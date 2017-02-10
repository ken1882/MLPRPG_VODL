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
  attr_reader :hashid
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
    prefix = PONY.MD5(@name)
    suffix = PONY.MD5(@value.to_s(16))
    @hashid = PONY.Sha256(prefix + suffix).to_i(16)
  end
end
#==============================================================================
# ** Game_Transaction
#------------------------------------------------------------------------------
#  Transaction in game, or what do you want me to say!?
#==============================================================================
class Game_Transaction
  #--------------------------------------------------------------------------
  # * Instance Vars
  #--------------------------------------------------------------------------
  attr_reader :hashid
  attr_reader :currency
  attr_reader :source
  attr_reader :recipient
  attr_reader :info
  attr_reader :timestamp
  #--------------------------------------------------------------------------
  # * Initialization
  #--------------------------------------------------------------------------
  def initialize(type_id, amount, from, to, info = "")
    @currency  = Game_Currency.new(type_id, amount)
    @source    = PONY.Sha256(from).to_i(16)
    @recipient = PONY.Sha256(to).to_i(16)
    @info   = info
    @timestamp = Time.now
    @hashid = PONY.Sha256(Time.now.to_s + currency.hashid.to_s(16) + info)
  end
  # String to Ponyaccount
  def transaccount(is_source, account)
    @source    = account if is_source
    @recipient = account unless is_source
  end
  # value of this transaction
  def value; return currency.value; end
end
