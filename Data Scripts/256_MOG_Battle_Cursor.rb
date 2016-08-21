#==============================================================================
# +++ MOG - Battle Cursor (3.3) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Sistema de cursor animado de batalha nos sprites dos battlers.
#==============================================================================
# Arquivo necessário. (Graphics/System)
# 
# Battle_Cursor.png
# Battle_Cursor2.png *(necessário o script Scope EX)
#
#==============================================================================
# NOTA - Deixe este script abaixo do script Battler Motion.
#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# (3.3) - Correção do bug de não atualizar a index quando o battler é morto.
# (3.2) - Melhoria de compatibilidade com Scope EX
# (3.1) - Melhoria na posição dos battler aliados mortos. (MOG Sprite Actor)
# (3.0) - Correção do cursor não acompanhar a posição do battler em movimento.
#       - Apresentar o cursor na seleção de todos os alvos.
#==============================================================================
$imported = {} if $imported.nil?
$imported[:mog_battle_cursor] = true

#==============================================================================
# ■ CURSOR SETTING
#==============================================================================
module MOG_BATTLE_CURSOR
  #Definição da posição do cursor em relação ao alvo.
  CURSOR_POSITION = [0, 0]
  #Definição da posição do nome do alvo.
  CURSOR_NAME_POSITION = [-10, 35]
  #Ativar efeito deslizar.
  CURSOR_SLIDE_EFFECT = true
  #Ativar animação de levitação.
  CURSOR_FLOAT_EFFECT = true
  #Definição da prioridade do cursor.
  CURSOR_Z = 155
  #Posição do cursor Secundário.
  TARGET_CURSOR_2_POS = [0, -48]
  #Ativar animação de zoom.
  TARGET_CURSOR_2_ZOOM_EFFECT = false
end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp 
  
  attr_accessor :battle_cursor
  attr_accessor :battle_cursor_data
  attr_accessor :target_skill
  attr_accessor :battle_end 
  attr_accessor :sprite_visible
  attr_accessor :battle_cursor_need_refresh
  attr_accessor :battle_cursor_scope_refresh
  attr_accessor :battle_cursor_target
  attr_accessor :target_data
  attr_accessor :target_cursor_need_refresh
  attr_accessor :target_window_active
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias mog_battle_cursor_initialize initialize
  def initialize
      @battle_cursor = [0,0,false,""] ; @target_skill = [] ; @battle_end = false
      @battle_cursor_need_refresh = [false,false] ; @battle_cursor_target = [nil,nil]
      @target_data = [nil,nil] ; @target_cursor_need_refresh = false 
      @target_window_active = [false,false] ; @battle_cursor_scope_refresh = false
      mog_battle_cursor_initialize
  end  
  
  #--------------------------------------------------------------------------
  # ● Clear Target Temp
  #--------------------------------------------------------------------------    
  def clear_target_temp
      $game_party.members.each {|t| t.target_temp = false } rescue nil
      $game_troop.members.each {|t| t.target_temp = false } rescue nil   
      @target_data = [nil,nil] ; @battle_cursor_target = [nil,nil]
  end
    
  #--------------------------------------------------------------------------
  # ● Sprite Visible
  #--------------------------------------------------------------------------    
  def sprite_visible
      return false if $game_message.visible
      return false if $game_temp.battle_end
      return true
  end
  
end

