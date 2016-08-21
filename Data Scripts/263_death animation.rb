#==============================================================================
#  ▼  Fancy Death
# -- Last Updated: 2012.12.18
# -- Level: Nothing
# -- Requires: n/a
# -- Collaboration: Yami, Archeia_Nessiah
#==============================================================================

$imported = {} if $imported.nil?
$imported["YN-FancyDeath"] = true

#==============================================================================
#  ▼  Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.12.18 - Started and Finished Script.
# 
#==============================================================================
#  ▼  Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows you to use battle animations for enemy death.
# 
#==============================================================================
#  ▼  Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Add in the enemy's notebox:
# <animation collapse: id>
#
# To install this script, open up your script editor and copy/paste this script
# to an open slot below  ▼  Materials but above  ▼  Main. Remember to save.
#
#==============================================================================
#  ▼  Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
#==============================================================================

#==============================================================================
#  ▼  Regular Expression
#==============================================================================

module REGEXP
  module ANIMATION_COLLAPSE
    ANIMATION_COLLAPSE = /<(?:ANIMATION_COLLAPSE|animation collapse):[ ]*(\d+)/i
  end # ANIMATION_COLLAPSE
end # REGEXP

#==============================================================================
#  ▼  DataManager
#==============================================================================

module DataManager
    
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_animation_collapse load_database; end
  def self.load_database
    load_database_animation_collapse
    initialize_animation_collapse
  end
  
  #--------------------------------------------------------------------------
  # new method: initialize_animation_collapse
  #--------------------------------------------------------------------------
  def self.initialize_animation_collapse
    groups = [$data_actors, $data_classes, $data_enemies]
    groups.each { |group|
      group.each { |obj|
        next if obj.nil?
        obj.initialize_animation_collapse
      }
    }
  end
  
end # DataManager

#==============================================================================
#  ▼  RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :animation_collapse

  #--------------------------------------------------------------------------
  # new method: initialize_animation_collapse
  #--------------------------------------------------------------------------
  def initialize_animation_collapse
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when REGEXP::ANIMATION_COLLAPSE::ANIMATION_COLLAPSE
        @animation_collapse = $1.to_i
      end
    }
  end
  
end # RPG::BaseItem

#==============================================================================
#  ▼  Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: perform_collapse_effect
  #--------------------------------------------------------------------------
  alias animation_collapse_perform_collapse_effect perform_collapse_effect
  def perform_collapse_effect
    animation_collapse_perform_collapse_effect
    #---
    if $game_party.in_battle
      collapse_id = [actor.animation_collapse, self.class.animation_collapse].compact[0]
      @animation_id = collapse_id unless collapse_id.nil?
      SceneManager.scene.wait_for_animation
    end
  end
  
 
end # Game_Actor

#==============================================================================
#  ▼  Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: perform_collapse_effect
  #--------------------------------------------------------------------------
  alias animation_collapse_perform_collapse_effect perform_collapse_effect
  def perform_collapse_effect
    animation_collapse_perform_collapse_effect
    #---
    collapse_id = enemy.animation_collapse
    @animation_id = collapse_id unless collapse_id.nil?
    SceneManager.scene.wait_for_animation
  end

end # Game_Enemy