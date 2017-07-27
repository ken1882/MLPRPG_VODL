#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. It includes event starting determinants and
# map scrolling functions. The instance of this class is referenced by
# $game_player.
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :target_event   # Event auto trigger when touched
  attr_reader   :new_x, :new_y
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_gapc_opt initialize
  def initialize
    @target_event = nil
    initialize_gapc_opt
  end
  #--------------------------------------------------------------------------
  # * Disable Dash utility
  #--------------------------------------------------------------------------
  def dash?
    return false
  end
  #--------------------------------------------------------------------------
  # * Vehicle Processing
  #--------------------------------------------------------------------------
  def update_vehicle
  end
  #--------------------------------------------------------------------------
  # * Clear Transfer Player Information
  #--------------------------------------------------------------------------
  def clear_transfer_info
    @transferring = false            # Player transfer flag
    @new_map_id = 0                  # Destination map ID
    @new_x = 0                      # Destination X coordinate
    @new_y = 0                      # Destination Y coordinate
    @new_direction = 0               # Post-movement direction
  end
  #--------------------------------------------------------------------------
  # * Execute Player Transfer
  #--------------------------------------------------------------------------
  def perform_transfer
    if transfer?
      set_direction(@new_direction)
      if @new_map_id != $game_map.map_id
        $game_map.setup(@new_map_id)
        $game_map.autoplay
      end
      moveto(@new_x, @new_y)
      clear_transfer_info
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Player Transfer is Reserved
  #--------------------------------------------------------------------------
  def transfer?
    return @transferring
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Actor
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, args) unless actor
    super(symbol, args) unless actor.methods.include?(symbol)
    actor.method(symbol).call(*args)
  end
  #--------------------------------------------------------------------------
  # * Update Encounter
  #--------------------------------------------------------------------------
  def update_encounter
  end
  #--------------------------------------------------------------------------
  # * Frame Update.                                                     [REP]
  #--------------------------------------------------------------------------
  def update
    last_real_x = @real_x
    last_real_y = @real_y
    last_moving = moving?
    move_by_input unless !movable? || $game_map.interpreter.running?
    super
    update_scroll(last_real_x, last_real_y) if last_real_x != @real_x ||
                                               last_real_y != @real_y
    update_vehicle unless @followers.gathering?
    update_nonmoving(last_moving) unless moving?
    @followers.update
  end
  #--------------------------------------------------------------------------
  # * Scroll Processing
  #--------------------------------------------------------------------------
  def update_scroll(last_real_x, last_real_y)
    ax1 = $game_map.adjust_x(last_real_x)
    ay1 = $game_map.adjust_y(last_real_y)
    ax2 = $game_map.adjust_x(@real_x)
    ay2 = $game_map.adjust_y(@real_y)
    $game_map.scroll_down (ay2 - ay1) if ay2 > ay1 && ay2 > center_y
    $game_map.scroll_left (ax1 - ax2) if ax2 < ax1 && ax2 < center_x
    $game_map.scroll_right(ax2 - ax1) if ax2 > ax1 && ax2 > center_x
    $game_map.scroll_up   (ay1 - ay2) if ay2 < ay1 && ay2 < center_y
  end
  
end