#==============================================================================
# ■ Spriteset Battle Cursor
#==============================================================================
class Sprite_Battle_Cursor < Sprite
  include MOG_BATTLE_CURSOR
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------        
  def initialize(viewport = nil)
      super(viewport) 
      $game_temp.battle_cursor = [0,0,false,""] ; $game_temp.battle_end = false
      self.bitmap = Cache.system("Battle_Cursor")
      self.visible = $game_temp.battle_cursor[2] ; self.z = CURSOR_Z
      @cw = self.bitmap.width / 2 ; @ch = [self.bitmap.height, Graphics.height - self.bitmap.height]
      @cursor_name = Sprite.new ; @cursor_name.bitmap = Bitmap.new(120,32)
      @cursor_name.z = self.z + 1 ; @cursor_name.bitmap.font.size = 16
      @cursor_name_enemy = $game_temp.battle_cursor[3] ; @cs_x = 0
      @cursor_name_position = [CURSOR_NAME_POSITION[0] ,CURSOR_NAME_POSITION[1]]
      @cursor_float = [0,0] ;  refresh_cursor_name
      @face_battler = SceneManager.face_battler? if $imported[:mog_battle_hud_ex]
      @cs_x = (15 * MOG_SPRITE_ACTOR::SPRITE_ZOOM).truncate if $imported[:mog_sprite_actor]  
  end

  #--------------------------------------------------------------------------
  # ● Dispose Sprite
  #--------------------------------------------------------------------------          
  def dispose
      super
      dispose_sprite_cursor
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Sprite Cursor
  #--------------------------------------------------------------------------            
  def dispose_sprite_cursor
      @cursor_name.bitmap.dispose ; @cursor_name.dispose
      self.bitmap.dispose ; $game_temp.clear_target_temp
  end

  #--------------------------------------------------------------------------
  # ● Refresh Cursor Name
  #--------------------------------------------------------------------------              
  def refresh_cursor_name
      @cursor_name_enemy = $game_temp.battle_cursor[3]
      @cursor_name.bitmap.clear
      @cursor_name.bitmap.draw_text(0,0,120,32,@cursor_name_enemy.to_s,1)
  end 

  #--------------------------------------------------------------------------
  # ● Update Sprite Cursor
  #--------------------------------------------------------------------------              
  def update_sprite_cursor
      update_battle_camera_cursor if update_battle_cursor_r?
      if force_hide? ; self.visible = false ; @cursor_name.visible = false ; return ; end
      update_visible ; update_cursor_float_effect ; set_real_position 
      execute_move(0,self.x,$game_temp.battle_cursor[0])
      execute_move(1,self.y,$game_temp.battle_cursor[1] + @cursor_float[1])
      update_sprite_name
      self.visible = false if !$game_temp.sprite_visible
      @cursor_name.opacity = 0 if @cursor_name and !$game_temp.sprite_visible
  end
  
  #--------------------------------------------------------------------------
  # ● Process Cursor Move
  #--------------------------------------------------------------------------
  def process_cursor_move
      return unless cursor_movable?
      last_index = @index
      cursor_move_index(1) if Input.repeat?(:DOWN)
      cursor_move_index(-1) if Input.repeat?(:UP)
      cursor_move_index(1) if Input.repeat?(:RIGHT)
      cursor_move_index(-1) if Input.repeat?(:LEFT)
      
      $game_temp.battle_cursor_data = $game_troop.alive_members[@index]
      $game_temp.battle_cursor_data.sort! { |a,b| a.screen_x <=> b.screen_x }
      
      Sound.play_cursor if @index != last_index
  end
  #--------------------------------------------------------------------------
  # ● Update Battle Cursor
  #--------------------------------------------------------------------------              
  def update_battle_cursor_r?
      return false if $imported[:mog_battle_camera] == nil
      if $imported[:mog_battle_hud_ex] and SceneManager.face_battler? and $game_temp.battle_cursor_[0] != nil
         self.ox = 0 ; self.oy = 0 ; @cursor_name.ox = 0 ; @cursor_name.oy = 0 
         return false 
      end    
      return true
   end   
      
  #--------------------------------------------------------------------------
  # ● Update Battle Camera Cursor
  #--------------------------------------------------------------------------              
  def update_battle_camera_cursor
      self.ox = $game_temp.viewport_oxy[0]
      self.oy = $game_temp.viewport_oxy[1]
      @cursor_name.ox = self.ox
      @cursor_name.oy = self.oy
  end

  #--------------------------------------------------------------------------
  # ● Set Real Position
  #--------------------------------------------------------------------------              
  def set_real_position  
      
      return if $game_temp.target_data == [nil,nil]
      return if $game_temp.battle_cursor_target == [nil,nil]
      #counter = 0
      #for info in $game_temp.battle_cursor_target
      #  counter += 1
      #  next if info.nil?
      #  puts "#{counter}:#{info.name}"
      #end
      #puts "----------------------"
      return 
      
      $game_temp.battle_cursor[0] = $game_temp.target_data[1].x - @cw + CURSOR_POSITION[0]
      #$game_temp.battle_cursor[1] = $game_temp.target_data[1].y + CURSOR_POSITION[1]
      $game_temp.battle_cursor[1] -= ($game_temp.target_data[1].bitmap.height / 2) unless !$game_temp.target_data[1].bitmap
      if $game_temp.target_data[0].is_a?(Game_Actor)
         if $imported[:mog_sprite_actor] and $game_temp.target_data[0].dead? 
            if $game_temp.target_data[0].bact_sprite[5] == 6
               $game_temp.battle_cursor[0] -= @cs_x
            else
               $game_temp.battle_cursor[0] += @cs_x
            end   
         end         
         $game_temp.battle_cursor[1] -= @ch[0] if @face_battler and $game_temp.battle_cursor[1] > @ch[1]
      end      
  end
    
  #--------------------------------------------------------------------------
  # ● Can Move Real Position?
  #--------------------------------------------------------------------------               
  def can_move_real_position?
      return false if $game_temp.battle_cursor_data == nil 
      return false if $game_temp.battle_cursor_data.dead?
      screen_x = $game_temp.battle_cursor_data.screen_x rescue nil
      return false if screen_x == nil
      return true
  end    
      
  #--------------------------------------------------------------------------
  # ● Force Hide
  #--------------------------------------------------------------------------              
  def force_hide?
      return true if $game_temp.battle_cursor == nil
      return true if $game_temp.battle_cursor[0] == nil
      return true if $game_temp.battle_cursor[1] == nil    
      return false
  end
  
  #--------------------------------------------------------------------------
  # ● Update Visible
  #--------------------------------------------------------------------------                
  def update_visible
      $game_temp.battle_cursor_data = nil if !self.visible
      if force_hide_battle_cursor?
         self.visible = false ; return
      end  
      self.visible = $game_temp.battle_cursor[2]
      (self.x = -64 ; self.y = -64) if !self.visible
  end  
  
  #--------------------------------------------------------------------------
  # ● Force Hide Battle Cursor
  #--------------------------------------------------------------------------                
  def force_hide_battle_cursor?
      if $imported[:mog_sprite_actor] and !$game_temp.target_data.nil?
         return true if !$game_temp.target_data[0].bact_sprite_visiblle
      end  
      return true if $imported[:mog_active_chain] and $game_temp.chain_action_phase
      return true if $imported[:mog_atb_system] and BattleManager.actor == nil
      return true if $imported[:mog_blitz_commands] and $game_temp.blitz_commands_phase
      return false
  end
  
  #--------------------------------------------------------------------------
  # ● Update Sprite Name
  #--------------------------------------------------------------------------                
  def update_sprite_name
      return
      return if @cursor_name == nil
      refresh_cursor_name  if @cursor_name_enemy != $game_temp.battle_cursor[3]
      @cursor_name.x = self.x + @cursor_name_position[0]
      @cursor_name.y = self.y + @cursor_name_position[1]
      @cursor_name.opacity = self.opacity ; @cursor_name.visible = self.visible
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Cursor Float Effect
  #--------------------------------------------------------------------------              
  def update_cursor_float_effect
      return if !CURSOR_FLOAT_EFFECT
      @cursor_float[0] += 1
      case @cursor_float[0]
        when 0..20  ; @cursor_float[1] += 1
        when 21..40 ; @cursor_float[1] -= 1
        else
          @cursor_float[0] = 0 ;   @cursor_float[1] = 0
      end        
  end  
  
  #--------------------------------------------------------------------------
  # ● Execute Move
  #--------------------------------------------------------------------------      
  def execute_move(type,cp,np)
      sp = 5 + ((cp - np).abs / 5)
      if cp > np 
         cp -= sp ; cp = np if cp < np
      elsif cp < np 
         cp += sp ; cp = np if cp > np
      end     
       self.x = cp if type == 0 ; self.y = cp if type == 1
  end      
  
