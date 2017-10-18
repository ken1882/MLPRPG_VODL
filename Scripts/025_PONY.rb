#==============================================================================
# ** PONY
#------------------------------------------------------------------------------
#  Pone Pone Pone~ Po-Po-Pony should poni pony
#==============================================================================
$imported = {} if $imported.nil?
Button_CoolDown = 10
SPLIT_LINE = "-------------------------------------------------"
module PONY
  #----------------------------------
  TOTAL_BIT_VARIABLE_ID   = 31
  TOTAL_XP_VARIABLE_ID    = 32
  
  COMBAT_STOP_FLAG        = 98
  Enable_Loading          = true
  
  TimeCycle               = 60  # Frame
  @hashid_table           = {}
  
  # tag: icon
  #----------------------------------
  IconID = {
    :bit            => 558,
    :chromastal     => 571,
    :mouse_casting  => 386,
    :loot_drop      => 573,
    :aim            => 6140,
    :fighting       => 115,
    :self           => 125,
    :plus           => 1143,
  }
  #----------------------------------
  StateID = {
    :aggressive_level => [7,8,9,10,11,12],
    :true_sight       => 13,
  }
  #----------------------------------
  LightStateID = {
    14  =>  0, # Light_Core::Effects
  }
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
    path = "System\\"
    if File.exist?(path + "DownloadManager")
      info = "Gemfile missing: GDownloader"
      SceneManager.scene.raise_overlay_window(:popinfo, "An error occurred while verifing code:\n" + info);
      return false
    end
    if File.exist?(path + "GateCloser")
      info = "Gemfile missing: GDownloader"
      SceneManager.scene.raise_overlay_window(:popinfo, "An error occurred while verifing code:\n" + info);
      return false
    end
    SceneManager.scene.raise_overlay_window(:popinfo, "Obtaining data from internet, your game may be no respond for about one miniute, please wait...");
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
  
end
