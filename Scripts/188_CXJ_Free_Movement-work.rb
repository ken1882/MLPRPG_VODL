#==============================================================================
# 
# GaryCXJk - Free Movement v0.86
# * Last Updated: 2013.08.02
# * Level: Medium
# * Requires: N/A
# * Optional: CXJ - AnimEx v1.01+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["CXJ-FreeMovement"] = true

#==============================================================================
#
# Changelog:
#
#------------------------------------------------------------------------------
# 2013.08.02 - v0.86
#
# * Added: Follow types
# * Fixed: Jumping not going in the right direction
#
#------------------------------------------------------------------------------
# 2013.07.06 - v0.85
#
# * Fixed: Touch events get triggered when moving after transfers
#
#------------------------------------------------------------------------------
# 2013.06.09 - v0.84
#
# * Added: Capabilities to disable Free Movement per map
#
#------------------------------------------------------------------------------
# 2013.01.12 - v0.83
#
# * Added: Option to only let the closest event get triggered
# * Added: Event comment tags for event collision boxes
#
#------------------------------------------------------------------------------
# 2013.01.12 - v0.82
#
# * Added: Map notetags for event collision boxes
# * Fixed: In case the initializor of Game_CharacterBase gets overridden, the
#          script would fail on a certain check
#
#------------------------------------------------------------------------------
# 2013.01.11 - v0.81
#
# * Fixed: Vehicles could be boarded even if not on the map
#
#------------------------------------------------------------------------------
# 2013.01.11 - v0.80
#
# * Initial release
#
#==============================================================================
#
# RPG Maker VX Ace is mainly constrained to the grid. Luckily there are quite
# some scripts that add off-the-grid movement, mainly called "pixel movement".
# As that's kind of a BS term for something like that (it implies you can only
# travel per pixel, and most of the time it skips a few pixels anyway), I just
# give it a more general term.
#
# Free Movement gives you freedom of movement in eight directions. I'd love to
# implement free movement in three dimensions, but the engine isn't built on
# 3D. Yet.
#
#==============================================================================
#
# Installation:
#
# Make sure to put this below Materials, but above Main Process.
#
# This script overrides several methods. If you are sure no method that is
# used by other scripts get overridden, you can place it anywhere, otherwise,
# make sure this script is loaded first. Do know that there is a possibility
# that this script will stop working due to that.
#
# This script adds aliases for several methods. If you are sure no method that
# is used by other scripts get overridden, you can place it anywhere,
# otherwise, make sure this script is loaded after any other script overriding
# these methods, otherwise this script stops working.
#
# This script has additional functionality and / or compatibility with other
# scripts. In order to benefit the most out of it, it is advised to place this
# script after the others.
#
#------------------------------------------------------------------------------
# Overridden functions:
#
# * class Game_Player
#   - move_by_input
#
#------------------------------------------------------------------------------
# Aliased methods:
#
# * class Game_Map
#   - setup(map_id)
#   - check_passage(x, y, bit)
#   - refresh setup_events
#   - round_x_with_direction(x, d)
#   - round_y_with_direction(y, d)
# * class Game_CharacterBase
#   - initialize
#   - update
#   - check_event_trigger_touch_front
#   - passable?(x, y, d)
#   - diagonal_passable?(x, y, horz, vert)
#   - set_direction(d)
#   - move_straight(d, turn_ok = true)
#   - move_diagonal(horz, vert)
#   - collide_with_events?(x, y)
#   - collide_with_vehicles?(x, y)
#   - update_jump
#   - jump_height
# * class Game_Character
#   - process_move_command(command)
#   - move_random
#   - move_toward_character(character)
#   - move_away_from_character(character)
#   - move_forward
#   - move_backward
#   - jump(x_plus, y_plus)
# * class Game_Player
#   - initialize
#   - refresh
#   - perform_transfer
#   - make_encounter_count
#   - update_nonmoving(last_moving)
#   - start_map_event(x, y, triggers, normal, rect = collision_rect)
#   - check_event_trigger_there(triggers)
#   - get_on_vehicle
#   - get_off_vehicle
#   - map_passable_rect?(x, y, d, rect)
#   - move_diagonal(horz, vert)
#   - collide_with_vehicles?(x, y)
# * class Game_Event
#   - init_public_members
#   - update
#   - refresh
#   - collide_with_player_characters?(x, y)
#   - check_event_trigger_touch(x, y)
# * class Game_Followers
#   - move
# * class Game_Follower
#   - initialize(member_index, preceding_character)
#   - refresh
#   - chase_preceding_character
# * class Game_Vehicle
#   - land_ok?(x, y, d)
# * class Spriteset_Map (When debug is enabled)
#   - create_characters
#   - update_characters
#
#==============================================================================
#
# Usage:
#
# In essence, this script is plug-and-play, however, one can make minor to
# big tweaks to this script without having to touch the actual script. Most of
# the settings in the script are self-explanatory, however, there are two
# things that need explaining.
#
# This script uses collision boxes to determine collisions. As not every sprite
# is of the same size, and even events have different shapes, I wanted to add
# a way to allow for these differences in size. At the moment there are only
# collision boxes for characters and events.
#
# There are two kinds of collision boxes, the regular collision boxes and the
# interaction boxes, the latter being reserved for active player characters.
#
# Collision boxes are for the regular collisions, like passability on terrain,
# or just regular touch events. There are four ways you can define a collsion
# box.
#
# The first is using this script, and by either altering the default settings
# or creating a new collision list. This same collision list is used for the
# vehicles. To actually be able to use this list, you'll need to call it by
# using the following notetag on the actor:
#
# <collisionbox: string>
#
# You can also directly set the collision box on the actor:
#
# <collisionbox: x, y, width, height>
#
# Finally, since events don't use notetags, you can set the collisions using
# either a script, notetags placed on the map itself or comment tags on the
# event itself. For the script method I've added a method to the interpreter,
# so you can just run it directly from the event without having to find the
# event itself. There are  two ways you can use the method.
#
# set_collision_rect(string)
# set_collision_rect(x, y, width, height)
#
# The first way calls the collision box from the collision list. The second
# directly sets the collision. Do note that collision boxes set this way aren't
# persistent, so when the map is reloaded, the script must be run again.
#
# You can also use notetags on the map to define the collision box of the
# event. You'll also need to supply the event name so that it can identify
# which event should get the new collision box.
#
# <collisionbox eventname: string>
# <collisionbox eventname: x, y, width, height>
#
# To make it even more easy to implement collision boxes, you can use the
# following comment tags on the comment blocks in the event itself:
#
# <collisionbox: string>
# <collisionbox: x, y, width, height>
#
# You can use this in two ways. When placed on the first page, it acts as the
# default collision box. This can still be overridden by the map notetag or
# a script, but it's used as the default. However, when placed on a different
# page, it will use that comment page whenever that page is available. That
# means that you can actually use switches or variables to dynamically set
# the collision box without having to use scripts.
#
# There are two ways to set an interaction box. One is by using the interaction
# list, just like how you set a collision list. Do note that each interaction
# entry contains eight values, each representing a direction. Note that the
# collisions are relative to the origin position plus 32 in the direction the
# interaction box is set, so you don't have to correct for that. To use a
# certain list, you can use the following notetag on the actor:
#
# <interactionbox: string>
#
# You can also directly set the collision box on the actor:
#
# <interactionbox d: x, y, width, height>
#
# Note that d is a number, representing a direction.
#
# As it is sometimes hard to see if the collisions work as expected, you can
# enable debugging, which actually shows the collision boxes. Green boxes
# represent collision boxes, while the red box represents the interaction box.
#
# Finally, there might be reasons to disable this script on certain maps. You
# can do so by changing the settings for auto-enable to false, or by using the
# following notetag in the map:
#
# <free-movement-enabled true|false>
#
# This setting has precedence over the global settings.
#
#==============================================================================
#
# License:
#
# Creative Commons Attribution 3.0 Unported
#
# The complete license can be read here:
# http://creativecommons.org/licenses/by/3.0/legalcode
#
# The license as it is described below can be read here:
# http://creativecommons.org/licenses/by/3.0/deed
#
# You are free:
#
# to Share — to copy, distribute and transmit the work
# to Remix — to adapt the work
# to make commercial use of the work
#
# Under the following conditions:
#
# Attribution — You must attribute the work in the manner specified by the
# author or licensor (but not in any way that suggests that they endorse you or
# your use of the work).
#
# With the understanding that:
#
# Waiver — Any of the above conditions can be waived if you get permission from
# the copyright holder.
#
# Public Domain — Where the work or any of its elements is in the public domain
# under applicable law, that status is in no way affected by the license.
#
# Other Rights — In no way are any of the following rights affected by the
# license:
#
# * Your fair dealing or fair use rights, or other applicable copyright
#   exceptions and limitations;
# * The author's moral rights;
# * Rights other persons may have either in the work itself or in how the work
#   is used, such as publicity or privacy rights.
#
# Notice — For any reuse or distribution, you must make clear to others the
# license terms of this work. The best way to do this is with a link to this
# web page.
#
#------------------------------------------------------------------------------
# Extra notes:
#
# Despite what the license tells you, I will not hunt down anybody who doesn't
# follow the license in regards to giving credits. However, as it is common
# courtesy to actually do give credits, it is recommended that you do.
#
# As I picked this license, you are free to share this script through any
# means, which includes hosting it on your own website, selling it on eBay and
# hang it in the bathroom as toilet paper. Well, not selling it on eBay, that's
# a dick move, but you are still free to redistribute the work.
#
# Yes, this license means that you can use it for both non-commercial as well
# as commercial software.
#
# You are free to pick the following names when you give credit:
#
# * GaryCXJk
# * Gary A.M. Kertopermono
# * G.A.M. Kertopermono
# * GARYCXJK
#
# Personally, when used in commercial games, I prefer you would use the second
# option. Not only will it actually give me more name recognition in real
# life, which also works well for my portfolio, it will also look more
# professional. Also, do note that I actually care about capitalization if you
# decide to use my username, meaning, capital C, capital X, capital J, lower
# case k. Yes, it might seem stupid, but it's one thing I absolutely care
# about.
#
# Finally, if you want my endorsement for your product, if it's good enough
# and I have the game in my posession, I might endorse it. Do note that if you
# give me the game for free, it will not affect my opinion of the game. It
# would be nice, but if I really did care for the game I'd actually purchase
# it. Remember, the best way to get any satisfaction is if you get people to
# purchase the game, so in a way, I prefer it if you don't actually give me
# a free copy.
#
# This script was originally hosted on:
# http://area91.multiverseworks.com
#
#==============================================================================
#
# The code below defines the settings of this script, and are there to be
# modified.
#
#==============================================================================

