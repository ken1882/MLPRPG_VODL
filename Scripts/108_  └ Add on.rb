#==============================================================================
# ** Window_Selectable
#------------------------------------------------------------------------------
#  This window class contains cursor movement and scroll functions.
#==============================================================================
class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :overlayed
  attr_accessor :button_cooldown
  #--------------------------------------------------------------------------
  # * Object Initialization
  #-------------------------------------------------------------------------
  alias initialize_overlay initialize
  def initialize(x, y, width, height)
    @overlayed    = false
    @self_overlay = false
    @button_cooldown = 0
    @overlay_window  = nil
    @stacked_command = nil
    @stacked_args    = nil
    initialize_overlay(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_overlayed update
  def update
    @button_cooldown -= 1    if @button_cooldown > 0
    process_overlay_handling unless @button_cooldown > 0
    
    if @overlayed
      self_overlay? ? update_overlay(update_overlayed) : update_overlay
    else
      update_overlayed
    end
  end
  #--------------------------------------------------------------------------
  # * Item alignment the center
  #--------------------------------------------------------------------------
  def centralize?
    false
  end
  #--------------------------------------------------------------------------
  # * Deactivate self when overlayed
  #--------------------------------------------------------------------------
  def overlay_deactivate?
    true
  end
  #--------------------------------------------------------------------------
  # * Check if self overlayed
  #--------------------------------------------------------------------------
  def self_overlay?
    @self_overlay
  end
  
  #--------------------------------------------------------------------------
  # * Raise ovrelay window
  #--------------------------------------------------------------------------
  def raise_overlay(stack_commandname = nil, args = nil)
    @stacked_command = self.method(stack_commandname) rescue nil
    @stacked_args    = args.is_a?(Array) ? args : [args]
    self.deactivate unless self_overlay?
    @overlay_window.activate
    @overlayed = true
  end
  #--------------------------------------------------------------------------
  # * Deactivate overlay window
  #--------------------------------------------------------------------------
  def close_overlay(continue = false)
    @overlay_window.deactivate
    self.activate   unless self_overlay?
    self.deactivate if self_overlay?
    call_stacked_command if continue
    @stacked_command, @stacked_args = nil, nil
    @overlayed = false
  end
  #--------------------------------------------------------------------------
  # * Call stacked method
  #--------------------------------------------------------------------------
  def call_stacked_command
    return if @stacked_command.nil?
    arg_number = [@stacked_command.parameters.size, @stacked_args.compact.size].min
    args = @stacked_args
    case arg_number
    when 0; @stacked_command.call;
    when 1; @stacked_command.call(args[0]);
    when 2; @stacked_command.call(args[0],args[1]);
    when 3; @stacked_command.call(args[0],args[1],args[2]);
    when 4; @stacked_command.call(args[0],args[1],args[2],args[3]);
    when 5; @stacked_command.call(args[0],args[1],args[2],args[3],args[4]);
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update overlay window
  #--------------------------------------------------------------------------
  def update_overlay(continue = nil)
    return nil if @overlay_window.nil?
    continue = @overlay_window.update unless self_overlay?
    close_overlay(continue) unless continue.nil?
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
    elsif item_max > 1 && col_max >= 2
      select(0)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if col_max >= 2 && (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
     elsif col_max >= 2
      select(item_max - 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Alias: Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  alias overlay_cursor_movable? cursor_movable?
  def cursor_movable?
    return false if (@overlayed && !self_overlay?)
    overlay_cursor_movable?
  end
  #--------------------------------------------------------------------------
  # * Self already a overlay window class
  #--------------------------------------------------------------------------
  def self_overlay
    @overlay_window = self
    @self_overlay   = true
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return if (@overlayed && !self_overlay?)
    return if @button_cooldown > 0
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
    return process_pagedown if handle?(:pagedown) && Input.trigger?(:R)
    return process_pageup   if handle?(:pageup)   && Input.trigger?(:L)
  end
  #--------------------------------------------------------------------------
  # * Process overlay window handling
  #--------------------------------------------------------------------------
  def process_overlay_handling
  end
end
