#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Overwrite: Frame Update
  #--------------------------------------------------------------------------
  alias update_gamemap_lapse update
  def update(main = false)
    return update_tactic(main)   if SceneManager.tactic_enabled?
    return update_timestop(main) if SceneManager.time_stopped? 
    return update_gamemap_lapse(main)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  # tag: tactic(game_map update)
  #--------------------------------------------------------------------------
  def update_tactic(main)
    refresh if @need_refresh
    update_interpreter if main
    update_scroll
    update_events
    update_vehicles
    update_parallax
    @screen.update
  end
end