module CXJ
  module FREE_MOVEMENT

    ENABLE_DIAGONAL = true    # Enables diagonal movement.

    DEFAULT_COLLISION = [8, 12, 16, 20]
    DEFAULT_INTERACTION = {
    1 => [24, -8, 24, 24],
    2 => [4, 0, 24, 24],
    3 => [-16, -8, 24, 24],
    4 => [16, 10, 24, 24],
    6 => [-8, 10, 24, 24],
    7 => [24, 28, 24, 24],
    8 => [4, 20, 24, 24],
    9 => [-16, 28, 24, 24],
    }

    BOAT_COLLISION      = [4, 4, 24, 24]
    SHIP_COLLISION      = [2, 2, 28, 28]
    AIRSHIP_COLLISION   = [4, 4, 24, 24]

    PIXELS_PER_STEP = 4

    FOLLOWERS_DISTANCE = 16
    FOLLOWERS_DISTANCE_MARGIN = 4

    JUMP_SPEED = 1

    # Debug variables
    SHOW_COLLISION_BOXES = false
  end
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * New: Determine Valid Coordinates
  #--------------------------------------------------------------------------
  def valid_rect?(x, y, rect)
    x2 = x + (rect.x / 32.0)
    y2 = y + (rect.y / 32.0)
    x3 = x2 + (rect.width / 32.0)
    y3 = y2 + (rect.height / 32.0)
    round_x(x2) >= 0 && round_x(x3) < width && round_y(y2) >= 0 && round_y(y3) < height
  end
  #--------------------------------------------------------------------------
  # * Override: Check Passage
  #     bit:  Inhibit passage check bit
  #--------------------------------------------------------------------------
  def check_passage(x, y, bit)
    x = round_x(x)
    y = round_y(y)
    all_tiles(x.floor, y.floor).each do |tile_id|
      flag = tileset.flags[tile_id]
      next if flag & 0x10 != 0            # [☆]: No effect on passage
      return true  if flag & bit == 0     # [○] : Passable
      return false if flag & bit == bit   # [×] : Impassable
    end
    return false                          # Impassable
  end
  #--------------------------------------------------------------------------
  # * New: Determine Passability of Normal Character
  #     d:  direction (2,4,6,8)
  #    Determines whether the tile at the specified coordinates is passable
  #    in the specified direction.
  #--------------------------------------------------------------------------
  def passable_rect?(x, y, d, rect)
    x2 = x + (rect.x / 32.0)
    y2 = y + (rect.y / 32.0)
    x3 = x2 + (rect.width / 32.0)
    y3 = y2 + (rect.height / 32.0)
    x4 = (x2 + x3) / 2.0
    y4 = (y2 + y3) / 2.0

    if((x2.floor != x3.floor && [1, 3, 4, 6, 7, 9].include?(d)) || (y2.floor != y3.floor && [1, 2, 3, 7, 8, 9].include?(d)))
      return false if ([1, 2, 3].include?(d) && !check_passage(x2, y2, 1)) || ([3, 6, 9].include?(d) && !check_passage(x2, y2, 4))
      return false if ([3, 6, 9].include?(d) && !check_passage(x2, y3, 4)) || ([7, 8, 9].include?(d) && !check_passage(x2, y3, 8))
      return false if ([1, 2, 3].include?(d) && !check_passage(x3, y2, 1)) || ([1, 4, 7].include?(d) && !check_passage(x3, y2, 2))
      return false if ([1, 4, 7].include?(d) && !check_passage(x3, y3, 2)) || ([7, 8, 9].include?(d) && !check_passage(x3, y3, 8))
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * New: Determine if Passable by Boat
  #--------------------------------------------------------------------------
  def boat_passable_rect?(x, y, rect)
    x2 = x + (rect.x / 32.0)
    y2 = y + (rect.y / 32.0)
    x3 = x2 + (rect.width / 32.0)
    y3 = y2 + (rect.height / 32.0)
    return false unless check_passage(x2, y2, 0x0200)
    return false unless check_passage(x2, y3, 0x0200)
    return false unless check_passage(x3, y2, 0x0200)
    return check_passage(x3, y3, 0x0200)
  end
  #--------------------------------------------------------------------------
  # * New: Determine if Passable by Ship
  #--------------------------------------------------------------------------
  def ship_passable_rect?(x, y, rect)
    x2 = x + (rect.x / 32.0)
    y2 = y + (rect.y / 32.0)
    x3 = x2 + (rect.width / 32.0)
    y3 = y2 + (rect.height / 32.0)
    return false unless check_passage(x2, y2, 0x0400)
    return false unless check_passage(x2, y3, 0x0400)
    return false unless check_passage(x3, y2, 0x0400)
    return check_passage(x3, y3, 0x0400)
  end
  #--------------------------------------------------------------------------
  # * New: Determine if Airship can Land
  #--------------------------------------------------------------------------
  def airship_land_ok_rect?(x, y, rect)
    x2 = x + (rect.x / 32.0)
    y2 = y + (rect.y / 32.0)
    x3 = x2 + (rect.width / 32.0)
    y3 = y2 + (rect.height / 32.0)
    return false unless check_passage(x2, y2, 0x0800) && check_passage(x2, y2, 0x0f)
    return false unless check_passage(x2, y3, 0x0800) && check_passage(x2, y3, 0x0f)
    return false unless check_passage(x3, y2, 0x0800) && check_passage(x3, y2, 0x0f)
    return check_passage(x3, y3, 0x0800) && check_passage(x3, y3, 0x0f)
  end
  #--------------------------------------------------------------------------
  # * New: Get Array of Events at Designated Coordinates
  #--------------------------------------------------------------------------
  def events_xy_rect(x, y, rect)
    @events.values.select {|event| event.pos_rect?(x, y, rect) }
  end
  #--------------------------------------------------------------------------
  # * New: Get Array of Events at Designated Coordinates (Except Pass-Through)
  #--------------------------------------------------------------------------
  def events_xy_rect_nt(x, y, rect)
    @events.values.select {|event| event.pos_rect_nt?(x, y, rect) }
  end
  #--------------------------------------------------------------------------
  # * New: Get Array of Tile-Handling Events at Designated Coordinates
  #   (Except Pass-Through)
  #--------------------------------------------------------------------------
  def tile_events_xy_rect(x, y, rect)
    @tile_events.select {|event| event.pos_rect_nt?(x, y, rect) }
  end
  #--------------------------------------------------------------------------
  # * Calculate X Coordinate Shifted One Tile in Specific Direction
  #   (With Loop Adjustment)
  #--------------------------------------------------------------------------
  def round_x_with_direction(x, d)
    round_x(x + ((d - 1) % 3 - 1))
  end
  #--------------------------------------------------------------------------
  # * Calculate Y Coordinate Shifted One Tile in Specific Direction
  #   (With Loop Adjustment)
  #--------------------------------------------------------------------------
  def round_y_with_direction(y, d)
    round_y(y + (1 - ((d - 1) / 3)))
  end
