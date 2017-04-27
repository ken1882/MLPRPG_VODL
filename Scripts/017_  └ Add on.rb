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
  
  def self.all_battlers
    return @action_battlers.collect{|key, battler| battler}
  end
  #--------------------------------------------------------------------------
  # * Return allied battlers
  #--------------------------------------------------------------------------
  def self.ally_battler(battler = $game_palyer)
    return @action_battlers[battler.team_id].compact
  end
  #--------------------------------------------------------------------------
  # * Return allied battlers
  #--------------------------------------------------------------------------
  def self.opponent_battler(battler = $game_player)
    opponents = []
    @action_battlers.each do |key, members|
      next if key == battler.team_id
      opponents << members.compact
    end
    return opponents.flatten
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
  def self.autotarget(user, item, sensor = 8)
    return user.current_target if user.current_target
    return user if item.for_none? || item.for_user?
    return one_random_ally(user, item, sensor) if item.for_friend?
    return one_random_enemy(user, item, sensor)
  end
  #--------------------------------------------------------------------------
  # * Decide one random ally (nearset if not AOE)
  #--------------------------------------------------------------------------
  def self.one_random_ally(user, item, sensor = 8)
    allies = ally_battler(user)
    return determine_best_position(allies, item) if item.for_all?
    target = allies[0]
    allies.each { |battler| 
      target = battler if user.distance_to_character(battler) > user.distance_to_character(target)
    }
    return target ? target : user
  end
  #--------------------------------------------------------------------------
  # * Decide one random enemy (nearset if not AOE)
  #--------------------------------------------------------------------------
  def self.one_random_enemy(user, item, sensor = 8)
    enemies = opponent_battler(user)
    return determine_best_position(enemies, item) if item.for_all?
    
    target = enemies[0]
    enemies.each { |battler| 
      target = battler if user.distance_to_character(battler) > user.distance_to_character(target)
    }
    return target ? target : user
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
    determine_effected_targets(action)
    action.user.use_item(action.item)
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
    
    if action.item.for_one?
      action.subject = action.target.is_a?(POS) ? [candidates.first] : [action.target]
    elsif action.item.tool_type == 1
      action.subject = candidates.select {|battler| battler.distance_to_character(action.target) <= action.item.tool_distance}
    end
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
  
end
