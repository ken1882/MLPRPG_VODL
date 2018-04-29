#-------------------------------------------------------------------------------
# * [ACE] Sapphire Action System IV
#-------------------------------------------------------------------------------
# * By Khas Arcthunder - arcthunder.site40.net
# * Version: 4.4 EN
# * Released on: 11/07/2012
#
#-------------------------------------------------------------------------------
# * Terms of Use
#-------------------------------------------------------------------------------
# Terms of Use – June 22, 2012
# 1. You must give credit to Khas;
# 2. All Khas scripts are licensed under a Creative Commons license
# 3. All Khas scripts are free for non-commercial projects. If you need some 
#    script for your commercial project, check bellow these terms which 
#    scripts are free and which scripts are paid for commercial use;
# 4. All Khas scripts are for personal use, you can use or edit for your own 
#    project, but you are not allowed to post any modified version;
# 5. You can’t give credit to yourself for posting any Khas script;
# 6. If you want to share a Khas script, don’t post the script or the direct 
#    download link, please redirect the user to http://arcthunder.site40.net/
# 7. You are not allowed to convert any of Khas scripts to another engine, 
#    such converting a RGSS3 script to RGSS2 or something of that nature.
# 8. Its your obligation (user) to check these terms on the date you release 
#    your game. Your project must follow them correctly.
#
# Free commercial use scripts:
# - Sapphire Action System IV (RPG Maker VX Ace)
# - Awesome Light Effects (RPG Maker VX Ace)
# - Pixel movement (RPG Maker VX e RPG Maker VX Ace)
# - Sprite & Window Smooth Sliding (RPG Maker VX e RPG Maker VX Ace)
# - Pathfinder (RPG Maker VX Ace)
#
# Check all the terms at http://arcthunder.site40.net/terms/
#
#-------------------------------------------------------------------------------
# * Features
#-------------------------------------------------------------------------------
# The Sapphire Action System IV includes the following features:
# - Pixel Movement
# - Realistic collisions
# - Easy to use
# - Skill support
#
#-------------------------------------------------------------------------------
# * Instructions
#-------------------------------------------------------------------------------
# All the instructions are on SAS IV guide. Please read them carefully.
#
#-------------------------------------------------------------------------------
# * How to use
#-------------------------------------------------------------------------------
# 1. Physics System
# In order to run this script with the best performance, there's a system 
# called "Physics". This system will load each map between the transitions,
# so you may experience little loadings. The Khas Pixel Movement is not 
# recommended for huge maps.
#
# 2. Event Commands (place a comment)
# There are two special commands for events, you may add a comment with
# the following sintax:
#
# a. [collision_x A]
# This command sets the x collision to A (A must be an integer)
#
# b. [collision_y B]
# This command sets the y collision to B (B must be an integer)
#
# Please check the demo to understand how the collision system works!
#
# 3. Event Commands (call script)
# You can call the following commands for the player or the events
#
# character.px
# This command returns the pixel coordinate X (4 px = 1 tile)
#
# character.py
# This command returns the pixel coordinate Y (4 py = 1 tile)
#
# character.pixel_passable?(px,py,d)
# This command checks the pixel passability from (px, py) to the direction d.
# 
# 4. Map Commands
# You can call a special command to update the passability of the current
# map. You MUST run this command if the option "Auto_Refresh_Tile_Events"
# is set to false.
#
# "But when do I need to use this command?"
# Well, if you change a event graphic to a tileset graphic, or if you remove
# this event graphic, then your map need to be updated!
#
# $game_map.refresh_table(start_x,start_y,end_x,end_y)
#
# Where:
# start_x => Initial X
# start_y => Initial Y
# end_x => End X
# end_y => End Y
#
#-------------------------------------------------------------------------------
# * Warning!
#-------------------------------------------------------------------------------
# Check your tileset directions. If any direction is set as unpassable, the
# system will set the whole tile as unpassable. Setup your tilesets before
# using them!
#
#-------------------------------------------------------------------------------
# * Setup Part (Sapphire Engine)
#-------------------------------------------------------------------------------
# tag: movement
#-------------------------------------------------------------------------------
# * Game CharacterBase
#-------------------------------------------------------------------------------
class Game_CharacterBase
  include Pixel_Core
  #-------------------------------------------------------------------------------
  # * Instance variables
  #-------------------------------------------------------------------------------
  attr_accessor :px
  attr_accessor :py
  attr_accessor :cx
  attr_accessor :cy
  #-------------------------------------------------------------------------------
  # * Alias mehtods
  #-------------------------------------------------------------------------------
  alias kp_moveto moveto
  alias kp_move_straight move_straight
  alias kp_move_diagonal move_diagonal
  alias kp_bush? bush?
  alias kp_ladder? ladder?
  alias kp_terrain_tag terrain_tag
  alias kp_region_id region_id
  alias sas_update update
  alias sas_public_members init_public_members
  alias sas_straighten straighten
  #-------------------------------------------------------------------------------
  # * New: Range in pixel
  #-------------------------------------------------------------------------------
  def pixel_range?(px,py)
    #puts "#{@cx} #{@cy}"
    #puts "#{@x},#{@y};#{px},#{py}; #{(@px - px).abs <= @cx && (@py - py).abs <= @cy}"
    #puts "#{@x},#{@y};#{px/4},#{py/4}; #{(@x - px/4).abs <= 1 && (@py - py/4).abs <= 1}"
    #return (@x - px/4).abs <= 1 && (@py - py/4).abs <= 1
    return (@px - px).abs <= @cx && (@py - py).abs <= @cy
  end
  #-------------------------------------------------------------------------------
  # * Alias: Frame update
  #-------------------------------------------------------------------------------
  def update
    sas_update
    update_step_action if @step_action
  end
  #-------------------------------------------------------------------------------
  # * Alias: Straighten
  #-------------------------------------------------------------------------------
  def straighten
    sas_straighten
    @step_action = false
    @step_timer = 0
  end
  #-------------------------------------------------------------------------------
  #  New: Update_step_action
  #-------------------------------------------------------------------------------
  def update_step_action
    case @step_timer
    when 12; @pattern = 0
    when 8; @pattern = 1
    when 4; @pattern = 2
    when 0
      @step_action = false
      @pattern = 1
      return
    end
    @step_timer -= 1
  end
  #-------------------------------------------------------------------------------
  # * New: Do_step
  #-------------------------------------------------------------------------------
  def do_step
    @step_action = true
    @step_timer = 12
  end
  #-------------------------------------------------------------------------------
  # * Alias: init public vars
  #-------------------------------------------------------------------------------
  def init_public_members
    sas_public_members
    @x = @x.to_f
    @y = @y.to_f
    @px = (@x*Pixel).to_i
    @py = (@y*Pixel).to_i
    @cx = Default_Collision_X
    @cy = Default_Collision_Y
    @step_action = false
    @step_timer = 0
  end
  #-------------------------------------------------------------------------------
  # * Alias: moveto address immediately
  #-------------------------------------------------------------------------------
  def moveto(x,y)
    kp_moveto(x,y)
    @x = @x.to_f
    @y = @y.to_f
    @px = (@x*Pixel).to_i
    @py = (@y*Pixel).to_i
  end
  #-------------------------------------------------------------------------------
  # * New: Pixel passable?
  #-------------------------------------------------------------------------------
  def pixel_passable?(px,py,d)
    nx = px + Tile_Range[d][0]
    ny = py + Tile_Range[d][1]
    return false unless $game_map.pixel_valid?(nx,ny)
    return true  if @through || debug_through?
    return false if $game_map.pixel_table[nx,ny,0] == 0
    return false if collision?(nx,ny)
    return true
  end
  #-------------------------------------------------------------------------------
  # * New: Collision?
  # tag: effectus
  #-------------------------------------------------------------------------------
  def collision?(px, py)
    return false if through_character?
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        next if event.through || event == self
        return true if event.priority_type == 1
      end
    end
    
    if @priority_type == 1
      return true if ($game_player.px - px).abs <= @cx && ($game_player.py - py).abs <= @cy && !$game_player.dead?
    end
    return false
  end
  #-------------------------------------------------------------------------------
  def collision_character?(char)
    return false if char == self
    return (char.px - px) <= char.cx && (char.py - py).abs <= char.cy
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: move_straight
  #-------------------------------------------------------------------------------
  def move_straight(d,turn_ok = true)
    move_pixel(d,turn_ok)
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: move diagonal
  #-------------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    move_dpixel(horz,vert)
  end
  #-------------------------------------------------------------------------------
  # * New: move_pixel     # tag: movement
  #-------------------------------------------------------------------------------
  def move_pixel(d,t = true)
    return if moving?
    $game_player.followers.move if self.is_a?(Game_Player)
    @move_succeed = pixel_passable?(@px, @py, d)
    if @move_succeed
      set_direction(d)
      @px += Tile_Range[d][0]
      @py += Tile_Range[d][1]
      @real_x = @x
      @real_y = @y
      @x += Pixel_Range[d][0]
      @y += Pixel_Range[d][1]
      increase_steps
    elsif t
      set_direction(d)
      return front_pixel_touch?(@px + Tile_Range[d][0],@py + Tile_Range[d][1])
    end
  end
  #-------------------------------------------------------------------------------
  # * New: move diagonal pixel
  #-------------------------------------------------------------------------------
  def move_dpixel(h,v)
    return if moving?
    @move_succeed = false
    touched = false
    
    if pixel_passable?(@px,@py,v)
      @move_succeed = true
      @real_x = @x
      @real_y = @y
      set_direction(v)
      @px += Tile_Range[v][0]
      @py += Tile_Range[v][1]
      @x += Pixel_Range[v][0]
      @y += Pixel_Range[v][1]
      increase_steps
    else
      set_direction(v)
      touched |= front_pixel_touch?(@px + Tile_Range[v][0],@py + Tile_Range[v][1])
    end
    
    if pixel_passable?(@px,@py,h)
      unless @move_succeed 
        @real_x = @x
        @real_y = @y
        @move_succeed = true
      end
      set_direction(h)
      @px += Tile_Range[h][0]
      @py += Tile_Range[h][1]
      @x += Pixel_Range[h][0]
      @y += Pixel_Range[h][1]
      increase_steps
    else
      set_direction(h)
      touched |= front_pixel_touch?(@px + Tile_Range[h][0],@py + Tile_Range[h][1])
    end
    $game_player.followers.move if self.is_a?(Game_Player)
    return touched
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: on bush tile?
  #-------------------------------------------------------------------------------
  def bush?
    return $game_map.pixel_table[@px, @py, 4] == 1
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: on ladder tile?
  #-------------------------------------------------------------------------------
  def ladder?
    return $game_map.pixel_table[@px, @py, 3] == 1
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: return current terrain tag
  #-------------------------------------------------------------------------------
  def terrain_tag
    rx = ((@px % Pixel) > 1 ? @x.to_i + 1 : @x.to_i)
    ry = ((@py % Pixel) > 1 ? @y.to_i + 1 : @y.to_i)
    return $game_map.terrain_tag(rx,ry)
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: return current region id
  #-------------------------------------------------------------------------------
  def region_id
    rx = ((@px % Pixel) > 1 ? @x.to_i + 1 : @x.to_i)
    ry = ((@py % Pixel) > 1 ? @y.to_i + 1 : @y.to_i)
    return $game_map.region_id(rx, ry)
  end
  #-------------------------------------------------------------------------------
  # * New: Front collision detect, save for latter use
  #-------------------------------------------------------------------------------
  def front_pixel_touch?(x,y)
  end
