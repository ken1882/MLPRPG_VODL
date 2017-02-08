#==============================================================================
# ** Game_Currency
#------------------------------------------------------------------------------
#  The trade currency; e.g. Bits
#==============================================================================
class Game_Currency
  Normal  = "βits"
  Special = "Chromastal"
  Coin_Name = [Normal, Special]
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :name
  attr_reader :id
  attr_reader :value
  attr_reader :hash_id
  attr_reader :hash_hex
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(_id, amount = 0)
    @name = Coin_Name[_id]
    @id = _id
    @value = amount
    self.hash_object
  end
  #--------------------------------------------------------------------------
  # * Object Hash
  #--------------------------------------------------------------------------
  def hash_object
    prefix = PONY::MD5(@name)
    suffix = PONY::MD5(@value.to_s)
    @hash_id = PONY::Sha256(prefix + suffix)
    @hash_hex = @hash_id.to_i(16)
  end
  
end
