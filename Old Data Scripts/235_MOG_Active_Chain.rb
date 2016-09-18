#tag: skill
#==============================================================================
# +++ MOG - Active Chain Commands (v3.3) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Permite combinar (Linkar) ataques consecutivos através do uso de
# sequência de botões.
#==============================================================================
# Arquivos necessários. Graphics/System/
#
# Chain_Command.png
# Chain_Battle_Layout.png
# Chain_Battle_Meter.png
#
#==============================================================================
# UTILIZAÇÃO
#==============================================================================
# No banco de dados use o sequinte comentário para linkar as ações.
#
# <Chain Action = X>
#
# X - ID da habilidade.
#==============================================================================

#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v3.3 - Melhoria na compatibilidade com MOG Battle Camera
# v3.2 - Compatibilidade com MOG Sprite Actor.
# v3.1 - Compatibilidade com MOG Battle Camera.
# v3.0 - Adição de comandos aleatórios.
# v2.9 - Correção do bug de não ocultar a janela com MOG ATB.
# v2.8 - Melhoria na codificação.
#==============================================================================

$imported = {} if $imported.nil?
$imported[:mog_active_chain] = true

module MOG_CHAIN_ACTIONS
 #=============================================================================
 # CHAIN_ACTIONS = { SKILL_ID => [COMMAND] }
 #
 # SKILL_ID = ID da habilidade no banco de dados.
 # COMMANDS = Defina aqui a sequência de botões. 
 #            (Para fazer a sequência use os comandos abaixo)   
 #  
 # "Down" ,"Up" ,"Left" ,"Right" ,"Shift" ,"D" ,"S" ,"A" ,"Z" ,"X" ,"Q" ,"W",
 # "Random"
 #
 # Exemplo de utilização
 #
 # CHAIN_SWITCH_COMMAND = { 
 # 25=>["Down","D","S","Right"],
 # 59=>["Down","Up","Left","Right","Shift","D","S","A","Z","X","Q","W"],
 # 80=>["Shift","D"]
 # } 
 #==============================================================================  
 DEBUG = true #right input nomatter what
 CHAIN_ACTIONS = {
    23 => ["Z"],
    
    27 => ["Down","Down","A"],
    28 => ["Left","Down","Right","Down","Left","A","Z"],
    29 => ["Up","Down","Right","S","Down","Left","W","Shift","Shift","A"],
    30 => ["Right","Down","Left","Right","Down","Left","Up","W","W","W","Down","Down","A","Z","X"],
    
    81 => ["Down","Left","Right","Z"],
    82 => ["Down","Down","Left","Right","Right","A","A","Z"],
    83 => ["Down","Right","Down","Left","W","X","Down","Left","X","A","A"],
    84 => ["Down","Left","Right","Down","Left","Z","A","A","S","Left","Right","Q","Q","A","Down","Z","X","A","A","S"],
    
    129 => ["Left","Right","Z"],
    130 => ["Up","Up","Down","Down","Left","Left","Right","Right","Z","Z","X","A","Shift","Down","Z","Up","Down","Shift"],
    131 => ["Down","Left","Up","Right","X","Z","Z"],
    132 => ["Up","Down","Q","Down","Z","Down","X","Left","Right","A","Up","S"],
    
    160 => ["Up","Down","X"],
    161 => ["Up","Down","Up","Down","Up","Down","Up","Down","Up","Down"],
    162 => ["Z","Z","A","X","S","S","W","Q","A","A","Shift","Z","W","S","Shift","Q","A","A","X","S",],
    163 => ["Up","Down","Up","Down","Left","Left","Right","Right","Up","Down","Up","Down","Left","Left","Right","Right","Random","Random","Random","Random","Random","Random","Random","Random",],
    
    225 => ["Down","A","Left",],
    226 => ["Up","Right","Q","Shift","X","S","A","Right","Q","S","X"],
    227 => ["Up","Q","Down","Shift","W"],
    228 => ["Left","Up","Right","Down","Z","Left","Up","Right","Down","X","Left","Up","Right","Down","A","Left","Up","Right","Down","S","Left","Up","Right","Down","Q","Left","Up","Right","Down","W"],
    
    340 => ["Down","Left","Z"],
    341 => ["Down","Down","A","S",],
    342 => ["Down","Right","Down","Left","X",],
    343 => ["Right","Down","Left","Up","A","Down","Z"],
    
    233 => ["Random","Random","Random","Random","Random",],
    232 => ["Random","Random","Random","Random","Random",],
    
    42 => ["Down","S","Up","A","Left"],
    43 => ["X","W","X","W","Shift"],
    46 => ["Z","S","Down","X","X","Right","Right","Shift","Shift","X","Left","S"],
    
 }  
 #Definição dos comandos aleatórios.
 RANDOM_KEYS = ["Left","Right","Up","Down","D","S","A","Z","X"]
 #Definição padrão do tempo limite para pressionar o botão.
 CHAIN_DEFAULT_INPUT_DURATION = 60 #60 = 1s
 #Definição do tempo limite para pressionar o botão.
 CHAIN_INPUT_DURATION = {
    27 => 50,
    28 => 40, 
    29 => 30,
    30 => 20,
    
    81 => 50,
    82 => 40, 
    83 => 30,
    84 => 20,
 
    129 => 50,
    130 => 40,
    131 => 30,
    132 => 20,
    
    160 => 50,
    161 => 40,
    162 => 30,
    163 => 30,
    
    225 => 60,
    226 => 25,
    227 => 15,
    228 => 15,
    
    340 => 50,
    341 => 40,
    342 => 30,
    343 => 20,
    
    233 => 30,
    232 => 30,
    
 }
 
 #Som ao acertar. 
 CHAIN_RIGHT_SE = "Chime1"
 #Som ao errar.
 CHAIN_WRONG_SE = "Buzzer1"
 #Definição do som ao ativar o sistema de chain.
 CHAIN_START_SE = "Open1"
 #Definição da posição do botão.
 CHAIN_SPRITE_POSITION = [0,-15]
 #Posição do layout do medidor.
 CHAIN_LAYOUT_POSITION = [1,-7]
 #Posição do medidor de tempo.
 CHAIN_METER_POSITION = [0,-6]
 #Posição do Ícone
 CHAIN_ICON_POSITION = [0,-32]
 #Definição da palavra Chain.
 CHAIN_COMMAND_WORD = "Chain Action!"
 #Definição das palavras de erro.
 CHAIN_MISSED_WORDS = ["Missed!", "Timeover"]
 #Definição da posição da palavra.
 CHAIN_COMMAND_WORD_POSITION = [0,0]
 #Definição do tamanho da fonte
 CHAIN_WORD_FONT_SIZE = 20
 #Definição da cor da fonte
 CHAIN_WORD_FONT_COLOR = Color.new(255,255,255) 
 #Prioridade do sprite.
 CHAIN_SPRITE_Z = 150
