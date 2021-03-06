#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================
class Game_BattlerBase
  include DND::Utility
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
  def attack_bonus;  xparam(0);   end               # Attack Bonus
  def armor_class;   xparam(1);   end               # Armor Class
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_battler_dnd initialize
  def initialize
    @lskills      = Table.new(18)
    @lskill_bonus = Table.new(18)
    @wprof = Table.new(Vocab::DND::WEAPON_TYPE_NAME.size)
    @aprof = Table.new(Vocab::DND::ARMOR_TYPE_NAME.size)
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
    return 0 if param_id.nil? || param_id < 3
    return (( param(param_id) - 10) / 2 ).to_i
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
