#===============================================================================
# * Falcao Pearl ABS script shelf # 3
#
# This script handles some battler settings and the keys definitions
#===============================================================================
module Key
  
  
# Pearl ABS Input system, there is a full keayboard build in with this system, 
# you can use keys from A throught Z, and number between 1 throught 9
  
# Type            Key         Display name      
  Weapon    =  [:kA,      'A']            # Weapon usage
  Armor     =  [:kS,      'S']            # Armor usage
  Item      =  [:kD,      'D']            # Item  usage
  Item2     =  [:kF,      'F']            # Item2 usage
  Item3     =  [:kG,      'G']            # Item2 usage
  Skill     =  [:kQ,      'Q']            # Skill usage
  Skill2    =  [:kW,      'W']            # Skill2 usage
  Skill3    =  [:kE,      'E']            # Skill3 usage
  Skill4    =  [:kR,      'R']            # Skill4 usage
  Skill5    =  [:k1,      '1']            # Skill5 usage
  Skill6    =  [:k2,      '2']            # Skill6 usage
  Skill7    =  [:k3,      '3']            # Skill7 usage
  Skill8    =  [:k4,      '4']            # Skill8 usage
  Skill9    =  [:k5,      '5']            # Skill9 usage
  Skill10   =  [:k6,      '6']            # Skill10 usage
  SSkill    =  [:k7,      '7']            # Special Skill usage
  SSkill2   =  [:k8,      '8']            # Special Skill usage
  
  # Follower attack toggle
  Follower =  [PearlKey::C,      'C']
  
  # Quick tool selection key
  QuickTool = PearlKey::N
  
  # Player select call key
  PlayerSelect = PearlKey::M
  
  # Sound played when success guarding
  GuardSe = "Hammer"
  
end
module Vocab
  
  # Buff/Debuff
  BuffAdd         = "%s's %s up!"
  DebuffAdd       = "%s's %s down!"
  BuffRemove      = "%s's %s to normal."
  
