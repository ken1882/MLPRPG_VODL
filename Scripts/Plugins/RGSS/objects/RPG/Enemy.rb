#==============================================================================
# ** RPG::Enemy
#------------------------------------------------------------------------------
#  Instance class in database, store enemies data
#==============================================================================
class RPG::Enemy
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  # tag: charparam
  #--------------------------------------------------------------------------
  attr_accessor :default_weapon       # Weapon ID when no primary weapon equipped
  attr_accessor :team_id              # Team ID
  attr_accessor :visible_sight        # Sight range with bare eye
  attr_accessor :blind_sight          # Sight ragne without actuallt see things
  attr_accessor :infravision          # No penalty in dark
  attr_accessor :move_limit           # Back to original position once distance out of this value
  attr_accessor :aggressive_level     # Aggressive Level:
    #--------------------------------------------------------------------------
    # 0: Won't attack no matter what (No attack)
    # 1: Won't attack unless enemy attack first, if in combat, change to 4 (Passive)
    # 2: Attack sighted enemy without chasing (Stand Ground)
    # 3: Chase enemy in short range (7), until enemy out of last sighted spot (Defensive)
    # 4: Chase enemy until target out of last sighted spot, won't corss areas (Aggressive)
    # 5: Chase enemy through local areas until target out of last sighted spot (Striking)
    #--------------------------------------------------------------------------
  attr_reader   :death_animation      # Animation display on death
  attr_reader   :death_switch_self    # Self switch trigger when dead
  attr_reader   :death_switch_global  # Global switch trigger when dead
  attr_reader   :death_var_self       # Self var change when dead
  attr_reader   :death_var_global     # Self var change when dead
  attr_reader   :casting_animation
  
  attr_accessor :weapon_level_prof    # Immune the damage from weapons below than +N level
  attr_accessor :face_name  # Face filename show in map status window
  attr_accessor :face_index # Face index
  attr_accessor :body_size
  
  attr_accessor :secondary_weapon
  #--------------------------------------------------------------------------
  attr_reader :dualclass_id, :race_id, :subrace_id, :class_id
  attr_reader :class_levelcap
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
    super
    apply_default_attributes
    self.note.split(/[\r\n]+/).each { |line|
      do_load_enemy_params(line)
    } # self.note.split
    #--------------------------------------------------
  end
  #--------------------------------------------------------------------------
  def do_load_enemy_params(line)
    case line
    when DND::REGEX::Character::DefaultWeapon
      id = $1.to_i
      @default_weapon = $data_weapons[id] if id > 1
      puts "[System]: #{self.name}'s default weapon: #{@default_weapon.name}" if id > 1
    when DND::REGEX::Character::SecondaryWeapon
      id = $1.to_i
      @secondary_weapon = $data_weapons[id] if id > 1
      puts "[System]: #{self.name}'s secondary weapon: #{@secondary_weapon.name}" if id > 1
    when DND::REGEX::Character::SecondaryArmor
      id = $1.to_i
      @secondary_weapon = $data_armors[id] if id > 1
      puts "[System]: #{self.name}'s secondary armor: #{@secondary_weapon.name}" if id > 1
    when DND::REGEX::Character::TeamID
      @team_id = $1.to_i
    when DND::REGEX::Character::DeathSwitchSelf
      @death_switch_self = $1.upcase
    when DND::REGEX::Character::DeathSwitchGlobal
      @death_switch_global = $1.to_i
    when DND::REGEX::Character::DeathVarSelf
      @death_var_self = [$1.to_i, $2.to_i]
    when DND::REGEX::Character::DeathVarGlobal
      @death_var_global = [$1.to_i, $2.to_i]
    when DND::REGEX::Character::VisibleSight
      @visible_sight = $1.to_i
    when DND::REGEX::Character::BlindSight
      @blind_sight   = $1.to_i
    when DND::REGEX::Character::Infravision
      @infravision   = $1.to_i.to_bool
    when DND::REGEX::Character::AggressiveLevel
      @aggressive_level = $1.to_i
    when DND::REGEX::Character::MoveLimit
      @move_limit      = $1.to_i
    when DND::REGEX::Character::DeathAnimation
      @death_animation = $1.to_i
    when DND::REGEX::Character::WeaponLvProtect
      @weapon_level_prof = $1.to_i
      puts "[System]: #{@name} has weapon level prof: #{$1.to_i}"
    when DND::REGEX::Character::CastingAnimation
      @casting_animation = $1.to_i
    when DND::REGEX::Character::DefaultAmmo
      @default_ammo = $1.to_i
    when DND::REGEX::Leveling::LoadStart; dnd_loading = true;
    when DND::REGEX::Leveling::LoadEnd;   dnd_loading = false;
    end
    load_dnd_attribute(line) if dnd_loading
  end
  #--------------------------------------------------------------------------
  def load_dnd_attribute(line)
    case line
    when DND::REGEX::Leveling::Race;      @race_id         = $1.to_i
    when DND::REGEX::Leveling::Subrace;   @subrace_id      = $1.to_i
    when DND::REGEX::Leveling::Class
      # Primary Class selection is loaded from default RM database editor
    when DND::REGEX::Leveling::DualClass
      info          = $1.split(',')
      @dualclass_id = (info.first.to_i || 0)
      @class_levelcap[@dualclass_id][0] = [info.last.to_i, 1].max
    when DND::REGEX::Leveling::HP;           @param_adjust[0]   = $1.to_i
    when DND::REGEX::Leveling::EP;           @param_adjust[1]   = $1.to_i
    when DND::REGEX::Leveling::Strength;     @param_adjust[2]   = $1.to_i
    when DND::REGEX::Leveling::Constitution; @param_adjust[3]   = $1.to_i
    when DND::REGEX::Leveling::Intelligence; @param_adjust[4]   = $1.to_i
    when DND::REGEX::Leveling::Wisdom;       @param_adjust[5]   = $1.to_i
    when DND::REGEX::Leveling::Dexterity;    @param_adjust[6]   = $1.to_i
    when DND::REGEX::Leveling::Charisma;     @param_adjust[7]   = $1.to_i
    end # case
  end
  #--------------------------------------------------------------------------
  def apply_default_attributes
    @defalut_weapon       = DND::BattlerSetting::DefaultWeapon
    @team_id              = DND::BattlerSetting::TeamID
    @visible_sight        = DND::BattlerSetting::VisibleSight
    @blind_sight          = DND::BattlerSetting::BlindSight
    @infravision          = DND::BattlerSetting::Infravision 
    @move_limit           = DND::BattlerSetting::MoveLimit
    @aggressive_level     = DND::BattlerSetting::AggressiveLevel 
    @death_switch_self    = DND::BattlerSetting::DeathSwitchSelf
    @death_switch_global  = DND::BattlerSetting::DeathSwitchGlobal
    @death_var_self       = DND::BattlerSetting::DeathVarSelf
    @death_var_global     = DND::BattlerSetting::DeathVarGlobal
    @death_animation      = DND::BattlerSetting::DeathAnimation
    @casting_animation    = DND::BattlerSetting::CastingAnimation
    @face_name            = nil
    @secondary_weapon     = nil
    @face_index           = 0
    @body_size            = DND::BattlerSetting::BodySize
    @weapon_level_prof    = 0
    @default_ammo         = 0
    
    @param_adjust         = Array.new(8, 0)
    @class_id             = DND::BattlerSetting::DefaultClassID
    @dualclass_id         = 0
    @race_id              = @subrace_id   = 0 
    
    # Initial element for classes' init level and level cap
    init_lvl_ele = [0, DND::BattlerSetting::LevelCap]
    @class_levelcap  = Array.new($data_classes.size, init_lvl_ele)
    @class_levelcap[@class_id][0] = @initial_level
  end
  #------------------------------------------------------------------------
end