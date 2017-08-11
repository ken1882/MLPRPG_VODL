#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :phase
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_gafo_opt initialize
  def initialize(member_index, preceding_character)
    @phase = DND::BattlerSetting::PhaseIdle
    init_gafo_opt(member_index, preceding_character)
    @through = false
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_dnd update
  def update
    update_dnd
    update_movement
  end
  #--------------------------------------------------------------------------
  # * Combat mode on
  #--------------------------------------------------------------------------
  def process_combat_phase
    
  end
  #---------------------------------------------------------------------------
  def update_movement
    process_pathfinding_movement
  end
  #--------------------------------------------------------------------------
  def hashid
    return actor.hashid if actor
    return PONY.Sha256(self.inspect)
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Game_Enemy
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, *args) if actor.nil?
    actor.method(symbol).call(*args)
  end
  
end