end
#-------------------------------------------------------------------------------
# Game player adds
class Game_Player < Game_Character
  attr_accessor :projectiles, :damage_pop, :anime_action, :enemy_drops
  attr_accessor :refresh_status_icons, :refresh_buff_icons, :mouse_over
  attr_accessor :refresh_skillbar, :pearl_menu_call, :reserved_swap
  attr_accessor :new_map_id
  
  alias falcaopearl_initialize initialize
  def initialize
    @projectiles = []
    @damage_pop = []
    @anime_action = []
    @enemy_drops = []
    @press_timer = 0
    @mouse_over = 0
    @mouse_exist = defined?(Map_Buttons).is_a?(String)
    @refresh_skillbar = 0
    @pearl_menu_call = [sym = nil, 0]
    @reserved_swap = []
    falcaopearl_initialize
  end
  
  alias falcaopearl_poses_refresh refresh
  def refresh
    return if @knockdown_data[0] > 0
    falcaopearl_poses_refresh
  end
    
  def any_collapsing?
    return true if @colapse_time > 0
    @followers.each {|f| return true if f.visible? and f.colapse_time > 0}
    return false
  end
  
  # check if any follower is fighting
  def follower_fighting?
    @followers.each do |f|
      next unless f.visible?
      return true if f.targeted_character != nil
    end
    return false
  end
  
  # check if game party in combat mode
  def in_combat_mode?
    return true if follower_fighting? || battler_acting?
    return false
  end
  
  # get battler
  def battler
    return actor
  end
  
  def update_state_effects
    battler.dead? ? return : super
  end
  
  def trigger_tool?(key, type)
    return true if type == :keys && PearlKey.trigger?(key)
    return true if @mouse_exist && Mouse.trigger?(0) && type == :mouse && 
    @mouse_over == key
    return false
  end
  
  def all_jump(x, y)
    jumpto_tile(x, y)
    @followers.each {|f| f.jumpto_tile(x, y)}
  end
  
  alias falcaopearl_it_update update
  def update
    update_pearl_battle_set
    falcaopearl_it_update
  end
  
  # pearl battle update
  def update_pearl_battle_set
    @projectiles.each {|projectile| projectile.update}
    @pearl_menu_call[1] -= 1 if @pearl_menu_call[1] > 0
    update_tool_usage
    update_menu_buttons
  end
  
  if $imported["Falcao Interactive System Lite"]
    alias falcaopearl_int player_start_falling
    def player_start_falling
      return if @hookshoting[1]
      falcaopearl_int
    end
  end
  
  # get on vehicle
  alias falcaopearl_get_on_vehicle get_on_vehicle
  def get_on_vehicle
    return if follower_fighting?
    falcaopearl_get_on_vehicle
  end
  
  def update_tool_usage
    return if PearlSkillBar.hidden?
    return unless normal_walk?
    #--------------------------------------------------------------------------
    unless actor.equips[0].nil?
      use_weapon(actor.equips[0].id) if trigger_tool?(Key::Weapon[0], :keys) && !Input.press?(:kCTRL)
      use_weapon(actor.equips[0].id) if trigger_tool?(1, :mouse) 
    end
    #--------------------------------------------------------------------------
    unless actor.equips[1].nil?
      use_armor(actor.equips[1].id) if trigger_tool?(Key::Armor[0], :keys)
      use_armor(actor.equips[1].id) if trigger_tool?(2, :mouse) 
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_item.nil?
      use_item(actor.assigned_item.id) if trigger_tool?(Key::Item[0], :keys)
      use_item(actor.assigned_item.id) if trigger_tool?(3, :mouse) 
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_item2.nil?
      use_item(actor.assigned_item2.id) if trigger_tool?(Key::Item2[0], :keys)
      use_item(actor.assigned_item2.id) if trigger_tool?(4, :mouse) 
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_item3.nil?
      use_item(actor.assigned_item3.id) if trigger_tool?(Key::Item3[0], :keys)
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill.nil?
      use_skill(actor.assigned_skill.id) if trigger_tool?(Key::Skill[0], :keys)
      use_skill(actor.assigned_skill.id) if trigger_tool?(5, :mouse) 
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill2.nil?
      use_skill(actor.assigned_skill2.id) if trigger_tool?(Key::Skill2[0],:keys)
      use_skill(actor.assigned_skill2.id) if trigger_tool?(6, :mouse) 
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill3.nil?
      use_skill(actor.assigned_skill3.id) if trigger_tool?(Key::Skill3[0],:keys)
      use_skill(actor.assigned_skill3.id) if trigger_tool?(7, :mouse) 
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill4.nil?
      use_skill(actor.assigned_skill4.id) if trigger_tool?(Key::Skill4[0],:keys)
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill5.nil?
      use_skill(actor.assigned_skill5.id) if trigger_tool?(Key::Skill5[0],:keys)
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill6.nil?
      use_skill(actor.assigned_skill6.id) if trigger_tool?(Key::Skill6[0],:keys)
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill7.nil?
      use_skill(actor.assigned_skill7.id) if trigger_tool?(Key::Skill7[0],:keys)
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill8.nil?
      use_skill(actor.assigned_skill8.id) if trigger_tool?(Key::Skill8[0],:keys)
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill9.nil?
      use_skill(actor.assigned_skill9.id) if trigger_tool?(Key::Skill9[0],:keys)
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_skill10.nil?
      use_skill(actor.assigned_skill10.id) if trigger_tool?(Key::Skill10[0],:keys)
    end
    #--------------------------------------------------------------------------
    unless actor.assigned_sskill.nil?
      use_skill(actor.assigned_sskill.id) if trigger_tool?(Key::SSkill[0],:keys)
    end
    
    #--------------------------------------------------------------------------
    update_followers_trigger unless $game_map.interpreter.running?
  end
  #---------------------------------------------------------------------------
  # update followers trigger key
  # tag: follower
  #---------------------------------------------------------------------------
  def update_followers_trigger
    if PearlKernel::SinglePlayer and trigger_tool?(Key::Follower[0], :keys)
      return if @knockdown_data[0] > 0
      force_cancel_actions
      @pearl_menu_call = [:tools, 2]
      return
    end
    make_battle_followers if trigger_tool?(Key::Follower[0], :keys)
    make_battle_followers if trigger_tool?(9, :mouse)
    
    if PearlKey.press?(Key::Follower[0]) || @mouse_exist && Mouse.press?(0) &&
      @mouse_over == 9
      @press_timer += 1
      if @press_timer == 1 * 60
        @followers.each do |f|
          next unless f.visible?
          next if f.targeted_character.nil?
          withdraw_battle_follower(f)
        end
      end
    else
      @press_timer = 0 if @press_timer != 0
    end
  end
  
  #---------------------------------------------------------------------------
  # *) follower exit battle
  #---------------------------------------------------------------------------
  def withdraw_battle_follower(follower, show_msg = true)
    follower.turn_toward_player
    follower.targeted_character = nil
    follower.pop_damage('Scape') if show_msg
  end
  
  #---------------------------------------------------------------------------
  # *) follower into the fray
  #---------------------------------------------------------------------------
  def make_battle_followers
    @followers.each do |f|
      next unless f.visible?
      next if f.fo_tool.nil? || f.battler.dead? 
      make_battle_follower(f)
    end
  end
  #---------------------------------------------------------------------------
  # *) follower into the fray
  #---------------------------------------------------------------------------
  def make_battle_follower(f, move_free = true)
    f.pathfinding_moves.clear
    f.setup_followertool_usage if !targeted_character.nil?
    f.command_follow           if !targeted_character.nil? && move_free
    
    if f.targeted_character.nil?
      if f.fo_tool.tool_data("User Graphic = ", false).nil?
        if f.fo_tool.is_a?(RPG::Skill) || fo_tool.is_a?(RPG::Item)
          # has no data but is a benefical skill
          if f.fo_tool.scope == 0 || f.fo_tool.scope.between?(7, 11)
            f.setup_followertool_usage
          else
            f.balloon_id = PearlKernel::FailBalloon
          end # f.fo_tool.scope
        else
          f.balloon_id = PearlKernel::FailBalloon
          return
        end # if f.fo_tool.is_a?
      else
        f.setup_followertool_usage
      end # tool_data
    end # targeted_character.nil?
  end # def 
  #---------------------------------------------------------------------------
  # menu buttons update
  def update_menu_buttons
    return if $game_map.interpreter.running?
    return if @pearl_menu_call[1] > 0
    
    if PearlKey.trigger?(Key::QuickTool)
      return if @knockdown_data[0] > 0
      force_cancel_actions
      @pearl_menu_call = [:tools, 2]
    end
    if !PearlKernel::SinglePlayer and PearlKey.trigger?(Key::PlayerSelect)
      @pearl_menu_call = [:character, 2]
    end
  end
  
  def set_skill(id)
    actor.assigned_skill = $data_skills[id]
  end
  
  alias falcao_pearl_movable movable?
  def movable?
    return if force_stopped? || @blowpower[0] > 0
    falcao_pearl_movable
  end
  
  alias falcaopearl_perform_transfer perform_transfer
  def perform_transfer
    if $game_map.map_id !=  @new_map_id
      pearl_abs_global_reset
    end
    falcaopearl_perform_transfer
    
    
    @followers.each {|f|
    next unless f.visible?
    if f.battler.deadposing != nil
      f.battler.deadposing != $game_map.map_id ? f.transparent = true :
      f.transparent = false
      f.knockdown_data[0] = 10 #if follower.battler.deadposing != nil
      f.knowdown_effect(1)
    end}
  end
  
  alias falcaopearl_start_map start_map_event
  def start_map_event(x, y, triggers, normal)#, rect = collision_rect)
    $game_map.events_xy(x, y).each do |event|
      return if event.has_token?
    end  
    falcaopearl_start_map(x, y, triggers, normal)#, rect = collision_rect)
  end
