#==============================================================================
# ** Game_ActionResult
#------------------------------------------------------------------------------
#  This class handles the results of battle actions. It is used internally for
# the Game_Battler class. 
#==============================================================================
class Game_ActionResult
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :interrupted
  attr_accessor :hitted
  #--------------------------------------------------------------------------
  # * Alias :Clear Hit Flags
  #--------------------------------------------------------------------------
  alias clear_hit_flags_dnd clear_hit_flags
  def clear_hit_flags
    @interrupted = false
    @hitted       = false
    clear_hit_flags_dnd
  end
  #--------------------------------------------------------------------------
  # * Overwrite :hit?
  #--------------------------------------------------------------------------
  def hit?
    @used && !@missed && !@evaded && !@interrupted && @hitted
  end
  
end
