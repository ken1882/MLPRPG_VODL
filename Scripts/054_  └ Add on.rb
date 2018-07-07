#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
# The instance of this class is referenced by $game_temp.
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :loading_destroy_delay # Cancel loading screen destroy by map.setup
  attr_accessor :effectus_sprites, :effectus_triggers # tag: effectus
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_temp_dnd initialize
  def initialize
    @loading_destroy_delay = $game_temp ? $game_temp.loading_destroy_delay : false
    @effectus_sprites  = {}
    @effectus_triggers = []
    init_temp_dnd
  end
  #--------------------------------------------------------------------------
end
