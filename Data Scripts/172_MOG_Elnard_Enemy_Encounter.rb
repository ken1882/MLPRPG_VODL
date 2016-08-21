#==============================================================================
# +++ MOG - Elnard Enemy Encounter (v1.1) +++
#==============================================================================
# By Moghunter
# http://www.atelier-rgss.com
#==============================================================================
# Sistema de encontros de inimigos baseado no radar, caso o ponto azul encostar
# no ponto vermelho a batalha será ativada. 
# Sistema semelhante ao do Elnard / The 7th Saga / Mystic Ark
#==============================================================================
#
# NOTA 1 - O radar será ativado apenas em mapas com lista de inimigos.
#
#==============================================================================
#
# NOTA 2 - Se deseja (forçar) desativar o radar para fazer alguma cena
#          de evento em um mapa com inimigos , use o código abaixo.
#
# $game_system.enemy_radar = false
#
#==============================================================================
#
# NOTA 3 - Se deseja parar os inimigos temporariamente use o código abaixo.
#
# $game_temp.enemy_radar_stop_duration = X     #60 = 1sec
#
#==============================================================================

#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 1.1 - Melhoria na apresentação da posição do ponteiro. 
#==============================================================================

module MOG_ELNARD_ENEMY_ENCOUNTER
   #Quantidade de inimigos no radar. (de 0 a 50)
   ENEMY_RADAR_NUMBER_OF_ENEMIES = 50
   #Velocidade de movimento do ponto inimigo (de 10 a 999...)
   ENEMY_MOVE_SPEED = 90
   #Tamanho do radar inimigo.
   ENEMY_RADAR_SIZE = [96,96]   
   #Posição do radar do inimigo
   ENEMY_RADAR_POSITION = [440,25]
   #Posição do layout.
   ENEMY_RADAR_LAYOUT_POSITION = [-7,-13]
   #Prioridade da Hud na tela.
   ENEMY_RADAR_Z = 50
   #Cor do ponto do jogador.
   POINT_COLOR_1 = Color.new(0,150,250,255)
   #Cor do ponto do Inimigo.
   POINT_COLOR_2 = Color.new(255,120,0,160)
end  
 
#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
  attr_accessor :enemy_radar_reset
  attr_accessor :enemy_radar_player_move
  attr_accessor :enemy_radar_pre_xy
  attr_accessor :enemy_radar_active
  attr_accessor :enemy_radar_stop_duration
  attr_accessor :enemy_radar_battle_start
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  alias mog_enemy_radar_initialize initialize
  def initialize
      @enemy_radar_reset = false
      @enemy_radar_player_move = []
      @enemy_radar_pre_xy = []
      @enemy_radar_active = true
      @enemy_radar_stop_duration = 0
      @enemy_radar_battle_start = false
      mog_enemy_radar_initialize
  end
  
end

#==============================================================================
# ■ Game System
#==============================================================================
class Game_System
  attr_accessor :enemy_radar
  attr_accessor :enemy_radar_map
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  alias mog_enemy_radar_initialize initialize
  def initialize
      @enemy_radar = true
      @enemy_radar_map = false
      mog_enemy_radar_initialize
  end
  
end  

#==============================================================================
# ■ Game Player
#==============================================================================
class Game_Player < Game_Character

  #--------------------------------------------------------------------------
  # ● Encounter
  #--------------------------------------------------------------------------  
  alias mog_enemy_radar_encounter encounter
  def encounter
      return false
      mog_enemy_radar_encounter
  end
    
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------
  alias mog_enemy_radar_update update
  def update
      pre_pos = [@x,@y]
      mog_enemy_radar_update
      if @move_succeed
         new_x = pre_pos[0] - @x
         new_y = pre_pos[1] - @y
         $game_temp.enemy_radar_player_move = [new_x,new_y]
      end  
  end
    
  #--------------------------------------------------------------------------
  # ● Enemy Radar Battle
  #--------------------------------------------------------------------------  
  def enemy_radar_battle
      make_encounter_count
      troop_id = make_encounter_troop_id
      return false unless $data_troops[troop_id]
      BattleManager.setup(troop_id)
      BattleManager.on_encounter
      SceneManager.call(Scene_Battle)
      $game_temp.enemy_radar_reset = true
      $game_temp.enemy_radar_stop_duration = 30
  end
  