end
# game party
class Game_Party < Game_Unit
  attr_accessor :actors
  def set_skill(actor_id, sid, slot)
    actor = $game_actors[actor_id] ; skill = $data_skills[sid]
    return unless actor.skill_learn?(skill)
    case slot
    when Key::Skill[1].to_sym  then actor.assigned_skill  = skill
    when Key::Skill2[1].to_sym then actor.assigned_skill2 = skill
    when Key::Skill3[1].to_sym then actor.assigned_skill3 = skill
    when Key::Skill4[1].to_sym then actor.assigned_skill4 = skill
    end
  end
  
  def set_item(actor_id, item_id, slot)
    actor = $game_actors[actor_id] ; item = $data_items[item_id]
    return unless has_item?(item)
    case slot
    when Key::Item[1].to_sym  then actor.assigned_item   = item
    when Key::Item2[1].to_sym then actor.assigned_item2  = item
    end
  end
end
#--------------------------------------------------------
class Game_Battler < Game_BattlerBase
  attr_reader   :state_steps
  attr_accessor :buff_turns, :buffs, :used_item, :deadposing
  attr_accessor :skill_cooldown,:item_cooldown,:weapon_cooldown, :armor_cooldown
  
  alias falcaopearl_battler_ini initialize
  def initialize
    @skill_cooldown = {}
    @item_cooldown = {}
    @weapon_cooldown = {}
    @armor_cooldown = {}
    falcaopearl_battler_ini
  end
  
  alias falcaopearl_revive revive
  def revive
    #if SceneManager.scene_is?(Scene_Item) || SceneManager.scene_is?(Scene_Skill)
    #  falcaopearl_revive
    #  $game_temp.pop_w(180, 'Pearl ABS', 
    #  'You cannot revive from menu!')
    #  return
    #end
    falcaopearl_revive
    @deadposing = nil
  end
  
  alias falcaopearl_addnew add_new_state
  def add_new_state(state_id)
    falcaopearl_addnew(state_id)
     if self.is_a?(Game_Actor)
      $game_player.refresh_skillbar = 4
    end
  end
  
  def tool_ready?(item)
    return false if item.is_a?(RPG::Skill)  and @skill_cooldown[item.id]
    return false if item.is_a?(RPG::Item)   and @item_cooldown[item.id]
    return false if item.is_a?(RPG::Weapon) and @weapon_cooldown[item.id]
    return false if item.is_a?(RPG::Armor)  and @armor_cooldown[item.id]
    return true
  end
  
  def apply_cooldown(item, value)
    @skill_cooldown[item.id]  = value if item.is_a?(RPG::Skill)
    @item_cooldown[item.id]   = value if item.is_a?(RPG::Item)
    @weapon_cooldown[item.id] = value if item.is_a?(RPG::Weapon)
    @armor_cooldown[item.id]  = value if item.is_a?(RPG::Armor)
  end
  
  # Make the steps settings to seconds for states if used in the scene map
  alias falcaopearl_stepsset reset_state_counts
  def reset_state_counts(state_id)
    falcaopearl_stepsset(state_id)
    state = $data_states[state_id]
    @state_steps[state_id] = state.steps_to_remove * 60 if 
    SceneManager.scene_is?(Scene_Map)
  end
  
  # make the buff turns per seconds if used in the scene map
  alias falcaopearl_buffs overwrite_buff_turns
  def overwrite_buff_turns(param_id, turns)
    if SceneManager.scene_is?(Scene_Map)
      time = turns * 60
      @buff_turns[param_id] = time if @buff_turns[param_id].to_i < time
      return
    end
    falcaopearl_buffs(param_id, turns)
  end
  
  # make the item occasion to always in the map
  alias falcaopearl_occasion_ok occasion_ok?
  def occasion_ok?(item)
    return true if SceneManager.scene_is?(Scene_Map) ||
    SceneManager.scene_is?(Scene_QuickTool) || 
    SceneManager.scene_is?(Scene_CharacterSet)
    falcaopearl_occasion_ok(item)
  end
  
  # apply the usability settings (used to refresh the skill bar icons)
  alias falcaopearl_usablecheck use_item
  def use_item(item)
    falcaopearl_usablecheck(item)
    self.apply_usability if self.is_a?(Game_Actor)
  end
  #-----------------------------------------------------------------------------
  # melee attack apply used with invoked tools
  #-----------------------------------------------------------------------------
  def melee_attack_apply(user, item_id)
    item_apply(user, $data_skills[item_id])
  end
  #-----------------------------------------------------------------------------
  # *) alias method: item apply
  #-----------------------------------------------------------------------------
  alias falcaopearl_itemapply item_apply
  def item_apply(user, item, source_item = item)
    @used_item = item
    falcaopearl_itemapply(user, item, source_item)
  end
