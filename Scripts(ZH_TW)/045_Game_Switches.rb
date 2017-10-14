#==============================================================================
# ** Game_Switches
#------------------------------------------------------------------------------
#  This class handles switches. It's a wrapper for the built-in class "Array."
# The instance of this class is referenced by $game_switches.
#==============================================================================
class Game_Switches
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Get Switch
  #--------------------------------------------------------------------------
  def [](switch_id)
    @data[switch_id] || false
  end
  #--------------------------------------------------------------------------
  # * Set Switch
  #     value : ON (true) / OFF (false)
  #--------------------------------------------------------------------------
  def []=(switch_id, value)
    @data[switch_id] = value
    on_change
  end
  #--------------------------------------------------------------------------
  # * Processing When Setting Switches
  #--------------------------------------------------------------------------
  def on_change
    $game_map.need_refresh = true
  end
end
