#==============================================================================
# ** Window_MouseUIBase
#------------------------------------------------------------------------------
#  A totally mouse-oriented UI
#==============================================================================
class Window_MouseUIBase < Window_Base
  #--------------------------------------------------------------------------
  attr_reader :buttons
  attr_reader :currnent_index, :current_group
  attr_reader :index
  attr_reader :groups
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @index_changed = false
    @buttons = []
    @groups  = {}
    @button_symbol_table = {}
    @mouse_hovered = Mouse.collide_sprite?(self)
    unselect
  end
  #-----------------------------------------------------------------------------
  # * Functions that not used
  #-----------------------------------------------------------------------------
  def update_tone; end
  #-----------------------------------------------------------------------------
  def unselect
    select(-1)
  end
  #-----------------------------------------------------------------------------
  def select(sig)
    return select_index(sig)  if sig.is_a?(Numeric)
    return select_symbol(sig) if sig.is_a?(Symbol)
  end
  #-----------------------------------------------------------------------------
  def select_index(_index)
    return if _index == @index
    @index = _index
    @index_changed = true
  end
  #-----------------------------------------------------------------------------
  def select_symbol(sym)
    
  end
  #-----------------------------------------------------------------------------
  def index_changed?
    @index_changed
  end
  #-----------------------------------------------------------------------------
  def update
    @index_changed = false
    super
    return unless visible?
    update_buttons
    update_mouse
    update_keyboard if active?
  end
  #------------------------------------------------------------------------------
  def update_buttons
    @buttons.each_with_index do |but, i|
      next unless but.active? && but.sprite_valid?(but.sprite)
      if Mouse.collide_sprite?(but.sprite) || @index == i 
        @index = i
        but.focus_sprite
        process_trigger(but) if button_cooled? && Input.trigger?(:C)
      else
        but.unfocusite_sprite
      end
    end
  end
  #-----------------------------------------------------------------------------
  def update_mouse
    update_mouse_dragging
  end
  #-----------------------------------------------------------------------------
  def update_mouse_dragging
  end
  #-----------------------------------------------------------------------------
  def update_keyboard
    update_navigate
  end
  #-----------------------------------------------------------------------------
  def update_navigate
    # last work
  end
  #-----------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #-----------------------------------------------------------------------------
  def item_max
    @buttons.size
  end
  #-----------------------------------------------------------------------------
  def draw_all_items
    item_max.times do |i|
      draw_item(i)
    end
  end
  #-----------------------------------------------------------------------------
  def draw_item(i)
    @buttons[i].refresh
  end
  #-----------------------------------------------------------------------------
  def process_trigger(button)
    return if button.handler.nil?
    heatup_button
    button.handler.call(get_button_args(button))
  end
  #-----------------------------------------------------------------------------
  def add_button(*args)
    button = Game_InteractiveButton.new(args)
    button.create_sprite
    @button_symbol_table[button.symbol] = @buttons.size
    add_group(button) if button.group
    @buttons.push(button)
  end
  #-----------------------------------------------------------------------------
  def add_group(button)
    (@groups[button.group] ||= []) << button
    @groups[button.group].sort_by!{|but| but.x + but.y}
  end
  #-----------------------------------------------------------------------------
  def dispose
    dispose_all_buttons
    super
  end
  #-----------------------------------------------------------------------------
  def dispose_all_buttons
    @buttons.each do |but| but.dispose end
  end
  #-----------------------------------------------------------------------------
  def get_button_args(button)
  end
  #-----------------------------------------------------------------------------
end
