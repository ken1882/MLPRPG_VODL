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
  def over_edge?(x,y)
    x < 0 || y < 0 || x >= width || y >= height
  end
  
end

#==============================================================================
# ** Map_Address_Node
#------------------------------------------------------------------------------
# This class is using to save the movement cost and address for the later class
# PathFinding_Queue
#==============================================================================

class Map_Address_Node
  
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
    
    start_node = Map_Address_Node.new(init_x,init_y)
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
    
    return (dx1.abs + dy1.abs) * 10 + (dx1 * dy2 - dx2 * dy1).abs
  end
  
  #--------------------------------------------------------------------------
  # *  Push new scanned address
  #--------------------------------------------------------------------------
  def push(source_loc,current_loc,next_loc,dir, goal_loc)
    
    extra_cost = Math.hypot(next_loc.x - goal_loc.x, next_loc.y - goal_loc.y).to_i * 5
    extra_cost += Math.hypot(next_loc.x - source_loc.x, next_loc.y - source_loc.y).to_i * 5
    
    $saved_cost = extra_cost
    node_cost = predict_movement_cost(source_loc,current_loc,goal_loc) + extra_cost
    
    node = Map_Address_Node.new(next_loc.x,next_loc.y,node_cost)
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
        command_id = 1
      when 4
        debug_info = "←"
        command_id = 2
      when 6
        debug_info = "→"
        command_id = 3
      when 8
        debug_info = "↑"
        command_id = 4
      else
        debug_info = "O"
      end #case
      
      puts "#{debug_info} (#{curx},#{cury})"
      if command_id > 0
        command = RPG::MoveCommand.new
        command.code = command_id
        cmd_list.push(command)
      end # if command_id > 0
    end # for i in path_address.size
    
    command = RPG::MoveCommand.new
    command.code = 0
    cmd_list.push(command)
    route = RPG::MoveRoute.new
    route.repeat = false
    route.list = cmd_list
    
    return route
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
      path_address.push( Map_Address_Node.new( _address[0], _address[1]) )
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
  # * adjacent posititon? (for free-movement script)
  #--------------------------------------------------------------------------
  def adjacent?(x2 ,y2 , x1 = @x , y1 = @y)
    return (x1 - x2).abs <= 0.6 && (y1 - y2).abs <= 0.6
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
  def move_to_position(goalx,goaly,forced = false, redirect = false, draw_arrow = false)
    return if @move_route_forcing && !forced
    $game_map.clean_pathfinding_arrow if draw_arrow
    
    @on_path_finding = true
    fixed_address = fix_address
    self.moveto(fixed_address[0],fixed_address[1])
    
    fixed_address = fix_address(goalx,goaly)
    goalx = fixed_address[0]
    goaly = fixed_address[1]
    
    tox   = [0,-1,1,0]
    toy   = [1,0,0,-1]
    dir   = [2,4,6,8]
    path_queue = PathFinding_Queue.new(@x,@y)
    path_found = false
    
    while !path_found && !path_queue.empty?
     
      curx = path_queue.top[0]
      cury = path_queue.top[1]
      
      if curx == goalx && cury == goaly
        path_found = true
        break
      end
      
      path_queue.pop
      
      for i in 0...4
        break if path_found
        next_x = (curx + tox[i]).to_i
        next_y = (cury + toy[i]).to_i
        
        # check next path if passable
        if $game_map.passable?(next_x,next_y,dir[i]) && !path_queue.visited?(next_x,next_y) && !$game_map.over_edge?(next_x,next_y)
          next if !passable?(curx, cury, dir[i])
          next if path_blocked_by_event?(next_x,next_y)
          
          if (path_blocked_by_player?(next_x,next_y) && !@through)
            next unless adjacent?(goalx,goaly,$game_player.x,$game_player.y)
          end
          
          
          path_found = true if (next_x == goalx && next_y == goaly)
          
          source_loc  = Map_Address_Node.new(@x,@y)
          current_loc = Map_Address_Node.new(curx,cury)
          next_loc    = Map_Address_Node.new(next_x,next_y)
          goal_loc    = Map_Address_Node.new(goalx,goaly)
          
          path_queue.push(source_loc,current_loc,next_loc,dir[i],goal_loc)
          #=====================================================================
          # Draw search arrow
          #=====================================================================
          if draw_arrow
            $game_map.data[next_x,next_y,2] = 887 + dir[i].to_i/2 
            $game_map.interpreter.wait(1)
          end
          
        end # if passable?
        path_queue.mark_visited(next_x,next_y)
        
      end # for i in 0...4
    end # while
    
    if path_found
      
      @move_route_forcing = true
      route = path_queue.get_walk_path(goalx,goaly)
      force_move_route(route)
      
      @original_move_route        = nil if forced
      @original_move_route_index  = 0   if forced
      
    end # if path found
    
    return path_found
  end # def move_to_position
  
  
  #--------------------------------------------------------------------------
  # * Overwrite Method: Process Move Route End
  #--------------------------------------------------------------------------
  def process_route_end
    if @move_route.repeat
      @move_route_index = -1
    elsif @move_route_forcing
      @on_path_finding = false
      @move_route_forcing = false
      restore_move_route
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
  #--------------------------------------------------------------------------
  # * overwrite method: setup_page_settings
  #--------------------------------------------------------------------------
  def setup_page_settings
    @tile_id          = @page.graphic.tile_id
    @character_name   = @page.graphic.character_name
    @character_index  = @page.graphic.character_index
    
    if @original_direction != @page.graphic.direction
      @direction          = @page.graphic.direction
      @original_direction = @direction
      @prelock_direction  = 0
    end
    
    if @original_pattern != @page.graphic.pattern
      @pattern            = @page.graphic.pattern
      @original_pattern   = @pattern
    end
    
    @move_type          = @page.move_type
    @move_speed         = @page.move_speed
    @move_frequency     = @page.move_frequency
    
    #tag: modified here
    if !@on_path_finding || @on_path_finding.nil?
      @move_route         = @page.move_route
      @move_route_index   = 0               
      @move_route_forcing = false           
    end
    
    @walk_anime         = @page.walk_anime
    @step_anime         = @page.step_anime
    @direction_fix      = @page.direction_fix
    @through            = @page.through
    @priority_type      = @page.priority_type
    @trigger            = @page.trigger
    @list               = @page.list
    @interpreter = @trigger == 4 ? Game_Interpreter.new : nil
  end
end


class Game_Map
  
  def clean_pathfinding_arrow
    dir = [2,4,6,8]
      for i in 0..$game_map.width
        for j in 0..$game_map.height
            for c in 0...4
              if $game_map.passable?(i,j,dir[c]) && $game_player.passable?(i,j,dir[c])
                $game_map.data[i,j,2] = 893 
              end
              
            end # for c
        end # for j 
      end # for i
  end # def clean_
  
end # Game_Map
