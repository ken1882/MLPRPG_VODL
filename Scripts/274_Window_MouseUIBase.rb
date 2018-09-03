#==============================================================================
# ** Window_MouseUIBase
#------------------------------------------------------------------------------
#  A totally mouse-oriented UI
#==============================================================================
class Window_MouseUIBase < Window_Base
  #--------------------------------------------------------------------------
  attr_reader :buttons
  attr_reader :currnent_index
  attr_reader :index
  attr_reader :groups
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @index_changed = false
    @buttons = []
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
  def select(_index)
    return if _index == @index
    @index = _index
    @index_changed = true
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
    update_mouse
    update_keyboard if active?
  end
  #-----------------------------------------------------------------------------
  def update_mouse
    update_mouse_selection
    update_mouse_activation
    update_mouse_dragging
  end
  #-----------------------------------------------------------------------------
  def update_mouse_activation
    
  end
  #-----------------------------------------------------------------------------
  def update_mouse_selection
    
  end
  #-----------------------------------------------------------------------------
  def update_keyboard
    update_navigate
  end
  #-----------------------------------------------------------------------------
  def update_navigate
    
  end
  #-----------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #-----------------------------------------------------------------------------
  def draw_all_items
    item_max.times do |i|
      draw_item(i)
    end
  end
  #-----------------------------------------------------------------------------
  def draw_item(inx)
    @buttons[i]
  end
  #-----------------------------------------------------------------------------
  def add_button(*args)
    @buttons.push(Game_InteractiveButton.new(args))
  end
  #-----------------------------------------------------------------------------
  def add_command(*args)
    if args.size == 1
      but = Game_InteractiveButton.new()
    else
    end
  end # last work here
  #-----------------------------------------------------------------------------
end
