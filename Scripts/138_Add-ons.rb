
#=======================================================================
# Game System
#=======================================================================
class Game_System
  attr_accessor :time_stop
  
  alias initialize_COMP initialize
  def initialize
    @time_stop = false
    initialize_COMP
  end
  
  def time_stopped?
    return @time_stop
  end
  
  def show_roll_result?
    return $game_switches[15]
  end
  
  def hide_all_windows?
    return $game_switches[16]
  end
  
  def make_rand
    Random.new_seed
    return Random.new
  end
end
#=======================================================================
# *) Game BattlerBase
#=======================================================================
class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :reg_time_count
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_reg_dnd initialize
  def initialize
    @reg_time_count = 0
    initialize_reg_dnd
  end
  #--------------------------------------------------------------------------   
  # ● Easier method for check skilll learned
  #--------------------------------------------------------------------------   
  def skill_learned?(id)
    if self.actor?
      return self.skills.include?($data_skills[id])
    else
      return self.skills.include?(id)
    end
  end
  #--------------------------------------------------------------------------
  # ● Posioned?
  #--------------------------------------------------------------------------   
  def poisoned?
    
    for state in self.states
      return true if state.is_poison?
    end
    
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Debuffed?
  #--------------------------------------------------------------------------   
  def debuffed?
    for state in self.states
      return true if state.is_debuff?
    end
    
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Dispel Magic
  #--------------------------------------------------------------------------   
  def dispel_magic
    animated = false
    for state in self.states
      next if state.nil?
      animated = true if state.id == 271
      
      remove_state(state.id) if state.is_magic?
    end
    die if animated
  end
  #--------------------------------------------------------------------------
  # ● Anti Magic?
  #--------------------------------------------------------------------------   
  def anti_magic?
    
    result = false
    source = 0
    
     if @anti_magic
       result = true; source = 1
     end
     
    if self.mrf > 0.5
      result = true; source = 2 
    end
    
    anti_magic_state = [266,267,288]
    
    for id in anti_magic_state
      if self.state?(id)
        source = id
        result = true
        break
      end
  
    end
    
    return result
  end
  #--------------------------------------------------------------------------
  # Hide HP/MP info
  #--------------------------------------------------------------------------
  def hide_info?
    false
  end
  
  #--------------------------------------------------------------------------   
end
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
