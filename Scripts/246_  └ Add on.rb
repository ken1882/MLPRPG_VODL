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
  def contents_width
    return Graphics.width
  end
  #--------------------------------------------------------------------------
  def contents_right
    return Gracphis.height
  end
  #--------------------------------------------------------------------------
  def refresh
    unselect if @category == :bitmap
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
    when :bitmap
      darw_bitmap_item
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
  def darw_bitmap_item
    return unless data
    rect = Rect.new(0, 0, data.width, data.height)
    contents.blt(0, 0, data, rect)
  end
  #--------------------------------------------------------------------------
  def display_bot
    dx = [contents.width  - width  - standard_padding, 0].max
    dy = [contents.height - height - standard_padding, 0].max
    return POS.new(dx, dy)
  end
  #--------------------------------------------------------------------------
  def cursor_right
    return super unless @category == :bitmap
    self.ox = [self.ox + BitmapNegativeSpeed, display_bot.x].min
  end
  #--------------------------------------------------------------------------
  def cursor_left
    return super unless @category == :bitmap
    self.ox = [self.ox - BitmapNegativeSpeed, 0].max
  end
  #--------------------------------------------------------------------------
  def cursor_up
    return super unless @category == :bitmap
    self.oy = [self.oy - BitmapNegativeSpeed, 0].min
  end
  #--------------------------------------------------------------------------
  def cursor_down
    return super unless @category == :bitmap
    self.oy = [self.oy + BitmapNegativeSpeed, display_bot.y].min
  end
  #--------------------------------------------------------------------------
end
