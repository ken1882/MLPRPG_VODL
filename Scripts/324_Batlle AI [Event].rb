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
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_gaevdndai update
  def update
    update_sight if @enemy && !@static_object
    update_gaevdndai
  end
  #----------------------------------------------------------------------------
  # * update enemies in sight
  #----------------------------------------------------------------------------
  def update_sight
    @sight_timer -= 1 if @sight_timer > 0
    return if @sight_timer > 0
    @sight_timer = 15
    return update_sighted if @current_target
    update_blindsight
    update_visiblesight
  end
  #----------------------------------------------------------------------------
  def update_blindsight
    range = blind_sight
    return if range == 0
    candidates = BattleManager.opponent_battler(self)
    best_target = [nil,0xffff]
    candidates.each do |char|
      dis = distance_to_character(char)
      next if dis > range
      best_target = [char, rate] if target_rate(char, dis) < best_target[1]
    end
    set_target(best_target.first)
  end
  #----------------------------------------------------------------------------
  def update_visiblesight
    range = visible_sight
    return if range == 0
    candidates = BattleManager.opponent_battler(self)
    best_target = [nil,0xffff]
    candidates.each do |char|
      dis = distance_to_character(char)
      next if dis > range
      next unless in_sight?(char, range)
      rate = target_rate(char, dis)
      best_target = [char, rate] if rate < best_target[1]
    end
    set_target(best_target.first)
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
  def update_sighted
    #key = [$game_map.id]
    if !in_sight?(@current_target, visible_sight)
      @sight_lost_timer -= 15 if @sight_lost_timer > 0
      process_target_missing if @sight_lost_timer == 0
    else
      @sight_lost_timer = 180
      @target_last_pos = @current_target.pos
    end
    
    BattleManager.opponent_battler(self).each do |battler|
      next if !battler.primary_weapon
      next if distance_to_character(battler) > visible_sight
      next if !in_sight?(battler, visible_sight)
      set_target(battler) if change_target?(battler)
    end
  end
  #----------------------------------------------------------------------------
  def process_target_missing
    return if !@target_last_pos
    puts "#{name}: Target Missing"
    move_to_position(@target_last_pos.x, @target_last_pos.y, tool_range: 0) if aggressive_level > 3
    @target_last_pos = nil
  end
  #----------------------------------------------------------------------------
  def attack
    @enemy.process_tool_action(primary_weapon)
  end
  #----------------------------------------------------------------------------
  
end
