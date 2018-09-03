#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================
class Scene_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor   :overlay_windows
  attr_reader     :overlayed
  attr_reader     :viewport, :superviewport
  attr_reader     :item_help_window
  #--------------------------------------------------------------------------
  # * Main
  #--------------------------------------------------------------------------
  def main
    @@overlay_windows   = {}
    @@button_cooldown   = 0
    @@overlayed         = false
    $on_exit            = false
    create_debug_window if debug_mode?
    #-------------------------------
    start
    create_overlay_windows
    create_item_help_window
    create_dim_background
    post_start
    #-------------------------------
    loop do
      break if scene_changing?
      update
    end
    
    pre_terminate
    terminate
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Frame Update
  #--------------------------------------------------------------------------
  def update
    update_basic
    update_all_windows unless @@overlayed
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Update Frame (Basic)
  #--------------------------------------------------------------------------
  def update_basic
    #sleep(0.1) until PONY::API::GetForegroundWindow.call == PONY::API::Hwnd
    @@button_cooldown -= 1 unless button_cooled?
    Graphics.update
    Input.update
    $game_console.update_focus
    update_mutex
    update_errno
    update_global_help_window
  end
  #--------------------------------------------------------------------------
  def update_mutex
    error = PONY::ERRNO.error_occurred?
    flag_error(error) if error
  end
  #--------------------------------------------------------------------------
  def update_errno
    PONY::ERRNO.raise_errno if PONY::ERRNO.errno_occurred?
  end
  #--------------------------------------------------------------------------
  def update_verify
    return unless $verify_countdown
    $verify_countdown -= 1 
    return if $verify_countdown > 0
    result = PONY.DoVerifyCode if $giftcode_verify
    
    if result == true
      info = Vocab::Errno::APISymbol_Table[true]
    else
      info = sprintf(Vocab::Errno::APIErr, Vocab::Errno::APISymbol_Table[result])
    end
    raise_overlay_window(:popinfo, info)
  end
  #--------------------------------------------------------------------------
  # * Post-Start Processing
  #--------------------------------------------------------------------------
  alias post_start_scbase post_start
  def post_start
    SceneManager.update_loading while SceneManager.loading?
    debug_print "Post Start"
    post_start_scbase
    $game_system.load_complete
    debug_print "Load Complete"
  end
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias start_scbase start
  def start
    Cache.clear_sprite
    create_superviewport
    start_scbase
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_chain terminate
  def terminate
    dispose_item_help_window
    PONY::CHAIN.verify_totalbalance unless self.is_a?(Scene_Map)
    terminate_chain
  end
  #--------------------------------------------------------------------------
  # * Create Super Viewport
  #--------------------------------------------------------------------------
  def create_superviewport
    @superviewport = Viewport.new
    @superviewport.z = PONY::SpriteDepth::Table[:overlays]
  end
  #--------------------------------------------------------------------------
  # * Overlay Window
  #--------------------------------------------------------------------------
  def create_overlay_windows
    if self.is_a?(SceneManager.first_scene_class)
      $confirm_exit_win = Window_Confirm.new(nil, nil, nil, nil, Vocab::ExitConfirm, true)
      $confirm_win = Window_Confirm.new(nil, nil, nil, nil, '', true)
      t = sec_to_frame(5)
      $popup_win = Window_PopInfo.new(nil, nil, nil, nil, "", t, true)
    end
    @@overlay_windows[:exit_confirm] = $confirm_exit_win
    @@overlay_windows[:confirm] = $confirm_win
    @@overlay_windows[:popinfo] = $popup_win
  end
  #----------------------------------------------------------------------------
  # * Item help window
  #----------------------------------------------------------------------------
  def create_item_help_window
    @help_window_timer = 0
    @item_help_window = Sprite.new(@superviewport)
    @item_help_text   = Sprite.new(@superviewport)
    bitmap = Cache.UI("item_help_scroll")
    @item_help_window.bitmap = bitmap
    @item_help_text.bitmap = Bitmap.new(bitmap.width, bitmap.height)
    @item_help_window.hide
    @item_help_text.hide
  end
  #----------------------------------------------------------------------------
  def create_dim_background
    @dim_background = Sprite.new(@superviewport)
    @dim_background.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @dim_background.opacity = 128
    @dim_background.z = @superviewport.z - 0x10
    color = Color.new(16,16,16)
    @dim_background.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, color)
    @dim_background.hide
  end
  #----------------------------------------------------------------------------
  def create_debug_window
    $debug_window = Window_DebugPanel.new
    @@overlay_windows[:debug] = $debug_window
  end
  #----------------------------------------------------------------------------
  def dispose_item_help_window
    @item_help_window.dispose
    @item_help_text.dispose
    @item_help_window = nil
    @item_help_text   = nil
  end
  #--------------------------------------------------------------------------
  # * Free Viewport
  #--------------------------------------------------------------------------
  alias dispose_all_viewports dispose_main_viewport
  def dispose_main_viewport
    @dim_background.dispose
    @superviewport.dispose    
    dispose_all_viewports
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_scbase update
  def update
    update_terminate
    update_overlay
    update_debug_window if debug_mode? && button_cooled?
    update_console      if debug_mode? && button_cooled?
    update_scbase
    update_verify
  end
  #--------------------------------------------------------------------------
  # * Update Alt + F4 exit
  #--------------------------------------------------------------------------
  def update_terminate
    return if @@overlay_windows[:exit_confirm].overlayed
    return unless Input.trigger?(:kF4)  || Input.press?(:kF4)
    return unless Input.trigger?(:kALT) || Input.press?(:kALT) 
    self.heatup_button
    $on_exit = true
    raise_overlay_window(:exit_confirm , nil, :exit)
  end
  #--------------------------------------------------------------------------
  # * Update All Windows
  #--------------------------------------------------------------------------
  def update_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Window) && !ivar.disposed?
    end
  end
  #--------------------------------------------------------------------------
  # * Free All Windows
  #--------------------------------------------------------------------------
  def dispose_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      if ivar.is_a?(Window)
        ivar.dispose_all_windows rescue nil
        ivar.dispose unless !ivar || ivar.disposed?
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update global help window
  #--------------------------------------------------------------------------
  def update_global_help_window
    return if @help_window_timer == 0
    @help_window_timer -= 1 if @help_window_timer > 0
    hide_item_help_window if @help_window_timer == 0
  end
  #--------------------------------------------------------------------------
  def update_debug_window
    return unless Input.trigger?(:kF9)
    heatup_button
    window = @@overlay_windows[:debug]
    if window.visible?
      window.hide
    else
      SceneManager.process_tactic(true) unless SceneManager.tactic_enabled?
      window.show
    end
  end
  #--------------------------------------------------------------------------
  # * Raise overlay window
  #--------------------------------------------------------------------------
  def raise_overlay_window(symbol, *args)
    deactivate_all_windows(symbol)
    
    if args.size == 1 && args[0].is_a?(Hash)
      $on_exit = true if args[0][:method] == :exit
      @@overlay_windows[symbol].raise_overlay(args[0])
    else
      info      = args[0]
      method    = args[1]
      call_args = args[2]
      forced    = (args[3] || false)
      $on_exit = true if method == :exit
      @@overlay_windows[symbol].raise_overlay(info, method, call_args, forced)
    end
    SceneManager.process_tactic(true) unless SceneManager.tactic_enabled?
  end
  #--------------------------------------------------------------------------
  # * Deactivate All Windows
  #--------------------------------------------------------------------------
  def deactivate_all_windows(symbol)
    
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      if ivar.is_a?(Window_Selectable) && ivar.active?
        begin
          @@overlay_windows[symbol].z = [ivar.z + 1, @@overlay_windows[symbol].z].max
        rescue Exception => e
          puts "#{e}"
        ensure
          @@overlay_windows[symbol].assign_last_window(ivar)
          ivar.deactivate
        end
      end
    end
    
    @@overlay_windows.each do |sym, window|
      @@overlay_windows[symbol].z = [window.z + 1, @@overlay_windows[symbol].z].max rescue nil
    end
  end
  #--------------------------------------------------------------------------
  def find_current_active_window
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      if ivar.is_a?(Window_Selectable) && ivar.active?
        return ivar
      end
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Update overlay window
  #--------------------------------------------------------------------------
  def update_overlay
    @@overlayed = false
    @@overlay_windows.each do |sym, window|
      next unless window.visible?
      @@overlayed = true
      window.update
    end
  end
  #--------------------------------------------------------------------------
  # * Start button cooldown
  #--------------------------------------------------------------------------
  def heatup_button(multipler = 1)
    @@button_cooldown = Button_CoolDown * multipler
  end
  #--------------------------------------------------------------------------
  # * Button cooldown finished
  #--------------------------------------------------------------------------
  def button_cooled?
    @@button_cooldown <= 0
  end
  #--------------------------------------------------------------------------
  # * Get Transition Speed
  #--------------------------------------------------------------------------
  def transition_speed
    return 20
  end
  #--------------------------------------------------------------------------
  # * Execute Transition
  #--------------------------------------------------------------------------
  alias perform_transition_load perform_transition
  def perform_transition
    SceneManager.destroy_loading_screen
    perform_transition_load
  end
  #--------------------------------------------------------------------------
  # * Fade Out All Sounds and Graphics
  #--------------------------------------------------------------------------
  def fadeout_all(time = 1000, no_fadeout = false)
    RPG::BGM.fade(time)
    RPG::BGS.fade(time)
    RPG::ME.fade(time)
    Graphics.fadeout(time * Graphics.frame_rate / 1000) unless no_fadeout
    RPG::BGM.stop
    RPG::BGS.stop
    RPG::ME.stop
  end
  #--------------------------------------------------------------------------
  # > Console Debug
  #--------------------------------------------------------------------------
  def update_console
    return unless Input.press?(:kCTRL)
    return unless Input.press?(:kSPACE)
    @window_input = Window_Input.new(Graphics.center_width(480), Graphics.height - 80, 480, autoscroll: true)
    loop do
      update_basic
      @window_input.update
      break if @input_string
    end
    return if @input_string.strip.empty?
    #--
    begin
      eval("$game_console." + @input_string)
    rescue NoMethodError
      eval_standard(@input_string)
    rescue SyntaxError
      eval_standard(@input_string)
    rescue Exception => err
      puts SPLIT_LINE
      debug_print err
      puts err.backtrace
    end
    @input_string = nil
  end
  #--------------------------------------------------------------------------
  def eval_standard(code)
    begin
      eval(code)
    rescue Exception => err
      puts SPLIT_LINE
      debug_print err
      puts err.backtrace
    end
    @input_string = nil
  end
  #--------------------------------------------------------------------------
  def retrieve_input(string)
    @input_string = string
  end
  #----------------------------------------------------------------------------
  def get_input
    re = @input_string
    @input_string = nil
    return re
  end
  #----------------------------------------------------------------------------
  def show_item_help_window(x, y, text = "")
    return hide_item_help_window if text == @cur_item_help_text || text.nil? || text.empty?
    hide_item_help_window
    @cur_item_help_text = text
    rect = Rect.new(2, 2, 120, 42)
    @item_help_window.x, @item_help_window.y = x, y
    @item_help_text.x, @item_help_text.y = x, y
    
    @item_help_text.bitmap.font.size = 20
    
    lines = FileManager.textwrap(text, 120, @item_help_text.bitmap)
    
    lines.each do |line|
      @item_help_text.bitmap.draw_text(rect, line, 1)
      rect.y += 12
    end
    
    @item_help_window.show
    @item_help_text.show
    @help_window_timer = 150
  end
  #-------------------------------------------------------------------------
  def hide_item_help_window
    return unless @item_help_text && @item_help_window
    @cur_item_help_text = ""
    @help_window_timer = 0
    @item_help_text.hide
    @item_help_text.bitmap.clear
    @item_help_window.hide
  end
  #--------------------------------------------------------------------------
  # * Overwrite: aDetermine if Game Is Over
  #   Transition to the game over screen if the entire party is dead.
  #--------------------------------------------------------------------------
  def check_gameover
    return unless $game_party.all_dead?(true)
    return SceneManager.goto(Scene_Gameover) if $game_system.allow_gameover?
    SceneManager.call_all_dead_rescue
  end
  #--------------------------------------------------------------------------
  def show_dim_background
    @dim_background.show if @dim_background && !@dim_background.disposed?
  end
  #--------------------------------------------------------------------------
  def hide_dim_background
    @dim_background.hide if @dim_background && !@dim_background.disposed?
  end
  #--------------------------------------------------------------------------
end
