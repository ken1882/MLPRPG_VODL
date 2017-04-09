#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :dualclass_id                 # Second class ID
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_muticlass initialize
  def initialize(actor_id)
    @dualclass_id = 0
    init_muticlass(actor_id)
  end
  
  def dualclass
    $data_classes[@dualclass_id]
  end
  
  def setup_dualclass(class_id)
    @dualclass_id = class_id
  end
  
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Actor
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, args) unless @map_char
    super(symbol, args) unless @map_char.methods.include?(symbol)
    
    case args.size
    when 0; @map_char.method(symbol).call
    when 1; @map_char.method(symbol).call(args[0])
    when 2; @map_char.method(symbol).call(args[0], args[1])
    when 3; @map_char.method(symbol).call(args[0], args[1], args[2])
    when 4; @map_char.method(symbol).call(args[0], args[1], args[2], args[3])
    when 5; @map_char.method(symbol).call(args[0], args[1], args[2], args[3], args[4])
    end
  end
  
end
