#==============================================================================
# ** Window_DebugLeft
#------------------------------------------------------------------------------
#  This window designates switch and variable blocks on the debug screen.
#==============================================================================
class Window_DebugLeft < Window_Selectable
  #--------------------------------------------------------------------------
  attr_reader :category, :content_data
  #--------------------------------------------------------------------------
  # * Get Mode
  #--------------------------------------------------------------------------
  def mode
  end
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  def set_category(_cat, content_data)
    @category = _cat
    self.oy   = 0
    @content_data = content_data
    @item_max     = [get_content_size, 1].max
    @right_window.set_category(_cat, content_data) if @right_window
    refresh
    update
  end
  #--------------------------------------------------------------------------
  def get_content_size
    case @category
    when :switch
      bas = @content_data.size == 0 ? $game_switches.item_max : @content_data.size
      return (bas + 9) / 10
    when :variable
      bas = @content_data.size == 0 ? $game_variables.item_max : @content_data.size
      return (bas + 9) / 10
    end
    return @content_data.size
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
    when :sprite
      text = @content_data[index].bitmap.source rescue nil
      text = @content_data[index].inspect unless text
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
  def top_id
    return index * 10 + 1
  end
  #--------------------------------------------------------------------------
end
