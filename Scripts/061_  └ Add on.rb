#==============================================================================
# ** Game_Variables
#------------------------------------------------------------------------------
#  This class handles variables. It's a wrapper for the built-in class "Array."
# The instance of this class is referenced by $game_variables.
#==============================================================================
# tag: effectus
class Game_Variables
  #--------------------------------------------------------------------------
  # * Set Variable.                                                     [REP]
  #--------------------------------------------------------------------------
  def []=(variable_id, value)
    @data[variable_id] = value
    trigger_symbol = :"variable_#{variable_id}"
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
  #--------------------------------------------------------------------------
  def size
    return @data.size
  end
  #--------------------------------------------------------------------------
  def item_max
    return 1000
  end
  #--------------------------------------------------------------------------
end
