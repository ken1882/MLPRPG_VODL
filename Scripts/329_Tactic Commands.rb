#==============================================================================
# ** Module: Tactic Condition
#------------------------------------------------------------------------------
#  Define the conditions of tactic command
#==============================================================================
# tag: AI
module Tactic_Config
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
      return [(20 - enemy.distance_to_character(@args[:user])), 0].max * priority * 0.01
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
  # * Handling the conditions when fighting enemy
  #--------------------------------------------------------------------------
  module Target
    #--------------------------------------------------------------------------
    Condition_Table = {
      :any              => :return_any,
      :clustered        => :determine_cluster_number,
      :hp_lower         => :hp_lower,
      :hp_higher        => :hp_higher,
      :target_range     => :determine_target_range_scale,
      :target_atk_type  => :determine_target_attack_type,
    }
    #--------------------------------------------------------------------------
    Priority_Table = {
      :any              => 100,
      :clustered        => 20,
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
      return [(percent - (user.hp.to_f / user.mhp)) * priority, 0].max
    end
    #--------------------------------------------------------------------------
    def hp_higher(target, priority)
      percent = @args[:hp_high_percent] / 100.0
      return [((user.hp.to_f / user.mhp) - percent), 0].max * priority
    end
    #--------------------------------------------------------------------------
    def determine_target_range_scale(target, priority)
      dis = distance_to_character(@args[:user])
      case @args[:range]
      when :short && dis < 4;             return priority;
      when :medium && dis < 8;            return priority;
      when :long && dis >= 8 && dis < 30; return priority;
      end
    end
    #--------------------------------------------------------------------------
    def determine_target_attack_type(target, priority)
      case @args[:atk_type]
      when :melee && target.default_weapon.melee?;    return priority;
      when :magic && target.default_weapon.is_magic?;  return priority;
        when :ranged && target.default_weapon.ranged?;   return priority;
      end
    end
    
  end # queued: tactic AI
  #--------------------------------------------------------------------------
  # * Handling the conditions about player team
  #--------------------------------------------------------------------------
  module Players
     #--------------------------------------------------------------------------
    Condition_Table = {
      :any                    => :return_any,
      :has_state              => :state_included?,
      :hp_lower               => :hp_lower,
      :ep_lower               => :ep_lower,
      :being_attacked_by_type => :last_attacked_type,
      :enemies_alive          => :alive_enemy_number,
      :allies_alive           => :alive_ally_number,
      :allies_dead            => :dead_ally_number,
      :using_attack_type      => :current_attack_type,
      :surrounded_by_enemies  => :nearby_enemy_number
    }
    #--------------------------------------------------------------------------
    Priority_Table = {
      :any                    => 100,
      :has_state              =>  60,
      :hp_lower               => 120,
      :ep_lower               =>  80,
      :being_attacked_by_type =>  50,
      :allies_alive           =>  30,
      :allies_dead            =>  45,
      :using_attack_type      =>  50,
      :surrounded_by_enemies  =>  30,
    }
    #--------------------------------------------------------------------------
    module_function
    #--------------------------------------------------------------------------
    def start_check(user, symbol, priority, args = {})
      @args = args
      return method(symbol).call(user, priority)
    end
    #--------------------------------------------------------------------------
    def return_any(user, priority)
      return priority
    end
    #--------------------------------------------------------------------------
    def state_included?(user, priority)
      return priority if user.state?(@args[:state_id])
    end
    #--------------------------------------------------------------------------
    def hp_lower(user, priority)
      percent = @args[:hp_low_percent] / 100.0
      return [(percent - (user.hp.to_f / user.mhp)) * priority, 0].max
    end
    #--------------------------------------------------------------------------
    def ep_lower(user, priority)
      percent = @args[:ep_low_percent] / 100.0
      return [(percent - (user.mp.to_f / user.mmp)) * priority, 0].max
    end
    #--------------------------------------------------------------------------
    def last_attacked_type(user, priority)
      return priority if @args[:last_attacked_type] == user.last_attacked_action.item.attack_type
    end
    #--------------------------------------------------------------------------
    def alive_enemy_number(user, priority)
      number = @args[:enemies].select{|b| b.alive}.size
      return 0 if number < @args[:pass_number]
      return number * priority
    end
    #--------------------------------------------------------------------------
    def alive_ally_number(user, priority)
      number = @args[:allies].select{|b| b.alive}.size
      return 0 if number < @args[:pass_number]
      return number * priority
    end
    #--------------------------------------------------------------------------
    def dead_ally_number(user, priority)
      number = BattleManager.dead_allies.size
      return 0 if number < @args[:pass_number]
      return number * priority
    end
    #--------------------------------------------------------------------------
    def current_attack_type(user, priority)
      return priority if user.equips.first.attack_type == @args[:current_atk_type]
    end
    #--------------------------------------------------------------------------
    def nearby_enemy_number(user, priority)
      number = @args[:enemies].select{|b| b.distance_to_character(user) < 3}.size
      return 0 if number < @args[:pass_number]
      return number * priority
    end
  end
  
end
#==============================================================================
# ** Tactic Condition
#==============================================================================
# tag: AI
class Tactic_Condition
  include Tactic_Config
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :symbol
  attr_accessor :argument
  attr_accessor :priority
  #----------------------------------------------------------------------------
  # *) Object initialization
  #----------------------------------------------------------------------------
  def initialize(symbol, priority, argumment = nil)
    @symbol   = symbol
    @priority = priority
    @argument = argument
  end
end # queued: tactics AI
#==============================================================================
# ** Tactic Commands
# -----------------------------------------------------------------------------
#   Tactic commands for AI combat processing
#==============================================================================
# tag: AI
class Tactic_Command
  include Tactic_Config
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :action
  attr_accessor :conditions
  attr_accessor :args
  attr_reader   :user
  attr_reader   :require_motivate
  #----------------------------------------------------------------------------
  # *) Object initialization
  #----------------------------------------------------------------------------
  def initialize(user, require_motivate)
    @user             = user
    @require_motivate = 30
    @conditions       = []
    @args             = {}
  end
  #----------------------------------------------------------------------------
  def search_target
    @args[:enemies] = BattleManager.opponent_battler(@user)
    @args[:allies]  = BattleManager.ally_battler(@user)
    @args[:user]    = @user
    
    candidates = @args[:enemies]
    candidates.select!{|enemy| enemy.alive}
    target   = candidates.first
    max_rate = 0
    
    candidates.each_with_index do |enemy, i|
      rate = 0
      @conditions.each do |condition|
        rates += method(condition.symbol).call(condition.priority, condition.argument)
      end # each symbol
      if rate > max_rate
        max_rate = rate
        target   = enemy
      end
    end # each candiate
    return target
  end
  #----------------------------------------------------------------------------
  def check_condition
    motivate = 0
    conditions.each do |condition|
      motivate += method(condition.symbol).call(condition.priority, condition.argument)
    end
    perform_action if motivate > @require_motivate
  end
  #----------------------------------------------------------------------------
  def perform_action
  end
  #----------------------------------------------------------------------------
end
