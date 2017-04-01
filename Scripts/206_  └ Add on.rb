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
  #--------------------------------------------------------------------------
  # * Main
  #--------------------------------------------------------------------------
  alias main_pony main
  def main
    @@overlay_windows = {}
    @@button_cooldown = 0
    @@overlayed       = false
    $on_exit          = false
    $game_party.sync_blockchain
    create_overlay_windows
    main_pony
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Update Frame (Basic)
  #--------------------------------------------------------------------------
  def update_basic
    puts "Mouse  address: (#{Mouse.pos})" if Input.trigger?(:kP)
    Graphics.update
    Input.update
    update_all_windows unless @@overlayed
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
  alias update_pony update
  def update
    @@button_cooldown -= 1 unless button_cooled?
    update_terminate if button_cooled?
    update_overlay
    update_pony
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
  # * Execute Transition
  #--------------------------------------------------------------------------
  def perform_transition
    speed = SceneManager.scene_is?(Scene_Map) ? 30 : transition_speed
    Graphics.transition(speed)
  end
  #--------------------------------------------------------------------------
end
