#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
# tag: tactic(Scene_Map)
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  attr_reader :battler      # Selected battler
  attr_reader :target       # Target selected in Phase_Selection
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  Phase_Idle            = 0   # Nothing selected
  Phase_Selected        = 1   # A battler is selected
  Phase_MoveSelection   = 2   # Move Selection
  Phase_TargetSelection = 3   # Target Selection
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias start_dndtactic start
  def start
    @phase = Phase_Idle
    start_dndtactic
  end
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
    @command_window.update if @command_window.visible?
    @status_window.update
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
    hide_windows
  end
  #--------------------------------------------------------------------------
  def hide_windows
    @status_window.setup_battler(nil)
    @status_window.hide
    @window_help.hide
    @command_window.fallback
    @phase = Phase_Idle
  end
  #--------------------------------------------------------------------------
  def update_tactic_cursor
    return if @command_window.visible?
    @tactic_cursor.update
    @battler = @tactic_cursor.collide_battler?
    @status_window.setup_battler(@battler)
    process_command_handle
  end
  #--------------------------------------------------------------------------
  def process_command_handle
    return unless button_cooled?
    return process_ok       if Input.trigger?(:C)
    return command_fallback if Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  def process_ok
    case @phase
    when Phase_Idle
      show_command_window
    when Phase_MoveSelection
      target = @battler.nil? ? POS.new(@tactic_cursor.x, @tactic_cursor.y) : @battler
      do_move(target)
      command_fallback
    when Phase_TargetSelection
      @target = @battler.nil? ? POS.new(@tactic_cursor.x, @tactic_cursor.y) : @battler
      command_fallback
    end
    Sound.play_ok
    heatup_button
  end
  #--------------------------------------------------------------------------
  def command_fallback
    case @phase
    when Phase_Selected
      @command_window.fallback
      @phase = Phase_Idle
    when Phase_MoveSelection || Phase_TargetSelection
      @status_window.setup_battler(@command_window.battler)
      @tactic_cursor.relocate(@command_window.battler)
      show_command_window(@command_window.battler)
    end
  end
  #--------------------------------------------------------------------------
  def show_command_window(battler = nil)
    battler = battler.nil? ? @status_window.battler : battler
    @command_window.heatup_button
    @command_window.setup_battler(battler)
    @window_help.hide
    @status_window.refresh
    @phase = Phase_Selected
  end
  #--------------------------------------------------------------------------
  def command_move
    info = "Select a location to move, or an enemy to attack."
    @window_help.set_text(info)
    @window_help.show
    @command_window.hide
    @phase = Phase_MoveSelection
  end
  #--------------------------------------------------------------------------
  def command_hold
    if @battler.command_holding?
      @battler.command_follow
    else
      @battler.command_hold
    end
    show_command_window
  end
  #--------------------------------------------------------------------------
  def command_selection(info = nil)
    info = info.nil? ? "Select a location" : info
    @window_help.set_text(info)
    @window_help.show
    @command_window.hide
    @phase = Phase_TargetSelection
  end
  #--------------------------------------------------------------------------
  def command_cancel
    Sound.play_cancel
    command_fallback
    heatup_button
  end
  #--------------------------------------------------------------------------
  def get_target
    re = @target.nil? ? nil : @target.dup
    @target = nil
    return re
  end
  #--------------------------------------------------------------------------
  def do_move(target)
    if target.is_a?(Game_Event) || target.is_a?(Game_Enemy)
      @command_window.battler.set_target(target)
      @command_window.battler.popup_info("Attack")
    else
      @command_window.battler.move_to_position(target.x, target.y, depth: 300, tool_range: 0)
      @command_window.battler.popup_info("Move")
    end
  end
  #--------------------------------------------------------------------------
end
