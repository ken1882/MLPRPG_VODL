#==============================================================================
# ** Game_SelfSwitches
#------------------------------------------------------------------------------
#  This class handles self switches. It's a wrapper for the built-in class
# "Hash." The instance of this class is referenced by $game_self_switches.
#==============================================================================
class Game_SelfSwitches
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @data = {}
  end
  #--------------------------------------------------------------------------
  # * Get Self Switch 
  #--------------------------------------------------------------------------
  def [](key)
    @data[key] == true
  end
  #--------------------------------------------------------------------------
  # * Set Self Switch
  #     value : ON (true) / OFF (false)
  #--------------------------------------------------------------------------
  def []=(key, value)
    @data[key] = value
    on_change
  end
  #--------------------------------------------------------------------------
  # * Processing When Setting Self Switches
  #--------------------------------------------------------------------------
  def on_change
    $game_map.need_refresh = true
  end
end
