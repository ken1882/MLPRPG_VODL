#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :weight, :velocity, :opacity, :x, :y, :move_speed
  attr_accessor :movment_formula  # delta y = f(x)
  attr_accessor :action
  attr_accessor :target
  attr_accessor :current_target
  attr_reader   :hashid
  #----------------------------------------------------------------------------
  # *) Initialize Object
  #----------------------------------------------------------------------------
  alias initialize_charbaseopt initialize
  def initialize
    initialize_charbaseopt
    @weight   = 10
    @velocity = @move_speed
    @opacity  = 0xff
    @movment_formula = nil
    @action          = nil
    @target          = nil
    @hint_cooldown   = 0
    @hashid = PONY.Sha256(@character_name + @id.to_s + self.class.to_s + Time.now.to_s).to_i(16)
  end
  #----------------------------------------------------------------------------
  # * Update
  #----------------------------------------------------------------------------
  alias update_charbase_opt update
  def update
    update_realtime_action
    update_charbase_opt
  end
  #----------------------------------------------------------------------------
  # * Update RTA
  #----------------------------------------------------------------------------
  def update_realtime_action
    update_cooldown
    update_ai
    update_action if @action
  end
  #----------------------------------------------------------------------------
  # * Cool down reduce
  #----------------------------------------------------------------------------
  def update_cooldown
  end
  #----------------------------------------------------------------------------
  # * Update AI process
  #----------------------------------------------------------------------------
  def update_ai
  end
  #----------------------------------------------------------------------------
  # * Can perform action?
  #----------------------------------------------------------------------------
  def actable?
    return false if $game_message.busy?
    return false if !movable
    return true  if !@current_action.interruptible?
    return false if battler.nil?
    return false if battler.dead?
    return true
  end
  #----------------------------------------------------------------------------
  def battler
    return self.is_a?(Game_Battler) ? self : nil
  end
  #----------------------------------------------------------------------------
  # * Item usage process
  #----------------------------------------------------------------------------
  def process_tool_action(item)
    return if item.nil?
    if !usable_test_passed?(item)
      PG::SE.new("Cursor1", 80).play if self.is_a?(Game_Player)
      return false
    end
    targets = BattleManager.target_selection(self, item) if item.for_all?   && !$game_system.autotarget_aoe
    targets = BattleManager.target_selection(self, item) if item.scope == 1 && !$game_system.autotarget
    use_tool(item, targets)
  end
  #----------------------------------------------------------------------------
  # * Return an item can be used effectivly
  #----------------------------------------------------------------------------
  def usable_test_passed?(item)
    @hint_cooldown -= 1 if @hint_cooldown > 0
    msg = battler.usable?(item)
    if msg == true
      return true
    elsif @hint_cooldown == 0 && msg == :outofammo
      text = sprintf("%s - run out of ammo", battler.name)
      SceneManager.display_info(text)
      @hint_cooldown = 10
    end
    return false
  end
  #----------------------------------------------------------------------------
  # * Use item
  #----------------------------------------------------------------------------
  def use_tool(item, target = nil)
    target = BattleManager.autotarget(self, item) if target.nil?
    @action = Game_Action.new(self, target, item)
  end
  #----------------------------------------------------------------------------
  # * Update current action
  #----------------------------------------------------------------------------
  def update_action
    @action.do_casting
    execute_action if @action.cast_done?
  end
  #----------------------------------------------------------------------------
  # * Execute action
  #----------------------------------------------------------------------------
  def execute_action
    Audio.se_play('Audio/Se/' + @action.item.tool_soundeffect, 100, 100)
    proj = Game_Projectile.new(@action)
    $game_map.setup_projectile(proj)
    @action = nil
  end
  #----------------------------------------------------------------------------
  # * Pop-up text
  #----------------------------------------------------------------------------
  def popup_info(text, color = DND::COLOR::White)
    $game_map.setup_popinfo(text, POS.new(screen_x, screen_y), color)
  end
  #----------------------------------------------------------------------------
  # * Determine cast time needed for item
  # tag: casting
  #----------------------------------------------------------------------------
  def item_casting_time(item)
    timer = [item.tool_castime - @ctr, 0].max
    timer
  end
  #----------------------------------------------------------------------------
  # * Hash position address to single integer
  #----------------------------------------------------------------------------
  def hash_pos
    return (@x * 1000 + @y)
  end
end