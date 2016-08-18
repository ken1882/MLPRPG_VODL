#==============================================================================
# +++ MOG - Parallax EX (v1.2) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Adiciona alguns efeitos nos panoramas.
# - Transição suave entre os panoramas.
# - Efeito Wave. (Útil para criar cenários de desertos.)
# - Efeito Fade em loop.
# - Efeito Zoom em loop.
# - Efeito Fixed Position. (Para criar cenários de panoramas.)
#
#==============================================================================

#==============================================================================
# ● Auto Mode
#==============================================================================
# Para ativar os efeitos basta colocar os seguintes comentários na caixa de
# notas do mapa.
#
# <Parallax Wave>
#
# <Parallax Fade>
#
# <Parallax Zoom>
#
# <Parallax Fixed>
#
# O poder do efeito WAVE é baseado nos valores de Auto Scroll X e Y.
#
# X - Area de distorção no efeito WAVE. (de 0 a 9)
# Y - Velocidade de distorção do efeito WAVE. (de 0 a 9)
#
#==============================================================================
# ● Manual Mode
#==============================================================================
# Use o comando abaixo através do evento usando o comando chamar script.
#
# parallax_effect(EFFECT 1,EFFECT 2,EFFECT 3)
# 
# EFFECT 1
# 0 - Efeito Scroll
# 1 - Efeito Wave
# 2 - Efeito Zoom
#
# EFFECT 2
#
# true or false para ativar os efeitos.
#
#==============================================================================
# Se caso deseja desativar a transição suave use o código abaixo.
#
# parallax_transition(false) 
#
#==============================================================================

#==============================================================================
# ● NOTA
#==============================================================================
# O Efeito WAVE e ZOOM cancelam o efeito SCROLLING (Default Effect)
# O Efeito FIXED não funciona junto com os outros efeitos.
#==============================================================================

module MOG_PARALLAX_EX
    #Definição da resolução do projeto.
    SCREEN_RESOLUTION = [544,416]
    #Poder do efeito Zoom. de (0.1 a 0.0001)
    PARALLAX_ZOOM_POWER = 0.005
end  

#==============================================================================
# ■ Game System
#==============================================================================
class Game_System
  
  attr_accessor :parallax_change_values
  attr_accessor :parallax_ignore_transition
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  alias mog_parallax_effects_initialize initialize
  def initialize
      @parallax_change_values = []
      @parallax_ignore_transition = false
      mog_parallax_effects_initialize
  end  
  
  #--------------------------------------------------------------------------
  # ● Can Update Parallax_EX
  #--------------------------------------------------------------------------        
  def can_update_parallax_ex?
      if $schala_battle_system != nil
         return false if $game_temp.battle_phase[0]
      end   
      return true
  end  
  
end  

#==============================================================================
# ■ Game Intepreter
#==============================================================================
class Game_Interpreter
 
  #--------------------------------------------------------------------------
  # ● Parallax Transition
  #--------------------------------------------------------------------------     
  def parallax_transition(value = false)
      $game_system.parallax_ignore_transition = value
  end  
  
  #--------------------------------------------------------------------------
  # ● Effect
  #--------------------------------------------------------------------------       
  def parallax_effect(value = true,fade = false,zoom = false,fixed_p = false)
      value2 = value == true ? 1 : 0
      $game_map.parallax_effect = [value2,120,fade,0,zoom,0,fixed_p]
  end  
  
  #--------------------------------------------------------------------------
  # ● Command 284
  #--------------------------------------------------------------------------   
  alias mog_parallax_effects_command_284 command_284
  def command_284
      if $game_system.can_update_parallax_ex?
         if !$game_system.parallax_ignore_transition
             $game_system.parallax_change_values.clear
             $game_system.parallax_change_values[0] = @params[0]
             $game_system.parallax_change_values[1] = @params[1]
             $game_system.parallax_change_values[2] = @params[2]
             $game_system.parallax_change_values[3] = @params[3]
             $game_system.parallax_change_values[4] = @params[4]     
             $game_map.parallax_effect[1] = 120
             return 
         end
         $game_map.parallax_effect[1] = 0
      end
      mog_parallax_effects_command_284  
   end
 
end   

