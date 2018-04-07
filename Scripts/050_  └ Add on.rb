#==============================================================================
# ** Game_Switches
#------------------------------------------------------------------------------
#  This class handles switches. It's a wrapper for the built-in class "Array."
# The instance of this class is referenced by $game_switches.
#==============================================================================
# tag: effectus
class Game_Switches
  #--------------------------------------------------------------------------
  # * Set Switch.                                                       [REP]
  #--------------------------------------------------------------------------
  def []=(switch_id, value)
    @data[switch_id] = value
    trigger_symbol = :"switch_#{switch_id}"
    unless $game_temp.effectus_triggers.include?(trigger_symbol)
      $game_temp.effectus_triggers << trigger_symbol
    end
    $game_map.effectus_need_refresh = true
    on_change
  end
  #--------------------------------------------------------------------------
  # * On Change.                                                        [REP]
  #--------------------------------------------------------------------------
  def on_change
    # Kept for compatibility purposes.
  end
  
end
