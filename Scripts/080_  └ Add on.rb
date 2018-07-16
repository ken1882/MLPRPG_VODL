#==============================================================================
# ** Game_BattlerBase
#------------------------------------------------------------------------------
#  This base class handles battlers. It mainly contains methods for calculating
# parameters. It is used as a super class of the Game_Battler class.
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :reg_time_count             # regeneration time counter
  attr_reader   :shp                        # HP
  attr_reader   :smp                        # MP
  attr_reader   :class_id
  attr_reader   :dualclass_id, :race_id, :subrace_id
  #--------------------------------------------------------------------------
  # * Access Method by Parameter Abbreviations
  #--------------------------------------------------------------------------
  def ctr;  sparam(3); end     # CTR Casting Time Reducation Rate
                                            # Original: Pharmacology
  def csr;  sparam(5); end     # CSR Casting Speed Rate
                                            # Original: TP Charge Rate
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_reg_dnd initialize
  def initialize
    @reg_time_count = 0
    initialize_reg_dnd
    @shp = PONY.EncInt(@hp)
    @smp = PONY.EncInt(@mp)
    @dualclass_id = 0
    @race_id = @subrace_id = 0
    @class_objects = []
  end
  #--------------------------------------------------------------------------
  # * Change HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    hp = [[hp, mhp].min, 0].max
    delta = hp - @hp
    return if delta == 0
    check_security
    popup_hp_change(delta) if delta != 0
    @hp  = hp
    refresh
    update_security
  end
  #--------------------------------------------------------------------------
  # * Change MP
  #--------------------------------------------------------------------------
  def mp=(mp)
    mp = [[mp, mmp].min, 0].max
    delta = mp - @mp
    return if delta == 0
    check_security
    popup_ep_change(delta) if delta > 30
    @mp  = mp
    refresh
    update_security
  end
  #--------------------------------------------------------------------------   
  # ● Easier method for check skilll learned
  #--------------------------------------------------------------------------   
  def skill_learned?(id)
    return self.skills.include?($data_skills[id])
  end
  #--------------------------------------------------------------------------
  def setup_dnd_battler(instance)
    @class_objects = []
    
    @class_id     = instance.class_id
    @dualclass_id = instance.dualclass_id
    @race_id      = instance.race_id
    @subrace_id   = instance.subrace_id
    @class_level  = instance.class_levelcap.collect{|lvl| lvl.first}
    
    @level  = @level ? @level : (@class_level[@class_id] || 0)
    @level += @class_level[@dualclass_id] if @dualclass_id > 0
    @class_level[@race_id] = @class_level[@subrace_id] = @level
  end
  #--------------------------------------------------------------------------
  def class_objects
    return @class_objects unless @class_objects.empty?
    re = []
    
    primary = $data_classes[@class_id]
    re << primary
    re << $data_classes[primary.parent_class] if primary.parent_class > 0
    
    if @dualclass_id > 0
      dual     = $data_classes[@dualclass_id]
      d_parent = $data_classes[primary.parent_class] if dual.parent_class > 0
      re << dual << d_parent
    end
    
    re << $data_classes[@race_id]     if @race_id > 0
    re << $data_classes[@subrace_id]  if @subrace_id > 0
    
    return @class_objects = re
  end
  #--------------------------------------------------------------------------
  def init_skills
    @skills = []
    class_objects.each do |obj|
      next unless obj.id > 0
      learn_class_skills(obj.id)
    end
  end
  #--------------------------------------------------------------------------
  def learn_class_skills(cid)
    return unless cid.to_bool
    $data_classes[cid].learnings.each do |learning|
      next if learning.level > @class_level[cid]
      learn_skill(learning.skill_id)
    end
  end
  #--------------------------------------------------------------------------
  # * Learn Skill
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    return if $data_skills[skill_id].for_leveling?
    return if skill_learn?($data_skills[skill_id])
    @skills.push(skill_id)
    @skills.sort!
  end
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  def level_up
    @level += 1
    level_up_class(@race_id)
    level_up_class(@subrace_id)
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  def level_up_class(cid)
    return unless cid.to_bool
    @class_level[cid] += 1
    learn_class_skills(cid)
  end
  #---------------------------------------------------------------------------
  def param_base(id)
    return class_objects.inject(0){|sum, obj| sum + obj.param(id)}
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Value of Parameter
  #--------------------------------------------------------------------------
  def param_max(param_id)
    return 9999 if (param_id >> 1) == 0  # MHP/MMP
    return 99 
  end
  #--------------------------------------------------------------------------
  def change_class(cid, keep_lvl = true)
    @class_objects.clear
    @class_level[cid] = @class_level[@class_id] if keep_lvl
    @class_id = cid
    refresh
  end
  #--------------------------------------------------------------------------
  def advance_dualclass(cid, keep_lvl = true)
    @class_objects.clear
    @class_level[cid] = @class_level[@dualclass_id] if keep_lvl
    @dualclass_id = cid
    refresh
  end
  #--------------------------------------------------------------------------
  def change_race(cid, keep_lvl = true)
    @class_objects.clear
    @class_level[cid] = @class_level[@race_id] if keep_lvl
    @race_id = cid
    refresh
  end
  #--------------------------------------------------------------------------
  def change_subrace(cid, keep_lvl = true)
    @class_objects.clear
    @class_level[cid] = @class_level[@subrace_id] if keep_lvl
    @subrace_id = cid
    refresh
  end
  #--------------------------------------------------------------------------
  # ● Posioned?
  #--------------------------------------------------------------------------   
  def poisoned?
    return self.states.any?{|state| state.is_poison?}
  end
  #--------------------------------------------------------------------------
  # ● Debuffed?
  #--------------------------------------------------------------------------   
  def debuffed?
    return self.states.any?{|state| state.is_poison?}
  end
  #--------------------------------------------------------------------------
  # ● Dispel Magic
  #--------------------------------------------------------------------------   
  def dispel_magic
    animated = false
    for state in self.states
      next if state.nil?
      animated = true if state.id == 271 # original for animted dead, reservered
                                         # for furture usage
      remove_state(state.id) if state.is_magic?
    end
    die if animated
  end
  #--------------------------------------------------------------------------
  # ● Anti Magic?
  #--------------------------------------------------------------------------   
  def anti_magic?
    
    result = false
    source = 0
    
     if @anti_magic
       result = true; source = 1
     end
     
    if self.mrf > 0.5
      result = true; source = 2 
    end
    
    anti_magic_state = [266,267,288]
    
    for id in anti_magic_state
      if self.state?(id)
        source = id
        result = true
        break
      end
  
    end
    
    return result
  end
  #--------------------------------------------------------------------------
  # Hide HP/MP info
  #--------------------------------------------------------------------------
  def hide_info?
    false
  end
  #--------------------------------------------------------------------------
  # * Check When Skill/Item Can Be Used
  #--------------------------------------------------------------------------
  def occasion_ok?(item)
    SceneManager.scene_is?(Scene_Map) ? item.battle_ok? : item.menu_ok?
  end
  #--------------------------------------------------------------------------   
  def popup_hp_change(value)
    return unless SceneManager.scene_is?(Scene_Map)
    color = value < 0 ? DND::COLOR::HPDamage : DND::COLOR::HPHeal
    popup_info(value.abs.to_s, color)
  end
  #--------------------------------------------------------------------------   
  def popup_ep_change(value)
    return unless SceneManager.scene_is?(Scene_Map)
    color = value < 0 ? DND::COLOR::EPDamage : DND::COLOR::EPHeal
    popup_info(value.abs.to_s, color)
  end
  #--------------------------------------------------------------------------
  # * Determine if Equippable
  #--------------------------------------------------------------------------
  alias :freehoof_equippable? :equippable?
  def equippable?(item)
    return freehoof_equippable?(item)
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Refresh
  #--------------------------------------------------------------------------
  def refresh
    state_resist_set.each {|state_id| erase_state(state_id) }
    @hp = [[@hp, mhp].min, 0].max
    @mp = [[@mp, mmp].min, 0].max
    @hp == 0 ? add_state(death_state_id, self) : remove_state(death_state_id)
  end
  #--------------------------------------------------------------------------
  # * Clear State Information
  #--------------------------------------------------------------------------
  alias clear_states_gbb clear_states
  def clear_states
    @state_enchanter = {}
    clear_states_gbb
  end
  #--------------------------------------------------------------------------
  # * Erase States
  #--------------------------------------------------------------------------
  alias erase_state_gbb erase_state
  def erase_state(state_id)
    @state_enchanter.delete(state_id)
    erase_state_gbb(state_id)
  end
  #--------------------------------------------------------------------------
end
