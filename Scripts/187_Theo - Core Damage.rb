
#==============================================================================
# ** Core Damage Processing
# -----------------------------------------------------------------------------
# I altered the way how damage calculation to provide more flexibility. Any
# scripts that also overwrite make_damage_value will highly incompatible.
#
# However, I don't have any script implements this module right now. So you
# may disable it
# -----------------------------------------------------------------------------
if $imported[:Theo_CoreDamage]  # Activation flag
#==============================================================================

class Game_Battler < Game_BattlerBase
  # ---------------------------------------------------------------------------
  # *) Overwrite make damage value
  # tag: damage
  # ---------------------------------------------------------------------------
  def make_damage_value(user, item)
    value = base_damage(user, item)
    globalize_damage_type(item)
    
    value = apply_element_rate(user, item, value)
    value = process_damage_rate(user, item, value)
    
    value = apply_other_effect(user,item,value)
    value = apply_damage_modifiers(user, item, value)
    
    @dmg_popup      = true
    user.dmg_popup  = true
    
    @result.make_damage(value.to_i, item)
    apply_after_effect(user,item,value)
  end
  # ---------------------------------------------------------------------------
  # *) Make base damage. Evaling damage formula
  # ---------------------------------------------------------------------------
  def base_damage(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value
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
    value = apply_critical(value, user,item) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    value
  end
  # ---------------------------------------------------------------------------
  # *) Applying critical
  # ---------------------------------------------------------------------------
  def apply_critical(damage, user,item)
    multiplier = 1.5
    ori_mul = 1.5
    #---------------------------------------------------------------------------
    #   Coup de grace
    #---------------------------------------------------------------------------
    if self.skill_learned?(637)
      multiplier = 4 if item.is_normal_attack
    end
    
    #---------------------------------------------------------------------------
    #   Exploit Weakness
    #---------------------------------------------------------------------------
    if user.skill_learned?(648)
      if multiplier == ori_mul
        multiplier *+ 1.03
      else
        multiplier += 0.3
      end
      
    end
    
    #----------------------------
    return damage * multiplier
  end
  
  # ---------------------------------------------------------------------------
  # *) Apply other effect
  # ---------------------------------------------------------------------------
  def apply_other_effect(user, item, value)
    
    multiplier = 1
    
    #---------------------------------------------------------------------------
    #   Lacerate
    #---------------------------------------------------------------------------
    if user.skill_learned?(649) && !self.state?(226) && value > 0 && self.opposite?(user)
      self.bleed if user.difficulty_class('str') > self.saving_throw('str')
    end
    #---------------------------------------------------------------------------
    #   Weak Points
    #---------------------------------------------------------------------------
    multiplier += 0.3 if user.state?(262)
    #---------------------------------------------------------------------------
    #   Powerful Swings
    #---------------------------------------------------------------------------
    if user.state?(249)
      if multiplier == 1
        multiplier += 0.2
      else
        multiplier *= 1.04
      end
    end
    #---------------------------------------------------------------------------
    #   Spell Might
    #---------------------------------------------------------------------------
    if user.state?(268) && item.magical?
      if multiplier == 1
        multiplier = 1.2
        multiplier += user.real_int * 0.01 unless user.real_int.nil?
      else
        multiplier *= 1.04
      end
    end
    #---------------------------
    value *= 0.4 if $enemy_chain_skill == true
    return value * multiplier
  end
  
  # ---------------------------------------------------------------------------
  # *) Apply after effect
  # ---------------------------------------------------------------------------
  def apply_after_effect(user, item, value)
    #---------------------------------------------------------------------------
    #   Feast of Fallen
    #---------------------------------------------------------------------------
    if user.skill_learned?(650) && value > 0
      user.hp += [value * 0.005 ,1].max.to_i
      user.mp += [value * 0.002 ,1].max.to_i
    end
    
  end
  
  # ---------------------------------------------------------------------------
  # *) Globalize damage type
  # ---------------------------------------------------------------------------
  def globalize_damage_type(item)

    if item.magical?
      $current_damage_type = 2
    elsif item.physical?
      $current_damage_type = 1
    else
      $current_damage_type = 0
    end
    
  end
  
end
end
#=============================================================================
# ** Core Damage Result ~
#-----------------------------------------------------------------------------
# I altered how action result is being handled. It's used within my sideview
# battle system.
#-----------------------------------------------------------------------------
if $imported[:Theo_CoreResult]  # Activation flag
#=============================================================================
class Game_Battler < Game_BattlerBase
  
  # ---------------------------------------------------------------------------
  # *) Apply item
  # ---------------------------------------------------------------------------
  def item_apply(user, item)
    make_base_result(user, item)
    apply_hit(user, item) if @result.hit?
  end
  # ---------------------------------------------------------------------------
  # *) Make base result
  # ---------------------------------------------------------------------------
  def make_base_result(user, item)
    @result.clear
    @result.used = item_test(user, item)
    @result.missed = determind_missed(user,item)
    @result.evaded = determind_evaded(user,item)
  end
  # ---------------------------------------------------------------------------
  # *) Determind missed
  # ---------------------------------------------------------------------------
  def determind_missed(user,item)
    return false unless @result.used
    return true if @base_attack_roll == 1
    
    rand >= item_hit(user, item)
  end
  # ---------------------------------------------------------------------------
  # *) Determind evaded
  # ---------------------------------------------------------------------------
  def determind_evaded(user,item)
    return false if @result.missed
    return false unless opposite?(user)
    
    dex_bonus = self.difficulty_class('dex',-10,false) * 0.01
    rand < ( item_eva(user, item) + dex_bonus)
  end
  # ---------------------------------------------------------------------------
  # *) Apply hit
  # ---------------------------------------------------------------------------
  def apply_hit(user, item)  
    unless item.damage.none?
      determine_critical(user, item)
      make_damage_value(user, item)
      execute_damage(user)
    end
    apply_item_effects(user, item)
  end
  # ---------------------------------------------------------------------------
  # *) Determind if critical hit
  # ---------------------------------------------------------------------------
  def determine_critical(user, item)
    return true if @base_attack_roll == 20
    @result.critical = (rand < item_cri(user, item))
  end
  # ---------------------------------------------------------------------------
  # *) Apply item effects
  # ---------------------------------------------------------------------------
  def apply_item_effects(user, item)
    
    for effect in item.effects
      return if @result.blocked
      return if self.state?(272)
      
      if effect.code == 21
        
        if self.anti_magic? && $current_damage_type == 2 && 
          $debuff_state_id_list.include?(effect.data_id)
          next
        end
        
      end
      
      item_effect_apply(user, item, effect)
    end
    
    item_user_effect(user, item)
  end
  
end # class Game_Battler
end # if $imported[:Theo_CoreResult] 