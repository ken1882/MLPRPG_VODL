#==============================================================================
# ** Window_ShopNumber
#------------------------------------------------------------------------------
#  This window is for inputting quantity of items to buy or sell on the shop
# screen.
#==============================================================================
class Window_ShopNumber < Window_Selectable
  #--------------------------------------------------------------------------
  # * Update Quantity
  #--------------------------------------------------------------------------
  def update_number
    mul = Input.press?(:kSHIFT) ? 5 : 1
    change_number( 1  * mul) if Input.repeat?(:RIGHT)
    change_number(-1  * mul) if Input.repeat?(:LEFT)
    change_number( 10 * mul) if Input.repeat?(:UP)
    change_number(-10 * mul) if Input.repeat?(:DOWN)
  end
end
