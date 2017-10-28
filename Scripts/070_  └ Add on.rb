#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :dualclass_id                 # Second class ID
  attr_accessor :assigned_hotkey
  #------------------------------------------------------------------------
  # * Set hashid
  #------------------------------------------------------------------------
  def hash_self
    @hashid = actor.hashid
    super
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_muticlass initialize
  def initialize(actor_id)
    @dualclass_id = 0
    @team_id = 0
    @assigned_hotkey = Array.new(HotKeys::HotKeys.size){nil}
    init_muticlass(actor_id)
    hash_self
  end
  #--------------------------------------------------------------------------
  alias :is_a_obj? :is_a?
  def is_a?(cls)
    return is_a_obj?(cls) || actor.is_a?(cls)
  end
  #--------------------------------------------------------------------------
  def dualclass
    $data_classes[@dualclass_id]
  end
  #--------------------------------------------------------------------------
  def setup_dualclass(class_id)
    @dualclass_id = class_id
  end
  #--------------------------------------------------------------------------
  # *) Get equipped all items
  #--------------------------------------------------------------------------
  def get_hotkeys(equip_only = false)
    items = [@equips[0], @equips[1]]
    unless equip_only
      @assigned_hotkey.each {|item| items.push(item)}
    end
    return items
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Processing Performed When Player Takes 1 Step
  #--------------------------------------------------------------------------
  def on_player_walk
    #@result.clear
    check_floor_effect
    if $game_player.normal_walk?
      #turn_end_on_map
      states.each {|state| update_state_steps(state) }
      show_added_states
      show_removed_states
    end
  end
  #--------------------------------------------------------------------------
  # * End of Turn Processing on Map Screen
  #--------------------------------------------------------------------------
  def turn_end_on_map
    on_turn_end
    perform_map_damage_effect if @result.hp_damage > 0
  end
  #--------------------------------------------------------------------------
  # * Get general skills for hotkey bar usage
  #--------------------------------------------------------------------------
  def get_valid_skills
    skills.select{|skill| !skill.is_passive? && !skill.is_vancian?}
  end
  #--------------------------------------------------------------------------
  # * Get valid skills for hotkey bar usage
  #--------------------------------------------------------------------------
  def get_vancian_spells
    skills.select{|skill| skill.is_vancian?}
  end
  #--------------------------------------------------------------------------
  def current_ammo
    equips.at(self.class.ammo_slot_id)
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_base(param_id)
    return DND::ACTOR_PARAMS[@actor_id].at(param_id) rescue 8
  end
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  def level_up
    @level += 1
    self.class.level_up
    self.class.learnings.each do |learning|
      learn_skill(learning.skill_id) if learning.level == @level
    end
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  def aggressive_level
    return @aggressive_level
  end
  #--------------------------------------------------------------------------
  def next_action
    return nil if @map_char.nil?
    @map_char.next_action
  end
  #--------------------------------------------------------------------------
  def action
    return nil if @map_char.nil?
    @map_char.action
  end
  #--------------------------------------------------------------------------
  def death_graphic;    return actor.death_graphic;   end
  def death_index;      return actor.death_index;     end
  def death_pattern;    return actor.death_pattern;   end
  def death_direction;  return actor.death_direction; end
  def death_sound;      return actor.death_sound;     end
  def icon_index;       return actor.icon_index;      end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     slot_id:  Equipment slot ID
  #     item:    Weapon/armor (remove equipment if nil)
  #--------------------------------------------------------------------------
  # tag: equipment
  def change_equip(slot_id, item)
    return unless trade_item_with_party(item, equips[slot_id])
    if item
      if equip_slots[slot_id] == 1
        return unless offhoof_equippable?(equip_slots[slot_id], item)
      else
        return if equip_slots[slot_id] != item.etype_id
      end
    end
    @equips[slot_id].object = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Change Experience
  #--------------------------------------------------------------------------
  alias change_exp_security change_exp
  def change_exp(exp, show)
    check_security
    change_exp_security(exp, show)
    update_security
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Actor
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, args) unless @map_char
    super(symbol, args) unless @map_char.methods.include?(symbol)
    @map_char.method(symbol).call(*args)
  end
  
end
