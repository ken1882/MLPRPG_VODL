
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  attr_reader :window_log
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias start_opt start
  def start
    @tactic_enabled = false
    start_opt
    create_tactic_cursor
    create_windows
  end
  #--------------------------------------------------------------------------
  # * Post-Start Processing
  #--------------------------------------------------------------------------
  def post_start
    super
    spriteset.restore_projectile
    $game_map.deploy_map_item_drops
  end
  #--------------------------------------------------------------------------
  def create_windows
    @window_log     = Window_InformationLog.new(SceneManager.resume_map_info)
    @status_window  = Window_TacticStatus.new
    @command_window = Window_TacticCommand.new(0,@status_window.y + @status_window.height)
    @window_help    = Window_Help.new(1)
    @window_help.y  = Graphics.height - @window_help.height
    @window_help.z  = 1200
    @window_help.hide
    @command_window_name  = "@command_window".to_sym
    @status_window_name   = "@status_window".to_sym
    set_handlers
  end
  #--------------------------------------------------------------------------
  def set_handlers
    @command_window.set_handler(:move,      method(:command_move))
    @command_window.set_handler(:hold,      method(:command_hold))
    @command_window.set_handler(:reaction,  method(:change_reaction))
    @command_window.set_handler(:cancel,    method(:command_cancel))
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_scmap_dnd terminate
  def terminate
    @message_window.dispose_all_windows
    SceneManager.save_map_infos(@window_log.data)
    $game_system.change_cursor_bitmap(nil)
    $game_map.dispose_item_drops
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
  # * Update All Windows
  #--------------------------------------------------------------------------
  def update_all_windows
    instance_variables.each do |varname|
      next if varname == @command_window_name || varname == @status_window_name
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Window) && !ivar.disposed?
    end
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
      @menu_calling = false if $game_system.story_mode?
      call_menu if @menu_calling && !$game_player.moving?
    end
  end
  #----------------------------------------------------------------------------
  def create_tactic_cursor
    @tactic_cursor = Game_TacticCursor.new
    @spriteset.create_tactic_cursor(@tactic_cursor)
    $game_system.change_cursor_bitmap(PONY::IconID[:aim]) if $game_player.free_fire
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
  def register_battle_unit(battler)
    if @spriteset
      @spriteset.register_battle_unit(battler)
    end
  end
  #--------------------------------------------------------------------------
  def resign_battle_unit(battler)
    if @spriteset
      @spriteset.resign_battle_unit(battler)
    end
  end
  #--------------------------------------------------------------------------
  def setup_weapon_use(action)
    if @spriteset
      @spriteset.setup_weapon_use(action)
    end
  end
  #--------------------------------------------------------------------------
  def update_encounter
  end
  #--------------------------------------------------------------------------
end
