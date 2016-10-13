module DND
  
  SKILL_STYPE_ID      =   1
  SPELL_STYPE_ID      =   2
  VANCIAN_STYPE_ID    =   3
  PASSIVE_STPYE_ID    =   4
  
  
  CLASS_ACTIONDC = {
  # id    skill, spell
    1 => ["int", "int"], # Twilight
    2 => ["str", "str"], # Applejack
    4 => ["dex", "cha"], # Pinkie Pie
    5 => ["dex", "dex"], # Rainbow Dash
    6 => ["wis", "cha"], # Rarity
    7 => ["dex", "wis"], # Fluttershy
    
    8 => ["wis", "int"], # Celestia
    9 => ["wis", "int"], # Luna
    
  }
  
  ACTOR_PARAMS  = {
  # cnt       0,   1,   2,   3,   4,   5,   6,   7
  # id      dhp, dmp, str, con, int, wis, dex, cha
    1   => [   6,100,   8,  11,  16,  15,  10,  12],  # Twilight
    2   => [  12,120,  15,  17,   8,  13,  12,  12],  # Applejack
    3   => [   8, 80,  16,  17,  10,  10,  12,  10],  # Spike(useless)
    4   => [  10,130,  14,  16,  10,  10,  16,  16],  # Pinkie
    5   => [   9,110,  16,  14,  10,   8,  17,  13],  # Rainbow Dash
    6   => [   7,100,  10,  12,  14,  17,  13,  16],  # Rarity
    7   => [   8,100,  10,  12,  15,  17,  12,  14],  # Fluttershy
    8   => [  21,200,  17,  24,  32,  26,  18,  30],  # Celestia
    9   => [  18,200,  22,  23,  29,  18,  20,  23],  # Luna
    
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
    20 =>  335,
    21 =>  370,
    22 =>  395,
    23 =>  426,
    24 =>  463,
    25 =>  498,
    26 =>  530,
    27 =>  568,
    28 =>  612,
    29 =>  661,
    30 =>  720,
    31 =>  780,
    32 =>  852,
    33 =>  929,
    34 =>  1024,
    35 =>  1129,
    36 =>  1243,
    37 =>  1362,
    38 =>  1486,
    39 =>  1618,
    40 =>  1759,
    41 =>  1905,
    42 =>  2067,
    43 =>  2239,
    44 =>  2423,
    45 =>  2618,
    46 =>  2841,
    47 =>  3072,
    48 =>  3316,
    49 =>  3584,
    50 =>  3975,
  }
  
  WEAPON_TYPE_NAME = [
    "",
    "Hoof Axe",
    "Horseshoe",
    "Polearm",
    "1H Sword",
    "2H Sword",
    "Bow",
    "Crossbow",
    "Hammer",
    "Mace",
    "Firearm",
    "Arrow",
    "Bolt",
    "Bullet"
  ]
  
  ARMOR_TYPE_NAME = [
  "",
  "Light Armor",
  "Medium Armor",
  "Heavy Armor",
  "Clothing",
  "Shield",
  "Great Shield",
  "Hooves",
  "Belt",
  "Necklace",
  "Cloak",
  "Ring",
  "Greave",
  "Rune",
  "Gem",
  
  ]
  
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
  
end # DataManager
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop).
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :level
  attr_accessor :class
  attr_accessor :skills                   # learned skill
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_dndlevel initialize
  def initialize(index, enemy_id)
    @level = 1
    init_dndlevel(index, enemy_id)
    @class = enemy.note =~ /<Boss HP Meter>/ ? "Boss" : "Minon"
    @class = enemy.note =~ /<Elite>/ ? "Elite" : "Minon"
    @level = enemy.note =~ /<Level = (\d+)>/i ? $1.to_i : 1.to_i unless enemy.nil?
    @skills = []
    get_learned_skills
  end
end
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
  
  def physical?; @property.include?(3) end
  def magical?;  @property.include?(4) end
  
  #----------------
end
#===============================================================================
#   RPG::Enemy
#===============================================================================
class RPG::Enemy < RPG::BaseItem
  
  def attack_bonus
    super
  end
  
  def armor_class
    super
  end
  