#==============================================================================
# ■ Game Map
#==============================================================================
class Game_Map
  attr_accessor :parallax_effect
  attr_accessor :parallax_sx 
  attr_accessor :parallax_sy
  attr_accessor :parallax_loop_x
  attr_accessor :parallax_loop_y
  attr_accessor :parallax_sprite
  
  #--------------------------------------------------------------------------
  # ● Setup Parallax
  #--------------------------------------------------------------------------     
  alias mog_parrallax_effects_setup_parallax setup_parallax
  def setup_parallax
      mog_parrallax_effects_setup_parallax
      setup_parallax_effects  
  end    

  #--------------------------------------------------------------------------
  # ● Setup Parallax Effects
  #--------------------------------------------------------------------------      
  def setup_parallax_effects
      return if @map == nil
      @parallax_effect = [0,0,false,0,false,0,false]
      @parallax_sprite = [0,0,255,1.00,0]
      if @map.note =~ /<Parallax Wave>/
         @parallax_effect[0] = 1
      end 
      if @map.note =~ /<Parallax Fade>/ 
         @parallax_effect[2] = true
      end
      if @map.note =~ /<Parallax Zoom>/ 
         @parallax_effect[4] = true
      end         
      if @map.note =~ /<Parallax Fixed>/ 
         @parallax_effect[6] = true
      end         
  end
  
