#==============================================================================
# ** Scene_Shop
#------------------------------------------------------------------------------
#  This class performs shop screen processing.
#==============================================================================
class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Instance Vars
  #--------------------------------------------------------------------------
  attr_accessor :shopname
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    @shopname = "Shop"
  end
  #--------------------------------------------------------------------------
  # * Execute Purchase
  #  >> source is the bits payer, recipient is who take the bita
  #      thus source will gain the item, recipient will lose item.
  #--------------------------------------------------------------------------
  def do_buy(number)
    bits      = number * buying_price
    source    = Vocab::Player
    recipient = Vocab::Coinbase
    info      = sprintf("Bought %s(%d) at %s.", @item.name, number, @shopname)
    BlockChain.new_transaction(bits, @item, number, source, recipient, info)
    $game_party.gain_item_origin(@item, number)
  end
  #--------------------------------------------------------------------------
  # * Execute Sale
  #--------------------------------------------------------------------------
  def do_sell(number)
    bits      = number * selling_price
    source    = Vocab::Coinbase
    recipient = Vocab::Player
    info      = sprintf("Sold %s(%d) at %s.", @item.name, number, @shopname)
    BlockChain.new_transaction(bits, @item, number, source, recipient, info)
    $game_party.gain_item_origin(@item, -number)
  end
end
