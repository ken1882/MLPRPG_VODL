#===============================================================================
# * Game_TacticCursor
#-------------------------------------------------------------------------------
#   Projectiles in the game, game cannot be saved if any projectile exist
#===============================================================================
class Game_TacticCursor < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    @sprite = Sprite_TacticCursor.new(self)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_movement
  end
  #--------------------------------------------------------------------------
  # * Update movement
  #--------------------------------------------------------------------------
  def update_movement
    # last work
  end
  #--------------------------------------------------------------------------
  # * Check if cursor go beyond the sight
  #--------------------------------------------------------------------------
  def over_bound?(x, y)
    
  end
end
