#==============================================================================
# 
# ▼ Yanfly Engine Ace - Button Common Events v1.00
# -- Last Updated: 2012.01.09
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ButtonCommonEvents"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.09 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# RPG Maker VX Ace supports 8 different action buttons to use. However, only
# 3 of those are used (A, B, and C) on the field map. The rest of them aren't
# used at all. This script allows usage of the L, R, X, Y, and Z buttons by
# binding them to common events.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Modify the COMMON_EVENT hash in the script module to adjust which common
# events are used for each button.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module BUTTON_EVENT
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Button Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This sets the common events that are to run when the particular button
    # is pressed. The following chart shows the respective keyboard buttons.
    # 
    #   :Button    Default Keyboard Button
    #      :L        Q
    #      :R        W
    #      :X        A
    #      :Y        S
    #      :Z        D
    # 
    # If you do not wish to associate a button with a common event, set the
    # common event for that button to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    COMMON_EVENT ={
    # :Button => Common Event,
           :L =>   0,    # Quest
           :R =>   0,    # Does not run a common event.
           :Y => 0,
           :X=> 0,
           :Z => 0,
    } # Do not remove this.
    
    HOT_KEY ={
      :kI => "SceneManager.call(Scene_Item)",
      :kE => "SceneManager.call(Scene_Equip)",
      :kO => "SceneManager.call(Scene_System)",
      :kF => "$start_bfs = true",
      :kQ => "$game_temp.reserve_common_event(18)",
      :kS => "$game_temp.reserve_common_event(24)",
    }
  end # BUTTON_EVENT
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: update_scene
  #--------------------------------------------------------------------------
  alias scene_map_update_scene_bce update_scene
  def update_scene
    scene_map_update_scene_bce
    update_button_common_events unless scene_changing?
  end
  
  #--------------------------------------------------------------------------
  # new method: update_button_common_events
  #--------------------------------------------------------------------------
  def update_button_common_events
    
    #for key in YEA::BUTTON_EVENT::COMMON_EVENT
    #  next unless Input.trigger?(key[0])
    #  next if key[1] <= 0
    #  $game_temp.reserve_common_event(key[1])
    #end
    
    if Input.press?(:kTAB) && Input.press?(:kSPACE)
      $game_temp.reserve_common_event(23)
    elsif Input.press?(:kTAB) && Input.press?(:kP)
      puts "(#{$game_player.x},#{$game_player.y})"
    else
      for key in YEA::BUTTON_EVENT::HOT_KEY
        next unless Input.trigger?(key[0])
        next if key[1].size <= 3
        eval(key[1])
      end
    end
    
  end
  
end # Scene_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================