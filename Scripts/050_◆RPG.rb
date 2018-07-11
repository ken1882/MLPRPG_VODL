#===============================================================================
# * Superclass of almost database items
#===============================================================================
class RPG::BaseItem
  #----------------------------------------------------------------------------
  # *) Delete a char at certain position
  #----------------------------------------------------------------------------
  def id_for_filename
    n = @id
    cnt = 0
    while n > 0
      n /= 10
      cnt += 1
    end
    dict = ''
    return sprintf("%s%s%s",dict, '0' * (3 - cnt), @id)
  end
   #------------------------------------------------------------------------
  # * Set hashid
  #------------------------------------------------------------------------
  def hash_self
    base = (@id * 42).to_s(8)
    base += "Actor"  if self.is_a?(RPG::Actor)
    base += "Class"  if self.is_a?(RPG::Class)
    base += "Enemy"  if self.is_a?(RPG::Enemy)
    base += "Item"   if self.is_a?(RPG::Item)
    base += "Weapon" if self.is_a?(RPG::Weapon)
    base += "Armor"  if self.is_a?(RPG::Armor)
    base += "State"  if self.is_a?(RPG::State)
    @hashid = PONY.Sha256(base).to_i(16)
    super
  end
  #-----------------------------------------------------------------------
  # *) Get Attack Element
  #-----------------------------------------------------------------------
  def get_feat_attack_elemet
    elements = []
    @features.each do |feat|
      elements.push(feat.data_id) if feat.code == 31
    end
    
    return elements
  end
  #-----------------------------------------------------------------------
  # *) Get Element Rate
  #-----------------------------------------------------------------------
  def get_element_rate(id)
    @features.each do |feat|
      if feat.code == 11
        if id.is_a?(String)
          return feat.value if id.upcase == $data_system.elements[feat.data_id].upcase
        else
          return feat.value if id == feat.data_id
        end
      end
    end
    return 1
  end
  #---------------------------------------------------------------------------
  def is_skill?;  false; end
  def is_item?;   false; end
  def is_weapon?; false; end
  def is_armor?;  false; end
  #---------------------------------------------------------------------------  
end
#=======================================================================
# *) RPG::UsableItem
#-----------------------------------------------------------------------
# Quicker way to check the effects
#=======================================================================
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * Constants (Effects)
  #--------------------------------------------------------------------------
  EFFECT_RECOVER_HP     = 11              # HP Recovery
  EFFECT_RECOVER_MP     = 12              # MP Recovery
  EFFECT_GAIN_TP        = 13              # TP Gain
  EFFECT_ADD_STATE      = 21              # Add State
  EFFECT_REMOVE_STATE   = 22              # Remove State
  EFFECT_ADD_BUFF       = 31              # Add Buff
  EFFECT_ADD_DEBUFF     = 32              # Add Debuff
  EFFECT_REMOVE_BUFF    = 33              # Remove Buff
  EFFECT_REMOVE_DEBUFF  = 34              # Remove Debuff
  EFFECT_SPECIAL        = 41              # Special Effect
  EFFECT_GROW           = 42              # Raise Parameter
  EFFECT_LEARN_SKILL    = 43              # Learn Skill
  EFFECT_COMMON_EVENT   = 44              # Common Events
  #---------------------------------------------------------------------------
  # * Load the attributes of the item form its notes in database
  #---------------------------------------------------------------------------
  def load_notetags_dndattrs
    @effect_value = {}
    super
  end
  #--------------------------------------------------------------------------
  def effect_value(code, data_id)
    key = code * 1000 + data_id
    return @effect_value[key] unless @effect_value[key].nil?
    eff = Struct.new(:value1, :value2).new(0,0)
    @effects.each do |feat|
      next unless feat.code == code && feat.data_id == data_id
      eff.value1 += feat.value1
      eff.value2 += feat.value2
    end
    return @effect_value[key] = eff
  end
  #-----------------------------------------------------------------------
  # *) Check if state will be added
  #-----------------------------------------------------------------------
  def add_state?(id = 0)
    # check if will add state
    return @effects.any? {|eff| eff.code == EFFECT_ADD_STATE } if id == 0
    # check if will add a specific state
    return @effects.any? {|eff| eff.code == EFFECT_ADD_STATE && effect.data_id == id }
  end
  #-----------------------------------------------------------------------
  # *) Check if state will be removed
  #-----------------------------------------------------------------------
  def remove_state?(id = 0)
    # check if will remove state
    return @effects.any? {|eff| eff.code == EFFECT_REMOVE_STATE } if id == 0
    # check if will remove a specific state
    return @effects.any? {|eff| eff.code == EFFECT_REMOVE_STATE && effect.data_id == id }
  end
  #-----------------------------------------------------------------------
  # *) Check whether will recover hp
  #-----------------------------------------------------------------------
  def hp_recover?
    return true if @damage.recover? && @damage.to_hp?
    return @effects.any?{|eff| eff.code == EFFECT_RECOVER_HP && (eff.value1 > 0 || eff.value2 > 0) }
  end
  #-----------------------------------------------------------------------
  # *) Check whether will recover ep
  #-----------------------------------------------------------------------
  def mp_recover?
    return true if @damage.recover? && @damage.to_mp?
    return @effects.any?{|eff| eff.code == EFFECT_RECOVER_MP && (eff.value1 > 0 || eff.value2 > 0) }
  end
  alias :ep_recover? :mp_recover?
  #--------------------
