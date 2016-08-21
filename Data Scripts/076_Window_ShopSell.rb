#==============================================================================
# ** Window_ShopSell
#------------------------------------------------------------------------------
#  This window displays a list of items in possession for selling on the shop
# screen.
#==============================================================================

class Window_ShopSell < Window_ItemList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    unsellable = item.note =~ /<unsellable>/ ? true : false
    item && item.price > 0 && !unsellable
  end
end
