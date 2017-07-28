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
    @team_id = 0
    @assigned_hotkey = Array.new(HotKeys::HotKeys.size){nil}
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
  #--------------------------------------------------------------------------
  # * Overwrite: Processing Performed When Player Takes 1 Step
  #--------------------------------------------------------------------------
  def on_player_walk
    #@result.clear
    check_floor_effect
    if $game_player.normal_walk?
      #turn_end_on_map
      states.each {|state| update_state_steps(state) }
      show_added_states
      show_removed_states
    end
  end
  #--------------------------------------------------------------------------
  # * End of Turn Processing on Map Screen
  #--------------------------------------------------------------------------
  def turn_end_on_map
    on_turn_end
    perform_map_damage_effect if @result.hp_damage > 0
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