end
                      #===============================#
                      #  ▼ Beware of magic numbers ▼  #
                      #===============================#
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
    ensure_dndattr_correct
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
  def ensure_dndattr_correct
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
    @class_id             = @dualclass_id = 0
    @race_id              = @subrace_id   = 0 
    
    # Initial element for classes' init level and level cap
    init_lvl_ele = [0, DND::BattlerSetting::LevelCap]
    @class_levelcap  = Array.new($data_classes.size, init_lvl_ele)
    @class_levelcap[@class_id][0] = @initial_level
  end
  #------------------------------------------------------------------------
end
#==========================================================================
# ■ RPG::Actor
#==========================================================================
class RPG::Actor < RPG::BaseItem
  #------------------------------------------------------------------------
  # * instance variables
  #------------------------------------------------------------------------
  #tag: charparam
  #tag: actor
  attr_reader :death_graphic        # Graphic filename when K.O
  attr_reader :death_index          # Graphic index
  attr_reader :death_pattern        # Pattern
  attr_reader :death_direction      # Direction
  attr_reader :death_sound
  attr_reader :casting_graphic
  attr_reader :casting_index
  attr_reader :casting_pattern
  attr_reader :icon_index
  attr_reader :parent_class
  attr_reader :dualclass_id, :race_id, :subrace_id
  attr_reader :class_levelcap
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
    super
    apply_default_attributes
    dnd_loading = false
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Character::KOGraphic;   @death_graphic   = $1
      when DND::REGEX::Character::KOIndex;     @death_index     = $1.to_i
      when DND::REGEX::Character::KOPattern;   @death_pattern   = $1.to_i
      when DND::REGEX::Character::KODirection; @death_direction = $1.to_i
      when DND::REGEX::Character::KODirection; @death_sound     = $1.to_i
      when DND::REGEX::Character::CastGraphic; @casting_graphic = $1.to_i
      when DND::REGEX::Character::CastIndex;   @casting_index   = $1.to_i
      when DND::REGEX::Character::CastPattern; @casting_pattern = $1.to_i
      when DND::REGEX::Character::IconIndex;   @icon_index      = $1.to_i
      when DND::REGEX::Character::CastingAnimation; @casting_animation = $1.to_i
      when DND::REGEX::Leveling::LoadStart; dnd_loading = true;
      when DND::REGEX::Leveling::LoadEnd;   dnd_loading = false;
      end
      load_dnd_attribute(line) if dnd_loading
    end
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
    @death_graphic      = DND::BattlerSetting::KOGraphic
    @death_index        = DND::BattlerSetting::KOIndex
    @death_pattern      = DND::BattlerSetting::KOPattern
    @death_direction    = DND::BattlerSetting::KODirection
    @casting_animation  = DND::BattlerSetting::CastingAnimation
    @race_id            = DND::BattlerSetting::DefaultRaceID
    
    @param_adjust = Array.new(8, 0)
    @subrace_id   = @dualclass_id = 0
    
    # Initial element for classes' init level and level cap
    init_lvl_ele = [0, DND::BattlerSetting::LevelCap]
    @class_levelcap  = Array.new($data_classes.size, init_lvl_ele)
    @class_levelcap[@class_id][0] = @initial_level
  end
  #--------------------------------------------------------------------------
