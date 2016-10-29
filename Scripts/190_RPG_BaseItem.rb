#=======================================================================
# *) RPG::UsableItem
#-----------------------------------------------------------------------
# Quicker way to check the effects
#=======================================================================
class RPG::UsableItem
  #-----------------------------------------------------------------------
  # *) Check if state will be added
  #-----------------------------------------------------------------------
  def add_state?(id = 0)
    
    if id == 0 # check if will add state
      @effects.each do |effect|
        return true if effect.code == 21
      end
    else       # check if assigned state id will be added
      @effects.each do |effect|
        return true if effect.code == 21 && effect.data_id == id
      end
    end
    
    return false
  end
  #-----------------------------------------------------------------------
  # *) Check if state will be removed
  #-----------------------------------------------------------------------
  def remove_state?(id = 0)
    
    if id == 0 # check if will add state
      @effects.each do |effect|
        return true if effect.code == 22
      end
    else       # check if assigned state id will be added
      @effects.each do |effect|
        return true if effect.code == 22 && effect.data_id == id
      end
    end
    
    return false
  end
  
  #--------------------
end
#=======================================================================
# *) RPG::BaseItem
#-----------------------------------------------------------------------
# Quicker way to check the features
#=======================================================================
class RPG::BaseItem
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
  #-----------------------------------------------------------------------
  # *) Get Param
  #-----------------------------------------------------------------------
  def get_param(id)
    if id.is_a?(String)
      for i in 0...$data_system.terms.params.size
        id = i if id.upcase == $data_system.terms.params[i].upcase
        break
      end
    end
    
    @features.each do |feat|
      return value if faet.code == 21 && feat.data_id == id
    end
  end
  
  #--------------------
end
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
