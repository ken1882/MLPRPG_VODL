#==============================================================================
# ** Window_TacticList
#------------------------------------------------------------------------------
#  This window is for selecting New Game/Continue on the title screen.
#==============================================================================
# tag: command (Tactic List
class Window_TacticList < Window_Selectable
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
  # * Draw command
  #--------------------------------------------------------------------------
  def draw_command(command, rect)
    cx = rect.x
    cy = rect.y
    case command.category
    when :targeting
      draw_icon(PONY::IconID[:aim], cx, cy)
      rect.x += 26
      contents.font.color.set(DND::COLOR::Orange)
      name = "Enemies: " + Tactic_Config::Name_Table[command.condition_symbol]
      draw_text(rect, name)
      rect.x = self.width / 2 + 4
      action = "> Set to current target"
      draw_text(rect, action)
      change_color(normal_color)
    when :fighting
      draw_icon(PONY::IconID[:fighting], cx, cy)
      rect.x += 26
      name = "Target: " + Tactic_Config::Name_Table[command.condition_symbol]
      draw_text(rect, name)
      rect.x = self.width / 2 + 4
      action = command.action.get_item_name
      draw_text(rect, action)
    when :self
      draw_icon(PONY::IconID[:self], cx, cy)
      rect.x += 26
      contents.font.color.set(DND::COLOR::Green)
      name = "Self: " + Tactic_Config::Name_Table[command.condition_symbol]
      draw_text(rect, name)
      rect.x = self.width / 2 + 4
      action = command.action.get_item_name
      draw_text(rect, action)
      change_color(normal_color)
    when :new
      draw_icon(PONY::IconID[:plus], cx, cy)
      rect.x += 26
      contents.font.color.set(DND::COLOR::Yellow)
      name = "<Add New Tactic>"
      draw_text(rect, name)
      rect.x = self.width / 2 + 4
      action = command.action.get_item_name
      draw_text(rect, action)
      change_color(normal_color)
    end
  end
  #--------------------------------------------------------------------------
  def apply_tactic_change
    return if @data.nil?
    puts "Apply tactic change"
    @data.each {|cmd| puts "#{cmd} #{cmd.condition_symbol} #{cmd.action.item}"}
    @actor.tactic_commands = @data.select{|cmd| cmd.category && cmd.category != :new}
    puts "After:"
    @actor.tactic_commands.each {|cmd| puts "#{cmd} #{cmd.condition_symbol} #{cmd.action.item}"}
  end
  #--------------------------------------------------------------------------
end
