#==============================================================================
# +++ MOG - Active Timer  (v1.2) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Apresenta um medidor animado com a contagem de tempo.
#==============================================================================
# Serão necessários os seguintes arquivos na pasta Graphics/System
#
# Timer_Layout.png
# Timer_Meter.png
# Timer_Number.png 
# Timer_Fire.png 
# 
#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 1.2 - Correção de não apresentar o medidor na cena de batalha.
# v 1.1 - Melhoria no sistema de dispose de imagens.
#==============================================================================

module MOG_ACTIVE_TIMER
    #Posição geral da janela de contagem. (X,Y)
    TIMER_POS = [130,30] 
    #Posição do medidor. (X,Y)
    METER_POS = [60,9]
    #Posição do número. (X,Y)
    NUMBER_POS = [104,24]
    #Posição da animação do fogo. (X,Y)
    FIRE_POS = [60,0]
    #Velocidade da animação do medidor.
    METER_FLOW_SPEED = 5 
    #Velocidade da animação do fogo.
    FIRE_ANIMATION_SPEED = 3
    #Definição da prioridade da hud.
    HUD_Z = 50
end  

#==============================================================================
# ■ Game_System
#==============================================================================
class Game_System
  attr_accessor :timer_prev
  
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------  
  alias mog_timer_meter_initialize initialize
  def initialize
      @timer_prev  = 1
      mog_timer_meter_initialize
  end
end

#==============================================================================
# ■ Game_Timer
#==============================================================================
class Game_Timer  
  attr_reader  :count
end

#==============================================================================
# ■ Game_Interpreter  
#==============================================================================
class Game_Interpreter  
  
  #--------------------------------------------------------------------------
  # ● command_124
  #--------------------------------------------------------------------------
  alias mog_timer_meter_command_124 command_124
  def command_124
      mog_timer_meter_command_124
      $game_system.timer_prev = $game_timer.count - 60
      $game_system.timer_prev = 1 if $game_timer.count <= 0
  end  
end  

