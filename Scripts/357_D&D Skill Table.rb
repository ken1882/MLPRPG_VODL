#==============================================================================
# ** Dungeons and Dragons
#------------------------------------------------------------------------------
#  Skill: skill stuff, such as level charges
#==============================================================================
#tag: vancian
#tag: skill
#tag: state
#==============================================================================
# ** DND::SkillCharges
#------------------------------------------------------------------------------
#  This module calculate the charge times for each skill of level
#==============================================================================
module DND::SkillCharges
  #-----------------------------------------------------------------------------
  # * Barbarian's rage
  #-----------------------------------------------------------------------------
  def self.Rage(level)
    return 2 if level < 3
    return 3 if level < 9
    return 4 if level < 13
    return 5 if level < 17
    return 6 if level < 20
    return 99
  end
  
end
#==============================================================================
# ** DND::SkillModify
#------------------------------------------------------------------------------
#  This module calculate various effects of skill or state
#==============================================================================
module DND::SkillModify
  #-----------------------------------------------------------------------------
  # * Attack bonus plus of Barbarian's rage
  #-----------------------------------------------------------------------------
  def self.RageTHAC0(level)
    return 2 if level < 9
    return 3 if level < 16
    return 4 if level < 22
    return 5 if level < 30
    return 6 if level < 37
    return 7 if level < 46
    return 8
  end
  
end
