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
        Pixel_Core::Pixel.times{ cmd_list << [command_id, true] }
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
  attr_accessor   :move_poll
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_members_comp init_public_members
  def init_public_members
    init_public_members_comp
    @pathfinding_moves = []
    @move_poll         = []
    @pathfinding_goal  = nil
    @force_pathfinding = true
    @pathfinding_timer = 0
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
  #--------------------------------------------------------------------------
  def clear_pathfinding_moves
    @pathfinding_moves.clear
    @move_poll.clear
  end
  #--------------------------------------------------------------------------
  # * next step is blocked by events?
  #--------------------------------------------------------------------------
  def path_blocked_by_event?(next_x,next_y)
    px, py = next_x * 4, next_y * 4
    return collision?(px, py)
  end # def path_blocked
  
  #--------------------------------------------------------------------------
  # * next step is blocked by events?
  #--------------------------------------------------------------------------
  def path_blocked_by_player?(next_x,next_y)
    return collision_character?($game_player)
  end # def path_blocked_by_player
  #--------------------------------------------------------------------------
  # * core function, move to assigned position
  #--------------------------------------------------------------------------
  def move_to_position(goalx, goaly, args = {})
    return true unless @pathfinding_timer == 0 || args[:forced]
    @pathfinding_timer = 60
    clear_pathfinding_moves
    
    ti = Time.now
    depth          = args[:depth].nil?          ? 100   : args[:depth]
    tool_range     = args[:tool_range].nil?     ? 0     : args[:tool_range]
    draw_arrow     = args[:draw_arrow].nil?     ? false : true
    through_player = args[:through_player].nil? ? false : true
    through_event  = args[:through_event].nil?  ? false : true
    debug          = args[:debug].nil?          ? false : true
    
    puts SPLIT_LINE if debug
    puts "Current Address: #{@x} #{@y}" if debug
    puts "Goal: #{goalx} #{goaly}"      if debug
    $game_map.clean_pathfinding_arrow if draw_arrow
    $pathfinding_debug = debug
    @on_path_finding = true
    fixed_address = fix_address
    
    fx = fixed_address[0]; fy = fixed_address[1] 
    fixed_address = fix_address(goalx,goaly)
    ori_goalx = goalx
    ori_goaly = goaly
    goalx = fixed_address[0]
    goaly = fixed_address[1]
    
    tox   = [0,-1,1,0]
    toy   = [1,0,0,-1]
    dir   = [2,4,6,8]
    cnt   = 0
    path_queue = PathFinding_Queue.new([fx,0].max,[fy,0].max)
    path_found = false
    best_path  = path_queue.dup
    bestx, besty = fx, fy
    puts "Current pos fixed: #{fx} #{fy}" if debug
    puts "Goal Fixed: #{goalx} #{goaly}"  if debug
    while !path_found && !path_queue.empty? && cnt <= depth
      
      cnt += 1
      curx = path_queue.top[0]
      cury = path_queue.top[1]
      
      path_queue.distance = [path_queue.distance, Math.hypot(goalx - curx, goaly - cury)].min
      if curx == goalx && cury == goaly
        path_found = true
        puts "Path found: #{curx} #{cury}" if debug
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
          next if !through_event && path_blocked_by_event?(next_x,next_y) && !adjacent?(next_x, next_y, goalx, goaly)
          
          if (!through_player && path_blocked_by_player?(next_x,next_y) && !@through)
            next unless adjacent?(goalx,goaly,$game_player.x,$game_player.y)
          end
          
          if adjacent?(next_x, next_y, goalx, goaly)
            path_found = true
            puts "Path found by adjacent: #{next_x} #{next_y}" if debug
          elsif ((next_x - goalx).abs + (next_y - goaly).abs ) <= tool_range && path_clear?(curx, cury, goalx, goaly)
            goalx = next_x
            goaly = next_y
            path_found = true
            puts "Path found by range: #{next_x} #{next_y}" if debug
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
      debug_print "Destination x,y: #{goalx}, #{goaly}" if debug
    end # if !path found
    
    debug_print "Pathfinding time takes: #{Time.now.to_f - ti.to_f}" if debug
    @pathfinding_moves = best_path.get_walk_path(goalx,goaly)
    finalize_offset(fx, fy)
    push_movement_offset(ori_goalx, ori_goaly, goalx, goaly)
    debug_print "Pathfinding moves: #{@pathfinding_moves.size}" if debug
    interpret_debug_moves if debug
    return path_found
  end # def move_to_position
  #--------------------------------------------------------------------------
  def finalize_offset(fx,fy)
    return if fx == @x && fy == @y
    return if @pathfinding_moves.size < 4
    next_step   = @pathfinding_moves.shift(4).at(0)
    corrections = []
    next_dir = next_step[0]
    next_pos = POS.new(fx, fy)
    case next_dir
    when 2; next_pos.y += 1;
    when 4; next_pos.x -= 1;
    when 6; next_pos.x += 1;
    when 8; next_pos.y -= 1;
    end
    delta_x = next_pos.x - @x; delta_y = next_pos.y - @y
    puts "Next pos: #{next_pos.x} #{next_pos.y}" if $pathfinding_debug
    puts "Offset delta: #{delta_x} #{delta_y}" if $pathfinding_debug
    (delta_x * Pixel_Core::Pixel).abs.to_i.times do 
      corrections << [delta_x > 0 ? 6 : 4 , next_step[1]]
    end
    (delta_y * Pixel_Core::Pixel).abs.to_i.times do 
      corrections << [delta_y > 0 ? 2 : 8 , next_step[1]]
    end
    corrections.reverse.each{|step| @pathfinding_moves.unshift(step)}
  end
  #--------------------------------------------------------------------------
  def push_movement_offset(fx, fy, tx, ty)
    offset_x, offset_y = fx - tx, fy - ty
    if offset_x != 0
      t = (offset_x / 0.25).abs.to_i
      dir = offset_x < 0 ? 4 : 6
      puts "Offset dir X: #{dir}, times: #{t}" if $pathfinding_debug
      t.times { @pathfinding_moves << [dir ,true] }
    end
    if offset_y != 0
      t = (offset_y / 0.25).abs.to_i
      dir = offset_y < 0 ? 8 : 2
      puts "Offset dir Y: #{dir}, times: #{t}" if $pathfinding_debug
      t.times { @pathfinding_moves << [dir ,true] }
    end
  end
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
  def trigger_movement_key?
    return false unless self.is_a?(Game_Player)
    return Input.press?(:DOWN) || Input.press?(:kS) || Input.press?(:LEFT)  || Input.press?(:kA) ||
           Input.press?(:UP)   || Input.press?(:kW) || Input.press?(:RIGHT) || Input.press?(:kD)
  end
  #--------------------------------------------------------------------------
  # * Process pathfinding movement
  #--------------------------------------------------------------------------
  # tag: movement
  def process_pathfinding_movement
    return clear_pathfinding_moves if trigger_movement_key?
    return if moving?
    return unless @pathfinding_moves.size > 0 && @move_poll.empty?
    @move_poll << @pathfinding_moves.shift
    @followers.move if self.is_a?(Game_Player)
    interpret_move(true)
  end
  #-------------------------------------------------------------------------
  # * Execute queued movement
  #-------------------------------------------------------------------------
  def interpret_move(through_character = false)
    return if @move_poll.empty?
    route = @move_poll.shift
    move_pixel(route[0], route[1], through_character)
  end
  #-------------------------------------------------------------------------
  def interpret_debug_moves
    pos = POS.new(@x, @y)
    @pathfinding_moves.each do |step|
      dir = step[0]
      case dir
      when 2
        debug_info = "↓"
        pos.y += 1.0 / Pixel_Core::Pixel
      when 4
        debug_info = "←"
        pos.x -= 1.0 / Pixel_Core::Pixel
      when 6
        debug_info = "→"
        pos.x += 1.0 / Pixel_Core::Pixel
      when 8
        debug_info = "↑"
        pos.y -= 1.0 / Pixel_Core::Pixel
      else
        debug_info = "O"
      end #case
      debug_info += " (#{pos.x},#{pos.y})"
      puts debug_info
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
