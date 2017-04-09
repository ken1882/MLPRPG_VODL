#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. It includes event starting determinants and
# map scrolling functions. The instance of this class is referenced by
# $game_player.
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :target_event   # Event auto trigger when touched
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_gapc_opt initialize
  def initialize
    @target_event = nil
    initialize_gapc_opt
  end
  #--------------------------------------------------------------------------
  # * Disable Dash utility
  #--------------------------------------------------------------------------
  def dash?
    return false
  end
  #--------------------------------------------------------------------------
  # * Vehicle Processing
  #--------------------------------------------------------------------------
  def update_vehicle
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Actor
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, args) unless actor
    super(symbol, args) unless actor.methods.include?(symbol)
    
    case args.size
    when 0; actor.method(symbol).call
    when 1; actor.method(symbol).call(args[0])
    when 2; actor.method(symbol).call(args[0], args[1])
    when 3; actor.method(symbol).call(args[0], args[1], args[2])
    when 4; actor.method(symbol).call(args[0], args[1], args[2], args[3])
    when 5; actor.method(symbol).call(args[0], args[1], args[2], args[3], args[4])
    end
  end
end
