#==============================================================================
# ** Game_Action
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================
# tag: action
class Game_Action
  #--------------------------------------------------------------------------
  Symbol_Name = {
      :main_hoof      => "Use main-hoof attack",
      :off_hoof       => "Use off-hoof attack",
      :add_command    => "Add a new tactic logic",
      
  }
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
  attr_accessor :effect_delay               # Exexute damage delay
  attr_accessor :item_symbol
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(user, target, item, forcing = false)
  	@user	   = user
    @target  = target
    @subject = []
    @forcing = forcing
    @item 	 = item
    @time    = user.item_casting_time(item) if @item.is_a?(RPG::BaseItem)
    @time_needed = @time
    @effect_delay  = item.tool_effectdelay rescue 0
    @interruptible = true
    @casting       = true
    @acting		     = false
    @done		       = false
    @casted        = false
    @item_symbol   = nil
    get_symbol_item if item.is_a?(Symbol)
  end
  #---------------------------------------------------------------------------
  #  *) Start action
  #---------------------------------------------------------------------------
  def start
    if @time > 10
      anim_id = user.map_char.casting_animation
      anim_id += 1 if anim_id == DND::BattlerSetting::CastingAnimation && @time > 120
      user.map_char.start_animation(anim_id) rescue nil
    end
  end
  #--------------------------------------------------------------------------
  def initial_casting?
    return false if cast_done?
    return @time < @time_needed - 10
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
  # * Update 
  #---------------------------------------------------------------------------
  def do_acting
    @time -= 1 if !@waiting && @time > 0
    terminate  if !@waiting && @time <= 0
  end
  #---------------------------------------------------------------------------
  # * Frame update
  #---------------------------------------------------------------------------
  def update
    do_acting  if @acting
    do_casting unless cast_done?
  end
  #---------------------------------------------------------------------------
  # * Set execution flas
  #---------------------------------------------------------------------------
  def execute
    @casting = false
    @casted  = true
    @acting  = true
    @time    = get_item_acting_time
  end
  #---------------------------------------------------------------------------
  def get_item_acting_time
    return @user.action_stiff
  end
  #---------------------------------------------------------------------------
  def terminate
    @acting = false
    @done   = true
  end
  #---------------------------------------------------------------------------
  def cast_done?
    return !@casting
  end
  #---------------------------------------------------------------------------
  def casted?
    return @casted
  end
  #---------------------------------------------------------------------------
  def done?
    return @done
  end
  #---------------------------------------------------------------------------
  def wait
    @waiting = true
  end
  #---------------------------------------------------------------------------
  def resume
    @waiting = false
  end
  #---------------------------------------------------------------------------
  def item=(subitem)
    return if done?
    @item = subitem
    execute
  end
  #---------------------------------------------------------------------------
  def direct_change_item(item)
    @item = item
  end
  #---------------------------------------------------------------------------
  def interrupt
    @done = true
    wait
  end
  #---------------------------------------------------------------------------
  def get_item_name
    return @item.name if @item_symbol.nil? && @item
    name = Symbol_Name[@item_symbol]
    return name.nil? ? "<none>" : name
  end
  #---------------------------------------------------------------------------
  def get_symbol_item
    @item_symbol = @item
    case @item
    when :main_hoof
      @item = @user.primary_tool
    when :off_hoof
      @item = @user.secondary_tool
    end
  end
  #---------------------------------------------------------------------------
end
