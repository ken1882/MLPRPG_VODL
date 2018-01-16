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
    @hashid  = enemy.hashid + self.hash
    super
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
  #--------------------------------------------------------------------------
  alias :is_a_obj? :is_a?
  def is_a?(cls)
    return is_a_obj?(cls) || enemy.is_a?(cls)
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
    @team_id = enemy.team_id if @team_id.nil?
    return @team_id
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
  def weapon_ammo_ready?(weapon)
    return true
  end
  #---------------------------------------------------------------------------
  def weapon_level_prof
    enemy.weapon_level_prof
  end
  #---------------------------------------------------------------------------
  def secondary_weapon
    enemy.secondary_weapon
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
  def determine_skill_usage
    action_list = enemy.actions.select {|a| action_valid?(a) }
    return if action_list.empty?
    list = action_list.sort{|a, b| b.rating <=> a.rating}
    list.select!{|a| item_test(self, $data_skills[a.skill_id]) && usable?($data_skills[a.skill_id])}
    skill = $data_skills[list.first.skill_id] rescue nil
    
    return skill
  end
  
end
