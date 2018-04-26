$imported = {} if $imported.nil?
$imported["COM::DND::API"] = true
#==============================================================================
# ** PONY::API
#------------------------------------------------------------------------------
#  API is magic
#==============================================================================
module PONY::API
  
  CheckSum             = Win32API.new("System/VODL.dll", "Checksum",'pll','l')
  ClipCursor           = Win32API.new('user32', 'ClipCursor', 'p', 'l')
  CloseWindow          = Win32API.new('user32', 'CloseWindow', 'l', 'l')
  CreateWindowEx       = Win32API.new('user32', 'CreateWindowEx', 'lppliiiipppp', 'l')
  DispatchMessage      = Win32API.new('user32', 'DispatchMessage', 'p', 'p')
  DecryptInt           = Win32API.new('System/VODL.dll', 'DecryptInt', 'p', 'p')
  EncryptInt           = Win32API.new('System/VODL.dll', 'EncryptInt', 'p', 'p')
  FindWindow           = Win32API.new('user32', 'FindWindow', 'pp', 'i')
  FindWindowEX         = Win32API.new('user32', 'FindWindowEx', ['l','l','p','p'], 'i')
  GamejoltConnect      = Win32API.new("System/VODL.dll", "GetGamejoltInfo", 'i', 'pp') rescue nil
  GetAsyncKeyState     = Win32API.new("user32", "GetAsyncKeyState", 'i', 'i')
  GetClientRect        = Win32API.new('user32', 'GetClientRect', 'lp', 'i')
  GetClipboardData     = Win32API.new("user32","GetClipboardData", 'i', 'i')
  GetCursorPos         = Win32API.new('user32', 'GetCursorPos', 'p', 'i')
  GetFocus             = Win32API.new('user32', 'GetFocus', 'i', 'l')
  GetForegroundWindow  = Win32API.new('user32','GetForegroundWindow', 'v', 'l')
  GetKeyState          = Win32API.new("user32","GetKeyState", 'i', 'i')
  GetMessage           = Win32API.new('user32', 'GetMessage', 'plll', 'l')
  GetModuleHandle      = Win32API.new('kernel32', 'GetModuleHandle', 'p', 'l')
  GetPPString          = Win32API.new('kernel32', 'GetPrivateProfileString', 'pppplp', 'l')
  GetSystemMetrics     = Win32API.new('user32', 'GetSystemMetrics', ['i'], 'i')
  GetWindowRect        = Win32API.new('user32', 'GetWindowRect', 'lp', 'i')
  GetWindowText        = Win32API.new('user32', 'GetWindowText', 'lpi', 'i')
  GetWindowTextLength  = Win32API.new("user32", "GetWindowTextLength", "l", "l")
  IsWindow             = Win32API.new('user32', 'IsWindow', 'l', 'i')
  LoadGamegoltUrl      = Win32API.new('System/VODL.dll', "LoadGamejoltUrl", 'p', 'p')
  MD5                  = Win32API.new("System/VODL.dll", "MDA5",'p','p')
  Mining               = Win32API.new("System/VODL.dll","Mine_Block",['L','L'],'L')
  OpenALPlay           = Win32API.new("System/OpenAL.dll","PlayAudio", 'pllllllllllll','l')
  OpenALInitDevice     = Win32API.new("System/OpenAL.dll","InitDevice", 'P','l')
  OpenALInitContext    = Win32API.new("System/OpenAL.dll","InitContext", 'PP','l')
  OpenALClose          = Win32API.new("System/OpenAL.dll","DestroyDevice", 'pp','l')
  ScreenToClient       = Win32API.new('user32', 'ScreenToClient', 'lp', 'i')
  SetCursorPos         = Win32API.new('user32', 'SetCursorPos', 'nn', 'n')
  SetFocus             = Win32API.new('user32', "SetFocus", 'l', 'l')
  SetParent            = Win32API.new('user32', 'SetParent', 'll', 'l')
  SetWindowPos         = Win32API.new('user32', 'SetWindowPos', ['l','i','i','i','i','i','p'], 'i')
  SetWindowText        = Win32API.new('user32', 'SetWindowText', 'lp', 'l')
  SendMessage          = Win32API.new('user32', 'SendMessage', 'llll', 'l')
  Sha256               = Win32API.new("System/VODL.dll","Sha256",'p','p')
  ShowWindow           = Win32API.new('user32', "ShowWindow", "ll", "l")
  UpdateWindow         = Win32API.new('user32', 'UpdateWindow', 'l', 'l')
  Verify               = Win32API.new("System/VODL.dll","Verify_Result",['L','L'],'p')
  VerifyGiftCode       = Win32API.new("System/VODL.dll","CodeValid", 'pp', 'l')
  WcharToMulByte       = Win32API.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'p')
  WritePPString        = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp', 'i')
  
  LoadGame   = Win32API.new('System/vodl.dll', 'LoadGameData', 'p', 'p')
  FindFoler  = Win32API.new('System/vodl.dll', 'GetFolderPath', 'ip', 'i')
  #-----------------------------------------------------------------------------
  # * General Confings setup
  #-----------------------------------------------------------------------------
  GetPPString.call("Game", "Title", "", title = "\0" * 256, 256, ".//Game.ini")
  Hwnd = FindWindow.call("RGSS Player", title.unpack("C*").collect {|a| a.chr }.join.delete!("\0"))
  
  puts("API loaded")
end