end
#-------------------------------------------------------------------------------
# Game followers adds
#-------------------------------------------------------------------------------
class Game_Follower < Game_Character
  def battler
    return actor
  end
  
  alias falcaopearl_f_poses_refresh refresh
  def refresh
    return if @knockdown_data[0] > 0
    falcaopearl_f_poses_refresh
  end
  
  
  def update_state_effects
    battler.dead? ? return : super
  end
  
  # Make the followers inpassable if they are in battle state
  alias falcaopearl_follower_update update
  def update
    if $game_player.followers.gathering? || $game_player.hookshoting[1] ||
      @hookshoting[1]
      @through = true
    else
      @through = false if @through
    end
    falcaopearl_follower_update
    
    @transparent = lying_down? if visible? and $game_player.normal_walk?
    @transparent = false if $game_player.using_custom_g
    
  end
  
  def lying_down?
    return true if !battler.deadposing.nil?  && 
    battler.deadposing != $game_map.map_id
    return false
  end
  
  # avoid the followers to chase the preceding character in battle
  alias falcaopearl_chase_preceding_character chase_preceding_character
  def chase_preceding_character
    return if @blowpower[0] > 0
    return if @targeted_character != nil
    if visible? and $game_player.follower_fighting?
      return if fo_tool.nil?
      return if battler.dead?
    end
    
    $game_player.reserved_swap.each {|i| 
    
    if i == battler.id
      swap_dead_follower
      $game_player.reserved_swap.delete(i)
    end}
    
    
    jumpto(0) if @targeted_character.nil? && !obj_size?($game_player, 6) &&
    !stopped_any?
    falcaopearl_chase_preceding_character
  end
  
  def stopped_any?
    $game_player.followers.each do |follower|
      return true if follower.force_stopped?
    end
    return false
  end
  
  # set up a target for followers
  def setup_target
    for event in $game_map.event_enemies
      if event.on_battle_screen? && event.enemy_ready?
        if $game_player.obj_size?(event, PearlKernel::PlayerRange)# && !event.being_targeted
          @targeted_character = event
          event.being_targeted = true
          if @hint_cooldown == 0
            self.pop_damage("Attack target")
            @hint_cooldown = 30
          end
          break
        end
      end
    end
  end
  
  def move_straight(d, turn_ok = true)
    return if force_stopped?
    super
  end
  
  def move_diagonal(horz, vert)
    return if force_stopped?
    super
  end
  
  alias falcaoabs_gather gather?
  def gather?
    return true if !battler.deadposing.nil?
    falcaoabs_gather
  end
