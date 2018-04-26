#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
module Effectus
  UsePassable = true
end
class Game_Map
  #--------------------------------------------------------------------------
  # * Public Instance Variables.                                        [NEW]
  #--------------------------------------------------------------------------
  attr_accessor :effectus_event_pos, :effectus_party_pos,
                :effectus_etile_pos, :effectus_hard_events,
                :effectus_events_to_update, :effectus_pass_table,
                :effectus_event_starting, :effectus_etriggers,
                :effectus_tile_events, :effectus_need_refresh
  #--------------------------------------------------------------------------
  # * Setup.                                                            [REP]
  #--------------------------------------------------------------------------
  alias setup_effectus setup
  def setup(map_id)
    @effectus_dref_display_x   = 0
    @effectus_dref_display_y   = 0
    @effectus_event_starting   = nil
    @effectus_events_to_update = []
    @effectus_hard_events      = []
    @effectus_tile_events      = []
    @effectus_initial_run      = nil
    @effectus_ody              = nil
    @effectus_odx              = nil
    @effectus_party_pos        = Hash.new { |hash, key| hash[key] = [] }
    @effectus_event_pos        = Hash.new { |hash, key| hash[key] = [] }
    @effectus_etile_pos        = Hash.new { |hash, key| hash[key] = [] }
    @effectus_etriggers        = Hash.new { |hash, key| hash[key] = [] }
    @effectus_need_refresh     = false
    setup_effectus(map_id)
    
    @effectus_pass_table = Table.new($game_map.width, $game_map.height, 4)
    $game_player.followers.each do |follower|
      follower.effectus_position_registered = false
    end
    @effectus_adjx = (width  - screen_tile_x) / 2
    @effectus_adjy = (height - screen_tile_y) / 2
  end
  #--------------------------------------------------------------------------
  # * Refresh Tile Events.                                              [REP]
  #--------------------------------------------------------------------------
  def effectus_refresh_tile_events
    @tile_events = []
    @effectus_tile_events.each { |e| e.tile? && @tile_events << e }
  end
  #--------------------------------------------------------------------------
  # * Overwrite: To make compatible with effectus and The0's anti lag
  #--------------------------------------------------------------------------
  def refresh_tile_events
    @tile_events = []
  end
  #--------------------------------------------------------------------------
  # * Trigger Refresh.                                                  [NEW]
  #--------------------------------------------------------------------------
  def effectus_trigger_refresh
    $game_temp.effectus_triggers.each do |trigger|
      effectus_etriggers[trigger].each { |event| event.refresh }
    end
    effectus_refresh_tile_events
    $game_temp.effectus_triggers.clear
    @effectus_need_refresh = false
  end
  #--------------------------------------------------------------------------
  # * Set Correct Display Values.                                       [NEW]
  #--------------------------------------------------------------------------
  def effectus_dref_set
    @effectus_dref_display_x = (@display_x * 32).floor / 32.0
    @effectus_dref_display_y = (@display_y * 32).floor / 32.0
  end
  #--------------------------------------------------------------------------
  # * Display X.                                                        [REP]
  #--------------------------------------------------------------------------
  def display_x
    @effectus_dref_display_x
  end
  #--------------------------------------------------------------------------
  # * Display Y.                                                        [REP]
  #--------------------------------------------------------------------------
  def display_y
    @effectus_dref_display_y
  end
  #--------------------------------------------------------------------------
  # * Calculate X Coordinate, Minus Display Coordinate.                 [REP]
  #--------------------------------------------------------------------------
  def adjust_x(x)
    if loop_horizontal? && x < @effectus_dref_display_x - @effectus_adjx
      x - @effectus_dref_display_x + @map.width
    else
      x - @effectus_dref_display_x
    end
  end
  #--------------------------------------------------------------------------
  # * Calculate Y Coordinate, Minus Display Coordinate.                 [REP]
  #--------------------------------------------------------------------------
  def adjust_y(y)
    if loop_vertical? && y < @effectus_dref_display_y - @effectus_adjy
      y - @effectus_dref_display_y + @map.height
    else
      y - @effectus_dref_display_y
    end
  end
  #--------------------------------------------------------------------------
  # * Set Display Position.                                             [REP]
  #--------------------------------------------------------------------------
  def set_display_pos(x, y)
    to_update_events = $game_map.effectus_events_to_update
    x = [0, [x, width  - screen_tile_x].min].max unless loop_horizontal?
    y = [0, [y, height - screen_tile_y].min].max unless loop_vertical?
    @display_x = (x + width)  % width
    @display_y = (y + height) % height
    @parallax_x = x
    @parallax_y = y
    to_update_events.each { |event| event.update }
  end
  #--------------------------------------------------------------------------
  # * Setup Starting Map Event.                                         [REP]
  #--------------------------------------------------------------------------
  def setup_starting_map_event
    return nil unless @effectus_event_starting
    event = @effectus_event_starting
    event.clear_starting_flag
    @interpreter.setup(event.list, event.id)
    @effectus_event_starting = nil
    event
  end
  #--------------------------------------------------------------------------
  # * Any Event Starting?                                               [REP]
  #--------------------------------------------------------------------------
  def any_event_starting?
    @effectus_event_starting
  end
