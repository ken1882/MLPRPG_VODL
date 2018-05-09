#==============================================================================
# ** Window_TacticList
#------------------------------------------------------------------------------
#  This window lists the battler's current tactics
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
  def draw_split_line(rect = nil)
    cx    = self.width / 2
    color = DND::COLOR::White
    if rect
      contents.draw_line(cx, rect.y, cx, rect.y + rect.height, color)
    else
      cy = 8
      fy = self.height - 8
      exy = item_height
      list_num = (self.height / exy)
      extra_num = [item_max - list_num, 0].max
      contents.draw_line(cx, cy, cx, fy + exy * extra_num, color)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      contents.clear_rect(rect)
      draw_split_line(rect)
      
      if !item.valid?
        contents.font.color.set(DND::COLOR::Red)
      elsif item.disabled?
        contents.font.color.set(DND::COLOR::Black)
      else
        contents.font.color.set(DND::COLOR::Green)
      end
      draw_order(index, rect)
      contents.font.color.set(DND::COLOR::White)
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
    return text + Vocab::TacticConfig::Name_Table[:player] if args.first == :player
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
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    super
    return unless open? && active
    process_dragging if Input.trigger?(:kSHIFT)
    toggle_enable    if Input.trigger?(:kCTRL)
  end
  #--------------------------------------------------------------------------
  def toggle_enable
    @data[index].enabled ^= true
    draw_item(index)
    Sound.play_ok
  end
  #--------------------------------------------------------------------------
  def process_dragging
    if @dragging
      call_handler(:on_dragging_cancel) if handle?(:on_dragging_cancel)
      Sound.play_cancel
      @dragging = false
    elsif @data[index].category != :new
      call_handler(:on_dragging_ok) if handle?(:on_dragging_ok)
      Sound.play_ok
      @dragging = true
    else
      Sound.play_buzzer
    end
    heatup_button
  end
  #--------------------------------------------------------------------------
  # * Select Item
  #--------------------------------------------------------------------------
  def select(index)
    last_index = self.index
    new_index  = index
    super(index)
    return unless @dragging && new_index != last_index && new_index >= 0
    return if @data[new_index].category == :new || @data[last_index].category == :new
    @data[new_index], @data[last_index] = @data[last_index], @data[new_index] 
    draw_item(new_index)
    draw_item(last_index)
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    return super unless @dragging
    process_dragging
  end
  #--------------------------------------------------------------------------
  # * Processing When Cancel Button Is Pressed
  #--------------------------------------------------------------------------
  def process_cancel
    return super unless @dragging
    process_dragging
  end
  #--------------------------------------------------------------------------
end
