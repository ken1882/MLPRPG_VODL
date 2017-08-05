#===============================================================================
# * PONY::SkillBar
#-------------------------------------------------------------------------------
#   Tool/SkillBar Set up 
#===============================================================================
# tag: hotkey
module PONY::SkillBar
  # Layout graphic
  LayoutImage = "Skillbar"
  
  # Follower attack command icon index
  FollowerIcon = 11
  
  AllSkillIcon = 143
  VancianIcon  = 141
  AllItemIcon  = 1528
  
  LastPageIon  = 2238
  NextPageIon  = 2237
  
  
  HotKeySelection = 1
  AllSelection    = 2
  CastSelection   = 3
  
  Follower_Flag = FollowerIcon
  AllItem_Flag  = AllItemIcon
  AllSkill_Flag = AllSkillIcon
  Vancian_Flag  = VancianIcon
  
  LastPage_Flag = LastPageIon
  NextPage_Flag = NextPageIon
  
  def self.hide
    $game_system.skillbar_enable = true
  end
  
  def self.show
    $game_system.skillbar_enable = nil
  end
  
  def self.hidden?
    !$game_system.skillbar_enable.nil?
  end
end
#===============================================================================
# * HotKeys
#-------------------------------------------------------------------------------
#   Hot Key Settings
#===============================================================================
module HotKeys
  
  Weapon       = :kR
  Armor        = :kF
  HotKeys      = [:k1, :k2, :k3, :k4, :k5, :k6, :k7, :k8, :k9, :k0]
  AllSkills    = :kTILDE
  AllItems     = :kMINUS
  Vancians     = :kEQUAL
  SwitchMember = [:kF3, :kF4, :kF5]
  QuickSave    = :kF7
  QuickLoad    = :kF8
  Follower     = :kC
  
  SkillBar     = [Weapon, Armor, Follower, AllSkills, HotKeys, AllItems, Vancians].flatten
  SkillBarSize = SkillBar.size
  HotkeyStartLoc = 4
  
  Menu         = :kESC
  Journal      = :kJ
  Inventory    = :kI
  Talents      = :kT
  Pause        = :kSPACE
  
  Letter = {
    :kCOLON => ':',        :kAPOSTROPHE => 39.chr, :kQUOTE => 39.chr,
    :kCOMMA => ',',        :kPERIOD => '.',        :kSLASH => 47.chr,
    :kBACKSLASH => 92.chr, :kLEFTBRACE => '(',     :kRIGHTBRACE => ')',
    :kMINUS => '-',        :kUNDERSCORE => '_',    :kPLUS => '+',
    :kEQUAL => '=',        :kEQUALS => '=',        :kTILDE => '~',
  }
  
  def self.name(key)
    Letter.each do  |name, ch|
      return ch if key == name
    end
    base = key.to_s
    base = base[1].upcase + base[2...base.length].downcase
    return base
  end
  
  def self.tool_index(key)
    return if key.nil?
    n = SkillBar.size
    for i in 0...n
      return i if key == SkillBar[i]
    end
  end
  
  def self.assigned_hotkey_index(index)
    return index - HotkeyStartLoc
  end
  
end
