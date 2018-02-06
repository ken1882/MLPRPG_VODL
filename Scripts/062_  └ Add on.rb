#==============================================================================
# ** Game_Action
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================
# tag: action
class Game_Action
  #--------------------------------------------------------------------------
  Symbol_Name = Vocab::Tactic::Name_Table
  #--------------------------------------------------------------------------
  Symbol_IconID = {
      :attack_mainhoof      => 131,
      :attack_offhoof       => 134,
      :add_command          => PONY::IconID[:plus],
      :target_none          => 1142,
      :hp_most_power        => 2775,
      :hp_least_power       => 2743,
      :ep_most_power        => 2773,
      :ep_least_power       => 2741,
      :set_target           => PONY::IconID[:aim],
      :jump_to              => 2103,
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
    @symbol_item   = nil
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
    #last work: skill action sequence
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
  def reassign_item(item, redect = true)
    @symbol_item  = item.is_a?(Symbol) ? item : nil
    @item         = item
    get_symbol_item if @symbol_item && redect
    @time         = user.item_casting_time(item) if @item.is_a?(RPG::BaseItem)
    @time_needed  = @time
    @effect_delay = item.tool_effectdelay rescue 0
  end
  #---------------------------------------------------------------------------
  def interrupt
    @done = true
    wait
  end
  #---------------------------------------------------------------------------
  def item_valid?
    return @item.is_a?(RPG::BaseItem)
  end
  #---------------------------------------------------------------------------
  def get_item_name
    return @item.name if !@symbol_item && @item.is_a?(RPG::BaseItem)
    name = Symbol_Name[@item]
    return name.nil? ? "<none>" : name
  end
  #---------------------------------------------------------------------------
  def get_icon_id
    return (@item.icon_index || 0) if !@symbol_item && @item.is_a?(RPG::BaseItem)
    id = Symbol_IconID[@item]
    return (id || 0)
  end
  #---------------------------------------------------------------------------
  def get_symbol_item
    case @item
    when :attack_mainhoof
      reassign_item(@user.primary_weapon)
    when :attack_offhoof
      reassign_item(@user.secondary_weapon)
    when :target_none
      @user.map_char.set_target(nil)
    when :hp_most_power
      potions = $game_party.items.select{|item| item.hp_recover? && !item.mp_recover?}
      potion  = potions.max_by{|item| item.price}
      reassign_item(potion)
    when :hp_least_power
      potions = $game_party.items.select{|item| item.hp_recover? && !item.mp_recover?}
      potion  = potions.min_by{|item| item.price}
      reassign_item(potion)
    when :ep_most_power
      potions = $game_party.items.select{|item| !item.hp_recover? && item.mp_recover?}
      potion  = potions.max_by{|item| item.price}
      reassign_item(potion)
    when :ep_least_power
      potions = $game_party.items.select{|item| !item.hp_recover? && !item.mp_recover?}
      potion  = potions.min_by{|item| item.price}
      reassign_item(potion)
    else
      @item
    end
  end
  #---------------------------------------------------------------------------
end