end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
  attr_accessor :chain_actions
  attr_accessor :active_chain
  attr_accessor :chain_ot
  attr_accessor :chain_action_phase
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------      
  alias mog_chain_actions_initialize initialize
  def initialize
      @chain_actions = [0,0,0,false] ; @active_chain = false
      @chain_action_phase = false
      mog_chain_actions_initialize
  end
  
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Use Item
  #--------------------------------------------------------------------------  
  alias mog_chain_actions_use_item use_item
  def use_item
      prepare_chain_command if can_use_chain_commands?
      mog_chain_actions_use_item
      execute_chain_actions if can_use_chain_commands?
  end  
  
  #--------------------------------------------------------------------------
  # ● Can Use Chain Commands
  #--------------------------------------------------------------------------  
  def can_use_chain_commands?
      return false if @subject == nil
      return false if !@subject.is_a?(Game_Actor)
      return false if @subject.restriction != 0
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Prepare Chain Commands
  #--------------------------------------------------------------------------  
  def prepare_chain_command
      @chain_skill_original = @subject.current_action.item rescue nil
      if $game_temp.chain_ot == nil and @subject.is_a?(Game_Actor)
         targets = @subject.current_action.make_targets.compact
         $game_temp.chain_ot = targets[0]
      end
      check_chain_targets  
  end
      
  #--------------------------------------------------------------------------
  # ● Check Chain Command Position
  #--------------------------------------------------------------------------      
  def check_chain_command_position
      scx = $game_temp.chain_ot.screen_x rescue nil
      return if scx == nil
      if $game_temp.chain_ot != nil and !$game_temp.chain_ot.dead?
         $game_temp.chain_actions = [$game_temp.chain_ot.screen_x,$game_temp.chain_ot.screen_y,true]
      end   
  end
      
  #--------------------------------------------------------------------------
  # ● Check Chain Targets
  #--------------------------------------------------------------------------    
  def check_chain_targets
      return if @subject == nil or $game_temp.chain_ot == nil
      if [1,7,9,10,11].include?(@subject.current_action.item.scope)
         @pre_target = $game_temp.chain_ot ; @pre_target_hp = $game_temp.chain_ot.hp
      else   
         @pre_target = nil ; @pre_target_hp = nil
      end  
  end
 
  #--------------------------------------------------------------------------
  # ● Execute Chain Actions
  #--------------------------------------------------------------------------  
  def execute_chain_actions
      $game_temp.active_chain = false
      return if !can_execute_chain_actions_base?
      check_chain_command_position
      skill = @subject.current_action.item rescue nil
      skill = @chain_skill_original rescue nil
      action_id = skill.note =~ /<Chain Action = (\d+)>/i ? $1.to_i : nil rescue nil
      return if action_id == nil or action_id < 1      
      
      #check if skill learned before execute chain action
      return if !@subject.skills.include?($data_skills[action_id])
      #check if skill usable
      return if !@subject.usable?($data_skills[action_id])
      
      chain_command_sequence = MOG_CHAIN_ACTIONS::CHAIN_ACTIONS[action_id].dup rescue nil
      $game_temp.chain_actions[2] = action_id    
      
      if can_execute_chain_sequence?(chain_command_sequence,action_id)
         chain_act_before_action if @chain_command == nil
         chain_sq = Chain_Actions.new(chain_command_sequence,$game_temp.chain_actions)
         loop do
              $game_temp.chain_action_phase = true
              (chain_sq.update($game_temp.chain_ot) ; Input.update) unless @spriteset.animation?
              $game_temp.active_chain = true ; chain_sq.update_skill_name
              @spriteset.update ; Graphics.update ; update_info_viewport
              break if chain_sq.phase == 9
         end
         @subject.wp_animation = [true,chain_sq.success] if $imported[:mog_sprite_actor]
         action_id = nil if !chain_sq.success or $game_temp.chain_ot.dead?
         chain_sq.dispose ; set_chain_skill(action_id) if action_id != nil         
      end
      $game_temp.active_chain = false ; $game_temp.chain_ot = nil
      $game_temp.chain_action_phase = false
  end

  #--------------------------------------------------------------------------
  # ● Chain Act Before Action
  #--------------------------------------------------------------------------  
  def chain_act_before_action
      @chain_command = true ; @bb_cursor
      if $imported[:mog_battle_cursor]
         @bb_cursor =  $game_temp.battle_cursor[2]
         $game_temp.battle_cursor[2] = false
      end
      if $imported[:mog_menu_cursor]    
         @chain_curor_x = $game_temp.menu_cursor[2] 
         $game_temp.menu_cursor[2] = -999
         force_cursor_visible(false)
      end
      if $imported[:mog_atb_system]
         record_window_data if @wd_rec.nil?
         hide_base_window
         @wd_rec = true
      end       
  end     
  
  #--------------------------------------------------------------------------
  # ● Turn End
  #--------------------------------------------------------------------------  
  alias mog_chain_command_process_action_end process_action_end
  def process_action_end
      mog_chain_command_process_action_end
      chain_act_after_action
  end
  
  #--------------------------------------------------------------------------
  # ● Chain Act After ACtion
  #--------------------------------------------------------------------------  
  def chain_act_after_action
      @chain_skill_original = nil
      $game_temp.chain_ot = nil
      return if @chain_command == nil
      restore_window_data if $imported[:mog_atb_system]
      $game_temp.menu_cursor[2] = @chain_curor_x if $imported[:mog_menu_cursor]
      $game_temp.battle_cursor[2] = @bb_cursor if @bb_cursor != nil
      @chain_command = nil      
  end    
  
  #--------------------------------------------------------------------------
  # ● Set Chain Skill
  #--------------------------------------------------------------------------  
  def set_chain_skill(action_id)
      return if action_id == nil
      @subject.input.set_skill(action_id) 
      $game_temp.chain_actions = [0,0,0,false] ; execute_action    
  end
  
  #--------------------------------------------------------------------------
  # ● Can Execute Chain Sequence?
  #--------------------------------------------------------------------------  
  def can_execute_chain_sequence?(chain_command_sequence = nil,action_id = nil)
      return false if chain_command_sequence == nil
      skill = $data_skills[action_id] rescue nil
      return false if skill == nil
      return false if $game_temp.chain_ot == nil or $game_temp.chain_ot.dead?
      if [9,10].include?(skill.scope)
         $game_party.battle_members.each do |i| return true if i.dead? end
         return false
      end
      return true
  end

  #--------------------------------------------------------------------------
  # ● Can Execute Chain Actions Base
  #--------------------------------------------------------------------------    
  def can_execute_chain_actions_base?
      return false if @subject == nil or @subject.dead?
      return false if $game_temp.chain_ot == nil or $game_temp.chain_ot.dead?
      return false if @subject.is_a?(Game_Enemy)
      return false if @subject.current_action == nil
      @subject.states.each do |i| return false if i.restriction > 0 end
      return false if $game_party.members.empty?
      return false if $game_party.all_dead?
      return false if $game_troop.all_dead?
      if @pre_target != nil and $game_temp.chain_ot.hp == @pre_target_hp
         return false if $game_temp.chain_ot.result.missed
         return false if $game_temp.chain_ot.result.evaded
      end
      return true 
  end
   
  #--------------------------------------------------------------------------
  # ● Turn End
  #--------------------------------------------------------------------------    
  alias mog_chain_command_turn_end turn_end
  def turn_end
      mog_chain_command_turn_end 
      @wd_rec = nil
  end
    
