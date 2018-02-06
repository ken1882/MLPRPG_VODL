#===============================================================================
# * Game_Projectile
#-------------------------------------------------------------------------------
#   Projectiles in the game, game cannot be saved if any projectile exist
#===============================================================================
class Game_Projectile < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :user, :target
  attr_reader   :item
  attr_reader   :sprite
  attr_reader   :action
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(action, move_formula = nil)
    super()
    @user   = action.user
    @target = action.target ? action.target : POS.new(user.x, user.y)
    #puts "Projectile target address: #{target.x} #{target.y}"
    @moved_dis = 0
    @item   = action.item
    @max_range     = item.tool_distance
    @move_speed    = item.tool_speed
    @through       = item.tool_through
    @priority_type = item.tool_priority
    @tool_type     = item.tool_type
    @executed      = false
    @action        = action
    @move_formula  = move_formula
    @substitute    = nil
    @enemies       = BattleManager.opponent_battler(@action.user)
    moveto([@user.x, 0].max, [@user.y, 0].max)
    @sprite = Sprite_Projectile.new(SceneManager.viewport1, self)
    activate
    self
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_movement
    @sprite.update
    super
  end
  #--------------------------------------------------------------------------
  # * Movement process
  #--------------------------------------------------------------------------
  def update_movement
    return if SceneManager.time_stopped?
    execute_action if !process_projectile_move
    @sprite.execute_collide if collision_ready?
  end
  #--------------------------------------------------------------------------
  def collision_ready?
    if @moved_dis >= @max_range
      pos = POS.new(@x, @y)
      @action.target = pos
      return true
    end
    return true if (@x - target.x).abs < 0.2 && (@y - target.y).abs < 0.2
    return true if !@target.is_a?(POS) && self.adjacent?(target.x, target.y)
    return false
  end
  #--------------------------------------------------------------------------
  def process_projectile_move
    return false if @executed
    return wall_rammed if obstacle_touched?
    return process_move_formula if @move_formula
    
    pixelstep = Pixel_Core::Pixel
    len = [Math.hypot(@x -  target.x, @y - target.y), 0.1].max
    dx  = (target.x - @x).to_f / len
    dy  = (target.y - @y).to_f / len
    delta_x = distance_per_frame * dx * pixelstep / 2
    delta_y = distance_per_frame * dy * pixelstep / 2
    @x = $game_map.round_x(@x + delta_x)
    @y = $game_map.round_y(@y + delta_y)
    @real_x = @x - delta_x
    @real_y = @y - delta_y
    @moved_dis += Math.hypot(delta_x, delta_y)
    @direction = (delta_x.abs > delta_y.abs) ? (delta_x > 0 ? 6 : 4) : (delta_y > 0 ? 2 : 8)
    return !(delta_x == 0 && delta_y == 0)
  end
  #--------------------------------------------------------------------------
  def process_move_formula
    # tag: formula
    # link to module PONY::Formula
  end
  #--------------------------------------------------------------------------
  # * Execute Action
  #--------------------------------------------------------------------------
  def execute_action
    return if @executed
    @executed = true
    BattleManager.execute_action(@action)
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Restore bitmap
  #--------------------------------------------------------------------------
  def restore
    @sprite = Sprite_Projectile.new(SceneManager.viewport1, self)
  end
  #--------------------------------------------------------------------------
  def dispose_sprite
    return unless @sprite
    @sprite.dispose unless @sprite.disposed?
    @sprite = nil
  end
  #--------------------------------------------------------------------------
  def obstacle_touched?
    dir = @direction
    nx = @x * 4 + Pixel_Core::Tile_Range[dir][0]
    ny = @y * 4 + Pixel_Core::Tile_Range[dir][1]
    return true  if !$game_map.pixel_valid?(nx,ny) || $game_map.over_edge?(@x, @y)
    return false if @through
    return true  if $game_map.pixel_table[nx,ny,1] == 0
    return true  if check_substitute 
    return false
  end
  #--------------------------------------------------------------------------
  def check_substitute
    @enemies.each do |enemy|
      if adjacent?(enemy.x, enemy.y)
        @substitute = enemy
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  def wall_rammed
    @action.target = @substitute ? @substitute : POS.new(@x, @y)
    @sprite.execute_collide
    execute_action
  end
  #--------------------------------------------------------------------------
  def character_name; return item.tool_graphic; end
  def animation_id; return item.animation_id; end
  def update_realtime_action; end
  def dead?; return true; end
  def relocate; @sprite.relocate; end
  #---------------------------------------------------------
end
