#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :dualclass_id        # Second class ID
  attr_accessor :assigned_hotkey     # Instance item in hotkey bar
  attr_reader   :queued_levelings    # Feats waiting to be select & added
  attr_reader   :class_level
  attr_reader   :mhp_plus, :mmp_plus # HP/EP gained through level up
  #------------------------------------------------------------------------
  # * Set hashid
  #------------------------------------------------------------------------
  def hash_self
    @hashid  = actor.hashid
    super
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_muticlass initialize
  def initialize(actor_id)
    @team_id = 0
    @assigned_hotkey = Array.new(HotKeys::HotKeys.size){nil}
    @passsive_skills = nil
    @queued_levelings = []
    @mhp_plus = @mmp_plus = 0
    init_muticlass(actor_id)
    hash_self
  end
  #--------------------------------------------------------------------------
  def setup(actor_id)
    @actor_id = actor_id
    @name     = actor.name
    @nickname = actor.nickname
    @level    = nil # will be set in setup_dnd_battler
    init_graphics
    @exp = 0
    @equips = []
    setup_dnd_battler(actor)
    init_exp
    init_skills
    init_equips(actor.equips)
    clear_param_plus
    recover_all
  end
  #--------------------------------------------------------------------------
  alias :is_a_obj? :is_a?
  def is_a?(cls)
    return is_a_obj?(cls) || actor.is_a?(cls)
  end
  #--------------------------------------------------------------------------
  # * Initialize EXP
  #--------------------------------------------------------------------------
  def init_exp
    @exp = 0
  end
  #--------------------------------------------------------------------------
  def exp
    @exp
  end
  #--------------------------------------------------------------------------
  # * Get Class Object
  #--------------------------------------------------------------------------
  def dualclass
    $data_classes[@dualclass_id]
  end
  #--------------------------------------------------------------------------
  # * Get Race Object
  #--------------------------------------------------------------------------
  def race
    $data_classes[@race_id]
  end
  #--------------------------------------------------------------------------
  def setup_dualclass(class_id)
    @dualclass_id = class_id
  end
  #--------------------------------------------------------------------------
  # * Learn Skill
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    return @queued_levelings.push(skill_id) if $data_skills[skill_id].for_leveling?
    super
  end
  #--------------------------------------------------------------------------
  # * Get Array of All Objects Retaining Features
  #--------------------------------------------------------------------------
  alias feature_objs feature_objects
  def feature_objects
    re  = feature_objs
    re += self.dualclass if @dualclass_id > 0
    re
  end
  #--------------------------------------------------------------------------
  # *) Get equipped all items
  #--------------------------------------------------------------------------
  def get_hotkeys(equip_only = false)
    items = [@equips[0], @equips[1]]
    unless equip_only
      @assigned_hotkey.each {|item| items.push(item)}
    end
    return items
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Processing Performed When Player Takes 1 Step
  #--------------------------------------------------------------------------
  def on_player_walk
    #@result.clear
    check_floor_effect
    if $game_player.normal_walk?
      #turn_end_on_map
      states.each {|state| update_state_steps(state) }
      show_added_states
      show_removed_states
    end
  end
  #--------------------------------------------------------------------------
  # * End of Turn Processing on Map Screen
  #--------------------------------------------------------------------------
  def turn_end_on_map
    on_turn_end
    perform_map_damage_effect if @result.hp_damage > 0
  end
  #--------------------------------------------------------------------------
  # * Get general skills for hotkey bar usage
  #--------------------------------------------------------------------------
  def get_valid_skills
    skills.select{|skill| !skill.is_passive? && !skill.is_vancian?}
  end
  #--------------------------------------------------------------------------
  # * Get valid skills for hotkey bar usage
  #--------------------------------------------------------------------------
  def get_vancian_spells
    skills.select{|skill| skill.is_vancian?}
  end
  #--------------------------------------------------------------------------
  def current_ammo
    equips.at(self.class.ammo_slot_id)
  end
  #--------------------------------------------------------------------------
  def mhp
    return (super + @mhp_plus).to_i
  end
  #--------------------------------------------------------------------------
  def mmp
    return (super + @mmp_plus).to_i
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_base(param_id)
    value  = actor.param(param_id) + super(param_id)
    return value if (value || 0).to_bool
    return DND::Base_Param[param_id]
  end
  #--------------------------------------------------------------------------
  # * Get Added Value of Parameter
  #--------------------------------------------------------------------------
  def param_plus(param_id)
    equips.compact.inject(super) {|r, item| r += item.param(param_id) }
  end
  #--------------------------------------------------------------------------
  alias param_plus_dnd param_plus
  def param_plus(param_id)
    value  = param_plus_dnd(param_id)
    
    # mhp, +constitution bonus
    value += [((self.def - 10) * @level / 4).to_i, 0].max if param_id == 0
    return value
  end
  #--------------------------------------------------------------------------
  def aggressive_level
    return @aggressive_level
  end
  #--------------------------------------------------------------------------
  def next_action
    return nil if @map_char.nil?
    @map_char.next_action
  end
  #--------------------------------------------------------------------------
  def action
    return nil if @map_char.nil?
    @map_char.action
  end
  #--------------------------------------------------------------------------
  def death_graphic;    return actor.death_graphic;   end
  def death_index;      return actor.death_index;     end
  def death_pattern;    return actor.death_pattern;   end
  def death_direction;  return actor.death_direction; end
  def death_sound;      return actor.death_sound;     end
  def icon_index;       return actor.icon_index;      end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     slot_id:  Equipment slot ID
  #     item:    Weapon/armor (remove equipment if nil)
  #--------------------------------------------------------------------------
  # tag: equipment
  def change_equip(slot_id, item)
    return unless trade_item_with_party(item, equips[slot_id])
    if item
      if equip_slots[slot_id] == 1
        return unless offhoof_equippable?(equip_slots[slot_id], item)
      else
        return if equip_slots[slot_id] != item.etype_id
      end
    end
    @equips[slot_id].object = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Total EXP Required for Rising to Specified Level
  #--------------------------------------------------------------------------
  def exp_for_level(level)
    return (DND::EXP_FOR_LEVEL[level] * 1000).to_i
  end
  #--------------------------------------------------------------------------
  # * Change Experience, player need to level up manually form Scene_LevelUp
  #     show : Level up display flag
  #--------------------------------------------------------------------------
  def change_exp(exp, show)
    @exp = [exp, 0].max
    refresh
  end
  #--------------------------------------------------------------------------
  # * Change Experience
  #--------------------------------------------------------------------------
  alias change_exp_security change_exp
  def change_exp(exp, show)
    check_security
    change_exp_security(exp, show)
    update_security
  end
  #--------------------------------------------------------------------------
  # * The real change class in dnd not exist, using for class advance
  #--------------------------------------------------------------------------
  def change_class(class_id, keep_exp = true)
    advance_class(class_id)
  end
  #--------------------------------------------------------------------------
  def advance_class(cid)
    @class_objects.clear
    @class_level[cid] = @class_level[@class_id]
    @class_id = cid
    refresh
  end
  #--------------------------------------------------------------------------
  def advance_dualclass(cid)
    @class_objects.clear
    @class_level[cid] = @class_level[@dualclass_id]
    @dualclass_id = cid
    refresh
  end
  #--------------------------------------------------------------------------
  def upgradeable?
    return self.exp >= next_level_exp
  end
  #--------------------------------------------------------------------------
  def init_skills
    super
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: Level Up
  #--------------------------------------------------------------------------
  def level_up
    proportion = [@hp.to_f / self.mhp, @mp.to_f / self.mmp]
    super
    @mmp_plus += Math.sqrt(self.class.param(1))
    self.hp = (proportion[0] * self.mhp).to_i
    self.mp = (proportion[1] * self.mmp).to_i
  end
  #--------------------------------------------------------------------------
  def level_up_class(cid)
    return unless cid > 0
    proportion = @hp.to_f / self.mhp
    super
    @mhp_plus += self.class.param(0)     if cid == @class_id
    @mhp_plus += self.dualclass.param(0) if cid == @dualclass_id
    self.hp = (proportion * self.mhp).to_i
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
  
end
