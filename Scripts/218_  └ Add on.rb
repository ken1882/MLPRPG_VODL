#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias start_opt start
  def start
    start_opt
    #@message_window.scene_swap($DEFAULT_MESSAGE_SKIN)
  end
  #--------------------------------------------------------------------------
  # * Post-Start Processing
  #--------------------------------------------------------------------------
  def post_start
    super
    #$game_party.skillbar.update
    $game_map.restore_projectile
  end  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    return if $on_exit
    $game_map.update(true)
    $game_player.update
    $game_timer.update
    @spriteset.update
    update_scene if scene_change_ok?
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
      @menu_calling ||= Input.trigger?(:kESC)
      call_menu if @menu_calling && !$game_player.moving?
    end
  end
  
end
