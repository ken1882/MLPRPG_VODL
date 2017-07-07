#==============================================================================
# ■ Window_SkillList
#==============================================================================
class Window_SkillList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # Overwrite: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    return if skill.nil?
    rect = item_rect(index)
    rect.width -= 4
    draw_item_name(skill, rect.x, rect.y, true, rect.width - 24)
    draw_skill_cost(rect, skill)
  end
  
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    true
  end
  
end # Window_SkillList
