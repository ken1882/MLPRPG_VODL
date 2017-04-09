#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :state_steps
  attr_accessor :map_char     # character on the map
  attr_accessor :skill_cooldown, :item_cooldown, :weapon_cooldown, :armor_cooldown
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_battler_opt initialize
  def initialize
    @skill_cooldown = {}
    @item_cooldown = {}
    @weapon_cooldown = {}
    @armor_cooldown = {}
    @map_char = nil
    init_battler_opt
  end
  #--------------------------------------------------------------------------
  def cooldown_ready?(item)
    return @skill_cooldown[item.id] > 0  if @skill_cooldown[item.id]  && item.is_a?(RPG::Skill)
    return @item_cooldown[item.id] > 0   if @item_cooldown[item.id]   && item.is_a?(RPG::Item)
    return @weapon_cooldown[item.id] > 0 if @weapon_cooldown[item.id] && item.is_a?(RPG::Weapon)
    return @armor_cooldown[item.id] > 0  if @armor_cooldown[item.id]  && item.is_a?(RPG::Armor)
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine Skill/Item Usability
  #--------------------------------------------------------------------------
  def usable?(item)
    return false if !cooldown_ready?(item)
    return skill_conditions_met?(item)  if item.is_a?(RPG::Skill)
    return item_conditions_met?(item)   if item.is_a?(RPG::Item)
    return weapon_conditions_met?(item) if item.is_a?(RPG::Weapon)
    return false
  end
  #--------------------------------------------------------------------------
  # * Weapon Ammo Ready?
  #--------------------------------------------------------------------------
  def weapon_conditions_met?(item)
    if item.tool_itemcost != nil || item.tool_itemcosttype != nil
      return weapon_ammo_ready?(item)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Cost of Using Skill Can Be Paid
  #--------------------------------------------------------------------------
  def skill_cost_payable?(skill)
    re = super(skill)
    if !item.tool_itemcost && item.tool_itemcost > 0
      item = $data_items[itemcost]
      re  &= $game_party.item_number(item)
    elsif item.tool_itemcosttype != nil
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
    popup_hp_change(-@result.hp_damage)    if @result.hp_damage != 0
    popup_ep_change(-@result.mp_damage)    if @result.mp_damage != 0
    user.popup_hp_change(@result.hp_drain) if @result.hp_drain  != 0
    user.popup_ep_change(@result.mp_drain) if @result.mp_drain  != 0
    execute_damage_popup(user)
  end
  
  def team_id
    return enemy.team_id if self.is_a?(Game_Event)
    return @team_id.nil? ? @team_id : 0
  end
  
end
