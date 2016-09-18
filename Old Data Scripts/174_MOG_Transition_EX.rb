#==============================================================================
# +++ MOG - Transition EX (V1.2) +++
#==============================================================================
# By Moghunter
# http://www.atelier-rgss.com
#==============================================================================
# - Adiciona efeitos nas transições de batalha.
#==============================================================================
# Para definir o efeito de transição use o código abaixo.
#
# transition_ex(X)
#
# X - (Effect)
#
# 0 - Zoom IN
# 1 - Zoom OUT
# 2 - Angle
# 3 - Wave
# 4 - Shake
# 5 - Screen Slice 
# 6 - Random
# 7 - Nothing (Default Rpg Maker Transition)
#
#==============================================================================
# - DEFAULT TRANSITION NAME
#==============================================================================
# Se deseja mudar o tipo de transiçâo padrão, use o código abaixo. 
#
# transition_name("TRANSITION_NAME")
#
# Ex
#
# transition_name("BattleStart_4")
# transition_speed(160)

#==============================================================================

#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 1.2 - Correção do bug da transição Zero e Inicial.
#       - Novo comando para ativar a transição.
#       - Melhor animação para transição padrão.
# v 1.1 - Opção de definir o tipo de transição padrão. (arquivo de imagem)
#==============================================================================

module MOG_TRANSITION_EX
  #Definição da resolução do jogo
  SCREEN_SIZE = [640,416]

end

#===============================================================================
# ■ Game System
#===============================================================================
class Game_System
  
  attr_accessor :transition_ex
  attr_accessor :transition_name
  attr_accessor :transition_speed
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  alias mog_transiton_ex_initialize initialize
  def initialize
      @transition_ex = 0
      @transition_name = "BattleStart"
      @transition_speed = 60
      mog_transiton_ex_initialize
  end
    
end

#==============================================================================
# ■ Game Interpreter
#==============================================================================
class Game_Interpreter
 
  #--------------------------------------------------------------------------
  # ● Transition EX
  #--------------------------------------------------------------------------        
  def transition_ex(type = 0)
      $game_system.transition_ex = type
  end  
  
  #--------------------------------------------------------------------------
  # ● Transition Name
  #--------------------------------------------------------------------------      
  def transition_name(name = "")
      $game_system.transition_name = name
  end  
  
  #--------------------------------------------------------------------------
  # ● Transition Speed
  #--------------------------------------------------------------------------        
  def transition_speed(speed = 60)
      $game_system.transition_speed = speed
  end  
  
end

#===============================================================================
# ■ SceneManager
#===============================================================================
class << SceneManager
  
  @background_transition = nil
  
  #--------------------------------------------------------------------------
  # ● Call
  #--------------------------------------------------------------------------  
  alias mog_transition_ex_call call
  def call(scene_class)
      snapshot_for_transition
      mog_transition_ex_call(scene_class)    
  end
  
  #--------------------------------------------------------------------------
  # ● Snapshot For Transition
  #--------------------------------------------------------------------------
  def snapshot_for_transition
      @background_transition.dispose if @background_transition
      @background_transition = Graphics.snap_to_bitmap
  end
  
  #--------------------------------------------------------------------------
  # ● Background Transition
  #--------------------------------------------------------------------------
  def background_transition
      @background_transition
  end
  
end

#===============================================================================
# ■ Module Transition
#===============================================================================
module Module_Transition_EX
  include MOG_TRANSITION_EX
 
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------        
  def initialize
      super rescue nil
      execute_transition_ex 
  end  
  
  #--------------------------------------------------------------------------
  # ● Terminate
  #--------------------------------------------------------------------------        
  def terminate
      super rescue nil
      dispose_transition_ex
  end
  
  #--------------------------------------------------------------------------
  # ● Create Black Background
  #--------------------------------------------------------------------------      
  def create_blackbackground
      return if @blackbackground != nil
      @blackbackground = Sprite.new
      @blackbackground.bitmap = Bitmap.new(SCREEN_SIZE[0],SCREEN_SIZE[1])
      @blackbackground.bitmap.fill_rect(0, 0, SCREEN_SIZE[0], SCREEN_SIZE[1], Color.new(0,0,0)) 
      @blackbackground.z = 5000
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Transition EX
  #--------------------------------------------------------------------------    
  def execute_transition_ex
      return if @transtion_ex
      return if !$game_system.transition_ex.between?(0,6)
      @transition_ex = true
      dispose_transition_ex
      create_blackbackground
      @transition = []
      case $game_system.transition_ex    
        when 0
           @transition_time = 90
        else  
           @transition_time = 120
      end
      @transition.push(Sprite_Transition.new($game_system.transition_ex,@transition_time))
  end
  
 #--------------------------------------------------------------------------
 # ● Dispose Transition EX
 #--------------------------------------------------------------------------
 def dispose_transition_ex
     return if @transition == nil
     @transition.each {|sprite| sprite.dispose }
     @blackbackground.bitmap.dispose
     @blackbackground.dispose
     @transition_time = 0
     @transition = nil
 end  
  
 #--------------------------------------------------------------------------
 # ● Update Transition EX
 #-------------------------------------------------------------------------- 
 def update_transition_ex
     return if @transition == nil
     time = @transition_time
     for i in 0...@transition_time
           @transition.each {|sprite| sprite.update }
           @blackbackground.opacity -= 10 if time <= 26
           Graphics.update
           time -= 1
     end
     dispose_transition_ex
 end 
 
