#==============================================================================
# ** Window_Confirm
#------------------------------------------------------------------------------
#  Overlayed on Selectable to confirm actions
#==============================================================================
class Window_Confirm < Window_Overlay
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor   :info
  attr_accessor   :confirm_status
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, information = "Sure?", overlay_self = false)
    @confirm_status = nil
    @static = false
    super(x, y, information, overlay_self)
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    active && open?
  end
  #--------------------------------------------------------------------------
  # * Activate Window
  #--------------------------------------------------------------------------
  def activate
    super
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Deactivate Window
  #--------------------------------------------------------------------------
  def deactivate
    @confirm_status = nil
    super
  end
  #--------------------------------------------------------------------------
  # * Call Handler
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    @confirm_status = super(symbol)
  end
  #--------------------------------------------------------------------------
  # * Deactivate overlay window
  #--------------------------------------------------------------------------
  def close_overlay(continue = false)
    super(continue)
    $on_exit = false if $on_exit
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_split_line
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command("Yes", :continue)
    add_command("NO" , :block)
  end
  #--------------------------------------------------------------------------
  # * Assign Mehtod to command
  #--------------------------------------------------------------------------
  def assign_handler
    set_handler(:continue, method(:continue_action) )
    set_handler(:block,    method(:block_action) )
    set_handler(:cancel,   method(:block_action) )
  end
  #--------------------------------------------------------------------------
  # * Item align center
  #--------------------------------------------------------------------------
  def central_item_rect(index)
    rect = super(index)
    rect.y = contents_height - item_height - 12
    rect
  end
  #--------------------------------------------------------------------------
  # * Item rect for choice (Yes/No)
  #--------------------------------------------------------------------------
  def choice_item_rect(index)
    rect = central_item_rect(index)
    rect.y = contents_height - item_height - 12
    rect
  end
  #--------------------------------------------------------------------------
  # * Draw Split Line
  #--------------------------------------------------------------------------
  def draw_split_line
    x1 = 24
    y  = contents_height - item_height - 24
    x2 = contents_width - 24
    contents.draw_line(x1,y,x2,y, DND::COLOR::White)
  end
  #--------------------------------------------------------------------------
  # * Return action flag
  #--------------------------------------------------------------------------
  def continue_action; return true;  end
  def block_action;    return false; end
  
end
