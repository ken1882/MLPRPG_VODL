#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================
# tag: tactic   (SceneManager)
# tag: timeflow (SceneManager)
module SceneManager
  #--------------------------------------------------------------------------
  # * Module Instance Variables
  #--------------------------------------------------------------------------
  @tactic_enabled = false
  @time_stopped   = false
  #--------------------------------------------------------------------------
  module_function
  #--------------------------------------------------------------------------
  def process_tactic(cmd = nil)
    return unless scene_is?(Scene_Map)
    return cmd ? start_tactic : end_tactic unless cmd.nil?
    return @tactic_enabled ? end_tactic : start_tactic
  end
  #--------------------------------------------------------------------------
  def start_tactic
    return unless scene_is?(Scene_Map)
    display_info 'Paused'
    @tactic_enabled = true
  end
  #--------------------------------------------------------------------------
  def end_tactic
    return unless scene_is?(Scene_Map)
    display_info 'Unpaused'
    @tactic_enabled = false
  end
  #--------------------------------------------------------------------------
  def tactic_enabled?
    return @tactic_enabled
  end
  #--------------------------------------------------------------------------
  def stop_time
    @time_stopped = true
  end
  #--------------------------------------------------------------------------
  def resume_time
    @time_stopped = false
  end
  #--------------------------------------------------------------------------
  def time_stopped?
    return @time_stopped
  end
  
end
