#===============================================================================
# State Effect : End Turn/Action Skill v1.3
#   by Shad3Light
#
# 2014/03/11
# Link: http://shad3light.blogspot.com/2014/02/state-effect-use-skill-on-turnaction-end.html
#===============================================================================
 
=begin
================================================================================
Description
 
This script makes it possible to have states that force the those inflicted
to use a specific skill at the end of the turn, or the end of an action.
Useful if you want a state that auto-buff every turn end, or a custom
poison damage formula.
 
--------------------------------------------------------------------------------
History
 
v1.3 (2015/05/21)
  New     Added an option for chance to proc
 
v1.2 (2014/03/11)
  Bugfix  End Action Skill error when battler cannot act
  Extra   BattleManager.action_forced? now returns true when executing
          end skills
  Extra   Made a separate method for swapping subject battlers in
          Scene_Battle (swap_subject)
 
v1.1 (2014/03/07)
  Update  Now supports all feature item
          (actors, classess, equips, enemies, states)
 
v1.0 (2014/02/28)
  Initial Release
         
 
--------------------------------------------------------------------------------
Terms of Use
 
- You are free to use this script for non-commercial projects.
- For commercial projects, at least contact me first.
- This script is provided as-is. Don't expect me to give support.
- Reported bug will be fixed, but no guarantee on requested features.
- No guarantee either for compatibility fixes.
- Give credit to Shad3Light (me), and do not delete this header.
--------------------------------------------------------------------------------
Installation
 
Put this script below Бе Materials and above Бе Main Process.
If there are scripts that overwrite the aliased methods below,
put this script below said script.
--------------------------------------------------------------------------------
Usage
 
Tag a actor/class/enemy/weapon/armor/state with any of the specified notetags:
 
<end turn skill: skill_id>
<end action skill: skill_id>
where skill_id is the skill that will be used when inflicted with the state.
 
Example: <end turn skill: 10>
  This will make a battler use skill no. 10 (Shock) at the end of turn,
  as long as the skill can be used.
 
The skill will be used only when normal conditions are met.
If you want to force the battler to always use the skill, add "forced"
behind the skill id.
 
Example: <end turn skill: 94, forced>
  This will make the battler use Zero Storm on turn end,
  even when stunned and not equipping the correct weapon.
 
You can also add an option for the skill to have a percentage chance
to be used.
 
Example: <end turn skill: 24, chance: 50>
  The battler will have a 50% chance to use meditate.
 
You can use all options at the same time. Separate the options with at
least a comma.
 
Example: <end turn skill: 66, forced, chance: 33>
         <end turn skill: 13, chance: 90, forced>
================================================================================
=end
 
if $imported && $imported[:SHD_EndTurnSkill]
  msgbox "Warning: The End Turn/Action Skill script is imported twice."
else
 
$imported = {} if $imported.nil?
$imported[:SHD_EndTurnSkill] = true
 
module SHD
#===============================================================================
# Configuration Module
#
# None.
#
# Configuration Module End
#===============================================================================
 
#===============================================================================
# Code Start
#   Configuration ends here. Edit what's below at your own risk.
#-------------------------------------------------------------------------------
# Aliased methods:
#   DataManager
#     self.load_database
#   BattleManager
#     self.action_forced?
#   Game_Battler
#     on_action_end
#   Scene_Battle
#     turn_end
#
# New methods:
#   DataManager
#     self.endskill_load_notetags
#   BattleManager
#     self.set_end_skill_flag
#     self.clear_end_skill_flag
#   RPG::BaseItem
#     end_turn_skill (attr_reader)
#     end_turn_skill_forced (attr_reader)
#     end_action_skill (attr_reader)
#     end_action_skill_forced (attr_reader)
#     load_notetags_endskill
#   Game_Battler
#     action_end_skill
#     turn_end_skill
#   Scene_Battle
#     execute_end_skill
#     swap_subject
#===============================================================================
 
  module REGEXP
    ENDTURNSKILL = /<end turn skill:[ ]*(\d+)([^>]*)>/i
    ENDACTIONSKILL = /<end action skill:[ ]*(\d+)([^>]*)>/i
  end
end
 
module DataManager
  class <<self; alias :shd_endskill_load_database :load_database; end
  def self.load_database
    shd_endskill_load_database
    endskill_load_notetags
  end
   
  def self.endskill_load_notetags
    for o in $data_actors+$data_classes+$data_weapons+$data_armors+$data_enemies+$data_states
      next if o.nil?
      o.load_notetags_endskill
    end
    #puts "Read: End Turn Skill notetags."
  end
end
 