end

#==============================================================================
# ■ Spriteset Battle
#==============================================================================
class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------      
  alias mog_battle_cursor_initialize initialize
  def initialize
      mog_battle_cursor_initialize
      create_cursor
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------      
  alias mog_battle_cursor_dispose dispose
  def dispose
      mog_battle_cursor_dispose
      dispose_battle_cursor
  end 
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------          
  alias mog_battle_cursor_update update
  def update
      mog_battle_cursor_update
      update_battle_cursor
  end  
  
  #--------------------------------------------------------------------------
  # ● Create_Cursor
  #--------------------------------------------------------------------------        
  def create_cursor
      return if @battle_cursor != nil
      $game_temp.clear_target_temp ; @battle_cursor = Sprite_Battle_Cursor.new
  end 
  
  #--------------------------------------------------------------------------
  # ● Dispose Cursor
  #--------------------------------------------------------------------------        
  def dispose_battle_cursor
      return if @battle_cursor == nil
      @battle_cursor.dispose ; @battle_cursor = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Battle Cursor
  #--------------------------------------------------------------------------          
  def update_battle_cursor
      return if @battle_cursor == nil
      @battle_cursor.update_sprite_cursor
  end
  
end

#==============================================================================
# ■ Battle Cursor Index
#==============================================================================
module Battle_Cursor_index
  
  include MOG_BATTLE_CURSOR
  
  #--------------------------------------------------------------------------
  # ● Check Index Limit
  #--------------------------------------------------------------------------      
  def check_index_limit
      self.index = 0 if self.index >= item_max
      self.index = (item_max - 1) if self.index < 0
  end      
  
  #--------------------------------------------------------------------------
  # ● Set Cursor Position Enemy
  #--------------------------------------------------------------------------    
  def set_cursor_position_enemy
      return if !self.active
      self.index = 0 if $game_troop.alive_members[self.index].nil?
      @fcursor = nil ; $game_temp.battle_cursor_need_refresh[1] = false
      $game_temp.battle_cursor[0] = $game_troop.alive_members[self.index].screen_x + CURSOR_POSITION[0] rescue nil
      $game_temp.battle_cursor[1] = $game_troop.alive_members[self.index].screen_y + CURSOR_POSITION[1] rescue nil
      $game_temp.battle_cursor[3] = $game_troop.alive_members[self.index].name rescue nil
      $game_temp.battle_cursor_data = $game_troop.alive_members[self.index]
      return if $game_temp.battle_cursor_data == nil
      enable_target_sprites($game_temp.battle_cursor_data.index)
  end

  #--------------------------------------------------------------------------
  # ● Enable Target Sprites
  #--------------------------------------------------------------------------    
  def enable_target_sprites(target_index)  
      return if $game_temp.target_skill.empty?
      if $imported[:mog_atb_system] and !BattleManager.subject.nil?
         $game_temp.battle_cursor_scope_refresh = true
      end   
      $game_temp.clear_target_temp ; battler = $game_temp.target_skill[1]
      type = $game_temp.target_skill[0].is_a?(RPG::Skill) ? 0 : 1
      target_index = $game_temp.battle_cursor_data.index
      battler.make_action_temp($game_temp.target_skill[0].id, target_index,type)      
      targets = battler.action_temp.make_targets.compact
      targets.each {|t| t.target_temp = true }
  end  
    
  #--------------------------------------------------------------------------
  # ● Refresh Scope Targets
  #--------------------------------------------------------------------------    
  def refresh_scope_targets
      targets = battler.action_temp.make_targets.compact
      targets.each {|t| t.target_temp = true }
  end
  
  #--------------------------------------------------------------------------
  # ● Set Cursor Position Actor
  #--------------------------------------------------------------------------    
  def set_cursor_position_actor
      return if !self.active
      self.index = 0 if $game_party.members[self.index].nil?
      @fcursor = nil ; $game_temp.battle_cursor_need_refresh[0] = false
      $game_temp.battle_cursor[0] = $game_party.members[self.index].screen_x + CURSOR_POSITION[0] rescue nil
      $game_temp.battle_cursor[1] = $game_party.members[self.index].screen_y + CURSOR_POSITION[1] rescue nil
      $game_temp.battle_cursor[3] = $game_party.members[self.index].name rescue nil
      $game_temp.battle_cursor_data = $game_party.members[self.index]
      $game_temp.battle_cursor = [0,0,false,0] if $game_temp.battle_cursor[0] == nil
      enable_target_sprites(self.index)
  end  
      
  #--------------------------------------------------------------------------
  # ● Process Cursor Move Index
  #--------------------------------------------------------------------------  
  def cursor_move_index(value = 0)
      self.index += value ;  check_index_limit
  end

