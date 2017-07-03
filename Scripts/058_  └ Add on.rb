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
  attr_accessor :time                       # Cast time required
  attr_accessor :interruptible              # Can be interrupted?
  attr_accessor :user                       # Battler who used, may be inverted
  attr_accessor :target                     # Target destiniation
  attr_accessor :subject                    # Battlers affected
  attr_reader   :casting                    # Casting flag
  attr_reader   :item                       # Item index
  attr_reader	  :acting                     # Performing flag
  attr_reader	  :done                       # Executed flag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(user, target, item, forcing = false)
  	@user	   = user
    @target  = target
    @subject = []
    @forcing = forcing
    @item 	 = item
    @time    = user.item_casting_time(item)
    @interruptible = true
    @casting       = true
    @acting		     = false
    @done		       = false
  end
  #---------------------------------------------------------------------------
  #  *) Return interrupt flag, if false, action will be executed anyway
  #---------------------------------------------------------------------------
  def interruptible?
  	return @interruptible
  end
  #---------------------------------------------------------------------------
  #  *) Return if action is undergoing
  #---------------------------------------------------------------------------
  def acting?
  	return @acting
  end
  #---------------------------------------------------------------------------
  #  *) Return action can be executed effectivly
  #---------------------------------------------------------------------------
  def action_impleable?
  	return false if @user.distance_to(@subject.x, @subject.y) > item.tool_range
  	return false if !path_clear?(@user.x, @user.y, @subject.x, @subject.y)
  	return true
  end
  #---------------------------------------------------------------------------
  #  *) casting process
  # tag: cast
  #---------------------------------------------------------------------------
  def do_casting
  	return if cast_done?
  	@time -= user.csr if @time > 0
    if @time <= 0
      @casting = false
      @time = 0
    end
  end
  #---------------------------------------------------------------------------
  def cast_done?
    return !@casting
  end
  
end
