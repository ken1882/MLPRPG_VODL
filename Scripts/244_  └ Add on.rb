#==============================================================================
# ** Window_DebugLeft
#------------------------------------------------------------------------------
#  This window designates switch and variable blocks on the debug screen.
#==============================================================================
class Window_DebugLeft < Window_Selectable
  #--------------------------------------------------------------------------
  attr_reader :content_data
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  def category=(_cat, content_data)
    @category = _cat
    self.oy   = 0
    @content_data = content_data
    @item_max     = content_data.size
    @right_window.set_category(_cat, content_data) if @right_window
    refresh
    update
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    case @category
    when :variable
      n = index * 10
      text = sprintf("V [%04d-%04d]", n+1, n+10)
    when :switch
      n = index * 10
      text = sprintf("S [%04d-%04d]", n+1, n+10)
    when :bitmap
      text = (@content_data[index].source rescue "nil")
    end
    draw_text(item_rect_for_text(index), text)
  end
  #--------------------------------------------------------------------------
  def cursor_pagedown
    return call_handler(:pagedown) if handle?(:pagedown)
    super
  end
  #--------------------------------------------------------------------------
  def cursor_pageup
    return call_handler(:pageup) if handle?(:pageup)
    super
  end
  #--------------------------------------------------------------------------
end
