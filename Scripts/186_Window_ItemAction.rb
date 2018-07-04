#==============================================================================
# ** Window_ItemAction
#------------------------------------------------------------------------------
#  Displaying the actions of an item when selected
#==============================================================================
class Window_ItemAction < Window_Command
  #--------------------------------------------------------------------------
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
    add_command(Vocab::Skillbar::Use, :use_ok, item_usable?)
    add_command(Vocab::Skillbar::Hotkey, :sel_hotkey, item_targetable?)
    add_command(Vocab::MoreInfo, :moreinfo, item_data_included?)
  end
  #--------------------------------------------------------------------------
  def activate(item = @item, actor = @actor)
    @item  = item
    @actor = actor
    super()
    self.opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # * Determine if item is usable
  #--------------------------------------------------------------------------
  def item_usable?
    return false unless @item
    return @actor ? @actor.usable?(@item) : $game_player.usable?(@item)
  end
  #--------------------------------------------------------------------------
  def item_targetable?
    return false unless @item
    return @item.scope != 0
  end
  #--------------------------------------------------------------------------
  def item_data_included?
    return false unless @item
    return true if @item.is_a?(RPG::Item)
    return true if @item.is_a?(RPG::Weapon)
    return true if @item.is_a?(RPG::Armor)
    return false
  end
  #--------------------------------------------------------------------------
end
