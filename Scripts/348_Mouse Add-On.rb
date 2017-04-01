#===========================================================================
# * Mouse Add on
# -------------------------------------------------------------------------
#   Add-ons and utility enhance for mouse
#===========================================================================
module Mouse
  
  GetMessage = Win32API.new('user32', 'GetMessage', 'plll', 'l')
  MouseWheel =  0x020A
  WM_Message = Struct.new(:message, :wparam, :lparam)
  
  class << self; alias update_wheel update; end
  def self.update
    update_scroll
    update_wheel
  end
  
  def self.scroll_down?
    @wheelstate && @wheelstate > 0x8000
  end
  
  def self.scroll_up?
    @wheelstate && @wheelstate < 0x8000
  end
  
  def self.update_scroll
    msg = "\0" * 32
    GetMessage.call(msg, self.hwnd, 0, 0)
    wm_mousewheel = unpack_wheelmessage(msg)
    @wheelstate   = to_hiword(wm_mousewheel.wparam) rescue nil
  end
  
  def self.unpack_wheelmessage(message)
    message = message.unpack('lllllll')
    wm_msg  = WM_Message.new
    wm_msg.message = message[1]
    wm_msg.wparam  = message[2]
    wm_msg.lparam  = message[3]
    return wm_msg.message == MouseWheel ? wm_msg : nil
  end
  
  def self.to_hiword(dword)
    ((dword & 0xffff0000) >> 16) & 0x0000ffff
  end
  
  
  def self.collide?(sprite)
    return object_area?(sprite.x, sprite.y, sprite.width, sprite.height)
  end
  
  def self.adjacent?(x, y)
    $game_player.adjacent?(map_grid[0], map_grid[1], x + 0.4, y)
  end
  
  #--------------------------------------------------------------------------
  # * Determind if trigger toolbar items
  #--------------------------------------------------------------------------
  def self.trigger_tool?(index)
    return false unless index
    return false unless self.trigger?(0)
    return true  if index == $game_player.mouse_skillbar_index
  end
  
end # Mouse
#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================
class Scene_Base
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_mouseauto update
  def update
    update_mouse_select_window
    update_mouseauto
  end
  #--------------------------------------------------------------------------
  # * Auto-select when mouse select to other window
  #--------------------------------------------------------------------------
  def update_mouse_select_window
    return unless Mouse.moved?
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      $focus_window = nil if $focus_window && $focus_window.disposed?
      if ivar.is_a?(Window_Selectable) && !ivar.disposed?
        $focus_window = ivar if ivar.active?
        if !ivar.active? && ivar.autoselect? && !@@overlayed && 
            Mouse.object_area?(ivar.x, ivar.y, ivar.width, ivar.height)
            
          $focus_window.unselect   if $focus_window && $focus_window.has_parent?
          $focus_window.deactivate if $focus_window
          process_autoselect(ivar)
          $focus_window = ivar
        end # !ivar.acive?
      end # is a Window_Selectable?
    end # each instance var
  end # update_mouse_select_window
  
  def process_autoselect(window)
    return if @@overlayed
    re = nil
    if window.is_a?(Window_FileAction)
      on_file_ok
      re = true
    elsif window.is_a?(Window_FileList)
      on_action_cancel
      re = true
    end
    Sound.play_cursor if re
  end
  
  
end
