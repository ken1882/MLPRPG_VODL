#==============================================================================
# ** Window_InstanceItemList
#------------------------------------------------------------------------------
#  Just like item list, but return the selected item after ok processed
#==============================================================================
# tag: command ( Instance Item List
class Window_InstanceItemList < Window_ItemList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @return_item = nil
  end
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  def update
    super
    return process_terminate if @return_item && !active?
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return true
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
  #--------------------------------------------------------------------------
  def include?(item)
    return true
  end
  #--------------------------------------------------------------------------
  def call_ok_handler
    super
    @return_item = @data[index]
  end
  #--------------------------------------------------------------------------
  def call_cancel_handler
    super
    @return_item = :nil
  end
  #--------------------------------------------------------------------------
  def process_terminate
    begin
      re = @return_item.dup
    rescue Exception
      re = @return_item
    end
    @return_item = nil
    puts "Item List return: #{re}"
    return re
  end
end