end

#==============================================================================
# ■ Window_BattleActor
#==============================================================================
class Window_BattleActor < Window_BattleStatus
  include Battle_Cursor_index
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_battle_cursor_actor_update update
  def update
      pre_index = self.index
      mog_battle_cursor_actor_update
      $game_temp.battle_cursor_target[0] = $game_party.members[self.index]
      $game_temp.battle_cursor_target[0] = nil if !self.active      
      set_cursor_position_actor if refresh_cursor_position?(pre_index)
      $game_temp.target_window_active[0] = self.active
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Cursor Position
  #--------------------------------------------------------------------------  
  def refresh_cursor_position?(pre_index)
      return true if pre_index != self.index 
      return true if @fcursor 
      return true if $game_temp.battle_cursor_need_refresh[0]
      return false
  end

  #--------------------------------------------------------------------------
  # ● Show
  #--------------------------------------------------------------------------
  alias mog_battle_cursor_show show
  def show
      if @info_viewport
         set_cursor_position_actor ; $game_temp.battle_cursor[2] = true
         @fcursor = true
      end
      mog_battle_cursor_show
  end

  #--------------------------------------------------------------------------
  # ● Hide
  #--------------------------------------------------------------------------
  alias mog_battle_cursor_hide hide
  def hide
      $game_temp.battle_cursor[2] = false if @info_viewport
      if $game_temp.target_window_active[1] == false
         ($game_temp.clear_target_temp ; $game_temp.target_skill.clear) unless self.active
      end
      mog_battle_cursor_hide
  end  
  
  #--------------------------------------------------------------------------
  # ● Process Cursor Move
  #--------------------------------------------------------------------------
  def process_cursor_move
      return unless cursor_movable?
      last_index = @index
      cursor_move_index(1) if Input.repeat?(:DOWN)
      cursor_move_index(-1) if Input.repeat?(:UP)
      cursor_move_index(1) if Input.repeat?(:RIGHT)
      cursor_move_index(-1) if Input.repeat?(:LEFT)
      $game_temp.battle_cursor_data = $game_party.members[self.index]
      Sound.play_cursor if @index != last_index
  end
  
