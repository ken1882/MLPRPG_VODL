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
  # * Overwrite: Frame Update
  #--------------------------------------------------------------------------
  def update
    # opacity sync to $game_player is removed
    @move_speed     = $game_player.real_move_speed
    @transparent    = $game_player.transparent
    @walk_anime     = $game_player.walk_anime
    @step_anime     = $game_player.step_anime
    @direction_fix  = $game_player.direction_fix
    @blend_type     = $game_player.blend_type
    update_movement
    super
  end
  #--------------------------------------------------------------------------
  # * Combat mode on
  #--------------------------------------------------------------------------
  def process_combat_phase
    
  end
  #--------------------------------------------------------------------------
  # * Combat mode off
  #--------------------------------------------------------------------------
  def retreat_combat
    
  end
  #---------------------------------------------------------------------------
  def update_movement
    process_pathfinding_movement
  end
  #--------------------------------------------------------------------------
  def body_size
    return 1 * @zoom_x
  end
  #--------------------------------------------------------------------------
  def hashid
    return actor.hashid if actor
    return PONY.Sha256(self.inspect)
  end
  #--------------------------------------------------------------------------
  def primary_weapon
    return actor.equips[0]
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Determine Visibility
  #--------------------------------------------------------------------------
  def visible?
    super && actor && $game_player.followers.visible
  end
  #----------------------------------------------------------------------------
  # * Die when hitpoint drop to zero
  #----------------------------------------------------------------------------
  def kill
    process_actor_death
    super
  end
  #--------------------------------------------------------------------------
  # * Determine if Movement is Possible
  #--------------------------------------------------------------------------
  def movable?
    return false if actor && !actor.movable?
    return super
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
