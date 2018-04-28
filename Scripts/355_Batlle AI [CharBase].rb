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
    process_tactic_commands
  end
  #----------------------------------------------------------------------------
  def chase_target(action = nil, impleable = nil)
    target = action ? action.target : @current_target
    return if target.nil?
    return if halt? || frozen?
    return process_target_dead if target.dead?
    
    return if aggressive_level < 3 || @chase_timer > 0 || command_holding?
    
    if !action
      if primary_weapon
        action = Game_Action.new(battler, target, primary_weapon)
      else
        return move_away_from_character(target)
      end
    end
    
    do_ok = impleable.nil? ? action.action_impleable? : impleable
    if do_ok
      # Impleaable, wondering around
      movable_dir = [2,4,6,8]
      movable_dir.delete(turn_toward_character(target))
      move_straight(movable_dir[rand(3)], false)
      start_timer(:chase) if @chase_pathfinding_timer == 0
      puts "move random"
    else
      # If unimpleable, chase target
      if @chase_pathfinding_timer == 0
        tx, ty = target.x, target.y
        move_to_position(tx, ty, goal: target, 
                           tool_range: action.item.tool_distance)
        start_timer(:chase_pathfinding)
        start_timer(:chase, 112)
        puts "chase pathfinding"
      else
        move_toward_character(target)
        start_timer(:chase)
        puts "chase normal"
      end
    end # do_ok
  end
  #----------------------------------------------------------------------------
  def determine_attack
    return if !primary_weapon
    return unless battler.cooldown_ready?(primary_weapon)
    return if halt?
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
  # tag: last work (bloody AI
  def process_tactic_commands
    @tactic_commands.each do |command|
      pas = command.check_condition
      puts "CMD: #{command.category} #{command.condition_symbol} >> #{pas}"
      next unless command.check_condition
      action = command.action.dup
      interpret_tactic_action(action, command.get_target)
    end
  end
  #----------------------------------------------------------------------------
  def interpret_tactic_action(action, target)
    item = action.get_symbol_item
    return execute_symbol_action(item, target) if item.is_a?(Symbol)
    use_tool(item, target)
  end
  #----------------------------------------------------------------------------
  def execute_symbol_action(item, target)
    case item
    when :target_none
      set_target(nil)
    end
    return unless target || (target != battler && target != self)
    return if target.is_a?(Array) && target.empty?
    case item
    when :set_target
      set_target(target) unless target.is_friend?(self) || !change_target?(target)
    when :move_away
      move_away_from_character(target) unless distance_to_character(target) > 5
    when :move_close
      move_toward_character(target) unless distance_to_character(target) < 2
    end
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
    result &= can_see?(@x, @y, target.x, target.y)
    return result
  end
  #----------------------------------------------------------------------------
  def update_battler
  end
  #----------------------------------------------------------------------------
  def process_target_dead
    set_target(nil)
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