end

#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================

class Game_CharacterBase
  include Pixel_Core
  
  attr_accessor :move_poll
  #--------------------------------------------------------------------------
  # * Alias: Object Initialization
  #--------------------------------------------------------------------------
  alias game_characterbase_initialize_cxj_fm initialize
  def initialize
    game_characterbase_initialize_cxj_fm
    @old_x = @real_x
    @old_y = @real_y
    @move_poll = []
  end
  
  #--------------------------------------------------------------------------
  # * Alias: Frame Update
  #
  # Added processing of movement being polled.
  #--------------------------------------------------------------------------
  alias game_characterbase_update_cxj_fm update
  def update
    @old_x = @real_x
    @old_y = @real_y
    interpret_move unless moving?
    @process_moving = moving?
    game_characterbase_update_cxj_fm
  end
  
  #--------------------------------------------------------------------------
  # * New: Movement Interpreting
  #     Interprets the polled movement.
  #--------------------------------------------------------------------------
  def interpret_move(step_left = distance_per_frame)
    
    if @move_poll.size > 0
      current_move = @move_poll.shift()
      d = current_move[0]
      horz = (d - 1) % 3 - 1
      vert = 1 - ((d - 1) / 3)
      turn_ok = current_move[1]
      set_direction(d) if turn_ok
      check_event_trigger_touch_front
      processed = false
      
      if (d % 2 == 0 && passable?(@x, @y, d)) || (d % 2 != 0 && diagonal_passable?(@x, @y, horz, vert)) || 
        (self.is_a?(Projectile) && pixel_passable?(@x, @y, d))
        process_move(horz, vert)
        processed = true
      elsif d % 2 != 0 && !diagonal_passable?(@x, @y, horz, vert)
        if passable?(@x, @y, horz + 5)
          set_direction(horz + 5) if turn_ok
          process_move(horz, 0)
          processed = true
        end
        if passable?(@x, @y, 5 - vert * 3)
          set_direction(5 - vert * 3) if turn_ok
          process_move(0, vert)
          processed = true
        end
      end
      
      if processed
        pixelstep = CXJ::FREE_MOVEMENT::PIXELS_PER_STEP / 32.0
        if(step_left > pixelstep && !@move_poll.empty?)
          interpret_move(step_left - pixelstep)
        elsif(jumping? && !@move_poll.empty?)
          interpret_move(0)
        end
      end
      
      @move_succeed = processed
      @px = @x * 4
      @py = @y * 4
      current_move
    end
  end

  #--------------------------------------------------------------------------
  # * New: Pixel passable?
  #--------------------------------------------------------------------------
  def pixel_passable?(px,py,d)
    px *= 4
    py *= 4
    return false if (d % 2 != 0)
    nx = px+Tile_Range[d][0]
    ny = py+Tile_Range[d][1]
    return false unless $game_map.pixel_valid?(nx,ny)
    return false if $game_map.pixel_table[px+Tile_Range[d][0],py+Tile_Range[d][1],1] == 0
    return true
  end
  #--------------------------------------------------------------------------
  # * New: Processes Movement
  #--------------------------------------------------------------------------
  def process_move(horz, vert)
    pixelstep = CXJ::FREE_MOVEMENT::PIXELS_PER_STEP / 32.0
    @x = @x + horz * pixelstep
    @y = @y + vert * pixelstep
    if(!jumping?)
      @x = $game_map.round_x(@x)
      @y = $game_map.round_y(@y)
      @real_x = @x - horz * pixelstep
      @real_y = @y - vert * pixelstep
      @process_moving = moving?
      increase_steps
    end
  end
  #--------------------------------------------------------------------------
  # * Override: Determine Triggering of Frontal Touch Event
  #--------------------------------------------------------------------------
  def check_event_trigger_touch_front
    d = @direction
    horz = (d - 1) % 3 - 1
    vert = 1 - ((d - 1) / 3)
    pixelstep = CXJ::FREE_MOVEMENT::PIXELS_PER_STEP / 32.0
    x2 = $game_map.round_x(x + horz * pixelstep)
    y2 = $game_map.round_y(y + vert * pixelstep)
    check_event_trigger_touch(x2, y2)
  end
  #--------------------------------------------------------------------------
  # * New: Collision Rectangle
  #     Gets the collision rectangle.
  #--------------------------------------------------------------------------
  def collision_rect
    collision = CXJ::FREE_MOVEMENT::DEFAULT_COLLISION
    return Rect.new(collision[0], collision[1], collision[2] - 1, collision[3] - 1)
  end
  #--------------------------------------------------------------------------
  # * Override: Determine if Passable
  #     d : Direction (2,4,6,8)
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    horz = (d - 1) % 3 - 1
    vert = 1 - ((d - 1) / 3)
    pixelstep = CXJ::FREE_MOVEMENT::PIXELS_PER_STEP / 32.0
    x2 = $game_map.round_x(x + horz * pixelstep)
    y2 = $game_map.round_y(y + vert * pixelstep)
    return false unless $game_map.valid_rect?(x2, y2, collision_rect)
    return true if @through || debug_through?
    return false unless map_passable_rect?(x, y, d, collision_rect)
    return false unless map_passable_rect?(x2, y2, reverse_dir(d), collision_rect)
    return false if collide_with_characters?(x2, y2)
    return true
  end
  #--------------------------------------------------------------------------
  # * Override: Determine Diagonal Passability
  #     horz : Horizontal (4 or 6)
  #     vert : Vertical (2 or 8)
  #--------------------------------------------------------------------------
  def diagonal_passable?(x, y, horz, vert)
    pixelstep = CXJ::FREE_MOVEMENT::PIXELS_PER_STEP / 32.0
    x2 = $game_map.round_x(x + horz * pixelstep)
    y2 = $game_map.round_y(y + vert * pixelstep)
    d = (horz == 4 ? -1 : 1) + (vert == 2 ? -3 : 3) + 5
    passable?(x, y, vert) && passable?(x, y, horz) && passable?(x, y, d) && passable?(x2, y2, vert) && passable?(x2, y2, horz) && passable?(x2, y2, d)
  end
  #--------------------------------------------------------------------------
  # * New: Determine if Map is Passable
  #     d : Direction (2,4,6,8)
  #--------------------------------------------------------------------------
  def map_passable_rect?(x, y, d, rect)
    $game_map.passable_rect?(x, y, d, rect)
  end
  #--------------------------------------------------------------------------
  # * Override: Change Direction to Designated Direction
  #     d : Direction (2,4,6,8)
  #
  # Fix for diagonal movement.
  #--------------------------------------------------------------------------
  def set_direction(d)
    if !@direction_fix && d != 0
      @direction = d
      if d % 2 != 0 && (!$imported["CXJ-AnimEx"] || !@has_diagonal)
        @direction+= 1
        @direction-= 2 if d > 5
        @direction = 10 - direction if d > 2 && d < 8
      end
    end
    @stop_count = 0
  end
  #--------------------------------------------------------------------------
  # * Override: Move Straight
  #     d:        Direction (2,4,6,8)
  #     turn_ok : Allows change of direction on the spot
  #
  # Polls the movement instead of processing them immediately.
  #--------------------------------------------------------------------------
  alias move_straight_ori move_straight
  def move_straight(d, turn_ok = true)
    
    pixelstep = CXJ::FREE_MOVEMENT::PIXELS_PER_STEP / 32.0
    @move_poll+= [[d, turn_ok]] * (distance_per_frame / pixelstep).ceil
  end
  #--------------------------------------------------------------------------
  # * Override: Move Diagonally
  #     horz:  Horizontal (4 or 6)
  #     vert:  Vertical (2 or 8)
  #
  # Polls the movement instead of processing them immediately.
  #--------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    pixelstep = CXJ::FREE_MOVEMENT::PIXELS_PER_STEP / 32.0
    @move_poll+= [[vert + (horz > 5 ? 1 : -1), true]] * (distance_per_frame / pixelstep).ceil
  end
  #--------------------------------------------------------------------------
  # * New: Determine Coordinate Match
  #--------------------------------------------------------------------------
  def pos_rect?(x, y, rect)
    main_left = @x + collision_rect.x / 32.0
    main_top = @y + collision_rect.y / 32.0
    main_right = main_left + collision_rect.width / 32.0
    main_bottom = main_top + collision_rect.height / 32.0
    other_left = x + rect.x / 32.0
    other_top = y + rect.y / 32.0
    other_right = other_left + rect.width / 32.0
    other_bottom = other_top + rect.height / 32.0
    coltest = true
    coltest = false if main_right < other_left
    coltest = false if main_left > other_right
    coltest = false if main_bottom < other_top
    coltest = false if main_top > other_bottom
    if coltest == false && ($game_map.loop_horizontal? || $game_map.loop_vertical?) && x <= $game_map.width && y <= $game_map.height
      return true if $game_map.loop_horizontal? && pos_rect?(x + $game_map.width, y, rect)
      return true if $game_map.loop_vertical? && pos_rect?(x, y + $game_map.height, rect)
    end
    return coltest
  end
  #--------------------------------------------------------------------------
  # * New: Determine if Coordinates Match and Pass-Through Is Off (nt = No Through)
  #--------------------------------------------------------------------------
  def pos_rect_nt?(x, y, rect)
    pos_rect?(x, y, rect) && !@through
  end
  #--------------------------------------------------------------------------
  # * Override: Detect Collision with Event
  #--------------------------------------------------------------------------
  def collide_with_events?(x, y)
    $game_map.events_xy_rect_nt(x, y, collision_rect).any? do |event|
      (event.normal_priority? || self.is_a?(Game_Event)) && event != self
    end
  end
  #--------------------------------------------------------------------------
  # * Override: Detect Collision with Vehicle
  #--------------------------------------------------------------------------
  def collide_with_vehicles?(x, y)
    $game_map.boat.pos_rect_nt?(x, y, collision_rect) || $game_map.ship.pos_rect_nt?(x, y, collision_rect)
  end
