#==============================================================================
# ** Window_Overlay
#------------------------------------------------------------------------------
#   Super class of overlay windows, which will display above the scene, this
#  class has the first priority of all actions.
#==============================================================================
class Window_Overlay < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :info
  attr_accessor :force_execute # force execute command procedure
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, information, overlay_self = false)
    @info = information
    @force_execute = false
    super(x, y)
    self.windowskin = Cache.system(WindowSkin::Pinkie) if WindowSkin::Enable
    assign_handler
    self.opacity = 255
    self.z = 1000
    refresh
    self_overlay if overlay_self
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
  # * Activate Window
  #--------------------------------------------------------------------------
  def activate
    self.show
    refresh
    super
  end
  #--------------------------------------------------------------------------
  # * Deactivate self when overlayed
  #--------------------------------------------------------------------------
  def overlay_deactivate?
    false
  end
  #--------------------------------------------------------------------------
  # * Deactivate Window
  #--------------------------------------------------------------------------
  def deactivate
    self.hide
    @overlayed = false if @self_overlay
    process_terminate
    super
  end
  #--------------------------------------------------------------------------
  # * Raise ovrelay window
  #--------------------------------------------------------------------------
  def raise_overlay(info = nil, stack_commandname = nil, args = nil, forced = false)
    @force_execute = forced
    super(info, stack_commandname, args)
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_info_text
  end  
  #--------------------------------------------------------------------------
  # * Terminate window
  #--------------------------------------------------------------------------
  def process_terminate
    reactivate_last_window
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
  end
  #--------------------------------------------------------------------------
  # * Assign Mehtod to command
  #--------------------------------------------------------------------------
  def assign_handler
  end
  #--------------------------------------------------------------------------
  # * Deactivate overlay window
  #--------------------------------------------------------------------------
  def close_overlay(continue = false)
    super(continue)
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
  # * Draw Extra Information
  #--------------------------------------------------------------------------
  def draw_info_text
    rect = item_rect_for_text(0)
    draw_modified_text(rect)
  end
  #--------------------------------------------------------------------------
  # * Modified Texts
  #--------------------------------------------------------------------------
  def draw_modified_text(rect)
    line_width = contents.width
    texts   = FileManager.textwrap(@info, line_width)
    cy = [rect.y - line_height * (texts.size + 1), 0].max
    draw_text_lines(texts, 0, cy, line_width)
  end
  #--------------------------------------------------------------------------
  # * Draw array of text lines
  #--------------------------------------------------------------------------
  def draw_text_lines(texts, cx, cy, line_width)
    texts.each do |line|
      draw_text(cx, cy, line_width, line_height, line, alignment)
      cy += line_height
    end
  end
  #------------------
end
