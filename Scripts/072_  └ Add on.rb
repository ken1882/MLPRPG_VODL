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
      :move_away            => 8688,
      :move_close           => 8683,
  }
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :time                       # Cast time required
  attr_accessor :interruptible              # Can be interrupted?
  attr_accessor :user                       # Battler who used, may be inverted
  attr_accessor :target                     # Target destiniation
  attr_accessor :target_pos                 # Target position at first place
  attr_accessor :subject                    # Battlers affected
  attr_reader   :started
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
    @time_needed   = @time
    @target_pos    = target.pos if @target
    @effect_delay  = item.tool_effectdelay rescue 0
    @interruptible = true
    @started       = false
    @casting       = false
    @acting		     = false
    @done		       = false
    @casted        = false
    @symbol_item   = nil
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
    @started = true
    @casting = true
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
    real_item = get_symbol_item
    return true  if real_item.is_a?(Symbol)
  	return false if @user.distance_to(@target.x, @target.y) > item.tool_distance
  	return @user.path_clear?(@user.x, @user.y, @target.x, @target.y) if real_item.melee?
  	return @user.can_see?(@user.x, @user.y, @target.x, @target.y)
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
    if !@started
      puts "imp: #{action_impleable?} #{need_chase?}"
      if @target.nil? || @target.dead?
        @done = true
        puts "Action canceled"
      elsif action_impleable?
        self.start
      elsif need_chase?
        @user.chase_target(self, false)
      end
    end
    puts "Target: #{@target.name}" if target
    if @started
      do_acting  if @acting
      do_casting unless cast_done?
    end
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
    #tag: queue: skill action sequence
    return @user.action_stiff
  end
  #---------------------------------------------------------------------------
  def terminate
    @acting = false
    @done   = true
  end
  #---------------------------------------------------------------------------
  def cast_done?
    return !@casting && @started
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
  def reassign_item(item)
    @symbol_item  = item.is_a?(Symbol) ? item : nil
    @item         = item
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
      return @user.primary_weapon
    when :attack_offhoof
      return @user.secondary_weapon
    when :hp_most_power
      potions = $game_party.items.select{|item| item.hp_recover? && !item.mp_recover?}
      potion  = potions.max_by{|item| item.price}
      return potion
    when :hp_least_power
      potions = $game_party.items.select{|item| item.hp_recover? && !item.mp_recover?}
      potion  = potions.min_by{|item| item.price}
      return potion
    when :ep_most_power
      potions = $game_party.items.select{|item| !item.hp_recover? && item.mp_recover?}
      potion  = potions.max_by{|item| item.price}
      return potion
    when :ep_least_power
      potions = $game_party.items.select{|item| !item.hp_recover? && !item.mp_recover?}
      potion  = potions.min_by{|item| item.price}
      return potion
    else
      return @item
    end
  end
  #--------------------------------------------------------------------------
  # * Determination if Action is Valid or Not
  #--------------------------------------------------------------------------
  def valid?
    return false if @item == :add_command
    return false if @item.is_a?(Symbol) && !Vocab::Tactic::Name_Table.include?(@item)
    return true
  end
  #---------------------------------------------------------------------------
  def need_chase?
    return @need_chase_flag unless @need_chase_flag.nil?
    real_item = get_symbol_item
    return @need_chase_flag = false if real_item.is_a?(Symbol)
    return @need_chase_flag = false if @target == @user
    return @need_chase_flag = false if real_item.is_a?(RPG::UsableItem) && real_item.for_user?
    return @need_chase_flag = true
  end
  #---------------------------------------------------------------------------
end
