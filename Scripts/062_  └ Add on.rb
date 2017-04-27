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
  attr_accessor :assigned_hotkey
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_muticlass initialize
  def initialize(actor_id)
    @dualclass_id = 0
    @assigned_hotkey = []
    init_muticlass(actor_id)
  end
  
  def dualclass
    $data_classes[@dualclass_id]
  end
  
  def setup_dualclass(class_id)
    @dualclass_id = class_id
  end
  #--------------------------------------------------------------------------
  # *) Get equipped all items
  #--------------------------------------------------------------------------
  def get_hotkeys(equip_only = false)
    items = [@equips[0], @equips[1]]
    unless equip_only
      @assigned_hotkey.each {|item| items.push(item)}
    end
    return items
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Actor
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, args) unless @map_char
    super(symbol, args) unless @map_char.methods.include?(symbol)
    @map_char.method(symbol).call(*args)
  end
  
end
