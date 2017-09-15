#==============================================================================
# ** Game_Follower
# tag: follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # tag: follower
  Followers_Distance        = 16
  Follwers_Margin           = 4
  #--------------------------------------------------------------------------
  attr_accessor :swap_with_leader
  #--------------------------------------------------------------------------
  # * Alias: Object Initialization
  #--------------------------------------------------------------------------
  alias init_game_follower_comp initialize
  def initialize(member_index, preceding_character)
    init_game_follower_comp(member_index, preceding_character)
    @force_chase = false
    @swap_with_leader = false
  end
  #--------------------------------------------------------------------------
  # * Move to Designated Position
  #--------------------------------------------------------------------------
  alias moveto_comp moveto
  def moveto(x, y, forced = false)
    return if @targeted_character != nil && !@swap_with_leader && !forced
    moveto_comp(x, y)
  end
  #--------------------------------------------------------------------------
  def normal_walk?
    return false if !@current_target.nil?
    return false if command_holding?
    return true
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Pursue Preceding Character
  # tag: follower
  #--------------------------------------------------------------------------
  alias chase_preceding_character_dnd chase_preceding_character
  def chase_preceding_character
    return if !movable?
    if !normal_walk?
      @force_chase = false
      return
    end
    return process_pathfinding_movement if !@pathfinding_moves.empty?
    return process_move_route if !@move_route.nil?
    return if moving? && !@force_chase
    @move_poll.clear if !@move_poll.empty? && distance_preceding_leader < 0.8
    dist = distance_preceding_character
    return chase_preceding_pathfinding if dist > 1.5
    return chase_preceding_normal
  end
  #--------------------------------------------------------------------------
  def chase_preceding_pathfinding
    @force_chase = true
    reachable = move_to_position($game_player.x, $game_player.y)
    moveto($game_player.x,$game_player.y) if !reachable
  end
  #--------------------------------------------------------------------------
  def chase_preceding_normal
    @force_chase = false
    dist = Followers_Distance / 32.0
    mrgn = Follwers_Margin / 32.0
    goal = command_gathering? ? $game_player : @preceding_character
    sx = distance_x_from(goal.x)
    sy = distance_y_from(goal.y)
    sd = Math.hypot(sx, sy)
    #if sx != 0 && sy != 0
    #  move_dpixel(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
    if(sd > dist && sx.abs > mrgn && sy.abs > mrgn)
      dir = (sx > 0 ? -1 : 1) + (sy > 0 ? 8 : 2)
      case dir
      when 1; move_dpixel(4,2, true);
      when 3; move_dpixel(6,2, true);
      when 7; move_dpixel(4,8, true);
      when 9; move_dpixel(6,8, true);
      end
    elsif sx.abs > dist && sx.abs > sy.abs
      move_pixel(sx > 0 ? 4 : 6, true)
    elsif sy.abs > dist && sx.abs < sy.abs
      move_pixel(sy > 0 ? 8 : 2, true)
    end # if @board
  end
  #--------------------------------------------------------------------------
  # * Process move route command
  #--------------------------------------------------------------------------
  def process_move_route
    command = @move_route.list[@move_route_index]
    if command
      process_move_command(command)
      advance_move_route_index
    end
  end
  #--------------------------------------------------------------------------
  # * The Distance To Preceding Character
  #--------------------------------------------------------------------------
  def distance_preceding_character
    sx = distance_x_from(@preceding_character.x)
    sy = distance_y_from(@preceding_character.y)
    return Math.hypot(sx, sy)
  end
  #--------------------------------------------------------------------------
  # * The Distance To Leader
  #--------------------------------------------------------------------------
  def distance_preceding_leader
    sx = distance_x_from($game_player.x)
    sy = distance_y_from($game_player.y)
    return Math.hypot(sx, sy)
  end
  #--------------------------------------------------------------------------
  # * New: Processes Movement
  #--------------------------------------------------------------------------
  def process_move(horz, vert)
    super(horz, vert)
    dist = Followers_Distance / 32.0
    if distance_preceding_character > dist && @move_poll.size == 0
      @force_chase = true
      chase_preceding_character
      @force_chase = false
    end
  end
  #--------------------------------------------------------------------------
  # * New: Sets the Character To Board
  #--------------------------------------------------------------------------
  def board
    @board = true
  end
end
