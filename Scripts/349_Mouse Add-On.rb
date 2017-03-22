
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
  
end # Mouse
