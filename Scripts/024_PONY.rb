#==============================================================================
# ** PONY
#------------------------------------------------------------------------------
#  Pone Pone Pone~ Po-Po-Pony should poni pony
#==============================================================================
$imported = {} if $imported.nil?
Button_CoolDown = 10
SPLIT_LINE = "-----------------------------"
module PONY
  #----------------------------------
  TOTAL_BIT_VARIABLE_ID   = 31
  TOTAL_XP_VARIABLE_ID    = 32
  
  COMBAT_STOP_FLAG        = 98
  Enable_Loading          = true
  #----------------------------------
  ICON_ID = {
    :bit        => 558,
    :chromastal => 571,
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
      if value == 0
        #caller.each {|i| puts i}
      end
      num = API::DecryptInt.call([value].pack("Q"))
      return num.to_i
    end
  end
  class << self; alias DecryptInt DecInt; end
  #-----------------------------------------------------------------------------
end
