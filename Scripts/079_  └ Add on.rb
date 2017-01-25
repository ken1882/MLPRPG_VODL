#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================
class Game_Event < Game_Character
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
