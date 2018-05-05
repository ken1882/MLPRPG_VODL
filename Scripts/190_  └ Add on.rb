#==============================================================================
# ** Window_EquipSlot
#------------------------------------------------------------------------------
#  This window displays items the actor is currently equipped with on the
# equipment screen.
#==============================================================================
class Window_EquipSlot < Window_Selectable
  #-----------------------------------------------------------------------------
  MouseTimer = 5
  #-----------------------------------------------------------------------------
  def get_mouse_timer
    return MouseTimer
  end
  #-----------------------------------------------------------------------------
end
