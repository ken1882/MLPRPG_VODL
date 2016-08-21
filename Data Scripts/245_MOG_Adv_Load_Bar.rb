#===============================================================================
# +++ MOG - Advanced Load Bar (v1.1) +++ 
#===============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#===============================================================================
# Apresenta uma barra de carregar entre as cenas de Save e Load.
#
# O propósito deste Script é apresentar alguns artworks de seu jogo 
# enquanto o jogador espera a barra de leitura.
#
#===============================================================================
# Você pode adpatar esse script em alguma outra Scene ou ativar pelo evento.
# Basta usar este código.
#
# SceneManager.call(Scene_Load_Bar)
#
#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 1.1 - Melhoria no sistema de dispose de imagens.
#==============================================================================

module MOG_LOAD_BAR
   # Tempo para fazer load.(Segundos)
   LOAD_DURATION = 3 
   # Ativar o sistema ao carregar o jogo.
   ENABLE_LOAD_BAR_FOR_SCENE_LOAD = true
   # Ativar o sistema ao salvar o jogo.
   ENABLE_LOAD_BAR_FOR_SCENE_SAVE = true 
   # Definição das imagens que ficarão no plano de fundo.
   LOAD_BACKGROUND_PICTURES = [
   "Background_1",
   "Background_2",
   "Background_3",
   "Background_4",
   #"Background_5",
   #"Background_6"
   #"Background_7",
   #"Background_8",
   #"Background_9",
   #"Background_10",
   # ...
   ]
   # Ativar ordem aleatória ou sequencial.
   PICTURE_RANDOM_SELECTION = true   
   # Posição do geral da Hud.
   LOAD_BAR_POSITION = [30,350]
   # Posição do medidor.
   LOAD_BAR_METER_POSITION = [11,27]
   # Posição do Texto.
   LOAD_BAR_TEXT_POSITION = [ 10, -3]
   # Som ao carregar o arquivo.
   LOAD_SE = "Kingdom Hearts Sound Effects - Save-Load"
   # Velocidade da animação do medidor.
   LOAD_BAR_FLOW_SPEED = 25
   # Definição da Cena que será ativada após salvar via menu.
   # Caso o save seja feito pelo evento, a cena será o Mapa.
   RETURN_TO_SCENE = Scene_Menu.new(4)
   # Ativar a animação de levitação do texto.
   ENABLE_FLOAT_TEXT_ANIMATION = true
   # Apresentar o sprite do personagem. 
   ENABLE_CHARACTER_SPRITE = true
   # Ativar barras laterais.
   ENABLE_STRIPE_SPRITE = true
   # Velocidade das barras laterais.
   STRIPE_SPEED = 1
end

#=============================================================================
# ■ Game_Temp
#=============================================================================
class Game_Temp
  attr_accessor :load_bar_pre_index
  attr_accessor :loadbar_type
  attr_accessor :load_pre_bgm
  attr_accessor :load_pre_bgs
 
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------              
 alias load_bar_initialize initialize
 def initialize
     @load_bar_pre_index = -1
     @loadbar_type = 0   
     load_bar_initialize
 end
   
end

#=============================================================================
# ■ Game_System
#=============================================================================
class Game_System
  attr_accessor :load_bar_pre_index
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------              
 alias load_bar_initialize initialize
 def initialize
     load_bar_initialize
     @load_bar_pre_index = 0
 end
 
 #--------------------------------------------------------------------------
 # ● BGS Stop
 #--------------------------------------------------------------------------             
 def bgs_stop
     Audio.bgs_stop
 end
end

