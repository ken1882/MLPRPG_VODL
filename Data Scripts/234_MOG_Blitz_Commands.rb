#==============================================================================
# +++ MOG - Blitz Commands (v1.6) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Permite ativar ações através de sequência de comandos.
#==============================================================================
# UTILIZAÇÃO
#==============================================================================
# No banco de dados de habilidades ou itens, coloque o seguinte comentário na
# caixa de notas. 
#
# <Blitz Command>
#
# * Lembre-se de definir a sequência de botões no editor de script antes de
# usar a habilidade
#
# Para definir uma velocidade especifica na sequência de botões use o cometário
# abaixo.
#
# <Blitz Speed = X>
#
#==============================================================================
# Arquivos necessários. Graphics/System/
#==============================================================================
#
# Blitz_Background.png
# Blitz_Flash.png
# Blitz_Layout.png
# Blitz_Meter.png
# Chain_Command.png
#
#==============================================================================
# Histórico
#==============================================================================
# v1.6 - Melhoria na codificação.
#==============================================================================

$imported = {} if $imported.nil?
$imported[:mog_blitz_commands] = true

module MOG_BLITZ_COMMANDS
  #Definição do tempo para inserir os comandos. (tempo X quantidade de comandos)
  DEFAULT_INPUT_DURATION = 30
 #==============================================================================
 # BLITZ_INPUT = { SKILL_ID => [COMMAND] }
 #
 # SKILL_ID = ID da habilidade no banco de dados.
 # COMMANDS = Defina aqui a sequência de botões. 
 #            (Para fazer a sequência use os comandos abaixo)   
 #  
 # "Down" ,"Up" ,"Left" ,"Right" ,"Shift" ,"D" ,"S" ,"A" ,"Z" ,"X" ,"Q" ,"W"
 #
 # Exemplo de utilização
 #
 # BLITZ_INPUT = { 
 # 25=>["Down","D","S","Right"],
 # 59=>["Down","Up","Left","Right","Shift","D","S","A","Z","X","Q","W"],
 # 80=>["Shift","D"]
 # }   
 #==============================================================================
 DEBUG = true #right input nomatter what
  BLITZ_INPUT = {
      325=>["Up","Up","Down","Down","Right","Right","Left","Left","Z","X","Up","Right","Q","Shift","Right","Left","Q","W","A","Z","Up","Right","Shift","S","Down","Up","X","Shift","Right","Left","Left","Z","Down","Right","Left","Up","Right","Down","Up","Down","Left","Right","Z","Shift","W","W","Up","Down","Right","Left","Shift","W","S","X","Z","A","Q","Up","Right","Down","Left","Z","Z","X","S","W","Shift","Z"],
  
     401=>["Left","Up","Right","Down","Up","Down","Left","Right","Z"],
     
     402=>["Shift","Right","Right","Down","Up","Z","Left","Right","Shift"],
     
     403=>["Up","Up","Down","Down","Z","X","Shift","X","Right","Right","Left","Left","Z","S","X","Z","Z","Q","Left","Q","Right","Down","Shift"],
     
     404=>["Z","Down","X","Down","Up","Down","Shift","Down","Up"],
     
     405=>["X","Shift","Left","Z","Shift","Z","Q","Left","Left","Shift"],
   
    406=>["Left","Z","W","Down","Z","Right","Z","Down","Left","X"],

    407=>["A","Right","Right","Right","W","Right","X","S","Down","Down"],

    408=>["X","X","Z","X","S","W","Down","X","Right","Z"],

    409=>["W","Z","S","Up","Z","A","Z","Left","Down","A","Left","S","Down","X","Up"],

    410=>["Right","Down","Shift","Right","Up","S","Down","A","A","Up","Up","S","S","Q","A"],

    411=>["X","Q","Left","Q","W","X","Up","Down","Up","Left","Left","S","Right","Q","W"],

    412=>["Z","Left","Z","Q","Up","X","Shift","Q","Right","Z","Shift","S","Z","S","Z"],
    423=>["Z","Left","Z","Q","Up","X","Shift","Q","Right","Z","Shift","S","Z","S","Z"],

    413=>["W","Z","S","Up","Z","A","Z","Left","Down","A","Left","S","Down","X","Up"],

    414=>["Down","Z","Right","Z","S","Left","Left","S","Right","S"],

    415=>["A","Q","Z","A","Up","Left","Down","Right","X","A","Q","Shift","X","Left","Left"],

    416=>["S","Left","A","S","Left","Left","Shift","Up","Q","Shift","Z","Up","S","Up","W"],
 
    417=>["S","Left","Left","Shift","X","W","Q","Right","Shift","Z","Down","S","Left","Down","Left"],
    
    418=>["S","Up","S","A","Up","Z","Right","Q","A","W","S","Q","S","A","W","Shift","X","Left","W","Right"],
    
    419=>["Left","X","Down","Q","Z","A","Up","W","Left","Q","Z","Left","W","A","X","Down","Z","X","Shift","Right","Down","Shift","Z","W","Z","S","Q","Q","A","Up","S","S","S","W","Shift","Z","A","A","Shift","S","S","Left","X","Up","Up"],
    
    420=>["S","Z","Q","Q","Right","Right","Up","Q","Q","X","Left","Right","Up","Up","Q","Down","Left","Left","Q","Down","Left","Shift","Shift","A","Shift","Shift","W","S","A","Down","Up","Down","Up","Up","Q","Left","Up","Z","Down","Left"],
    
    421=>["Up","Q","Z","Left","S","Up","Q","X","Up","Shift","A","W","Left","S","Left","Right","Left","Z","Up","Right","S","Shift","Left","Left","Up","W","Q","Down","S","Right","W","A","Down","A","Z","W","X","Left","A","X","A","X","Right","Z","Shift"],
    

 }  
 #Ativar animação da imagem de fundo. 
 BACKGROUND_ENABLE = false
 #Velocidade de deslize da imagem de fundo.
 BACKGROUND_SCROLL_SPEED = [30,0]
 #Posição do layout.
 BLITZ_POSITION = [0,0]
 #Posição do botão.
 BUTTON_POSITION = [265,170]
 #Posição do medidor de tempo.
 METER_POSITION = [63,249]
 #Posição do sprite Flash.
 FLASH_POSITION = [0,146]
 #Posição do ícone.
 ICON_POSITION = [0,0]
 #Posição do nome da skill
 SKILL_NAME_POSITION = [180,140]
 #Definição das palavras usadas no sistema blitz.
 BLITZ_WORDS = ["Missed!", "Timeover", "Success!"]
 #Configuração da fonte.
 FONT_SIZE = 22 
 FONT_COLOR = Color.new(255,255,255)
 #Prioridade dos sprites.
 BLITZ_Z = 10500 
 #Som ao acertar. 
 RIGHT_SE = "Chime1"
 #Som ao errar.
 WRONG_SE = "Buzzer1"  
 #Definição do som ao ativar o sistema.
 BLITZ_START_SE = "Saint9"
