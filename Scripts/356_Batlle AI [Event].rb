#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================
# tag: AI
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  Sight_Angle = 75
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_gaevdndai update
  def update
    if @enemy
      update_timer
      update_sight if effectus_near_the_screen?
    end
    update_gaevdndai
  end
  #----------------------------------------------------------------------------
  # * update enemies in sight
  #----------------------------------------------------------------------------
  def update_sight
    return unless aggressive_level > 1 && !static_object? && !halt?
    @sight_timer -= 1 if @sight_timer > 0
    return if @sight_timer > 0
    @sight_timer = 15 + rand(15)
    process_tactic_commands(:targeting)
    update_sighted if @current_target
  end
  #----------------------------------------------------------------------------
  def update_timer
    @chase_timer  -= 1 if @chase_timer > 0
    @chase_pathfinding_timer -= 1 if @chase_pathfinding_timer > 0
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
    offset = target.body_size / 2
    tx, ty = target.x + offset, target.y + offset
    angle  = determind_sight_angles(Sight_Angle)
    result = Math.in_arc?(tx, ty, @x, @y, angle[0], angle[1], dis - 1 + offset*3, @direction)
    return false unless result
    result = can_see?(@x, @y, target.x, target.y)
    return result
  end
  #----------------------------------------------------------------------------
  def update_battler
    return if dead? || $game_system.story_mode?
    @combat_timer -= 1 if @combat_timer > 0
    update_combat if @combat_timer == 0 && !halt?
  end
  #----------------------------------------------------------------------------
  def update_sighted
    if battler_in_sight?(@current_target)
      @sight_lost_timer = 150
      @target_last_pos = @current_target.pos
    else
      @sight_lost_timer -= 15 if @sight_lost_timer > 0
      process_target_missing  if @sight_lost_timer == 0
    end
  end
  #----------------------------------------------------------------------------
  def process_target_missing
    return if !@target_last_pos
    cancel_action_without_penalty if @action && !@action.started
    @next_action = nil if @next_action && @next_action.target == @current_target
    puts "#{name}: Target Missing, Last pos: #{[@target_last_pos.x, @target_last_pos.y]}"
    move_to_position(@target_last_pos.x, @target_last_pos.y, tool_range: 0) if aggressive_level > 3
    @target_last_pos = nil
    set_target(nil)
  end
  #----------------------------------------------------------------------------
  def attack(target = @current_target)
    return if halt?
    super
    @enemy.process_tool_action(primary_weapon)
  end
  #----------------------------------------------------------------------------
  def find_nearest_enemy
    brange = blind_sight
    vrange = visible_sight
    candidates = BattleManager.opponent_battler(self)
    best_target = [nil,0xffff]
    
    candidates.each do |char|
      next if char.static_object?
      dis = distance_to_character(char)
      next if dis > vrange && dis > brange
      if dis <= brange || in_sight?(char, vrange)
        rate = target_rate(char, dis)
        best_target = [char, rate] if rate < best_target[1]
      end
    end
    
    return best_target.first
  end
  #----------------------------------------------------------------------------
  def determine_skill_usage
    skill = @enemy.determine_skill_usage
    unless skill.nil?
      if (skill.tool_castime || 0) > 10
        @casting_flag = true
        @ori_agresilv = @aggressive_level
        @aggressive_level = 0
        @chase_timer = 30
      end
      target = BattleManager.autotarget(self, skill)
      @next_action = Game_Action.new(self, target, skill) 
      clear_pathfinding_moves
    end
  end
  #----------------------------------------------------------------------------
  def set_target(target)
    super
    if target.nil?
      $game_map.remove_active_enemy(self)
    else
      $game_map.add_active_enemy(self)
    end
  end
end
