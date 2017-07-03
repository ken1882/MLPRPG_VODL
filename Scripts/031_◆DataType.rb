#===============================================================================
# * RGSS3 Object
#===============================================================================
class Object
  #----------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------
  def check(string)
    self.each_line { |i| return true if i =~ /#{string}/i }
    return false
  end
  #----------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------
  def get(string,default = nil)    
    self.each_line { |i| return i.gsub("#{string} = ", "").chomp if i =~ /#{string} = /i }
    return default
  end
end
#===============================================================================
# * Basic Fixnum class
#===============================================================================
class Fixnum
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
    PONY::ERRNO.raise(:intid_overflow, :exit) if cnt > deg
    return ('0' * (deg - cnt)) + self.to_s
  end
  
  def to_sec
    return (self / 60).to_i + 1
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
  
end
#===============================================================================
# * Bitset
#===============================================================================
class Bitset
  
  def initialize(n = 0)
    raise ArgumentError, "Argument must be an integer" unless n.is_a?(Integer)
    @index = []
    while n > 0
      @index.unshift(n & 1)
      n >>= 1
    end
  end
  
  def [](index)
    return @index[index]
  end
  
  def each
    @index.each{|bin| yield bin } if block_given?
  end
  
  def to_i(n = 2)
    to_s.to_i(n)
  end
  
  def to_s
    str = ""
    @index.each{|bin| str << bin.to_s}
    return str.to_s
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
#==============================================================================
# ** RPG::Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop). 
#==============================================================================
class RPG::Enemy
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :default_weapon
  attr_accessor :recover
  attr_accessor :team_id
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def load_character_attributes
    
    @defalut_weapon = 1
    @recover        = 30
    @team_id        = 1
    
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::REGEX::DEFAULT_WEAPON
        @default_weapon = $1.to_i
        puts "[Enemy Weapon]: #{self.name}'s default weapon: #{$data_weapons[@default_weapon].name}" if @default_weapon != 1
      when DND::REGEX::TeamID
        @team_id = $1.to_i
      end
    } # self.note.split
    #---
  end
  #------------------------------------
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
  attr_accessor :tool_index          # Projectile graphic index
  attr_accessor :tool_distance       # Effective distance
  attr_accessor :tool_effectdelay    # Effect delay after exeucuted (frame)
  attr_accessor :tool_destroydelay   # Graphic removal delay after completed
  attr_accessor :tool_speed          # Projectile speed
  attr_accessor :tool_castime        # Cast time
  attr_accessor :tool_castanimation  # Animation during casting
  attr_accessor :tool_blowpower      # Knockback enemy when hitted
  attr_accessor :tool_piercing       # Pierece amount of effect executed
  
  attr_accessor :tool_animmoment     # Animation display moment
                                     # 0: Display on projectile
                                     # 1: Display on recipient
                                      
  attr_accessor :tool_special        # Special attributes
  attr_accessor :tool_special_param  # 0: Nothing
                                     # 1: Projectile jump to neartest next
                                     # target, parameter: max jump count
                                     #
                                     # 2: Projectile will reflect after collide
                                     # parameter: max reflection count
                                      
  attr_accessor :tool_scope          # Target scope, same as Damage::Scope
  attr_accessor :tool_invoke         # Invoke other skill(id) on execute
  attr_accessor :tool_soundeffect    # Sound effect played on execuute
  attr_accessor :tool_itemcost       # Specified item(id) required
  attr_accessor :tool_itemcosttype   # Item type(id) required
  attr_accessor :tool_through        # Projectile through map obstacles
  attr_accessor :tool_priority       # Graphic priority display, same as event's
  attr_accessor :tool_hitshake       # Screen shake level when hitted (uint)
  attr_accessor :tool_type           # Tool Type, 0 = missile, 1 = bomb
  attr_accessor :tool_combo          # Next Weapon id use after player contiune
                                     # to using this tool(default: in 20 frames)
                                     
  attr_reader   :scope               # Inheritance of :tool_scope
  attr_reader   :information         # Linked to folder /History
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
    when DND::REGEX::Equipment::UserGraphic;       @user_graphic       = $1 
    when DND::REGEX::Equipment::ToolGraphic;       @tool_graphic       = $1
    when DND::REGEX::Equipment::ToolIndex;         @tool_index         = $1.to_i
    when DND::REGEX::Equipment::CoolDown;          @tool_cooldown      = $1.to_i
    when DND::REGEX::Equipment::ToolDistance;      @tool_distance      = $1.to_i
    when DND::REGEX::Equipment::ToolEffectDelay;   @tool_effectdelay   = $1.to_i
    when DND::REGEX::Equipment::ToolDestroyDelay;  @tool_destroydelay  = $1.to_i
    when DND::REGEX::Equipment::ToolSpeed;         @tool_speed         = $1.to_f
    when DND::REGEX::Equipment::ToolCastime;       @tool_castime       = $1.to_i
    when DND::REGEX::Equipment::ToolCastAnimation; @tool_castanimation = $1.to_i
    when DND::REGEX::Equipment::ToolBlowPower;     @tool_blowpower     = $1.to_i
    when DND::REGEX::Equipment::ToolPiercing;      @tool_piercing      = $1.to_i
    when DND::REGEX::Equipment::ToolAnimMoment;    @tool_animmoment    = $1.to_i
    #---------------------------------------------------------------------------
    when DND::REGEX::Equipment::ToolSpecial
      @tool_special       = $1.to_i
      @tool_special_param = $2.to_i | 0
    #---------------------------------------------------------------------------
    when DND::REGEX::Equipment::ToolScope;         @tool_scope         = $1.to_i
    when DND::REGEX::Equipment::ToolInvokeSkill;   @tool_invoke        = $1.to_i
    when DND::REGEX::Equipment::ToolSE;            @tool_soundeffect   = $1
    when DND::REGEX::Equipment::ToolItemCost;      @tool_itemcost      = $1.to_i
    when DND::REGEX::Equipment::ToolItemCostType;  @tool_itemcosttype  = $1.to_i
    when DND::REGEX::Equipment::ToolThrough;       @tool_through       = $1.to_i.to_bool
    when DND::REGEX::Equipment::ToolPriority;      @tool_priority      = $1.to_i
    when DND::REGEX::Equipment::ToolType;          @tool_type          = $1.to_i  
    when DND::REGEX::Equipment::ToolHitShake;      @tool_hitshake      = $1.to_i
    when DND::REGEX::Equipment::ToolCombo;         @tool_combo         = $1.to_i
    end
  end
  #---------------------------------------------------------------------------
  def ensure_property_correct
    @scope = @tool_scope ? 0 : @tool_scope unless @scope
    @tool_castime  = 0 unless @tool_castime
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
    @tool_itemcost != 0 || !@tool_itemcosttype.nil?
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
# * Position
#===============================================================================
class POS
  #------------------------------------------------------------------------
  # *) public instance variables
  #------------------------------------------------------------------------
  attr_accessor :x, :y
  #------------------------------------------------------------------------
  # *) object initialization
  #------------------------------------------------------------------------
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end
  #------------------------------------------------------------------------
  def hashpos
    return @x * 1000 + @y
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
