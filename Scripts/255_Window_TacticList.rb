#==============================================================================
# ** Window_TacticList
#------------------------------------------------------------------------------
#  This window is for selecting New Game/Continue on the title screen.
#==============================================================================
# tag: command (Tactic List
class Window_TacticList < Window_Selectable
  include Vocab::TacticConfig
  #--------------------------------------------------------------------------
  attr_accessor :data
  attr_reader   :actor
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width - x, window_height - y)
    @actor = nil
    @data  = []
  end
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width
  end
  #--------------------------------------------------------------------------
  def window_height
    return Graphics.height
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_split_line
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  def actor=(_actor)
    @actor = _actor
    @data  = @actor.tactic_commands.dup
    refresh
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    return if @actor.nil?
    @data = @actor.tactic_commands.dup
    push_add_command if @data.size < @actor.command_limit
  end
  #--------------------------------------------------------------------------
  def push_add_command
    command_add = Game_TacticCommand.new(@actor)
    command_add.action = Game_Action.new(@actor, nil, :add_command)
    command_add.category = :new
    @data << command_add
  end
  #--------------------------------------------------------------------------
  def draw_split_line
    cx = self.width / 2
    cy = 8
    fy = self.height - 8
    color = DND::COLOR::White
    exy = item_height
    list_num = (self.height / exy)
    extra_num = [item_max - list_num, 0].max
    contents.draw_line(cx, cy, cx, fy + exy * extra_num, color)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      draw_order(index, rect)
      rect.width /= 2
      rect.width -= 4
      draw_command(item, rect)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(0)
  end
  #--------------------------------------------------------------------------
  def draw_order(index, rect)
    return if index >= @actor.tactic_commands.size
    text = sprintf("[%02d]", index)
    rect.width = 32
    draw_text(rect, text)
    rect.x = 32
    rect.width = item_width
  end
  #--------------------------------------------------------------------------
  # * Draw command
  #--------------------------------------------------------------------------
  def draw_command(command, rect)
    cx = rect.x
    cy = rect.y
    case command.category
    when :targeting
      contents.font.color.set(DND::COLOR::Orange)
      draw_condition(:targeting, rect, command)
      rect.x = self.width / 2 + 4
      draw_action_item(rect, command.action)
    when :fighting
      draw_condition(:fighting, rect, command)
      rect.x = self.width / 2 + 4
      draw_action_item(rect, command.action)
    when :self
      contents.font.color.set(DND::COLOR::Green)
      draw_condition(:self, rect, command)
      rect.x = self.width / 2 + 4
      draw_action_item(rect, command.action)
    when :new
      draw_icon(PONY::IconID[:plus], cx, cy)
      rect.x += 26
      contents.font.color.set(DND::COLOR::Yellow)
      name = Name_Table[:new_command]
      draw_text(rect, name)
      draw_action_item(rect, command.action)
    end
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  def draw_condition(symbol, rect, command)
    icon_id = 0
    if command.condition_symbol == :has_state && command.args.first.to_bool
      icon_id = $data_states[command.args.first].icon_index
    elsif command.args.first.is_a?(Game_Actor)
      icon_id = command.args.first.icon_index
    else
      icon_id = PONY::IconID[symbol]
    end
    draw_icon(icon_id, rect.x, rect.y)
    rect.x += 26
    name = sprintf("%s %s",Name_Table[symbol], Name_Table[command.condition_symbol])
    name = get_condition_args_name(command.condition_symbol, command.args, name) 
    if name.bytesize > 31
      temp = ""
      bsize = 0
      name.each_char do |ch|
        break if bsize > 30
        bsize += [ch.bytesize, 1.9].min
        temp += ch
      end
      name = temp + "..." unless temp.bytesize == name.bytesize
    end
    draw_text(rect, name)
  end
  #--------------------------------------------------------------------------
  def get_condition_args_name(symbol, args, text)
    return text + args.first.name if args.first.is_a?(RPG::BaseItem)
    return text if ArgDec_Table[symbol].nil?
    case symbol
    when :has_state
      name = ""
      name = $data_states[args.first].name if args.first.to_bool
      return text + ' ' + sprintf(ArgDec_Table[:has_state], name)
    else
      info = ArgDec_Table[args.first] if args.first.is_a?(Symbol)
      info = Name_Table[args.first]   if info.nil?
      info = args.first               if info.nil?
      return text + ' ' + sprintf(ArgDec_Table[symbol], info)
    end
  end
  #--------------------------------------------------------------------------
  def draw_action_item(rect, action)
    rect.x  = self.width / 2 + 4
    icon_id = action.get_icon_id
    draw_icon(icon_id, rect.x, rect.y) if icon_id > 0
    rect.x += 26
    name    = action.get_item_name
    draw_text(rect, name)
  end
  #--------------------------------------------------------------------------
  def apply_tactic_change
    return if @data.nil?
    @actor.tactic_commands = @data.select{|cmd| cmd.category && cmd.category != :new}
  end
  #--------------------------------------------------------------------------
end
