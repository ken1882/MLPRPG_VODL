#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
# tag: tactic(Scene_Map)
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * alias: Frame Update
  #--------------------------------------------------------------------------
  alias update_scmap_tactic update
  def update
    if @tactic_enabled
      super
      return update_tactic
    end
    update_scmap_tactic
  end
  #--------------------------------------------------------------------------
  # * Update for tactic mode
  #--------------------------------------------------------------------------
  def update_tactic
    update_tactic_cursor
    return update_scmap_tactic if Input.press?(:kALT)
    @spriteset.update_tactic
  end
  #--------------------------------------------------------------------------
  def start_tactic
    @tactic_enabled = true
  end
  #--------------------------------------------------------------------------
  def end_tactic
    @tactic_enabled = false
  end
  #--------------------------------------------------------------------------
  def update_tactic_cursor
    
  end
  
end
