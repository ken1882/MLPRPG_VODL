
#==========================================================================
# ■ RPG::BaseItem
#==========================================================================
class RPG::BaseItem
  
  #------------------------------------------------------------------------
  # public instance variables
  #------------------------------------------------------------------------
  attr_accessor :saving_throw_adjust
  attr_accessor :difficulty_class_adjust
  attr_accessor :property
  attr_accessor :damage_index
  attr_accessor :physical_damage_modify
  attr_accessor :magical_damage_modify
  attr_accessor :item_own_max
  #------------------------------------------------------------------------
  # common cache: load_notetags_dndsubs
  #------------------------------------------------------------------------  
  def load_notetags_dndsubs
    @saving_throw_adjust      = [0,0,0,0,0,0,0,0]
    @difficulty_class_adjust  = [0,0,0,0,0,0,0,0]
    @property                 = []
    @damage_index             = []
    @physical_damage_modify   = 0
    @magical_damage_modify    = 0
    @block_by_event           = false
    @item_own_max             = 10
    
    if self.is_spell?
      @property.push(0)
      p sprintf("%10s: %30s%6s %5s",self.class,self.name,'(' + self.id.to_s + ')',"is a magic stuff") if self.name.size > 1
    end
    
    self.note.split(/[\r\n]+/).each { |line|
      _property = ""
      
      case line
      when DND::REGEX::SAVING_THROW_ADJUST
        @saving_throw_adjust[$1.to_i] = $2.to_i
        #p sprintf("[Attack Block]:%s's saving throw[%d] adjust:%d",self.name,$1.to_i,@saving_throw_adjust[$1.to_i])
      when DND::REGEX::DC_ADJUST
        @difficulty_class_adjust[$1.to_i] = $2.to_i
        #p sprintf("[Attack Block]:%s's DC[%d] adjust:%d",self.name,$1.to_i,@difficulty_class_adjust[$1.to_i])
      when DND::REGEX::POISON && self.is_a?(RPG::State)
        @property.push(2)
        #_property = "is a poison"
      when DND::REGEX::DEBUFF
        @property.push(1) if self.is_a?(RPG::State)
        #_property = "is a debuff"
      when DND::REGEX::MAGIC_EFFECT
        @property.push(0)
        #_property = "is a magic stuff"
      when DND::REGEX::IS_PHYSICAL
        @property.push(3)
      when DND::REGEX::IS_MAGICAL
        @property.push(4)
      when DND::REGEX::PROJ_BLOCK_BY_EVENT
        @block_by_event = true
      when DND::REGEX::ITEM_MAX
        @item_own_max = $1.to_i
      when DND::REGEX::DAMAGE
        element_id = get_element_id($3)
        time = $1.split('d').at(0)
        face = $1.split('d').at(1)
        mod_id = get_param_id($4)
        @damage_index.push( [time.to_i,face.to_i,$2.to_i,element_id,mod_id])
        puts "[BaseItem Damage]:#{self.name}: #{time}d#{face} + (#{$2.to_i}), element:#{$3}(#{element_id}) modifier: #{$4}(#{mod_id})"
      when DND::REGEX::PHY_DMG_MOD
        @physical_damage_modify = $1.to_i
        _property = sprintf("has physical damage mod: %d", @physical_damage_modify)
      when DND::REGEX::MAG_DMG_MOD
        @magical_damage_modify = $1.to_i
        _property = sprintf("has magical damage mod: %d", @magical_damage_modify)
      end
      
      p sprintf("%10s: %30s%6s %5s",self.class,self.name,'(' + self.id.to_s + ')',_property) if _property.size > 1
    } # self.note.split
  end
  #------------------------------------------------------------------------
  # common cache: load_notetags_dndsubs
  #------------------------------------------------------------------------  
  def load_notetags_dndparams
    
    return unless self.is_a?(RPG::Actor) || self.is_a?(RPG::Enemy)
    
    @base_damages = []
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::REGEX::DAMAGE
        element_id = get_element_id($3)
        time = $1.split('d').at(0)
        face = $1.split('d').at(1)
        mod_id = get_param_id($4)
        @damage_index.push( [time.to_i,face.to_i,$2.to_i,element_id,mod_id])
        puts "[Enemy Damage]:#{self.name}: #{time}d#{face} + (#{$2.to_i}), element:#{$3}(#{element_id}) modifier: #{$4}(#{mod_id})"
      end
    } # self.note.split
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
    return false if nil?
    return false if !self.is_a?(RPG::Skill)
    return true if is_magic?
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
  
end # RPG::BaseItem
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_dndsubs load_database; end
  def self.load_database
    $data_notetagged_items = []
    load_database_dndsubs
    load_notetags_dndsubs
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_war
  #--------------------------------------------------------------------------
  def self.load_notetags_dndsubs
    groups = [$data_items, $data_weapons, $data_armors,$data_skills,$data_states, $data_enemies, $data_actors]
    
    p sprintf("[Attack Block]:load note tags")
    for group in groups
      for obj in group
        next if obj.nil?
        obj.hash_self
        obj.load_notetags_dndsubs
        #obj.load_notetags_dndparams
      end
    end
  end
  #------------------------------
end # DataManager
#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Constants (Features)
  #--------------------------------------------------------------------------
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :wprof
  attr_reader   :aprof
  attr_reader   :lskills
  attr_reader   :lskill_bonus
  attr_accessor :result_critical
  attr_accessor :result_miss
  
  #--------------------------------------------------------------------------
  # * Access Method by Parameter Abbreviations
  #--------------------------------------------------------------------------
  def mhp;  param(0) + (( (self.def-10)/2) * @level/2).to_i;   end # MHP + CON bonus
  def attack_bonus;  xparam(0);   end               # Attack Bonus
  def armor_class;   xparam(1);   end               # Armor Class
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_battler_dnd initialize
  def initialize
    @lskills      = Table.new(18)
    @lskill_bonus = Table.new(18)
    @wprof = Table.new(DND::WEAPON_TYPE_NAME.size)
    @aprof = Table.new(DND::ARMOR_TYPE_NAME.size)
    @result_critical = false
    @result_miss = false
    
    initialize_battler_dnd
  end
  #--------------------------------------------------------------------------
  # * new method: proficiency
  #--------------------------------------------------------------------------
  def proficiency
    return ((level+1)/4 + 0.5).to_i + 1
  end
  #--------------------------------------------------------------------------
  # * new method: proficiency
  #--------------------------------------------------------------------------
  def param_modifier(param_id)
    return 0 if param_id.nil? || param_id == 0
    return (( param(param_id) - 9.5) / 2 ).to_i
  end
  
  #--------------------------------------------------------------------------
  # * Get score ability id
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
  # * new method: rolld20
  #--------------------------------------------------------------------------
  def roll(time, face)
    roll = 0
    (0...time).each do |i|
      roll += 1 + rand(face)
    end
    return roll
  end
  
  
  #--------------------------------------------------------------------------
  # * new method: lskill_save
  #--------------------------------------------------------------------------
  def lskill_save(type,bonus,dc,user = nil,item = nil)
    type = get_param_id(type) if type.is_a?(String)
    
    dc = actionDC(user,item)
    base_roll = roll(1,20)
    return true  if base_roll == 20
    return false if base_roll == 1
    
    
    return result
  end
  #-----------------------------------------------------
end
