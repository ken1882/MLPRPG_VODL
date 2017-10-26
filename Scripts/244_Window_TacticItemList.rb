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
    if item.is_a?(RPG::UsableItem)
      super
    else
      rect = item_rect(index)
      rect.width -= 4
      name = Vocab::TacticConfig::Name_Table[item]
      name = "<none>" if name.nil?
      icon_id = (PONY::IconID[item] || 0)
      draw_icon(icon_id, rect.x, rect.y) if icon_id > 0
      draw_text(rect.x + 24, rect.y, item_width, line_height, name)
    end
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
        return call_cancel_handler unless result
        if item.is_a?(Symbol)
          @command.condition_symbol = item
          @command.condition = ""
        else
          @command.condition_symbol = :code
          @commadn.condition = item
        end
      when :action
        @command.action.reassign_item(item, false)
      end
      
      puts "#{@command} #{@command.condition_symbol} #{@command.action.item}"
    end
    show_intput_window if subwindow_call
    super
  end
  #--------------------------------------------------------------------------
  def call_subwindow(item)
    help_text = Vocab::TacticConfig::InputHelp[item]
    return true if help_text.nil?
    cw = 480
    cx = Graphics.center_width(cw)
    cy = Graphics.center_height(48)
    attrs = {
      autoscroll: true,
      limit: 3,
      number: true,
      dim_background: true,
      title: help_text
    }
    @subwindow = Window_Input.new(cx, cy, cw, attrs)
    loop do
      Graphics.update
      Input.update
      @subwindow.update
      str = SceneManager.get_input
      break if str
    end
    return str.empty? ? false : [[(str.to_i || 0), 0].max, 100].min
  end
  #--------------------------------------------------------------------------
end
