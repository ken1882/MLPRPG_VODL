#==============================================================================
# ** Window_DebugRight
#------------------------------------------------------------------------------
#  This window displays switches and variables separately on the debug screen.
#==============================================================================
class Window_DebugRight < Window_Selectable
  #--------------------------------------------------------------------------
  BitmapNegativeSpeed = 10
  #--------------------------------------------------------------------------
  attr_reader :category
  attr_reader :data
  #--------------------------------------------------------------------------
  # * Object Initialization
  #-------------------------------------------------------------------------
  alias init_debug initialize
  def initialize(x, y, width)
    init_debug(x, y, width)
    self.arrows_visible = false
  end
  #--------------------------------------------------------------------------
  alias :mode :category
  #--------------------------------------------------------------------------
  def contents_width
    return Graphics.width
  end
  #--------------------------------------------------------------------------
  def contents_right
    return Gracphis.height
  end
  #--------------------------------------------------------------------------
  def refresh
    unselect if @category == :sprite
    super
  end
  #--------------------------------------------------------------------------
  def set_category(_cat, data)
    @category = _cat
    @data     = data
    refresh
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    return unless @category
    data_id = @top_id + index
    id_text = sprintf("%04d:", data_id)
    id_width = text_size(id_text).width
    case @category
    when :sprite
      return darw_bitmap_item((@top_id - 1) / 10)
    when :switch
      name   = $data_system.switches[data_id]
      status = data[data_id] ? "[ON]" : "[OFF]"
    when :variable
      name   = $data_system.variables[data_id]
      status = data[data_id]
    end
    name = "" unless name
    rect = item_rect_for_text(index)
    change_color(normal_color)
    draw_text(rect, id_text)
    rect.x += id_width
    rect.width -= id_width + 60
    draw_text(rect, name)
    rect.width += 60
    draw_text(rect, status, 2)
  end
  #--------------------------------------------------------------------------
  def darw_bitmap_item(index)
    return unless @data[index]
    data = @data[index].bitmap
    if data.disposed?
      contents.draw_text(0, 0, 240, line_height, "Disposed Bitmap")
    else
      rect = Rect.new(0, 0, data.width, data.height)
      contents.blt(0, 0, data, rect)
    end    
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    return cursor_rect.empty if @category == :sprite
    return super
  end
  #--------------------------------------------------------------------------
  def display_bot
    dx = [contents.width  - width  - standard_padding, 0].max
    dy = [contents.height - height - standard_padding, 0].max
    return POS.new(dx, dy)
  end
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    return super unless @category == :sprite
    self.ox = [self.ox + BitmapNegativeSpeed, display_bot.x].min
  end
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    return super unless @category == :sprite
    self.ox = [self.ox - BitmapNegativeSpeed, 0].max
  end
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    return super unless @category == :sprite
    self.oy = [self.oy - BitmapNegativeSpeed, 0].max
  end
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    return super unless @category == :sprite
    self.oy = [self.oy + BitmapNegativeSpeed, display_bot.y].min
  end
  #--------------------------------------------------------------------------
end
