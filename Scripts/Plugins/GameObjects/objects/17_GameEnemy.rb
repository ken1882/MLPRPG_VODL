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
  # * Overwrite: Object Initialization
  #--------------------------------------------------------------------------
  def initialize(index, enemy_id)
    super()
    @index = index
    @enemy_id = enemy_id
    enemy = $data_enemies[@enemy_id]
    @original_name = enemy.name
    @letter = ""
    @plural = false
    @screen_x = 0
    @screen_y = 0
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @level = 1
    case enemy.note
    when /<Chief>/i;    @rank = :chief;
    when /<Captain>/i;  @rank = :captain;
    when /<Elite>/i;    @rank = :elite;
    when /<Minion>/i;   @rank = :minion;
    when /<Critter>/i;  @rank = :critter;
    else
      @rank = :minion
    end
    @level = enemy.note =~ /<Level = (\d+)>/i ? $1.to_i : 1.to_i unless enemy.nil?
    @event = nil
    setup_dnd_battler(enemy)
    init_skills
    @skills << get_learned_skills
    @hp = mhp
    @mp = mmp
  end
  #--------------------------------------------------------------------------
  alias :is_a_obj? :is_a?
  def is_a?(cls)
    return is_a_obj?(cls) || enemy.is_a?(cls)
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
  #--------------------------------------------------------------------------
  # * Overwrite: Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_base(param_id)
    value  = enemy.params[param_id] + super(param_id)
    return value if (value || 0).to_bool
    return DND::Base_Param[param_id]
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
  #---------------------------------------------------------------------------
  def load_tactic_commands
    @tactic_commands = TacticCommandModule.load_template(:basic, self)
  end
  
end
