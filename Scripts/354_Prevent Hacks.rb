#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: update_scene
  #--------------------------------------------------------------------------
  alias scene_map_update_scene_hack update_scene
  
  def update_scene
    scene_map_update_scene_hack
    distract_data unless scene_changing?
  end
  
  #--------------------------------------------------------------------------
  # new method: distract data
  #--------------------------------------------------------------------------
  def distract_data
    
    $game_variables[PONY::TOTAL_BIT_VARIABLE_ID] = $game_variables[PONY::TOTAL_BIT_VARIABLE_ID].to_i
    $game_variables[PONY::TOTAL_XP_VARIABLE_ID]  = $game_variables[PONY::TOTAL_XP_VARIABLE_ID].to_i

    distract_value = rand / 2
    $game_variables[PONY::TOTAL_BIT_VARIABLE_ID] += distract_value
    $game_variables[PONY::TOTAL_XP_VARIABLE_ID]  += distract_value
    
  end
  
end # Scene_Map



#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # alias method: start
  #--------------------------------------------------------------------------
  alias start_prehacks start
  def start
    check_hacks
    start_prehacks
  end
  
  def check_hacks
    
    value = $game_variables[PONY::TOTAL_BIT_VARIABLE_ID]
    value = [1000,[value,$game_party.max_gold].min].max
    
    if $game_party.gold > (value * 1.05).to_i
      str = "Assertion failed:\n" + "Party gold overflowed:#{$game_party.gold}"
      Audio.se_play("Audio/SE/Buzzer1",100,100)
      msgbox(str)
      SceneManager.exit
    end
    
    for battler in $game_party.members
      vaule = [$game_variables[PONY::TOTAL_XP_VARIABLE_ID],15480000].min
      vaule = [vaule,500].max
      if battler.exp > vaule
        str = "Assertion failed:\n" + "Actor[#{battler.name}]'s exp overflowed"
        Audio.se_play("Audio/SE/Buzzer1",100,100)
        msgbox(str)
        SceneManager.exit
        return
      end
    end
  end
  
end # Scene_Menus

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles parties. Information such as gold and items is included.
# Instances of this class are referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  
  def init_restrict_value
    $game_variables[PONY::TOTAL_BIT_VARIABLE_ID] = ($game_party.gold * 1.01).to_i
    
    max_xp = 0
    for battler in members
      max_xp = [max_xp, battler.exp].max
    end
    $game_variables[PONY::TOTAL_XP_VARIABLE_ID] = (max_xp * 1.01).to_i
  end
  
end
