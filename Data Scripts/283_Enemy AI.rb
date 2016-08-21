=begin
#===============================================================================
 Title: Enemy Action Conditions
 Author: Hime
 Date: Feb 23, 2014
 URL: http://www.himeworks.com/2014/02/23/enemy-action-conditions/
--------------------------------------------------------------------------------
 ** Change log
 Feb 23, 2014
   - Initial release
--------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in non-commercial projects
 * Contact me for commercial use
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Credits to Hime Works in your project
 * Preserve this header
--------------------------------------------------------------------------------
 ** Description
 
 This script allows you to define custom action conditions on top of the
 conditions that are provided by the database.
 
 You can use a formula to determine whether an action is usable or not,
 enabling you to add any condition that you can imagine for an action.

--------------------------------------------------------------------------------
 ** Installation
 
 In the script editor, place this script below Materials and above Main

--------------------------------------------------------------------------------
 ** Usage 
 
 When setting up the enemy in the database, you can set up the actions that the
 enemy can use. Each action has an ID: the first action on the list is ID 1,
 the second action on the list is ID 2.
 
 To add an action condition to a particular action, use the note-tag
 
   <action condition: ID>
     FORMULA
   </action condition>
   
 Where the ID is the action ID, and the FORMULA is any valid formula that
 returns true or false. All conditions must be met in order for the action to
 be usable.
 
 The following formula variables are available:
 
   a - the enemy
   p - game party
   t - game troop
   s - game switches
   v - game variables
 
#===============================================================================
=end
$imported = {} if $imported.nil?
$imported[:TH_EnemyActionConditions] = true
#===============================================================================
# ** Configuration
#===============================================================================
module TH
  module Enemy_Action_Conditions
    
    Ext_Regex = /<action[-_ ]condition:\s*(\d+)\s*>(.*?)<\/action[-_ ]condition>/im
  end
end
#===============================================================================
# ** Rest of script
# tag: AI
#===============================================================================
module RPG
  class Enemy
    
    alias :th_enemy_action_conditions_actions :actions
    def actions
      load_notetag_enemy_action_conditions unless @enemy_action_conditions_parsed
      th_enemy_action_conditions_actions
    end
    
    def load_notetag_enemy_action_conditions
      @enemy_action_conditions_parsed = true
      enemyActions = th_enemy_action_conditions_actions
      
      results = self.note.scan(TH::Enemy_Action_Conditions::Ext_Regex)
      results.each do |res|
        action_id = res[0].to_i - 1
        formula = res[1]
        
        act = enemyActions[action_id]
        act.formula_conditions ||= []
        act.formula_conditions << formula
      end
    end
  end
  
  class Enemy::Action
    
    attr_accessor :formula_conditions
    
    def formula_conditions_met?(user)
      return true if self.formula_conditions.nil? || self.formula_conditions.empty?
      
      cur_item = $data_skills[self.skill_id]
      
      return self.formula_conditions.all? do |formula|
        eval_formula_condition(formula, user)
      end
    end
    
    def eval_formula_condition(formula, a, p=$game_party, t=$game_troop, s=$game_switches, v=$game_variables)
      eval(formula)
    end
    
    #----------------------------------------------------------------
    #   Check if using healing skill
    #----------------------------------------------------------------
    def using_heal_skill?(user)
      
      cur_item = $data_skills[self.skill_id]
      
      for battler in $game_troop.alive_members
        if battler.hp <= battler.mhp * 0.6
          $game_troop.item_target = battler unless cur_item.for_all?
          puts "Enemy using heal skill"
          return true
        end
      end
      return false
    end
    #----------------------------------------------------------------
    #   Check which item enemy should use
    #----------------------------------------------------------------
    def check_enemy_item_using(user)
      return false if user.state?(271)
      return false unless $game_troop.available_items.size > 0
      
      $game_troop.item_require = 0
      item_contained = []
      
      for item in $game_troop.available_items
        next if item[0] == 0
        if item[1] == 0
          $game_troop.available_items.delete(item)
          next
        end
        item_contained.push(item[0]) # item id
      end
      
      for battler in $game_troop.alive_members
        next if battler.state?(271) || battler.state?(99)
        #--------------------------------------
        #   *) remove ally's debuff
        #--------------------------------------
        if battler.debuffed?
          $game_troop.item_require = 7
          $game_troop.item_target = battler
        #--------------------------------------
        #   *) remove ally's debuff - frozen
        #--------------------------------------
        elsif battler.state?(53)
          $game_troop.item_require = 43
          $game_troop.item_target = battler
        #--------------------------------------
        #   *) recover HP/MP
        #--------------------------------------
        elsif battler.movable?
          
          potion_id = 0
          
          if battler.hp < battler.mhp * 0.4 && item_contained.include?(26)
            potion_id = 26
          elsif battler.hp < battler.mhp * 0.6 && item_contained.include?(25)
            potion_id = 25
          elsif battler.mmp >= 1500 && battler.mp < 250
            potion_id = 12
          elsif battler.mmp >= 800 && battler.mp < 200
            potion_id = 11
          elsif battler.mmp >= 400 && battler.mp < 100
            potion_id = 10
          elsif battler.mmp >= 200 && battler.mp < 50
            potion_id = 9
          end
          
          $game_troop.item_require = potion_id
          $game_troop.item_target = battler if potion_id > 0
        #--------------------------------------
        #   *) 
        #--------------------------------------
        
        end
      #--------------------------------------------
      break if $game_troop.item_require > 0
      end # end for battler in $game_troop....
      #---------------------------------
      # Reduce number of item
      if $game_troop.item_require != 0
        for item in $game_troop.available_items
          if item[0] == $game_troop.item_require
            $game_troop.available_items[item[0]] -= 1
            $game_troop.available_items.delete(item) if item[1] == 1
          end
        end
        
      end
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      return $game_troop.item_require != 0
    end
    
  end
end

class Game_Enemy < Game_Battler
  
  alias :th_enemy_action_conditions_conditions_met? :conditions_met?
  def conditions_met?(action)
    cur_item = $data_skills[action.skill_id]
    #------------------------------------------------------------
    #   Check if using magic attack
    #------------------------------------------------------------
    if (cur_item.magical? || cur_item.is_spell?) && cur_item.for_opponent?
      return false if self.state?(288) || self.state?(90)
      return false if !self.using_magic_attack?
    end
    #------------------------------------------------------------
    #   Animated Dead
    #------------------------------------------------------------
    if self.state?(271)
      return false if cur_item.for_friend?
    end
    #-------------------------
    return false unless th_enemy_action_conditions_conditions_met?(action)
    return false unless action.formula_conditions_met?(self)  
    return true
  end
end