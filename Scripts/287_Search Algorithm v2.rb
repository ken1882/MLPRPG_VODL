=begin
╔════╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═════╗
║ ╔══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╗ ║
╠─╣                        Q:How to use?                                     ╠─╣
╠─╣                                                                          ╠─╣
╠─╣    A:Use script call: (character/event).move_to_position(x,y)            ╠─╣
╠─╣                                                                          ╠─╣
╠─╣    For example, if you want a event chase the plyer, use:                ╠─╣
╠─╣$game_map.events[@event_id].move_to_position($game_player.x,$game_player.y╠─╣
║ ╚══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╝ ║
╚════╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═════╝
=end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  #------------------------------------------------------------------------------
  #  * Address over the map's width / height?
  #------------------------------------------------------------------------------
  def over_edge?(x,y)
    return if @map.nil?
    return x < 0 || y < 0 || x >= width || y >= height
  end
  
end
#==============================================================================
# ** Map_Address
#------------------------------------------------------------------------------
# This class is using to save the movement cost and address for the later class
# PathFinding_Queue
#==============================================================================
class Map_Address
  
  attr_accessor :x
  attr_accessor :y
  attr_accessor :cost
  
  def initialize(x = nil, y = nil, cost = 0)
    @x = x
    @y = y
    @cost = cost
  end
  
end
#==============================================================================
# ** PathFinding_Queue
#------------------------------------------------------------------------------
# This class is the main part of path finding, algorithm: A*
#==============================================================================
class PathFinding_Queue
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :visisted
  attr_accessor :nodes
  attr_accessor :move_dir
  attr_accessor :nodes_parent_id
  attr_accessor :distance
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(init_x,init_y)
    @visited          = []           # visited address
    @nodes            = []           # map nodes
    
    @nodes_parent_id  = []           # use for the path lookup after path fonud,
                                     # track up which node leads to the saved
                                     # node.
                                     
    @move_dir         = []           # use for the path lookup after path fonud,
                                     # saves the directions where the character
                                     # should go
                                     
    @distance         = 0x800000     # Distance to goal
    
    start_node = Map_Address.new(init_x,init_y)
    @nodes.push(start_node)
    @nodes_parent_id[ hash_address(init_x,init_y) ] = hash_address(init_x,init_y)
    mark_visited(init_x,init_y)
  end
  #--------------------------------------------------------------------------
  # * Dehash address
  #--------------------------------------------------------------------------
  def dehash_address(value)
    return [(value/1000).to_i , value % 1000]
  end
  #--------------------------------------------------------------------------
  # * Hash address
  #--------------------------------------------------------------------------
  def hash_address(x,y)
    return x * 1000 + y
  end
  #--------------------------------------------------------------------------
  # *  Heuristic algorithm 
  #--------------------------------------------------------------------------
  def predict_movement_cost(source_location,current_location,goal_location)
    
    dx1 = current_location.x - goal_location.x
    dx2 = source_location.x  - goal_location.x
    dy1 = current_location.y - goal_location.y
    dy2 = source_location.y  - goal_location.y
    
    return (dx1.abs + dy1.abs) * 3 + (dx1 * dy2 - dx2 * dy1).abs * 2
  end
  
  #--------------------------------------------------------------------------
  # *  Push new scanned address
  #--------------------------------------------------------------------------
  def push(source_loc, current_loc,next_loc, dir, goal_loc, depth)
    
    extra_cost = depth * 5
    node_cost = predict_movement_cost(source_loc,current_loc,goal_loc) + extra_cost
    node = Map_Address.new(next_loc.x,next_loc.y,node_cost)
    @nodes.push(node)
    @nodes.sort!{ |a,b| a.cost <=> b.cost}
    
    # save source direction
    @move_dir[ hash_address(next_loc.x,next_loc.y) ] = dir
    
    # save source address
    @nodes_parent_id[ hash_address(next_loc.x,next_loc.y) ] = hash_address(current_loc.x,current_loc.y)
  end
  #--------------------------------------------------------------------------
  # *  Address visied?
  #--------------------------------------------------------------------------
  def visited?(x,y)
    return @visited.include?( hash_address(x,y) )
  end
  #--------------------------------------------------------------------------
  # *  Mark address visited
  #--------------------------------------------------------------------------
  def mark_visited(x,y)
    @visited.push( hash_address(x,y) )
  end
  
  #--------------------------------------------------------------------------
  # *  Queue is Empty?
  #--------------------------------------------------------------------------
  def empty?
    return @nodes.size == 0
  end
  #--------------------------------------------------------------------------
  # *  Top of queue, which has the minimum cost
  #--------------------------------------------------------------------------
  def top
    return [@nodes[0].x , @nodes[0].y]
  end
  #--------------------------------------------------------------------------
  # *  Remove the top object in the queue
  #--------------------------------------------------------------------------
  def pop
    @nodes.shift
  end
  #--------------------------------------------------------------------------
  # *  Get the route command
  #--------------------------------------------------------------------------
  def get_route_command(path_address,moving_direction)
    cmd_list = []
              
    for i in 0...path_address.size
      curx = path_address[i].x
      cury = path_address[i].y
      
      command_id = 0
      debug_info = ""
      case moving_direction[i]
      when 2
        debug_info = "↓"
        command_id = 2
      when 4
        debug_info = "←"
        command_id = 4
      when 6
        debug_info = "→"
        command_id = 6
      when 8
        debug_info = "↑"
        command_id = 8
      else
        debug_info = "O"
      end #case
      
      puts "#{debug_info} (#{curx},#{cury})" if $pathfinding_debug
      if command_id > 0
        cmd_list.push([[command_id, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil)
      end # if command_id > 0
    end # for i in path_address.size
    
    return cmd_list
  end
  
  #--------------------------------------------------------------------------
  # *  Return the path address and direction
  #--------------------------------------------------------------------------
  def get_walk_path(goalx,goaly)
    current_track_address = hash_address(goalx,goaly)
    path = []
    path_address = []
    go_dir = []
    path.push(current_track_address)
    
    while @nodes_parent_id[current_track_address]
      
      path.unshift( @nodes_parent_id[current_track_address] )
      go_dir.unshift( @move_dir[current_track_address] )
      
      current_track_address = @nodes_parent_id[current_track_address]
      break if current_track_address == @nodes_parent_id[current_track_address]
    end
    
    path.each do |hash_value|
      _address = dehash_address(hash_value)
      path_address.push( Map_Address.new( _address[0], _address[1]) )
    end
    
    return get_route_command(path_address,go_dir)
  end
  
end
#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  A character class with mainly movement route and other such processing
# added. It is used as a super class of Game_Player, Game_Follower,
# GameVehicle, and Game_Event.
#==============================================================================
class Game_Character < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor   :pathfinding_moves
  attr_accessor   :pathfinding_goal
  attr_accessor   :force_pathfinding
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_members_comp init_public_members
  def init_public_members
    init_public_members_comp
    @pathfinding_moves = []
    @pathfinding_goal  = nil
    @force_pathfinding = true
  end
  #--------------------------------------------------------------------------
  # * adjacent posititon? (for free-movement script)
  #--------------------------------------------------------------------------
  def adjacent?(x2 ,y2 , x1 = @x , y1 = @y)
    return (x1 - x2).abs < 0.6 && (y1 - y2).abs < 0.6
  end
  #--------------------------------------------------------------------------
  # * distance from self to certain pos
  #--------------------------------------------------------------------------
  def distance_to(x, y)
    return Math.hypot(x - @x, y - @y)
  end
  #--------------------------------------------------------------------------
  # * Fix current address (for free-movement script)
  #--------------------------------------------------------------------------
  def fix_address(x = @x, y = @y)
    fixed_x = (x - x.to_i).abs < 0.500 ? x.to_i : x.to_i + 1
    fixed_y = (y - y.to_i).abs < 0.500 ? y.to_i : y.to_i + 1
    
    return [fixed_x,fixed_y]
  end
  
  def clear_pathfinding_moves
    @pathfinding_moves.clear
  end
  #--------------------------------------------------------------------------
  # * next step is blocked by events?
  #--------------------------------------------------------------------------
  def path_blocked_by_event?(next_x,next_y)
    
    for event_id in 1...$game_map.events.size
      next if $game_map.events[event_id].nil?
      
      if !$game_map.events[event_id].through
        ob_x = $game_map.events[event_id].x
        ob_y = $game_map.events[event_id].y
        
        return true if adjacent?(ob_x,ob_y,next_x,next_y)
        
      end #if event is not through 
    end # for event_id
    return false
  end # def path_blocked
  
  #--------------------------------------------------------------------------
  # * next step is blocked by events?
  #--------------------------------------------------------------------------
  def path_blocked_by_player?(next_x,next_y)
    return adjacent?(next_x,next_y,$game_player.x,$game_player.y)
  end # def path_blocked_by_player
  
  #--------------------------------------------------------------------------
  # * core function, move to assigned position
  #--------------------------------------------------------------------------
  def move_to_position(goalx, goaly, args = {})
    ti = Time.now
    depth      = args[:depth].nil?      ? 100   : args[:depth]
    tool_range = args[:tool_range].nil? ? 1     : args[:tool_range]
    draw_arrow = args[:draw_arrow].nil? ? false : args[:draw_arrow]
    debug      = args[:debug].nil?      ? false : args[:debug]
    
    $game_map.clean_pathfinding_arrow if draw_arrow
    $pathfinding_debug = debug
    @pathfinding_moves.clear
    @move_poll.clear
    @on_path_finding = true
    fixed_address = fix_address
    
    fx = fixed_address[0]; fy = fixed_address[1] 
    fixed_address = fix_address(goalx,goaly)
    ori_goalx = goalx
    ori_goaly = goaly
    goalx = fixed_address[0]
    goaly = fixed_address[1]
    offset_x = fx - @x + (ori_goalx - goalx)
    offset_y = fy - @y + (ori_goaly - goaly)
    
    tox   = [0,-1,1,0]
    toy   = [1,0,0,-1]
    dir   = [2,4,6,8]
    cnt   = 0
    path_queue = PathFinding_Queue.new([fx,0].max,[fy,0].max)
    path_found = false
    best_path  = path_queue.dup
    bestx, besty = fx, fy
    
    while !path_found && !path_queue.empty? && cnt <= depth
      
      cnt += 1
      curx = path_queue.top[0]
      cury = path_queue.top[1]
      
      path_queue.distance = [path_queue.distance, Math.hypot(goalx - curx, goaly - cury)].min
      if curx == goalx && cury == goaly
        path_found = true
        break
      elsif path_queue.distance < best_path.distance
        best_path = path_queue.dup
        bestx     = curx
        besty     = cury
      end
      
      path_queue.pop
      
      for i in 0...4
        break if path_found
        next_x = (curx + tox[i]).to_i
        next_y = (cury + toy[i]).to_i
        
        # check next path if passable
        if ( $game_map.passable?(next_x,next_y,dir[i]) || adjacent?(next_x, next_y, goalx, goaly) ) && 
          !path_queue.visited?(next_x,next_y) && !$game_map.over_edge?(next_x,next_y)
          
          next if !passable?(curx, cury, dir[i])
          next if path_blocked_by_event?(next_x,next_y) && !adjacent?(next_x, next_y, goalx, goaly)
          
          if (path_blocked_by_player?(next_x,next_y) && !@through)
            next unless adjacent?(goalx,goaly,$game_player.x,$game_player.y)
          end
          
          if adjacent?(next_x, next_y, goalx, goaly)
            path_found = true
          elsif (((next_x - goalx).abs + (next_y - goaly).abs ) <= tool_range ||
                  adjacent?(goalx, goaly - tool_range + 0.5, next_x, next_y)) && 
                  path_clear?(curx, cury, goalx, goaly)
            goalx = next_x
            goaly = next_y
            path_found = true
          end
          
          source_loc  = Map_Address.new(fx,fy)
          current_loc = Map_Address.new(curx,cury)
          next_loc    = Map_Address.new(next_x,next_y)
          goal_loc    = Map_Address.new(goalx,goaly)
          
          path_queue.push(source_loc,current_loc,next_loc,dir[i],goal_loc, cnt)
        end # if passable?
        path_queue.mark_visited(next_x,next_y)
        
      end # for i in 0...4
    end # while
    
    best_path = path_queue if path_found
    
    if !path_found
      goalx, goaly = bestx, besty
      puts "x,y: #{goalx}, #{goaly}"
    end # if !path found
    
    debug_print "Pathfinding time takes: #{Time.now.to_f - ti.to_f}"
    if offset_x != 0
      @pathfinding_moves.push([[offset_x < 0 ? 4 : 6 ,true]] * (offset_x / 0.125).abs)
    end
    if offset_y != 0
      @pathfinding_moves.push([[offset_y < 0 ? 8 : 2 ,true]] * (offset_y / 0.125).abs)
    end
    @pathfinding_moves = @pathfinding_moves + best_path.get_walk_path(goalx,goaly)
    debug_print "Pathfinding moves: #{@pathfinding_moves.size}"
    return path_found
  end # def move_to_position
  
  
  #--------------------------------------------------------------------------
  # * Overwrite Method: Process Move Route End
  #--------------------------------------------------------------------------
  def process_route_end
    if @move_route.repeat
      @move_route_index = -1
    elsif @move_route_forcing
      @on_path_finding    = false
      @move_route_forcing = false
      restore_move_route
    end
    @move_type = @previous_move_type
  end
  #--------------------------------------------------------------------------
  # * Process pathfinding movement
  #--------------------------------------------------------------------------
  def process_pathfinding_movement
    if @pathfinding_moves.size > 0 && @move_poll.empty?
      @move_poll += @pathfinding_moves[0]
      @followers.move if self.is_a?(Game_Player)
      @pathfinding_moves.shift
    end
  end
  
end # class Game_Character
#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================
class Game_Event < Game_Character
  
end
#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================
module SceneManager
  
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #-------------------------------------------------------------------------
  # *) draw pathfinding arrow
  #-------------------------------------------------------------------------
  def draw_pathfinding_arrow
    
  end
  #-------------------------------------------------------------------------
end
#==============================================================================#
#                                                                              #
#                      ▼   End of File   ▼                                     #
#                                                                              # 
#==============================================================================#
