#==============================================================================
# ** Pony
#------------------------------------------------------------------------------
#  Pony should poni pony
#==============================================================================
$imported = {} if $imported.nil?
Button_CoolDown = 10
module PONY
  #--------------------------------------------------------------------------
  # * DLLs
  #--------------------------------------------------------------------------
  Sha256 = Win32API.new("lib/Sha256.dll","Sha256",'p','p')
  MD5    = Win32API.new("lib/MD5.dll", "MDA5",'p','p')
  Mining = Win32API.new("lib/POW.dll","Mine_Block",['L','L'],'L')
  Verify = Win32API.new("lib/POW.dll","Verify_Result",['L','L'],'p')
  
  def self.Sha256(input = nil)
    return input.nil? ? Sha256 : Sha256.call(input)
  end
  
  def self.MD5(input = nil)
    return input.nil? ? MD5 : MD5.call(input)
  end
  
  def self.Mining(input = nil)
    return input.nil? ? Mining : Mining.call(input)
  end
  
  def self.Verify(input = nil)
    return input.nil? ? Verify : Verify.call(input)
  end
  
  #----------------------------------
  TOTAL_BIT_VARIABLE_ID   = 31
  TOTAL_XP_VARIABLE_ID    = 32
  
  COMBAT_STOP_FLAG        = 98
  ENABLE_FOLLOWER         = true
  #----------------------------------
  ICON_ID = {
    :bit => 558,
    :chromastal => 571,
  }
  #--------------------------------------------------------------------------
  # * PonyChain
  #--------------------------------------------------------------------------
  CoinBase = 0x19714a76fe85569718e451d8fa7a4de15afa3cff06016717df84fc364f0a9885
  Nodes = [
    "Equestria", # 0
      "Ponyvile",
      "Canterlot",
      "Cloudsdale",
      "Manehattan",
      "Appleloosa",
      "Dodge_Junction",
      "Filly_Delphia",
      "Las_Pegasus",
      "Baltimare",
      "Starlights_Village",
      "Yanhooyer",
      "Rock_Farm", # 12
    #---------------------------
    "Crystal_Mountains", # 13
      "Crystal_Empire",
      "Yakyakistan",
    #---------------------------
    "HeartLands", # 16
      "Smoky_Mountains",
    #---------------------------
    "BadLands", # 18
      "UnderTribe",
    #---------------------------
    "Forbidden_Jungle", #20
    #---------------------------
    "EastLands", # 21
      "Griffon_Stone",
      "Dragon_Land",
    #---------------------------
    "SouthEquestria", # 24
      "Saddle_Arbia",
      "Zefribia",
  ]
  #----------------------------------
end
