#-------------------------------------------------------------------------------
# * RGSS3 Object
#-------------------------------------------------------------------------------
class Object
  #----------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------
  def check(string)
    self.each_line { |i| return true if i =~ /#{string}/i }
    return false
  end
  #----------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------
  def get(string,default = nil)    
    self.each_line { |i| return i.gsub("#{string} = ", "").chomp if i =~ /#{string} = /i }
    return default
  end
end
#==========================================================================
# ■ RPG::BaseItem
#==========================================================================
class RPG::BaseItem
  #------------------------------------------------------------------------
  # public instance variables
  #------------------------------------------------------------------------
  attr_accessor :user_graphic
  attr_accessor :user_animespeed
  attr_accessor :tool_cooldown
  attr_accessor :tool_graphic
  attr_accessor :tool_index
  attr_accessor :tool_size
  attr_accessor :tool_distance
  attr_accessor :tool_effectdelay
  attr_accessor :tool_destroydelay
  attr_accessor :tool_speed
  attr_accessor :tool_castime
  attr_accessor :tool_castanimation
  attr_accessor :tool_blowpower
  attr_accessor :tool_piercing
  attr_accessor :tool_animation
  attr_accessor :tool_anirepeat
  attr_accessor :tool_special
  attr_accessor :tool_target
  attr_accessor :tool_invoke
  attr_accessor :tool_guardrate
  attr_accessor :tool_knockdown
  attr_accessor :tool_soundse
  attr_accessor :tool_itemcost
  attr_accessor :tool_itemcosttype
  attr_accessor :tool_shortjump
  attr_accessor :tool_through
  attr_accessor :tool_priority
  attr_accessor :tool_selfdamage
  attr_accessor :tool_hitshake
  attr_accessor :tool_combo
  attr_reader :information
  #------------------------------------------------------------------------
  # alias: load_notetags_dndsubs
  #------------------------------------------------------------------------  
  alias load_notetags_comp load_notetags_dndsubs
  def load_notetags_dndsubs
    load_notetags_comp
    
    PearlKernel.load_item(self)
    @user_graphic       = PearlKernel.user_graphic
    @user_animespeed    = PearlKernel.user_animespeed
    @tool_cooldown      = PearlKernel.tool_cooldown
    @tool_garphic       = PearlKernel.tool_graphic
    @tool_index         = PearlKernel.tool_index
    @tool_size          = PearlKernel.tool_size
    @tool_distance      = PearlKernel.tool_distance
    @tool_effectdelay   = PearlKernel.tool_effectdelay
    @tool_destroydelay  = PearlKernel.tool_destroydelay
    @tool_speed         = PearlKernel.tool_speed
    @tool_castime       = PearlKernel.tool_castime
    @tool_castanimation = PearlKernel.tool_castanimation
    @tool_blowpower     = PearlKernel.tool_blowpower
    @tool_piercing      = PearlKernel.tool_piercing
    @tool_animation     = PearlKernel.tool_animation
    @tool_anirepeat     = PearlKernel.tool_anirepeat
    @tool_special       = PearlKernel.tool_special
    @tool_target        = PearlKernel.tool_target
    @tool_invoke        = PearlKernel.tool_invoke
    @tool_guardrate     = PearlKernel.tool_guardrate
    @tool_knockdown     = PearlKernel.tool_knockdown
    @tool_soundse       = PearlKernel.tool_soundse
    @tool_itemcost      = PearlKernel.tool_itemcost
    @tool_itemcosttype  = PearlKernel.tool_itemcosttype
    @tool_shortjump     = PearlKernel.tool_shortjump
    @tool_through       = PearlKernel.tool_through
    @tool_priority      = PearlKernel.tool_priority
    @tool_selfdamage    = PearlKernel.tool_selfdamage
    @tool_hitshake      = PearlKernel.tool_hitshake
    @tool_combo         = PearlKernel.tool_combo
    
    #puts "#{self.class}"
    @information        = self.note.get("Desc", self.description)
  end
  #------------------------------------------------------------------------
  # *) Item need consume items
  #------------------------------------------------------------------------  
  def item_required?
    @tool_itemcost != 0 || !@tool_itemcosttype.nil?
  end
  #------------------------------------------------------------------------
  # *) Item is an ammo?
  #------------------------------------------------------------------------  
  def is_ammo?
    return false if !self.is_a?(RPG::Weapon)
    _id = self.wtype_id
    return true if _id == 11 || _id == 12 || _id == 13
    return false
  end
  
end # RPG::BaseItem
