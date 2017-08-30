#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  A character class with mainly movement route and other such processing
# added. It is used as a super class of Game_Player, Game_Follower,
# GameVehicle, and Game_Event.
#==============================================================================
# tag: AI
class Game_Character < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :combat_timer
  attr_accessor :tactic_commands
  attr_accessor :visible
  attr_reader   :semi_visible
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_combatdnd init_public_members
  def init_public_members
    @combat_timer    = rand(20)
    @tactic_commands = []
    @visible         = true
    @semi_visible    = false
    init_public_combatdnd
  end
  #----------------------------------------------------------------------------
  # *) Frame update
  #----------------------------------------------------------------------------
  alias update_gachdndai update
  def update
    @combat_timer -= 1 if @combat_timer > 0
    update_combat if @current_target && @combat_timer > 0
    update_gachdndai
  end
  #----------------------------------------------------------------------------
  def target_rate(target, modifier = 0)
    sum  = 100
    sum  = apply_tactic_target(sum, target)
    sum *= tgr
    return sum.to_i + modifier
  end
  #----------------------------------------------------------------------------
  def set_target(target)
    @current_target = target
  end
  #----------------------------------------------------------------------------
  def update_combat
    @combat_timer = 20
    chase_target
    return process_tactic_commands unless @tactic_commands.empty?
    determine_skill_usage
    determine_item_usage
  end # last work: AI combat (it finally comes
  #----------------------------------------------------------------------------
  def chase_target    
  end
  #----------------------------------------------------------------------------
  def determine_skill_usage
  end
  #----------------------------------------------------------------------------
  def determine_item_usage
  end
  #----------------------------------------------------------------------------
  def process_tactic_commands
  end
  #----------------------------------------------------------------------------
  def tactic_retreat
  end
  #----------------------------------------------------------------------------
  def visible?
    return @visible
  end
  #----------------------------------------------------------------------------
  def change_visibility(status = !@visible)
    @visible = status
    @semi_visible = status if BattleManager.is_friend?(self, $game_player)
  end # last work: translucent sprite
  #----------------------------------------------------------------------------
  # * Increase the target rate if target is meet to current tactic target
  #----------------------------------------------------------------------------
  def apply_tactic_target(value, target)
    return value
  end
  #----------------------------------------------------------------------------
end
