
#==============================================================================
# ** Window_ImageCommand
#------------------------------------------------------------------------------
#  This window deals with graphic command choices.
#==============================================================================
class Window_ImageCommand < Window_HorzCommand
  MENU_ICON_WIDTH  = 50
  MENU_ICON_HEIGHT = 50
  #--------------------------------------------------------------------------
  # * Create Window Contents
  #--------------------------------------------------------------------------
  def create_contents
    contents.dispose
    if contents_width > 0 && contents_height > 0
      self.contents = Bitmap.new(contents_width, contents_height )
    else
      self.contents = Bitmap.new(1, 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Calculate Width of Window Contents
  #--------------------------------------------------------------------------
  def contents_width
    (item_width + spacing) * item_max - spacing
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    item_height
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    (width - standard_padding * 2 + spacing) / col_max - 60
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    MENU_ICON_HEIGHT
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Displaying Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.x = 4 + index * (item_width + spacing)
    rect.y = 0
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items (for Text)
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    rect
  end
  #--------------------------------------------------------------------------
  # * Add Command
  #     name    : Command name
  #     symbol  : Corresponding symbol
  #     image   : Image name
  #     enabled : Activation state flag
  #     ext     : Arbitrary extended data
  #--------------------------------------------------------------------------
  def add_command(name, image, symbol, enabled = true, ext = nil, help = nil)
    @list.push( {:name=>name, :symbol=>symbol, :image => image,:enabled=> enabled, :ext=>ext, :help=>help} )
  end
  #--------------------------------------------------------------------------
  # * Get Image file of Command
  #--------------------------------------------------------------------------
  def command_image(index)
    Cache.UI(@list[index][:image])
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  alias update_cursor_comp update_cursor
  def update_cursor
    update_cursor_comp
    
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    
    @help_text[index] = @list[index][:help]
    enabled = command_enabled?(index)
    change_color(normal_color, enabled)
    rect = item_rect_for_text(index)
    text = command_name(index)
    bitmap = command_image(index)
    
    draw_command_image(index, bitmap, enabled)
    #draw_text(rect, text, alignment)
  end
  #--------------------------------------------------------------------------
  # * Draw Image
  #--------------------------------------------------------------------------
  def draw_command_image(index, bitmap, enabled = true)
    rect_width  = index * (item_width + spacing)
    rect = Rect.new(0 , 0, MENU_ICON_WIDTH, MENU_ICON_HEIGHT)
    contents.blt(8 + rect_width, 1, bitmap, rect, enabled ? 255 : 155)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_col    = [index, item_max - 6].min if index < top_col
    self.bottom_col = [index, item_max - 3].min     if index > bottom_col
  end
  
end
