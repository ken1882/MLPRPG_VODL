#tag: param
module DND
  
  SKILL_STYPE_ID      =   1
  SPELL_STYPE_ID      =   2
  VANCIAN_STYPE_ID    =   3
  PASSIVE_STYPE_ID    =   4
  
  CLASS_ACTIONDC = {
  # id    skill, spell/save
    1  => [:str, :con],    # Barbarian
    2  => [:dex, :cha],    # Bard
    3  => [:wis, :cha],    # Cleric
    4  => [:int, :wis],    # Druid
    5  => [:str, :con],    # Fighter
    6  => [:str, :dex],    # Monk
    7  => [:str, :wis],    # Paladin
    8  => [:str, :dex],    # Ranger
    9  => [:dex, :int],    # Rogue
    10 => [:con, :cha],    # Sorcerer
    11 => [:wis, :cha],    # Warlock
    12 => [:wis, :int],    # Wizard
    13 => [:cha, :int],    # Arch-Mage
    
  }
  
  ACTOR_PARAMS  = {
  # cnt       0,   1,   2,   3,   4,   5,   6,   7
  # id      dhp, dmp, str, con, int, wis, dex, cha
    1   => [   6,100,  10,  11,  18,  16,   9,  14],  # Twilight
    2   => [  12,120,  17,  16,  10,  11,  13,  11],  # Applejack
    3   => [   8, 80,  12,  12,  12,  12,  12,  12],  # Spike(useless)
    4   => [  10,130,  12,  14,  11,  12,  14,  15],  # Pinkie
    5   => [   9,110,  14,  13,   9,  11,  18,  13],  # Rainbow Dash
    6   => [   7,100,  11,  12,  12,  14,  11,  18],  # Rarity
    7   => [   8,100,   9,  12,  14,  17,  10,  16],  # Fluttershy
    8   => [  21,200,  18,  20,  22,  24,  16,  20],  # Celestia
    9   => [  18,200,  22,  19,  20,  21,  18,  17],  # Luna
    
   10   => [   8,  5,  10,  10,  10,  10,  10,  10],
   11   => [   8,  5,  10,  10,  10,  10,  10,  10],
   12   => [   8,  5,  10,  10,  10,  10,  10,  10],
   13   => [   8,  5,  10,  10,  10,  10,  10,  10],
   14   => [   8,  5,  10,  10,  10,  10,  10,  10],
   15   => [   8,  5,  10,  10,  10,  10,  10,  10],
  }
  
  EXP_FOR_LEVEL = {
  # lv    require xp(/1000)
    1  =>  0,
    2  =>  0.3,
    3  =>  0.9,
    4  =>  2.7,
    5  =>  6.5,
    6  =>  14,
    7  =>  23,
    8  =>  34,
    9  =>  48,
    10 =>  64,
    11 =>  85,
    12 =>  100,
    13 =>  120,
    14 =>  140,
    15 =>  165,
    16 =>  195,
    17 =>  225,
    18 =>  265,
    19 =>  305,
    20 =>  355,
    21 =>  410,
    22 =>  472,
    23 =>  558,
    24 =>  650,
    25 =>  750,
    26 =>  862,
    27 =>  986,
    28 => 1120,
    29 => 1260,
    30 => 1414,
    31 => 1732,
    32 => 1905,
    33 => 2088,
    34 => 2278,
    35 => 2473,
    36 => 2675,
    37 => 2880,
    38 => 3088,
    39 => 3308,
    40 => 3530,
    41 => 3758,
    42 => 3990,
    43 => 4225,
    44 => 4665,
    45 => 4720,
    46 => 5252,
    47 => 5534,
    48 => 5828,
    49 => 6140,
    50 => 6535,
  }
  
  
  
