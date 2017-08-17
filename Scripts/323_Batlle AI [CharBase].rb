#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  A character class with mainly movement route and other such processing
# added. It is used as a super class of Game_Player, Game_Follower,
# GameVehicle, and Game_Event.
#==============================================================================
# tag: battler
class Game_Character < Game_CharacterBase
  #----------------------------------------------------------------------------
  # *) Frame update
  #----------------------------------------------------------------------------
  alias update_gachdndai update
  def update
    update_combat if @current_target
    update_gachdndai
  end
  #----------------------------------------------------------------------------
  def target_rate(target, modifier = 0)
    sum  = 100
    sum  = apply_tactic_target(sum, target)
    sum *= tgr
    return sum.to_i + modifier
  end
  #----------------------------------------------------------------------------
  def set_target(target)
    @current_target = target
  end
  #----------------------------------------------------------------------------
  def update_combat
  end # last work: AI combat (it finally comes
  #----------------------------------------------------------------------------
  # * Increase the target rate if target is meet to current tactic target
  #----------------------------------------------------------------------------
  def apply_tactic_target(value, target)
    return value
  end
  #----------------------------------------------------------------------------
end
