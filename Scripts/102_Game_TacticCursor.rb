#===============================================================================
# * Game_TacticCursor
#-------------------------------------------------------------------------------
#   Projectiles in the game, game cannot be saved if any projectile exist
#===============================================================================
class Game_TacticCursor < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    @sprite = Sprite_TacticCursor.new(self)
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
    nx, ny = @x, @y
    mul = Input.press?(:kSHIFT) ? 4 : 1
    nx += 0.25 * mul if Input.repeat?(:RIGHT)
    nx -= 0.25 * mul if Input.repear?(:LEFT)
    ny += 0.25 * mul if Input.repeat?(:DOWN)
    ny -= 0.25 * mul if Input.repear?(:UP)
    return unless over_bound?(nx, ny)
    execute_keyboard_movement(nx, ny)
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
      screen_x = $game_map.adjust_x(nu_x) * 32 + 16
      screen_y = $game_map.adjust_y(nu_y) * 32 + 32
      sx = (screen_x / 32).to_i; sy = (screen_y / 32).to_i
      if sx.between?(0 - out_offset, max_w + out_offset) && 
         sy.between?(0 - out_offset, max_h + out_offset)
         
        return true
      end # sx, sy
    end # xy != @xy && map_valid
    return false
  end
  
end