end 
#==============================================================================
# ■ Spriteset Map
#==============================================================================
class Spriteset_Map
  include MOG_PARALLAX_EX
  
  #--------------------------------------------------------------------------
  # ● Create Parallax
  #--------------------------------------------------------------------------  
  def create_parallax
      refresh_parallax
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Parallax
  #--------------------------------------------------------------------------
  def dispose_parallax
      return if @parallax == nil
      @parallax.bitmap.dispose if @parallax.bitmap
      @parallax.dispose
      @parallax_image.dispose if @parallax_image != nil
  end
  
  #--------------------------------------------------------------------------
  # ● Update Parallax
  #--------------------------------------------------------------------------      
  alias mog_parallax_ex_update_parallax update_parallax
  def update_parallax
      if $game_system.can_update_parallax_ex?
         refresh_parallax if can_refresh_parallax?
         update_parallax_transition_effect
         update_parallax_effects
         return
      end
      mog_parallax_ex_update_parallax 
  end  
  
  #--------------------------------------------------------------------------
  # ● Can Refresh Parallax?
  #--------------------------------------------------------------------------        
  def can_refresh_parallax?
      return false if @parallax_name == $game_map.parallax_name
      return false if $game_map.parallax_effect[1] > 0
      return true
  end
    
  #--------------------------------------------------------------------------
  # ● Refresh Parallax
  #--------------------------------------------------------------------------          
  def refresh_parallax
      dispose_parallax     
      @parallax_name = $game_map.parallax_name
      @parallax_effect_type = $game_map.parallax_effect[0]
      @parallax_zoom_effect = $game_map.parallax_effect[4] 
      @parallax_zoom_speed = PARALLAX_ZOOM_POWER > 0.1 ? 0.1 : PARALLAX_ZOOM_POWER
      @parallax_fade_effect = $game_map.parallax_effect[2]
      @parallax_fixed_position = $game_map.parallax_effect[6] 
      @power_1 = $game_map.parallax_loop_x == true ? $game_map.parallax_sx : 0
      @power_2 = $game_map.parallax_loop_y == true ? $game_map.parallax_sy : 0
      @orig = [0,0]
      @range = 0
      if @parallax_effect_type == 0 
         if !($game_map.parallax_loop_x and $game_map.parallax_loop_y) and
              @parallax_zoom_effect
              create_parallax_type0
              mode_zoom_setup
         else
              create_parallax_type1 
         end  
      else  
         create_parallax_type2
         mode_zoom_setup
      end  
      @parallax.z = -100
      @parallax.opacity = $game_map.parallax_sprite[2]      
      Graphics.frame_reset
      @parallax_effect_type = 1 if $game_map.parallax_effect[4]
      update_parallax_effects
  end  
  
  #--------------------------------------------------------------------------
  # ● Mode Zoom Setup
  #--------------------------------------------------------------------------              
  def mode_zoom_setup
      return if !@parallax_zoom_effect
      @orig[0] = (@parallax.bitmap.width / 2) 
      @orig[1] = (@parallax.bitmap.height / 2)
      @parallax.ox = @orig[0] 
      @parallax.oy = @orig[1]       
      @parallax.x = @orig[0] -@range
      @parallax.y = @orig[1]
  end
      
  #--------------------------------------------------------------------------
  # ● Create Parallax Type 0
  #--------------------------------------------------------------------------            
  def create_parallax_type0
      @parallax = Sprite.new(@viewport1)
      @parallax_image = Cache.parallax(@parallax_name)
      @parallax.bitmap = Bitmap.new(SCREEN_RESOLUTION[0],SCREEN_RESOLUTION[1])
      @parallax.bitmap.stretch_blt(@parallax.bitmap.rect, @parallax_image, @parallax_image.rect)
  end  
  
  #--------------------------------------------------------------------------
  # ● Create Parallax Type 1
  #--------------------------------------------------------------------------            
  def create_parallax_type1
      @parallax = Plane.new(@viewport1)
      @parallax.bitmap = Cache.parallax(@parallax_name)        
  end

  #--------------------------------------------------------------------------
  # ● Create Parallax Type 2
  #--------------------------------------------------------------------------              
  def create_parallax_type2
      @parallax = Sprite.new(@viewport1)
      @parallax_image = Cache.parallax(@parallax_name)         
      @range = (@power_1 + 1) * 10
      @range = 500 if @range > 500
      speed = (@power_2 + 1) * 100
      speed = 1000 if speed > 1000
      @parallax.x = -@range
      @parallax.wave_amp = @range
      @parallax.wave_length = SCREEN_RESOLUTION[0]
      @parallax.wave_speed = speed
      sc_size = [SCREEN_RESOLUTION[0] + (@range * 2),SCREEN_RESOLUTION[1]]
      @parallax.bitmap = Bitmap.new(sc_size[0],sc_size[1])
      @parallax.bitmap.stretch_blt(@parallax.bitmap.rect, @parallax_image, @parallax_image.rect)
  end  
  
  #--------------------------------------------------------------------------
  # ● Update parallax Fade
  #--------------------------------------------------------------------------            
  def update_parallax_transition_effect      
      return if $game_map.parallax_effect[1] == 0
      if @parallax_name == ""
         refresh_parallax
         if @parallax != nil
            @parallax.opacity = 0
            $game_map.parallax_effect[1] = 61
         end   
      end   
      $game_map.parallax_effect[1] -= 1
      execute_fade_effect if @parallax != nil      
  end  
  
  #--------------------------------------------------------------------------
  # ● Execute Fade Effect
  #--------------------------------------------------------------------------              
  def execute_fade_effect
      case $game_map.parallax_effect[1]
          when 61..120
             $game_map.parallax_sprite[2] -= 5
          when 1..60    
             parallax_transition_setup if $game_map.parallax_effect[1] == 60
             $game_map.parallax_sprite[2] += 5
          else
             $game_map.parallax_sprite[2] = 255
      end
  end  
  
  #--------------------------------------------------------------------------
  # ● Parallax Transition Setup
  #--------------------------------------------------------------------------                
  def parallax_transition_setup
      if !$game_system.parallax_change_values.empty?
          cv = $game_system.parallax_change_values
          $game_map.change_parallax(cv[0],cv[1],cv[2],cv[3],cv[4])
      end
      refresh_parallax
      $game_map.parallax_sprite[2] = 0
      $game_map.parallax_effect[3] = 0
      $game_map.parallax_effect[5] = 0
      @parallax.zoom_x = 1.00
      @parallax.zoom_y = 1.00
      $game_map.parallax_sprite[3] = 1.00        
  end
                
  #--------------------------------------------------------------------------
  # ● Update Parallax Effects
  #--------------------------------------------------------------------------        
  def update_parallax_effects
      return if @parallax == nil
      update_parallax_fade_effect
      update_parallax_zoom_effect   
      @parallax.opacity = $game_map.parallax_sprite[2]
      if @parallax_effect_type == 0
         if @parallax_fixed_position
            @parallax.ox = $game_map.display_x * 32
            @parallax.oy = $game_map.display_y * 32
         else
            @parallax.ox = $game_map.parallax_ox(@parallax.bitmap)
            @parallax.oy = $game_map.parallax_oy(@parallax.bitmap)
         end
      else
         @parallax.update         
      end  
  end
    
  #--------------------------------------------------------------------------
  # ● Update Parallax Fade Effect
  #--------------------------------------------------------------------------          
  def update_parallax_fade_effect
      return if !@parallax_fade_effect 
      return if $game_map.parallax_effect[1] > 0
      $game_map.parallax_effect[3] += 1
      case $game_map.parallax_effect[3]
          when 0..60
              $game_map.parallax_sprite[2] = 255
          when 61..189
              $game_map.parallax_sprite[2] -= 2 
          when 190..318
              $game_map.parallax_sprite[2] += 2         
        else
          $game_map.parallax_effect[3] = 0
          $game_map.parallax_sprite[2] = 255
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Update Parallax Zoom Effect
  #--------------------------------------------------------------------------            
  def update_parallax_zoom_effect
      return if !@parallax_zoom_effect
      $game_map.parallax_effect[5] += 1
      case $game_map.parallax_effect[5]
          when 0..120
              $game_map.parallax_sprite[3] += @parallax_zoom_speed
          when 121..240
              $game_map.parallax_sprite[3] -= @parallax_zoom_speed
        else
          $game_map.parallax_effect[5] = 0
          $game_map.parallax_sprite[3] = 1.00
      end
      @parallax.zoom_x = $game_map.parallax_sprite[3]
      @parallax.zoom_y = $game_map.parallax_sprite[3]        
  end  
  
end

$mog_rgss3_parallax_ex = true