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
  #--------------------------------------------------------------------------
  attr_reader :effect_value
  #--------------------------------------------------------------------------
  alias init_rpguim_opt initialize
  def initialize
    @effect_value = {}
    init_rpguim_opt
  end
  #--------------------------------------------------------------------------
  def get_effect_sum(code, args = {})
    return @effect_value[code] if @effect_value[code]
    value = [0,0]
    @effects.each do |eff|
      next unless eff.code == code
      next if args[:data_id] && eff.data_id != args[:data_id]
      value.first += eff.value1
      value.last  += eff.value2
    end
    return @effect_value[code] = value
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
    return @effects.any?{|eff| eff.code == EFFECT_RECOVER_HP && (eff.value1 > 0 || effect.value2 > 0) }
  end
  #-----------------------------------------------------------------------
  # *) Check whether will recover ep
  #-----------------------------------------------------------------------
  def mp_recover?
    return true if @damage.recover? && @damage.to_mp?
    return @effects.any?{|eff| eff.code == EFFECT_RECOVER_MP && (eff.value1 > 0 || effect.value2 > 0) }
  end
  alias :ep_recover? :mp_recover?
  #--------------------
end
#=======================================================================
# *) RPG::BaseItem
#-----------------------------------------------------------------------
# Quicker way to check the features
#=======================================================================
class RPG::BaseItem
  #------------------------------------------------------------------------
  attr_reader :feature_value
  #------------------------------------------------------------------------
  alias init_rpgbim_opt initialize
  def initialize
    @feature_value = {}
    init_rpgbim
  end
  #--------------------------------------------------------------------------
  def get_feature_sum(code, args = {})
    value = 0
    @features.each do |feat|
      next unless feat.code == code
      next if args[:data_id] && feat.data_id != args[:data_id]
      value += (feat.value || 0)
    end
    value
  end
  #------------------------------------------------------------------------
  # * Set hashid
  #------------------------------------------------------------------------
  def hash_self
    base = (@id * 42).to_s(8)
    base += @name ? @name : "nothingness"
    base += "Actor"  if self.is_a?(RPG::Actor)
    base += "Class"  if self.is_a?(RPG::Class)
    base += "Enemy"  if self.is_a?(RPG::Enemy)
    base += "Item"   if self.is_a?(RPG::Item)
    base += "Weapon" if self.is_a?(RPG::Weapon)
    base += "Armor"  if self.is_a?(RPG::Armor)
    base += "State"  if self.is_a?(RPG::State)
    @hashid = PONY.Sha256(base).to_i(16)
    super
  end
  #-----------------------------------------------------------------------
  # *) Get Attack Element
  #-----------------------------------------------------------------------
  def get_feat_attack_elemet
    elements = []
    @features.each do |feat|
      elements.push(feat.data_id) if feat.code == 31
    end
    
    return elements
  end
  #-----------------------------------------------------------------------
  # *) Get Element Rate
  #-----------------------------------------------------------------------
  def get_element_rate(id)
    @features.each do |feat|
      if feat.code == 11
        if id.is_a?(String)
          return feat.value if id.upcase == $data_system.elements[feat.data_id].upcase
        else
          return feat.value if id == feat.data_id
        end
      end
    end
    return 1
  end
  #--------------------
end
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_rpgbaseitem load_database; end
  def self.load_database
    load_database_rpgbaseitem
    load_baseitem_extrainfos
  end
  
  #--------------------------------------------------------------------------
  # new method: load_baseitem_extrainfos
  #--------------------------------------------------------------------------
  def self.load_baseitem_extrainfos
    groups = [$data_items, $data_weapons, $data_armors,$data_skills,$data_states, $data_enemies, $data_actors]
    for group in groups do for obj in group
        next if obj.nil?
        obj.hash_self; end
    end
  end
  #------------------------------
end # DataManager
=begin  
class RPG::UsableItem::Damage
  def initialize
    @type = 0
    @element_id = 0
    @formula = '0'
    @variance = 20
    @critical = false
  end
  
  def none?
    @type == 0
  end
  
  def to_hp?
    [1,3,5].include?(@type)
  end
  
  def to_mp?
    [2,4,6].include?(@type)
  end
  
  def recover?
    [3,4].include?(@type)
  end
  
  def drain?
    [5,6].include?(@type)
  end
  
  def sign
    recover? ? -1 : 1
  end
  
  def eval(a, b, v)
    [Kernel.eval(@formula), 0].max * sign rescue 0
  end
  
  attr_accessor :type
  attr_accessor :element_id
  attr_accessor :formula
  attr_accessor :variance
  attr_accessor :critical
end
=end
