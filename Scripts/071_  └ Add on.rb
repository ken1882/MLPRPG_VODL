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
  attr_reader   :event
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
    @event = nil
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
  def team_id
    return enemy.team_id
  end
  #--------------------------------------------------------------------------
  def face_name
    return enemy.face_name
  end
  #--------------------------------------------------------------------------
  def face_index
    return enemy.face_index
  end
  #--------------------------------------------------------------------------
  # * Create Battle Action
  #--------------------------------------------------------------------------
  def get_learned_skills
    #actions = Array.new(make_action_times) { Game_Action.new(self) }
    #for action in enemy.actions
    #  @skills.push(action.skill_id)
    #end
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Actor
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, args) unless @map_char
    super(symbol, args) unless @map_char.methods.include?(symbol)
    @map_char.method(symbol).call(*args)
  end
  #---------------------------------------------------------------------------
end