end

#==============================================================================
# ■ Game Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  attr_accessor :index 
end

#==============================================================================
# ■ Game Troop
#==============================================================================
class Game_Troop < Game_Unit
    
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias mog_battle_cursor_setup setup
  def setup(troop_id)
      mog_battle_cursor_setup(troop_id)
      if can_sort_index?
         @enemies.sort! {|a,b| a.screen_x <=> b.screen_x}
         @enemies.each_with_index {|e, i| e.index = i }
      end
  end
  
  #--------------------------------------------------------------------------
  # * Can Sort Index?
  #--------------------------------------------------------------------------
  def can_sort_index?
      return false if @enemies.size < 3
      return false if troop.pages.size > 1
      return false if !troop.pages[0].list[0].parameters.empty? rescue false
      return true
  end
  
end

#==============================================================================
# ■ Window_BattleEnemy
#==============================================================================
class Window_BattleEnemy < Window_Selectable
  include Battle_Cursor_index
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_battle_cursor_enemy_update update
  def update
      pre_index = self.index
      mog_battle_cursor_enemy_update
      $game_temp.battle_cursor_target[1] = $game_troop.alive_members[self.index]
      $game_temp.battle_cursor_target[1] = nil if !self.active
      set_cursor_position_enemy if refresh_cursor_position?(pre_index)
      $game_temp.target_window_active[1] = self.active
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Cursor Position
  #--------------------------------------------------------------------------  
  def refresh_cursor_position?(pre_index)
      return true if pre_index != self.index 
      return true if @fcursor 
      return true if $game_temp.battle_cursor_need_refresh[1]
      return false
  end    
      
  #--------------------------------------------------------------------------
  # ● Show
  #--------------------------------------------------------------------------
  alias mog_battle_cursor_show show
  def show
      if @info_viewport
         set_cursor_position_enemy ; $game_temp.battle_cursor[2] = true
         @fcursor = true
      end
      mog_battle_cursor_show
  end
  
  #--------------------------------------------------------------------------
  # ● Hide
  #--------------------------------------------------------------------------
  alias mog_battle_cursor_hide hide
  def hide
      $game_temp.battle_cursor[2] = false if @info_viewport
      if $game_temp.target_window_active[0] == false
      ($game_temp.clear_target_temp ; $game_temp.target_skill.clear) unless self.active
      end
      mog_battle_cursor_hide
  end  
    
  #--------------------------------------------------------------------------
  # ● Process Cursor Move
  #--------------------------------------------------------------------------
  def process_cursor_move
      return unless cursor_movable?
      last_index = @index
      cursor_move_index(1) if Input.repeat?(:DOWN)
      cursor_move_index(-1) if Input.repeat?(:UP)
      cursor_move_index(1) if Input.repeat?(:RIGHT)
      cursor_move_index(-1) if Input.repeat?(:LEFT)
      $game_temp.battle_cursor_data = $game_troop.alive_members[@index]
      Sound.play_cursor if @index != last_index
  end
      
