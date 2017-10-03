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
    BattleManager.detect_combat
    update_scmap_tactic
  end
  #--------------------------------------------------------------------------
  # * Update for tactic mode
  #--------------------------------------------------------------------------
  def update_tactic
    return if @@overlayed
    update_tactic_cursor
    $game_map.update
    @spriteset.update_timelapse
    @command_window.update if @command_window.visible?
    @status_window.update
  end
  #--------------------------------------------------------------------------
  def start_tactic
    @tactic_enabled = true
    @spriteset.show_units
  end
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
    if Input.trigger?(:C)
      if Mouse.click?(1)
        return process_ok if !Mouse.hover_skillbar?
      else
        return process_ok
      end
    end
    return command_fallback if Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  def process_ok
    case @phase
    when Phase_Idle
      show_command_window if $game_player.is_friend?(@status_window.battler)
    when Phase_MoveSelection
      target = @battler.nil? ? POS.new(@tactic_cursor.x, @tactic_cursor.y) : @battler
      target.x = (@tactic_cursor.x * 4 + 0.5).to_i / 4
      target.y = (@tactic_cursor.y * 4 + 0.5).to_i / 4
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
    if @status_window.battler.command_holding?
      @status_window.battler.command_follow
    else
      @status_window.battler.command_hold
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
  def change_reaction
    char = @status_window.battler
    char.aggressive_level = (char.aggressive_level + 1) % 6
    show_command_window
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
    return command_fallback if @command_window.battler.nil?
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
