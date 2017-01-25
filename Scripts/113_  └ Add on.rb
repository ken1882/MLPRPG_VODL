#==============================================================================
# ** Window_Gold
#------------------------------------------------------------------------------
#  This window displays the party's gold.
#==============================================================================
class Window_Gold < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, fitting_height(2))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 120
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_common_currency_value(value, 4, 0, contents.width - 8)
    draw_special_currency_value(value, 4, line_height, contents.width - 8)
  end
  #--------------------------------------------------------------------------
  # * Draw Number (Gold Etc.) with Currency Unit
  #--------------------------------------------------------------------------
  def draw_common_currency_value(value, x, y, width)
    change_color(normal_color)
    draw_icon(PONY::ICON_ID[:bit],0,0)
    draw_text(x, y, width - 2, line_height, value, 2)
    change_color(system_color)
  end
  #--------------------------------------------------------------------------
  # * Draw Special Currency Value, which can't be obtained normally
  #--------------------------------------------------------------------------
  def draw_special_currency_value(value, x, y, width)
    change_color(crisis_color)
    draw_icon(PONY::ICON_ID[:chromastal],0,line_height)
    draw_text(x, y, width - 2, line_height, 0, 2)
    change_color(system_color)
  end
end
