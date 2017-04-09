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
  
  SkillBar     = [Weapon, Armor, AllSkills, HotKeys, AllItems, Vancians, Follower].flatten
  SkillBarSize = SkillBar.size
  
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
  
  # Sound played when success guarding
  GuardSe = "Hammer"
  
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
  
end
