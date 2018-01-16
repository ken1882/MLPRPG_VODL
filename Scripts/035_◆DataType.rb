#===============================================================================
# * Basic Object
#===============================================================================
class Object
  #------------------------------------------------------------------------
  # * Set hashid
  #------------------------------------------------------------------------
  def hash_self
    PONY.hashid_table[@hashid] = self
    return @hashid
  end
  #------------------------------------------------------------------------
  def hashid
    hash_self if @hashid.nil?
    return @hashid
  end
  #------------------------------------------------------------------------
  def to_bool
    return true
  end  
end
#===============================================================================
# * True/Flase class
#===============================================================================
class TrueClass
  def to_i
    return 1
  end
end
class FalseClass
  def to_i
    return 0
  end
end
#==============================================================================
# ■ Numeric
#==============================================================================
class Numeric
  
end
#===============================================================================
# * Basic Fixnum class
#===============================================================================
class Fixnum
  #----------------------------------------------------------------------------
  alias plus +
  def +(*args)
    plus(*args)
  end
  #----------------------------------------------------------------------------
  alias minus -
  def -(*args)
    minus(*args)
  end
  #----------------------------------------------------------------------------
  alias bigger >
  def >(*args)
    bigger(*args)
  end
  #----------------------------------------------------------------------------
  alias ebigger >=
  def >=(*args)
    ebigger(*args)
  end
  #----------------------------------------------------------------------------
  alias smaller <
  def <(*args)
    smaller(*args)
  end
  #----------------------------------------------------------------------------
  alias esmaller <=
  def <=(*args)
    esmaller(*args)
  end
  #----------------------------------------------------------------------------
  alias :divid :/
  def /(*args)
    divid(*args)
  end
  #----------------------------------------------------------------------------
  # *) Convert to radians
  #----------------------------------------------------------------------------
  def to_rad
    self * Math::PI / 180
  end
  #----------------------------------------------------------------------------
  # *) Convert to boolean
  #----------------------------------------------------------------------------
  def to_bool
    self == 0 ? false : true
  end
  #----------------------------------------------------------------------------
  # *) String for filename
  #----------------------------------------------------------------------------
  def to_fileid(deg)
    n = self
    cnt = 0
    while n > 0
      n /= 10
      cnt += 1
    end
    cnt = [cnt, 1].max
    PONY::ERRNO.raise(:fileid_overflow, :exit) if cnt > deg
    return ('0' * (deg - cnt)) + self.to_s
  end
  #----------------------------------------------------------------------------
  # * To second in frame
  #----------------------------------------------------------------------------
  def to_sec
    return (self / Graphics.frame_rate).to_i + 1
  end
  #----------------------------------------------------------------------------
  def set_bit(index, n)
    n = n.to_i rescue nil
    if n.nil?
      PONY::ERRNO.raise(:datatype_error, nil, nil, "Nil bit given")
      return
    elsif n != 1 && n != 0
      puts "n: #{n}"
      PONY::ERRNO.raise(:datatype_error, nil, nil, "Bit operation excess 0/1")
      return
    end
    
    return self |  (1 << index) if n == 1
    return self & ~(1 << index)
  end
  alias setbit set_bit
  alias sb set_bit
  #----------------------------------------------------------------------------
end
class NilClass
  #----------------------------------------------------------------------------
  # *) Convert to boolean
  #----------------------------------------------------------------------------
  def to_bool
    false
  end
end
#===============================================================================
# * Basic String class
#===============================================================================
class String  
  #----------------------------------------------------------------------------
  # *) Delete a char at certain position
  #----------------------------------------------------------------------------
  def delete_at(pos)
    return if pos >= self.size
    self[pos] = ''
  end
  
end
#===============================================================================
# * Array
#===============================================================================
class Array
  
  def swap_at(loc_a, loc_b)
    self[loc_a], self[loc_b] = self[loc_b], self[loc_a]
  end
  
  def x
    self[0]
  end
  
  def y
    self[1]
  end
  
  def z
    self[2]
  end
  
