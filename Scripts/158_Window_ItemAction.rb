#==============================================================================
# ** Window_ItemAction
#------------------------------------------------------------------------------
#  Displaying the actions of an item when selected
#==============================================================================
class Window_ItemAction < Window_Command
  
  attr_accessor :item
  attr_accessor :actor
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 0)
    super
    self.windowskin = Cache.system(WindowSkin::ItemAction)
    @actor  = nil
    @item   = nil
    unselect
    hide
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command('Use', :use_ok)
    add_command('Hotkey', :sel_hotkey)
  end
  #--------------------------------------------------------------------------
  def activate(item = nil, actor = nil)
    @item  = item
    @actor = actor
    super()
    self.opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color, item_usable?)
    draw_text(item_rect_for_text(index), command_name(index), alignment)
  end
  #--------------------------------------------------------------------------
  # * Determine if item is usable
  #--------------------------------------------------------------------------
  def item_usable?
    return false unless @item
    return @actor ? @actor.usable?(@item) : $game_player.usable?(@item)
  end
end
