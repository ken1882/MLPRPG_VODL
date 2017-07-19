#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  This module manages battle progress.
#==============================================================================
module BattleManager
  Team_Number     = 3
  Team_Max_Number = 15
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
  def self.setup(npcs, can_escape = true, can_lose = false)
    init_members(npcs)
    @can_escape = can_escape
    @can_lose = can_lose
  end
  #--------------------------------------------------------------------------
  # * Initialize Member Variables
  #--------------------------------------------------------------------------
  class << self; alias init_members_dnd init_members; end
  def self.init_members(npcs)
    init_members_dnd
    @action_battlers = {}
    Team_Number.times {|key| @action_battlers[key] = Array.new()}
    assign_team_number(npcs)
  end
  #--------------------------------------------------------------------------
  def self.assign_team_number(npcs)
    @action_battlers[0] = $game_party.battle_members
    npcs.compact.each do |npc|
      next if npc.team_id.nil? || npc.team_id >= Team_Max_Number
      @action_battlers[npc.team_id].push(npc)
    end
  end
  #--------------------------------------------------------------------------
  # * Processing at Encounter Time
  #--------------------------------------------------------------------------
  def self.on_encounter
  end
  #--------------------------------------------------------------------------
  # * Get Probability of Preemptive Attack
  #--------------------------------------------------------------------------
  def self.rate_preemptive
  end
  #--------------------------------------------------------------------------
  # * Get Probability of Surprise
  #--------------------------------------------------------------------------
  def self.rate_surprise
  end
  #--------------------------------------------------------------------------
  # * Save BGM and BGS
  #--------------------------------------------------------------------------
  def self.save_bgm_and_bgs
    @map_bgm = RPG::BGM.last
    @map_bgs = RPG::BGS.last
  end
  #--------------------------------------------------------------------------
  # * Play Battle BGM
  #--------------------------------------------------------------------------
  def self.play_battle_bgm
    $game_system.battle_bgm.play
    RPG::BGS.stop
  end
  #--------------------------------------------------------------------------
  # * Play Battle End ME
  #--------------------------------------------------------------------------
  def self.play_battle_end_me
    $game_system.battle_end_me.play
  end
  #--------------------------------------------------------------------------
  # * Resume BGM and BGS
  #--------------------------------------------------------------------------
  def self.replay_bgm_and_bgs
    @map_bgm.replay unless $BTEST
    @map_bgs.replay unless $BTEST
  end
  #--------------------------------------------------------------------------
  # * Create Escape Success Probability
  #--------------------------------------------------------------------------
  def self.make_escape_ratio
  end
  #--------------------------------------------------------------------------
  # * Determine if Turn Is Executing
  #--------------------------------------------------------------------------
  def self.in_turn?
    @phase == :turn
  end
  #--------------------------------------------------------------------------
  # * Determine if Turn Is Ending
  #--------------------------------------------------------------------------
  def self.turn_end?
    @phase == :turn_end
  end
  #--------------------------------------------------------------------------
  # * Determine if Battle Is Aborting
  #--------------------------------------------------------------------------
  def self.aborting?
    @phase == :aborting
  end
  #--------------------------------------------------------------------------
  # * Get Whether Escape Is Possible
  #--------------------------------------------------------------------------
  def self.can_escape?
    @can_escape
  end
  #--------------------------------------------------------------------------
  # * Get Actor for Which Command Is Being Entered
  #--------------------------------------------------------------------------
  def self.actor
  end
  #--------------------------------------------------------------------------
  # * Clear Actor for Which Command Is Being Entered
  #--------------------------------------------------------------------------
  def self.clear_actor
    @actor_index = -1
  end
  #--------------------------------------------------------------------------
  # * Get Next Action Subject
  #    Get the battler from the beginning of the action order list.
  #    If an actor not currently in the party is obtained (occurs when index
  #    is nil, immediately after escaping in battle events etc.), skip them.
  #--------------------------------------------------------------------------
  def self.next_subject
  end
  #--------------------------------------------------------------------------
  def self.all_battlers
    return @action_battlers.collect{|key, battler| battler}
  end
  #--------------------------------------------------------------------------
  def self.all_alive_battlers
    return @action_battlers.collect{|key, battler| battler unless battler.dead?}
  end
  #--------------------------------------------------------------------------
  def self.dead_battlers
    return @action_battlers.collect{|key, battler| battler if battler.dead?}
  end
  #--------------------------------------------------------------------------
  # * Return allied battlers
  #--------------------------------------------------------------------------
  def self.ally_battler(battler = $game_palyer)
    return @action_battlers[battler.team_id].compact.select{|char| !char.dead?}
  end
  #--------------------------------------------------------------------------
  # * Return allied battlers
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
  end # last work: define alive battlers
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
    target_distance = 0xffffff
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
    debug_print "Action subjects: #{action.subject.collect{|char| char.name if char}}"
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
  # * Invoke Action
  #--------------------------------------------------------------------------
  def self.invoke_action(action)
    item = action.item
    action.subject.each do |target|
      next if target.nil?
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
  # * Use Item on Actor
  #--------------------------------------------------------------------------
  def self.use_item_to_actors(user)
    return unless user.is_a?(Game_Actor)
    item_target_actors.each do |target|
      item.repeats.times { target.item_apply(user, item) }
    end
  end
  
end
