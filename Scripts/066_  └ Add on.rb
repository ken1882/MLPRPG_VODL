#==============================================================================
# ** Game_SelfSwitches
#------------------------------------------------------------------------------
#  This class handles self switches. It's a wrapper for the built-in class
# "Hash." The instance of this class is referenced by $game_self_switches.
#==============================================================================
#tag: effectus
class Game_SelfSwitches
  
  #--------------------------------------------------------------------------
  # * Set SelfSwitch.                                                   [REP]
  #--------------------------------------------------------------------------
  def []=(key, value)
    @data[key] = value
    unless $game_temp.effectus_triggers.include?(key)
      $game_temp.effectus_triggers << key
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