end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
  attr_accessor :blitz_commands
  attr_accessor :blitz_commands_phase
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------      
  alias mog_blits_commands_initialize initialize
  def initialize
      @blitz_commands = [false,0] ; @blitz_commands_phase = false
      mog_blits_commands_initialize
  end
  
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Use Item
  #--------------------------------------------------------------------------  
  alias mog_blitz_commands_use_item use_item
  def use_item
      if can_execute_blitz_input?
         blitz_before_action
         execute_blitz_input
         blitz_after_action
         unless $game_temp.blitz_commands[1] == nil
             return if !$game_temp.blitz_commands[0]
         end
      end
      mog_blitz_commands_use_item     
  end 
  
  #--------------------------------------------------------------------------
  # ● Blitz Before Action
  #--------------------------------------------------------------------------  
  def blitz_before_action
      record_window_data if $imported[:mog_atb_system]
      if $imported[:mog_menu_cursor]    
         @chain_curor_x = $game_temp.menu_cursor[2] 
         $game_temp.menu_cursor[2] = -999
         force_cursor_visible(false)
      end             
  end      
  
  #--------------------------------------------------------------------------
  # ● Blitz After ACtion
  #--------------------------------------------------------------------------  
  def blitz_after_action
      restore_window_data if $imported[:mog_atb_system]
      if $imported[:mog_menu_cursor] and @chain_curor_x != nil
         $game_temp.menu_cursor[2] = @chain_curor_x 
      end
  end    
  
  #--------------------------------------------------------------------------
  # ● Can Execute Blitz Input
  #--------------------------------------------------------------------------    
  def can_execute_blitz_input?
      return false if !@subject.is_a?(Game_Actor)
      return false if @subject.restriction != 0
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Blitz Input
  #--------------------------------------------------------------------------   
  def execute_blitz_input 
      $game_temp.blitz_commands[0] = false
      action_id = @subject.current_action.item.note =~ /<Blitz Command>/ ? @subject.current_action.item.id : nil
      $game_temp.blitz_commands[1] = action_id
      return if action_id == nil
      blitz_command_sequence = MOG_BLITZ_COMMANDS::BLITZ_INPUT[action_id]
      if $imported[:mog_menu_cursor]    
         valor_x = $game_temp.menu_cursor[2] ; $game_temp.menu_cursor[2] = -999
         force_cursor_visible(false)
      end      
      if blitz_command_sequence != nil  
         blitz_sq = Blitz_Commands.new(blitz_command_sequence, @subject ,action_id)
         loop do
              $game_temp.blitz_commands_phase = true
              (blitz_sq.update ; Input.update) unless @spriteset.animation?
              @spriteset.update ; Graphics.update ; update_info_viewport
              break if blitz_sq.phase == 9
         end
         blitz_sq.dispose
      end        
      $game_temp.menu_cursor[2] = valor_x if $imported[:mog_menu_cursor]
      $game_temp.blitz_commands_phase = false
  end
  