end
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class << self; alias load_database_dnd_parameter load_database; end
  def self.load_database
    $dnd_info = []
    load_database_dnd_parameter
    load_notetags_dnd_parameter
    load_class_dndparameter
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_dnd
  #--------------------------------------------------------------------------
  def self.load_notetags_dnd_parameter
    groups = [$data_armors,$data_weapons,$data_actors,$data_classes,$data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_dnd_parameter
      end
    end
  end
  #--------------------------------------------------------------------------
  # new method: load_dndparameter
  #--------------------------------------------------------------------------
  def self.load_class_dndparameter
    for obj in $data_classes
      next if obj.nil?
      obj.initialize_dndparams
    end
  end
  #--------------------------------------------------------------------------
end # DataManager
#==============================================================================
# ** RPG::BaseItem
#------------------------------------------------------------------------------
#  This base handle the classes below: RPG::State, RPG::Enemy, RPG::Equipitem
#  RPG::UsableItem, RPG::Class, RPG::Actor
#==============================================================================
class RPG::BaseItem
  
  attr_accessor :thac0
  attr_accessor :ac
  #--------------------------------------------------------------------------
  # *)  load notetags
  #--------------------------------------------------------------------------
  def load_notetags_dnd_parameter
    @thac0 = 0
    @ac    = 0
    
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::REGEX::THAC0
        @thac0 = $1.to_i
      when DND::REGEX::ARMOR_CLASS
        @ac = $1.to_i
      end
    } # self.note.split
    #---
  end
  
  #--------------------------------------------------------------------------
  # *) attack_bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    value = @thac0.nil? ? 0 : @thac0
    #--------------------------------------------------------------
    #   get hit rate in features
    #--------------------------------------------------------------
    @features.each do |feat|
      if feat.code == 22    # xparam
        value += (feat.value * 20).to_i if feat.data_id == 0  # hit
      end
    end
    
    return value
  end
  #---------------------------------------------------------------------
  # *) armor class
  #--------------------------------------------------------------------------
  def armor_class
    value = @ac.nil? ? 0 : @ac
    #--------------------------------------------------------------
    #   get evasion rate in features
    #--------------------------------------------------------------
    @features.each do |feat|
      if feat.code == 22   # xparam
        value += (feat.value * 20).to_i if feat.data_id == 1  # eva
      end
    end
    
    return value
  end
  #---------------------------------------------------------------------------
  def wield_speed
    return 60 - @tool_cooldown
  end
  #---------------------------------------------------------------------------
  def physical?
    return (@property & PONY::Bitset[3]).to_bool
  end
  #---------------------------------------------------------------------------
  def magical?
    return (@property & PONY::Bitset[4]).to_bool
  end
  #----------------
end
#===============================================================================
#   RPG::Enemy
#===============================================================================
class RPG::Enemy < RPG::BaseItem
  #--------------------------------------------------------------------------
  def attack_bonus
    super
  end
  #--------------------------------------------------------------------------
  def armor_class
    super
  end
  #--------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::EquipItem
#------------------------------------------------------------------------------
#  This class handle the RPG::Weapon and RPG::Armor class.
#
#==============================================================================
class RPG::EquipItem < RPG::BaseItem
  
  #---------------------------------------------------------------------------
  # *) attack_bonus
  #---------------------------------------------------------------------------
  def attack_bonus
    super
  end
  #---------------------------------------------------------------------------
  # *) armor class
  #---------------------------------------------------------------------------
  def armor_class
    super
  end
  #---------------------------------------------------------------------------
  # *) Physical?
  #---------------------------------------------------------------------------
  def physical?
    true
  end
  #---------------------------------------------------------------------------
  # *) Magical?
  #---------------------------------------------------------------------------
  def magical?
    false
  end
  #---------------------------------------------------------------------------
  def wield_speed
    return 60 - @tool_cooldown
  end
  #---------------------------------------------------------------------------
  def physical?; super end
  def magical?; super end
  #----------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::Weapon
#==============================================================================
class RPG::Weapon < RPG::EquipItem
  #--------------------------------------------------------------------------
  # *) attack_bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    (self.rarity - 1 + super)
  end
  #---------------------------------------------------------------------
  # *) armor class
  #--------------------------------------------------------------------------
  def armor_class
    super
  end
  
  def physical?; super end
  def magical?; super end
  #--------------------
