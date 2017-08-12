#===============================================================================
# * Game_TacticCursor
#-------------------------------------------------------------------------------
#   Projectiles in the game, game cannot be saved if any projectile exist
#===============================================================================
class Game_TacticCursor
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :x, :y
  attr_accessor :battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @x, @y = 0, 0
    @battler = nil
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_movement
  end
  #--------------------------------------------------------------------------
  # * Update movement
  #--------------------------------------------------------------------------
  def update_movement
    update_keyboard_movement
    update_mouse_movement
  end
  #--------------------------------------------------------------------------
  def update_keyboard_movement
    nx, ny = @x, @y
    mul = Input.press?(:kSHIFT) ? 4 : 1
    nx += 0.25 * mul if Input.repeat?(:RIGHT)
    nx -= 0.25 * mul if Input.repeat?(:LEFT)
    ny += 0.25 * mul if Input.repeat?(:DOWN)
    ny -= 0.25 * mul if Input.repeat?(:UP)
    return if over_bound?(nx, ny)
    Sound.play_cursor
    @x, @y = nx, ny
  end
  #--------------------------------------------------------------------------
  def update_mouse_movement
    mx, my = *Mouse.pos
    nx = ((mx + ($game_map.display_x * 32)) / 32).round(6)
    ny = ((my + ($game_map.display_y * 32)) / 32).round(6)
    return if over_bound?(nx, ny)
    @x, @y = nx, ny
  end
  #--------------------------------------------------------------------------
  def out_offset
    return 0
  end
  #--------------------------------------------------------------------------
  # * Check if cursor go beyond the sight
  #--------------------------------------------------------------------------
  def over_bound?(x, y)
    if (x != @x || y != @y) && $game_map.valid?(x, y)
      max_w = $game_map.max_width ; max_h = $game_map.max_height
      screen_x = $game_map.adjust_x(x) * 32 + 16
      screen_y = $game_map.adjust_y(y) * 32 + 32
      sx = (screen_x / 32).to_i; sy = (screen_y / 32).to_i
      if sx.between?(0 - out_offset, max_w + out_offset) && 
         sy.between?(0 - out_offset, max_h + out_offset)
         
        return false
      end # sx, sy
    end # xy != @xy && map_valid
    return true
  end
  #--------------------------------------------------------------------------
  def collide_battler?
    target  = nil
    min_dis = 0xffff
    BattleManager.all_battlers.each do |battler|
      sx = battler.screen_x + 16; sy = battler.screen_y + 16;
      mx,my = screen_x, screen_y
      dx = (mx - sx).abs; dy = (my - sy).abs;
      if dx < 16 && dy < 16
        if dx + dy < min_dis
          target = battler
          min_dis = dx + dy
        end # dx+dy
      end # dx,dy < 16
    end # all battlers
    return target
  end
  #--------------------------------------------------------------------------
  def relocate(battler = @battler)
    @battler = battler.nil? ? $game_player : battler
    @x, @y   = @battler.x + 0.5, @battler.y + 0.5
  end
  #--------------------------------------------------------------------------
  def set_battler(battler)
    @battler = battler
    relocate
  end
  #--------------------------------------------------------------------------
  # * Get Screen X-Coordinates
  #--------------------------------------------------------------------------
  def screen_x
    $game_map.adjust_x(@x) * 32 + 16
  end
  #--------------------------------------------------------------------------
  # * Get Screen Y-Coordinates
  #--------------------------------------------------------------------------
  def screen_y
    $game_map.adjust_y(@y) * 32 + 32
  end
  #--------------------------------------------------------------------------
  def screen_z; 200; end
end
