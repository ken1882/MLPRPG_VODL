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
  
end # Mouse
#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================
class Scene_Base
  #--------------------------------------------------------------------------
  # * Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :focus_window
  #--------------------------------------------------------------------------
  # * Post-Start Processing
  #--------------------------------------------------------------------------
  alias post_start_mouse post_start
  def post_start
    post_start_mouse
    @focus_window = nil
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_mouseauto update
  def update
    update_mouse_select
    update_mouseauto
  end
  #--------------------------------------------------------------------------
  # * Auto-select when mouse select to other window
  #--------------------------------------------------------------------------
  def update_mouse_select
    return unless Mouse.moved?
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      if ivar.is_a?(Window_Selectable)
        @focus_window = ivar if ivar.active?
        if !ivar.active? && Mouse.object_area?(ivar.x, ivar.y, ivar.width, ivar.height)
          @focus_window.deactivate if @focus_window
          @focus_window.unselect   if @focus_window && @focus_window.has_parent?
          ivar.activate
          @focus_window = ivar
        end
      end
    end # each instance var
  end # update_mouse_select
  
end