end
#-------------------------------------------------------------------------------
# Game Actor adds
class Game_Actor < Game_Battler
  attr_accessor :assigned_skill, :assigned_item, :primary_use
  attr_accessor :assigned_skill2, :assigned_item2, :assigned_item3, :usability
  attr_accessor :assigned_skill3, :assigned_skill4, :assigned_skill5
  attr_accessor :assigned_skill6, :assigned_skill7, :assigned_skill8
  attr_accessor :assigned_skill9, :assigned_skill10, :assigned_sskill
  
  alias falcaopearl_cooldown_setup setup
  def setup(actor_id)
    @usability = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    @primary_use = 1
    falcaopearl_cooldown_setup(actor_id)
  end
  
  # player walk 
  alias falcaopearl_on_player_walk on_player_walk
  def on_player_walk
    @result.clear
    check_floor_effect
    return
    falcaopearl_on_player_walk
  end
  
  #usability refresher
  def apply_usability
    apply_usabilityto_melee(0) # weapon
    apply_usabilityto_melee(1) # armor
    @usability[2] = usable?(@assigned_item) if !@assigned_item.nil?
    @usability[3] = usable?(@assigned_item2) if !@assigned_item2.nil?
    @usability[4] = usable?(@assigned_skill) if !@assigned_skill.nil?
    @usability[5] = usable?(@assigned_skill2) if !@assigned_skill2.nil?
    @usability[6] = usable?(@assigned_skill3) if !@assigned_skill3.nil?
    @usability[7] = usable?(@assigned_skill4) if !@assigned_skill4.nil?
  end
 #-------------------------------------------------------------------------------
 #  *) Apply melee wepaon damage
 #-------------------------------------------------------------------------------
  def apply_usabilityto_melee(index)
    if !equips[index].nil?
      invoke = equips[index].tool_data("Tool Invoke Skill = ")
      if invoke != nil and invoke != 0 and index == 0
        @usability[index] = usable?($data_skills[invoke])
      elsif index == 0
        @usability[index] = usable?($data_skills[1])
      end
      if invoke != nil and invoke != 0 and index == 1
        @usability[index] = usable?($data_skills[invoke])
      elsif index == 1
        @usability[index] = usable?($data_skills[2])
      end
    end
  end
end
#-------------------------------------------------------------------------------
# Game character adds, the agro system
#-------------------------------------------------------------------------------
class Game_Character < Game_CharacterBase
  
  # agro to follower turn towars player
  alias pearlagro_turn_toward_player turn_toward_player
  def turn_toward_player
    if self.is_a?(Game_Event) and self.agroto_f != nil
      turn_toward_character(self.agroto_f)
      return
    end
    pearlagro_turn_toward_player
  end
 
  # agro to follower turn away from player
  alias pearlagro_turn_away_from_player turn_away_from_player
  def turn_away_from_player
    if self.is_a?(Game_Event) and self.agroto_f != nil
      turn_away_from_character(self.agroto_f)
      return
    end
    pearlagro_turn_away_from_player
  end
  
  # agro to game follower move toward player
  alias pearlagro_move_toward_player move_toward_player
  def move_toward_player
    if self.is_a?(Game_Event) and self.agroto_f != nil
      move_toward_character(self.agroto_f)
      return
    end
    pearlagro_move_toward_player
  end
  
  # agro away from follower
  alias pearlagro_move_away_from_player move_away_from_player
  def move_away_from_player
    if self.is_a?(Game_Event) and self.agroto_f != nil
      move_away_from_character(self.agroto_f)
      return
    end
    pearlagro_move_away_from_player
  end
