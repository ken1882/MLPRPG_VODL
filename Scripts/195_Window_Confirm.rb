#==============================================================================
# ** Window_Confirm
#------------------------------------------------------------------------------
#  Overlayed on Selectable to confirm actions
#==============================================================================
class Window_Confirm < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor   :info
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, information = "Sure?")
    @info = information
    super(x, y)
    self.windowskin = Cache.system($CHAR4_SKIN)
    assign_handler
    self.opacity = 255
    self.z = 1000
    refresh
    select(0)
    
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 300
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(5)
  end
  #--------------------------------------------------------------------------
  # * Item alignment the center
  #--------------------------------------------------------------------------
  def centralize?
    true
  end
  #--------------------------------------------------------------------------
  # * Deactivate self when overlayed
  #--------------------------------------------------------------------------
  def overlay_deactivate
    false
  end
  #--------------------------------------------------------------------------
  # * Self already a overlay window class
  #--------------------------------------------------------------------------
  def self_overlay
    @overlay_window = self
    @self_overlay = true
  end
  #--------------------------------------------------------------------------
  # * Activate Window
  #--------------------------------------------------------------------------
  def activate
    self.show
    self.opacity = 255
    select(0)
    super
  end
  #--------------------------------------------------------------------------
  # * Deactivate Window
  #--------------------------------------------------------------------------
  def deactivate
    self.hide
    super
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    active && open?
  end
  #--------------------------------------------------------------------------
  # * Deactivate overlay window
  #--------------------------------------------------------------------------
  alias close_overlay_pony close_overlay
  def close_overlay(continue = false)
    close_overlay_pony(continue)
    self.deactivate if self_overlay?
    $on_exit = false if $on_exit
    reactivate_last_window
  end
  #--------------------------------------------------------------------------
  # * Reactivate last window before overlay
  #--------------------------------------------------------------------------
  def reactivate_last_window
    return if @last_window.nil?
    @last_window.activate if @last_window.is_a?(Window_Selectable)
  end
  #--------------------------------------------------------------------------
  # * Assign last window if self overlay
  #--------------------------------------------------------------------------
  def assign_last_window(window)
    @last_window = window
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh(index = 0)
    contents.clear
    draw_split_line
    draw_info_text
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
  # * Alias: Item align center
  #--------------------------------------------------------------------------
  alias cent_item_rect_con central_item_rect
  def central_item_rect(index)
    rect = cent_item_rect_con(index)
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
    contents.draw_line(x1,y,x2,y, GTBS::WHITE.color)
  end
  #--------------------------------------------------------------------------
  # * Draw Extra Information
  #--------------------------------------------------------------------------
  def draw_info_text
    rect = item_rect_for_text(0)
    draw_modified_text(rect)
  end
  #--------------------------------------------------------------------------
  # * Modify rectangle
  #--------------------------------------------------------------------------
  def draw_modified_text(rect)
    line_width = contents.width
    texts   = FileManager.textwrap(@info, line_width)
    cy = [rect.y - line_height * (texts.size + 1), 0].max
    
    texts.each do |line|
      draw_text(0, cy, line_width, line_height, line, alignment)
      cy += line_height
    end
    
  end
  #--------------------------------------------------------------------------
  # * Return action flag
  #--------------------------------------------------------------------------
  def continue_action; return true;  end
  def block_action;    return false; end
  
end
