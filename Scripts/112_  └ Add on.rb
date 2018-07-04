#==============================================================================
# ** Game_Vehicle
#------------------------------------------------------------------------------
#  This class handles vehicles. It's used within the Game_Map class. If there
# are no vehicles on the current map, the coordinates are set to (-1,-1).
#==============================================================================
class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # * Determine if Docking/Landing Is Possible.                         [REP]
  #--------------------------------------------------------------------------
  def land_ok?(x, y, d)
    if @type == :airship
      return false unless $game_map.airship_land_ok?(x, y)
      return false unless $game_map.events_xy(x, y).empty?
    else
      x2 = d == 4 ? x - 1 : d == 6 ? x + 1 : x
      y2 = d == 8 ? y - 1 : d == 2 ? y + 1 : y
      return false unless $game_map.valid?(x2, y2) &&
      $game_map.effectus_original_passable?(x2, y2, 10 - 1)
      return false if collide_with_characters?(x2, y2)
    end
    return true
  end
end
