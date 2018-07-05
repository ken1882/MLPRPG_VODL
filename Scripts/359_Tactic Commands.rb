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
    :set_target             => :set_target,
    :hp_most_power          => :hp_most_power,
    :hp_least_power         => :hp_least_power,
    :ep_most_power          => :ep_most_power,
    :ep_least_power         => :ep_least_power,
    :jump_to                => :nil,
    :move_away              => :move_away,
    :move_close             => :move_close,
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
      @range = @user.visible_sight
      @candidates = @candidates.select{|ch| @user.distance_to_character(ch) <= @range}
      @candidates.select!{|ch| @user.battler_in_sight?(ch) }
      @candidates.sort!{|a,b| @user.distance_to_character(a) <=> @user.distance_to_character(b)}
      return method(func).call
    end
    #--------------------------------------------------------------------------
    def pick_hp_lowest
      re = @candidates.min_by{|ch| ch.hp.to_f / ch.mhp}
      return re.empty? ? nil : re
    end
    #--------------------------------------------------------------------------
    def pick_hp_highest
      re = @candidates.max_by{|ch| ch.hp.to_f / ch.mhp}
      return re.empty? ? nil : re
    end
    #--------------------------------------------------------------------------
    def pick_state_included
      return unless (@args[0] || 0) > 0
      @candidates.each do |ch|
        return ch if ch.state?(@args[0])
      end
      return nil
    end
    #--------------------------------------------------------------------------
    def pick_nearest_visible
      @candidates.each do |ch|
        next if ch.dead?
        return ch
      end
      return nil
    end
    #--------------------------------------------------------------------------
    def pick_attacking_ally
      ally = @args[0]
      return nil unless ally
      ally = ally == :player ? $game_player : ally.battler
      
      @candidates.each do |ch|
        next if ch.dead?
        next if ch.current_target.nil?
        return ch if ch.current_target.hashid == ally.hashid
      end
      return nil
    end
    #--------------------------------------------------------------------------
    def pick_target_of_ally
      ally = @args[0]
      if ally == :player
        target = $game_player.current_target 
        return nil unless target
        return target if $game_player.can_see?(target)
        return nil
      end
      return ally.map_char.current_target if ally
      $game_party.members.each do |ch|
        next if ch.dead?
        next if ch.nil? || !ch.map_char
        return ch.map_char.current_target if ch.map_char.current_target
      end
      return nil
    end
    #--------------------------------------------------------------------------
    def pick_rank
      return if @args[0].nil?
      @candidates.each do |ch|
        next if ch.dead?
        return ch if ch.rank == ch.rank
      end
      return nil
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
      :has_state        => :state_included?,
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
      return method(Condition_Table[symbol]).call if @target
    end
    #--------------------------------------------------------------------------
    def return_any
      return true
    end
    #--------------------------------------------------------------------------
    def state_included?
      return @target.state?(@args[0])
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
      return dis > 6 if @args[0]  == :long
    end
    #--------------------------------------------------------------------------
    def determine_target_attack_type
      return false if @target.primary_weapon.nil?
      return @target.primary_weapon.melee?  if @args[0] == :melee
      return @target.primary_weapon.ranged? if @args[0] == :ranged
      return @target.casting?               if @args[0] == :magic
    end
    
  end # queued: tactic AI
  #--------------------------------------------------------------------------
  # * Handling the conditions about player itself
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
    module_function
    #--------------------------------------------------------------------------
    def start_check(user, symbol, args)
      @user = user
      @args = args
      @range = 8
      return method(Condition_Table[symbol]).call
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
      enemies.select!{|ch| @user.distance_to_character(ch) <= @range}
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
  #--------------------------------------------------------------------------
  # * Handling the conditions about other party member
  #--------------------------------------------------------------------------
  module Party
     #--------------------------------------------------------------------------
    Condition_Table = {
      :has_state              => :state_included?,
      :hp_lower               => :hp_lower,
      :ep_lower               => :ep_lower,
      :being_attacked_by_type => :last_attacked_type,
      :using_attack_type      => :current_attack_type,
      :surrounded_by_enemies  => :nearby_enemy_number
    }
    #--------------------------------------------------------------------------
    module_function
    #--------------------------------------------------------------------------
    def start_check(user, symbol, args)
      @user = @user
      @args = args
      @candidates = $game_party.members.select{|member| member.map_char}
      return method(Condition_Table[symbol]).call
    end
    #--------------------------------------------------------------------------
    def state_included?
      @candidates.each do |member|
        return member if member.state?(@args[0])
      end
      return false
    end
    #--------------------------------------------------------------------------
    def hp_lower
      @candidates.each do |member|
        percent = @args[0] / 100.0
        return member if (member.hp.to_f / member.mhp) <= percent
      end
      return false
    end
    #--------------------------------------------------------------------------
    def ep_lower
      @candidates.each do |member|
        percent = @args[0] / 100.0
        return member if (member.mp.to_f / member.mmp) <= percent
      end
      return false
    end
    #--------------------------------------------------------------------------
    def last_attacked_type
      @candidates.each do |member|
        if member.last_attacked_action.collect{|a| a.item}.any?{|i| i.attack_type == @args[0]}
          return member
        end
      end
      return false
    end
    #--------------------------------------------------------------------------
    def current_attack_type
      @candidates.each do |member|
        return member if member.primary_weapon.attack_type == @args[0]
      end
      return false
    end
    #--------------------------------------------------------------------------
    def nearby_enemy_number
      @candidates.each do |member|
        number = BattleManager.opponent_battler(@user).select{|ch| ch.distance_to_character(member) < 3}
        return member if number >= @args[0]
      end
      return false
    end
    #--------------------------------------------------------------------------
  end
  #--------------------------------------------------------------------------
end
#==============================================================================
# ** Module: Tactic Condition
#------------------------------------------------------------------------------
#  Define the conditions of tactic command
#==============================================================================
module Tactic_Config
  Condition_Symbol = {
    :has_state              => :collect_valid_states,
    :attacking_ally         => :player_party_members, 
    :target_of_ally         => :player_party_members,
    :rank                   => DND::Rank,
    :target_atk_type        => DND::AttackType,
    :being_attacked_by_type => DND::AttackType,
    :using_attack_type      => DND::AttackType,
    :jump_to                => :get_setting_actor,
    :target_range           => [:short, :medium, :long],
  }
  #--------------------------------------------------------------------------
  module_function
  #--------------------------------------------------------------------------
  def call_function(symbol)
    return method(symbol).call
  end
  #--------------------------------------------------------------------------
  def player_party_members
    return $game_party.members
  end
  #--------------------------------------------------------------------------
  def get_setting_actor
    actor = SceneManager.scene.current_actor
    return unless actor
    n = actor.tactic_commands.size - 1
    return Array.new(n){|i| i + 1}
  end
  #--------------------------------------------------------------------------
  def collect_valid_states
    return $data_states.select{|state| state_valied?(state)}
  end
  #--------------------------------------------------------------------------
  def state_valied?(state)
    return false if state.nil?
    return false if state.id < 1
    return false if (state.icon_index || 0) < 1
    return false if state.name.nil? || state.name.empty?
    return false if state.features.empty? && state.note.empty?
    return true
  end
  #--------------------------------------------------------------------------
  
end
