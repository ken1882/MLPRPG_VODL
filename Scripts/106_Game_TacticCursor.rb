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
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @x, @y = 0, 0
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
    BattleManager.all_battlers.each do |battler|
      return battler if battler.adjacent?(@x, @y)
    end
    return false
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