end

#==============================================================================
# ■ Window Selectable
#==============================================================================
class Window_Selectable < Window_Base  

  #--------------------------------------------------------------------------
  # * Process OK
  #-------------------------------------------------------------------------
  alias mog_target_cursor_process_ok process_ok
  def process_ok
      mog_target_cursor_process_ok
      execute_target_selection if can_execute_target_selection?
  end
  
  #--------------------------------------------------------------------------
  # * Can Execute Target Selection
  #-------------------------------------------------------------------------
  def can_execute_target_selection?
      return false if !SceneManager.scene_is?(Scene_Battle)
      return false if !current_item_enabled?
      return true if self.is_a?(Window_BattleSkill)
      return true if self.is_a?(Window_BattleItem)
      return true if self.is_a?(Window_ActorCommand) and self.index == 0
      return false
  end

  #--------------------------------------------------------------------------
  # * Execute Target Selection
  #-------------------------------------------------------------------------
  def execute_target_selection      
      return if BattleManager.actor == nil 
      $game_temp.target_skill.clear
      item = @data[index] rescue nil      
      item = $data_skills[BattleManager.actor.attack_skill_id] rescue nil if self.is_a?(Window_ActorCommand)
      return if item == nil 
      if [2,8,10].include?(item.scope) or item.note =~ /<Scope Range = (\d+) - (\d+) - (\d+) - (\d+)>/   
         $game_temp.target_skill = [item,BattleManager.actor]
      end   
  end  

end

