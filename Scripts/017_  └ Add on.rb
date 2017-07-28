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
  Team_Max_Number = 15
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
  #--------------------------------------------------------------------------
  # * Setup 
  #--------------------------------------------------------------------------
  # tag: 1 (BM
  def self.setup(can_escape = true, can_lose = false)
    init_members
    @flags = {}
    @can_escape = can_escape
    @can_lose = can_lose
  end
  #--------------------------------------------------------------------------
  # * Initialize Member Variables
  #--------------------------------------------------------------------------
  class << self; alias init_members_dnd init_members; end
  def self.init_members
    @action_battlers = {}
    Team_Number.times {|key| @action_battlers[key] = Array.new()}
    assign_party_number
  end
  #--------------------------------------------------------------------------
  # * Set party member's team id to 0
  #--------------------------------------------------------------------------
  def self.assign_party_number
    @action_battlers[0] = $game_party.battle_members
  end
  #--------------------------------------------------------------------------
  # * Push character into active battlers
  #--------------------------------------------------------------------------
  def self.register_battler(battler)
    return if battler.team_id.nil? || battler.team_id >= Team_Max_Number
    @action_battlers[battler.team_id] << battler
    $game_map.enemies << battler
    $game_map.register_battle_unit(battler)
  end
  #--------------------------------------------------------------------------
  # * Remove unit
  #--------------------------------------------------------------------------
  def self.resign_battle_unit(battler)
    $game_map.enemies.delete(battler)
    @action_battlers[battler.team_id].delete(battler)
    $game_map.resign_battle_unit(battler)
  end
  #--------------------------------------------------------------------------
  def self.all_battlers
    re = []
    @action_battlers.each do |key, team|
      team.each {|battler| re << battler}
    end
    return re
  end
  #--------------------------------------------------------------------------
  def self.all_alive_battlers
    re = []
    @action_battlers.each do |key, battlers|
      battlers.each {|battler| re << battler unless battler.dead?}
    end
    return re
  end
  #--------------------------------------------------------------------------
  def self.dead_battlers
    re = []
    @action_battlers.each do |key, battlers|
      battlers.each {|battler| re << battler if battler.dead?}
    end
    return re
  end
  #--------------------------------------------------------------------------
  # * Return alive allied battlers
  #--------------------------------------------------------------------------
  def self.ally_battler(battler = $game_palyer)
    return @action_battlers[battler.team_id].compact.select{|char| !char.dead?}
  end
  #--------------------------------------------------------------------------
  # * Return dead allies
  #--------------------------------------------------------------------------
  def self.dead_allies(battler = $game_player)
    return @action_battlers[battler.team_id].compact.select{|char| char.dead?}
  end
  #--------------------------------------------------------------------------
  # * Return alive hostile battlers
  #--------------------------------------------------------------------------
  def self.opponent_battler(battler = $game_player)
    opponents = []
    @action_battlers.each do |key, members|
      next if key == battler.team_id
      members.compact.each do |member|
        next if member.dead?
        opponents.push(member)
      end
    end
    return opponents
  end
  #--------------------------------------------------------------------------
  # * Return dead hostile battlers
  #--------------------------------------------------------------------------
  def self.dead_opponents(battler = $game_player)
    opponents = []
    @action_battlers.each do |key, members|
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
    return SceneManager.scene.target_selection(user, item)
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
    return determine_best_position(allies, item) if item.for_all?
    
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
    return determine_best_position(enemies, item) if item.for_all?
    
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
  def self.determine_best_position(battlers, item)
    return (battlers.sort!{|a,b| a.hash_pos <=> b.hash_pos}).at(battlers.size / 2)
  end
  #--------------------------------------------------------------------------
  # * Execute Action
  #--------------------------------------------------------------------------
  def self.execute_action(action)
    puts "[Debug]: Action executed"
    determine_effected_targets(action)
    action.user.use_item(action.item) if action.item.tool_animmoment == 0 # Directly use
    apply_skill(action)  if action.item.is_a?(RPG::Skill)
    apply_item(action)   if action.item.is_a?(RPG::Item)
    apply_weapon(action) if action.item.is_a?(RPG::Weapon)
    apply_armor(action)  if action.item.is_a?(RPG::Armor)
  end
  #--------------------------------------------------------------------------
  # * Determine effected targets
  #--------------------------------------------------------------------------
  def self.determine_effected_targets(action)
    if action.item.for_opponent?
      candidates = opponent_battler(action.user).sort {|a,b| a.distance_to_character(action.target) <=> b.distance_to_character(action.target)}
    elsif action.item.for_friend?
      candidates = ally_battler(action.user).sort {|a,b| a.distance_to_character(action.target) <=> b.distance_to_character(action.target)}
    else
      candidates = []
    end
    pos = [action.target.x, action.target.y]
    candidates.select!{|battler| battler.distance_to(*pos) < action.item.tool_scope}
    if action.item.for_one?
      action.subject = action.target.is_a?(POS) ? [candidates.first] : [action.target]
    elsif action.item.tool_type == 1
      action.subject = candidates.select {|battler| battler.distance_to_character(action.target) <= action.item.tool_distance}
    end
    action.subject.compact.select!{|battler| !battler.dead?}
    names = []
    action.subject.compact.each do |char|
      names << char.enemy.name if char.is_a?(Game_Event)    && char.enemy
      names << char.actor.name if char.is_a?(Game_Player)   && char.actor
      names << char.actor.name if char.is_a?(Game_Follower) && char.actor
    end
    debug_print "Action subjects: #{names}}"
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
    return true  if battler.is_a?(Game_Event) && battler.enemy
    return true  if (battler.is_a?(Game_Follower) || battler.is_a?(Game_Player)) && battler.actor
    return false
  end
  #--------------------------------------------------------------------------
  # * Invoke Action
  #--------------------------------------------------------------------------
  def self.invoke_action(action)
    item = action.item
    action.subject.each do |target|
      next unless valid_battler?(target)
      target.item_apply(action.user, item)
    end
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
