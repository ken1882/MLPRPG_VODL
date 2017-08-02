#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  attr_reader :window_log
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias start_opt start
  def start
    @tactic_enabled = false
    start_opt
    @window_log = Window_InformationLog.new(SceneManager.resume_map_info)
  end
  #--------------------------------------------------------------------------
  # * Post-Start Processing
  #--------------------------------------------------------------------------
  def post_start
    super
    spriteset.restore_projectile
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_scmap_dnd terminate
  def terminate
    @message_window.dispose_all_windows
    SceneManager.save_map_infos(@window_log.data)
    terminate_scmap_dnd
  end
  #--------------------------------------------------------------------------
  # * Update Frame (for Fade In)
  #--------------------------------------------------------------------------
  def update_for_fade
    update_basic            rescue nil
    $game_map.update(false)
    @spriteset.update       rescue nil
  end
  #--------------------------------------------------------------------------
  # * Create Message Window
  # -------------------------
  #   Overwrite to fix memory leak error
  #--------------------------------------------------------------------------
  def create_message_window
    @message_window = Window_Message.new unless @message_window && !@message_window.disposed?
  end
  #--------------------------------------------------------------------------
  # * Return Spriteset
  #--------------------------------------------------------------------------
  def spriteset
    @spriteset
  end
  #--------------------------------------------------------------------------
  # * Determine if Menu is Called due to Cancel Button
  #--------------------------------------------------------------------------
  def update_call_menu
    if $game_system.menu_disabled || $game_map.interpreter.running?
      @menu_calling = false
    else
      @menu_calling ||= Input.trigger?(:kESC) || Mouse.click?(3)
      call_menu if @menu_calling && !$game_player.moving?
    end
  end
  #----------------------------------------------------------------------------
  # * Display info on window
  #----------------------------------------------------------------------------
  def display_info(text)
    @window_log.add_text(text)
  end
  #----------------------------------------------------------------------------
  # * Clear info
  #----------------------------------------------------------------------------
  def clear_info
    @window_log.clear
  end
  #--------------------------------------------------------------------------
  # * Update Encounter
  #--------------------------------------------------------------------------
  def update_encounter
  end
  #--------------------------------------------------------------------------
end