#==============================================================================
# ■ Game Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  
  attr_accessor :target_temp
  attr_accessor :action_temp
  
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  alias mog_target_cursor_initialize initialize
  def initialize
      @target_cursor_temp = false
      mog_target_cursor_initialize
  end
  
  #--------------------------------------------------------------------------
  # ● Make Action Temp
  #--------------------------------------------------------------------------
  def make_action_temp(action_id,target_index,type)
      return if action_id == nil
      action = Game_Action.new(self, true)
      action.set_skill(action_id) if type == 0
      action.set_item(action_id) if type == 1
      action.target_index = target_index
      @action_temp = action
  end     
  
  #--------------------------------------------------------------------------
  # ● Make Action Temp
  #--------------------------------------------------------------------------
  alias mog_battle_cursor_item_apply item_apply
  def item_apply(user, item)
      mog_battle_cursor_item_apply(user, item)
      if self == $game_temp.battle_cursor_target[1]
         $game_temp.battle_cursor_need_refresh[0] = true
         $game_temp.battle_cursor_need_refresh[1] = true
      end
  end  
  
end

#==============================================================================
# ■ Game BattlerBase
#==============================================================================
class Game_BattlerBase
   attr_accessor :hidden
end

#==============================================================================
# ■ Sprite Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  include MOG_BATTLE_CURSOR
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  alias mog_target_cursor_initialize initialize
  def initialize(viewport, battler = nil)
      mog_target_cursor_initialize(viewport, battler)
      create_target_cursor
  end 
  
  #--------------------------------------------------------------------------
  # * Create Target Cursor
  #--------------------------------------------------------------------------
  def create_target_cursor
      @target_cursor = Sprite.new
      @target_cursor.bitmap = Cache.system("Battle_Cursor2")
      @target_cursor.ox = @target_cursor.bitmap.width / 2
      @target_cursor.oy = @target_cursor.bitmap.height / 2
      @target_cursor_org = [@target_cursor.ox,@target_cursor.oy]
      @target_cursor.visible = false
      @target_visible_old = @target_cursor.visible
      @tc_pos = [TARGET_CURSOR_2_POS[0],TARGET_CURSOR_2_POS[1] + @target_cursor.oy]
      @face_battler = SceneManager.face_battler? if $imported[:mog_battle_hud_ex]
      @target_cursor_ch = [@target_cursor.bitmap.height, Graphics.height - @target_cursor.bitmap.height]
  end
  
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias mog_target_cursor_dispose dispose
  def dispose
      dispose_target_cursor
      mog_target_cursor_dispose
  end
  
  #--------------------------------------------------------------------------
  # * Dispose Target Cursor
  #--------------------------------------------------------------------------
  def dispose_target_cursor
      return if @target_cursor == nil
      @target_cursor.bitmap.dispose ; @target_cursor.dispose
  end
  
  #--------------------------------------------------------------------------
  # * Update Postion
  #--------------------------------------------------------------------------
  alias mog_target_cursor_update_position update_position
  def update_position
      mog_target_cursor_update_position
      update_battler_cursor_xy
      update_target_cursor
  end
  
  #--------------------------------------------------------------------------
  # * Update Battler Cursor
  #--------------------------------------------------------------------------
  def update_battler_cursor_xy
      return if @battler == nil
      return if $game_temp.battle_cursor_target[0] != nil and @battler != $game_temp.battle_cursor_target[0]
      return if $game_temp.battle_cursor_target[1] != nil and @battler != $game_temp.battle_cursor_target[1]
      $game_temp.target_data = [@battler,self]
  end  
  
  #--------------------------------------------------------------------------
  # * Update Target Cursor
  #--------------------------------------------------------------------------
  def update_target_cursor
      return if @target_cursor == nil
      refresh_zoom if @target_visible_old != @target_cursor.visible
      @target_cursor.visible = can_target_cursor_visible?
      return if !@target_cursor.visible
      @target_cursor.x = self.x + @tc_pos[0]
      @target_cursor.y = self.y + @tc_pos[1]
      @target_cursor.y -= (self.bitmap.height / 2) if self.bitmap
      if @battler.is_a?(Game_Actor) and @face_battler
         @target_cursor.y -= @target_cursor_ch[0] if @target_cursor.y > @target_cursor_ch[1]
      end           
      @target_cursor.z = CURSOR_Z + 1
      @target_cursor.opacity = 130 + rand(125)
      @target_cursor.zoom_x -= 0.05 if @target_cursor.zoom_x > 1.00
      @target_cursor.zoom_x = 1.00 if @target_cursor.zoom_x < 1.00
      @target_cursor.zoom_y = @target_cursor.zoom_x      
      update_battle_camera_cursor_t if update_battle_camera_cursor_t?
  end
  
  #--------------------------------------------------------------------------
  # * Update Battle Camera Cursor T
  #--------------------------------------------------------------------------
  def update_battle_camera_cursor_t?
      return false if $imported[:mog_battle_camera] == nil
      return false if @battler == nil
      if $imported[:mog_battle_hud_ex] and SceneManager.face_battler?
         return false if @battler.is_a?(Game_Actor)
      end  
      return true
  end
     
  #--------------------------------------------------------------------------
  # ● Update Battle Camera Cursor
  #--------------------------------------------------------------------------              
  def update_battle_camera_cursor_t
      @target_cursor.ox = $game_temp.viewport_oxy[0] + @target_cursor_org[0]
      @target_cursor.oy = $game_temp.viewport_oxy[1] + @target_cursor_org[1]
  end  
  
  #--------------------------------------------------------------------------
  # * Refresh Zoom
  #--------------------------------------------------------------------------
  def refresh_zoom
      @target_visible_old = @target_cursor.visible
      @target_cursor.zoom_x = 1.50 if TARGET_CURSOR_2_ZOOM_EFFECT
      @target_cursor.zoom_y = @target_cursor.zoom_x
  end
  
  #--------------------------------------------------------------------------
  # * Can Target Cursor Visible?
  #--------------------------------------------------------------------------
  def can_target_cursor_visible?
      return false if !$game_temp.battle_cursor[2]
      return false if @battler.dead?
      return false if @battler.hidden
      return false if !@battler.target_temp
      return false if $game_message.visible
      return false if $game_temp.battle_end
      return false if $imported[:mog_sprite_actor] and !@battler.bact_sprite_visiblle
      return false if $imported[:mog_active_chain] and $game_temp.chain_action_phase
      return false if $imported[:mog_atb_system] and BattleManager.actor == nil
      return false if $imported[:mog_blitz_commands] and $game_temp.blitz_commands_phase
      return true
  end
  
