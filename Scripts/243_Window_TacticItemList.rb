#==============================================================================
# ** Window_TacticItemList
#------------------------------------------------------------------------------
#  List the available tactic commands
#==============================================================================
# tag: command ( Tactic Item List
class Window_TacticItemList < Window_ItemList
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # * Include in Item List?
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :general
      return Tactic_Config::General_Actions.include?(item)
    when :targeting
      return Tactic_Config::Enemy::Condition_Table.include?(item)
    when :fighting
      return Tactic_Config::Target::Condition_Table.include?(item)
    when :self
      return Tactic_Config::Self::Condition_Table.include?(item)
    else
      return super
    end
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []  
    return super if [:item, :skill].include?(@category)
    case @category
    when :general
      @data = Tactic_Config::General_Actions.keys
    when :targeting
      @data = Tactic_Config::Enemy::Condition_Table.keys
    when :fighting
      @data = Tactic_Config::Target::Condition_Table.keys
    when :self
      @data = Tactic_Config::Players::Condition_Table.keys
    end
  end # last work: tactic processing
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item.is_a?(RPG::UsableItem)
      super
    else
      rect = item_rect(index)
      rect.width -= 4
      name = Tactic_Config::Name_Table[item]
      name = "<none>" if name.nil?
      icon_id = (PONY::IconID[item] || 0)
      draw_icon(icon_id, rect.x, rect.y) if icon_id > 0
      draw_text(rect.x + 24, rect.y, 172, line_height, name)
    end
    #--------------------------------------------------------------------------
  end
end
