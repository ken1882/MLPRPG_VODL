#==============================================================================
# ** PONY::API
#------------------------------------------------------------------------------
#  API is magic
#==============================================================================
module PONY::API
  
  CheckSum = Win32API.new("lib/VODL.dll", "Checksum",'pll','l')
  ClipCursor = Win32API.new('user32', 'ClipCursor', 'p', 'l')
  FindWindow = Win32API.new('user32', 'FindWindow', 'pp', 'i')
  FindWindowEX = Win32API.new('user32', 'FindWindowEx', ['l','l','p','p'], 'i')
  GamejoltConnect = Win32API.new("lib/VODL.dll", "GetGamejoltInfo", 'i', 'pp') rescue nil
  GetSystemMetrics = Win32API.new('user32', 'GetSystemMetrics', ['i'], 'i')
  GetKeyStat = Win32API.new("user32","GetKeyState", 'i', 'i')
  GetClipboardData = Win32API.new("user32","GetClipboardData", 'i', 'i')
  Get_Message = Win32API.new('user32', 'GetMessage', 'plll', 'l')
  GetAsyncKeyState = Win32API.new("user32", "GetAsyncKeyState", 'i', 'i')
  GetKeyState = Win32API.new("user32", "GetKeyState", 'i', 'i')
  GetCursorPos = Win32API.new('user32', 'GetCursorPos', 'p', 'i')
  GetClientRect = Win32API.new('user32', 'GetClientRect', 'lp', 'i')
  GetWindowRect = Win32API.new('user32', 'GetWindowRect', 'lp', 'i')
  GetPPString = Win32API.new('kernel32', 'GetPrivateProfileString', 'pppplp', 'l')
  MD5    = Win32API.new("lib/VODL.dll", "MDA5",'p','p')
  Mining = Win32API.new("lib/VODL.dll","Mine_Block",['L','L'],'L')
  Sha256 = Win32API.new("lib/VODL.dll","Sha256",'p','p')
  SetCursorPos = Win32API.new('user32', 'SetCursorPos', 'nn', 'n')
  ScreenToClient = Win32API.new('user32', 'ScreenToClient', 'lp', 'i')
  SetWindowPos = Win32API.new('user32', 'SetWindowPos', ['l','i','i','i','i','i','p'], 'i')
  Verify = Win32API.new("lib/VODL.dll","Verify_Result",['L','L'],'p')
  WritePPString = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp', 'i')
  
  LoadGame   = Win32API.new('lib/vodl.dll', 'LoadGameData', 'p', 'p')
  FindFoler  = Win32API.new('lib/vodl.dll', 'GetFolderPath', 'ip', 'i')
  #-----------------------------------------------------------------------------
  # * General Confings setup
  #-----------------------------------------------------------------------------
  GetPPString.call("Game", "Title", "", title = "\0" * 256, 256, ".//Game.ini")
  Hwnd = FindWindow.call("RGSS Player", title.unpack("C*").collect {|a| a.chr }.join.delete!("\0"))
  
  debug_print("API loaded")
end
