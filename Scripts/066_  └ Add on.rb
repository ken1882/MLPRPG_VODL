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
  attr_accessor :immune
  #--------------------------------------------------------------------------
  # * Alias :Clear Hit Flags
  #--------------------------------------------------------------------------
  alias clear_hit_flags_dnd clear_hit_flags
  def clear_hit_flags
    @interrupted  = false
    @hitted       = false
    @immune       = false
    clear_hit_flags_dnd
  end
  #--------------------------------------------------------------------------
  # * Overwrite :hit?
  #--------------------------------------------------------------------------
  def hit?
    @used && !@missed && !@evaded && !@interrupted && @hitted && !@immune
  end
  #--------------------------------------------------------------------------
  def result?
    args = {}
    args[:used]        = @used
    args[:missed]      = @missed
    args[:interrupted] = @interrupted
    args[:hitted]      = @hitted
    args[:evaded]      = @evaded
    args[:critical]    = @critical
    args[:immune]      = @immune
    return args
  end
  
end
