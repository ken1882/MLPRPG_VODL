#==============================================================================
# ** Window_LevelUpCommands
#------------------------------------------------------------------------------
#  This window is for selecting category of level up command or skill tree
#==============================================================================
class Window_LevelUpCommands < Window_MultiCommand
  include Vocab::Leveling
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  attr_reader   :actor
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, _actor)
    @actor = _actor
    super(x, y)
  end
  #--------------------------------------------------------------------------
  def actor=(_actor)
    @actor = _actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    160
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
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
    add_command(name: Vocab::LevelUp, symbol: :levelup, 
                enabled: levelup_enabled?, help: Helps[:level_up])
                
    add_command(name: Vocab::Skilltree, symbol: :skilltree, child: :skilltree,
                help: Helps[:skilltree])
                
    make_skilltree_list if @actor
  end
  #--------------------------------------------------------------------------
  def make_skilltree_list
    cat = :skilltree
    names = [@actor.name, @actor.race.name, @actor.class.name]
    syms  = [:unique, :race, :class]
    helps = [Helps[:unique], Helps[:race], Helps[:class]]
    if @actor.dualclass_id > 0
      names.push(@actor.dualclass.name)
      syms.push(:dualclass)
      helps.push(Helps[:dualclass])
    end
    
    names.size.times do |i|
      add_command(name: names[i], symbol: syms[i], help: helps[i], category: cat)
    end
    
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
  #--------------------------------------------------------------------------
end
