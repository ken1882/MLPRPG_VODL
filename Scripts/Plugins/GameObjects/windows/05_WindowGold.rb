#==============================================================================
# ** Window_Gold
#------------------------------------------------------------------------------
#  This window displays the party's gold.
#==============================================================================
class Window_Gold < Window_Base
  attr_reader :type
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(_type = 1) # 0 = both, 1 = bit, 2 = chromastal
    @type = _type
    super(0, 0, window_width, fitting_height(@type == 0 ? 2 : 1))
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
    cy = 0
    if type < 2
      begin
        draw_common_currency_value(value, 4, cy, contents.width - 8)
      rescue Expection => e
        puts e
      end
      cy += line_height
    end
    s_value = BlockChain.item_amount(Vocab::Player, $data_items[42])
    draw_special_currency_value(s_value, 4, cy, contents.width - 8) if type != 1 && visible?
  end
  #--------------------------------------------------------------------------
  # * Draw Number (Gold Etc.) with Currency Unit
  #--------------------------------------------------------------------------
  def draw_common_currency_value(value, x, y, width)
    change_color(normal_color)
    draw_icon(PONY::IconID[:bit],0,0)
    draw_text(x, y, width - 2, line_height, value, 2)
    change_color(system_color)
  end
  #--------------------------------------------------------------------------
  # * Draw Special Currency Value, which can't be obtained normally
  #--------------------------------------------------------------------------
  def draw_special_currency_value(value, x, y, width)
    change_color(crisis_color)
    draw_icon(PONY::IconID[:chromastal],0,line_height)
    draw_text(x, y, width - 2, line_height, value, 2)
    change_color(system_color)
  end
  #--------------------------------------------------------------------------
  # * Get Party Gold
  #--------------------------------------------------------------------------
  def value
    #PONY.DecryptInt($game_party.gold(true))
    $game_party.gold(false)
  end
end
