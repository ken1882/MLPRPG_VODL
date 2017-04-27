#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Overwrite: Frame Update
  #--------------------------------------------------------------------------
  alias update_scmap_tactic update
  def update
    super
    return update_tactic if SceneManager.tactic_enabled?
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
  def update_tactic_cursor
    
  end
  
end