end  

#==============================================================================
# ■ Game Map
#==============================================================================
class Game_Map
  
  #--------------------------------------------------------------------------
  # ● Setup
  #--------------------------------------------------------------------------
  alias mog_enemy_radar_setup setup
  def setup(map_id)
      mog_enemy_radar_setup(map_id)
      $game_temp.enemy_radar_reset = true
      $game_temp.enemy_radar_stop_duration = 20
      $game_system.enemy_radar_map = encounter_list.empty? ? false : true
  end
  
end

#==============================================================================
# ■ Spriteset Map
#==============================================================================
class Spriteset_Map
  
  include MOG_ELNARD_ENEMY_ENCOUNTER
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  alias mog_enemy_radar_initialize initialize
  def initialize
      mog_enemy_radar_initialize
      create_enemy_radar  
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #-------------------------------------------------------------------------  
  alias mog_enemy_radar_dispose dispose
  def dispose
      mog_enemy_radar_dispose
      dispose_enemy_radar
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_enemy_radar_update update
  def update
      mog_enemy_radar_update
      update_enemy_radar
  end
  
  #--------------------------------------------------------------------------
  # ● Create Enemy Radar
  #--------------------------------------------------------------------------    
  def create_enemy_radar
      $game_temp.enemy_radar_active = can_active_enemy_radar?
      create_enemy_radar_background
      create_enemy_radar_point
      update_enemy_radar_visible
  end  
 
  #--------------------------------------------------------------------------
  # ● Create Enemy Radar Background
  #--------------------------------------------------------------------------      
  def create_enemy_radar_background
      $game_system.enemy_radar_map = $game_map.encounter_list.empty? ? false : true
      @radar_size = ENEMY_RADAR_SIZE
      @enemy_radar_layout = Sprite.new
      @enemy_radar_layout.bitmap = Cache.system("Enemy_Radar") rescue nil
      @enemy_radar_layout.bitmap = Cache.system("") if @enemy_radar_layout.bitmap == nil
      @enemy_radar_layout.z = ENEMY_RADAR_Z
      @enemy_radar_layout.x = ENEMY_RADAR_POSITION[0] + ENEMY_RADAR_LAYOUT_POSITION[0]
      @enemy_radar_layout.y = ENEMY_RADAR_POSITION[1] + ENEMY_RADAR_LAYOUT_POSITION[1]      
      @enemy_radar = Sprite.new
      @enemy_radar.bitmap = Bitmap.new(@radar_size[0] + 2, @radar_size[1] + 2)
      @enemy_radar.bitmap.fill_rect(Rect.new(0, 0, @radar_size[0], @radar_size[1]),Color.new(0,0,0,120))
      @enemy_radar.z = ENEMY_RADAR_Z + 1
      @enemy_radar.x = ENEMY_RADAR_POSITION[0] - 2
      @enemy_radar.y = ENEMY_RADAR_POSITION[1] - 2
  end
  #--------------------------------------------------------------------------
  # ● Create Enemy Radar Point
  #--------------------------------------------------------------------------        
  def create_enemy_radar_point
      point_size = ENEMY_RADAR_NUMBER_OF_ENEMIES
      point_size = [(60 - $game_map.encounter_step / 5),10].min
      
      #point_size = 50 if point_size > 50
      index = 0
      @radar_point= []
      for i in 0..point_size
          @radar_point.push(Point_Sprite.new(@enemy_radar_viewport,index,@radar_size[0] - 4,@radar_size[1] - 4))
          index += 1
      end
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Enemy Radar
  #--------------------------------------------------------------------------    
  def dispose_enemy_radar
      return if @enemy_radar == nil
      @enemy_radar_layout.bitmap.dispose
      @enemy_radar_layout.dispose
      @enemy_radar.dispose
      @enemy_radar.bitmap.dispose
      index = 0
      for i in @radar_point
          $game_temp.enemy_radar_pre_xy[index] = [i.x, i.y]
          i.dispose
          index += 1
      end
      @radar_point.each {|sprite| sprite.dispose }      
  end 
  
  #--------------------------------------------------------------------------
  # ● Update Enemy Radar
  #--------------------------------------------------------------------------    
  def update_enemy_radar
      return if @radar_point == nil
      $game_temp.enemy_radar_active = can_active_enemy_radar?
      up_radar = can_update_enemy_radar?
      update_enemy_radar_visible
      @radar_point.each {|sprite| sprite.update_radar(up_radar) }
      if $game_temp.enemy_radar_battle_start and $game_temp.enemy_radar_stop_duration == 0
         $game_temp.enemy_radar_battle_start = false
         $game_player.enemy_radar_battle
         $game_temp.enemy_radar_reset = true
      end
      $game_temp.enemy_radar_stop_duration -= 1 if $game_temp.enemy_radar_stop_duration > 0
      $game_temp.enemy_radar_reset = false if $game_temp.enemy_radar_reset
      $game_temp.enemy_radar_player_move.clear
      $game_temp.enemy_radar_pre_xy.clear
  end
    
  #--------------------------------------------------------------------------
  # ● Can Active Enemy Radar
  #--------------------------------------------------------------------------      
  def can_active_enemy_radar?
      return false if !$game_system.enemy_radar
      return false if !$game_system.enemy_radar_map
      return false if $game_message.visible
      return true
  end  
  
  #--------------------------------------------------------------------------
  # ● Can Update Enemy Radar
  #--------------------------------------------------------------------------        
  def can_update_enemy_radar?
      return false if $game_map.interpreter.running?
      return false if !$game_temp.enemy_radar_active
      return false if $game_temp.enemy_radar_stop_duration > 0
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Update Enemy Radar Visible
  #--------------------------------------------------------------------------        
  def update_enemy_radar_visible
      @enemy_radar.visible = $game_temp.enemy_radar_active
      @enemy_radar_layout.visible = $game_temp.enemy_radar_active    
  end  
  
