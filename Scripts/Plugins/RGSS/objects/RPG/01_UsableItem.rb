#=======================================================================
# *) RPG::UsableItem
#-----------------------------------------------------------------------
# Quicker way to check the effects
#=======================================================================
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * Constants (Effects)
  #--------------------------------------------------------------------------
  EFFECT_RECOVER_HP     = 11              # HP Recovery
  EFFECT_RECOVER_MP     = 12              # MP Recovery
  EFFECT_GAIN_TP        = 13              # TP Gain
  EFFECT_ADD_STATE      = 21              # Add State
  EFFECT_REMOVE_STATE   = 22              # Remove State
  EFFECT_ADD_BUFF       = 31              # Add Buff
  EFFECT_ADD_DEBUFF     = 32              # Add Debuff
  EFFECT_REMOVE_BUFF    = 33              # Remove Buff
  EFFECT_REMOVE_DEBUFF  = 34              # Remove Debuff
  EFFECT_SPECIAL        = 41              # Special Effect
  EFFECT_GROW           = 42              # Raise Parameter
  EFFECT_LEARN_SKILL    = 43              # Learn Skill
  EFFECT_COMMON_EVENT   = 44              # Common Events
  #---------------------------------------------------------------------------
  # * Load the attributes of the item form its notes in database
  #---------------------------------------------------------------------------
  def load_notetags_dndattrs
    @effect_value = {}
    super
  end
  #--------------------------------------------------------------------------
  def effect_value(code, data_id)
    key = code * 1000 + data_id
    return @effect_value[key] unless @effect_value[key].nil?
    eff = Struct.new(:value1, :value2).new(0,0)
    @effects.each do |feat|
      next unless feat.code == code && feat.data_id == data_id
      eff.value1 += feat.value1
      eff.value2 += feat.value2
    end
    return @effect_value[key] = eff
  end
  #-----------------------------------------------------------------------
  # *) Check if state will be added
  #-----------------------------------------------------------------------
  def add_state?(id = 0)
    # check if will add state
    return @effects.any? {|eff| eff.code == EFFECT_ADD_STATE } if id == 0
    # check if will add a specific state
    return @effects.any? {|eff| eff.code == EFFECT_ADD_STATE && effect.data_id == id }
  end
  #-----------------------------------------------------------------------
  # *) Check if state will be removed
  #-----------------------------------------------------------------------
  def remove_state?(id = 0)
    # check if will remove state
    return @effects.any? {|eff| eff.code == EFFECT_REMOVE_STATE } if id == 0
    # check if will remove a specific state
    return @effects.any? {|eff| eff.code == EFFECT_REMOVE_STATE && effect.data_id == id }
  end
  #-----------------------------------------------------------------------
  # *) Check whether will recover hp
  #-----------------------------------------------------------------------
  def hp_recover?
    return true if @damage.recover? && @damage.to_hp?
    return @effects.any?{|eff| eff.code == EFFECT_RECOVER_HP && (eff.value1 > 0 || eff.value2 > 0) }
  end
  #-----------------------------------------------------------------------
  # *) Check whether will recover ep
  #-----------------------------------------------------------------------
  def mp_recover?
    return true if @damage.recover? && @damage.to_mp?
    return @effects.any?{|eff| eff.code == EFFECT_RECOVER_MP && (eff.value1 > 0 || eff.value2 > 0) }
  end
  alias :ep_recover? :mp_recover?
  #--------------------
end