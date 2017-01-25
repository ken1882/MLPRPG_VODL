#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop).
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :level
  attr_accessor :rank
  attr_accessor :skills                   # learned skill
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_dndlevel initialize
  def initialize(index, enemy_id)
    @level = 1
    init_dndlevel(index, enemy_id)
    @rank = enemy.note =~ /<Boss HP Meter>/ ? "Boss" : "Minon"
    @rank = enemy.note =~ /<Elite>/ ? "Elite" : "Minon"
    @level = enemy.note =~ /<Level = (\d+)>/i ? $1.to_i : 1.to_i unless enemy.nil?
    @skills = []
    get_learned_skills
  end
  #-----------------------------------------------------------
  # *) is_boss?
  #-----------------------------------------------------------
  def is_boss?
    return @rank == "Boss"
  end
  #-----------------------------------------------------------
  # *) is_elite?
  #-----------------------------------------------------------
  def is_elite?
    return @rank == "Elite"
  end
  #-----------------------------------------------------------
  # *) is_minon?
  #-----------------------------------------------------------
  def is_minon?
    return @rank == "Minon"
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
