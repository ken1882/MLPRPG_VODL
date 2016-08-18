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
    check_hacks unless scene_changing?
  end
  
  #--------------------------------------------------------------------------
  # new method: check_hacks
  #--------------------------------------------------------------------------
  def check_hacks
    
    if $previous_rand_value.nil?
      puts "previous no rand available"
      $game_variables[PONY::TOTAL_BIT_VARIABLE_ID] = $game_variables[PONY::TOTAL_BIT_VARIABLE_ID].to_i
      $game_variables[PONY::TOTAL_XP_VARIABLE_ID]  = $game_variables[PONY::TOTAL_XP_VARIABLE_ID].to_i
    else
      $game_variables[PONY::TOTAL_BIT_VARIABLE_ID] -= $previous_rand_value
      $game_variables[PONY::TOTAL_XP_VARIABLE_ID]  -= $previous_rand_value
    end
    
    $previous_rand_value = rand
    $game_variables[PONY::TOTAL_BIT_VARIABLE_ID] += $previous_rand_value
    $game_variables[PONY::TOTAL_XP_VARIABLE_ID]  += $previous_rand_value
    
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
  
end # Scene_Map