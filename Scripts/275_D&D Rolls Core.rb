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
