#tag: param
module DND
  
  SKILL_STYPE_ID      =   1
  SPELL_STYPE_ID      =   2
  VANCIAN_STYPE_ID    =   3
  PASSIVE_STYPE_ID    =   4
  
  CLASS_ACTIONDC = {
  # id    skill, spell/vancian/save
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
  
      # cnt       0,   1,   2,   3,   4,   5,   6,   7
      # id      dhp, dmp, str, con, int, wis, dex, cha
  Base_Param  = [   8,  5,  10,  10,  10,  10,  10,  10]
  
  Base_Attack = 0
  Base_AC     = 10
  
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
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Attack Bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    attack_bonus_base + attack_bonus_plus
  end
  #--------------------------------------------------------------------------
  # * Armor Class
  #--------------------------------------------------------------------------
  def armor_class
    param_modifier( get_param_id(:dex) ) + armor_class_base + armor_class_plus
  end
  #--------------------------------------------------------------------------
  def attack_bonus_base
    return DND::Base_Attack
  end
  #--------------------------------------------------------------------------
  def attack_bonus_plus
    return feature_objects.inject(0){|r,obj| r += (obj.attack_bonus | 0)}
  end
  #--------------------------------------------------------------------------
  def armor_class_base
    return DND::Base_AC
  end
  #--------------------------------------------------------------------------
  def armor_class_plus
    return feature_objects.inject(0){|r,obj| r += (obj.attack_bonus | 0)}
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
end
  
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop).
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Attack Bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    self.enemy.attack_bonus
  end
  #--------------------------------------------------------------------------
  # * Armor Class
  #--------------------------------------------------------------------------
  def armor_class
    self.enemy.armor_class
  end
  #------------
end
#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. It includes event starting determinants and
# map scrolling functions. The instance of this class is referenced by
# $game_player.
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Attack Bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    self.actor.attack_bonus
  end
  #--------------------------------------------------------------------------
  # * Armor Class
  #--------------------------------------------------------------------------
  def armor_class
    self.actor.armor_class
  end
  #------------
end
#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * Attack Bonus
  #--------------------------------------------------------------------------
  def attack_bonus
    self.actor.attack_bonus
  end
  #--------------------------------------------------------------------------
  # * Armor Class
  #--------------------------------------------------------------------------
  def armor_class
    self.actor.armor_class
  end
  #------------
end
