#==============================================================================
# ** Window_LanguageList
#------------------------------------------------------------------------------
#  Display in Scene_System for supported languages
#==============================================================================
class Window_LanguageList < Window_InstanceItemList
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $supported_languages.keys
  end # def make item list
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      name = $supported_languages[item]
      draw_text(rect, name)
    end
  end
end