end
#===============================================================================
# Module Math
#===============================================================================
module Math
  #-----------------------------------------------------------------------------
  # * Module variables
  #-----------------------------------------------------------------------------
  @rotation_cache = {}
  #-----------------------------------------------------------------------------
  # * Get rotated position
  #-----------------------------------------------------------------------------
  def self.rotation_matrix(x, y, angle, flip = false)
    key  = (x * 10000 + y * 360 + angle)
    key *= flip ? -1 : 1
    if !@rotation_cache[key]
      rx = x * Math.cos(angle.to_rad) - y * Math.sin(angle.to_rad)
      ry = x * Math.sin(angle.to_rad) + y * Math.cos(angle.to_rad)
      ry *= -1 if flip
      @rotation_cache[key] = [rx.round(6), ry.round(6)]
    end
    return @rotation_cache[key]
  end
  #-----------------------------------------------------------------------------
  def self.slope(x1, y1, x2, y2)
    return nil if x2 == x1
    return (y2 - y1).to_f / (x2 - x1)
  end
  #-----------------------------------------------------------------------------
  # *) in arc:
  #
  # x1, y1: target coord
  # x2, y2: source coord
  # angle1, angle2: left's and right's Generalized Angle
  # distance: effective distance
  #-----------------------------------------------------------------------------
  def self.in_arc?(x1, y1, x2, y2, angle1, angle2, distance, original_dir)
    return false if self.hypot( x2 - x1, y2 - y1 ) > distance
    move_x = $game_map.width / 2
    move_y = $game_map.height / 2
    
    x1 = x1 - move_x
    y1 = move_y - y1
    x2 = x2 - move_x
    y2 = move_y - y2
    
    left_x    = x2 + self.rotation_matrix(1,0, angle1).at(0)
    left_y    = y2 + self.rotation_matrix(1,0, angle1).at(1)
    right_x   = x2 + self.rotation_matrix(1,0, angle2).at(0)
    right_y   = y2 + self.rotation_matrix(1,0, angle2).at(1)
    m1 = slope(x2, y2, left_x, left_y)
    m2 = slope(x2, y2, right_x, right_y)
    on_m1_right = on_m2_left = true
    
    offset1 = (left_y - m1 * left_x)
    offset2 = (right_y - m2 * right_x)
    delta   = m2 - m1
    delta_x = offset1 - offset2
    cx = delta_x.to_f / delta
    
    if m1.nil?
      on_m1_right = (angle1 == 90 ? x1 >= x2 : x1 <= x2)
    else
      if [4,7,8,9].include?(original_dir)
        on_m1_right = y1 >= m1 * x1 + offset1
      else
        on_m1_right = y1 <= m1 * x1 + offset1
      end
    end
    
    if m2.nil?
      on_m2_left = (angle2 == 270 ? x1 >= x2 : x1 <=x2)
    else
      if [4,1,2,3].include?(original_dir)
        on_m2_left = y1 <= m2 * x1 + offset2
      else
        on_m2_left = y1 >= m2 * x1 + offset2
      end
    end
    return on_m1_right && on_m2_left
  end
end
#===============================================================================
# * Mutex
#===============================================================================
class Mutex
  #----------------------------------------------------------------------------
  def synchronize
    self.lock
    begin
      puts "[Thread]: Yield Block"
      yield
    ensure
      self.unlock rescue nil
      puts "[Thread]: Block completed"
    end
  end
end
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
# ■ RPG::BaseItem
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
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
    apply_default_attributes
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
      when DND::REGEX::Leveling::DNDRace;      @race_id         = $1.to_i
      when DND::REGEX::Leveling::DNDClass;     @class_id        = $1.to_i
      when DND::REGEX::Leveling::DNDDualClass; @dualclass_id    = $1.to_i
      end
    end
  end
  #--------------------------------------------------------------------------
  def apply_default_attributes
    @death_graphic      = DND::BattlerSetting::KOGraphic
    @death_index        = DND::BattlerSetting::KOIndex
    @death_pattern      = DND::BattlerSetting::KOPattern
    @death_direction    = DND::BattlerSetting::KODirection
    @casting_animation  = DND::BattlerSetting::CastingAnimation
  end
  #--------------------------------------------------------------------------
end
#==========================================================================
# ■ RPG::BaseItem
#==========================================================================
class RPG::BaseItem
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
      when DND::REGEX::SAVING_THROW_ADJUST; @saving_throw_adjust[$1.to_i] = $2.to_i
      when DND::REGEX::DC_ADJUST;           @difficulty_class_adjust[$1.to_i] = $2.to_i
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
  # new method: get element id
  #--------------------------------------------------------------------------
  def get_element_id(string)
    string = string.upcase
    for i in 0...$data_system.elements.size
      return i if string == $data_system.elements[i].upcase
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # new method: get param id
  #--------------------------------------------------------------------------
  def get_param_id(string)
    string = string.downcase.to_sym
    _id = 0
    if     string == :str then _id = 2
    elsif  string == :con then _id = 3
    elsif  string == :int then _id = 4
    elsif  string == :wis then _id = 5
    elsif  string == :dex then _id = 6
    elsif  string == :cha then _id = 7
    end
    return _id
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
  attr_accessor :x, :y
  attr_reader :hash
  #------------------------------------------------------------------------
  # *) object initialization
  #------------------------------------------------------------------------
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
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
end
#==============================================================================
# ** RPG::Weapon
#==============================================================================
class RPG::Weapon < RPG::EquipItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = "History/Weapons/"
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
end
#==============================================================================
# ** RPG::Armor
#==============================================================================
class RPG::Armor < RPG::EquipItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = "History/Armors/"
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
end
#==============================================================================
# ** RPG::Item
#==============================================================================
class RPG::Item < RPG::UsableItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = "History/Items/"
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
end
#==============================================================================
# ** RPG::Skill
#==============================================================================
class RPG::Skill < RPG::UsableItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = "History/Skills/"
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
#===============================================================================
# * Overwrite the exit method to program-friendly
#===============================================================================
def exit(stat = true)
  $exited = true
  SceneManager.scene.fadeout_all rescue nil
  Cache.release
  SceneManager.exit
end
