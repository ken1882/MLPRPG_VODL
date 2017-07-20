#==============================================================================
# ** Game_Variables
#------------------------------------------------------------------------------
#  This class handles variables. It's a wrapper for the built-in class "Array."
# The instance of this class is referenced by $game_variables.
#==============================================================================
class Game_Variables
  attr_accessor :global_vars
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_extravar initialize
  def initialize
    initialize_extravar
    @global_vars = {}
  end
  
end
