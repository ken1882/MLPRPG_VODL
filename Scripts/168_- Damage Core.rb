#==============================================================================
# ** Game_ActionResult
#------------------------------------------------------------------------------
#  This class handles the results of battle actions. It is used internally for
# the Game_Battler class. 
#==============================================================================
class Game_ActionResult
  attr_accessor :interrupted
  attr_accessor :hited
  #--------------------------------------------------------------------------
  # * Alias :Clear Hit Flags
  #--------------------------------------------------------------------------
  alias clear_hit_flags_dnd clear_hit_flags
  def clear_hit_flags
    @interrupted = false
    @hited       = false
    clear_hit_flags_dnd
  end
  
  #--------------------------------------------------------------------------
  # * overwrite :hit?
  #--------------------------------------------------------------------------
  def hit?
    @used && !@missed && !@evaded && !@interrupted && @hited
  end
end
#==============================================================================
# ** Core Damage Processing
# -----------------------------------------------------------------------------
# D&D based damages!
#==============================================================================
class Game_Battler < Game_BattlerBase
  # ---------------------------------------------------------------------------
  # *) Overwrite make damage value
  # tag: damage
  # ---------------------------------------------------------------------------
  def make_damage_value(user, item, source_item)
    
    damages = roll_base_damages(user, item)
    cnt = 0
    
    (0...damages.size).each do |value|
      value   = damages[value]
      value   = apply_other_effect(user,item,value)       if cnt == 0
      value   = apply_damage_modifiers(user, item, value) if cnt == 0
      cnt += 1
      
      if value == 0
        #text = sprintf("%s - Weapon Ineffective",self.name)
        text = sprintf("%s - %s immune to my damage", user.name, self.name)
        SceneManager.display_info(text)
      end
      
      @result.hited = true if value < 0
      @result.critical = @result.missed = false if value < 0
      @result.make_damage(value.to_i, source_item)
      apply_after_effect(user,item,value)
    end # each do
  end
  # ---------------------------------------------------------------------------
  # *) Make base damage via rolls
  # ---------------------------------------------------------------------------
  def roll_base_damages(user, item)
    damages = []
    
    for feat in item.damage_index
      damages.push(process_damage_roll(feat, user, item))
    end
    
    return damages
  end
  #------------------------------------------------------------------------
  # process damage roll
  # tag: damage
  #------------------------------------------------------------------------
  def process_damage_roll(damage_feature, user, item)
    
    time     = damage_feature[0]
    face     = damage_feature[1]
    bonus    = damage_feature[2]
    element  = damage_feature[3]
    modifier = determind_modifier(damage_feature[4])
    
    value    = roll(time,face) + bonus
    value   += param_modifier(modifier)        unless modifier == 0
    value    = process_element_rate(value, element)
    
    return value.to_i
  end
  
  #--------------------------------------------------------------------------
  #  Determind Modifier
  #--------------------------------------------------------------------------
  def determind_modifier(modifier)
    return 0 if modifier == 0
    return 4 if skill_learned?(9)
    
    return modifier
  end
  #--------------------------------------------------------------------------
  #  Process element rate
  #--------------------------------------------------------------------------
  def process_element_rate(value, element_id)
    value * element_rate(element_id)
  end
  # ---------------------------------------------------------------------------
  # *) Apply element rate
  # ---------------------------------------------------------------------------
  def apply_element_rate(user, item, value)
    value *= item_element_rate(user, item)
    value
  end
  # ---------------------------------------------------------------------------
  # *) Apply damage rate. Such as physical, magical, recovery
  # ---------------------------------------------------------------------------
  def process_damage_rate(user, item, value)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value
  end
  # ---------------------------------------------------------------------------
  # *) Apply damage modifier. Such as guard, critical, variance
  # ---------------------------------------------------------------------------
  def apply_damage_modifiers(user, item, value)
    value = apply_critical(value, user,item) if @result.critical && item.physical?
    value
  end
  # ---------------------------------------------------------------------------
  # *) Applying critical
  # ---------------------------------------------------------------------------
  def apply_critical(damage, user,item)
    multiplier     = 1.5
    ori_multiplier = 1.5
    
    
    #----------------------------
    return damage * multiplier
  end
  
  # ---------------------------------------------------------------------------
  # *) Apply other effect
  # ---------------------------------------------------------------------------
  def apply_other_effect(user, item, value)
    
    multiplier = 1
    
    #---------------------------------------------------------------------------
    #  *)
    #---------------------------------------------------------------------------
    
    return value * multiplier
  end
  
  # ---------------------------------------------------------------------------
  # *) Apply after effect
  # ---------------------------------------------------------------------------
  def apply_after_effect(user, item, value)
    #---------------------------------------------------------------------------
    #  *)
    #---------------------------------------------------------------------------
  
    
  end
  
    
  #--------------------------------------------------------------------------
  # * new method: attackDC
  #--------------------------------------------------------------------------
  def attackDC(item, bonus = 0, user = self)
    return 99 unless item.is_a?(RPG::Weapon) || item.is_a?(RPG::Skill)
    return 99 if item.damage_index.nil?
    return 99 if item.damage_index[0].nil?
    
    type = item.damage_index[0][4]
    type = get_param_id(type) if type.is_a?(String)
    value = bonus + self.attack_bonus
    
    if actor?
      param_id = get_param_id(DND::CLASS_ACTIONDC[self.class_id][0])
      value += param_modifier(param_id)
    else
      value += param_modifier(type)
    end
    
    if item.is_a?(RPG::Weapon)
      value += (proficiency * Math.sqrt(self.wprof[item.wtype_id])).to_i
    elsif item.is_a?(RPG::Skill)
      value += (proficiency + @level)
    end
    
    
    #str = 'dc'
    #value = process_states_effect(value, type, str, item)
    #value = process_equip_effect(value, type, str, item)
    #value = process_item_effect(value, type, str, item)
    
    return value
  end
  #--------------------------------------------------------------------------
  # * new method: saving_throw
  #--------------------------------------------------------------------------
  def saving_throw(type, bonus = 0, user = nil, item = nil)
    type = get_param_id(type) if type.is_a?(String)
    
    value = roll(1,20)
    return true  if value == 20
    return false if value == 1
    
    str = 'save'
    value += param_modifier(type)
    value  = process_states_effect(value, type, str, item)
    value  = process_equip_effect(value, type, str, item)
    value  = process_item_effect(value, type, str, item)
    
    return (value + bonus) > dc
  end
  #--------------------------------------------------------------------------
  # * new method: skillDC
  #--------------------------------------------------------------------------
  def skillDC(type, bonus = 0, item)
    type = get_param_id(type) if type.is_a?(String)
    value = 10 + bonus + proficiency + @level
    
    if actor?
      param_id = get_param_id(DND::CLASS_ACTIONDC[self.class_id][1])
      value += param_modifier(param_id)
    else
      value += param_modifier(type)
    end
    
    value = process_states_effect(value, type, "dc", item)
    value = process_equip_effect(value, type, "dc", item)
    value = process_item_effect(value, type, "dc", item)
    
    return value
  end
  
