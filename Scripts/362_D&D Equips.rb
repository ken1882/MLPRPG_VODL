#==============================================================================
# ** Window_EquipStatus
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen.
#==============================================================================
class Window_EquipStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Set Temporary Actor After Equipment Change
  #--------------------------------------------------------------------------
  def set_temp_actor(temp_actor, item = nil)
    return if @temp_actor == temp_actor
    @temp_actor = temp_actor
    @temp_item = item
    refresh
  end
  
  def set_original_item(item)
    @original_item = item
  end
  
end
#==============================================================================
class RPG::Weapon < RPG::EquipItem
  #--------------------------------------------------------------------------
  def initialize
    super
    @wtype_id = 0
    @animation_id = 0
    @features.push(RPG::BaseItem::Feature.new(31, 1, 0))
    @features.push(RPG::BaseItem::Feature.new(22, 0, 0))
  end
  #--------------------------------------------------------------------------
  def performance(actor = nil)
    base = (params[2] + params[4]) * 20
    plus = 0
    for feat in damage_index
      time     = feat[0]
      face     = feat[1]
      bonus    = feat[2]
      element  = feat[3]
      modparam = feat[4]
      plus += (time * face + bonus)
      #plus *= 
    end
    point = base + plus + self.rarity
    return point
  end
  attr_accessor :wtype_id
  attr_accessor :animation_id
end
