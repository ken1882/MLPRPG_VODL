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
  end
  #--------------------------------------------------------------------------
  # * Change HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    delta = hp - @hp
    popup_hp_change(delta) if delta != 0
    @hp  = hp
    refresh
  end
  #--------------------------------------------------------------------------
  # * Change MP
  #--------------------------------------------------------------------------
  def mp=(mp)
    delta = mp - @mp
    popup_ep_change(delta) if delta > 30
    @mp  = mp
    refresh
  end
  #--------------------------------------------------------------------------   
  # ● Easier method for check skilll learned
  #--------------------------------------------------------------------------   
  def skill_learned?(id)
    return self.skills.include?($data_skills[id])
  end
  #--------------------------------------------------------------------------
  # ● Posioned?
  #--------------------------------------------------------------------------   
  def poisoned?
    
    for state in self.states
      return true if state.is_poison?
    end
    
    return false
  end
  #--------------------------------------------------------------------------
  # ● Debuffed?
  #--------------------------------------------------------------------------   
  def debuffed?
    for state in self.states
      return true if state.is_debuff?
    end
    
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Dispel Magic
  #--------------------------------------------------------------------------   
  def dispel_magic
    animated = false
    for state in self.states
      next if state.nil?
      animated = true if state.id == 271
      
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
end