end
#-------------------------------------------------------------------------------
# * Game Character
#-------------------------------------------------------------------------------
class Game_Character < Game_CharacterBase
  #-------------------------------------------------------------------------------
  # * Public instance variables
  #-------------------------------------------------------------------------------
  attr_accessor :pattern 
  #-------------------------------------------------------------------------------
  # * Alias methods
  #-------------------------------------------------------------------------------
  alias kp_force_move_route force_move_route
  alias kp_move_toward_character move_toward_character
  alias kp_move_away_from_character move_away_from_character
  alias kp_jump jump
  #-------------------------------------------------------------------------------
  # * Alias: force move route
  #-------------------------------------------------------------------------------
  def force_move_route(route)
    kp_force_move_route(route.clone)
    multiply_commands
  end
  #-------------------------------------------------------------------------------
  # * multiply movements by 4 to a tile
  #-------------------------------------------------------------------------------
  def multiply_commands
    return unless Multiply_Commands
    return if @move_route.list.empty?
    new_route = []
    for cmd in @move_route.list
      if Commands.include?(cmd.code)
        Pixel.times do
          new_route << cmd
        end
      else
        new_route << cmd
      end
    end
    @move_route.list = new_route
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: move toeard character
  # return: touch any chatacter?
  #-------------------------------------------------------------------------------
  def move_toward_character(character)
    dx = @px - character.px
    dy = @py - character.py
    if dx.abs < character.cx
      unless dy.abs < character.cy
        move_pixel(dy < 0 ? 2 : 8) 
        unless @move_succeed
          return if dx.abs - Chase_Axis[@direction][0] <= @cx && dy.abs - Chase_Axis[@direction][1] <= @cy
          move_dpixel(dx < 0 ? 6 : 4, dy < 0 ? 2 : 8)
        end
      end
    else
      if dy.abs < character.cy
        move_pixel(dx < 0 ? 6 : 4)
        unless @move_succeed
          return if dx.abs - Chase_Axis[@direction][0] <= @cx && dy.abs - Chase_Axis[@direction][1] <= @cy
          move_dpixel(dx < 0 ? 6 : 4, dy < 0 ? 2 : 8)
        end
      else
        move_dpixel(dx < 0 ? 6 : 4, dy < 0 ? 2 : 8)
      end
    end
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: move away from character
  #-------------------------------------------------------------------------------
  def move_away_from_character(character)
    dx = @px - character.px
    dy = @py - character.py
    if dx == 0
      move_pixel(dy > 0 ? 2 : 8,true)
    else
      if dy == 0 
        move_pixel(dx > 0 ? 6 : 4,true)
      else
        move_dpixel(dx > 0 ? 6 : 4, dy > 0 ? 2 : 8)
      end
    end
  end
  #-------------------------------------------------------------------------------
  # * Alias: jump
  #-------------------------------------------------------------------------------
  def jump(xp,yp)
    kp_jump(xp,yp)
    @px = @x*Pixel
    @py = @y*Pixel
  end
