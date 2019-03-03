$imported = {} if $imported.nil?
$imported["COM::DND::API"] = true
#==============================================================================
# ** PONY::API
#------------------------------------------------------------------------------
#  API is magic
#==============================================================================
module PONY::API
  VODLPath             = "System/VODL.dll"
  OpenALPath           = "System/OpenAL.dll"
  CheckSum             = Win32API.new(VODLPath, "Checksum",'pll','l')
  ClipCursor           = Win32API.new('user32', 'ClipCursor', 'p', 'l')
  CloseWindow          = Win32API.new('user32', 'CloseWindow', 'l', 'l')
  CreateWindowEx       = Win32API.new('user32', 'CreateWindowEx', 'lppliiiipppp', 'l')
  CheckConnection      = Win32API.new(VODLPath, 'CheckConnection', 'v', 'l')
  DispatchMessage      = Win32API.new('user32', 'DispatchMessage', 'p', 'p')
  DecryptInt           = Win32API.new(VODLPath, 'DecryptInt', 'p', 'p')
  EncryptInt           = Win32API.new(VODLPath, 'EncryptInt', 'p', 'p')
  FindWindow           = Win32API.new('user32', 'FindWindow', 'pp', 'i')
  FindWindowEX         = Win32API.new('user32', 'FindWindowEx', ['l','l','p','p'], 'i')
  GamejoltConnect      = Win32API.new(VODLPath, "GetGamejoltInfo", 'i', 'pp') rescue nil
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
  LoadGamegoltUrl      = Win32API.new(VODLPath, "LoadGamejoltUrl", 'p', 'p')
  MD5                  = Win32API.new(VODLPath, "MDA5",'p','p')
  Mining               = Win32API.new(VODLPath,"Mine_Block",['L','L'],'L')
  OpenALPlay           = Win32API.new(OpenALPath,"PlayAudio", 'pllllllllllll','l')
  OpenALInitDevice     = Win32API.new(OpenALPath,"InitDevice", 'P','l')
  OpenALInitContext    = Win32API.new(OpenALPath,"InitContext", 'PP','l')
  OpenALClose          = Win32API.new(OpenALPath,"DestroyDevice", 'pp','l')
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
  Verify               = Win32API.new(VODLPath,"Verify_Result",['L','L'],'p')
  VerifyGiftCode       = Win32API.new(VODLPath,"CodeValid", 'pp', 'l')
  WcharToMulByte       = Win32API.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'p')
  WritePPString        = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp', 'i')
  LoadGame   = Win32API.new(VODLPath, 'LoadGameData', 'p', 'p')
  FindFoler  = Win32API.new(VODLPath, 'GetFolderPath', 'ip', 'i')
  #-----------------------------------------------------------------------------
  # * General Confings setup
  #-----------------------------------------------------------------------------
  GetPPString.call("Game", "Title", "", title = "\0" * 256, 256, ".//Game.ini")
  Hwnd = FindWindow.call("RGSS Player", title.unpack("C*").collect {|a| a.chr }.join.delete!("\0"))
  
  puts("API loaded")
