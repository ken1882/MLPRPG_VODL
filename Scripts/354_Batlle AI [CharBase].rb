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
  attr_reader   :translucent
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_combatdnd init_public_members
  def init_public_members
    @combat_timer    = rand(20)
    @tactic_commands = []
    @translucent     = false
    @chase_timer     = 0
    @chase_pathfinding_timer = 0
    init_public_combatdnd
  end
  #----------------------------------------------------------------------------
  alias update_batgc update
  def update
    update_battler_situation_normal if battler != self && @current_target.nil?
    update_batgc
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
    signal = target.nil? ? false : true
    BattleManager.send_flag(in_battle: signal)
  end
  #----------------------------------------------------------------------------
  def update_combat
    return set_target(nil) if aggressive_level == 0
    start_timer(:combat)
    # last work: tactic processing(real)
    #return process_tactic_commands unless @tactic_commands.empty?
    return if casting? || @next_action
    determine_item_usage
    determine_skill_usage
    determine_attack
  end
  #----------------------------------------------------------------------------
  def chase_target
    return if @current_target.nil?
    return if casting? || @casting_flag || frozen?
    return process_target_dead if @current_target.dead?
    return if aggressive_level < 3 || @chase_timer > 0 || command_holding?
    if primary_weapon
      tx, ty = @current_target.x, @current_target.y
      if @chase_pathfinding_timer == 0 && !path_clear?(@x, @y, tx, ty)
        move_to_position(tx, ty, goal: @current_target, 
                           tool_range: primary_weapon.tool_distance)
        start_timer(:chase_pathfinding)
        start_timer(:chse, 112)
      else
        # if weapon is ranged and enemy too close, move away from
        if primary_weapon.tool_distance > 2 && distance_to_character(@current_target) < 2
          move_away_from_character(@current_target)
        # move random when enemy in moderate range
        elsif distance_to_character(@current_target) <= primary_weapon.tool_distance
          unless @action && @action.acting?
            movable_dir = [2,4,6,8]
            movable_dir.delete(turn_toward_character(@current_target))
            move_straight(movable_dir[rand(3)], false)
            start_timer(:chase) if @chase_pathfinding_timer == 0
          end
        # when too fat, moev toward
        else
          move_toward_character(@current_target)
          start_timer(:chase)
        end
      end
    else # run way, run away!
      move_away_from_character(@current_target)
    end
  end
  #----------------------------------------------------------------------------
  def determine_attack
    return if !primary_weapon
    return unless battler.cooldown_ready?(primary_weapon)
    return if @casting_flag || casting?
    BattleManager.opponent_battler(self).each do |enemy|
      next if distance_to_character(enemy) > primary_weapon.tool_distance
      attack(enemy)
    end
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
  def attack(target = @current_target)
    #move_toward_character(target) if aggressive_level > 2
    turn_toward_character(target)
  end
  #----------------------------------------------------------------------------
  def tactic_retreat
  end
  #----------------------------------------------------------------------------
  def visible?
    return false if battler == self
    return !battler.state?(PONY::StateID[:invisible])
  end
  alias :visible :visible?
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
    return unless BattleManager.valid_battler?(self)
    return if aggressive_level == 0
    return unless is_opponent?(attacker)
    set_target(attacker) if change_target?(attacker)
  end
  #----------------------------------------------------------------------------
  # * Determine whether change current target
  #----------------------------------------------------------------------------
  def change_target?(target)
    return false if casting?
    return false if target == @current_target
    return true  if @current_target.nil? || @current_target.dead?
    return true  if target && distance_to_character(target) < distance_to_character(@current_target)
    return false
  end
  #----------------------------------------------------------------------------
  # *) Determind sight angle
  #----------------------------------------------------------------------------
  def determind_sight_angles(angle)
    case direction
    when 2; value = [270 + angle, 270 - angle]
    when 4; value = [180 + angle, 180 - angle]
    when 6; value = [  0 + angle,   0 - angle]
    when 8; value = [ 90 + angle,  90 - angle]
    end
    value[0] = (value[0] + 360) % 360
    value[1] = (value[1] + 360) % 360
    return value
  end
  #----------------------------------------------------------------------------
  # *) sight
  #----------------------------------------------------------------------------
  def in_sight?(target, dis)
    return false if !target.visible? && !true_sight
    offset  = target.body_size / 2
    tx, ty  = target.x + offset, target.y + offset
    angle   = determind_sight_angles(75)
    result  = Math.in_arc?(tx, ty, @x, @y, angle[0], angle[1], dis - 1 + offset*3, @direction)
    result &= path_clear?(@x, @y, target.x, target.y)
    return result
  end
  #----------------------------------------------------------------------------
  def update_battler
  end
  #----------------------------------------------------------------------------
  def update_battler_situation_normal
  end
  #----------------------------------------------------------------------------
  def process_target_dead
    set_target(find_nearest_enemy)
  end
  #----------------------------------------------------------------------------
  def find_nearest_enemy
  end
  #---------------------------------------------------------------------------
  def update_sight
  end
  #----------------------------------------------------------------------------
  def start_timer(sym, plus = 0)
    case sym
    when :combat
      return @combat_timer = 20 + plus;
    when :chase_pathfinding
      return @chase_pathfinding_timer = 120 + plus;
    when :chase
      return @chase_timer = 8 + plus;
    end
  end
  
end