end
# enemy
class Game_Enemy < Game_Battler
  attr_accessor :battler_graphic, :breath_enable, :object, :collapse_type
  attr_accessor :die_animation, :kill_weapon, :kill_armor, :kill_item 
  attr_accessor :kill_skill, :body_sized, :esensor, :boss_hud, :k_back_dis
  attr_reader   :lowhp_10, :lowhp_25, :lowhp_50, :lowhp_75
  alias falcaopearl_enemy_ini initialize
  def initialize(index, enemy_id)
    falcaopearl_enemy_ini(index, enemy_id)
    @kill_weapon = []
    @kill_armor = []
    @kill_item = []
    @kill_skill = []
    
    @battler_graphic = enemy.tool_data("Enemy Battler = ",false) == "true"
    @breath_enable = enemy.tool_data("Enemy Breath = ",false) == "true"
    @object = enemy.tool_data("Enemy Object = ", false) == "true"
    @collapse_type = enemy.tool_data("Enemy Collapse Type = ", false)
    @die_animation = enemy.tool_data("Enemy Die Animation = ")
    @body_sized = enemy.tool_data("Enemy Body Increase = ")
    @boss_hud = enemy.tool_data("Enemy Boss Bar = ", false) == "true"
    @esensor = enemy.tool_data("Enemy Sensor = ")
    @esensor = PearlKernel::Sensor if @esensor.nil?
    @body_sized = 0 if @body_sized.nil?
    @k_back_dis = enemy.tool_data("Enemy Knockback Disable = ",false) == "true"
    
    @lowhp_75 = enemy.tool_data("Enemy Lowhp 75% Switch = ")
    @lowhp_50 = enemy.tool_data("Enemy Lowhp 50% Switch = ")
    @lowhp_25 = enemy.tool_data("Enemy Lowhp 25% Switch = ")
    @lowhp_10 = enemy.tool_data("Enemy Lowhp 10% Switch = ")
    apply_kill_with_settings
  end
  
  def apply_kill_with_settings
    wtag = enemy.tool_data("Enemy Kill With Weapon = ", false)
    @kill_weapon = wtag.split(",").map { |s| s.to_i } if wtag != nil
    atag = enemy.tool_data("Enemy Kill With Armor = ", false)
    @kill_armor = atag.split(",").map { |s| s.to_i } if atag != nil
    itag = enemy.tool_data("Enemy Kill With Item = ", false)
    @kill_item = itag.split(",").map { |s| s.to_i } if itag != nil
    stag = enemy.tool_data("Enemy Kill With Skill = ", false)
    @kill_skill = stag.split(",").map { |s| s.to_i } if stag != nil
  end
  
  def has_kill_with?
    !@kill_weapon.empty? || !@kill_armor.empty? || !@kill_item.empty? ||
    !@kill_skill.empty?
  end
end
# make refresh
class Game_BattlerBase
  alias falcaopearl_erasestate erase_state
  def erase_state(state_id)
    falcaopearl_erasestate(state_id)
    if self.is_a?(Game_Actor)
      $game_player.refresh_skillbar = 4
    end
  end
end
#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
class Game_Followers
  #------------------------------------------------------------------------------
  # *) Overwrite mehtod: synchornize
  #------------------------------------------------------------------------------
  def synchronize(x, y, d)
    
    if $character_swapped
      $character_swapped = false
      return
    end
    
    each do |follower|
      next if follower.visible? and follower.battler.deadposing != nil
      next if follower.targeted_character != nil
      follower.moveto(x, y)
      follower.set_direction(d)
    end
  end
  
end
#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
class Game_Interpreter
  alias falcaopearl_intsystem_command_201 command_201
  def command_201
    return if $game_player.any_collapsing?
    falcaopearl_intsystem_command_201
  end
end
#-------------------------------------------------------------------------------
