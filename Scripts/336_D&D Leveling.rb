#==============================================================================
# ** DND::Leveling
#------------------------------------------------------------------------------
#   Leveling features of DND, this module handles definitions of these features
#==============================================================================
# tag: leveling
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
  attr_reader :queued_levelings    # Feats waiting to be select & added
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_gmar initialize
  def initialize(actor_id)
    @queued_levelings = []
    init_gmar(actor_id)
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: Level Up
  #--------------------------------------------------------------------------
  def level_up
    @level += 1
    self.class.level_up
    self.class.learnings.each do |learning|
      next unless learning.level == @level
      id    = learning.skill_id
      skill = $data_skills[id]
      if skill.for_leveling?
        @queued_levelings.push(id)
      else
        learn_skill(id)
      end # if for leveling
    end # learnings.each
    $game_map.need_refresh = true
  end # last work: dnd leveling system
  #--------------------------------------------------------------------------
end