end
#==========================================================================
# ■ RPG::Class
#==========================================================================
class RPG::Class < RPG::BaseItem
  #------------------------------------------------------------------------
  # * instance variables
  #------------------------------------------------------------------------
  attr_reader :parent_class
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
    super
    apply_default_attributes
    dnd_loading = false
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Leveling::LoadStart; dnd_loading = true;
      when DND::REGEX::Leveling::LoadEnd;   dnd_loading = false;
      end
      load_dnd_attribute(line) if dnd_loading
    end
  end
  #--------------------------------------------------------------------------
  def load_dnd_attribute(line)
    case line
    when DND::REGEX::Leveling::ClassParent;  @parent_class    = $1.to_i;
    when DND::REGEX::Leveling::HP;           @param_adjust[0] = $1.to_i
    when DND::REGEX::Leveling::EP;           @param_adjust[1] = $1.to_i
    when DND::REGEX::Leveling::Strength;     @param_adjust[2] = $1.to_i
    when DND::REGEX::Leveling::Constitution; @param_adjust[3] = $1.to_i
    when DND::REGEX::Leveling::Intelligence; @param_adjust[4] = $1.to_i
    when DND::REGEX::Leveling::Wisdom;       @param_adjust[5] = $1.to_i
    when DND::REGEX::Leveling::Dexterity;    @param_adjust[6] = $1.to_i
    when DND::REGEX::Leveling::Charisma;     @param_adjust[7] = $1.to_i
    end # last work: dnd attribute class loading
  end
  #--------------------------------------------------------------------------
  def apply_default_attributes
    @parent_class = 0
    @param_adjust = Array.new(8, 0)
  end
  #------------------------------------------------------------------------
  def param(id)
    return $data_classes[@parant_class].param(id) if @parent_class > 0
    return (@param_adjust[id] || 0)
  end
  #--------------------------------------------------------------------------
  # * Get Total EXP Required for Rising to Specified Level
  #--------------------------------------------------------------------------
  def exp_for_level(level)
    return (DND::EXP_FOR_LEVEL[level] * 1000).to_i
  end
  #--------------------------------------------------------------------------
end
#===============================================================================
# * RPG::Skill
#===============================================================================
class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  def is_skill?
    @stype_id == DND::SKILL_STYPE_ID
  end
  #--------------------------------------------------------------------------
  def is_spell?
    @stype_id == DND::SPELL_STYPE_ID
  end
  #--------------------------------------------------------------------------
  def is_vancian?
    @stype_id == DND::VANCIAN_STYPE_ID
  end
  #--------------------------------------------------------------------------
  def is_passive?
    @stype_id == DND::PASSIVE_STYPE_ID
  end
  #--------------------------------------------------------------------------
  def stype_symbol
    case @stype_id
    when DND::SKILL_STYPE_ID;   return :skill;
    when DND::SPELL_STYPE_ID;   return :spell;
    when DND::VANCIAN_STYPE_ID; return :vancian;
    when DND::PASSIVE_STYPE_ID; return :passive;
    end
  end
  #--------------------------------------------------------------------------
end
#===============================================================================
# * RPG::Map
#===============================================================================
class RPG::Map
  #--------------------------------------------------------------------------
  attr_accessor :battle_bgm
  #--------------------------------------------------------------------------
  # * Object initialization
  #--------------------------------------------------------------------------
  alias initialize_dnd initialize
  def initialize(width, height)
    initialize_dnd(width, height)
    @battle_bgm = nil
  end
