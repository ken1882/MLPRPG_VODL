
#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  This is a wrapper for a follower array. This class is used internally for
# the Game_Player class. 
#==============================================================================
class Game_Followers
  #--------------------------------------------------------------------------
  # * New: Detect Collision
  #--------------------------------------------------------------------------
  def collide_rect?(x, y, rect)
    visible_folloers.any? {|follower| follower.pos_rect?(x, y, rect) }
  end
  #--------------------------------------------------------------------------
  # * Override: Movement
  #--------------------------------------------------------------------------
  def move
    reverse_each {|follower| follower.board if gathering?; follower.chase_preceding_character }
  end
  
end
#==============================================================================
# ** Game_Follower
# tag: follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
class Game_Follower < Game_Character
  attr_accessor :swap_with_leader
  #--------------------------------------------------------------------------
  # * Alias: Object Initialization
  #--------------------------------------------------------------------------
  alias game_follower_initialize_cxj_fm initialize
  def initialize(member_index, preceding_character)
    game_follower_initialize_cxj_fm(member_index, preceding_character)
    @force_chase = false
    @board = false
    @swap_with_leader = false
  end
  
  #--------------------------------------------------------------------------
  # * Move to Designated Position
  #--------------------------------------------------------------------------
  def moveto(x, y, forced = false)
    return if @targeted_character != nil && !@swap_with_leader && !forced
    @swap_with_leader = false
    @x = x % $game_map.width
    @y = y % $game_map.height
    @real_x = @x
    @real_y = @y
    @prelock_direction = 0
    straighten
    update_bush_depth
  end
  
  #--------------------------------------------------------------------------
  # * Alias: Pursue Preceding Character
  #--------------------------------------------------------------------------
  def chase_preceding_character
    if @pathfinding_moves.size > 0
      process_pathfinding_movement
      return
    end
    
    return if @blowpower[0] > 0
    return if @targeted_character != nil
    return if $game_player.in_combat_mode?
    return if self.command_holding?
    
    if !@move_route.nil?
      command = @move_route.list[@move_route_index]
      if command
        process_move_command(command)
        advance_move_route_index
      end
    end
    
    unless moving? && !@force_chase
      
      dist = CXJ::FREE_MOVEMENT::FOLLOWERS_DISTANCE / 32.0
      mrgn = CXJ::FREE_MOVEMENT::FOLLOWERS_DISTANCE_MARGIN / 32.0
      
      far_dist = distance_preceding_character
      
      type = far_dist > 3 ? 1 : 2
      
      if !@move_poll.empty? && distance_preceding_leader < 0.8
        @move_poll.clear
      end
      
      # if self(follower) is idle and 3 blocks away from leader
      if type == 1 && @move_poll.empty? && distance_preceding_leader > 3
        @pathfinding_moves.clear
        reachable = self.move_to_position($game_player.x, $game_player.y)
        self.moveto($game_player.x,$game_player.y) if !reachable
      else
        goal = command_gathering? ? $game_player : @preceding_character
        sx = distance_x_from(goal.x)
        sy = distance_y_from(goal.y)
        sd = Math.hypot(sx, sy)
        if @board
          @x = goal.x
          @y = goal.y
          @board = false
        elsif(sd > dist && sx.abs > mrgn && sy.abs > mrgn)
          @move_poll += [[(sx > 0 ? -1 : 1) + (sy > 0 ? 8 : 2), true]]
        elsif sx.abs > dist && sx.abs > sy.abs
          @move_poll+=[[sx > 0 ? 4 : 6, true]]
        elsif sy.abs > dist && sx.abs < sy.abs
          @move_poll+=[[sy > 0 ? 8 : 2, true]]
        elsif command_gathering?
          move_toward_character($game_player, false, 0, false)
          self.moveto($game_player.x,$game_player.y) if (sx + sy) < 1 && @move_poll.empty?
        end # if @board
        #-----
      end
      
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
    dist = CXJ::FREE_MOVEMENT::FOLLOWERS_DISTANCE / 32.0
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
