#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles system data. It saves the disable state of saving and 
# menus. Instances of this class are referenced by $game_system.
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :skillbar
  attr_accessor :autotarget, :autotarget_aoe
  attr_accessor :loading_pressure
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_system_opt initialize
  def initialize
    @skillbar  = nil
    @autotarget = true
    @autotarget_aoe = true
    @loading_pressure = 0
    initialize_system_opt
  end  
  #--------------------------------------------------------------------------
  # * show roll result?
  #--------------------------------------------------------------------------
  def show_roll_result?
    return $game_switches[15]
  end
  
  #--------------------------------------------------------------------------
  # * hide all windows?
  #--------------------------------------------------------------------------
  def hide_all_windows?
    return $game_switches[16]
  end
  #--------------------------------------------------------------------------
  # * return a rand class value
  #--------------------------------------------------------------------------
  def make_rand
    Random.new_seed
    return Random.new
  end
  
  def load_process
    @loading_pressure += 1
  end
  
  def load_complete
    @loading_pressure = 0
  end
  
  def load_complete?; return @loading_pressure == 0; end
  
  def cache_loading
  end
  
end
