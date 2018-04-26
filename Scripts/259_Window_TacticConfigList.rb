#==============================================================================
# ** Window_InstanceItemList
#------------------------------------------------------------------------------
#  Display in Scene_Tactic for available configs
#==============================================================================
# tag: command ( Instance Item List
class Window_TacticConfigList < Window_InstanceItemList
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    temp  = Tactic_Config::Condition_Symbol[@category]
    temp  = Tactic_Config.call_function(temp) if temp.is_a?(Symbol)
    @data = temp
  end # def make item list
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    rect.width -= 4
    if item.is_a?(RPG::BaseItem)
      name = item.name
      icon_id = item.icon_index
    else
      name = Vocab::TacticConfig::Name_Table[item]
      icon_id = (PONY::IconID[item] || 0)
    end
    name = "<none>" if name.nil?
    draw_icon(icon_id, rect.x, rect.y) if icon_id > 0
    draw_text(rect.x + 24, rect.y, item_width, line_height, name)
  end
end
