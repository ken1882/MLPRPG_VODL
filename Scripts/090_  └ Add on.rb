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
  attr_accessor :recurrence_delay
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_gapc_opt initialize
  def initialize
    @target_event     = nil
    @recurrence_delay = nil
    initialize_gapc_opt
  end
  #--------------------------------------------------------------------------
  # * Disable Dash utility
  #--------------------------------------------------------------------------
  def dash?
    return false
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
  #--------------------------------------------------------------------------
  # * Overwrite: Determine if Movement is Possible
  #--------------------------------------------------------------------------
  def movable?(for_action = false)
    return false if moving? && !for_action
    return false if @move_route_forcing || @followers.gathering?
    return false if @vehicle_getting_on || @vehicle_getting_off
    return false if $game_message.busy? || $game_message.visible
    return false if vehicle && !vehicle.movable?
    return false if !actor.movable?
    return true
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
  # * Overwrite: Frame Update
  #--------------------------------------------------------------------------
  def update
    last_real_x = @real_x
    last_real_y = @real_y
    last_moving = moving?
    move_by_input unless !movable? || $game_map.interpreter.running?
    super
    update_scroll(last_real_x, last_real_y) if last_real_x != @real_x ||
                                               last_real_y != @real_y
    #update_vehicle unless @followers.gathering?
    update_nonmoving(last_moving) unless moving?
    @recurrence_delay -= 1 if !@recurrence_delay.nil? && @recurrence_delay > 0
    $game_party.recurrence_leader if @recurrence_delay == 0
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
  #--------------------------------------------------------------------------
  # * Processing When Not Moving
  #     last_moving : Was it moving previously?
  #--------------------------------------------------------------------------
  def update_nonmoving(last_moving)
    return if $game_map.interpreter.running?
    if last_moving
      $game_party.on_player_walk
      return if check_touch_event
    end
    if movable? && Input.trigger?(:C)
      #return if get_on_off_vehicle
      return if check_action_event
    end
  end
  #----------------------------------------------------------------------------
  # * Can perform action?
  #----------------------------------------------------------------------------
  def actable?
    return false if $game_message.busy?
    return false if !movable?(true)
    return true
  end
  #----------------------------------------------------------------------------
  # * Die when hitpoint drop to zero
  #----------------------------------------------------------------------------
  def kill
    process_actor_death
    $game_player.recurrence_delay = 60
    super
  end
  #--------------------------------------------------------------------------
  def primary_weapon
    return actor.equips[0]
  end
  #--------------------------------------------------------------------------
  def body_size
    return 1 * @zoom_x
  end
  #--------------------------------------------------------------------------
  def hashid
    return actor.hashid if actor
    return 0
  end
  #----------------------------------------------------------------------------
  def dead?
    return actor.dead?
  end
  #--------------------------------------------------------------------------
  def update_vehicle
  end
  #--------------------------------------------------------------------------
  def update_encounter
  end
  #----------------------------------------------------------------------------
  # * Allow character move freely between characters?
  #----------------------------------------------------------------------------
  def allow_loose_moving?
    return false
  end
  #--------------------------------------------------------------------------
  def team_id
    return @team_id.nil? ? @team_id = 0 : @team_id
  end
  #----------------------------------------------------------------------------
  # * Use item
  #----------------------------------------------------------------------------
  def use_tool(item, target = nil)
    super
    SceneManager.spriteset.hud_sprite[actor.index].draw_action(@next_action)
  end
  #----------------------------------------------------------------------------
  def setup_light(light_id)
    p 'setup lantern'
    $game_map.lantern = $game_map.lantern
    $game_map.lantern.change_owner($game_player)
    $game_map.lantern.set_graphic(Light_Core::Effects[light_id].first)
    $game_map.lantern.set_opacity(180,30)
    $game_map.lantern.show
  end
  #----------------------------------------------------------------------------
  def dispose_light
    $game_map.lantern.hide
  end
end
