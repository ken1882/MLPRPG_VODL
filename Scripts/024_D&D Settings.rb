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
    
  end
  #----------------------------------------------------------------------------
end