end
#=============================================================================
# ** Core Damage Result ~
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#=============================================================================
class Game_Battler < Game_BattlerBase
  
  # ---------------------------------------------------------------------------
  # *) Apply item
  # ---------------------------------------------------------------------------
  def item_apply(user, item, source_item)
    
    make_base_result(user, item, source_item)
    apply_hit(user, item, source_item) if @result.hit?
  end
  #--------------------------------------------------------------------------
  # * Apply Normal Attack Effects
  #--------------------------------------------------------------------------
  def attack_apply(attacker, item)
    item_apply(attacker, $data_skills[attacker.attack_skill_id], item)
  end
  # ---------------------------------------------------------------------------
  # *) Make base result
  # ---------------------------------------------------------------------------
  def make_base_result(user, item, source_item)
    
    @result.clear
    @result.used = item_test(user, item)
    
    item = source_item if source_item.is_a?(RPG::Weapon) && item.is_a?(RPG::Skill) && item.id == 1    
    
    value = roll(1,20)
    if value == 20
      if item.is_a?(RPG::Skill)
        @result.critical = true if item.stype_id == 1
      else
        @result_critical = true
      end # if item.is_a?(RPG::Skill)
    elsif value == 1
      @result.missed = true
    end # if value == 20
    a = user.attackDC(item,value)
    b = self.armor_class
    @result.hited = (a >= b) || @result_critical
  end
  
  # ---------------------------------------------------------------------------
  # *) Determind interrupted
  # ---------------------------------------------------------------------------
  def determind_interrupted(user,item)
    return true if user.state?(PONY::COMBAT_STOP_FLAG)
    result = false
    
    return result
  end
  # ---------------------------------------------------------------------------
  # *) Apply hit
  # ---------------------------------------------------------------------------
  def apply_hit(user, item, source_item)
    
    unless item.damage.none?
      if source_item.is_a?(RPG::Weapon) && item.is_a?(RPG::Skill) && item.id == 1
        item,source_item = source_item,item
      end
      make_damage_value(user, item, source_item)
      execute_damage(user)
    end
    apply_item_effects(user, source_item)
  end
  # ---------------------------------------------------------------------------
  # *) Apply item effects
  # ---------------------------------------------------------------------------
  def apply_item_effects(user, item)
    return if item.nil?
    for effect in item.effects
      return if self.state?(272)
      
      if effect.code == 21
        
        if self.anti_magic? && $current_damage_type == 2 && $data_states[effect.data_id].is_magic?
          next
        end
        
      end
      
      item_effect_apply(user, item, effect)
    end
    
    item_user_effect(user, item)
  end
  
end # class Game_Battler
