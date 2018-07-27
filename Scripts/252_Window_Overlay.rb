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
  def initialize(x, y, width, line_number, information, overlay_self)
    @info = information
    @force_execute = false
    @width = width ? width : 300
    line_number = line_number ? line_number : 5
    @height = fitting_height(line_number)
    x = Graphics.center_width(window_width) unless x
    y = Graphics.center_height(window_height) unless y
    super(x, y)
    self.windowskin = Cache.system(WindowSkin::Pinkie) if WindowSkin::Enable
    assign_handler
    self.opacity = 255
    self.z = PONY::SpriteDepth::Table[:overlays]
    refresh
    self_overlay if overlay_self
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return @width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    return @height
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
    SceneManager.show_dim_background
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
    SceneManager.hide_dim_background
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
    @last_window = nil
  end
  #--------------------------------------------------------------------------
  # * Assign last window if self overlay
  #--------------------------------------------------------------------------
  def assign_last_window(window)
    puts "Last window: #{window}"
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
  def get_text_y(rect, tsize)
    return [rect.y - line_height * (tsize + 1) - (line_height / 4).to_i, 0].max
  end
  #--------------------------------------------------------------------------
  # * Modified Texts
  #--------------------------------------------------------------------------
  def draw_modified_text(rect)
    line_width = contents.width
    texts   = FileManager.textwrap(@info, line_width - 4, contents)    
    cy = get_text_y(rect, texts.size)
    draw_text_lines(texts, 4, cy, line_width)
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
