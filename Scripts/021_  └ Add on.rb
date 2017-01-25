#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
# The instance of this class is referenced by $game_temp.
#==============================================================================
class Game_Temp
  #-----------------------------------------------------------------------------
  #  *) check temporary data
  #-----------------------------------------------------------------------------
  def check_var_ok?(*args)
    symbol = args[0]
    
    case symbol
    when :coord_1
      puts "Hello World!"
    when :coord_2
      puts "Hey yal!"
    end
    
  end
end
