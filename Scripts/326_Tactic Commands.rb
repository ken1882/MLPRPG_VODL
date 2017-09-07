#==============================================================================
# ** Module: Tactic Condition
#------------------------------------------------------------------------------
#  Define the conditions of tactic command
#==============================================================================
# tag: AI
module Tactic_Condition
  #--------------------------------------------------------------------------
  # * This module contains the conditions when targeting a opponent
  #--------------------------------------------------------------------------
  module Enemy
    #--------------------------------------------------------------------------
    # * Corresponding mehtod name to each symbol
    #--------------------------------------------------------------------------
    Condition_Table = {
      # symbol,              mehtod name
      :lowest_hp            => :pick_hp_lowest,
      :highest_hp           => :pick_hp_highest,
      :has_state            => :pick_state_included,
      :nearest_visible      => :pick_nearest_visible,
      :nearest_visible_type => :pick_nearest_type,
      :attacking_ally       => :pick_attacking_ally,
      :target_of_ally       => :pick_target_of_ally,
      :rank                 => :pick_rank,
    }
    #--------------------------------------------------------------------------
    # * Default priority value to each symbol
    #--------------------------------------------------------------------------
    Priority_Table = {
      :lowest_hp            => 100,
      :highest_hp           => 100,
      :has_state            =>  15,
      :nearest_visible      =>  60,
      :nearest_visible_type =>  40,
      :attacking_ally       =>  50,
      :target_of_ally       =>  40,
      :rank                 =>  30,
    }
    #--------------------------------------------------------------------------
    module_function
    #--------------------------------------------------------------------------
    def start_check(candidates, symbols, priorities, args = {})
      @args = args
      candidates.select!{|enemy| enemy.alive}
      target   = candidates.first
      max_rate = 0
      candidates.each_with_index do |enemy, i|
        rate = 0
        symbols.each_with_index do |symbol, j|
          rates += method(symbol).call(enemy, priorities[j])
        end
        if rate > max_rate
          max_rate = rate
          target   = enemy
        end
      end
      return target
    end
    #--------------------------------------------------------------------------
    def pick_hp_lowest(enemy, priority)
      return (1 - (enemy.hp.to_f / enemy.mhp)) * priority
    end
    #--------------------------------------------------------------------------
    def pick_hp_highest(enemy, priority)
      return (enemy.hp.to_f / enemy.mhp) * priority
    end
    #--------------------------------------------------------------------------
    def pick_state_included(enemy, priority)
      return priority if enemy.state?(@args[:state_id])
    end
    #--------------------------------------------------------------------------
    def pick_nearest_visible(enemy, priority)
      return (100 - enemy.distance_to_character(@args[:user])) * priority * 0.01
    end
    #--------------------------------------------------------------------------
    def pick_attacking_ally(enemy, priority)
      return priority if enemy.current_target == @args[:ally]
      return priority if BattleManager.is_friend?(@args[:user], enemy.current_target)
      return 0
    end
    #--------------------------------------------------------------------------
    def pick_target_of_ally(enemy, priority)
      return priority if BattleManager.ally_battler.any?{|b| b.current_target == enemy}
    end
    #--------------------------------------------------------------------------
    def pick_rank(enemy, priority)
      return priority if enemy.rank == @args[:rank]
    end
  end
  #--------------------------------------------------------------------------
  # * Handling the conditions and actions when fighting enemy
  #--------------------------------------------------------------------------
  module Target
    #--------------------------------------------------------------------------
    Condition_Table = {
      :any              => :return_any,
      :clustered        => :determine_cluster_number,
      :hp_lower         => :check_hp_lower,
      :hp_higher        => :determine_hp_higher,
      :target_range     => :determine_target_range_scale,
      :target_atk_type  => :determine_target_attack_type,
    }
    #--------------------------------------------------------------------------
    Priority_Table = {
      :any              => 100,
      :clustered        => 15,
      :hp_lower         => 60,
      :hp_higher        => 60,
      :target_range     => 40,
      :target_atk_type  => 45,
    }
    #--------------------------------------------------------------------------
    module_function
    #--------------------------------------------------------------------------
    def start_check(target, symbol, priority, args = {})
      @args = args
      return method(symbol).call(target, priority)
    end
    #--------------------------------------------------------------------------
    def return_any(target, priority)
      return priority
    end
    #--------------------------------------------------------------------------
    def determine_cluster_number(target, priority)
      cnt = 0
      @args[:enemies].each do |enemy|
        cnt += 1 if enemy.distance_to_character(target) < 3
      end
      return priority * cnt
    end
    #--------------------------------------------------------------------------
    def hp_lower(target, priority)
      percent = @args[:hp_low_percent] / 100.0
      return (1 - target.hp.to_f / target.mhp / percent) * priority
    end
    #--------------------------------------------------------------------------
    def hp_higher(target, priority)
      return (target.hp.to_f / target.mhp / percent) * priority
    end
    #--------------------------------------------------------------------------
    def target_range(target, priority)
      dis = distance_to_character(@args[:user])
      case @args[:range]
      when :short && dis < 4;             return priority;
      when :medium && dis < 8;            return priority;
      when :long && dis >= 8 && dis < 30; return priority;
      end
    end
    #--------------------------------------------------------------------------
    def target_atk_type(target, priority)
      case @args[:atk_type]
      when :melee && target.default_weapon.melee?;    return priority;
      when :magic && target.default_weapno.is_magic?;  return priority;
      when :ranged && target.default_weapon.ranged?;   return priority;
      end
    end
    
  end # last work: tactic AI
  
  module Self
    
  end
  
  module Ally
    
  end
  
end
#==============================================================================
# ** Tactic Commands
# -----------------------------------------------------------------------------
#   Tactic commands for AI combat processing
#==============================================================================
# tag: AI
class Tactic_Command
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :action
  attr_accessor :conditions
  attr_reader   :user
  #----------------------------------------------------------------------------
  # *) Object initialization
  #----------------------------------------------------------------------------
  def initialize(action)
    @user       = action.user
    @action     = action
    @conditions = []
  end
  #----------------------------------------------------------------------------
  def update
  end
  #----------------------------------------------------------------------------
  def check_condition
  end
  #----------------------------------------------------------------------------
  def perform_action
  end
  #----------------------------------------------------------------------------
end
