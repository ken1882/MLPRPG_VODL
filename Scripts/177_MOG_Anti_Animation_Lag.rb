#==============================================================================
# +++ MOG - Anti Animation Lag (v1.1) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Este script remove as travadas (Lag) relacionadas ao dispose de uma animação.
#==============================================================================

#==============================================================================
# Durante a execução do jogo o Rpg Maker VX ACE leva um tempo considerável para
# ler ou apagar (Dispose) um arquivo. (Imagem, som ou video)
# O que acaba acarretando pequenas travadas durante o jogo, efeito perceptível 
# ao usar arquivos relativamente pesados. (Arquivos de animações.)
#==============================================================================
# NOTA - Este script não elimina as travadas relacionadas ao tempo de leitura
# de uma animação, apenas ao tempo relacionado para apagar uma animação.
#==============================================================================
  
$imported = {} if $imported.nil?
$imported[:mog_anti_animation_lag] = true

#===============================================================================
# ■ Game_Temp
#===============================================================================
class Game_Temp
  attr_accessor :animation_garbage
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias mog_anti_lag_animation_initialize initialize
  def initialize
      @animation_garbage = []
      mog_anti_lag_animation_initialize
  end  
  
end

#===============================================================================
# ■ Game System
#===============================================================================
class Game_System
  
  attr_accessor :anti_lag_animation
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  alias mog_antilag_animation_initialize initialize
  def initialize
      @anti_lag_animation = true
      mog_antilag_animation_initialize
  end  
  
end  

#===============================================================================
# ■ SceneManager
#===============================================================================
class << SceneManager
  
  #--------------------------------------------------------------------------
  # ● Call
  #--------------------------------------------------------------------------  
  alias mog_anti_lag_animation_call call
  def call(scene_class)
      mog_anti_lag_animation_call(scene_class)
      dispose_animation_garbage 
  end  
  
  #--------------------------------------------------------------------------
  # ● Goto
  #--------------------------------------------------------------------------    
  alias mog_anti_lag_animation_goto goto
  def goto(scene_class)
      mog_anti_lag_animation_goto(scene_class)
      dispose_animation_garbage 
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Animation Garbage
  #--------------------------------------------------------------------------  
  def dispose_animation_garbage
      return if $game_temp.animation_garbage == nil
      for animation in $game_temp.animation_garbage
          animation.dispose 
      end  
      $game_temp.animation_garbage = nil
  end  

end

#==============================================================================
# ■ Game Map
#==============================================================================
class Game_Map
  
  #--------------------------------------------------------------------------
  # ● Setup
  #--------------------------------------------------------------------------    
  alias mog_anti_lag_animation_setup setup
  def setup(map_id)
      SceneManager.dispose_animation_garbage
      mog_anti_lag_animation_setup(map_id)
  end

end

#==============================================================================
# ■ Scene Base
#==============================================================================
class Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Terminate
  #--------------------------------------------------------------------------      
  alias mog_anti_lag_animation_terminate terminate
  def terminate
      mog_anti_lag_animation_terminate
      SceneManager.dispose_animation_garbage
  end
  
end

#==============================================================================
# ■ Sprite Base 
#==============================================================================
class Sprite_Base < Sprite  

  #--------------------------------------------------------------------------
  # ● Dispose Animation
  #--------------------------------------------------------------------------
  alias mog_anti_lag_animation_dispose_animation dispose_animation
  def dispose_animation
      if $game_system.anti_lag_animation  
         execute_animation_garbage  
         return
      end  
      mog_anti_lag_animation_dispose_animation
  end
    
  #--------------------------------------------------------------------------
  # ● Execute Animation Garbage
  #--------------------------------------------------------------------------  
  def execute_animation_garbage  
      $game_temp.animation_garbage = [] if $game_temp.animation_garbage == nil
      if @ani_bitmap1
         @@_reference_count[@ani_bitmap1] -= 1
        if @@_reference_count[@ani_bitmap1] == 0
            $game_temp.animation_garbage.push(@ani_bitmap1)
         end
      end
      if @ani_bitmap2
         @@_reference_count[@ani_bitmap2] -= 1
         if @@_reference_count[@ani_bitmap2] == 0
            $game_temp.animation_garbage.push(@ani_bitmap2)
        end
     end
     if @ani_sprites
        @ani_sprites.each {|sprite| sprite.dispose }
        @ani_sprites = nil ; @animation = nil
     end
     @ani_bitmap1 = nil ; @ani_bitmap2 = nil
  end    
  
end