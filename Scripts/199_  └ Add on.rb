#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================
class Scene_Base
  #--------------------------------------------------------------------------
  # * Main
  #--------------------------------------------------------------------------
  alias main_pony main
  def main
    @confrim_window = Window_Confirm.new(160, 160, " Do you really want to leave? Ponies will miss you...")
    @confrim_window.self_overlay
    @button_cooldown = 0
    $on_exit = false
    main_pony
  end
  #--------------------------------------------------------------------------
  # * Update Frame (Basic)
  #--------------------------------------------------------------------------
  def update_basic
    Graphics.update
    Input.update
    update_all_windows unless @confrim_window.overlayed
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_pony update
  def update
    @button_cooldown -= 1 if @button_cooldown > 0
    update_terminate if @button_cooldown <= 0
    update_overlay   if @confrim_window.overlayed
    update_pony
  end
  #--------------------------------------------------------------------------
  # * Update Alt + F4 exit
  #--------------------------------------------------------------------------
  def update_terminate
    return if @confrim_window.overlayed
    return unless Input.trigger?(:kF4)  || Input.press?(:kF4)
    return unless Input.trigger?(:kALT) || Input.press?(:kALT) 
    @button_cooldown = Button_CoolDown
    deactivate_all_windows
    $on_exit = true
    @confrim_window.raise_overlay(:exit)
  end
  #--------------------------------------------------------------------------
  # * Deactivate All Windows
  #--------------------------------------------------------------------------
  def deactivate_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      if ivar.is_a?(Window_Selectable) && ivar.active?
        @confrim_window.z = [ivar.z + 1, @confrim_window.z].max rescue nil
        @confrim_window.assign_last_window(ivar)
        ivar.deactivate
      end
    end
  end  
  #--------------------------------------------------------------------------
  # * Update overlay window
  #--------------------------------------------------------------------------
  def update_overlay
    @confrim_window.update
  end
  
  #--------------------------------------------------------------------------
end