end
#==============================================================================
# ** PONY
#------------------------------------------------------------------------------
#  API calling function
#==============================================================================
module PONY
  #==============================================================================
  connected = API::CheckConnection.call.to_bool
  define_singleton_method(:online?){connected}
  #-----------------------------------------------------------------------------
  # * Module functions
  #-----------------------------------------------------------------------------
  module_function
  #-----------------------------------------------------------------------------
  def Sha256(input = nil)
    input = input.to_s unless input.is_a?(String)
    return input.nil? ? API::Sha256 : API::Sha256.call(input)
  end
  #-----------------------------------------------------------------------------
  def MD5(input = nil)
    return input.nil? ? API::MD5 : API::MD5.call(input)
  end
  #-----------------------------------------------------------------------------
  def Mining(input = nil, difficulty = 0x64)
    return input.nil? ? API::Mining : API::Mining.call(input, difficulty)
  end
  #-----------------------------------------------------------------------------
  def Verify(input = nil, difficulty = 0x64)
    return input.nil? ? API::Verify : API::Verify.call(input, difficulty)
  end
  #-----------------------------------------------------------------------------
  def CheckSum(input = nil, is_file = true, is_bin = true)
    is_file = is_file ? 1 : 0
    is_bin  = is_bin  ? 1 : 0
    return input.nil? ? API::CheckSum : API::CheckSum.call(input, is_file, is_bin)
  end
  #-----------------------------------------------------------------------------
  def EncInt(value)
    return unless value.is_a?(Numeric)
    if value < 0
      info = "Numeric out of range: #{value}"
      ERRNO.raise(:illegel_value, :exit, nil, info)
    else
      num = API::EncryptInt.call([value].pack("Q"))
      return num.to_i
    end
  end
  class << self; alias EncryptInt EncInt; end
  #-----------------------------------------------------------------------------
  def DecInt(value)
    return unless value.is_a?(Numeric)
    if value < 0
      info = "Numeric out of range: #{value}"
      ERRNO.raise(:illegel_value, :exit, nil, info)
    else
      #caller.each {|i| puts i} if value == 0
      num = API::DecryptInt.call([value].pack("Q"))
      return num.to_i
    end
  end
  class << self; alias DecryptInt DecInt; end
  #-----------------------------------------------------------------------------
  def InitOpenAL
    # tag: error >> bugged
    #$audio_device = Object.new
    #API::OpenALInitDevice.call(memprof($audio_device))
    #File.open('openal2.txt', 'wb'){|file| file << $audio_device}
    #$audio_context = API::OpenALInitContext.call(API::OpenALInitDevice.call)
  end
  #-----------------------------------------------------------------------------
  def CloseOpenAL
    #API::OpenALClose.call($audio_device, $audio_context)
  end
  #-----------------------------------------------------------------------------
  def PlayAudio(filename, sx, sy, sz, lx, ly, lz, 
                svx = 0, svy = 0, svz = 0, lvx = 0, lvy = 0, lvz = 0)
    #API::OpenALPlay.call(filename, sx, sy, sz, lx, ly, lz, svx, svy, svz, lvx, lvy, lvz)
  end
  #-----------------------------------------------------------------------------
  def VerifyGiftCode(code)
    unless PONY.online?
      info = Vocab::OfflineMode
      t    = sec_to_frame(10)
      SceneManager.scene.raise_overlay_window(:popinfo, info: info, time: t)
      return ;
    end
    
    path = "System\\"
    if File.exist?(path + "DownloadManager")
      info  = sprintf(Vocab::Errno::GiftCodeFailed, Vocab::Errno::ProgramMissing)
      info += "GDownloader"
      SceneManager.scene.raise_overlay_window(:popinfo, info);
      return false
    end
    if File.exist?(path + "GateCloser")
      info  = sprintf(Vocab::Errno::GiftCodeFailed, Vocab::Errno::ProgramMissing)
      info += "GCloser"
      SceneManager.scene.raise_overlay_window(:popinfo, info);
      return false
    end
    SceneManager.scene.raise_overlay_window(:popinfo, Vocab::Connection);
    # need some time to make overlay window displayed
    $giftcode_verify  = code
    $verify_countdown = 20
  end
  #-----------------------------------------------------------------------------
  def DoVerifyCode
    path = "System\\"
    code = $giftcode_verify
    result = API::VerifyGiftCode.call(path, code)
    $giftcode_verify  = nil
    $verify_countdown = nil
    case result
    when 0; return true;
    when 1; return :json_failed;
    when 2; return :connection_failed;
    when 3; return :invalid_code;
    when 4; return :close_failed;
    when 5; return :decrypt_failed;
    else
      return false
    end
  end
  #-----------------------------------------------------------------------------
  def hashid_table
    return @hashid_table
  end
  #-----------------------------------------------------------------------------
  def inhert_table
    @inhert_table
  end
  #-----------------------------------------------------------------------------
end