#--------------------------------------------------------------------------
# Whether using effectus' pass table
if Effectus::UsePassable
  #--------------------------------------------------------------------------
  # * Tile Events XY.                                                   [REP]
  #--------------------------------------------------------------------------
  def tile_events_xy(x, y)
    @effectus_etile_pos[y * width + x]
  end
  #--------------------------------------------------------------------------
  # * All Tiles.                                                        [REP]
  #--------------------------------------------------------------------------
  def all_tiles(x, y)
    @effectus_etile_pos[y * width + x].collect { |event| event.tile_id } + 
    layered_tiles(x, y)
  end
  #--------------------------------------------------------------------------
  # * Alias Passable?                                                   [NEW]
  #--------------------------------------------------------------------------
  alias_method(:effectus_original_passable?, :passable?)
  #--------------------------------------------------------------------------
  # * Passable?                                                         [MOD]
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    if @effectus_pass_table[x, y, (d / 2) - 1] == 0
      cd = 10 - d
      cx = d == 4 ? x - 1 : d == 6 ? x + 1 : x
      cy = d == 2 ? y + 1 : d == 8 ? y - 1 : y
      if effectus_original_passable?(x, y, d) &&
        effectus_original_passable?(cx, cy, cd)
        @effectus_pass_table[x, y, (d / 2) - 1] = 1
        @effectus_pass_table[cx, cy, (cd / 2) - 1] = 1
        return true
      else
        @effectus_pass_table[x, y, (d / 2) - 1] = 2
        return false
      end
    end
    @effectus_pass_table[x, y, (d / 2) - 1] == 1
  end
  #--------------------------------------------------------------------------
  # * MS Effectus Release.                                              [NEW]
  #--------------------------------------------------------------------------
  def effectus_release(x, y)
    @effectus_pass_table[x, y, 0] = 0
    @effectus_pass_table[x, y, 1] = 0
    @effectus_pass_table[x, y, 2] = 0
    @effectus_pass_table[x, y, 3] = 0
    @effectus_pass_table[x - 1, y, 0] = 0
    @effectus_pass_table[x - 1, y, 1] = 0
    @effectus_pass_table[x - 1, y, 2] = 0
    @effectus_pass_table[x - 1, y, 3] = 0
    @effectus_pass_table[x + 1, y, 0] = 0
    @effectus_pass_table[x + 1, y, 1] = 0
    @effectus_pass_table[x + 1, y, 2] = 0
    @effectus_pass_table[x + 1, y, 3] = 0
    @effectus_pass_table[x, y - 1, 0] = 0
    @effectus_pass_table[x, y - 1, 1] = 0
    @effectus_pass_table[x, y - 1, 2] = 0
    @effectus_pass_table[x, y - 1, 3] = 0
    @effectus_pass_table[x, y + 1, 0] = 0
    @effectus_pass_table[x, y + 1, 1] = 0
    @effectus_pass_table[x, y + 1, 2] = 0
    @effectus_pass_table[x, y + 1, 3] = 0
  end
end # if Effectus::UsePassable
  #--------------------------------------------------------------------------
end