end

#===============================================================================
# ■ Sprite Transition
#===============================================================================
class Sprite_Transition   
  include MOG_TRANSITION_EX
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------     
  def initialize(type = 0,duration = 90)
      @type = $game_system.transition_ex > 5 ? rand(5) : type
      @range = 0 
      @speed = 0  
      @power = 0
      @image = SceneManager.background_transition
      @image = Cache.system("") if @image == nil
      @transition = Sprite.new      
      @transition.x = 0
      @transition.y = 0
      @transition.z = 99999
      @screen_size = [SCREEN_SIZE[0] ,SCREEN_SIZE[1]]
      @center = [@screen_size[0]/ 2, @screen_size[1] / 2]
      @transition.x = @center[0]
      @transition.y = @center[1]
      @transition.ox = @center[0]
      @transition.oy = @center[1]
      case @type
         when 5
            @transition.bitmap = Bitmap.new(@screen_size[0], @screen_size[1])         
            @transition.bitmap.stretch_blt(@transition.bitmap.rect, @image, @image.rect)                      
            @cw = @transition.bitmap.width 
            @ch = @transition.bitmap.height / 2            
            src_rect = Rect.new(0, 0,@screen_size[0], @screen_size[1] )
            @transition.bitmap.blt(0, 0, @image, src_rect)                 
         else
            @transition.bitmap = Bitmap.new(@screen_size[0], @screen_size[1])         
            @transition.bitmap.stretch_blt(@transition.bitmap.rect, @image, @image.rect)                       
      end          
      @effect_time = [duration, duration]    
  end  
  
 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------     
  def dispose
      @image.dispose
      @transition.bitmap.dispose
      @transition.dispose 
  end  
  
 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------   
  def update
      @effect_time[0] -= 1 if @effect_time[0] > 0
      case @type
         when 1 # Zoom IN / OUT # --------------------
               if  @effect_time[0].between?(@effect_time[1] - 20, @effect_time[1])
                   @transition.zoom_x += 0.07
                   @transition.zoom_y += 0.07
               else    
                   @transition.zoom_x -= 0.03
                   @transition.zoom_y -= 0.03
                   @transition.opacity -= 3
               end  
        when 2 # Angle # --------------------
                @transition.zoom_x += 0.01
                @transition.zoom_y -= 0.02
                @transition.opacity -= 2
                @transition.angle += 5
        when 3 # Wave
            if  @effect_time[0] == @effect_time[1] - 1
                @range = 250 
                @speed = 500             
                @transition.wave_length = 544
            end
            @power += 1
            @transition.wave_amp = @power * 2
            @transition.wave_speed = @power * 7          
            @transition.opacity -= 2
            @transition.zoom_x += 0.01
            @transition.zoom_y += 0.01            
            @transition.update
        when 4 # Shake
            if  @effect_time[0].between?(@effect_time[1] - 10, @effect_time[1]) or
                @effect_time[0].between?(@effect_time[1] - 30, @effect_time[1] - 20) or
                @effect_time[0].between?(@effect_time[1] - 50, @effect_time[1] - 40) or
                @effect_time[0].between?(@effect_time[1] - 70, @effect_time[1] - 60) or
                @effect_time[0].between?(@effect_time[1] - 90, @effect_time[1] - 80) 
                @transition.zoom_x += 0.1
                @transition.zoom_y += 0.1                
            else    
                @transition.zoom_x -= 0.1
                @transition.zoom_y -= 0.1
             end
        when 5 #Slice
           @transition.bitmap.clear
           @speed += 6           
           src_rect = Rect.new(0, 0,@cw, @ch )
           @transition.bitmap.blt(@speed, 0, @image, src_rect)            
           src_rect = Rect.new(0, @ch,@cw, @ch )
           @transition.bitmap.blt(-@speed, @ch, @image, src_rect)           
           @transition.opacity -= 3
           @transition.zoom_x += 0.005
           @transition.zoom_y += 0.005        
         else # Zoom IN # --------------------
              @transition.zoom_x += 0.05
              @transition.zoom_y += 0.05         
              @transition.opacity -= 3       
      end     
    end  
        
end

#===============================================================================
# ■ Scene Map
#===============================================================================
class Scene_Map < Scene_Base
  
 #--------------------------------------------------------------------------
 # ● Perform Battle Transition
 #--------------------------------------------------------------------------       
 def perform_battle_transition
     if $game_system.transition_ex.between?(0,6)       
        Graphics.transition(0)
      else 
        Graphics.transition($game_system.transition_speed, "Graphics/System/" + $game_system.transition_name, 100)
     end
     Graphics.freeze     
 end
   
end

#===============================================================================
# ■ Scene Battle
#===============================================================================
class Scene_Battle < Scene_Base
  include Module_Transition_EX
  
 #--------------------------------------------------------------------------
 # ● Perform Transition
 #--------------------------------------------------------------------------       
 def perform_transition
     if $game_system.transition_ex.between?(0,6)
        Graphics.transition(0)
        update_transition_ex
     else        
        Graphics.transition($game_system.transition_speed, "Graphics/System/" + $game_system.transition_name, 100)
     end
     Graphics.update
 end
  
end

$mog_rgss3_transition_ex = true