end
#-------------------------------------------------------------------------------
# * Game Player
#-------------------------------------------------------------------------------
class Game_Player < Game_Character
  #-------------------------------------------------------------------------------
  # * Overwite: Determine if Same Position Event is Triggered
  #-------------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    for event in $game_map.events.values
      if (event.px - @px).abs <= event.cx && (event.py - @py).abs <= event.cy
        event.start if triggers.include?(event.trigger) && event.priority_type != 1
      end
    end
  end
  #-------------------------------------------------------------------------------
  # * Overwite: Determine if Front Event is Triggered
  #-------------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    fx = @px+Trigger_Range[@direction][0]
    fy = @py+Trigger_Range[@direction][1]
    for event in $game_map.events.values
      if (event.px - fx).abs <= event.cx && (event.py - fy).abs <= event.cy
        if triggers.include?(event.trigger) && event.normal_priority?
          event.start
          return
        end
      end
    end
    if $game_map.pixel_table[fx,fy,5] == 1
      fx += Counter_Range[@direction][0]
      fy += Counter_Range[@direction][1]
      for event in $game_map.events.values
        if (event.px - fx).abs <= event.cx && (event.py - fy).abs <= event.cy
          if triggers.include?(event.trigger) && event.normal_priority?
            event.start
            return
          end
        end
      end
    end
  end
  #-------------------------------------------------------------------------------
  # * Front pixel collision check
  #-------------------------------------------------------------------------------
  def front_pixel_touch?(px,py)
    return if $game_map.interpreter.running?
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        if [1,2].include?(event.trigger) && event.normal_priority?
          event.start
          result = true
        end
      end
    end
  end
  #-------------------------------------------------------------------------------
  # * Pixel move passable?
  #-------------------------------------------------------------------------------
  def pixel_passable?(px,py,d)
    nx = px + Tile_Range[d][0]
    ny = py + Tile_Range[d][1]
    return false unless $game_map.pixel_valid?(nx,ny)
    return true if @through || debug_through?
    #puts "#{nx} #{ny} #{px} #{py} #{d} #{$game_map.pixel_table[nx,ny,0]}"
    return false if $game_map.pixel_table[nx,ny,0] == 0
    return false if collision?(nx,ny)
    return true
  end
  #-------------------------------------------------------------------------------
  # * Overwrite: Processing of Movement via Input from Directional Buttons
  #-------------------------------------------------------------------------------
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    d = Input.dir8
    case d
    when 1; move_dpixel(4,2)
    when 2; move_pixel(2,true)
    when 3; move_dpixel(6,2)
    when 4; move_pixel(4,true)
    when 6; move_pixel(6,true)
    when 7; move_dpixel(4,8)
    when 8; move_pixel(8,true)
    when 9; move_dpixel(6,8)
    end
    update_cancel_action if d > 0
  end
  #-------------------------------------------------------------------------------
  # * Disable damage floor
  #-------------------------------------------------------------------------------
  def on_damage_floor?
    return false
  end
  #-------------------------------------------------------------------------------
  # * Collision check
  #-------------------------------------------------------------------------------
  def collision?(px, py)
    return false if through_character?
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        next if event.through
        return true if event.priority_type == 1
      end
    end
    return false
  end
  #-------------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    super(d, turn_ok)
  end
  #-------------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    super(horz, vert)
  end
  