=begin
  #--------------------------------------------------------------------------
  # * Override: Update While Jumping
  #--------------------------------------------------------------------------
  def update_jump
    @jump_count -= 1
    diff_x = @real_x
    @real_x = (@real_x * @jump_count  + @x) / (@jump_count + 1.0)
    @real_y = (@real_y * @jump_count  + @y) / (@jump_count + 1.0)
    update_bush_depth
    if @jump_count == 0
      @real_x = @x = $game_map.round_x(@x)
      @real_y = @y = $game_map.round_y(@y)
    end
  end
  #--------------------------------------------------------------------------
  # * Override: Calculate Jump Height
  #--------------------------------------------------------------------------
  def jump_height
    (@jump_peak * @jump_peak - (@jump_count * CXJ::FREE_MOVEMENT::JUMP_SPEED - @jump_peak).abs ** 2) / 2
  end
=end
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
  # * Override: Move at Random
  #--------------------------------------------------------------------------
  def move_random
    @move_poll+= [[2 + rand(4) * 2, true]] * ((24.0 + (rand(160) / 10) ) / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
  end
  #--------------------------------------------------------------------------
  # * Override: Move Toward Character
  #--------------------------------------------------------------------------
  alias move_toward_character_comp move_toward_character
  def move_toward_character(character, pathfinding = false)
    return unless @move_poll.empty?
    
    if pathfinding && !path_clear?(@x, @y, character.x, character.y)
      @pathfinding_goal = character
      found = move_to_position(character.x, character.y)
      @pathfinding_moves.clear if @pathfinding_goal.enemy.dead?
      return if found
    end
    
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    processed = false
    if sx.abs > sy.abs
      if passable?(@x, @y, (sx > 0 ? 4 : 6))
        @move_poll+= [[sx > 0 ? 4 : 6, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
      else
        @move_poll+= [[sy > 0 ? 8 : 2, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
      end
      processed = true
    elsif sy != 0
      if passable?(@x, @y, (sy > 0 ? 8 : 2))
        @move_poll+= [[sy > 0 ? 8 : 2, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
      else
        @move_poll+= [[sx > 0 ? 4 : 6, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
      end
      processed = true
    end
    #puts "move toward #{character} (#{processed})" if self.id == 13
  end
  #--------------------------------------------------------------------------
  # * Override: Move Away from Character
  #--------------------------------------------------------------------------
  def move_away_from_character(character)
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    if sx.abs > sy.abs
      if passable?(@x, @y, (sx > 0 ? 6 : 4))
        @move_poll+= [[sx > 0 ? 6 : 4, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
      else
        @move_poll+= [[sy > 0 ? 2 : 8, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
      end
    elsif sy != 0
      if passable?(@x, @y, (sy > 0 ? 2 : 8))
        @move_poll+= [[sy > 0 ? 2 : 8, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
      else
        @move_poll+= [[sx > 0 ? 6 : 4, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Override: 1 Step Forward
  #--------------------------------------------------------------------------
  def move_forward
    @move_poll+= [[@direction, true]]# * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
  end
  #--------------------------------------------------------------------------
  # * Override: 1 Step Backward
  #--------------------------------------------------------------------------
  def move_backward
    last_direction_fix = @direction_fix
    @direction_fix = true
    @move_poll+= [[reverse_dir(@direction), false]]# * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    @direction_fix = last_direction_fix
  end
=begin
  #--------------------------------------------------------------------------
  # * Override: Jump
  #     x_plus : x-coordinate plus value
  #     y_plus : y-coordinate plus value
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    if x_plus.abs > y_plus.abs
      set_direction(x_plus < 0 ? 4 : 6) if x_plus != 0
    else
      set_direction(y_plus < 0 ? 8 : 2) if y_plus != 0
    end
    distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
    pollcount = distance * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    
    @move_poll += [[(x_plus < 0 ? -1 : x_plus > 0 ? 1 : 0) + (y_plus < 0 ? 8 : y_plus > 0 ? 2 : 5), false]] * pollcount
    
    @jump_peak = 10 + distance - @move_speed
    @jump_count = @jump_peak / CXJ::FREE_MOVEMENT::JUMP_SPEED * 2
    @stop_count = 0
    straighten
  end
=end
  #--------------------------------------------------------------------------
  # * Alias: Process Move Command
  # tag: modified
  #--------------------------------------------------------------------------
  alias game_character_process_move_command_cxj_fm process_move_command
  def process_move_command(command)
    is_player = self.is_a?(Game_Player)
    saved_poll = nil
    case command.code
    when ROUTE_MOVE_DOWN
      saved_poll = [[2, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil 
    when ROUTE_MOVE_LEFT
      saved_poll = [[4, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    when ROUTE_MOVE_RIGHT
      saved_poll = [[6, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    when ROUTE_MOVE_UP
      saved_poll = [[8, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    when ROUTE_MOVE_LOWER_L
      saved_poll = [[1, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    when ROUTE_MOVE_LOWER_R
      saved_poll = [[3, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    when ROUTE_MOVE_UPPER_L
      saved_poll = [[7, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    when ROUTE_MOVE_UPPER_R
      saved_poll = [[9, true]] * (32.0 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP).ceil
    else; game_character_process_move_command_cxj_fm(command)
    end
    
    @move_poll += saved_poll unless saved_poll.nil?
    if is_player && !saved_poll.nil?
      $game_player.followers.each do |follower|
        follower.moveto($game_player.x,$game_player.y)
        follower.move_poll += saved_poll
      end
    end
    
  end
end
#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. It includes event starting determinants and
# map scrolling functions. The instance of this class is referenced by
# $game_player.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Alias: Object Initialization
  #--------------------------------------------------------------------------
  alias game_player_initialize_cxj_fm initialize
  def initialize
    @last_poll = []
    game_player_initialize_cxj_fm
    @custom_collision = []
    @interaction = CXJ::FREE_MOVEMENT::DEFAULT_INTERACTION
    if @note =~ /<collisionbox:[ ]*(\s*),[ ]*(\s*),[ ]*(\s*),[ ]*(\s*)>/i
      @custom_collision = Rect.new($1, $2, $3 - 1, $4)
    end
    if @note =~ /<interaction (\s*):[ ]*(\s*),[ ]*(\s*),[ ]*(\s*),[ ]*(\s*)>/i && $1 > 0 && $1 < 10 && $1 % 2 == 0
      @interaction[$1] = [$2, $3, $4, $5]
    end
  end
  #--------------------------------------------------------------------------
  # * New: Movement Interpreting
  #     Interprets the polled movement.
  #--------------------------------------------------------------------------
  def interpret_move(step_left = distance_per_frame)
    current_move = super(step_left)
    @last_poll.push(current_move) if !current_move.nil?
  end
  #--------------------------------------------------------------------------
  # * New: Collision Rectangle
  #     Gets the collision rectangle.
  #--------------------------------------------------------------------------
  def collision_rect
    #return @custom_collision if @custom_collision.size > 0
    return super
  end
  #--------------------------------------------------------------------------
  # * New: Interaction Rectangle
  #     Gets the interaction rectangle.
  #--------------------------------------------------------------------------
  def interaction_rect
    collision = @interaction[@direction]
    if collision.nil?
      return collision_rect
    end
    return Rect.new(collision[0], collision[1], collision[2] - 1, collision[3] - 1)
  end
  #--------------------------------------------------------------------------
  # * Override: Processing of Movement via Input from Directional Buttons
  #
  # Added diagonal movement.
  #--------------------------------------------------------------------------
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    if CXJ::FREE_MOVEMENT::ENABLE_DIAGONAL && Input.dir8 > 0 && Input.dir8 % 2 != 0
      d = Input.dir8
      horz = (d == 1 || d == 7 ? 4 : 6)
      vert = (d == 1 || d == 3 ? 2 : 8)
      move_diagonal(horz, vert)
    elsif Input.dir4 > 0
      move_straight(Input.dir4)
    end
  end
  #--------------------------------------------------------------------------
  # * New: Detect Collision (Including Followers)
  #--------------------------------------------------------------------------
  def collide_rect?(x, y, rect)
    !@through && (pos_rect?(x, y, rect) || followers.collide_rect?(x, y, rect))
  end
  #--------------------------------------------------------------------------
  # * Override: Trigger Map Event
  #     triggers : Trigger array
  #     normal   : Is priority set to [Same as Characters] ?
  #--------------------------------------------------------------------------
  def start_map_event(x, y, triggers, normal, rect = collision_rect)
    return if $game_map.interpreter.running?
    $game_map.events_xy_rect(x, y, rect).each do |event|
      if event.trigger_in?(triggers) && event.normal_priority? == normal
        event.start unless event.is_touching?(self)
        event.add_touch(self)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Override: Determine if Front Event is Triggered
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    x2 = $game_map.round_x_with_direction(@x, @direction)
    y2 = $game_map.round_y_with_direction(@y, @direction)
    start_map_event(x2, y2, triggers, true, interaction_rect)
    return if $game_map.any_event_starting?
    return unless $game_map.counter?(x2, y2)
    x3 = $game_map.round_x_with_direction(x2, @direction)
    y3 = $game_map.round_y_with_direction(y2, @direction)
    start_map_event(x3, y3, triggers, true, interaction_rect)
  end
  #--------------------------------------------------------------------------
  # * Override: Board Vehicle
  #    Assumes that the player is not currently in a vehicle.
  #--------------------------------------------------------------------------
  def get_on_vehicle
    front_x = $game_map.round_x_with_direction(@x, @direction)
    front_y = $game_map.round_y_with_direction(@y, @direction)
    @vehicle_type = :boat    if $game_map.boat.pos_rect?(front_x, front_y, interaction_rect)
    @vehicle_type = :ship    if $game_map.ship.pos_rect?(front_x, front_y, interaction_rect)
    @vehicle_type = :airship if $game_map.airship.pos_rect?(@x, @y, collision_rect)
    if vehicle
      @vehicle_getting_on = true
      horz = (@x > vehicle.x ? -1 : @x < vehicle.x ? 1 : 0)
      vert = (@y > vehicle.y ? -3 : @y < vehicle.y ? 3 : 0)
      d = 5 + horz - vert
      set_direction(d)
      @x = vehicle.x
      @y = vehicle.y
      @followers.gather
    end
    @vehicle_getting_on
  end
  #--------------------------------------------------------------------------
  # * Override: Get Off Vehicle
  #    Assumes that the player is currently riding in a vehicle.
  #--------------------------------------------------------------------------
  def get_off_vehicle
    if vehicle.land_ok?(@x, @y, @direction)
      set_direction(2) if in_airship?
      @followers.synchronize(@x, @y, @direction)
      vehicle.get_off
      unless in_airship?
        @x = $game_map.round_x_with_direction(@x, @direction)
        @y = $game_map.round_y_with_direction(@y, @direction)
        @transparent = false
      end
      @vehicle_getting_off = true
      @move_speed = 4
      @through = false
      make_encounter_count
      @followers.gather
    end
    @vehicle_getting_off
  end
  #--------------------------------------------------------------------------
  # * Override: Determine if Map is Passable
  #     d:  Direction (2,4,6,8)
  #--------------------------------------------------------------------------
  def map_passable_rect?(x, y, d, rect)
    case @vehicle_type
    when :boat
      $game_map.boat_passable_rect?(x, y, vehicle.collision_rect)
    when :ship
      $game_map.ship_passable_rect?(x, y, vehicle.collision_rect)
    when :airship
      true
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * Override: Move Diagonally
  #--------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    @followers.move if diagonal_passable?(@x, @y, horz, vert) || passable?(@x, @y, horz + 5) || passable?(@x, @y, 5 - vert * 3)
    super
  end
  #--------------------------------------------------------------------------
  # * Alias: Create Encounter Count
  #--------------------------------------------------------------------------
  alias game_player_make_encounter_count_cxj_fm make_encounter_count
  def make_encounter_count
    game_player_make_encounter_count_cxj_fm
    @encounter_count*= (32 / CXJ::FREE_MOVEMENT::PIXELS_PER_STEP) + (32 / 2 < CXJ::FREE_MOVEMENT::PIXELS_PER_STEP ? 1 : 0)
  end
  #--------------------------------------------------------------------------
  # * Override: Detect Collision with Vehicle
  #--------------------------------------------------------------------------
  def collide_with_vehicles?(x, y)
    (@vehicle_type != :boat && $game_map.boat.pos_rect_nt?(x, y, collision_rect)) || (@vehicle_type != :ship && $game_map.ship.pos_rect_nt?(x, y, collision_rect))
  end
  #--------------------------------------------------------------------------
  # * Alias: Processing When Not Moving
  #     last_moving : Was it moving previously?
  #--------------------------------------------------------------------------
  alias game_player_update_nonmoving_cxj_fm update_nonmoving
  def update_nonmoving(last_moving)
    game_player_update_nonmoving_cxj_fm(last_moving || @old_x != @real_x || @old_y != @real_y)
    update_encounter if !last_moving && !@last_poll.empty?
    @last_poll.clear
  end
end

#==============================================================================
# ** Game_Vehicle
#------------------------------------------------------------------------------
#  This class handles vehicles. It's used within the Game_Map class. If there
# are no vehicles on the current map, the coordinates are set to (-1,-1).
#==============================================================================

class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # * New: Collision Rectangle
  #     Gets the collision rectangle.
  #--------------------------------------------------------------------------
  def collision_rect
    collision = CXJ::FREE_MOVEMENT::DEFAULT_COLLISION
    case @type
    when :boat
      collision = CXJ::FREE_MOVEMENT::BOAT_COLLISION
    when :ship
      collision = CXJ::FREE_MOVEMENT::SHIP_COLLISION
    when :airship
      collision = CXJ::FREE_MOVEMENT::AIRSHIP_COLLISION
    end
    return Rect.new(collision[0], collision[1], collision[2] - 1, collision[3] - 1)
  end
  #--------------------------------------------------------------------------
  # * Override: Determine if Docking/Landing Is Possible
  #     d:  Direction (2,4,6,8)
  #--------------------------------------------------------------------------
  def land_ok?(x, y, d)
    if @type == :airship
      return false unless $game_map.airship_land_ok_rect?(x, y, collision_rect)
      return false unless $game_map.events_xy_rect(x, y, collision_rect).empty?
    else
      x2 = $game_map.round_x_with_direction(x, d)
      y2 = $game_map.round_y_with_direction(y, d)
      return false unless $game_map.valid_rect?(x2, y2, collision_rect)
      return false unless $game_map.passable_rect?(x2, y2, reverse_dir(d), collision_rect)
      return false if collide_with_characters?(x2, y2)
    end
    return true
  end
end

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Alias: Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias game_event_init_public_members_cxj_fm init_public_members
  def init_public_members
    game_event_init_public_members_cxj_fm
    @collisionbox = Rect.new(0, 0, 31, 31)
    @touch_chars = []
  end
  #--------------------------------------------------------------------------
  # * Alias: Frame Update
  #--------------------------------------------------------------------------
  alias game_event_update_cxj_fm update
  def update
    temp_chars = []
    @touch_chars.each do |character|
      temp_chars.push(character) if character.pos_rect?(@x, @y, collision_rect)
    end
    @touch_chars = temp_chars
    game_event_update_cxj_fm
  end
  #--------------------------------------------------------------------------
  # * New: Initialize Public Member Variables
  #--------------------------------------------------------------------------
  def set_collision_rect(x, y, width, height)
    @collisionbox = Rect.new(x, y, width - 1, height - 1)
  end
  #--------------------------------------------------------------------------
  # * New: Collision Rectangle
  #     Gets the collision rectangle.
  #--------------------------------------------------------------------------
  def collision_rect
    return @collisionbox
  end
  #--------------------------------------------------------------------------
  # * Alias: Detect Collision with Player (Including Followers)
  #--------------------------------------------------------------------------
  def collide_with_player_characters?(x, y)
    normal_priority? && $game_player.collide_rect?(x, y, collision_rect)
  end
  #--------------------------------------------------------------------------
  # * Alias: Determine if Touch Event is Triggered
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    return if $game_map.interpreter.running?
    if @trigger == 2 && $game_player.pos_rect?(x, y, $game_player.collision_rect)
      start if !jumping? && normal_priority?
    end
  end

  #--------------------------------------------------------------------------
  # * New: Add Character to Touch List
  #     Keeps track of characters already touching this event.
  #--------------------------------------------------------------------------
  def add_touch(character)
    @touch_chars.push(character) unless is_touching?(character)
  end

  #--------------------------------------------------------------------------
  # * New: Checks if the current event is touching.
  #--------------------------------------------------------------------------
  def is_touching?(character)
    @touch_chars.include?(character)
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New: Set Collision Rectangle From Event Script
  #--------------------------------------------------------------------------
  def set_collision_rect(x, y, width, height)
    $game_map.events[@event_id].set_collision_rect(x, y, width, height)
  end
end

if(CXJ::FREE_MOVEMENT::SHOW_COLLISION_BOXES)
  #============================================================================
  # ** Sprite_CollisionBox
  #----------------------------------------------------------------------------
  #  This sprite is used to display collision boxes. It's mainly used for
  # debugging purposes.
  #============================================================================

  class Sprite_CollisionBox < Sprite
    
    def initialize(viewport, parent_sprite = nil)
      super(viewport)
      @color = Color.new(0, 255, 0, 128)
      @icolor = Color.new(255, 0, 0, 128)
      @parent_sprite = parent_sprite
      self.bitmap = Bitmap.new(96, 96)
      update
    end

    def update
      self.x = @parent_sprite.x
      self.y = @parent_sprite.y
      draw_box
    end

    def draw_box
      self.ox = 48
      self.oy = 64
      self.bitmap.clear
      return if @parent_sprite.character.through && @parent_sprite.character.transparent
      col_rect = @parent_sprite.character.collision_rect
      self.bitmap.fill_rect(col_rect.x + 32, col_rect.y + 32, col_rect.width, col_rect.height, @color)
      
      if(@parent_sprite.character == $game_player)
        int_rec = $game_player.interaction_rect
        d = $game_player.direction
        horz = (d - 1) % 3 - 1
        vert = 1 - ((d - 1) / 3)
        int_rect = Rect.new(int_rec.x + 32 + 32 * horz, int_rec.y + 32 + 32 * vert, int_rec.width, int_rec.height)
        self.bitmap.fill_rect(int_rect, @icolor)
      end
    end
  end
  #============================================================================
  # ** Sprite_Sightview
  #----------------------------------------------------------------------------
  #   Show the enemy's sight view range  
  #
  #============================================================================
  class Sprite_Sightview < Sprite
    
    def initialize(viewport, parent_sprite = nil)
      super(viewport)
      @color = Color.new(0, 255, 0, 128)
      @icolor = Color.new(255, 0, 0, 128)
      @parent_sprite = parent_sprite
      self.bitmap = Bitmap.new(640, 480)
      update
    end

    def update
      self.x = @parent_sprite.x - 100
      self.y = @parent_sprite.y - 100
      draw_box
    end

    def draw_box
      self.ox = 48
      self.oy = 64
      self.bitmap.clear
      return if @parent_sprite.character.through && @parent_sprite.character.transparent
      _id = @parent_sprite.character.id
      return unless _id == 13 || _id == 12
      angles = @parent_sprite.character.determind_sight_angles(60)
      pos1   = Math.rotation_matrix(160, 0, angles[0], true)
      pos2   = Math.rotation_matrix(160, 0, angles[1], true)
      
      int_rec = $game_player.interaction_rect
      d = $game_player.direction
      horz = (d - 1) % 3 - 1
      vert = 1 - ((d - 1) / 3)
      int_rect = Rect.new(int_rec.x + 32 + 32 * horz, int_rec.y + 32 + 32 * vert, int_rec.width, int_rec.height)
      cx = int_rec.x + 132 + 32 * horz 
      cy = int_rec.y + 132 + 32 * vert
      if    d == 2; cx += 14
      elsif d == 4; cx += 32; cy += 16
      elsif d == 6; cy += 16
      elsif d == 8; cx += 16; cy += 32
      end
      self.bitmap.draw_line(cx, cy, cx + pos1[0], cy + pos1[1], @icolor)
      self.bitmap.draw_line(cx, cy, cx + pos2[0], cy + pos2[1], @icolor)
    end
    
  end
  
  #============================================================================
  # ** Spriteset_Map
  #----------------------------------------------------------------------------
  #  This class brings together map screen sprites, tilemaps, etc. It's used
  # within the Scene_Map class.
  #============================================================================

  class Spriteset_Map
    #--------------------------------------------------------------------------
    # * Alias: Create Character Sprite
    #--------------------------------------------------------------------------
    alias spriteset_map_create_characters_cxj_fm create_characters
    def create_characters
      spriteset_map_create_characters_cxj_fm
      @collision_sprites = []
      @sightview_sprites = []
      @character_sprites.each do |char|
        @collision_sprites.push(Sprite_CollisionBox.new(@viewport, char))
      end
      @character_sprites.each do |char|
        @sightview_sprites.push(Sprite_Sightview.new(@viewport, char))
      end
      
    end
    #--------------------------------------------------------------------------
    # * Alias: Update Character Sprite
    #--------------------------------------------------------------------------
    alias spriteset_map_update_characters_cxj_fm update_characters
    def update_characters
      spriteset_map_update_characters_cxj_fm
      @collision_sprites.each {|sprite| sprite.update }
      @sightview_sprites.each {|sprite| sprite.update }
    end
  end
end