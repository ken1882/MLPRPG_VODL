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
  def make_damage_value(user, item)
    damages = roll_base_damages(user, item)
    cnt = 0
    final_value = 0
    (0...damages.size).each do |i|
      value   = damages[i]
      value   = apply_equipment_bonus(user, item, value)  if cnt == 0
      value   = apply_other_effect(user,item,value)       if cnt == 0
      value   = apply_damage_modifiers(user, item, value) if cnt == 0
      cnt += 1
      final_value += value
    end
    value = final_value
    if value == 0 && is_opponent?(user)
      #text = sprintf("%s - Weapon Ineffective",self.name)
      text = sprintf("%s - %s immune to my damage", user.name, self.name)
      SceneManager.display_info(text)
    end
    @result.hited = true if value < 0
    @result.critical = @result.missed = false if value < 0
    @result.make_damage(value.to_i, item.is_a?(RPG::Weapon) ? $data_skills[1] : item)
    apply_after_effect(user, item, value)
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
    value   += user.param_modifier(modifier)        unless modifier == 0
    
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
  # ---------------------------------------------------------------------------
  # *) Apply equipment effect
  # ---------------------------------------------------------------------------
  def apply_equipment_bonus(user, item, value)
    
    if self.is_a?(Game_Actor)
      for equip in @equips
        next if equip.nil?
        value += equip.physical_damage_modify if item.physical?
        value += equip.magical_damage_modify  if item.magical?
      end
    end
    
    return value
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
      value += user.param_modifier(param_id)
    else
      value += user.param_modifier(type)
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
    #value  = process_states_effect(value, type, str, item)
    #value  = process_equip_effect(value, type, str, item)
    #value  = process_item_effect(value, type, str, item)
    
    return (value + bonus) > dc
  end
  #--------------------------------------------------------------------------
  # * new method: skillDC
  #--------------------------------------------------------------------------
  def skillDC(item, bonus = 0, user = self)
    #type = get_param_id(type) if type.is_a?(String)
    value = 10 + bonus + proficiency + @level
    
    if actor?
      param_id = get_param_id(DND::CLASS_ACTIONDC[self.class_id][1])
      value += param_modifier(param_id)
    else
      value += param_modifier(item.damage.element_id)
    end
    
    #value = process_states_effect(value, "dc", item)
    #value = process_equip_effect(value, "dc", item)
    #value = process_item_effect(value, "dc", item)
    
    return value
  end
  
end
#=============================================================================
# ** Core Damage Result ~
#-----------------------------------------------------------------------------
# These stuffs handle the damage result of attacks
#-----------------------------------------------------------------------------
#=============================================================================
class Game_Battler < Game_BattlerBase
  # ---------------------------------------------------------------------------
  # *) Apply item
  # ---------------------------------------------------------------------------
  def item_apply(user, item)
    make_base_result(user, item)
    if @result.hit?
      apply_hit(user, item)
    else
      results = @result.result?
      info = "Blocked"
      if results[:evaded]
        info = "Evaded"
      elsif results[:missed]
        info = "Missed"
        SceneManager.display_info("#{user.name} - critical miss")
      elsif results[:critical]
        SceneManager.display_info("#{user.name} - critical attack")
      end
      popup_info(info, DND::COLOR::White)
    end
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
  def make_base_result(user, item)
    
    @result.clear
    @result.used = item_test(user, item)
    
    value = roll(1,20)
    if value == 20
      if item.is_a?(RPG::Skill)
        @result.critical = true if item.stype_id == 1
      else
        @result.critical = true
      end # if item.is_a?(RPG::Skill)
    elsif value == 1
      @result.missed = true
    end # if value == 20
    a = item.is_a?(RPG::Weapon) ? user.attackDC(item, value) : user.skillDC(item)
    b = self.armor_class
    
    @result.hitted = (a >= b) || @result_critical
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
  def apply_hit(user, item)
    puts "Apply hit"
    unless item.is_a?(RPG::Skill) && item.damage.none?
      make_damage_value(user, item)
      execute_damage(user)
    end
    start_item_animation(item)
    item.effects.each {|effect| item_effect_apply(user, item, effect) }
  end
  #----------------------------------------------------------------------------
  # *) Apply item animation
  #----------------------------------------------------------------------------
  def start_item_animation(item)
    if item.animation_id
      puts "Start actoin animation"
      start_animation(item.animation_id)
    end
  end
  
end # class Game_Battler
