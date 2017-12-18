#==============================================================================
# Class RPG::Class
#==============================================================================
class RPG::Class < RPG::BaseItem
  # tag: queued >> D&D Class Settings
  #---------------------------------------------------------------------
  attr_reader :level
  #---------------------------------------------------------------------
  # *) Initialize D&D params
  #---------------------------------------------------------------------
  def initialize_dndparams
    @level = 1
  end
  #---------------------------------------------------------------------
  def level_up
    @level += 1
  end
  #---------------------------------------------------------------------
  def level_down
    @level -= 1
    @level = [1, @level].max
  end
  #---------------------------------------------------------------------
end
#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Get the right class id of class parent
  #--------------------------------------------------------------------------
  def get_class(symbol)
    classid = 0
    compare_template = []
    case symbol
    when :barbarian
      compare_template = DND::ClassID::Barbarian
    when :bard
      compare_template = DND::ClassID::Bard
    when :cleric
      compare_template = DND::ClassID::Cleric
    when :druid
      compare_template = DND::ClassID::Druid
    when :fighter
      compare_template = DND::ClassID::Fighter
    when :monk
      compare_template = DND::ClassID::Monk
    when :paladin
      compare_template = DND::ClassID::Paladin
    when :ranger
      compare_template = DND::ClassID::Ranger
    when :rogue
      compare_template = DND::ClassID::Rogue
    when :Sorcerer
      compare_template = DND::ClassID::Sorcerer
    when :warlock
      compare_template = DND::ClassID::Warlock
    when :wizard
      compate_template = DND::ClassID::Wizard
    end
    classid = self.class     if compare_template.include?(@class_id)
    classid = self.dualclass if compare_template.include?(@dualclass_id)
    return classid
  end
  
end
