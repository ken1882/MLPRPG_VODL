#==============================================================================
# +++ MOG - Pause (v1.0) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Permite pausar o jogo.
# O script é útil para verificar erros em sequências de animações rápidas.
#==============================================================================
module MOG_PAUSE
  
  #Ativar o sistema de pause na cena de batalha.
  PAUSE_SCENE_BATTLE = true

  #Ativar o sistema de pause na cena de mapa.
  PAUSE_SCENE_MAP = true

  #Definição do botão de pause
  PAUSE_BUTTON = Input::F8
  
  #Definição do som ao pausar o jogo.
  PAUSE_SE = "Decision2"
  
end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
  
  attr_accessor :pause
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------                
  alias mog_pause_initialize initialize
  def initialize
      @pause = false
      mog_pause_initialize
  end
  
end

#==============================================================================
# ■ Game Pause
#==============================================================================
module Game_Pause
  include MOG_PAUSE
  
  #--------------------------------------------------------------------------
  # ● Update Pause
  #--------------------------------------------------------------------------              
  def update_pause
      update_execute_pause
      update_pause_button      
  end
  
  #--------------------------------------------------------------------------
  # ● Update Pause Button
  #--------------------------------------------------------------------------                
  def update_pause_button
      check_pause if Input.trigger?(PAUSE_BUTTON)
  end     
  
  #--------------------------------------------------------------------------
  # ● Update Check Pause
  #--------------------------------------------------------------------------                  
  def check_pause
      Audio.se_play("Audio/SE/" + PAUSE_SE,100,100)       
      $game_temp.pause = $game_temp.pause == true ? false : true 
      if $game_temp.pause
        $game_map.screen.pictures[0].show("pause",0,0,0,100,100,255,0)
      else
        $game_map.screen.pictures[0].erase
      end
      
  end
       
  #--------------------------------------------------------------------------
  # ● Update Check Pause
  #--------------------------------------------------------------------------                  
  def update_execute_pause
      return if !$game_temp.pause
      loop do 
          break if !$game_temp.pause
          update_paused
          Input.update
          Graphics.update          
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Update Check Pause
  #--------------------------------------------------------------------------                   
  def update_paused
      update_pause_button
  end
  
end

#==============================================================================
# ■ Scene Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  include Game_Pause
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------            
  alias mog_pause_battle_update update_basic
  def update_basic
      mog_pause_battle_update
      update_pause if MOG_PAUSE::PAUSE_SCENE_BATTLE
  end
  
end

#==============================================================================
# ■ Scene Map
#==============================================================================
class Scene_Map < Scene_Base
  
  include Game_Pause
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------              
  alias mog_pause_map_update update
  def update
      mog_pause_map_update
      update_pause if MOG_PAUSE::PAUSE_SCENE_MAP
  end
  
end

#==============================================================================
# ■ Bonus Gauge Animation
#==============================================================================
class Bonus_Gauge_Animation  
      include Game_Pause     
end
   
#==============================================================================
# ■ Ougi Animation
#==============================================================================
class Ougi_Animation
      include Game_Pause
end
 
#==============================================================================
# ■ Battle Result
#==============================================================================
class Battle_Result
      include Game_Pause
end
    
$mog_rgss3_pause = true
