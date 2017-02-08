#==============================================================================
# ** Window_HorzCommand
#------------------------------------------------------------------------------
#  This is a command window for the horizontal selection format.
#==============================================================================
class Window_HorzCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # * Alias: contents width
  #--------------------------------------------------------------------------
  alias contents_width_cent contents_width
  def contents_width
    centralize? ? super : contents_width_cent
  end
  #--------------------------------------------------------------------------
  # * Alias: contents height
  #--------------------------------------------------------------------------
  alias contents_height_cent contents_height
  def contents_height
    centralize? ? super : contents_height_cent
  end
  #--------------------------------------------------------------------------
  # * Item alignment the center
  #--------------------------------------------------------------------------
  def centralize?
    false
  end
  #--------------------------------------------------------------------------
  # * Update Padding
  #--------------------------------------------------------------------------
  def update_padding
    super unless centralize?
  end
  #--------------------------------------------------------------------------
  # * Alias method: item_rect
  #--------------------------------------------------------------------------
  alias normal_item_rect item_rect
  def item_rect(index)
   centralize? ? central_item_rect(index) : normal_item_rect(index)
  end
  #--------------------------------------------------------------------------
  # * Item align center
  #--------------------------------------------------------------------------
  def central_item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    pos = (index + 1) % col_max
    rect.x = ((window_width / item_max) * pos - item_width + 4 * spacing * pos) / 2
    rect.y = (window_height / item_max / col_max * item_height * (index / col_max + 1)) / 8
    rect
  end
  
end
