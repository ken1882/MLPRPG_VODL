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
  def initialize(x = nil, y = nil, width = 300, ln = 5,
                information = "Sure?", overlay_self = false)
    @confirm_status = nil
    @static = false
    super(x, y, width, ln, information, overlay_self)
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
    @map_paused = SceneManager.tactic_enabled?
    SceneManager.start_tactic
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
    if $on_exit
      $on_exit = false
      SceneManager.process_tactic(@map_paused)
    end
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
  def get_text_y(rect, tsize)
    draw_height = contents.height - item_height - 12
    return [(draw_height - line_height * (tsize + 1)) / 2, 0].max
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
