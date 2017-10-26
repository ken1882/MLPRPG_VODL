#==============================================================================
# ** Module: Tactic Condition
#------------------------------------------------------------------------------
#  Define the conditions of tactic command
#==============================================================================
# tag: AI
module Tactic_Config
  #--------------------------------------------------------------------------
  General_Actions = {
    :attack_mainhoof        => :attack_mainhoof,
    :attack_offhoof         => :attack_offhoof,
    :target_none            => :target_none,
    :hp_most_power          => :hp_most_power,
    :hp_least_power         => :hp_least_power,
    :ep_most_power          => :ep_most_power,
    :ep_least_power         => :ep_least_power,
    :set_target             => :set_target,
    :jump_to                => :nil,
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
    module_function
    #--------------------------------------------------------------------------
    def start_check(user, symbol, args)
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
      @candidates.select!{|ch| @user.path_clear?(@user.x, @user.y, ch.x, ch.y) }
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
      return if (@args[0] || 0) > 0
      @candidates.each do |ch|
        return ch if ch.state?(@args[0])
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
      ally = @args[0]
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
      ally = @args[0]
      return ally.map_char.current_target if ally
      $game_party.members.each do |ch|
        next if ch.nil? || !ch.map_char
        return ch.map_char.current_target if ch.map_char.current_target
      end
    end
    #--------------------------------------------------------------------------
    def pick_rank
      return if @args[0].nil?
      @candidates.each do |ch|
        return ch if ch.rank == ch.rank
      end
    end
    #--------------------------------------------------------------------------
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
    module_function
    #--------------------------------------------------------------------------
    def start_check(user, symbol, args)
      @user = user
      @target = user.current_target
      @args = args
      return method(symbol).call if @target
    end
    #--------------------------------------------------------------------------
    def return_any
      return true
    end
    #--------------------------------------------------------------------------
    def determine_cluster_number
      enemies = BattleManager.opponent_battler(@user)
      enemies.each do |enemy|
        cnt += 1 if enemy.distance_to_character(@target) < 3
      end
      return cnt >= @args[0] # number greater gate
    end
    #--------------------------------------------------------------------------
    def hp_lower
      percent = @args[0] / 100.0 # percent
      return (@target.hp.to_f / @target.mhp) <= percent
    end
    #--------------------------------------------------------------------------
    def hp_higher
      percent = @args[0] / 100.0 # percent
      return (@target.hp.to_f / @target.mhp) >= percent
    end
    #--------------------------------------------------------------------------
    def determine_target_range_scale
      dis = @user.distance_to_character(@target)
      return dis <= 2 if @args[0] == :short
      return dis <= 6 if @args[0] == :medium
      return dis > 6 if @args[0] == :long
    end
    #--------------------------------------------------------------------------
    def determine_target_attack_type
      return false if @target.primary_weapon.nil?
      return @target.primary_weapon.melee?  if @args[0] == :melee
      return @target.primary_weapon.ranged? if @args[0] == :ranged
      return @target.casting?               if @args[0] == :casting
    end
    
  end # queued: tactic AI
  #--------------------------------------------------------------------------
  # * Handling the conditions about player team
  #--------------------------------------------------------------------------
  module Players
     #--------------------------------------------------------------------------
    Condition_Table = {
      :any                    => :return_any,
      :in_battle              => :check_in_battle?,
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
    module_function
    #--------------------------------------------------------------------------
    def start_check(user, symbol, args)
      @user = @user
      @args = args
      return method(symbol).call
    end
    #--------------------------------------------------------------------------
    def return_any
      return true
    end
    #--------------------------------------------------------------------------
    def check_in_battle?
      return BattleManager.in_battle?
    end
    #--------------------------------------------------------------------------
    def state_included?
      return @user.state?(@args[0])
    end
    #--------------------------------------------------------------------------
    def hp_lower
      percent = @args[0] / 100.0
      return (@user.hp.to_f / @user.mhp) <= percent
    end
    #--------------------------------------------------------------------------
    def ep_lower
      percent = @args[0] / 100.0
      return (@user.mp.to_f / @user.mmp) <= percent
    end
    #--------------------------------------------------------------------------
    def last_attacked_type
      return @user.battler.last_attacked_action.collect{|a| a.item}.any?{|i| i.attack_type == @args[0]}
    end
    #--------------------------------------------------------------------------
    def alive_enemy_number
      enemies = BattleManager.opponent_battler(@user)
      enemies.select!{|ch| @user.distance_to_character(ch) <= range}
      enemies.select!{|ch| @user.path_clear?(@user.x, @user.y, ch.x, ch.y) }
      number = enemies.size
      return number >= @args[0]
    end
    #--------------------------------------------------------------------------
    def alive_ally_number
      number = $game_party.battle_members.select{|ch| !ch.dead?}
      return number >= @args[0]
    end
    #--------------------------------------------------------------------------
    def dead_ally_number
      number = $game_party.battle_members.select{|ch| ch.dead?}
      return number >= @args[0]
    end
    #--------------------------------------------------------------------------
    def current_attack_type
      return @user.primary_weapon.attack_type == @args[0]
    end
    #--------------------------------------------------------------------------
    def nearby_enemy_number
      number = BattleManager.opponent_battler(@user).select{|ch| ch.distance_to_character(@user) < 3}
      return number >= @args[0]
    end
  end
  
end
