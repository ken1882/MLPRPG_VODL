#==============================================================================
# ** Window_ImageCommand
#------------------------------------------------------------------------------
#  This window deals with graphic command choices.
#==============================================================================
class Window_ImageCommand < Window_Command
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
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * item_width
    rect.y = index / col_max * item_height
    rect
  end
  #--------------------------------------------------------------------------
  # * Calculate Width of Window Contents
  #--------------------------------------------------------------------------
  def contents_width
    col_max * (item_width + spacing) + spacing
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    (item_width + spacing) * row_max + spacing
  end
  #--------------------------------------------------------------------------
  # * Add Command
  #     name    : Command name
  #     symbol  : Corresponding symbol
  #     image   : Path to the image
  #     enabled : Activation state flag
  #     ext     : Arbitrary extended data
  #     help    : Text displayed in tab-help window
  #--------------------------------------------------------------------------
  #def add_command(name, symbol, image, enabled = true, ext = nil, help = nil)
  def add_command(*args)
    case args.size
    when 1 # Hash initializer
      args = args[0]
      content = {
        :name     => args[:name],
        :symbol   => args[:symbol],
        :enabled  => args[:enabled].nil? ? true : args[:enabled],
        :ext      => args[:ext],
        :help     => args[:help],
        :image    => args[:image],
      }
    else
      name    = args[0]; symbol = args[1]; 
      image   = args[2];
      enabled = args[3].nil? ? true  : args[3];
      ext     = args[4]
      help    = args[5]
      content = {:name=>name, :symbol=>symbol, :enabled => enabled,
                 :ext=>ext, :help => help, :image => image}
      #----
    end
                      
    if !content[:symbol] || !content[:name] || !content[:image]
      errinfo = "Invalid parameter given:\nName: %s\nSymbol: %s\nImage: %s\n"
      errinfo = sprintf(errinfo, content[:name], content[:symbol], content[:image])
      raise ArgumentError, errinfo
    end
    
    @list.push(content)
  end
  #--------------------------------------------------------------------------
  # * Get Image file of Command
  #--------------------------------------------------------------------------
  def command_image(index)
    Cache.UI(@list[index][:image])
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    @help_text[index] = @list[index][:help]
    enabled = command_enabled?(index)
    change_color(normal_color, enabled)
    rect = item_rect_for_text(index)
    bitmap = command_image(index)
    draw_command_image(index, bitmap, enabled)
  end
  #--------------------------------------------------------------------------
  # * Draw Image
  #--------------------------------------------------------------------------
  def draw_command_image(index, bitmap, enabled = true)
    rect = Rect.new(0 , 0, bitmap.width, bitmap.height)
    dy   = index * (item_height + spacing)
    contents.blt(0, dy, bitmap, rect, enabled ? 255 : 155)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_row    = row if row < top_row
    self.bottom_row = row if row > bottom_row
  end
  
end
