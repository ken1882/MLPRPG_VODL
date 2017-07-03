
#==============================================================================
#
# ** Game_Enemy
#
#==============================================================================
class Game_Enemy < Game_Battler
  
  
end
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # *) Recover All
  #--------------------------------------------------------------------------
  alias recover_revive recover_all
  def recover_all(gather_follower = true)
    recover_revive
    @deadposing = nil
    return unless $game_map.map_id > 0
    return unless gather_follower
    $game_player.followers.each do |follower|
      follower.moveto($game_player.x, $game_player.y)
    end
  end
  #--------------------------------------------------------------------------
  # * Show Level Up Message
  #     new_skills : Array of newly learned skills
  #--------------------------------------------------------------------------
  def display_level_up(new_skills)
    text  = sprintf("%s - Level Up", @name)
    infos = [text]
    
    if new_skills
      new_skills.each do |skill|
        text = sprintf("%s - new skill learned: %s",@name, skill.name)
        infos.push(text)
      end
    end
  
    self.recover_all(false)
    infos.each do |info| SceneManager.display_info(info) end
  end
  #--------------------------------------------------------------------------
  def moved?
    false
  end
  
  #--------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles parties. Information such as gold and items is included.
# Instances of this class are referenced by $game_party.
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Get Maximum Number of Items Possessed
  #--------------------------------------------------------------------------
  def max_item_number(item)
    return item.item_own_max
  end
  #--------------------------------------------------------------------------
end