module BattleManager
   
  class <<self
    alias :end_skill_act_forced :action_forced?
  end
   
  def self.action_forced?
    end_skill_act_forced || @end_skill_flag
  end
   
  def self.set_end_skill_flag
    @end_skill_flag = true
  end
   
  def self.clear_end_skill_flag
    @end_skill_flag = nil
  end
   
end
 
class RPG::BaseItem
   
  attr_reader :end_turn_skill
  attr_reader :end_turn_skill_forced
  attr_reader :end_turn_skill_chance
  attr_reader :end_action_skill
  attr_reader :end_action_skill_forced
  attr_reader :end_action_skill_chance
   
  def load_notetags_endskill
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when SHD::REGEXP::ENDTURNSKILL
        @end_turn_skill = $1.to_i
        @end_turn_skill_forced = false
        @end_turn_skill_chance = 100
        if $2
          $2.delete(" ").scan(/[^,]+/).each { |opt_line|
            if opt_line.upcase == "FORCED"
              @end_turn_skill_forced = true
              next
            end
            if /chance:(\d+)/i.match(opt_line)
              @end_turn_skill_chance = $1.to_i
              next
            end
          }
        end
      when SHD::REGEXP::ENDACTIONSKILL
        @end_action_skill = $1.to_i
        @end_action_skill_forced = false
        @end_action_skill_chance = 100
        if $2
          $2.delete(" ").scan(/[^,]+/).each { |opt_line|
            if opt_line.upcase == "FORCED"
              @end_action_skill_forced = true
              next
            end
            if /chance:(\d+)/i.match(opt_line)
              @end_action_skill_chance = $1.to_i
              next
            end
          }
        end
      end
    }
  end
end
 
class Game_Battler < Game_BattlerBase
  
  
  
  def dead_skill
    BattleManager.set_end_skill_flag
    
    for skill in @force_perform_skills
      action = Game_Action.new(self)
      action.set_skill(skill)
      
      @actions.unshift(action)
      SceneManager.scene.execute_action
      @actions.shift
    end
    
    @force_perform_skills = []
    BattleManager.clear_end_skill_flag
  end
  
  
  def turn_end_skill
    return if dead? || $game_party.all_dead? || $game_troop.all_dead? #|| !movable?
    BattleManager.set_end_skill_flag
    
    feature_objects.each do |obj|
      if obj.end_turn_skill
        next if rand(100) >= obj.end_turn_skill_chance
        
        action = Game_Action.new(self)
        action.set_skill(obj.end_turn_skill)
        if obj.end_turn_skill_forced || usable?(action.item)
          @actions.unshift(action)
          SceneManager.scene.execute_action
          @actions.shift
        end
      end
    end

    BattleManager.clear_end_skill_flag
  end
   
  def action_end_skill
    return if dead? || $game_party.all_dead? || $game_troop.all_dead?
    BattleManager.set_end_skill_flag
    feature_objects.each do |obj|
      if obj.end_action_skill
        next if rand(100) >= obj.end_action_skill_chance
        action = Game_Action.new(self)
        action.set_skill(obj.end_action_skill)
        if obj.end_action_skill_forced || usable?(action.item)
          @actions.unshift(action)
          SceneManager.scene.execute_action
          @actions.shift
        end
      end
    end
    BattleManager.clear_end_skill_flag
  end
   
  alias :shd_endskill_act_end :on_action_end
  def on_action_end
    battler = SceneManager.scene.swap_subject(self)
    action_end_skill
    SceneManager.scene.swap_subject(battler)
    shd_endskill_act_end
  end
end
 
class Scene_Battle < Scene_Base
   
  #alias :shd_endskill_turn_end :turn_end
  def system_turn_end
    p sprintf("[End turn skill]:Turn end")
    execute_end_skill
    
    for battler in $game_party.members
       battler.make_atb_discrete
    end
    
    for battler in $game_troop.members
       battler.make_atb_discrete
    end
    
    #shd_endskill_turn_end
  end
   
  def execute_end_skill
    all_battle_members.sort{ |a, b| b.agi <=> a.agi }.each do |battler|
      last_battler = swap_subject(battler)
      battler.turn_end_skill
      swap_subject(last_battler)
    end
    
    for battler in BattleManager.battlers
      battler.update
    end
    BattleManager.judge_win_loss
  end
   
  def swap_subject(battler)
    last_subject = @subject
    @subject = battler
    last_subject
  end
  
  def execute_dead_skill
    all_battle_members.sort{ |a, b| b.agi <=> a.agi }.each do |battler|
      last_battler = swap_subject(battler)
      battler.dead_skill
      swap_subject(last_battler)
    end
    
    for battler in BattleManager.battlers
      battler.update
    end
    BattleManager.judge_win_loss
  
  end
  
end
 
end # if $imported