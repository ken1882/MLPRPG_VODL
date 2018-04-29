
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
  #---------------------------------------------------------------------------
  def is_skill?;  false; end
  def is_item?;   false; end
  def is_weapon?; false; end
  def is_armor?;  false; end
  #---------------------------------------------------------------------------  
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
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
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
    end
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
  end
  #------------------------------------
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
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
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
      when DND::REGEX::Leveling::EP;   dnd_loading = false;
      when DND::REGEX::Leveling::HP;   dnd_loading = false;
      when DND::REGEX::Leveling::ClassParent;   dnd_loading = false;    
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
        @class_id = $1.to_i
        @class_id = DND::BattlerSetting::DefaultClassID if !(@class_id || 0).to_bool
      when DND::REGEX::Leveling::DualClass; @dualclass_id    = $1.to_i
    end
  end
  #--------------------------------------------------------------------------
  def apply_default_attributes
    @death_graphic      = DND::BattlerSetting::KOGraphic
    @death_index        = DND::BattlerSetting::KOIndex
    @death_pattern      = DND::BattlerSetting::KOPattern
    @death_direction    = DND::BattlerSetting::KODirection
    @casting_animation  = DND::BattlerSetting::CastingAnimation
    @race_id            = DND::BattlerSetting::DefaultRaceID
    @subrace_id = @dualclass_id = 0 
  end
  #--------------------------------------------------------------------------
  def base_hp
    return @parent_class.base_hp if @parent_class
    return @base_hp
  end
  #--------------------------------------------------------------------------
  def base_ep
    return @parent_class.base_ep if @parent_class
    return @base_ep
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
  #tag: class
  
  attr_reader :parent_class
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
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
      when DND::REGEX::Leveling::EP;   @base_ep = $1.to_i;
      when DND::REGEX::Leveling::HP;   @base_hp = $1.to_i;
      when DND::REGEX::Leveling::ClassParent;   @parent_class = false;    
    end # last work: dnd attribute class loading
  end
  #--------------------------------------------------------------------------
  def apply_default_attributes
    @base_hp = @base_ep = 0
    @parent_class = 0
  end
  #--------------------------------------------------------------------------
  def base_hp
    return @parent_class.base_hp if @parent_class
    return @base_hp
  end
  #--------------------------------------------------------------------------
  def base_ep
    return @parent_class.base_ep if @parent_class
    return @base_ep
  end
  #--------------------------------------------------------------------------
