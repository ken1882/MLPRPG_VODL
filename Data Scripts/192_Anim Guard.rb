#==========================================================
#
#     Separated from TSBS's super long script
#
#==========================================================


class Game_Battler
  
  def enable_anim_guard?(item,anim_id,guard_state)  
    return false
    return false if item.nil? || anim_id.nil? || guard_state.nil?
    return false if item.for_user?
    return false if anim_id == 0
      cond = !item.for_user? && anim_id > 0 && !item.damage.recover? &&
      !item.ignore_anim_guard? && !item.for_friend?
    return false if !cond
    
    #------------------------------------------------
    #   Spell sheid
    #------------------------------------------------
    if guard_state.id == 266
      return $current_damage_type == 2 && @result.hp_damage == 0
    end
  end
  
end
