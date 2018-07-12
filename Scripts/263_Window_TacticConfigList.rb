#==============================================================================
# ** Window_TacticConfigList
#------------------------------------------------------------------------------
#  Display in Scene_Tactic for available configs
#==============================================================================
# tag: command ( Instance Item List
class Window_TacticConfigList < Window_InstanceItemList
  #--------------------------------------------------------------------------
  attr_reader :preset_data
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end  
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    if @preset_data
      @data = @preset_data.dup
      @preset_data = nil
      return
    end
    temp  = Tactic_Config::Condition_Symbol[@category]
    @data = []
    @data = [:player] if [:player_party_members].include?(temp)
    temp  = Tactic_Config.call_function(temp) if temp.is_a?(Symbol)
    @data += temp if temp
  end # def make item list
  #--------------------------------------------------------------------------
  def set_data(data)
    @preset_data = data || []
    refresh
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    icon_id = 0
    rect = item_rect(index)
    rect.width -= 4
    if item.is_a?(RPG::BaseItem)
      name = item.name
      icon_id = item.icon_index
    elsif @category == :jump_to
      name = sprintf("Jump to tactic: #%02d", item.index_id)
    else
      name = Vocab::TacticConfig::Name_Table[item]
      icon_id = (PONY::IconID[item] || 0)
    end
    name = "<none>" if name.nil?
    draw_icon(icon_id, rect.x, rect.y) if icon_id > 0
    draw_text(rect.x + 24, rect.y, item_width, line_height, name)
  end
  #--------------------------------------------------------------------------
end
