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
    @spriteset.update_timelapse
  end
  #--------------------------------------------------------------------------
  def start_tactic
    @tactic_enabled = true
    @spriteset.show_units
  end # last work: tactic mode processing
  #--------------------------------------------------------------------------
  def end_tactic
    @tactic_enabled = false
    @spriteset.hide_units
  end
  #--------------------------------------------------------------------------
  def update_tactic_cursor
    @tactic_cursor.update
  end
  
end
