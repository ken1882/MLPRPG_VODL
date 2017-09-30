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
  attr_accessor :combat_timer       # lazy update timer
  attr_accessor :tactic_commands    # tactic commadns, unfinished
  attr_accessor :visible
  attr_reader   :translucent
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_combatdnd init_public_members
  def init_public_members
    @combat_timer    = rand(20)
    @tactic_commands = []
    @visible         = true
    @translucent     = false
    init_public_combatdnd
  end
  #----------------------------------------------------------------------------
  # *) Frame update
  #----------------------------------------------------------------------------
  alias update_gachdndai update
  def update
    if !dead?
      @combat_timer -= 1 if @combat_timer > 0
      chase_target  if @current_target && !frozen?
      update_combat if @current_target && @combat_timer == 0
    end
    
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
    BattleManager.detect_combat
    return if self.is_a?(Game_Player)
    @current_target = target
  end
  #----------------------------------------------------------------------------
  def update_combat
    @combat_timer = 20
    return process_tactic_commands unless @tactic_commands.empty?
    determine_attack
    determine_skill_usage
    determine_item_usage
  end
  #----------------------------------------------------------------------------
  def chase_target
    return set_target(nil) if @current_target.dead?
    move_toward_character(@current_target)
  end
  #----------------------------------------------------------------------------
  def determine_attack(target = @current_target)
    return if !primary_weapon
    return if distance_to_character(target) > primary_weapon.tool_distance
    turn_toward_character(target)
    attack
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
  def attack
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
    @visible     =  status
    @translucent = !status if BattleManager.is_friend?(self, $game_player)
    if !@visible && @translucent
      @opacity = translucent_alpha
    else
      @opacity = 0xff
    end
  end
  #--------------------------------------------------------------------------
  def true_sight
    return battler.state?(PONY::StateID[:true_sight])
  end
  #--------------------------------------------------------------------------
  # * Get Alpha Value of Translucent Drawing
  #--------------------------------------------------------------------------
  def translucent_alpha
    return 160
  end
  #----------------------------------------------------------------------------
  # * Increase the target rate if target is meet to current tactic target
  #----------------------------------------------------------------------------
  def apply_tactic_target(value, target)
    return value
  end
  #----------------------------------------------------------------------------
  # * Change target to attacker when being attcked
  #----------------------------------------------------------------------------
  def apply_damaged_target_change(attacker, value)
    return if @aggressive_level == 0
    return unless is_opponent?(attacker)
    set_target(attacker) if change_target?(@current_target)
  end
  #----------------------------------------------------------------------------
  # * Determine whether change current target
  #----------------------------------------------------------------------------
  def change_target?(target)
    return true if @current_taret.nil? || @current_taret.dead?
    return true if distance_to_character(target) < distance_to_character(@current_target)
    return false
  end
  #----------------------------------------------------------------------------
end
