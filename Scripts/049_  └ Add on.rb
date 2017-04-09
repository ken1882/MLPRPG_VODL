#==============================================================================
# ** Game_Action
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================
class Game_Action
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :time
  attr_accessor :interruptible
  attr_accessor :user
  attr_accessor :target, :subject
  attr_reader   :casting
  attr_reader   :item
  attr_reader	  :acting
  attr_reader	  :done
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(user, target, item, forcing = false)
  	@user	   = user
    @target  = target
    @subject = []
    @forcing = forcing
    @item 	 = item
    @time    = item.tool_castime
    @interruptible = true
    @casting       = true
    @acting		     = false
    @done		       = false
    @spell_slot    = nil
  end
  def interruptible?
  	return @interruptible
  end
  def acting?
  	return @acting
  end
  def action_impleable?
  	return false if Math.hypot(@user.x + @user.y, @subject.x + @subject.y) > item.tool_range
  	return false if !path_clear?(@user.x, @user.y, @subject.x, @subject.y)
  	return true
  end
  def do_casting
  	return if cast_done?
  	@time -= 1 if @time > 0
    @casting = false if @time == 0
  end
  
  def cast_done?
    return !@casting
  end
  
end
