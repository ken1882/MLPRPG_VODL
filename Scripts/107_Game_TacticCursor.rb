#===============================================================================
# * Game_TacticCursor
#-------------------------------------------------------------------------------
#   Projectiles in the game, game cannot be saved if any projectile exist
#===============================================================================
class Game_TacticCursor
  #--------------------------------------------------------------------------
  PhaseIdle              = 0
  PhaseBattlerSelection  = 1
  PhaseTargetSelection   = 2
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :x, :y
  attr_accessor :battler
  attr_accessor :phase
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @x, @y = 0, 0
    @phase = PhaseIdle
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
    battlers = []
    BattleManager.all_battlers.each do |battler|
      battlers << battler if battler.adjacent?(@x, @y)
    end
    return battlers.empty? ? nil : battlers.min_by{|b|b.distance_to(@x,@y)}
  end
  #--------------------------------------------------------------------------
  def set_battler(battler)
    @battler = battler
    @phase   = @battler.nil? ? PhaseIdle : PhaseBattlerSelection
  end
  #--------------------------------------------------------------------------
  def select_target
    @phase = PhaseTargetSelection
  end
  #--------------------------------------------------------------------------
  def target_selected
    @phase = PhaseBattlerSelection
  end
  #--------------------------------------------------------------------------
  def phase_back
    @phase = [@phase - 1, 0].max
  end
  #--------------------------------------------------------------------------
  def phase?;             @phase; end
  def idle?;              @phase == PhaseIdle; end
  def battler_selection?; @phase == PhaseBattlerSelection; end
  def target_selection?;  @phase == PhaseTargetSelection; end
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