end

#==============================================================================
# ■ Spriteset Battle
#==============================================================================
class Spriteset_Battle  

  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------    
  alias mog_enemy_radar_sprite_dispose dispose
  def dispose
      mog_enemy_radar_sprite_dispose
      $game_temp.enemy_radar_stop_duration = 30
  end
    
end

#==============================================================================
# ■ Point Sprite
#==============================================================================
class Point_Sprite < Sprite
  
  include MOG_ELNARD_ENEMY_ENCOUNTER
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  def initialize(viewport = nil,index = 0,slx = 81,sly = 81)
      super(viewport)
      @pos = [ENEMY_RADAR_POSITION[0],ENEMY_RADAR_POSITION[1]]
      @point_size = 4
      @index = index
      @screen_size = [slx ,sly]
      @screen_limit = [@screen_size[0] + @pos[0], @screen_size[1] + @pos[1]]
      @cp = [(@screen_size[0] / 2) + @pos[0], (@screen_size[1] / 2) + @pos[1]]
      @cp_limit_x = [(@cp[0] - (@point_size / 2)), (@cp[0] + (@point_size / 2))]
      @cp_limit_y = [(@cp[1] - (@point_size / 2)), (@cp[1] + (@point_size / 2))]   
      @move_time_limit = ENEMY_MOVE_SPEED
      @move_time_limit = 10 if @move_time_limit < 10
      @move_time = rand(@move_time_limit)
      @move_mode = 0
      create_bitmap
      if !$game_temp.enemy_radar_pre_xy.empty?
         restore_position
      else  
         reset_position
      end   
      update_position
      update_visible
  end
  
  #--------------------------------------------------------------------------
  # ● Create Bitmap
  #--------------------------------------------------------------------------    
  def create_bitmap
      self.bitmap = Bitmap.new(@point_size,@point_size)
      self.ox = @point_size / 2
      self.oy = @point_size / 2
      self.z = ENEMY_RADAR_Z + 2
      if @index == 0
         self.bitmap.fill_rect(Rect.new(0, 0, @point_size, @point_size),point_color_1)
         self.x = @cp[0]
         self.y = @cp[1]
      else
         self.bitmap.fill_rect(Rect.new(0, 0, @point_size, @point_size),point_color_2)
      end  
  end
      
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------    
  def dispose
      self.bitmap.dispose
      super
  end
    
  #--------------------------------------------------------------------------
  # ● Update Radar
  #--------------------------------------------------------------------------    
  def update_radar(up_radar = true)
      update_visible
      return if !up_radar or !self.visible
      update_position
      reset_position if out_of_screen?
  end    

  #--------------------------------------------------------------------------
  # ● Update Visible
  #--------------------------------------------------------------------------      
  def update_visible
      self.visible = $game_temp.enemy_radar_active
      if @index > 0 and $game_temp.enemy_radar_stop_duration > 0 
         self.visible = false
         self.x = -32
         self.y = -32
      end  
  end  
  
  #--------------------------------------------------------------------------
  # ● Reset Position
  #--------------------------------------------------------------------------    
  def reset_position
      return if @index == 0
      side = rand(2)
      side2 = rand(2)
      if side == 0
         self.x = rand(@screen_size[0]) + @pos[0]
         self.y = side2 == 0 ? + @pos[1] : @screen_limit[1]
      else   
         self.x = side2 == 0 ? + @pos[0] : @screen_limit[0]
         self.y = rand(@screen_size[1]) + @pos[1]        
      end  
  end   
 
  #--------------------------------------------------------------------------
  # ● Restore position
  #--------------------------------------------------------------------------      
  def restore_position
      return if @index == 0
      self.x = $game_temp.enemy_radar_pre_xy[@index][0]
      self.y = $game_temp.enemy_radar_pre_xy[@index][1]
  end  
  
  #--------------------------------------------------------------------------
  # ● Out of Screen?
  #--------------------------------------------------------------------------    
  def out_of_screen?
      return true if $game_temp.enemy_radar_reset
      return true if !self.x.between?(@pos[0],@screen_limit[0])
      return true if !self.y.between?(@pos[1],@screen_limit[1])
      return false      
  end 
  
  #--------------------------------------------------------------------------
  # ● Update Position
  #--------------------------------------------------------------------------    
  def update_position
      return if @index == 0
      @move_time += 1
      update_player_movement if !$game_temp.enemy_radar_player_move.empty?      
      execute_movement if @move_time > @move_time_limit
      execute_battle if can_execute_battle?
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Player Movement
  #--------------------------------------------------------------------------      
  def update_player_movement
      self.x += ($game_temp.enemy_radar_player_move[0] * @point_size)
      self.y += ($game_temp.enemy_radar_player_move[1] * @point_size)         
  end
      
  #--------------------------------------------------------------------------
  # ● Can Execute Battle
  #--------------------------------------------------------------------------      
  def can_execute_battle?
      return false if !self.x.between?(@cp_limit_x[0],@cp_limit_x[1])
      return false if !self.y.between?(@cp_limit_y[0],@cp_limit_y[1])
      return false if $game_temp.enemy_radar_stop_duration > 0
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Battle
  #--------------------------------------------------------------------------    
  def execute_battle
      $game_temp.enemy_radar_battle_start = true
      #self.x = @cp[0]
      #self.y = @cp[1]      
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Movement
  #--------------------------------------------------------------------------    
  def execute_movement
      @move_time = 0
      if @move_mode == 0
         @move_mode = 1
         move_toward_player
      else   
         @move_mode = 0    
         move_random
      end   
  end  
  
  #--------------------------------------------------------------------------
  # ● Move Random
  #--------------------------------------------------------------------------      
  def move_random
      rand_d = rand(2)
      rand_s = rand(2)
      move_d = rand_s == 0 ? -@point_size : @point_size
      if rand_d == 0
         self.x += move_d
      else  
         self.y += move_d
      end  
  end  
  
  #--------------------------------------------------------------------------
  # ● Move Toward Player
  #--------------------------------------------------------------------------      
  def move_toward_player
      sx = (self.x - @cp[0])
      sy = (self.y - @cp[1])
      move_x = sx > 0 ? -@point_size : @point_size
      move_y = sy > 0 ? -@point_size : @point_size      
      if sx.abs > sy.abs
         self.x += move_x 
         self.y += move_y if sy != 0
      elsif sy != 0  
         self.y += move_y
         self.x += move_x if sx != 0
      end   
  end  
  
  #--------------------------------------------------------------------------
  # ● Point Color 1
  #--------------------------------------------------------------------------    
  def point_color_1
      POINT_COLOR_1
  end   
    
  #--------------------------------------------------------------------------
  # ● Point Color 2
  #--------------------------------------------------------------------------    
  def point_color_2
      POINT_COLOR_2
  end  
  
end

$mog_rgss3_elnard_enemy_encounter = true