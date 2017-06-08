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
  attr_reader     :viewport
  #--------------------------------------------------------------------------
  # * Main
  #--------------------------------------------------------------------------
  alias main_pony main
  def main
    @@overlay_windows = {}
    @@button_cooldown = 0
    @@overlayed       = false
    $on_exit          = false
    #$game_party.sync_blockchain
    create_overlay_windows
    main_pony
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Update Frame (Basic)
  #--------------------------------------------------------------------------
  def update_basic
    Graphics.update
    Input.update
    update_all_windows unless @@overlayed
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
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_chain terminate
  def terminate
    PONY::CHAIN.verify_totalbalance unless self.is_a?(Scene_Map)
    terminate_chain
  end
  #--------------------------------------------------------------------------
  # * Overlay Window
  #--------------------------------------------------------------------------
  def create_overlay_windows
    if self.is_a?(SceneManager.first_scene_class)
      $confirm_exit_win = Window_Confirm.new(160, 180, "  Do you really want to leave? Ponies will miss you...", true)
      $confirm_win = Window_Confirm.new(160, 180, '', true)
      $popup_win = Window_PopInfo.new(160, 180, "", 180, true)
    end
    @@overlay_windows[:exit_confirm] = $confirm_exit_win
    @@overlay_windows[:confirm] = $confirm_win
    @@overlay_windows[:popinfo] = $popup_win
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_scbase update
  def update
    @@button_cooldown -= 1 unless button_cooled?
    update_terminate if button_cooled?
    update_console if button_cooled?
    update_overlay
    update_scbase
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
  # * Raise overlay window
  #--------------------------------------------------------------------------
  def raise_overlay_window(symbol, info = nil, method = nil, args = nil, forced = false)
    deactivate_all_windows(symbol)
    @@overlay_windows[symbol].raise_overlay(info, method, args, forced)
    $focus_window = @@overlay_windows[symbol]
  end
  #--------------------------------------------------------------------------
  # * Deactivate All Windows
  #--------------------------------------------------------------------------
  def deactivate_all_windows(symbol)
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      if ivar.is_a?(Window_Selectable) && ivar.active?
        @@overlay_windows[symbol].z = [ivar.z + 1, @@overlay_windows[symbol].z].max rescue nil
        @@overlay_windows[symbol].assign_last_window(ivar)
        ivar.deactivate
      end
    end
    
    @@overlay_windows.each do |sym, window|
      @@overlay_windows[symbol].z = [window.z + 1, @@overlay_windows[symbol].z].max rescue nil
    end
    
  end  
  #--------------------------------------------------------------------------
  # * Update overlay window
  #--------------------------------------------------------------------------
  def update_overlay
    @@overlayed = false
    @@overlay_windows.each do |sym, window|
      @@overlayed = true if window.visible?
      window.update      if @@overlayed
    end
  end
  #--------------------------------------------------------------------------
  # * Start button cooldown
  #--------------------------------------------------------------------------
  def heatup_button
    @@button_cooldown = Button_CoolDown
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
    @window_input = Window_Input.new(Graphics.center_width(480), Graphics.height - 80, 480, 24)
    loop do
      Graphics.update
      Input.update
      @window_input.update
      break if @input_string
    end
    begin
      eval @input_string
    rescue Exception => err
      puts SPLIT_LINE
      debug_print err
    end
    @input_string = nil
  end
  #--------------------------------------------------------------------------
  def retrieve_input(string)
    @input_string = string
  end
                                   
end
