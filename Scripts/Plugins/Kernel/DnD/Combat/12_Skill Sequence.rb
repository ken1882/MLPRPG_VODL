#==============================================================================
# ** DND::SkillSequence
#------------------------------------------------------------------------------
#  Sequence of action defined of the skill when performed
#==============================================================================
#tag: skill
#tag: sequence
module DND::SkillSequence
  
  ACTS = {
    
    0 => [
            # do nothing
         ],
  
    1 => [
            [:move,  1,  0, 4, 0], [:wait, 4],
            [:move, -1,  1, 4, 0], [:wait, 4],
            [:move, -1, -1, 4, 0], [:wait, 4],
            [:move,  1, -1, 4, 0], [:wait, 4],
            [:move,  0,  1, 4, 0], [:wait, 4],
         ],
         
  }
end
