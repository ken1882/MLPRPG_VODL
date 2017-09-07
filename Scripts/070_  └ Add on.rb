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
  #------------------------------------------------------------------------
  # * Set hashid
  #------------------------------------------------------------------------
  def hash_self
    @hashid  = enemy.hashid
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_dndlevel initialize
  def initialize(index, enemy_id)
    @level = 1
    init_dndlevel(index, enemy_id)
    @rank = enemy.note =~ /<Boss HP Meter>/ ? :boss : :minon
    @rank = enemy.note =~ /<Elite>/ ? :elite : :minon
    @level = enemy.note =~ /<Level = (\d+)>/i ? $1.to_i : 1.to_i unless enemy.nil?
    @event = nil
    @skills = get_learned_skills
  end
  #-----------------------------------------------------------
  # *) is_boss?
  #-----------------------------------------------------------
  def is_boss?
    return @rank == :boss
  end
  #-----------------------------------------------------------
  # *) is_elite?
  #-----------------------------------------------------------
  def is_elite?
    return @rank == :elite
  end
  #-----------------------------------------------------------
  # *) is_minon?
  #-----------------------------------------------------------
  def is_minon?
    return @rank == :minon
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
  #---------------------------------------------------------------------------
  def get_learned_skills
    enemy.actions.collect{|action| $data_skills[action.skill_id] }
  end
  #---------------------------------------------------------------------------
  def skills
    @skills
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
