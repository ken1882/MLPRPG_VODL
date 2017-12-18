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
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor)
    @actor = actor
    super(0, 0)
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
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::LevelUp,     :levelup, levelup_enabled?)
    add_command(Vocab::Skilltree,   :skilltree)
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
