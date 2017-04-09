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
  attr_accessor :movment_formula
  attr_accessor :action
  attr_accessor :target
  attr_accessor :hitted_by
  attr_accessor :projectiles
  attr_accessor :current_target
  attr_reader   :hashid
  #----------------------------------------------------------------------------
  # *) Initialize Object
  #----------------------------------------------------------------------------
  alias initialize_charbaseopt initialize
  def initialize
    initialize_charbaseopt
    @weight   = 10
    @velocity = 10
    @opacity  = 255
    @movment_formula = nil
    @action          = nil
    @target          = nil
    @current_target  = nil
    @hitted_by       = {}
    @projectiles     = []
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
    #update_pathfinding_movement
    update_sprites
    update_ai
    update_action if @action
  end
  def update_sprites
    update_primstate_sprites
  end
  def update_primstate_sprites
  end
  def update_cooldown
  end
  def update_ai
  end
  # Can perform action?
  def actable?
    return false if $game_message.busy?
    return false if !movable
    return false if @current_action.interruptible?
    return false if battler.nil?
    return false if battler.dead?
    return true
  end
  
  def battler
    return self.is_a?(Game_Battler) ? self : nil
  end
  
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
  # item usable test
  def usable_test_passed?(item)
    @hint_cooldown -= 1 if @hint_cooldown > 0
    msg = battler.usable?(item)
    if msg == true
      return true
    elsif @hint_cooldown == 0 && msg == :outofammo
      text = sprintf("%s - run out of ammo", battler.name)
      SceneManager.display_info(text)
      @hint_cooldown = 3
    end
    return false
  end
  def use_tool(item, target = nil)
    target = BattleManager.autotarget(self, item) if target.nil?
    @action = Game_Action.new(self, target, item)
  end
  
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
  # * Execute action
  #----------------------------------------------------------------------------
  def popup_info(text, color = GTBS::White.color)
    $game_map.setup_popinfo(text, POS.new(screen_x, screen_y), color)
  end
  
  # Hash position address to one
  def hash_pos
    return (@x * 10000 + @y)
  end
end
