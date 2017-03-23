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
  attr_accessor :target_event
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_trevent initialize
  def initialize
    @target_event = nil
    initialize_trevent
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Game_Enemy
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, *args) if actor.nil?
    
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
