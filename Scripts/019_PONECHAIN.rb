#==============================================================================
# ** PONY::CHAIN
#------------------------------------------------------------------------------
#  Pone's block chain setting
#==============================================================================
module PONY::CHAIN
  
  # Total Bits available for transaction
  TotalBalance = 10 ** 9
  
  # Missing bits goes here
  CoinBase = 0xc4f10a20486103dd74203a315edf9200
  # Mining Difficulty
  Difficulty = 0x64
  
  #--------------------------------------------------------------------------
  # * Nodes process block mining and player local bits flows
  #--------------------------------------------------------------------------
  Nodes = [
    "Equestria", # 0
      "Player",  # 1
      "Ponyvile",
      "Canterlot",
      "Cloudsdale",
      "Manehattan", # 5
      "Appleloosa",
      "Dodge_Junction",
      "Filly_Delphia",
      "Las_Pegasus",
      "Baltimare",  # 10
      "Starlights_Village",
      "Yanhooyer",
      "Rock_Farm", # 13
    #---------------------------
    "Crystal_Mountains", # 14
      "Crystal_Empire",
      "Yakyakistan",
    #---------------------------
    "HeartLands", # 17
      "Smoky_Mountains",
    #---------------------------
    "BadLands", # 19
      "UnderTribe",
    #---------------------------
    "Forbidden_Jungle", # 21
    #---------------------------
    "EastLands", # 22
      "Griffon_Stone",
      "Dragon_Land",
    #---------------------------
    "SouthEquestria", # 25
      "Saddle_Arbia",
      "Zefribia",
  ]
  #--------------------------------------------------------------------------#
  # * Each node's initial Bits in new game                                   #
  #--------------------------------------------------------------------------#
  #                 *  Magic Numbers  *                                      #
  Dispute_Weight = {
    0xc4f10a20486103dd74203a315edf9200 => 0.150, # Equestria
    0x636da1d35e805b00eae0fcd8333f9234 => 0    , # Player
    0xd8ce07f3e67ffde6d6260e426a51a70b => 0.050, # Ponyvile
    0x518f65c35638945cb6b2e3855b7c8f20 => 0.060, # Canterlot
    0x5ea8847659eedf0104b9b74cb26533df => 0.040, # Cloudsdale
    0x1e44e014507e1db404ebc32871d6d5ca => 0.060, # Manehattan
    0xa2ececaab1570fdc9dda6761b9fd4ccb => 0.008, # Appleloosa
    0x4588cc55c932638be854e8f503c9c088 => 0.005, # Dodge_Junction
    0x9cc4410a5715561f6eb559b9e2feadcf => 0.015, # Filly_Delphia
    0x42d7683217d076f0317d37e30f0796dd => 0.020, # Las_Pegasus
    0xf69d7bf4390d5f32d4e74ae56d72973d => 0.048, # Baltimare
    0x7ddcb5482c9ec7c003b35ee26053541c => 0.001, # Starlights_Village
    0x7c5cab193bf23cfb5932ab9b2e786a81 => 0.012, # Yanhooyer
    0xf066193a1b22cb02186da10f8ff2f745 => 0.003, # Rock_Farm
    0xa6ba93608028cb3d87c7c545a7beea37 => 0.060, # Crystal Mountains
    0x8efec93859f44adb1ee2f486710ba609 => 0.045, # Crystal Empire
    0x4483ac41f5856b3c63187901af52d593 => 0.012, # Yakyakistan
    0xe5bbc032695e96ea1d95163db1b9b1a7 => 0.065, # Heartlands
    0xf832346e5964994e4e0b6048c4af5569 => 0.008, # Smoky Mounatins
    0xf593ae588dfb9596a61f3431e4ae9475 => 0.010, # Badlands
    0x7a8f93689d916c5ee846d1fc1cd9e2a7 => 0.006, # Undertribe
    0xa59cd0371e35dde9ef61707d846e6414 => 0.004, # Forbidden Jungle
    0xb1237f571e8ea9bbe802e69d20087c45 => 0.060, # Eastlands
    0x560e56027d39ab11b5650c2f3bc46cbb => 0.060, # Griffon Stone
    0xb54b9f45b857c9bc910466a6f6e0e94f => 0.080, # Dragon Lands
    0xecc531adf9d75553a46be49dfee3cc2d => 0.008, # South Equestria
    0xb4c38b478dee769f5978662d7ca409ad => 0.095, # Saddle Arbia
    0x07c651182bf62dd18653ccf2f103d710 => 0.015, # Zefribia
  }
  #--------------------------------------------------------------------------
  # * Verify all nodes balance if equal to totalbalance
  #--------------------------------------------------------------------------
  def self.verify_totalbalance
    return true if BlockChain.node_empty?
    return true if SceneManager.scene_is?(Scene_Map)
    sum = BlockChain.account_balance
    result = (sum == TotalBalance)
    PONY::ERRNO.raise(:bits_incorrect, :exit, nil) unless result
    return result
  end
  
end