#=============================================================================
# ■ Scene Load Bar
#=============================================================================
class Scene_Load_Bar
 include MOG_LOAD_BAR
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------            
 def initialize
     execute_dispose
     @bar_type = $game_temp.loadbar_type
     @load_duration_max = 60 * LOAD_DURATION
     @load_duration_max = 60 if @load_duration_max < 60  
     @load_duration = 0
     @pictures = LOAD_BACKGROUND_PICTURES
     create_background
     create_layout  
     create_load_bar
     create_text
     create_side_strip
 end
   
 #--------------------------------------------------------------------------
 # ● Create Background 
 #--------------------------------------------------------------------------           
 def create_background  
     @background = Sprite.new
     if PICTURE_RANDOM_SELECTION
        $game_system.load_bar_pre_index = rand(@pictures.size) 
        no_repeat_picture
     end
     image_name = @pictures[$game_system.load_bar_pre_index]    
     image_name = "" if image_name == nil     
     @background.bitmap = Cache.picture(image_name)
     $game_temp.load_bar_pre_index = $game_system.load_bar_pre_index
     unless PICTURE_RANDOM_SELECTION
        $game_system.load_bar_pre_index += 1
        $game_system.load_bar_pre_index = 0 if $game_system.load_bar_pre_index > @pictures.size - 1
     end   
 end
   
 #--------------------------------------------------------------------------
 # ● No Repeat Picture 
 #--------------------------------------------------------------------------            
 def no_repeat_picture
     if $game_system.load_bar_pre_index == $game_temp.load_bar_pre_index
        $game_system.load_bar_pre_index += 1
        $game_system.load_bar_pre_index = 0 if $game_system.load_bar_pre_index > @pictures.size - 1
     end  
 end
 
 #--------------------------------------------------------------------------
 # ● Create Layout
 #--------------------------------------------------------------------------           
 def create_layout  
     @hud = Sprite.new
     @hud.bitmap = Cache.system("Load_Bar_Layout")
     @hud.x = LOAD_BAR_POSITION[0]
     @hud.y = LOAD_BAR_POSITION[1]
     @hud.z = 10
 end
 
 #--------------------------------------------------------------------------
 # ● Create Side Strip
 #--------------------------------------------------------------------------           
 def create_side_strip
     @stripe1 = Plane.new
     @stripe2 = Plane.new     
     if @bar_type == 0
        @stripe1.bitmap = Cache.system("Load_Bar_Stripe1_L")
        @stripe2.bitmap = Cache.system("Load_Bar_Stripe2_L")
     else  
        @stripe1.bitmap = Cache.system("Load_Bar_Stripe1_S")
        @stripe2.bitmap = Cache.system("Load_Bar_Stripe2_S")
     end  
     @stripe1.z = 1
     @stripe2.z = 1          
     @stripe1.visible = ENABLE_STRIPE_SPRITE
     @stripe2.visible = ENABLE_STRIPE_SPRITE
 end 
 
 #--------------------------------------------------------------------------
 # ● Create Load Bar
 #--------------------------------------------------------------------------            
 def create_load_bar
     @bar_flow = 0
     @bar_image = Cache.system("Load_Bar_Meter")
     @bar_bitmap = Bitmap.new(@bar_image.width,@bar_image.height)
     @bar_range = @bar_image.width / 3
     @bar_width = @bar_range  * @load_duration / @load_duration_max
     @bar_height = @bar_image.height
     @bar_width_old = @bar_width
     @bar_src_rect = Rect.new(@bar_flow, 0, @bar_width, @bar_height)
     @bar_bitmap.blt(0,0, @bar_image, @bar_src_rect)
     @bar_sprite = Sprite.new
     @bar_sprite.bitmap = @bar_bitmap
     @bar_sprite.z = 11
     @bar_sprite.x = LOAD_BAR_POSITION[0] + LOAD_BAR_METER_POSITION[0]
     @bar_sprite.y = LOAD_BAR_POSITION[1] + LOAD_BAR_METER_POSITION[1]
     update_bar_flow
 end
 
 #--------------------------------------------------------------------------
 # ● Create Text
 #--------------------------------------------------------------------------            
 def create_text
     @text_float_time = 0
     @text_float_y = 0
     @text_image = Cache.system("Load_Bar_Text")
     @text_bitmap = Bitmap.new(@text_image.width,@text_image.height)
     @text_width = @text_image.width
     @text_height = @text_image.height / 2
     @text_src_rect = Rect.new(0, @text_height * @bar_type, @text_width, @text_height)
     @text_bitmap.blt(0,0, @text_image, @text_src_rect)   
     @text_sprite = Sprite.new
     @text_sprite.bitmap = @text_bitmap    
     @text_fy = LOAD_BAR_POSITION[1] + LOAD_BAR_TEXT_POSITION[1] 
     @text_sprite.x = LOAD_BAR_POSITION[0] + LOAD_BAR_TEXT_POSITION[0]
     @text_sprite.y = @text_fy 
     @text_sprite.z = 12
 end 
 
 #--------------------------------------------------------------------------
 # ● Main
 #--------------------------------------------------------------------------          
 def main
     Graphics.transition
     execute_loop
     execute_dispose
 end   
 
 #--------------------------------------------------------------------------
 # ● Execute Loop
 #--------------------------------------------------------------------------           
 def execute_loop
     loop do
          update
          Graphics.update          
          if SceneManager.scene != self
              break
          end
     end
 end
 
 #--------------------------------------------------------------------------
 # ● Execute Dispose
 #--------------------------------------------------------------------------            
 def execute_dispose
     return if @hud == nil
     @hud.bitmap.dispose
     @hud.dispose
     @stripe1.bitmap.dispose
     @stripe1.dispose     
     @stripe2.bitmap.dispose
     @stripe2.dispose        
     @bar_image.dispose
     @bar_bitmap.dispose
     @bar_sprite.bitmap.dispose
     @bar_sprite.dispose     
     @background.bitmap.dispose
     @background.dispose
     @text_image.dispose
     @text_bitmap.dispose
     @text_sprite.bitmap.dispose
     @text_sprite.dispose
     Graphics.transition
     Graphics.freeze
 end  
 
 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------             
 def update
     update_bar_flow
     update_bar_duration
     update_float_text
     update_slide_stripe
 end
 
 #--------------------------------------------------------------------------
 # ● Update Slide Stripe
 #--------------------------------------------------------------------------              
 def update_slide_stripe
     @stripe1.oy += STRIPE_SPEED
     @stripe2.ox += STRIPE_SPEED
 end   
   
 #--------------------------------------------------------------------------
 # ● update_float_text
 #--------------------------------------------------------------------------             
 def update_float_text
     return unless ENABLE_FLOAT_TEXT_ANIMATION 
     @text_float_time += 1
     case @text_float_time
        when 1..10
           @text_float_y += 1
        when 11..20
           @text_float_y -= 1
        else
          @text_float_y = 0
          @text_float_time = 0
     end 
     @text_sprite.y = @text_fy + @text_float_y
 end
 
 #--------------------------------------------------------------------------
 # ● Update Bar Flow
 #--------------------------------------------------------------------------            
 def update_bar_flow
     @bar_sprite.bitmap.clear
     @bar_width = @bar_range  * @load_duration / @load_duration_max
     @bar_width = @bar_range if @load_duration > @load_duration_max
     @bar_src_rect = Rect.new(@bar_flow, 0,@bar_width, @bar_height)
     @bar_bitmap.blt(0,0, @bar_image, @bar_src_rect)
     @bar_flow += LOAD_BAR_FLOW_SPEED
     if @bar_flow >= @bar_image.width - @bar_range
        @bar_flow = 0     
     end
 end   
   
 #--------------------------------------------------------------------------
 # ● Update Bar Duration
 #--------------------------------------------------------------------------              
 def update_bar_duration
     @load_duration += 1
     if @load_duration == @load_duration_max
        Audio.se_play("Audio/SE/" + LOAD_SE,100,100) rescue nil 
     elsif @load_duration == @load_duration_max + 10 
        if @bar_type == 0
            SceneManager.return
            $game_system.replay_bgm
         else   
            SceneManager.return   
        end  
        $game_temp.loadbar_type = false 
     end
 end  
 
end

#=============================================================================
# ■ Scene Save
#=============================================================================
class Scene_Save < Scene_File
  
 #--------------------------------------------------------------------------
 # ● On Save Sucess
 #--------------------------------------------------------------------------                
  alias mog_advloadbar_on_save_success on_save_success
  def on_save_success
      mog_advloadbar_on_save_success
      $game_temp.loadbar_type = 1
      SceneManager.call(Scene_Load_Bar)    
  end
  
end

#=============================================================================
# ■ Scene Load
#=============================================================================
class Scene_Load < Scene_File
  
  #--------------------------------------------------------------------------
  # ● On Load Success
  #--------------------------------------------------------------------------
  alias mog_advloadbar_on_load_success on_load_success
  def on_load_success
      mog_advloadbar_on_load_success
      $game_system.save_bgm      
      RPG::BGM.stop
      $game_temp.loadbar_type = 0
      SceneManager.call(Scene_Load_Bar)              
  end
end

$mog_rgss3_advanced_load_bar = true