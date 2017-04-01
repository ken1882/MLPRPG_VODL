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
  attr_reader   :name
  attr_reader   :id
  attr_reader   :hashid
  attr_accessor :value
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(_id, amount = 0)
    @name = Coin_Name[_id]
    @id = _id
    @value = amount.to_i
    hash_object
  end
  #--------------------------------------------------------------------------
  # * Object Hash
  #--------------------------------------------------------------------------
  def hash_object
    prefix = PONY.MD5(@name)
    suffix = PONY.MD5(@value.to_s)
    @hashid = PONY.Sha256(prefix + suffix).to_i(16)
  end
  
  def merge(amount)
    @value += amount
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
  attr_reader :goods
  attr_reader :good_amount
  attr_reader :consumed
  #--------------------------------------------------------------------------
  # * Initialization
  #--------------------------------------------------------------------------
  def initialize(type_id, amount, from, to, goods, good_amount = 1, info = "")
    @currency    = Game_Currency.new(type_id, amount)
    @source      = BlockChain.accounts(from, true)
    @recipient   = BlockChain.accounts(to, true)
    @info        = info
    @goods       = goods if goods
    @good_amount = good_amount
    @timestamp   = Time.now
    @consumed    = false
    @cleansed    = nil
    hash_object(true)
  end
  #--------------------------------------------------------------------------
  # * Merge/Offset Transaction
  #--------------------------------------------------------------------------
  def merge(trans)
    return if trans.source.id    != @source.id && trans.source.id    != @recipient.id 
    return if trans.recipient.id != @source.id && trans.recipient.id != @recipient.id
    return if trans.goods != @goods
    return :checksum_failed unless hash_object
    mul = (@source.id == trans.source.id) ? 1 : -1
    @good_amount   += trans.good_amount * mul if @goods
    @currency.merge(trans.value * mul)
    @consumed = (value == 0)
    hash_object(true)
    return @consumed
  end
  
  def hash_object(overwrite = false)
    base  = @goods ? (@goods.hashid + @good_amount).to_s : "bits"
    base += @source.id.to_s + @recipient.id.to_s
    base  = PONY.Sha256(base + @currency.hashid.to_s + @info + @timestamp.to_s).to_i(16)
    @hashid = base if overwrite
    backup         if overwrite
    return base == @hashid
  end
  
  def backup
    @cleansed = self.dup
  end
  
  def recover
    @currency    = @cleansed.currency.dup
    @source      = @cleansed.source
    @recipient   = @cleansed.recipient
    @info        = @cleansed.info
    @goods       = @cleansed.goods
    @good_amount = @cleansed.good_amount
    @timestamp   = @cleansed.timestamp
    @consumed    = @cleansed.consumed
    hash_object(true)
  end
  
  def dup_currency; @currency = @currency.dup; end
  #--------------------------------------------------------------------------
  # value of this transaction
  def value; return currency.value; end
  #--------------------------------------------------------------------------
  # currency type
  def type;  return currency.id; end
end