end
#==========================================================================
# ■ RPG::BaseItem
#==========================================================================
class RPG::BaseItem
  include DND::Utility
  #------------------------------------------------------------------------
  # * public instance variables
  #------------------------------------------------------------------------
  # tag: equiparam
  attr_accessor :user_graphic        # Graphic display on user
  attr_accessor :tool_cooldown       # Cooldown after use
  attr_accessor :tool_graphic        # Projectile graphic
  attr_accessor :weapon_skill        # Skill apply when weapon hitted
  attr_accessor :tool_index          # Projectile graphic index
  attr_accessor :tool_distance       # Effective distance
  attr_accessor :tool_effectdelay    # Effect delay after exeucuted (frame)
  attr_accessor :tool_destroydelay   # Graphic removal delay after completed
  attr_accessor :tool_speed          # Projectile speed
  attr_accessor :tool_castime        # Cast time
  attr_accessor :tool_castanimation  # Animation during casting
  attr_accessor :tool_blowpower      # Knockback enemy when hitted
  attr_accessor :tool_piercing       # Pierece amount of effect executed
  
  attr_accessor :tool_animation      # Animation display on collide
  attr_accessor :tool_animmoment     # Animation display moment
                                     # 1: Display on projectile
                                     # 0: Display on recipient
                                      
  attr_accessor :tool_special        # Special attributes
  attr_accessor :tool_special_param  # 0: Nothing
                                     # 1: Projectile jump to neartest next
                                     # target, parameter: max jump count
                                     #
                                     # 2: Projectile will reflect after collide
                                     # parameter: max reflection count
                                      
  attr_accessor :tool_scope          # Effective scope range on execute
  attr_accessor :tool_scopedir       # Effective direction, 0 = same as battler
                                     # direction = 1~9, 5 = all direction
                                     
  attr_accessor :tool_scopeangle     # 0 = all_direction, 1~359 otherwise
  attr_accessor :tool_invoke         # Invoke other skill(id) on execute
  attr_accessor :tool_soundeffect    # Sound effect played on execuute
  attr_accessor :tool_itemcost       # Specified item(id) required
  attr_accessor :tool_itemcost_type  # Item type(id) required
  attr_accessor :tool_through        # Projectile through map obstacles
  attr_accessor :tool_priority       # Graphic priority display, same as event's
  attr_accessor :tool_hitshake       # Screen shake level when hitted (uint)
  attr_accessor :tool_type           # Tool Type, 0 = missile, 1 = bomb
  attr_accessor :tool_combo          # Next Weapon id use after player contiune
                                     # to using this tool(default: in 20 frames)
                                     
  attr_reader   :scope               # Damage::Scope
  attr_reader   :information         # Linked to folder /History
  attr_reader   :action_sequence
  attr_reader   :dmg_saves           # Saving throw type when executed
  #------------------------------------------------------------------------
  attr_accessor :saving_throw_adjust
  attr_accessor :difficulty_class_adjust
  attr_accessor :property
  attr_accessor :damage_index
  attr_accessor :physical_damage_modify
  attr_accessor :magical_damage_modify
  attr_accessor :item_own_max
  #---------------------------------------------------------------------------
  def load_notetags_dndsubs
    @saving_throw_adjust      = [0,0,0,0,0,0,0,0]
    @difficulty_class_adjust  = [0,0,0,0,0,0,0,0]
    @property                 = 0
    @damage_index             = []
    @physical_damage_modify   = 0
    @magical_damage_modify    = 0
    @block_by_event           = false
    @item_own_max             = 10
    ensure_property_correct
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::REGEX::SAVING_THROW_ADJUST
        @saving_throw_adjust = $1.split(',').collect{|i| i.to_i}
      when DND::REGEX::DC_ADJUST
        @difficulty_class_adjust = $1.split(',').collect{|i| i.to_i}
      when DND::REGEX::PROJ_BLOCK_BY_EVENT; @block_by_event = true
      when DND::REGEX::ITEM_MAX;            @item_own_max = $1.to_i
      when DND::REGEX::PHY_DMG_MOD;         @physical_damage_modify = $1.to_i
      when DND::REGEX::MAG_DMG_MOD;         @magical_damage_modify = $1.to_i
      when DND::REGEX::DAMAGE
        element_id = get_element_id($3)
        time = $1.split('d').at(0)
        face = $1.split('d').at(1)
        mod_id = get_param_id($4)
        @damage_index.push( [time.to_i,face.to_i,$2.to_i,element_id,mod_id])
        puts "[BaseItem Damage]:#{self.name}: #{time}d#{face} + (#{$2.to_i}), element:#{$3}(#{element_id}) modifier: #{$4}(#{mod_id})"
      else
        load_item_property(line)
      end
    } # self.note.split
    @tool_distance     += 0.4
    @tool_scope        += 0.4
    @information = load_help_information
  end
  #---------------------------------------------------------------------------
  def load_item_property(line)
    case line
    when DND::REGEX::MAGIC_EFFECT
      @property |= PONY::Bitset[0]
    when DND::REGEX::DEBUFF && self.is_a?(RPG::State)
      @property |= PONY::Bitset[1]
    when DND::REGEX::POISON && self.is_a?(RPG::State)
      @property |= PONY::Bitset[2]
    when DND::REGEX::IS_PHYSICAL
      @property |= PONY::Bitset[3]
    when DND::REGEX::IS_MAGICAL
      @property |= PONY::Bitset[4]
    when DND::REGEX::Leveling::Leveling
      @property |= PONY::Bitset[5]
    end
    load_item_features(line)
  end
  #---------------------------------------------------------------------------
  def load_item_features(line)
    case line
    when DND::REGEX::Equipment::UserGraphic
      @user_graphic = $1.downcase == 'nil' ? nil : $1
    when DND::REGEX::Equipment::ToolGraphic
      @tool_graphic = $1.downcase == 'nil' ? nil : $1
    when DND::REGEX::Equipment::WeaponEffect;      @weapon_skill       = $1.to_i;
    when DND::REGEX::Equipment::ToolIndex;         @tool_index         = $1.to_i;
    when DND::REGEX::Equipment::CoolDown;          @tool_cooldown      = $1.to_i;
    when DND::REGEX::Equipment::ToolDistance;      @tool_distance      = $1.to_i;
    when DND::REGEX::Equipment::ToolEffectDelay;   @tool_effectdelay   = $1.to_i;
    when DND::REGEX::Equipment::ToolDestroyDelay;  @tool_destroydelay  = $1.to_i;
    when DND::REGEX::Equipment::ToolSpeed;         @tool_speed         = $1.to_f;
    when DND::REGEX::Equipment::ToolCastime;       @tool_castime       = $1.to_i;
    when DND::REGEX::Equipment::ToolCastAnimation; @tool_castanimation = $1.to_i;
    when DND::REGEX::Equipment::ToolBlowPower;     @tool_blowpower     = $1.to_i;
    when DND::REGEX::Equipment::ToolPiercing;      @tool_piercing      = $1.to_i;
    when DND::REGEX::Equipment::ToolAnimation;     @tool_animation     = $1.to_i;    
    when DND::REGEX::Equipment::ToolAnimMoment;    @tool_animmoment    = $1.to_i;
    #---------------------------------------------------------------------------
    when DND::REGEX::Equipment::ToolSpecial
      @tool_special       = $1.to_i
      @tool_special_param = $2.to_i | 0
    #---------------------------------------------------------------------------
    when DND::REGEX::Equipment::ToolScope;         @tool_scope         = $1.to_i;
    when DND::REGEX::Equipment::ToolScopeDir;      @tool_scopedir      = $1.to_i;
    when DND::REGEX::Equipment::ToolScopeAngle;    @tool_scopeangle    = $1.to_i;
    when DND::REGEX::Equipment::ToolInvokeSkill;   @tool_invoke        = $1.to_i;
    when DND::REGEX::Equipment::ToolSE
      @tool_soundeffect[0] = $1 unless $1.strip.downcase == 'nil'
      @tool_soundeffect[1] = $2.to_i if $2
    when DND::REGEX::Equipment::ToolItemCost;      @tool_itemcost      = $1.to_i;
    when DND::REGEX::Equipment::ToolItemCostType;  @tool_itemcost_type = $1.to_i;
    when DND::REGEX::Equipment::ToolThrough;       @tool_through       = $1.to_i.to_bool;
    when DND::REGEX::Equipment::ToolPriority;      @tool_priority      = $1.to_i;
    when DND::REGEX::Equipment::ToolType;          @tool_type          = $1.to_i; 
    when DND::REGEX::Equipment::ToolHitShake;      @tool_hitshake      = $1.to_i;
    when DND::REGEX::Equipment::ToolCombo;         @tool_combo         = $1.to_i;
    when DND::REGEX::Equipment::ApplyAction;       @action_sequence    = $1.to_i;
    when DND::REGEX::Equipment::DamageSavingThrow
      @dmg_saves = [DND::SavingThrow::List[$1], $2]
    end
  end
  #---------------------------------------------------------------------------
  def ensure_property_correct
    @tool_animation     = 0
    @tool_distance      = 2
    @tool_animmoment    = 0
    @tool_castime       = 0
    @tool_itemcost      = 0
    @tool_itemcost_type = 0
    @tool_scope         = 1
    @tool_scopedir      = 5
    @tool_scopeangle    = 0
    @tool_blowpower     = 0
    @tool_combo         = 0
    @action_sequence    = 0
    @tool_effectdelay   = 0
    @tool_itemcost      = 0
    @tool_itemcost_type = 0
    @dmg_saves          = nil
    @tool_soundeffect   = [nil, 80]
  end
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
  end
  #------------------------------------------------------------------------
  # *) Item need consume items
  #------------------------------------------------------------------------  
  def item_required?
    return (@tool_itemcost || 0) > 0 || (@tool_itemcost_type || 0) > 0
  end
  #------------------------------------------------------------------------
  # *) Item is an ammo?
  #------------------------------------------------------------------------  
  def is_ammo?
    return false if !self.is_a?(RPG::Weapon)
    _id = self.wtype_id
    return [11, 12, 13].include?(_id)
  end
  #------------------------------------------------------------------------
  # * Is_magic?
  #------------------------------------------------------------------------
  def is_magic?
    return (@property & PONY::Bitset[0]).to_bool
  end
  #------------------------------------------------------------------------
  # * Is_debuff?
  #------------------------------------------------------------------------
  def is_debuff?
    return (@property & PONY::Bitset[1]).to_bool
  end
  #------------------------------------------------------------------------
  # * Is_poison?
  #------------------------------------------------------------------------
  def is_poison?
    return (@property & PONY::Bitset[2]).to_bool
  end
  #------------------------------------------------------------------------
  # * For leveling?
  #------------------------------------------------------------------------
  def for_leveling?
    return (@property & PONY::Bitset[5]).to_bool
  end
  #------------------------------------------------------------------------
  # * Is a spell?
  #------------------------------------------------------------------------
  def is_spell?
    return false if self.nil?
    return false if !self.is_a?(RPG::Skill)
    return true  if is_magic?
  end
  #------------------------------------------------------------------------
  def attack_type
    return :melee  if melee?
    return :magic  if is_magic?
    return :ranged
  end
  #------------------------------------------------------------------------
  def melee?
    return @tool_distance < 2.5
  end
  #--------------------------------------------------------------------------
  def ranged?
    return !melee?
  end
  #--------------------------------------------------------------------------
  # Item Scope Queries
  #--------------------------------------------------------------------------
  def for_none?; return @scope == 0; end
  def for_opponent?; return [1, 2, 3, 4, 5, 6].include?(@scope); end
  def for_friend?; return [7, 8, 9, 10, 11].include?(@scope); end
  def for_dead_friend?; return [9, 10].include?(@scope); end
  def for_user?; return @scope == 11; end
  def for_one?; return [1, 3, 7, 9, 11].include?(@scope); end
  def for_random?; return [3, 4, 5, 6].include?(@scope); end
  def for_all?; return [2, 8, 10].include?(@scope); end
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
