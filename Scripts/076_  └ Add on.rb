#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
class Game_Follower < Game_Character
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
