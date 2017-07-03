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
    info      = sprintf("%s bought %s(%d) at %s.", $game_party.leader.name, @item.name, number, @shopname)
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
    info      = sprintf("%s bought %s(%d) from %s.",$game_party.leader.name, @item.name, number, @shopname)
    BlockChain.new_transaction(bits, @item, number, source, recipient, info)
    $game_party.gain_item_origin(@item, -number)
  end
  #--------------------------------------------------------------------------
  # * Buy [OK]
  #--------------------------------------------------------------------------
  def on_buy_ok
    @item = @buy_window.item
    sync_blockchain
    @buy_window.hide
    @number_window.set(@item, max_buy, buying_price, currency_unit)
    @number_window.show.activate
  end
   #--------------------------------------------------------------------------
  # * Sell [OK]
  #--------------------------------------------------------------------------
  def on_sell_ok
    @item = @sell_window.item
    sync_blockchain
    @status_window.item = @item
    @category_window.hide
    @sell_window.hide
    @number_window.set(@item, max_sell, selling_price, currency_unit)
    @number_window.show.activate
    @status_window.show
  end
  #--------------------------------------------------------------------------
  # * Synchronize BlockChain
  #--------------------------------------------------------------------------
  def sync_blockchain
    BlockChain.recover_nodes
    $game_party.sync_blockchain(@item)
  end
  
end
