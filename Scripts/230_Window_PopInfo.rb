#==============================================================================
# ** Window_PopInfo
#------------------------------------------------------------------------------
#  Pop-up information window
#==============================================================================
class Window_PopInfo < Window_Overlay
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :countdown
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, information, exist_time, overlay_self = false)
    @exist_time = exist_time
    @countdown  = exist_time
    super(x, y, information, overlay_self)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @countdown -= 1 if @countdown > 0
    close_overlay(@force_execute) if @countdown <= 0 && @exist_time > 0
  end
  #--------------------------------------------------------------------------
  # * Assign Mehtod to command
  #--------------------------------------------------------------------------
  def assign_handler
    set_handler(:ok, method(:deactivate) )
    set_handler(:cancel, method(:deactivate) )
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    return false
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return true
  end
  #--------------------------------------------------------------------------
  # * Raise ovrelay window
  #--------------------------------------------------------------------------
  def raise_overlay(info = nil, stack_commandname = nil, args = nil, forced = false)
    @countdown = @exist_time
    unselect
    super(info, stack_commandname, args, forced)
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
  end
  
end
