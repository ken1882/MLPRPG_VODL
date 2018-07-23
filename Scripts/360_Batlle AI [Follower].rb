#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
# tag: AI
class Game_Follower < Game_Character
  #----------------------------------------------------------------------------
  def attack(target = @current_target)
    return if halt?
    super
    actor.process_tool_action(primary_weapon)
  end
  #----------------------------------------------------------------------------
  def set_target(target)
    return if gather? && target
    super
  end
  #--------------------------------------------------------------------------
  # * Alias: Frame Update
  #--------------------------------------------------------------------------
  alias update_dnd_combat update
  def update
    update_dnd_combat
    update_timer
    update_battler
  end
  #----------------------------------------------------------------------------
  def update_timer
    @chase_timer  -= 1 if @chase_timer > 0
    @chase_pathfinding_timer -= 1 if @chase_pathfinding_timer > 0
  end
  #----------------------------------------------------------------------------
  def update_battler
    return if dead? || $game_system.story_mode?
    super
    @combat_timer -= 1 if @combat_timer > 0
    update_combat if @combat_timer == 0 && !halt?
  end
  #----------------------------------------------------------------------------
  def update_combat
    return set_target(nil) if aggressive_level == 0
    start_timer(:combat)
    #puts "AI: #{$game_player.followers.tactic_enabled?}"
    process_tactic_commands if $game_player.followers.tactic_enabled?
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
    return can_see?(@x, @y, target.x, target.y)
  end
  #----------------------------------------------------------------------------
  def find_nearest_enemy
    enemies = BattleManager.opponent_battler(self)
    best = [nil, 0xffff]
    enemies.each do |enemy|
      next if enemy.static_object?
      dis = distance_to_character(enemy)
      next if distance_to_character(enemy) > 8
      next if !path_clear?(@x, @y, enemy.x, enemy.y)
      best = [enemy, dis] if dis < best.last
    end
    return best.first
  end
  #----------------------------------------------------------------------------
  def start_timer(sym, plus = 0)
    case sym
    when :combat
      return @combat_timer = 20 + plus;
    when :chase_pathfinding
      return @chase_pathfinding_timer = 60 + plus;
    when :chase
      return @chase_timer = 8 + plus;
    end
  end
  #----------------------------------------------------------------------------
end
