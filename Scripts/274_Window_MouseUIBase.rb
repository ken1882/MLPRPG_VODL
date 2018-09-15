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
    @groups  = []
    @button_symbol_table = {}
    @group_symbol_table  = {}
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
  #--------------------------------------------------------------------------
  # * Add Command
  #     name    : Command name
  #     symbol  : Corresponding symbol
  #     image   : Path to the image
  #     enabled : Activation state flag
  #     ext     : Arbitrary extended data
  #     help    : Text displayed in tab-help window
  #--------------------------------------------------------------------------
  #def add_command(name, symbol, image, enabled = true, ext = nil, help = nil)
  def add_command(*args)
    case args.size
    when 1 # Hash initializer
      args = args[0]
      content = {
        :name     => args[:name],
        :symbol   => args[:symbol],
        :enabled  => args[:enabled].nil? ? true : args[:enabled],
        :ext      => args[:ext],
        :help     => args[:help],
        :image    => args[:image],
      }
    else
      name    = args[0]; symbol = args[1]; 
      image   = args[2];
      enabled = args[3].nil? ? true  : args[3];
      ext     = args[4]
      help    = args[5]
      content = {:name=>name, :symbol=>symbol, :enabled => enabled,
                 :ext=>ext, :help => help, :image => image}
      #----
    end
                      
    if !content[:symbol] || !content[:name] || !content[:image]
      errinfo = "Invalid parameter given:\nName: %s\nSymbol: %s\nImage: %s\n"
      errinfo = sprintf(errinfo, content[:name], content[:symbol], content[:image])
      raise ArgumentError, errinfo
    end
    
    @list.push(content)
  end
  #-----------------------------------------------------------------------------
end
