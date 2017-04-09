#==============================================================================
# ** PONY
#------------------------------------------------------------------------------
#  Pone Pone Pone~ Po-Po-Pony should poni pony
#==============================================================================
$imported = {} if $imported.nil?
Button_CoolDown = 10
SPLIT_LINE = "-----------------------------"
module PONY
  #--------------------------------------------------------------------------
  # * DLLs
  #--------------------------------------------------------------------------
  Sha256 = Win32API.new("lib/VODL.dll","Sha256",'p','p')
  MD5    = Win32API.new("lib/VODL.dll", "MDA5",'p','p')
  Mining = Win32API.new("lib/VODL.dll","Mine_Block",['L','L'],'L')
  Verify = Win32API.new("lib/VODL.dll","Verify_Result",['L','L'],'p')
  CheckSum = Win32API.new("lib/VODL.dll", "Checksum",'pll','l')
  
  def self.Sha256(input = nil)
    input = input.to_s unless input.is_a?(String)
    return input.nil? ? Sha256 : Sha256.call(input)
  end
  
  def self.MD5(input = nil)
    return input.nil? ? MD5 : MD5.call(input)
  end
  
  def self.Mining(input = nil, difficulty = 0x64)
    return input.nil? ? Mining : Mining.call(input, difficulty)
  end
  
  def self.Verify(input = nil, difficulty = 0x64)
    return input.nil? ? Verify : Verify.call(input, difficulty)
  end
  
  def self.CheckSum(input = nil, is_file = true, is_bin = true)
    is_file = is_file ? 1 : 0
    is_bin  = is_bin  ? 1 : 0
    return input.nil? ? CheckSum : CheckSum.call(input, is_file, is_bin)
  end
  
  #----------------------------------
  TOTAL_BIT_VARIABLE_ID   = 31
  TOTAL_XP_VARIABLE_ID    = 32
  
  COMBAT_STOP_FLAG        = 98
  ENABLE_FOLLOWER         = true
  #----------------------------------
  ICON_ID = {
    :bit        => 558,
    :chromastal => 571,
    
  }
  
end
