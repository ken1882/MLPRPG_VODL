#==============================================================================
# ** Window_ItemAction
#------------------------------------------------------------------------------
#  Displaying the actions of an item when selected
#==============================================================================
class Window_ItemAction < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super
    @actor  = nil
    @item   = nil
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command('Use', :use, item_usable?)
    add_command('Hotkey', :add_hotkey, item_assignable?)
  end
  #--------------------------------------------------------------------------
  # * Assign item and actor
  #--------------------------------------------------------------------------
  def assign(item, actor = nil)
    @item  = item
    @actor = actor
  end
  #--------------------------------------------------------------------------
  def item_max
    return @choice.size
  end
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color, item_usable?)
    draw_text(item_rect_for_text(index), @choice[index])
  end
  #--------------------------------------------------------------------------
  # * Determine if item is usable
  #--------------------------------------------------------------------------
  def item_usable?(item)
    return false unless item
    # tag: last work
    #return false if 
  end
  #--------------------------------------------------------------------------
  # * Determine if item can be assigned to skillbar
  #--------------------------------------------------------------------------
  def item_assignable?
  end
  
end