#==============================================================================
# ■ Sprite_Timer
#==============================================================================
class Sprite_Timer < Sprite
  include MOG_ACTIVE_TIMER
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  def initialize(viewport)
      super(viewport)
      dispose
      update_timer
      create_layout
      create_meter
      create_number
      create_fire
      update_visible
  end
  
  #--------------------------------------------------------------------------
  # ● create_layout
  #--------------------------------------------------------------------------  
  def create_layout
      @layout = Sprite.new
      @layout.bitmap = Cache.system("Timer_Layout")
      @layout.z = HUD_Z
      @layout.x = TIMER_POS[0]
      @layout.y = TIMER_POS[1]
  end
  
  #--------------------------------------------------------------------------
  # ● create_meter
  #--------------------------------------------------------------------------  
  def create_meter
      @meter_flow = 0
      @meter_image = Cache.system("Timer_Meter")
      @meter_bitmap = Bitmap.new(@meter_image.width,@meter_image.height)
      @meter_range = @meter_image.width / 3
      @meter_width = @meter_range * $game_timer.count / $game_system.timer_prev
      @meter_width = 0 if $game_timer.count < 0
      @meter_height = @meter_image.height
      @meter_src_rect = Rect.new(@meter_range, 0, @meter_width, @meter_height)
      @meter_bitmap.blt(0,0, @meter_image, @meter_src_rect) 
      @meter_sprite = Sprite.new
      @meter_sprite.bitmap = @meter_bitmap
      @meter_sprite.z = 1 + HUD_Z
      @meter_sprite.x = TIMER_POS[0] + METER_POS[0]
      @meter_sprite.y = TIMER_POS[1] + METER_POS[1]
      update_flow
  end  
  
  #--------------------------------------------------------------------------
  # ● create_number
  #--------------------------------------------------------------------------  
  def create_number
      @number_image = Cache.system("Timer_Number")
      @number_bitmap = Bitmap.new(@number_image.width,@number_image.height)
      @number_sprite = Sprite.new
      @number_sprite.bitmap = @number_bitmap
      @number_sprite.z = 3 + HUD_Z
      @number_sprite.x = TIMER_POS[0] + NUMBER_POS[0]
      @number_sprite.y = TIMER_POS[1] + NUMBER_POS[1]
      @number_cw = @number_image.width / 10
      @number_ch = @number_image.height    
      refresh_number
      @number = @total_sec
  end 
    
  #--------------------------------------------------------------------------
  # ● create_fire
  #--------------------------------------------------------------------------  
  def create_fire
      @fire_flow = 0
      @fire_flow_speed = 0
      @fire_refresh = false
      @fire_image = Cache.system("luna_timer")
      @fire_bitmap = Bitmap.new(@fire_image.width,@fire_image.height)
      @fire_width = @fire_image.width / 3    
      @fire_src_rect_back = Rect.new(0, 0,@fire_width, @fire_image.height)
      @fire_bitmap.blt(0,0, @fire_image, @fire_src_rect_back)    
      @fire_sprite = Sprite.new
      @fire_sprite.bitmap = @fire_bitmap
      @fire_sprite.z = 2 + HUD_Z
      @fire_sprite.x = -5 + @meter_width  + TIMER_POS[0] + FIRE_POS[0]
      @fire_sprite.y = TIMER_POS[1] + FIRE_POS[1]
      update_fire 
  end  
  
  #--------------------------------------------------------------------------
  # ● dispose
  #--------------------------------------------------------------------------  
  def dispose
       return if @layout == nil
       @layout.bitmap.dispose
       @layout.dispose
       @layout = nil
       @meter_sprite.bitmap.dispose
       @meter_sprite.dispose
       @meter_bitmap.dispose
       @number_sprite.bitmap.dispose
       @number_sprite.dispose
       @number_bitmap.dispose 
       @fire_bitmap.dispose
       @fire_sprite.bitmap.dispose
       @fire_sprite.dispose
       @number_image.dispose
       @meter_image.dispose
       @fire_image.dispose        
       super
  end  
  
  #--------------------------------------------------------------------------
  # ● update
  #--------------------------------------------------------------------------  
  def update
      super
      update_visible
      if $game_timer.working?
         update_timer
         update_flow
         update_fire 
         refresh_number
      end
  end 
    
  #--------------------------------------------------------------------------
  # ● update
  #--------------------------------------------------------------------------    
  def can_visible?
      return false if !$game_timer.working?
      if SceneManager.scene_is?(Scene_Map) or SceneManager.scene_is?(Scene_Battle)
         return true
      else   
         return false
      end
      return true
  end  
  
  #--------------------------------------------------------------------------
  # ● update
  #--------------------------------------------------------------------------  
  def update_visible
      @vis = can_visible?
      @meter_sprite.visible = @vis
      @number_sprite.visible = @vis
      @layout.visible = @vis
      @fire_sprite.visible = @vis
  end    
  
  #--------------------------------------------------------------------------
  # ● draw_number
  #--------------------------------------------------------------------------  
  def draw_number(x,y,value)
      @number_text = value.abs.to_s.split(//)
      plus_x = -@number_cw * @number_text.size
      for r in 0..@number_text.size - 1
         @number_abs = @number_text[r].to_i 
         @number_src_rect = Rect.new(@number_cw * @number_abs, 0, @number_cw, @number_ch)
         @number_bitmap.blt(plus_x + x + (@number_cw  *  r), y, @number_image, @number_src_rect)        
      end     
  end   
    
  #--------------------------------------------------------------------------
  # ● refresh_number
  #--------------------------------------------------------------------------  
  def refresh_number
      return if @number == @time_sec
      @number = @time_sec
      @min = @number / 60
      @sec = @number % 60
      @number_sprite.bitmap.clear
      draw_number(@number_cw * 1,0,0) if @min < 10              
      draw_number(@number_cw * 2,0,@min)
      draw_number(@number_cw * 4,0,0) if @sec < 10            
      draw_number(@number_cw * 5,0,@sec)
  end
   
  #--------------------------------------------------------------------------
  # ● update
  #--------------------------------------------------------------------------  
  def update_timer
      @time_sec = $game_timer.count / 60 
      @time_flow = $game_timer.count - 60
  end  
    
  #--------------------------------------------------------------------------
  # ● update_flow
  #--------------------------------------------------------------------------  
  def update_flow
      @meter_sprite.bitmap.clear
      @meter_width = @meter_range * @time_flow / $game_system.timer_prev 
      @meter_width = 0 if @time_flow < 0
      @meter_src_rect = Rect.new(@meter_flow, 0,@meter_width, @meter_height)
      @meter_bitmap.blt(0,0, @meter_image, @meter_src_rect)          
      @meter_flow += METER_FLOW_SPEED  
      @meter_flow = 0 if @meter_flow >= @meter_image.width - @meter_range  
  end   
    
  #--------------------------------------------------------------------------
  # ● update_fire 
  #--------------------------------------------------------------------------  
  def update_fire 
      @fire_flow_speed += 1
      if @fire_flow_speed > FIRE_ANIMATION_SPEED
         @fire_flow += 1
         @fire_flow_speed = 0
         @fire_flow = 0 if @fire_flow == 3
         @fire_refresh = true 
      end
      @fire_sprite.x = -5 + @meter_width  + TIMER_POS[0] + FIRE_POS[0]
      return if @fire_refresh == false 
      @fire_sprite.bitmap.clear
      @fire_refresh = false
      @fire_src_rect_back = Rect.new(@fire_width * @fire_flow, 0,@fire_width, @fire_image.height)
      @fire_bitmap.blt(0,0, @fire_image, @fire_src_rect_back)        
  end
end  

$mog_rgss3_active_timer = true 