end
#==============================================================================
# ** RPG::Armor
#==============================================================================
class RPG::Armor < RPG::EquipItem
  #--------------------------------------------------------------------------
  # *) attack_bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    super
  end
  #---------------------------------------------------------------------
  # *) armor class
  #--------------------------------------------------------------------------
  def armor_class
    (self.rarity - 1 + super)
  end
  
  def physical?; super end
  def magical?; super end
  #--------------------
end
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  attr_accessor :attack_bonus_pool
  attr_accessor :armor_class_pool
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_battler_dnd initialize
  def initialize
    @attack_bonus_pool = {}
    @armor_class_pool  = {}
    init_battler_dnd
  end
  #--------------------------------------------------------------------------
  # * Attack Bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    attack_bonus_base + attack_bonus_plus
  end
  #--------------------------------------------------------------------------
  # * Attack Bonus Base
  #--------------------------------------------------------------------------
  def attack_bonus_base
    return 0
  end
  #--------------------------------------------------------------------------
  # * Attack Bonus Plus
  #--------------------------------------------------------------------------
  def attack_bonus_plus
    value = 0
    @attack_bonus_pool.each_value do |plus|
      value += plus
    end
    #------------------------------------------------
    # * process state effect
    #------------------------------------------------
    states.compact.each do |state|
      state = $data_states[state] if state.is_a?(Fixnum)
      value += (state_id.attack_bonus || 0)
    end
    return value
  end
  #--------------------------------------------------------------------------
  # * Armor Class
  #--------------------------------------------------------------------------
  def armor_class
    param_modifier( get_param_id(:dex) ) + armor_class_base + armor_class_plus
  end
  #--------------------------------------------------------------------------
  # * Armor Class Base
  #--------------------------------------------------------------------------
  def armor_class_base
    return 0
  end
  #--------------------------------------------------------------------------
  # * AC Plus
  #--------------------------------------------------------------------------
  def armor_class_plus
    value = 0
    @armor_class_pool.each_value do |plus|
      value += plus
    end
    #------------------------------------------------
    # * process state effect
    #------------------------------------------------
    states.compact.each do |state|
      state = $data_states[state] if state.is_a?(Fixnum)
      value += (state_id.attack_bonus || 0)
    end
    return value
  end
  #------------
end
#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Get Total EXP Required for Rising to Specified Level
  #--------------------------------------------------------------------------
  def exp_for_level(level)
    return (DND::EXP_FOR_LEVEL[level] * 1000).to_i
  end
  #--------------------------------------------------------------------------
  # * Attack Bonus Base
  #--------------------------------------------------------------------------
  def attack_bonus_base
    self.class.attack_bonus
  end
  #--------------------------------------------------------------------------
  # * Armor Class Base
  #--------------------------------------------------------------------------
  def armor_class_base
    self.class.armor_class
  end
  #--------------------------------------------------------------------------
  # * AC Plus
  #--------------------------------------------------------------------------
  def armor_class_plus
    value = super
    #------------------------------------------------
    # * process equips effect
    #------------------------------------------------
    equips.compact.each do |equip|
      value += equip.armor_class
    end
    return value
  end
  #--------------------------------------------------------------------------
  # * Attack Bonus Plus
  #--------------------------------------------------------------------------
  def attack_bonus_plus
    value = super
    #------------------------------------------------
    # * process equips effect
    #------------------------------------------------
    equips.compact.each do |equip|
      value += equip.attack_bonus
    end
    return value
  end
end
  
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop).
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Attack Bonus Base
  #--------------------------------------------------------------------------
  def attack_bonus_base
    self.enemy.attack_bonus
  end
  #--------------------------------------------------------------------------
  # * Armor Class Base
  #--------------------------------------------------------------------------
  def armor_class_base
    self.enemy.armor_class
  end
  #------------
end