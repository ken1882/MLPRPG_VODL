#==============================================================================
# ** Window_TacticItemList
#------------------------------------------------------------------------------
#  List the available tactic commands
#==============================================================================
# tag: command ( Tactic Item List
class Window_TacticItemList < Window_ItemList
  #--------------------------------------------------------------------------
  attr_accessor :symbol
  attr_accessor :command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system(WindowSkin::Fluttershy)
    @subwindow = nil
  end
  #--------------------------------------------------------------------------
  def init
    @ori_category = @command.category rescue nil
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
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
    @symbol = :action
    return super if [:item, :skill].include?(@category)
    case @category
    when :general
      @data = Tactic_Config::General_Actions.keys
    when :targeting
      @data = Tactic_Config::Enemy::Condition_Table.keys
      @command.category = :targeting
      @symbol = :condition
    when :fighting
      @data = Tactic_Config::Target::Condition_Table.keys
      @command.category = :fighting
      @symbol = :condition
    when :self
      @data = Tactic_Config::Players::Condition_Table.keys
      @command.category = :self
      @symbol = :condition
    else
      @symbol = nil
    end
  end # last work: tactic processing
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    return super if item.is_a?(RPG::UsableItem)
    return true
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    rect.width -= 4
    if item.is_a?(RPG::UsableItem)
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
  # * Call OK Handler
  #--------------------------------------------------------------------------
  def call_ok_handler
    if @command
      case @symbol
      when :condition
        cond = item
        result = call_subwindow(item)
        return call_cancel_handler if !result
        return call_cancel_handler if result.is_a?(Array) && !result.first
        @command.args = result
        if item.is_a?(Symbol)
          @command.condition_symbol = item
          @command.condition = ""
        else
          @command.condition_symbol = :code
          @command.condition = item
        end
      when :action
        @command.action.reassign_item(item, false)
      end
    end
    super
  end
  #--------------------------------------------------------------------------
  def call_cancel_handler
    @command.category = @ori_category if @ori_category
    super
  end
  #--------------------------------------------------------------------------
  def call_subwindow(item)
    help_text = Vocab::TacticConfig::InputHelp[item]
    return [true] if help_text.nil?
    if Tactic_Config::Condition_Symbol[item]
      @subwindow = create_select_window
      @subwindow.category = item
      @subwindow.activate
      @subwindow.select(0)
    else
      @subwindow = create_input_window(help_text)
      @subwindow.activate
      @subwin_flag = :input
    end
    re = update_subwindow(item) # Infinity loop until input processed
    @subwindow.dispose
    @subwindow   = nil
    @subwin_flag = nil
    return re
  end
  #--------------------------------------------------------------------------
  def create_input_window(help_text)
    cw = 120
    cx = Graphics.center_width(cw)
    cy = Graphics.center_height(48)
    attrs = {
      autoscroll: true,
      limit: 3,
      number: true,
      dim_background: true,
      title: help_text
    }
    return window = Window_Input.new(cx, cy, cw, attrs)
  end
  #--------------------------------------------------------------------------
  def create_select_window
    cw = 240
    ch = 240
    cx = Graphics.center_width(cw)
    cy = Graphics.center_height(ch)
    window = Window_InstanceItemList.new(cx, cy, cw, ch)
    window.set_handler(:ok, method(:on_select_ok))
    window.set_handler(:cancel, method(:on_subwindow_cancel))
    return window
  end
  #--------------------------------------------------------------------------
  def update_subwindow(item)
    re = nil
    loop do
      SceneManager.update_basic
      if @subwin_flag == :input
        @subwindow.update
        re = SceneManager.get_input
        re = re.empty? ? false : [[(re.to_i || 0), 0].max, 100].min if re
        re = :nil if @subwindow.disposed? && !re
      else
        re = @subwindow.update
        if re && item == :has_state
          re = re.id rescue :nil
        end
      end
      break if re
    end
    re = false if re == :nil
    return [re]
  end
  #--------------------------------------------------------------------------
  def on_select_ok
  end
  #--------------------------------------------------------------------------
  def on_subwindow_cancel
  end
  
end
