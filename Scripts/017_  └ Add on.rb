#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  This module manages battle progress.
#==============================================================================
module BattleManager
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  Team_Number     = 3
  # ~~~ Scope Constants ~~~ #
  Scope_None      = 0
  Scope_OneEnemy  = 1
  Scope_AllEnemy  = 2
  Scope_1Random   = 3
  Scope_2Random   = 4
  Scope_3Random   = 5
  Scope_4Random   = 6
  Scope_OneAlly   = 7
  Scope_AllAlly   = 8
  Scope_OneDead   = 9
  Scope_AllDead   = 10
  Scope_User      = 11
  # ~~~ Direction Angles ~~~ #
  Direction_Angles = {
    7 => 135, 8 =>  90, 9 =>  45,
    4 => 180, 5 => nil, 6 =>   0,
    1 => 225, 2 => 270, 3 => 335
  }
  # ~~~ Music ~~~ #
  Default_Battle_BGM = "Baldur's Gate OST - Attacked by Assassins.mp3"
  #--------------------------------------------------------------------------
  # * Caches
  #--------------------------------------------------------------------------
  @cache_opponents = []
  #--------------------------------------------------------------------------
  # * Setup 
  #--------------------------------------------------------------------------
  # tag: 1 (BM
  def self.setup(can_escape = true, can_lose = false)
    @flags = {}
    @cache_opponents.clear
    @can_escape = can_escape
    @can_lose = can_lose
    debug_print "Battle Manager setup"
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def self.refresh
    @cache_opponents.clear
    @flags.clear
  end
  #--------------------------------------------------------------------------
  # * Push character into active battlers
  #--------------------------------------------------------------------------
  def self.register_battler(battler)
    return if battler.team_id.nil? || battler.team_id >= Team_Number
    $game_map.register_battler(battler)
    @cache_opponents.clear
  end
  #--------------------------------------------------------------------------
  # * Remove unit
  #--------------------------------------------------------------------------
  def self.resign_battle_unit(battler)
    $game_map.resign_battle_unit(battler)
    @cache_opponents.clear
  end
  #--------------------------------------------------------------------------
  def self.all_battlers
    return $game_map.all_battlers
  end
  #--------------------------------------------------------------------------
  def self.all_alive_battlers
    return $game_map.all_alive_battlers
  end
  #--------------------------------------------------------------------------
  def self.dead_battlers
    return $game_map.dead_battlers
  end
  #--------------------------------------------------------------------------
  # * Return alive allied battlers
  #--------------------------------------------------------------------------
  def self.ally_battler(battler = $game_palyer)
    return $game_map.action_battlers[battler.team_id].compact.select{|char| !char.dead?}
  end
  #--------------------------------------------------------------------------
  # * Return dead allies
  #--------------------------------------------------------------------------
  def self.dead_allies(battler = $game_player)
    return $game_map.action_battlers[battler.team_id].compact.select{|char| char.dead?}
  end
  #--------------------------------------------------------------------------
  # * Return alive hostile battlers
  #--------------------------------------------------------------------------
  def self.opponent_battler(battler = $game_player)
    return @cache_opponents[battler.team_id] if @cache_opponents[battler.team_id]
    opponents = []
    $game_map.action_battlers.each do |key, members|
      next if key == battler.team_id
      members.compact.each do |member|
        next if member.dead?
        opponents.push(member)
      end
    end
    @cache_opponents[battler.team_id] = opponents
    return opponents
  end
  #--------------------------------------------------------------------------
  # * Return dead hostile battlers
  #--------------------------------------------------------------------------
  def self.dead_opponents(battler = $game_player)
    opponents = []
    $game_map.ction_battlers.each do |key, members|
      next if key == battler.team_id
      members.compact.each do |member|
        next unless member.dead?
        opponents.push(member)
      end
    end
    return opponents
  end
  #--------------------------------------------------------------------------
  def self.is_friend?(a, b)
    return false if a.nil? || b.nil?
    return a.team_id == b.team_id
  end
  #--------------------------------------------------------------------------
  def self.is_opponent?(a, b)
    return a.team_id != b.team_id
  end
  #--------------------------------------------------------------------------
  # * Enter target selection
  #--------------------------------------------------------------------------
  def self.target_selection(user, item)
    return unless SceneManager.scene_is?(Scene_Map)
    SceneManager.scene.start_tactic
    # tag: unfinished
  end
  #--------------------------------------------------------------------------
  # * Enter target selection
  #--------------------------------------------------------------------------
  def self.autotarget(user, item, sensor = item.tool_distance)
    return user.current_target if user.current_target
    return user if item.for_none? || item.for_user?
    return one_random_ally(user, item, sensor) if item.for_friend?
    return one_random_enemy(user, item, sensor)
  end
  #--------------------------------------------------------------------------
  # * Decide one random ally (nearset if not AOE)
  #--------------------------------------------------------------------------
  def self.one_random_ally(user, item, sensor)
    allies = ally_battler(user)
    return determine_best_position(user, allies, item) if item.for_all?
    
    target = nil
    target_distance = 0xffff
    allies.each do |ally|
      range = user.distance_to_character(ally)
      next if range > sensor
      if target_distance > range
        target = ally
        target_distance = range
      end
    end
    return target ? target : user
  end
  #--------------------------------------------------------------------------
  # * Decide one random enemy (nearset if not AOE)
  #--------------------------------------------------------------------------
  def self.one_random_enemy(user, item, sensor)
    enemies = opponent_battler(user)
    return determine_best_position(user, enemies, item) if item.for_all?
    
    target = nil
    target_distance = 0xffffff
    enemies.each do |enemy|
      range = user.distance_to_character(enemy)
      next if range > sensor
      if target_distance > range
        target = enemy
        target_distance = range
      end
    end
    return target ? target : POS.new(user.x, user.y)
  end
  #--------------------------------------------------------------------------
  # * Take median target as promary one
  #--------------------------------------------------------------------------
  def self.determine_best_position(user, battlers, item)
    battlers.select!{|battler| battler.distance_to_character(user) < item.tool_distance}
    n = battlers.size == 0 ? 1 : battlers.size
    so1 = battlers.sort!{|a,b| (a.x + a.y) <=> (b.x + b.y)}.at(n / 2)
    so2 = POS.new(0, 0)
    battlers.each{|obj| so2.x += obj.x; so2.y += obj.y}
    so2.x /= n; so2.y /= n
    n1  = determine_effected_targets(user, item, so1).size
    n2  = determine_effected_targets(user, item, so2).size
    target = n1 >= n2 ? so1 : so2
    return target.nil? ? user : target
  end
  #--------------------------------------------------------------------------
  # * Execute Action
  #--------------------------------------------------------------------------
  def self.execute_action(action)
    puts "[Debug]: Action executed"
    action.subject = determine_effected_targets(action.user, action.item, action.target)
    action.user.use_item(action.item) if action.item.tool_animmoment == 0 # Directly use
    apply_skill(action)  if action.item.is_a?(RPG::Skill)
    apply_item(action)   if action.item.is_a?(RPG::Item)
    apply_weapon(action) if action.item.is_a?(RPG::Weapon)
    apply_armor(action)  if action.item.is_a?(RPG::Armor)
  end
  #--------------------------------------------------------------------------
  # * Determine effected targets
  #--------------------------------------------------------------------------
  def self.determine_effected_targets(user, item, target)
    if item.for_opponent? || item.is_a?(RPG::Weapon)
      candidates = opponent_battler(user).sort {|a,b| a.distance_to_character(target) <=> b.distance_to_character(target)}
    elsif item.for_friend?
      candidates = ally_battler(user).sort {|a,b| a.distance_to_character(target) <=> b.distance_to_character(target)}
    else
      candidates = []
    end
    return [] if target.nil?
    pos = [target.x, target.y]
    
    candidates.select!{|battler| in_attack_range?(user, item, battler, pos)}
    if item.for_one?
      candidates = target.is_a?(POS) ? [candidates.first] : [target]
    end
    candidates.compact!; candidates.select!{|battler| !battler.dead?}
    names = []
    candidates.each do |char|
      names << char.enemy.name if char.is_a?(Game_Event)    && char.enemy
      names << char.actor.name if char.is_a?(Game_Player)   && char.actor
      names << char.actor.name if char.is_a?(Game_Follower) && char.actor
    end
    debug_print "Action subjects: #{names}}"
    return candidates
  end
  #--------------------------------------------------------------------------
  def self.in_attack_range?(user, item, target, pos)
    return false if target.distance_to(*pos) > item.tool_scope
    return true  if item.tool_scopedir == 5
    dir = item.tool_scopedir == 0 ? user.direction : item.tool_scopedir
    angle1 = (Direction_Angles[dir] + item.tool_scopeangle / 2 + 360) % 360
    angle2 = (Direction_Angles[dir] - item.tool_scopeangle / 2 + 360) % 360
    puts "Dir: #{dir} #{Direction_Angles[dir]}"
    distance = item.tool_scope
    
    re = Math.in_arc?(target.x + 0.5, target.y + 0.5, user.x + 0.5, user.y + 0.5,
                      angle1, angle2, item.tool_scope, dir)
    puts "In arc: #{re}"
    return re
  end
  #--------------------------------------------------------------------------
  # * Apply Skill
  #--------------------------------------------------------------------------
  def self.apply_skill(action)
    invoke_action(action)
  end
  #--------------------------------------------------------------------------
  # * Apply Item
  #--------------------------------------------------------------------------
  def self.apply_item(action)
    invoke_action(action)
  end
  #--------------------------------------------------------------------------
  # * Apply 
  #--------------------------------------------------------------------------
  def self.apply_weapon(action)
    invoke_action(action)
  end
  #--------------------------------------------------------------------------
  # * Apply Armor
  #--------------------------------------------------------------------------
  def self.apply_armor(action)
    invoke_action(action)
  end
  #--------------------------------------------------------------------------
  def self.valid_battler?(battler)
    return false if battler.nil?
    return true  if battler.is_a?(Game_Actor) && $game_party.members.include?(battler)
    return true  if (battler.is_a?(Game_Follower) || battler.is_a?(Game_Player)) && battler.actor && $game_party.members.include?(battler.actor)
    return valid_npc?(battler) if battler.is_a?(Game_Event)
    return false
  end
  #--------------------------------------------------------------------------
  def self.valid_npc?(battler)
    return false if !battler.enemy
    return false if !$game_map.events.include?(battler.id)
    return false if !$game_map.events.values.include?(battler)
    return true
  end
  #--------------------------------------------------------------------------
  # * Invoke Action
  #--------------------------------------------------------------------------
  def self.invoke_action(action)
    item = action.item
    return invoke_action_sequence(action) if item.action_sequence > 0
    action.subject.each do |target|
      next unless valid_battler?(target)
      target.item_apply(action.user, item)
    end
  end
  #--------------------------------------------------------------------------
  def self.invoke_action_sequence(action)
  end
  #--------------------------------------------------------------------------
  # * Apply Substitute
  #--------------------------------------------------------------------------
  def self.apply_substitute(target, item)
    if check_substitute(target, item)
      substitute = substitute_battler(target)
      if substitute && target != substitute
        return substitute
      end
    end
    return target
  end
  #--------------------------------------------------------------------------
  # * Get Substitute Battler
  #   e.g. mirror image
  #--------------------------------------------------------------------------
  def self.substitute_battler
    return nil
  end
  #--------------------------------------------------------------------------
  # * Get Array of Actors Targeted by Item Use
  #--------------------------------------------------------------------------
  def self.item_target_actors(item)
    if !item.for_friend?
      []
    elsif item.for_all?
      $game_party.members
    else
      [$game_party.members[@actor_window.index]]
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Item is Usable
  #--------------------------------------------------------------------------
  def self.item_usable?(user)
    user.usable?(item) && item_effects_valid?(user)
  end
  #--------------------------------------------------------------------------
  # * Determine if Item Is Effective
  #--------------------------------------------------------------------------
  def self.item_effects_valid?(user)
    item_target_actors.any? do |target|
      target.item_test(user, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Regenerate all battle members
  #--------------------------------------------------------------------------
  def self.regenerate_all
    all_battlers.each do |battler|
      battler.regenerate_all
    end
  end
  #--------------------------------------------------------------------------
  # * Processing at End of Turn, frame time per turn >> PONY::TimeCycle
  #--------------------------------------------------------------------------
  def self.on_turn_end
    all_battlers.each do |battler|
      battler.on_turn_end
    end
  end
  #--------------------------------------------------------------------------
  # * In battle?
  #--------------------------------------------------------------------------
  def self.in_battle?
    return @flags[:in_battle] if @flags[:in_battle]
    @flags[:in_battle] = all_battlers.any?{ |battler| battler.current_target.is_a?(Game_Actor) }
    return @flags[:in_battle]
  end
  #--------------------------------------------------------------------------
  # * Check if any battler is under process
  #--------------------------------------------------------------------------
  def self.detect_combat
    result = @flags[:in_battle]
    result = false if result.nil?
    @flags.delete(:in_battle)
    result = self.in_battle?
    if result != result
      battle_start if result
      battle_end   if !result
    end
  end
  #--------------------------------------------------------------------------
  def self.battle_start
    
  end
  #--------------------------------------------------------------------------
  def self.battle_end
    
  end
  #--------------------------------------------------------------------------
  def self.clear_flag(symbol = nil)
    if symbol
      @flags.delete(symbol)
    else
      @flags = {}
    end
  end
  #--------------------------------------------------------------------------
  def self.set_flag(symbol, value)
    @flags[symbol] = value
  end
  #--------------------------------------------------------------------------
  def self.on_encounter
  end
  #--------------------------------------------------------------------------
  def self.rate_preemptive
  end
  #--------------------------------------------------------------------------
  def self.rate_surprise
  end
  #--------------------------------------------------------------------------
  def self.make_escape_ratio
  end
  #--------------------------------------------------------------------------
  def self.actor
  end
  #--------------------------------------------------------------------------
  def self.next_subject
  end
end