end
#==============================================================================
# ** RPG::EquipItem
#------------------------------------------------------------------------------
#  This class handle the RPG::Weapon and RPG::Armor class.
#
#==============================================================================
class RPG::EquipItem < RPG::BaseItem
  
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
    super
  end
  #---------------------------------------------------------------------
  # *) Physical?
  #--------------------------------------------------------------------------
  def physical?
    true
  end
  #---------------------------------------------------------------------
  # *) Magical?
  #--------------------------------------------------------------------------
  def magical?
    false
  end
  
  def physical?; super end
  def magical?; super end
  #--------------------
  
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
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
    @last_skill = Game_BaseItem.new
  end
  #--------------------------------------------------------------------------
  # * Get Total EXP Required for Rising to Specified Level
  #--------------------------------------------------------------------------
  def exp_for_level(level)
    return (DND::EXP_FOR_LEVEL[level] * 1000).to_i
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
    self.class.attack_bonus
  end
  #--------------------------------------------------------------------------
  # * Attack Bonus Plus
  #--------------------------------------------------------------------------
  def attack_bonus_plus
    
    value = 0
    #------------------------------------------------
    #   process equips effect
    #------------------------------------------------
    equips.compact.each do |equip|
      value += equip.attack_bonus
    end
    #------------------------------------------------
    #   process state effect
    #------------------------------------------------
    states.compact.each do |state_id|
      if state_id.is_a?(RPG::State)
        value += state_id.attack_bonus
      else
        value += $data_states[state_id].attack_bonus
      end
    end
    
    return value
  end
  #--------------------------------------------------------------------------
  # * Armor Class
  #--------------------------------------------------------------------------
  def armor_class
    param_modifier( get_param_id('DEX') ) + armor_calss_base + armor_class_plus
  end
  #--------------------------------------------------------------------------
  # * Armor Class Base
  #--------------------------------------------------------------------------
  def armor_calss_base
    self.class.armor_class
  end
  #--------------------------------------------------------------------------
  # * AC Plus
  #--------------------------------------------------------------------------
  def armor_class_plus
    
    value = 0
    #------------------------------------------------
    #   process equips effect
    #------------------------------------------------
    equips.compact.each do |equip|
      value += equip.armor_class
    end
    #------------------------------------------------
    #   process state effect
    #------------------------------------------------
    states.compact.each do |state_id|
      if state_id.is_a?(RPG::State)
        value += state_id.attack_bonus
      else
        value += $data_states[state_id].attack_bonus
      end
    end
    
    return value
  end
  
  #------------
end
  
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop).
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_dnd initialize
  def initialize(index, enemy_id)
    initialize_dnd(index, enemy_id)
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
    self.enemy.attack_bonus
  end
  #--------------------------------------------------------------------------
  # * Attack Bonus Plus
  #--------------------------------------------------------------------------
  def attack_bonus_plus
    
    value = 0
    #------------------------------------------------
    #   process state effect
    #------------------------------------------------
    states.compact.each do |state_id|
      if state_id.is_a?(RPG::State)
        value += state_id.attack_bonus
      else
        value += $data_states[state_id].attack_bonus
      end
    end
    
    return value
  end
  #--------------------------------------------------------------------------
  # * Armor Class
  #--------------------------------------------------------------------------
  def armor_class
    param_modifier( get_param_id('DEX') ) + armor_calss_base + armor_class_plus
  end
  #--------------------------------------------------------------------------
  # * Armor Class Base
  #--------------------------------------------------------------------------
  def armor_calss_base
    self.enemy.armor_class
  end
  #--------------------------------------------------------------------------
  # * AC Plus
  #--------------------------------------------------------------------------
  def armor_class_plus
    
    value = 0
    #------------------------------------------------
    #   process state effect
    #------------------------------------------------
    states.compact.each do |state_id|
      if state_id.is_a?(RPG::State)
        value += state_id.attack_bonus
      else
        value += $data_states[state_id].attack_bonus
      end
    end
    
    return value
  end
  
  #------------
end
#==============================================================================
# Class RPG::Class
#==============================================================================
class RPG::Class < RPG::BaseItem
  #---------------------------------------------------------------------
  # *) Initialize D&D params
  #---------------------------------------------------------------------
  def initialize_dndparams
    @params = Table.new(8,100)
    (1..99).each do |i|
      (0...1).each {|j| @params[j,i] = DND::ACTOR_PARAMS[id][j] * i}
      (1...8).each {|j| @params[j,i] = DND::ACTOR_PARAMS[id][j] }
    end
  end
  
end
