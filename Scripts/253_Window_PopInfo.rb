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
  def initialize(x = nil, y = nil, width = 300, ln = 5, information = '', 
                  exist_time = sec_to_frame(5), overlay_self = false)
    @exist_time = exist_time
    @countdown  = exist_time
    super(x, y, width, ln, information, overlay_self)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    unselect
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
  def raise_overlay(*args)
    @countdown = @exist_time
    
    if args.size == 1 && args[0].is_a?(Hash)# hash initializer
      args = args[0]
      info = args[:info]; stack_commandname = args[:method];
      call_args = args[:args]; forced = (args[:forced] || false);
      @countdown = args[:time]
    else
      info = args[0]
      stack_commandname = args[1]
      call_args = args[2]
      forced = (args[3] || false)
    end
    
    unselect
    SceneManager.process_tactic(true) unless SceneManager.tactic_enabled?
    super(info, stack_commandname, call_args, forced)
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
  end
  #--------------------------------------------------------------------------
  def index
    return -1
  end
  #--------------------------------------------------------------------------
  def select_cursor_needed?
    return false
  end
  #--------------------------------------------------------------------------
end