end
#-------------------------------------------------------------------------------
# * Game Event
#-------------------------------------------------------------------------------
class Game_Event < Game_Character
  #-------------------------------------------------------------------------------
  # * Alias methods
  #-------------------------------------------------------------------------------
  alias sas_initialize initialize
  alias kp_move_type_toward_player move_type_toward_player
  alias kp_setup_page_settings setup_page_settings
  #-------------------------------------------------------------------------------
  # * Alias: initialize
  #-------------------------------------------------------------------------------
  def initialize(m,e)
    sas_initialize(m,e)
    setup_collision
  end
  #-------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------
  def move_type_toward_player
    move_toward_player if near_the_player?
  end
  #-------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------
  def setup_page_settings
    kp_setup_page_settings
    setup_collision
    multiply_commands
  end
  #-------------------------------------------------------------------------------
  def collision?(px, py)
    return false if through_character?
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        next if event.through || event == self
        return true if event.priority_type == 1
      end
    end
    
    for follower in $game_player.followers
      next unless follower.actor || follower.through
      return false if follower.dead?
      return true if (follower.px - px).abs <= follower.cx && (follower.py - py).abs <= follower.cy
    end
    
    if @priority_type == 1
      return true if ($game_player.px - px).abs <= @cx && ($game_player.py - py).abs <= @cy && !$game_player.dead?
    end
    return false
  end
  #-------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------
  def setup_collision
    @cx = Default_Collision_X
    @cy = Default_Collision_Y
    unless @list.nil?
      for value in 0...@list.size
        next if @list[value].code != 108 && @list[value].code != 408
        if @list[value].parameters[0].include?("[collision_x ")
          @list[value].parameters[0].scan(/\[collision_x ([0.0-9.9]+)\]/)
          @cx = $1.to_i
        end
        if @list[value].parameters[0].include?("[collision_y ")
          @list[value].parameters[0].scan(/\[collision_y ([0.0-9.9]+)\]/)
          @cy = $1.to_i
        end
      end
    end
  end
  #-------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------
  def front_pixel_touch?(px,py)
    return if $game_map.interpreter.running?
    if @enemy.nil?
      if @trigger == 2 && ($game_player.px - px).abs <= @cx && ($game_player.py - py).abs <= @cy
        start if !jumping? && normal_priority?
      end
    else
      return# if jumping? || @recover > 0 || @enemy.nature == 2 || @enemy.object
      #attack if $game_map.sas_active && ($game_player.px - px).abs <= @cx && ($game_player.py - py).abs <= @cy
    end
  end
  
end
#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
class Game_Follower < Game_Character
  #-------------------------------------------------------------------------------
  # * Collision check
  #-------------------------------------------------------------------------------
  def collision?(px, py)
    return false if through_character?
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        next if event.through
        return true if event.priority_type == 1
      end
    end
    
    return false
  end
  
end
