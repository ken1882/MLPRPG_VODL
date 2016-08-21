module BattleManager
  
  #--------------------------------------------------------------------------
  # * Overwrite: Processing at Encounter Time
  #--------------------------------------------------------------------------
  def self.on_encounter
    
    @preemptive = rate_preemptive
    @surprise = rate_surprise
    
    @all_prepared = (@preemptive && @surprise)
    
    puts "Battle Situation:"
    puts "Preemptive? -> #{@preemptive}"
    puts "Preemptive? -> #{@surprise}"
    puts "---------------------------------------"
    
  end
  
  #--------------------------------------------------------------------------
  # * Get Probability of Preemptive Attack
  #--------------------------------------------------------------------------
  def self.rate_preemptive
    $game_party.rate_preemptive($game_troop.agi,$game_troop.members)
  end
  #--------------------------------------------------------------------------
  # * Get Probability of Surprise
  #--------------------------------------------------------------------------
  def self.rate_surprise
    $game_party.rate_surprise($game_troop.agi,$game_troop.members)
  end
  
  def self.clear_assault_effect
    @preemptive = false ; @surprise = false ; @all_prepared = false
  end
  
  def self.all_prepared
    @all_prepared
  end
  
  def self.preemptive
    @preemptive
  end
  
  def self.surprise
    @surprise
  end
  
  
end #BattleManager

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles parties. Information such as gold and items is included.
# Instances of this class are referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  
  attr_accessor :invisible
  
  alias init_dnd initialize
  def initialize
    @invisible = false
    init_dnd
  end
  
  
  def avg_dex(bonus)
    base = 0
    for battler in self.members
      base += battler.difficulty_class('dex',bonus,false)
    end
    base /= self.members.size
    return base
  end
  
  #--------------------------------------------------------------------------
  # * Overwrite: Calculate Probability of Preemptive Attack
  #--------------------------------------------------------------------------
  def rate_preemptive(troop_agi,troop_members)
    return 40.0 if $game_map.enemy_alarmed && !@invisible
    
    roll = rand(20) + 1
    base = self.avg_dex(-8) / 2
    
    dc   = 11 + rand(20) + troop_agi / 10
    
    puts "Preemptive Roll: (#{base} + #{roll})/#{dc}"
    
    return (roll + base) >= dc
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Calculate Probability of Surprise
  #--------------------------------------------------------------------------
  def rate_surprise(troop_agi,troop_members)
    
    roll = rand(20) + 1
    base = (troop_agi) / 10
    dc   = 11 + rand(20) + self.avg_dex(-8)
    
    puts "Surprise roll: (#{base} + #{roll})/#{dc}"
    
    return (roll + base) >= dc
  end
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Map
  
  attr_accessor :enemy_alarmed  # if true, preemptive DC = 40
  alias init_dnd initialize
  def initialize
    @enemy_alarmed = false
    init_dnd
  end
  
  
end