end
  
#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
  
  attr_accessor :cache_active_chain
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  alias mog_active_chain_initialize initialize
  def initialize
      mog_active_chain_initialize
      cache_act_chain
  end  
  
  #--------------------------------------------------------------------------
  # ● Cache Act Chain
  #--------------------------------------------------------------------------      
  def cache_act_chain
      @cache_active_chain = []
      @cache_active_chain.push(Cache.system("IconSet"))
      @cache_active_chain.push(Cache.system("Chain_Battle_Layout"))
      @cache_active_chain.push(Cache.system("Chain_Battle_Meter"))
      @cache_active_chain.push(Cache.system("Chain_Battle_Command"))
  end
  
end

#==============================================================================
# ■ Spriteset Battle
#==============================================================================
class Spriteset_Battle
   
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  alias mog_active_chain_commands_initialize initialize
  def initialize
      $game_temp.cache_act_chain ; $game_temp.active_chain = false
      $game_temp.chain_ot = nil
      mog_active_chain_commands_initialize      
  end
end    

#==============================================================================
# ■ Chain Actions
#==============================================================================
class Chain_Actions
  
  include MOG_CHAIN_ACTIONS
  
  attr_accessor :phase
  attr_accessor :success
   
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  def initialize(sequence,chain_temp)
      $game_temp.chain_actions[3] = true
      @chain_command_original = sequence.dup
      @chain_command = sequence
      random_sequence
      @x = chain_temp[0] + CHAIN_SPRITE_POSITION[0]
      @y = chain_temp[1] + CHAIN_SPRITE_POSITION[1]
      @y = (Graphics.height - 36) if @y > (Graphics.height - 36)
      @y = 0 if @y < 0
      @skill = $data_skills[chain_temp[2]]
      @skillname = @skill.name

      if CHAIN_INPUT_DURATION[chain_temp[2]] != nil
         @duration = [CHAIN_INPUT_DURATION[chain_temp[2]],CHAIN_INPUT_DURATION[chain_temp[2]]]
      else   
         @duration = [CHAIN_DEFAULT_INPUT_DURATION, CHAIN_DEFAULT_INPUT_DURATION]
      end  
      @phase = 0 ; @success = false ; @com = 0 ; @com_index = 0
      @initial_wait = 1 ; @wrong_commnad = [false,0,0]
      Audio.se_play("Audio/SE/" + CHAIN_START_SE, 100, 100) rescue nil
      create_button_sprite ; create_skill_name ; create_icon ; create_meter
      set_opacity(0)
  end
  
  #--------------------------------------------------------------------------
  # ● Random Sequence
  #--------------------------------------------------------------------------    
  def random_sequence
      @chain_command_original.each_with_index do |c, i|
      next if c != "Random"
      k = rand(RANDOM_KEYS.size) ; @chain_command[i] = RANDOM_KEYS[k]
      end
  end

  #--------------------------------------------------------------------------
  # ● Create Icon
  #--------------------------------------------------------------------------      
  def create_icon
      @icon_image = $game_temp.cache_active_chain[0]
      @icon_sprite = Sprite.new ; @icon_sprite.bitmap = Bitmap.new(24,24)
      @icon_sprite.z = CHAIN_SPRITE_Z + 1
      @org_x2 = @x - 12 +  CHAIN_ICON_POSITION[0] - @center
      @icon_sprite.x = @org_x2 - 50
      @icon_sprite.y = @y +  CHAIN_ICON_POSITION[1]     
      icon_rect = Rect.new(@skill.icon_index % 16 * 24, @skill.icon_index / 16 * 24, 24, 24)
      @icon_sprite.bitmap.blt(0,0, @icon_image, icon_rect)
  end

  #--------------------------------------------------------------------------
  # ● Create Meter
  #--------------------------------------------------------------------------        
  def create_meter
      @meter_layout = Sprite.new
      @meter_layout.bitmap = $game_temp.cache_active_chain[1]
      @meter_layout.z = CHAIN_SPRITE_Z
      @meter_layout.x = @x - (@meter_layout.width / 2) + CHAIN_LAYOUT_POSITION[0]
      @meter_layout.y = @y + CHAIN_LAYOUT_POSITION[1]
      @meter_image = $game_temp.cache_active_chain[2]
      @meter_cw = @meter_image.width ; @meter_ch = @meter_image.height
      @meter = Sprite.new
      @meter.bitmap = Bitmap.new(@meter_image.width, @meter_image.height)
      @meter.z = CHAIN_SPRITE_Z + 1
      @meter.x = @x - (@meter_image.width / 2) + CHAIN_METER_POSITION[0]
      @meter.y = @y + CHAIN_METER_POSITION[1]
      @meter.visible = false ; @meter_layout.visible = false ; update_meter
  end
  
  #--------------------------------------------------------------------------
  # ● Update Meter
  #--------------------------------------------------------------------------          
  def update_meter
      return if @meter == nil
      @meter.bitmap.clear ; range = @meter_cw * @duration[0] / @duration[1]
      m_scr = Rect.new(0,0,range,@meter_ch )
      @meter.bitmap.blt(0,0, @meter_image ,m_scr)
  end
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------      
  def create_skill_name
      @skill_name = Sprite.new ; @skill_name.bitmap = Bitmap.new(200,32)
      @skill_name.bitmap.font.size = CHAIN_WORD_FONT_SIZE
      @skill_name.bitmap.font.color = CHAIN_WORD_FONT_COLOR
      @skill_name.z = CHAIN_SPRITE_Z 
      @skill_name.y = @y - 32 + CHAIN_COMMAND_WORD_POSITION[1]
      refresh_skill_name
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Skill Name
  #--------------------------------------------------------------------------        
  def refresh_skill_name
      cm = @skillname.to_s.split(//).size
      @center = ((200 / @skill_name.bitmap.font.size) * cm / 2) + 5
      @org_x = @x - (@button_cw / 2) - 85 + CHAIN_COMMAND_WORD_POSITION[0]
      @skill_name.x = @org_x - 50
      @skill_name.bitmap.draw_text(0,0,200,32,@skillname.to_s,1)  
  end
      
  #--------------------------------------------------------------------------
  # ● Create Button Sprite
  #--------------------------------------------------------------------------      
  def create_button_sprite
      @button_image = $game_temp.cache_active_chain[3]
      @button_cw = @button_image.width / 13 ; @button_ch = @button_image.height
      @button_sprite = Sprite.new
      @button_sprite.bitmap = Bitmap.new(@button_cw,@button_ch)
      @button_sprite.z = CHAIN_SPRITE_Z + 1
      @button_sprite.ox = @button_cw / 2 ; @button_sprite.oy = @button_ch / 2
      @button_sprite_oxy = [@button_sprite.ox,@button_sprite.oy]
      @button_sprite.x = @x + @button_sprite.ox - (@button_cw / 2)
      @button_sprite.y = @y + @button_sprite.oy      
  end

  #--------------------------------------------------------------------------
  # ● Refresh Button Command
  #--------------------------------------------------------------------------        
  def refresh_button_command
      return if @button_sprite == nil
      @duration[0] = @duration[1]
      command_list_check(@chain_command[@com_index])  
      @button_sprite.bitmap.clear
      button_scr = Rect.new(@com * @button_cw , 0,@button_cw,@button_ch)
      @button_sprite.bitmap.blt(0,0,@button_image,button_scr)
      @button_sprite.zoom_x = 1.3 ; @button_sprite.zoom_y = 1.3    
      @button_sprite.opacity = 255
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------      
  def dispose
      dispose_button ; dispose_meter ; dispose_name ; dispose_icon_sprite
      $game_temp.chain_actions[3] = false ; $game_temp.active_chain = false
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
  # ● Dispose Button 
  #--------------------------------------------------------------------------        
  def dispose_button 
      return if @button_sprite == nil 
      @button_sprite.bitmap.dispose ; @button_sprite.dispose ; @button_sprite = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Meter
  #--------------------------------------------------------------------------          
  def dispose_meter
      return if @meter_layout == nil
      @meter_layout.dispose ; @meter_layout = nil
      @meter.bitmap.dispose ; @meter.dispose
  end  
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------      
  def update(battler)
      if @initial_wait > 0
         @initial_wait -= 1
         if @initial_wait == 0 
            refresh_button_command ; @meter.visible = true
            @meter_layout.visible = true        
            set_opacity(0)
         end
         return  
      end
      if @wrong_commnad[0]
         update_fade_command
         return
      else   
         update_opacity         
      end      
      update_command ; update_sprite_button ; update_time ; update_meter
      update_battle_camera if oxy_camera?(battler)
  end

  #--------------------------------------------------------------------------
  # ● OXY_CAMERA
  #--------------------------------------------------------------------------               
  def oxy_camera?(battler) 
      return false if battler == nil
      return false if $imported[:mog_battle_camera] == nil
      if battler.is_a?(Game_Actor)
         return false if $imported[:mog_battle_hud_ex] and SceneManager.face_battler?
      end
      return true
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Battle Camera
  #--------------------------------------------------------------------------               
  def update_battle_camera
      @meter_layout.ox = $game_temp.viewport_oxy[0]
      @meter_layout.oy = $game_temp.viewport_oxy[1]
      @meter.ox = $game_temp.viewport_oxy[0]
      @meter.oy = $game_temp.viewport_oxy[1] 
      @skill_name.ox = $game_temp.viewport_oxy[0]
      @skill_name.oy = $game_temp.viewport_oxy[1]
      @button_sprite.ox = $game_temp.viewport_oxy[0] + @button_sprite_oxy[0]
      @button_sprite.oy = $game_temp.viewport_oxy[1] + @button_sprite_oxy[1]
      @icon_sprite.ox = $game_temp.viewport_oxy[0]
      @icon_sprite.oy = $game_temp.viewport_oxy[1]
  end  
  
  #--------------------------------------------------------------------------
  # ● Set Opacity
  #--------------------------------------------------------------------------         
  def set_opacity(opc)
      @meter_layout.opacity = opc
      @meter.opacity = opc
      @skill_name.opacity = opc
      @button_sprite.opacity = opc
      @icon_sprite.opacity = opc
  end      
  
  #--------------------------------------------------------------------------
  # ● Update Opacity
  #--------------------------------------------------------------------------         
  def update_opacity
      @meter_layout.opacity += 75
      @meter.opacity += 75
      @skill_name.opacity += 75
      @button_sprite.opacity += 75
      @icon_sprite.opacity += 75
  end    
    
  
  #--------------------------------------------------------------------------
  # ● Update Skill Name
  #--------------------------------------------------------------------------         
  def update_fade_command
      fade_speed = 6
      @skill_name.opacity -= fade_speed ; @meter.opacity -= fade_speed
      @meter_layout.opacity -= fade_speed ; @icon_sprite.opacity -= fade_speed
      @button_sprite.opacity -= fade_speed * 2 ; missed if @meter.opacity == 0
  end
  
  #--------------------------------------------------------------------------
  # ● Update Skill Name
  #--------------------------------------------------------------------------        
  def update_skill_name
      return if @skill_name == nil
      if @skill_name.x < @org_x
         @skill_name.x += 3 ; @icon_sprite.x += 3 
         if @skill_name.x > @org_x
            @skill_name.x = @org_x ; @icon_sprite.x = @org_x2
         end   
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Update Time
  #--------------------------------------------------------------------------
  def update_time
      return if @button_sprite == nil
      @duration[0] -= 1 if @duration[0] > 0
      wrong_command(1) if @duration[0] == 0
  end
  
  #--------------------------------------------------------------------------
  # ● Update Sprite Button
  #--------------------------------------------------------------------------        
  def update_sprite_button
      return if @button_sprite == nil
      if @button_sprite.zoom_x > 1.00
         @button_sprite.zoom_x -= 0.05
         @button_sprite.zoom_x = 1.00 if @button_sprite.zoom_x < 1.00
      end
      @button_sprite.zoom_y = @button_sprite.zoom_x
  end  

 #--------------------------------------------------------------------------
 # ● Update Command
 #--------------------------------------------------------------------------       
 def update_command
     if Input.trigger?(:X) ; check_command(0)
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
         when "Left" ;  @com = 9
         when "Down" ;  @com = 10
         when "Up"  ;   @com = 11         
         else ; @com = 12           
     end 
 end   
 
 #--------------------------------------------------------------------------
 # ● check_command
 #--------------------------------------------------------------------------            
 def check_command(com)
     if com != -1
        right_input = false
        @chain_command.each_with_index do |i, index|
           if index == @com_index || MOG_CHAIN_ACTIONS::DEBUG == true
              command_list_check(i) ; right_input = true if @com == com || MOG_CHAIN_ACTIONS::DEBUG == true
           end          
        end
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
     @com_index += 1   
     Audio.se_play("Audio/SE/" + CHAIN_RIGHT_SE, 100, 100)
     if @com_index == @chain_command.size
        @phase = 9 ; @success = true 
        return
     end  
     refresh_button_command
 end     
 
 #--------------------------------------------------------------------------
 # ● wrong_command
 #--------------------------------------------------------------------------              
 def wrong_command(type = 0)
     @wrong_commnad[0] = true ; @wrong_commnad[1] = type
     @skill_name.bitmap.clear
     Audio.se_play("Audio/SE/" + CHAIN_WRONG_SE, 100, 100)        
     wname = type == 0 ? CHAIN_MISSED_WORDS[0] : CHAIN_MISSED_WORDS[1]
     @skill_name.bitmap.draw_text(0,0,200,32,wname.to_s,1)
 end     
  
 #--------------------------------------------------------------------------
 # ● missed
 #--------------------------------------------------------------------------               
 def missed
     @success = false  ; @phase = 9  
 end
 
end