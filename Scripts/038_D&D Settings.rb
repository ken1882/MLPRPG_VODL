#===============================================================================
# * Module DND
#-------------------------------------------------------------------------------
#   General settings, configs, and regexp etc. of core system
#===============================================================================
module DND
  #=============================================================================
  # * Graphics Settings
  #=============================================================================
  module Graphics
    # Melee weapon wielding angles
    Wield_Angles = {
      2 => [ 80, 110, 140, 170],
      4 => [340,  10,  40,  70],
      6 => [290, 260, 230, 200],
      8 => [290, 320, 350,  20],
    }
    
    # Angles address correction
    Wield_Dir_Offest = {
      2 => [-8, -10],
      4 => [ 0, -10],
      6 => [ 0,  -4],
      8 => [ 4, -10],
    }
    
    # Z Axis value correction
    Wield_Depth_Correction = { 2 => 120, 4 => 50, 6 => 120, 8 => 50 }
  end
  #=============================================================================
  # * Color Settings
  #=============================================================================
  module COLOR
    HPHeal            = Color.new( 15, 140,  10)
    EPHeal            = Color.new(140, 230, 110)
    HPDamage          = Color.new(250,  45,  45)
    EPDamage          = Color.new(175,  55, 140)
    
    Black             = Color.new(  0,   0,   0)
    White             = Color.new(255, 255, 255)
    Red               = Color.new(255,   0,   0)
    Blue              = Color.new(  0,   0, 255)
    Green             = Color.new(  0, 255,   0)
    Yellow            = Color.new(255, 255,   0)
    Purple            = Color.new(128,   0, 255)
    Orange            = Color.new(255, 128,   0)
    Brown             = Color.new(128,  64,   0)
    Pink              = Color.new(255, 128, 255)
    Tan               = Color.new(200, 200, 110)
    
    HitPoint          = Green
    EnergyPoint       = Color.new(100, 200, 255)
  end
  #=============================================================================
  # * Battler Settings
  #=============================================================================
  module BattlerSetting
    RegenerateTime    = 30
    PhaseIdle         = 0
    PhaseCombat       = 1
    DefaultWeapon     = 0
    TeamID            = 1
    DeathSwitchSelf   = nil
    DeathSwitchGlobal = 0
    DeathVarSelf      = nil
    DeathVarGlobal    = [0, 0]
    VisibleSight      = 8
    BlindSight        = 0
    DeathAnimation    = 114
    Infravision       = false
    MoveLimit         = 30
    AggressiveLevel   = 4
    BodySize          = 1
    KOGraphic         = "$Coffin"
    KOIndex           = 0
    KOPattern         = 0
    KODirection       = 8
    CastingAnimation  = 162
    DefaultRaceID     = 119
    DefaultClassID    = 119
  end
  #=============================================================================
  # * Corresponding class and subclass to its original class
  #=============================================================================
  module ClassID
    Barbarian   = [1, 15, 16]
    Bard        = [2, 17, 18]
    Cleric      = [3, 19, 20, 21, 22, 23, 24, 25, 26, 27]
    Druid       = [4, 28, 29, 30, 31, 32, 33, 34, 35, 36]
    Fighter     = [5, 37, 38, 39]
    Monk        = [6, 40, 41, 42]
    Paladin     = [7, 43, 44, 45]
    Ranger      = [8, 46, 47]
    Rogue       = [9, 48, 49, 50]
    Sorcerer    = [10, 51, 52, 53, 54]
    Warlock     = [11, 55, 56, 57]
    Wizard      = [12, 58, 59, 60, 61, 62, 63, 64, 65]
    
    PrimaryPathes =[
      Barbarian, Bard, Cleric, Druid, Fighter, Monk, Paladin, Ranger, Rogue,
      Sorcerer, Warlock, Wizard,
    ]
    
  end
  #=============================================================================
  # * Saving type
  #=============================================================================
  module SavingThrow
    List = {
      "1/2"           => :halfdmg,
      "Neg."          => :nullify,
      "None"          => nil,
      nil             => nil
    }
  end
  
  # Enemy rank
  Rank  = [
    :critter,
    :minion,
    :elite,
    :captain,
    :chief,
  ]
  
  # Basic attack type
  AttackType = [
    :melee,
    :magic,
    :ranged,
  ]
  
  # Detail info description of item
  ItemParamDec = {
    :weapon => [:wtype, :speed, :range, :damage],
    :armor  => [:atype, :ac],
    :skill  => [:stype, :cost, :casting, :range, :cooldown, :save, :damage],
    :item   => [:cooldown, :range, :save, :damage],
  }
  #----------------------------------------------------------------------------
end
