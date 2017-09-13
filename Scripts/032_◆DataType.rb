#===============================================================================
# * Basic Object
#===============================================================================
class Object
  #------------------------------------------------------------------------
  # * Set hashid
  #------------------------------------------------------------------------
  def hash_self
  end
  #------------------------------------------------------------------------
  def hashid
    hash_self if @hashid.nil?
    return @hashid
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
  def to_sec
    return (self / 60).to_i + 1
  end
  
  def self
    return PONY.EncInt(self)
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
  # * Get rotated position
  #-----------------------------------------------------------------------------
  def self.rotation_matrix(x, y, angle, flip = false)
    rx = x * Math.cos(angle.to_rad) - y * Math.sin(angle.to_rad)
    ry = x * Math.sin(angle.to_rad) + y * Math.cos(angle.to_rad)
    ry *= -1 if flip
    return [rx.round(6), ry.round(6)]
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
    dict = "Items/"   if self.is_a?(RPG::Item)
    dict = "Weapons/" if self.is_a?(RPG::Weapon)
    dict = "Armors/"  if self.is_a?(RPG::Armor)
    dict = "Skills/"  if self.is_a?(RPG::Skill)
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
  
  attr_accessor :face_name  # Face filename show in map status window
  attr_accessor :face_index # Face index
  attr_accessor :body_size
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
      @default_weapon = $data_weapons[$1.to_i]
      puts "[System]: #{self.name}'s default weapon: #{@default_weapon.name}" if @default_weapon != 1
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
    end
  end
  #--------------------------------------------------------------------------
  # tag: 2
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
    @face_name            = nil
    @face_index           = 0
    @body_size            = DND::BattlerSetting::BodySize
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
  attr_reader :death_graphic        # Graphic filename when K.O
  attr_reader :death_index          # Graphic index
  attr_reader :death_pattern        # Pattern
  attr_reader :death_direction      # Direction
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Character::KOGraphic;   @death_graphic   = $1
      when DND::REGEX::Character::KOIndex;     @death_index     = $1.to_i
      when DND::REGEX::Character::KOPattern;   @death_pattern   = $1.to_i
      when DND::REGEX::Character::KODirection; @death_direction = $1.to_i
      end
    end
  end
  
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
    @property                 = []
    @damage_index             = []
    @physical_damage_modify   = 0
    @magical_damage_modify    = 0
    @block_by_event           = false
    @item_own_max             = 10
    
    @property.push(0)
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
    
    ensure_property_correct
  end
  #---------------------------------------------------------------------------
  def load_item_property(line)
    case line
    when DND::REGEX::POISON && self.is_a?(RPG::State)
      @property.push(2)
    when DND::REGEX::DEBUFF && self.is_a?(RPG::State)
      @property.push(1)
    when DND::REGEX::MAGIC_EFFECT
      @property.push(0)
    when DND::REGEX::IS_PHYSICAL
      @property.push(3)
    when DND::REGEX::IS_MAGICAL
      @property.push(4)
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
    when DND::REGEX::Equipment::ToolSE;            @tool_soundeffect   = $1;
    when DND::REGEX::Equipment::ToolItemCost;      @tool_itemcost      = $1.to_i;
    when DND::REGEX::Equipment::ToolItemCostType;  @tool_itemcost_type = $1.to_i;
    when DND::REGEX::Equipment::ToolThrough;       @tool_through       = $1.to_i.to_bool;
    when DND::REGEX::Equipment::ToolPriority;      @tool_priority      = $1.to_i;
    when DND::REGEX::Equipment::ToolType;          @tool_type          = $1.to_i; 
    when DND::REGEX::Equipment::ToolHitShake;      @tool_hitshake      = $1.to_i;
    when DND::REGEX::Equipment::ToolCombo;         @tool_combo         = $1.to_i;
    when DND::REGEX::Equipment::ApplyAction;       @action_sequence    = $1.to_i;
    end
  end
  #---------------------------------------------------------------------------
  def ensure_property_correct
    #@scope = @tool_scope ? 0 : @tool_scope unless @scope
    @tool_animation     = 0     unless @tool_animation
    @tool_distance      = 8     unless @tool_distance
    @@tool_animmoment   = 0     unless @tool_animmoment
    @tool_castime       = 0     unless @tool_castime
    @tool_itemcost      = 0     unless @tool_itemcost
    @tool_itemcost_type = 0     unless @tool_itemcost_type
    @tool_scope         = 1     unless @tool_scope
    @tool_scopedir      = 5     unless @tool_scopedir
    @tool_scopeangle    = 0     unless @tool_scopeangle
    @action_sequence    = 0     unless @action_sequence
    @tool_distance     += 0.5
    @tool_scope        += 0.5
  end
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = "History/"
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
  #------------------------------------------------------------------------
  # *) Item need consume items
  #------------------------------------------------------------------------  
  def item_required?
    @tool_itemcost != 0 || !@tool_itemcost_type.nil?
  end
  #------------------------------------------------------------------------
  # *) Item is an ammo?
  #------------------------------------------------------------------------  
  def is_ammo?
    return false if !self.is_a?(RPG::Weapon)
    _id = self.wtype_id
    return true if _id == 11 || _id == 12 || _id == 13
    return false
  end
  #------------------------------------------------------------------------
  # is_magic?
  #------------------------------------------------------------------------
  def is_magic?
    @property.include?(0)
  end
  #------------------------------------------------------------------------
  # is_debuff?
  #------------------------------------------------------------------------
  def is_debuff?
    @property.include?(1)
  end
  #------------------------------------------------------------------------
  # is_poison?
  #------------------------------------------------------------------------
  def is_poison?
    @property.include?(2)
  end
  #------------------------------------------------------------------------
  # is a spell?
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
    string = string.upcase
    _id = 0
    if     string == "STR" then _id = 2
    elsif  string == "CON" then _id = 3
    elsif  string == "INT" then _id = 4
    elsif  string == "WIS" then _id = 5
    elsif  string == "DEX" then _id = 6
    elsif  string == "CHA" then _id = 7
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
    return x * 1000 + y
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
#===============================================================================
# * Overwrite the exit method to program-friendly
#===============================================================================
def exit(stat = true)
  $exited = true
  SceneManager.scene.fadeout_all rescue nil
  SceneManager.exit
end
