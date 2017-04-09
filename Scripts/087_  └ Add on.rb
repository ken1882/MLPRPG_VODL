#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :enemy
  attr_reader   :event
  #--------------------------------------------------------------------------
  attr_accessor :default_weapon
  attr_accessor :last_target
  attr_accessor :cool_down
  attr_accessor :recover
  attr_accessor :target_switch
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     event:  RPG::Event
  #--------------------------------------------------------------------------
  alias initialize_event_opt initialize
  def initialize(map_id, event)
    initialize_event_opt(map_id, event)
  end
  #--------------------------------------------------------
  # *) check if comment is in event page
  #--------------------------------------------------------
  def comment_include?(comment)
    return if comment.nil? || @list.nil?
    comment = comment.to_s
    for command in @list
      if command.code == 108
        return true if command.parameters[0].include?(comment)
      end # if command.code
    end # for command
    return false
  end # def comment
  
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Game_Enemy
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, *args) if @enemy.nil?
    
    case args.size
    when 0; @enemy.method(symbol).call
    when 1; @enemy.method(symbol).call(args[0])
    when 2; @enemy.method(symbol).call(args[0], args[1])
    when 3; @enemy.method(symbol).call(args[0], args[1], args[2])
    when 4; @enemy.method(symbol).call(args[0], args[1], args[2], args[3])
    when 5; @enemy.method(symbol).call(args[0], args[1], args[2], args[3], args[4])
    end
  end
  
end
