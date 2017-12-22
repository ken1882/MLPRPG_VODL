#==============================================================================
# ** Window_LevelUpCommands
#------------------------------------------------------------------------------
#  This window is for selecting category of level up command or skill tree
#==============================================================================
class Window_LevelUpCommands < Window_Command
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  attr_reader   :actor
  attr_reader   :list_sec
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor)
    @actor    = actor
    super(0, 0)
    @old_cancel_handler = nil
    @sec_cancel_handler = nil
    set_initial_handlers
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 4
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @item_window.category = current_symbol if @item_window
  end
  #--------------------------------------------------------------------------
  def clear_command_list
    super
    @list_sec = []
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::LevelUp,     :levelup, levelup_enabled?)
    add_command(Vocab::Skilltree,   :skilltree)
    make_second_command_list
  end
  #--------------------------------------------------------------------------
  def add_command_sec(name, symbol, enabled = true, ext = nil)
    @list_sec.push({:name=>name, :symbol=>symbol, :enabled=>enabled, :ext=>ext})
  end
  #--------------------------------------------------------------------------
  def make_second_command_list
    add_command_sec(@actor.name,            :special)
    add_command_sec(@actor.race.name,       :race)
    add_command_sec(@actor.class.name,      :class)
    add_command_sec(@actor.dualclass.name,  :dualclass) if @actor.dualclass_id > 0
    @sec_cancel_handler = method(:swap_list)
  end
  #--------------------------------------------------------------------------
  def set_initial_handlers
    set_handler(:skilltee, method(:list_skilltree_category))
  end
  #--------------------------------------------------------------------------
  def swap_list
    swap(@list, @list_sec)
    swap(@handler[:cancel], @sec_cancel_handler) if @sec_cancel_handler
  end
  #--------------------------------------------------------------------------
  # * Set Item Window
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
  #--------------------------------------------------------------------------
  def levelup_enabled?
    return false if !@actor
    return @actor.upgradeable?
  end
end
