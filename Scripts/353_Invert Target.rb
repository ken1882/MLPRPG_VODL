#==============================================================================
#
# ▼ YSA Battle Add-On: Invert Targets
# -- Last Updated: 2012.02.19
# -- Level: Easy
# -- Requires Optional:
#  + Yanfly Engine Ace - Ace Battle Engine
#
#==============================================================================
$imported = {} if $imported.nil?
$imported["YSA-InvertTargets"] = true
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.19 - Add notetag <no invert>.
# 2012.01.03 - Fix a critical bug after an inverted skill.
# 2012.01.03 - Started Script and Finished.
#
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
#
# -----------------------------------------------------------------------------
# Skill and Item Notetags
# -----------------------------------------------------------------------------
# <no invert>
# Make the item cannot be inverted.
#
# <invertable>
# Make the skill can be inverted.
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
#
#==============================================================================
module YSA
  module INVERT_TARGETS

    # Select key which will invert the targets selection.
    INVERT_KEY = :X

  end
end
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================
module YSA
  module REGEXP
  module USABLEITEM

    NO_INVERT = /<(?:NO_INVERT|no invert)>/i
    INVERTABLE = /<(?:INVERTABLE|invertable)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YSA
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager

  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_invt load_database; end
  def self.load_database
    load_database_invt
    load_notetags_invt
  end

  #--------------------------------------------------------------------------
  # new method: load_notetags_invt
  #--------------------------------------------------------------------------
  def self.load_notetags_invt
    groups = [$data_skills, $data_items]
    for group in groups
	  for obj in group
	    next if obj.nil?
	    obj.load_notetags_invt
	  end
    end
  end

end # DataManager
#==============================================================================
# ■ RPG::UsableItem
#==============================================================================
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :no_invert
  attr_accessor :invertable
  #--------------------------------------------------------------------------
  # common cache: load_notetags_invt
  #--------------------------------------------------------------------------
  def load_notetags_invt
    @no_invert = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
	  case line
	  #---
	  when YSA::REGEXP::USABLEITEM::NO_INVERT
	    @no_invert = true
    when YSA::REGEXP::USABLEITEM::INVERTABLE
      @no_invert = false
      @invertable = true
	  #---
	  end
    } # self.note.split
    #---
  end

end # RPG::UsableItem
#==============================================================================
# ■ Game_Action
#==============================================================================
class Game_Action
  #--------------------------------------------------------------------------
  # alias method: friends_unit
  #--------------------------------------------------------------------------
  alias invert_target_friends_unit friends_unit
  def friends_unit
    subject.invert_target? ? subject.opponents_unit : invert_target_friends_unit
  end
  #--------------------------------------------------------------------------
  # alias method: opponents_unit
  #--------------------------------------------------------------------------
  alias invert_target_opponents_unit opponents_unit
  def opponents_unit
    subject.invert_target? ? subject.friends_unit : invert_target_opponents_unit
  end

  #--------------------------------------------------------------------------
  # alias method: set_skill
  #--------------------------------------------------------------------------
  alias invert_target_set_skill set_skill
  def set_skill(skill_id)
    invert_target_set_skill(skill_id)
    subject.invert_target = false
  end

  #--------------------------------------------------------------------------
  # alias method: set_item
  #--------------------------------------------------------------------------
  alias invert_target_set_item set_item
  def set_item(skill_id)
    invert_target_set_item(skill_id)
    subject.invert_target = false
  end

end # Game_Action
#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase

  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :invert_target
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias invert_target_initialize initialize
  def initialize
    invert_target_initialize
    @invert_target = false
  end

  #--------------------------------------------------------------------------
  # new method: invert_target?
  #--------------------------------------------------------------------------
  def invert_target?
    @invert_target
  end

end # Game_Battler
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base

  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_battle_update_basic_invtrg update_basic
  def update_basic
    scene_battle_update_basic_invtrg
    update_input_invert_target
  end

  #--------------------------------------------------------------------------
  # new method: update_input_invert_target
  #--------------------------------------------------------------------------
  def update_input_invert_target

    return unless BattleManager.actor
    return unless @actor_window.active || @enemy_window.active

    if Input.trigger?(YSA::INVERT_TARGETS::INVERT_KEY)
	  return if BattleManager.actor.input.item.no_invert
    
    if @actor_command_window.current_symbol == :skill
      return unless BattleManager.actor.input.item.invertable
    end
    

	  BattleManager.actor.invert_target = !BattleManager.actor.invert_target
	  if @actor_window.active
	    @show_comparison_windows
	    @actor_window.unselect
	    @actor_window.hide.deactivate
	    case @actor_command_window.current_symbol
	    when :skill
		  @skill_window.show
	    when :item
		  @item_window.show
	    end
	    select_enemy_selection
	  elsif @enemy_window.active
	    @hide_comparison_windows
	    @enemy_window.hide.deactivate
	    case @actor_command_window.current_symbol
	    when :skill
		  @skill_window.hide
	    when :item
		  @item_window.hide
	    end
	    if $imported["YEA-BattleEngine"]
		  #scene_battle_select_actor_selection_abe
      select_actor_selection
	    else
		  select_actor_selection
	    end	   
	  end

    end
  end

  #--------------------------------------------------------------------------
  # alias method: on_actor_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_actor_cancel_invtrg on_actor_cancel
  def on_actor_cancel
    scene_battle_on_actor_cancel_invtrg
    BattleManager.actor.invert_target = false
  end

  #--------------------------------------------------------------------------
  # alias method: on_enemy_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_cancel_invtrg on_enemy_cancel
  def on_enemy_cancel
    scene_battle_on_enemy_cancel_invtrg
    BattleManager.actor.invert_target = false
  end

  #--------------------------------------------------------------------------
  # alias method: turn_end
  #--------------------------------------------------------------------------
  alias scene_battle_turn_end_invtrg turn_end
  def turn_end
    scene_battle_turn_end_invtrg
    for actor in $game_party.members
	  actor.invert_target = false
    end
  end

end # Scene_Battle
#==============================================================================
#
# ▼ End of File
#
#==============================================================================