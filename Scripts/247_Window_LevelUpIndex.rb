#==============================================================================
# ** Window_LevelUpIndex
#------------------------------------------------------------------------------
#  Index item for level up feats selection or skill tree index
#==============================================================================
# tag: level up

class Window_LevelUpIndex < Window_Selectable
  #--------------------------------------------------------------------------
  attr_reader :actor
  attr_reader :category
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, _actor)
    super(x, y, width, height)
    actor = _actor
  end
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # * Set Category
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
end