end
#===============================================================================
# * Position
#===============================================================================
class POS
  #------------------------------------------------------------------------
  # *) public instance variables
  #------------------------------------------------------------------------
  attr_accessor :x, :y, :px, :py, :cx, :cy
  attr_reader :hash
  #------------------------------------------------------------------------
  # *) object initialization
  #------------------------------------------------------------------------
  def initialize(x = 0, y = 0)
    @x, @px = x, x * 4
    @y, @py = y, y * 4
    @cx = Pixel_Core::Default_Collision_X
    @cy = Pixel_Core::Default_Collision_Y
    @hash = hashpos
  end
  #------------------------------------------------------------------------
  def hashpos(x = @x, y = @y)
    return x * 4000 + y
  end
  #------------------------------------------------------------------------
  def ==(pos)
    return @x == pos.x && @y == pos.y
  end
  #------------------------------------------------------------------------
  def screen_x
    $game_map.adjust_x(@x) * 32 + 16
  end
  #------------------------------------------------------------------------
  def screen_y
    $game_map.adjust_y(@y) * 32 + 32
  end
  #------------------------------------------------------------------------
  def screen_z
    return 100
  end
  #------------------------------------------------------------------------
  def pos
    self
  end
  #------------------------------------------------------------------------
  def dead?
    false
  end
  #------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::Weapon
#==============================================================================
class RPG::Weapon < RPG::EquipItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = Vocab.GetDictPath(:weapon)
    DataManager.ensure_file_exist(path)
    filename = path + self.id_for_filename
    filename = Dir.glob(filename + '*').at(0)
    info = ""
    return self.description unless (filename && File.exist?(filename))
    File.open(filename, 'r') do |file|
      while(line = file.gets)
        info += line
      end
    end
    return info.size >= description.size ? info : description
  end
  #--------------------------------------------------------------------------
  # *) attack_bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    return (self.rarity - 1 + super)
  end
  #---------------------------------------------------------------------------
  def is_weapon?; true; end
  #---------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::Armor
#==============================================================================
class RPG::Armor < RPG::EquipItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = Vocab.GetDictPath(:armor)
    DataManager.ensure_file_exist(path)
    filename = path + self.id_for_filename
    filename = Dir.glob(filename + '*').at(0)
    info = ""
    return self.description unless (filename && File.exist?(filename))
    File.open(filename, 'r') do |file|
      while(line = file.gets)
        info += line
      end
    end
    return info.size >= description.size ? info : description
  end
  #---------------------------------------------------------------------
  # *) armor class
  #--------------------------------------------------------------------------
  def armor_class
    (self.rarity - 1 + super)
  end
  #---------------------------------------------------------------------------
  def is_armor?; true; end
  #---------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::Item
#==============================================================================
class RPG::Item < RPG::UsableItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = Vocab.GetDictPath(:item)
    DataManager.ensure_file_exist(path)
    filename = path + self.id_for_filename
    filename = Dir.glob(filename + '*').at(0)
    info = ""
    return self.description unless (filename && File.exist?(filename))
    File.open(filename, 'r') do |file|
      while(line = file.gets)
        info += line
      end
    end
    return info.size >= description.size ? info : description
  end
  #---------------------------------------------------------------------------
  def is_item?; true; end
  #---------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::Skill
#==============================================================================
class RPG::Skill < RPG::UsableItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = Vocab.GetDictPath(:skill)
    DataManager.ensure_file_exist(path)
    filename = path + self.id_for_filename
    filename = Dir.glob(filename + '*').at(0)
    info = ""
    return self.description unless (filename && File.exist?(filename))
    File.open(filename, 'r') do |file|
      while(line = file.gets)
        info += line
      end
    end
    return info.size >= description.size ? info : description
  end
  #---------------------------------------------------------------------------
  def is_skill?; true; end
  #---------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::Event::Page::Condition
#==============================================================================
class RPG::Event::Page::Condition
  
  def code_condition
    @code_condition = [] if @code_condition.nil?
    return @code_condition
  end
  
end
