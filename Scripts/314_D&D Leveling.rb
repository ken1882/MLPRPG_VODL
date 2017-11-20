#==============================================================================
# ** DND::Leveling
#------------------------------------------------------------------------------
#   Leveling features of DND, this module handles definitions of these features
#==============================================================================
# tag: leveling
# last work: dnd leveling system
module DND::Leveling
  
end
#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Learn Skill
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    unless skill_learn?($data_skills[skill_id])
      @skills.push(skill_id)
      @skills.sort!
    end
  end
end
