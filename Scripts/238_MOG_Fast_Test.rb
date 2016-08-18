#==============================================================================
# +++ MOG - Fast Test (V1.1) +++ 
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Permite testar o seu projeto com o dobro de velocidadde.
#==============================================================================
# Aperte a Tecla F5 (Default) para ativar ou desativar o  modo turbo.
# Aperte a Tecla F6 (Default) para ativar ou desativar o  modo Slow Motion.
#==============================================================================
module MOG_FAST_TEST 
 #Definição da tecla que ativa o modo turbo(rápido) 
 FAST_MOTION_KEY = :F5
 #Definição da tecla que ativa o modo lento. 
 SLOW_MOTION_KEY = :F6
end

#==============================================================================
# ■ Scene_Base
#==============================================================================
class Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_fast_test_update update
  def update
      mog_fast_test_update
      update_fast_test
  end
  
  #--------------------------------------------------------------------------
  # ● Update Fast Test
  #--------------------------------------------------------------------------  
  def update_fast_test
      return if !$TEST
      if Input.trigger?(MOG_FAST_TEST::FAST_MOTION_KEY)
         Graphics.frame_rate = Graphics.frame_rate != 120 ? 120 : 60
      elsif Input.trigger?(MOG_FAST_TEST::SLOW_MOTION_KEY)   
         Graphics.frame_rate = Graphics.frame_rate != 30 ? 30 : 60
      end  
  end
  
end

$mog_rgss3_fast_test = true