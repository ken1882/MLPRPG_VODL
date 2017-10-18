#==============================================================================
# ** Module: Tactic Condition
#------------------------------------------------------------------------------
#  Define the conditions of tactic command
#==============================================================================
# tag: AI
module Tactic_Config
  #--------------------------------------------------------------------------
  Name_Table = {
    :lowest_hp              => "Lowest HP",
    :highest_hp             => "Highest HP",
    :has_state              => "Has state",
    :nearest_visible        => "Nearest visible",
    :attacking_ally         => "Attacking ally",
    :target_of_ally         => "Target of ally",
    :rank                   => "Rank"
  }
  #--------------------------------------------------------------------------
  General_Actions = {
    :attack_mainhoof        => :attack_mainhoof,
    :attack_offhoof         => :attack_offhoof,
  }
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
      #:nearest_visible_type => :pick_nearest_type,
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
    def start_check(user, symbol, args = {})
      if !Condition_Table.keys.include?(symbol)
        PONY::ERRNO.raise(:tactic_sym_missing, nil, nil, symbol)
        return
      end
      func = Condition_Table[symbol]
      @args = args
      @user = user
      @candidates = BattleManager.opponent_battler(@user)
      range = @user.visible_sight
      @candidates = @candidates.select{|ch| @user.distance_to_character(ch) <= range}
      @candidates.sort!{|a,b| @user.distance_to_character(a) <=> @user.distance_to_character(b)}
      return method(func).call
    end
    #--------------------------------------------------------------------------
    def pick_hp_lowest
      return @candidates.min_by{|ch| ch.hp.to_f / ch.mhp}
    end
    #--------------------------------------------------------------------------
    def pick_hp_highest
      return @candidates.max_by{|ch| ch.hp.to_f / ch.mhp}
    end
    #--------------------------------------------------------------------------
    def pick_state_included
      return if (@args[:state_id] || 0) > 0
      @candidates.each do |ch|
        return ch if ch.state?(@args[:state_id])
      end
    end
    #--------------------------------------------------------------------------
    def pick_nearest_visible
      cx, cy = @user.x, @user.y
      @candidates.each do |ch|
        return ch if @user.path_clear?(cx, cy, ch.x, ch.y)
      end
    end
    #--------------------------------------------------------------------------
    def pick_attacking_ally
      ally = @args[:ally]
      ally = ally.battler if ally
      @candidates.each do |ch|
        if !ch.current_target.nil?
          return ch if ally.nil?
          return ch if ch.current_target.battler == ally
        end
      end
    end
    #--------------------------------------------------------------------------
    def pick_target_of_ally
      ally = @args[:ally]
      return ally.map_char.current_target if ally
      $game_party.members.each do |ch|
        next if ch.nil? || !ch.map_char
        return ch.map_char.current_target if ch.map_char.current_target
      end
    end
    #--------------------------------------------------------------------------
    def pick_rank
      return if @args[:rank].nil?
      @candidates.each do |ch|
        return ch if ch.rank == ch.rank
      end
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
