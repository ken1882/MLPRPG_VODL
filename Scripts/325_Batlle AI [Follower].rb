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
  def attack
    super
    actor.process_tool_action(primary_weapon)
  end
  #----------------------------------------------------------------------------
  def set_target(target)
    return if gather? || command_gathering?
    super
  end
  #----------------------------------------------------------------------------
  def find_nearest_enemy
    enemies = BattleManager.opponent_battler(self)
    best = [nil, 0xffff]
    enemies.each do |enemy|
      dis = distance_to_character(enemy)
      next if distance_to_character(enemy) > 8
      best = [enemy, dis] if dis < best.last
    end
    return best.first
  end
  #----------------------------------------------------------------------------
end
