#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
#tag: battler
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :state_steps
  attr_reader   :safe_hash
  attr_reader   :skill_charges
  attr_accessor :map_char     # character on the map
  attr_accessor :stiff        # Stiff time
  attr_accessor :skill_cooldown, :item_cooldown, :weapon_cooldown, :armor_cooldown
  attr_accessor :move_limit
  attr_accessor :aggressive_level
  attr_accessor :team_id
  attr_accessor :last_attacked_action
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_battler_opt initialize
  def initialize
    @skill_cooldown   = {}
    @item_cooldown    = {}
    @weapon_cooldown  = {}
    @armor_cooldown   = {}
    @skill_charges    = {}
    @map_char         = nil
    @stiff            = 0
    @move_limit       = DND::BattlerSetting::MoveLimit
    @aggressive_level = DND::BattlerSetting::AggressiveLevel
    @last_attacked_action = []
    init_battler_opt
  end
  #--------------------------------------------------------------------------
  def cooldown_ready?(item)
    return @skill_cooldown[item.id] == 0  if @skill_cooldown[item.id]  && item.is_a?(RPG::Skill)
    return @item_cooldown[item.id] == 0   if @item_cooldown[item.id]   && item.is_a?(RPG::Item)
    return @weapon_cooldown[item.id] == 0 if @weapon_cooldown[item.id] && item.is_a?(RPG::Weapon)
    return @armor_cooldown[item.id] == 0  if @armor_cooldown[item.id]  && item.is_a?(RPG::Armor)
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine Skill/Item Usability
  #--------------------------------------------------------------------------
  def usable?(item, ignore_cdt = false)
    return false if !item
    return false if !ignore_cdt && !cooldown_ready?(item)
    return skill_conditions_met?(item)  if item.is_a?(RPG::Skill)
    return item_conditions_met?(item)   if item.is_a?(RPG::Item)
    return false if !item.is_a?(RPG::UsableItem) && !SceneManager.scene_is?(Scene_Map)
    return weapon_conditions_met?(item) if item.is_a?(RPG::Weapon)
    return false
  end
  #--------------------------------------------------------------------------
  # * Weapon Ammo Ready?
  #--------------------------------------------------------------------------
  def weapon_conditions_met?(item)
    if item.item_required?
      return weapon_ammo_ready?(item)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Cost of Using Skill Can Be Paid
  #--------------------------------------------------------------------------
  def skill_cost_payable?(skill)
    re = super(skill)
    item = skill
    if !item.tool_itemcost && item.tool_itemcost > 0
      item = $data_items[itemcost]
      re  &= $game_party.item_number(item)
    elsif item.tool_itemcost_type > 0
      re  &= weapon_ammo_ready?(@equips[0])
    end
    return re
  end
  #--------------------------------------------------------------------------
  # * Damage Processing
  #    @result.hp_damage @result.mp_damage @result.hp_drain
  #    @result.mp_drain must be set before call.
  #--------------------------------------------------------------------------
  alias execute_damage_popup execute_damage
  def execute_damage(user)
    #popup_hp_change(-@result.hp_damage)    if @result.hp_damage != 0
    #popup_ep_change(-@result.mp_damage)    if @result.mp_damage != 0
    #user.popup_hp_change(@result.hp_drain) if @result.hp_drain  != 0
    #user.popup_ep_change(@result.mp_drain) if @result.mp_drain  != 0
    execute_damage_popup(user)
  end
  #--------------------------------------------------------------------------   
  def team_id
    return @team_id | 0
  end
  #--------------------------------------------------------------------------   
  def is_opponent?(charactor)
    return BattleManager.is_opponent?(self, charactor)
  end
  alias is_enemy? is_opponent?
  #--------------------------------------------------------------------------   
  def is_friend?(charactor)
    return BattleManager.is_friend?(self, charactor)
  end
  alias is_ally? is_friend?
  #--------------------------------------------------------------------------
  # * Test Skill/Item Application
  #    Used to determine, for example, if a character is already fully healed
  #   and so cannot recover anymore.
  #--------------------------------------------------------------------------
  def item_test(user, item)
    return false if casting?
    item = item.object if item.methods.include?(:object)
    return true if (item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)) && SceneManager.scene_is?(Scene_Map)
    return false if item.for_dead_friend? != dead?
    return true if item.for_opponent?
    return true if item.is_a?(RPG::UsableItem) && item.damage.recover? && item.damage.to_hp? && hp < mhp
    return true if item.is_a?(RPG::UsableItem) && item.damage.recover? && item.damage.to_mp? && mp < mmp
    return true if item.is_a?(RPG::UsableItem) && item_has_any_valid_effects?(user, item)
    return true if item.is_a?(RPG::UsableItem) && !item.damage.none?
    return false
  end
  #--------------------------------------------------------------------------
  # * Alias: die (Knock Out)
  #--------------------------------------------------------------------------
  alias die_dnd die
  def die
    die_dnd
    @map_char.kill if @map_char
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Processing at End of Turn
  #--------------------------------------------------------------------------
  def on_turn_end
    @result.clear
    update_state_turns
    update_buff_turns
    remove_states_auto(2)
    @last_attacked_action.shift unless @last_attacked_action.empty?
  end
  #--------------------------------------------------------------------------
  # * Regenerate HP
  #--------------------------------------------------------------------------
  def regenerate_hp
    damage = -(100 * hrg).to_i
    damage *= 10 if !$game_party.in_combat?
    perform_map_damage_effect if $game_party.in_battle && damage > 0
    @result.hp_damage = [damage, max_slip_damage].min
    self.hp -= @result.hp_damage
  end
  #--------------------------------------------------------------------------
  # * Regenerate MP
  #--------------------------------------------------------------------------
  def regenerate_mp
    @result.mp_damage = -(100 * mrg).to_i
    @result.mp_damage *= 10 if !$game_party.in_combat? && (100 * mrg) > 0
    self.mp -= @result.mp_damage
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Add State
  #--------------------------------------------------------------------------
  def add_state(state_id, duration = nil)
    if state_addable?(state_id)
      add_new_state(state_id) unless state?(state_id)
      reset_state_counts(state_id, duration)
      if @map_char && self.is_a?(Game_Actor) && PONY::LightStateID.keys.include?(state_id)
        light_id = PONY::LightStateID[state_id]
        @map_char.setup_light(light_id)
      end
      @result.added_states.push(state_id).uniq!
    end
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Remove State
  #--------------------------------------------------------------------------
  def remove_state(state_id)
    if state?(state_id)
      revive if state_id == death_state_id
      erase_state(state_id)
      @map_char.dispose_light if @map_char && self.is_a?(Game_Actor) && PONY::LightStateID.keys.include?(state_id)
      refresh
      @result.removed_states.push(state_id).uniq!
    end
  end
  #--------------------------------------------------------------------------
  # * Alias: Determine if States Are Addable
  #--------------------------------------------------------------------------
  alias :magic_state_addable? :state_addable?
  def state_addable?(state_id)
    return false if anti_magic? && $data_states[state_id].is_magic?
    return magic_state_addable?(state_id)
  end
  #--------------------------------------------------------------------------
  # * Alias: Reset State Counts (Turns and Steps)
  #--------------------------------------------------------------------------
  alias reset_state_counts_default reset_state_counts
  def reset_state_counts(state_id, duration = nil)
    state = $data_states[state_id]
    return reset_state_counts_default(state_id) if duration.nil?
    @state_turns[state_id] = duration
    @state_steps[state_id] = state.steps_to_remove
  end
  #--------------------------------------------------------------------------
  # * Use Skill/Item
  #    Called for the acting side and applies the effect to other than the user.
  #--------------------------------------------------------------------------
  def use_item(item)
    pay_skill_cost(item) if item.is_a?(RPG::Skill)
    consume_item(item)   if item.is_a?(RPG::Item)
    return unless item.is_a?(RPG::Skill) || item.is_a?(RPG::Item)
    item.effects.each {|effect| item_global_effect_apply(effect) }
  end
  #--------------------------------------------------------------------------
  # * Alias: Use Skill/Item
  #--------------------------------------------------------------------------
  alias use_item_dnd use_item
  def use_item(item)
    use_item_dnd(item)
    $game_party.skillbar.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # * Alias: Revive from Knock Out
  #--------------------------------------------------------------------------
  alias revive_dnd revive
  def revive
    revive_dnd
    update_security
    erase_state(death_state_id) if state?(death_state_id)
    @map_char.revive_character if @map_char
  end
  #---------------------------------------------------------------------------
  # * Immune weapon enchant level, 0 = none, 1 = below +1 and so on
  #---------------------------------------------------------------------------
  def weapon_level_prof
    return 0
  end
  #---------------------------------------------------------------------------
  # * Update security hash value
  #---------------------------------------------------------------------------
  def update_security
    v = @hp + @mp + exp
    @safe_hash = PONY.MD5(v.to_s)
  end
  #---------------------------------------------------------------------------
  # * Abort if hash check failed
  #---------------------------------------------------------------------------
  def check_security
    update_security if @safe_hash.nil?
    v = @hp + @mp + exp
    result = ( @safe_hash == PONY.MD5(v.to_s) )
    return true if result
    p SPLIT_LINE
    puts "Name: #{name} Sum: #{v} Safe-hash: #{@safe_hash} Hash: #{PONY.MD5(v.to_s)}"
    PONY::ERRNO.raise(:secure_hash_failed, :exit, nil, name)
    return false
  end
  #---------------------------------------------------------------------------
  # * Max tactic command count
  #---------------------------------------------------------------------------
  def command_limit
    return 20
  end
  #---------------------------------------------------------------------------
  def icon_index
    return 0;
  end
  #--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  def recover_all
    super
    update_security
  end
end
