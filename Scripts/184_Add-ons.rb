
#==============================================================================
#
# ** Game_Enemy
#
#==============================================================================
class Game_Enemy < Game_Battler
  
  #-----------------------------------------------------------
  # *) is_boss?
  #-----------------------------------------------------------
  def is_boss?
    return @class == "Boss"
  end
  #-----------------------------------------------------------
  # *) is_elite?
  #-----------------------------------------------------------
  def is_elite?
    return @class == "Elite"
  end
  #-----------------------------------------------------------
  # *) is_minon?
  #-----------------------------------------------------------
  def is_minon?
    return @class == "Minon"
  end
  
  #--------------------------------------------------------------------------
  # * Create Battle Action
  #--------------------------------------------------------------------------
  def get_learned_skills
    actions = Array.new(make_action_times) { Game_Action.new(self) }
    for action in enemy.actions
      @skills.push(action.skill_id)
    end
  end
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
  # *) Get equipped all items
  #--------------------------------------------------------------------------
  def get_equipped_items(include_equipment = true)
    items = []
    items = [ @equips[0], @equips[1] ] if include_equipment
    
    @assigned_item.each_value do |item|
      items.push(item)
    end
    @assigned_skill.each_value do |skill|
      items.push(skill)
    end
    items.push(@assigned_sskill)
    
    items.each_index do |index|
      items[index] = items[index].object if items[index].is_a?(Game_BaseItem)
    end
    
    return items
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
#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a super class of all windows within the game.
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Window visible? tag: modified
  #--------------------------------------------------------------------------
  def visible?
    return self.visible
  end
  #--------------------------------------------------------------------------
  # * Window Active?
  #--------------------------------------------------------------------------
  def active?
    return self.active
  end
  #---------------------------------------------------------------------------
end