end

#==============================================================================
# ■ Scene Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # * On Skill OK
  #--------------------------------------------------------------------------
  def on_skill_ok
      if $imported[:mog_atb_system]
         return if BattleManager.actor == nil 
         @skill_window.visible = false unless !@status_window.visible
      end
      @skill = @skill_window.item
      BattleManager.actor.input.set_skill(@skill.id)
      BattleManager.actor.last_skill.object = @skill
     if [0,11].include?(@skill.scope)
        @skill_window.hide
        if $imported[:mog_atb_system]
           next_command
           BattleManager.command_end
           hide_base_window
        end                
      elsif @skill.for_opponent?
          select_enemy_selection
      else
          select_actor_selection
      end
  end
  
  #--------------------------------------------------------------------------
  # * On Item OK
  #--------------------------------------------------------------------------
  def on_item_ok
      if $imported[:mog_atb_system]
         return if BattleManager.actor == nil
         @item_window.visible = false unless !@status_window.visible
      end   
      @item = @item_window.item
      BattleManager.actor.input.set_item(@item.id)
      if [0,11].include?(@item.scope)
         @item_window.hide
         next_command
         if $imported[:mog_atb_system]
            next_command
            BattleManager.command_end
            hide_base_window
         end          
      elsif @item.for_opponent?
          select_enemy_selection
      else
          select_actor_selection
      end
      $game_party.last_item.object = @item
  end  
   
  #--------------------------------------------------------------------------
  # * Turn End
  #--------------------------------------------------------------------------
  alias mog_battle_cursor_turn_end turn_end
  def turn_end
      mog_battle_cursor_turn_end
      if $game_temp.battle_cursor_scope_refresh
         $game_temp.battle_cursor_scope_refresh = false
         $game_temp.battle_cursor_need_refresh[0] = true
         $game_temp.battle_cursor_need_refresh[1] = true
      end        
  end  
  
end  