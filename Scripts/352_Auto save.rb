#===============================================================================
#
# DT's Autosave
# Author: DoctorTodd
# Date (06/22/2012)
# Version: (1.0.0) (VXA)
# Level: (Simple)
# Email: Todd@beacongames.com
#
#===============================================================================
#
# NOTES: 1)This script will only work with ace.
#
#===============================================================================
#
# Description: Saves the game when transferring the map, before battle,
# and opening the menu (all optional).
#
# Credits: Me (DoctorTodd)
#
#===============================================================================
#
# Instructions
# Paste above main.
# Call using Autosave.call
#
#===============================================================================
#
# Free for any use as long as I'm credited.
#
#===============================================================================
#
# Editing begins 37 and ends on 50.
#
#===============================================================================
module ToddAutoSaveAce
	  #Max files (without autosave).
	  MAXFILES = 54
	  #Autosave file name.
	  AUTOSAVEFILENAME = "Autosave"
	  #Autosave before battle?
	  AUTOSAVEBB =  true #$game_switches[7]
	  #Autosave when menu opened?
	  AUTOSAVEM =  false
	  #Autosave when changing map?
	  AUTOSAVETM =  true #$game_switches[8]
    
    #Autosave when walks?
    STEP = true
    STEP_NUM_VAR = 16
    #STEP_NUM = 50
  
end
#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================
module SceneManager
  #--------------------------------------------------------------------------
  # * Dispose light effect before save
  #--------------------------------------------------------------------------
  def self.dispose_kale
    if @scene.is_a?(Scene_Map)
      @scene.spriteset.dispose_lights
    else
      @stack.reverse.each do |s|
        if s.is_a?(Scene_Map)
          s.spriteset.dispose_lights
          return
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Rstore light effect
  #--------------------------------------------------------------------------
  def self.restore_kale
    
    if @scene.is_a?(Scene_Map)
      @scene.spriteset.setup_lights
    else
      @stack.reverse.each do |s|
        if s.is_a?(Scene_Map)
          s.spriteset.setup_lights
          return
        end
      end # stack
    end # if @scene.is_a?(Map)
  end # def
  #--------------------------------------------------------------------------
  # * Call quicksave
  #--------------------------------------------------------------------------
  def self.call_quicksave
  	#self.call(Scene_Wait)
  end
end
#==============================================================================
# ** Autosave
#------------------------------------------------------------------------------
# This module contains the autosave method. This is allows you to use the
# "Autosave.call" command.
#==============================================================================
module Autosave
  #--------------------------------------------------------------------------
  # * Call method
  #--------------------------------------------------------------------------
  def self.call
    SceneManager.dispose_kale
    DataManager.save_game_without_rescue($last_autosave_loc + 50)
    SceneManager.restore_kale
    #puts "Calc move speed bonus"
    $game_player.calc_move_speed_bonus
    
    $last_autosave_loc = ($last_autosave_loc + 1)% 3
  end
  
  def self.can_save?
    return $game_switches[4] && !$game_system.save_disabled
  end
end
#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the
# global variables used by the game are initialized by this module.
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # * Maximum Number of Save Files
  #--------------------------------------------------------------------------
  def self.savefile_max
    return ToddAutoSaveAce::MAXFILES + 1
  end  
  
end
#============================================
#**Autosave when walk
#-----------------------------------------------------------------
#   Game_party Rewrite increase_steps function
#============================================
class Game_Party
  
  def increase_steps
    
    @steps += 1
    
    for battler in $game_party.members
      if battler.death_state?
        battler.remove_state(1)
      end
    end
    if ToddAutoSaveAce::STEP 
      return if $game_variables[ToddAutoSaveAce::STEP_NUM_VAR] == 0
      
      if @steps % ($game_variables[ToddAutoSaveAce::STEP_NUM_VAR] * 8)  == 0
        Autosave.call if Autosave.can_save?
      end
    end
    
  end
  
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Preprocessing for Battle Screen Transition
  #--------------------------------------------------------------------------
  def pre_battle_scene
    Sound.play_battle_start
    Autosave.call if $game_switches[7] && Autosave.can_save?
    
    Graphics.update
    Graphics.freeze
    @spriteset.dispose_characters
    BattleManager.save_bgm_and_bgs
    BattleManager.play_battle_bgm
    
  end
  
  #--------------------------------------------------------------------------
  # * Post Processing for Transferring Player
  #--------------------------------------------------------------------------
  def post_transfer
    case $game_temp.fade_type
    when 0
      Graphics.wait(fadein_speed / 2)
      fadein(fadein_speed)
    when 1
      Graphics.wait(fadein_speed / 2)
      white_fadein(fadein_speed)
    end
    @map_name_window.open
    Autosave.call if $game_switches[8] && Autosave.can_save?
  end
end