end

#==============================================================================
# Game Temp
#==============================================================================
class Game_Temp
  
  attr_accessor :cache_blitz_command
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  alias mog_blitz_command_initialize initialize   
  def initialize
      mog_blitz_command_initialize
      cache_blt_cmd
  end
  
  #--------------------------------------------------------------------------
  # ● Cache Blt Cmd
  #--------------------------------------------------------------------------  
  def cache_blt_cmd
      @cache_blitz_command = []
      @cache_blitz_command.push(Cache.system("Blitz_Background"))
      @cache_blitz_command.push(Cache.system("IconSet"))
      @cache_blitz_command.push(Cache.system("Blitz_Flash"))
      @cache_blitz_command.push(Cache.system("Blitz_Meter"))
      @cache_blitz_command.push(Cache.system("Blitz_Layout"))
      @cache_blitz_command.push(Cache.system("Chain_Battle_Command"))
  end
  
end


#==============================================================================
# ■ Spriteset Battle
#==============================================================================
class Spriteset_Battle
   
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  alias mog_blitz_commands_initialize initialize
  def initialize
      $game_temp.cache_blt_cmd
      mog_blitz_commands_initialize     
  end
end  
#==============================================================================
# Blitz Commands
#==============================================================================
class Blitz_Commands
  include MOG_BLITZ_COMMANDS
  attr_accessor :phase
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------      
  def initialize(sequence, subject,action_id)
      @phase = 0 ; @actor = subject ; @skill = $data_skills[action_id]
      @skillname = @skill.name ; @action_id = action_id 
      @chain_command = sequence ; @end = false
      duration = @skill.note =~ /<Blitz Speed = (\d+)>/i ? $1.to_i : DEFAULT_INPUT_DURATION
      @timer_max = duration * @chain_command.size ; @timer_max = 1 if @timer_max < 1
      @timer = @timer_max ; @com = 0 ; @com_index = 0 ; @new_x = 0 
      Audio.se_play("Audio/SE/" + BLITZ_START_SE, 100, 100) rescue nil
      create_sprites
      
      if @actor.state?(111) then
        $game_variables[13] = 1
      else
        $game_variables[13] = 0
      end
      
  end

  #--------------------------------------------------------------------------
  # ● Create Sprites
  #--------------------------------------------------------------------------        
  def create_sprites
      create_background ; create_layout ; create_buttons ; create_meter
      create_flash ; create_skill_name ; create_icon      
  end
  
  #--------------------------------------------------------------------------
  # ● Create Background
  #--------------------------------------------------------------------------        
  def create_background
      @background = Plane.new ; @background.opacity = 0
      @background.bitmap = $game_temp.cache_blitz_command[0]
      @background.z = BLITZ_Z ; @background.visible = BACKGROUND_ENABLE
  end
  
  #--------------------------------------------------------------------------
  # ● Create Icon
  #--------------------------------------------------------------------------      
  def create_icon
      @icon_image = $game_temp.cache_blitz_command[1]
      @icon_sprite = Sprite.new ; @icon_sprite.bitmap = Bitmap.new(24,24)
      @icon_sprite.z = BLITZ_Z + 3
      @org_x2 = 80 + ICON_POSITION[0] - @center + SKILL_NAME_POSITION[0]
      @icon_sprite.x = @org_x2 ; @icon_sprite.opacity = 0
      @icon_sprite.y = ICON_POSITION[1] + SKILL_NAME_POSITION[1]     
      icon_rect = Rect.new(@skill.icon_index % 16 * 24, @skill.icon_index / 16 * 24, 24, 24)
      @icon_sprite.bitmap.blt(0,0, @icon_image, icon_rect)
  end  
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------      
  def create_skill_name
      @skill_name = Sprite.new ; @skill_name.bitmap = Bitmap.new(200,32)
      @skill_name.bitmap.font.size = FONT_SIZE
      @skill_name.z = BLITZ_Z + 3 ; @skill_name.y = SKILL_NAME_POSITION[1]
      @skill_name.opacity = 0 ; refresh_skill_name
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Skill Name
  #--------------------------------------------------------------------------        
  def refresh_skill_name
      cm = @skillname.to_s.split(//).size
      @center = ((200 / @skill_name.bitmap.font.size) * cm / 2) + 5
      @org_x = SKILL_NAME_POSITION[0] ; @skill_name.x = @org_x  
      @skill_name.bitmap.font.color = Color.new(0,0,0)
      @skill_name.bitmap.draw_text(1,1,200,32,@skillname.to_s,1)  
      @skill_name.bitmap.font.color = FONT_COLOR
      @skill_name.bitmap.draw_text(0,0,200,32,@skillname.to_s,1)  
  end  
  
  #--------------------------------------------------------------------------
  # ● Create Flash
  #--------------------------------------------------------------------------          
  def create_flash
      @flash_type = 0 ; @flash_image = $game_temp.cache_blitz_command[2]
      @flash_cw = @flash_image.width ; @flash_ch = @flash_image.height / 2
      @flash = Sprite.new ; @flash.bitmap = Bitmap.new(@flash_cw,@flash_ch)
      @flash.x = FLASH_POSITION[0] ; @flash.y = FLASH_POSITION[1]
      @flash.z = BLITZ_Z + 2 ; @flash.opacity = 0 ; @flash.blend_type = 1
      refresh_flash
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Flash
  #--------------------------------------------------------------------------            
  def refresh_flash
      @flash.bitmap.clear
      f_scr = Rect.new(0,@flash_type * @flash_ch,@flash_cw,@flash_ch)
      @flash.bitmap.blt(0,0,@flash_image,f_scr)
  end

  #--------------------------------------------------------------------------
  # ● Create Meter
  #--------------------------------------------------------------------------          
  def create_meter
      @meter_image = $game_temp.cache_blitz_command[3]
      @meter_cw = @meter_image.width ; @meter_ch = @meter_image.height
      @meter_sprite = Sprite.new
      @meter_sprite.bitmap = Bitmap.new(@meter_cw,@meter_ch)
      @meter_sprite.x = METER_POSITION[0] ; @meter_sprite.y = METER_POSITION[1]
      @meter_sprite.z = BLITZ_Z + 2 ; @meter_sprite.opacity = 0 ; update_meter
  end
  
  #--------------------------------------------------------------------------
  # ● Update Meter
  #--------------------------------------------------------------------------            
  def update_meter
      return if @meter_sprite == nil
      @meter_sprite.bitmap.clear ; m_width = @meter_cw * @timer / @timer_max
      m_scr = Rect.new(0,0,m_width,@meter_ch)
      @meter_sprite.bitmap.blt(0,0,@meter_image, m_scr)
  end
  
  #--------------------------------------------------------------------------
  # ● Create Layout
  #--------------------------------------------------------------------------          
  def create_layout
      @layout = Sprite.new ; @layout.bitmap = $game_temp.cache_blitz_command[4]
      @layout.x = BLITZ_POSITION[0] ; @layout.y = BLITZ_POSITION[1]
      @layout.z = BLITZ_Z + 1 ; @layout.opacity = 0
  end
  
  #--------------------------------------------------------------------------
  # ● Create Buttons
  #--------------------------------------------------------------------------       
  def create_buttons
     @image = $game_temp.cache_blitz_command[5]  
     @image_cw = @image.width / 13 ; @image_ch = @image.height  
     @image_cw_max = (@image_cw + 5) * @chain_command.size
     @sprite = Sprite.new ; @sprite.bitmap = Bitmap.new(@image_cw_max,@image_ch * 2)
     if @chain_command.size <= 15
        @sprite.x = (Graphics.width / 2) - ((@image_cw + 5) * @chain_command.size) / 2
        @new_x = 0
     else   
        @sprite.x = (Graphics.width / 2) ; @new_x = @sprite.x 
     end   
     @sprite.x = BUTTON_POSITION[0] ; @sprite.y = BUTTON_POSITION[1]
     @sprite.z = BLITZ_Z + 1 ; @sprite.opacity = 0 ; refresh_button
  end  
  
  #--------------------------------------------------------------------------
  # ● Refresh Button
  #--------------------------------------------------------------------------         
  def refresh_button
      return if @sprite == nil
      @sprite.bitmap.clear
      @chain_command.each_with_index do |i, index|
         command_list_check(i) 
         bitmap_src_rect = Rect.new(@com * @image_cw, 0, @image_cw, @image_ch)
         if @com_index == index
            @sprite.bitmap.blt(index * (@image_cw + 5) , 0, @image, bitmap_src_rect)
         else
            @sprite.bitmap.blt(index * (@image_cw + 5) , @image_ch, @image, bitmap_src_rect)
         end     
      end  
      @new_x = BUTTON_POSITION[0] - ((@image_cw + 5) * @com_index) 
  end
 
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------        
  def dispose
      dispose_background ; dispose_layout ; dispose_buttons ; dispose_meter
      dispose_flash ; dispose_name ; dispose_icon_sprite      
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Background
  #--------------------------------------------------------------------------          
  def dispose_background
      return if @background == nil
      @background.dispose ; @background = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Icon Sprite
  #--------------------------------------------------------------------------        
  def dispose_icon_sprite
      return if @icon_sprite == nil
      @icon_sprite.bitmap.dispose ; @icon_sprite.dispose ; @icon_sprite = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Name
  #--------------------------------------------------------------------------        
  def dispose_name
      return if @skill_name == nil
      @skill_name.bitmap.dispose ; @skill_name.dispose ; @skill_name = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Flash
  #--------------------------------------------------------------------------            
  def dispose_flash
      return if @flash == nil
      @flash.bitmap.dispose ; @flash.dispose ; @flash = nil
  end    
  
  #--------------------------------------------------------------------------
  # ● Dispose Meter
  #--------------------------------------------------------------------------            
  def dispose_meter
      return if @meter_sprite == nil
      @meter_sprite.bitmap.dispose ; @meter_sprite.dispose ; @meter_sprite = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Buttons
  #--------------------------------------------------------------------------         
  def dispose_buttons
      return if @sprite == nil
      @sprite.bitmap.dispose ; @sprite.dispose ; @sprite = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Layout
  #--------------------------------------------------------------------------            
  def dispose_layout
      return if @layout == nil
      @layout.dispose ; @layout = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------        
  def update
      if @end and @sprite.x == @new_x
         update_flash ; update_background ; update_end
         return 
      end
      update_background ; update_timer ; update_command ; update_slide_command
      update_meter ; update_flash ; update_opacity
  end
  
  #--------------------------------------------------------------------------
  # ● Update Opacity
  #--------------------------------------------------------------------------          
  def update_opacity 
      return if @sprite.opacity == nil
      @sprite.opacity += 10 ; @layout.opacity += 10 
      @meter_sprite.opacity += 10 ; @skill_name.opacity += 10
      @background.opacity += 10 ; @icon_sprite.opacity += 10   
  end
    
  #--------------------------------------------------------------------------
  # ● Update End
  #--------------------------------------------------------------------------          
  def update_end
      fs = 6 ; @icon_sprite.opacity -= fs ; @background.opacity -= fs
      @skill_name.opacity -= fs ; @sprite.opacity -= fs ; @layout.opacity -= fs
      @meter_sprite.opacity -= fs ; @phase = 9 if @background.opacity == 0
  end
  
  #--------------------------------------------------------------------------
  # ● Update Background
  #--------------------------------------------------------------------------          
  def update_background
      return if @background == nil
      @background.ox += BACKGROUND_SCROLL_SPEED[0]
      @background.oy += BACKGROUND_SCROLL_SPEED[1]
  end    
  
  #--------------------------------------------------------------------------
  # ● Update Flash
  #--------------------------------------------------------------------------              
  def update_flash
      return if @flash == nil or @flash.opacity == 0
      @flash.opacity -= 10
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Timer
  #--------------------------------------------------------------------------          
  def update_timer
      return if @timer == 0
      @timer -= 1 ; wrong_command(1) if @timer == 0
  end
  
  #--------------------------------------------------------------------------
  # ● Update Slide Command
  #--------------------------------------------------------------------------          
  def update_slide_command
      return if @sprite == nil or @sprite.x == @new_x
      slide_speed = 5 + ((@sprite.x - @new_x).abs / 5)      
      @sprite.x -= slide_speed ; @sprite.x = @new_x if @sprite.x < @new_x
  end
  
end

#==============================================================================
# Blitz Commands
#==============================================================================
class Blitz_Commands
  
 #--------------------------------------------------------------------------
 # ● Update Command
 #--------------------------------------------------------------------------       
 def update_command
     return if @end
     if Input.trigger?(Input::X) ; check_command(0)
     elsif Input.trigger?(:Z) ; check_command(1)
     elsif Input.trigger?(:Y) ; check_command(2)
     elsif Input.trigger?(:A) ; check_command(3)
     elsif Input.trigger?(:C) ; check_command(4)
     elsif Input.trigger?(:B) ; check_command(5)
     elsif Input.trigger?(:L) ; check_command(6)
     elsif Input.trigger?(:R) ; check_command(7)        
     elsif Input.trigger?(:RIGHT) ; check_command(8)
     elsif Input.trigger?(:LEFT) ; check_command(9)
     elsif Input.trigger?(:DOWN) ; check_command(10)
     elsif Input.trigger?(:UP) ; check_command(11)
     end   
 end  
   
 #--------------------------------------------------------------------------
 # ● command_list_check
 #--------------------------------------------------------------------------       
 def command_list_check(command) 
     case command
         when "A" ; @com = 0  
         when "D" ; @com = 1  
         when "S" ; @com = 2
         when "Shift" ; @com = 3
         when "Z" ; @com = 4
         when "X" ; @com = 5
         when "Q" ; @com = 6
         when "W" ; @com = 7            
         when "Right" ; @com = 8
         when "Left" ; @com = 9
         when "Down" ; @com = 10
         when "Up" ; @com = 11
         else ; @com = 12           
     end 
 end   
 
 #--------------------------------------------------------------------------
 # ● check_command
 #--------------------------------------------------------------------------            
 def check_command(com)
   bypass = MOG_BLITZ_COMMANDS::DEBUG
     if com != -1
        right_input = false
        @chain_command.each_with_index do |i, index|
        if index == @com_index || bypass
           command_list_check(i) ; right_input = true if (@com == com || bypass)
        end end
     else  
       command_list_check(@com_index) ; right_input = true
     end  
     if right_input 
        next_command
     else  
        wrong_command(0)
     end  
 end  
   
 #--------------------------------------------------------------------------
 # ● Next Command
 #--------------------------------------------------------------------------            
 def next_command   
     @flash.opacity = 255 ; @flash_type = 0 ; @com_index += 1   
     Audio.se_play("Audio/SE/" + RIGHT_SE, 70, 100)
     refresh_button ; refresh_flash
     if @com_index == @chain_command.size || $game_variables[13] == 1
        @end = true ; @skill_name.bitmap.clear
        @skill_name.bitmap.draw_text(0,0,200,32,BLITZ_WORDS[2].to_s,1)
        @icon_sprite.visible = false ; $game_temp.blitz_commands[0] = true
     end
 end     
 
 #--------------------------------------------------------------------------
 # ● wrong_command
 #--------------------------------------------------------------------------              
 def wrong_command(type)
     Audio.se_play("Audio/SE/" + WRONG_SE, 80, 100) ; @flash.opacity = 255
     @flash_type = 1 ;@skill_name.bitmap.clear ; @end = true
     wname = type == 0 ? BLITZ_WORDS[0] : BLITZ_WORDS[1]
     $game_temp.blitz_commands[0] = false
     @skill_name.bitmap.draw_text(0,0,200,32,wname.to_s,1)
     @icon_sprite.visible = false ; refresh_flash
 end
   
end