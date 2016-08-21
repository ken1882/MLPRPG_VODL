#=============================================================================
# ** Skill interruptions ~
#-----------------------------------------------------------------------------
#=============================================================================
class Game_Battler < Game_BattlerBase
  
  # ---------------------------------------------------------------------------
  # *) Determind interrupted by skills
  # ---------------------------------------------------------------------------
  def check_skill_interruption(user, item)
    
  end
  
  # ---------------------------------------------------------------------------
  # *) Determind interrupted by states
  # ---------------------------------------------------------------------------
  def check_state_interruption(user, item)
    # ---------------------------------------------------------------------------
    # *) Glyph of Repulsion
    # ---------------------------------------------------------------------------
    if state?(287)
      return false if user.nil?
      return false unless opposite?(user)
      scene = SceneManager.scene
      return false unless scene.is_a?(Scene_Battle)
      return false if $current_damage_type != 1
      @state_info[287] = 25 if @state_info[287].nil?
      return false if @state_info[287] < user.saving_throw('str')     
      
      user.damage.push(["Knock_Back","Knock_Back"])
      user.clear_tsbs
      self.multi_animation_id.push(357)
      
      user.add_state(PONY::COMBAT_STOP_FLAG)
      scene.show_action_sequences([user],$data_skills[11],user)
      return true
    # ---------------------------------------------------------------------------
    # *) 
    # ---------------------------------------------------------------------------
    else
      return false
    # ----
    end # if state
  end # def check_state_interruption
  # ----
end


