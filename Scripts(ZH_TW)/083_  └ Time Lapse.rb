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
    return update_timestop       if SceneManager.time_stopped? 
    return update_gamemap_lapse(main)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  # tag: tactic(game_map update)
  #--------------------------------------------------------------------------
  def update_tactic(main = false)
    refresh if @need_refresh
    update_interpreter if main
    update_scroll
    update_parallax
    @screen.update
  end
  #--------------------------------------------------------------------------
  def update_timestop
    refresh if @need_refresh
    update_scroll
    update_parallax
    @screen.update
    update_drops
    unless $game_system.time_stopper.nil?
      $game_system.time_stopper.update
      $game_system.time_stopper.update_battler
    end
    @timestop_timer += 1
    if @timestop_timer >= $game_system.timestop_duration
      $game_system.resume_time 
      @timestop_timer = 0
    end
  end
  #--------------------------------------------------------------------------
end
