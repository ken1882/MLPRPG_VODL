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
  #   address over the map's width / height?
  #------------------------------------------------------------------------------
  def over_edge?(x,y)
    return if @map.nil?
    x < 0 || y < 0 || x >= width || y >= height
  end
  
  #------------------------------------------------------------------------------
  # Only work in testing map
  #------------------------------------------------------------------------------
  def clean_pathfinding_arrow
    
  end # def clean_pathfinding_arrow
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor   :pathfinding_moves
  attr_accessor   :pathfinding_goal
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_members_comp init_public_members
  def init_public_members
    init_public_members_comp
    @pathfinding_moves = []
    @pathfinding_goal  = nil
  end
  #--------------------------------------------------------------------------
  # * adjacent posititon? (for free-movement script)
  #--------------------------------------------------------------------------
  def adjacent?(x2 ,y2 , x1 = @x , y1 = @y)
    return (x1 - x2).abs < 0.6 && (y1 - y2).abs < 0.6
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
  def move_to_position(goalx,goaly,forced = false, redirect = false, draw_arrow = false,debug = false)
    $game_map.clean_pathfinding_arrow if draw_arrow
    $pathfinding_debug = debug
    
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
          next if path_blocked_by_event?(next_x,next_y) && next_x != goalx && next_y != goaly
          
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
          if draw_arrow && SceneManager.scene.is_a?(Scene_Map)
            
          end
          
        end # if passable?
        path_queue.mark_visited(next_x,next_y)
        
      end # for i in 0...4
    end # while
    #puts "[Path Finding]: #{path_found} (#{@x},#{@y}) -> (#{goalx},#{goaly})"
    if path_found
      @pathfinding_moves = path_queue.get_walk_path(goalx,goaly)
      process_pathfinding_movement
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
#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================
class Spriteset_Map
  #-----------------------------------------------------------------------------
  # *) Instance Variables
  #-----------------------------------------------------------------------------
  
  #--------------------------------------------------------------------------
  # * Alias: Create Character Sprite
  #--------------------------------------------------------------------------
  alias create_characters_tactic create_characters
  def create_characters
    create_characters_tactic
    
    battlers = SceneManager.all_battlers
    @units = []
    $battle_unit_sprites  = []
    @character_sprites.each do |char|
      next unless battlers.include?(char.character)
      obj = Unit_Circle.new(@viewport1, char, char.character)
      @units.push(obj)
      $battle_unit_sprites.push(obj)
    end
  end
  #----------------------------------------------------------------------------
end
#==============================================================================#
#                                                                              #
#                      ▼   End of File   ▼                                     #
#                                                                              # 
#==============================================================================#
