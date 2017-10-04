#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================
# tag: battler
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :weight, :velocity, :opacity, :x, :y, :move_speed
  attr_accessor :movment_formula  # delta y = f(x)
  attr_accessor :action
  attr_accessor :next_action
  attr_accessor :current_target
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
    @next_action     = nil
    @action          = nil
    @current_target  = nil
    @hint_cooldown   = 0
    @popup_timer     = 0
    @queued_popups   = []
  end
  #----------------------------------------------------------------------------
  # * Update
  #----------------------------------------------------------------------------
  alias update_charbase_opt update
  def update
    update_realtime_action if valid_battler?
    update_popups
    update_charbase_opt
  end
  #----------------------------------------------------------------------------
  # * Update RTA
  #----------------------------------------------------------------------------
  def update_realtime_action
    update_cooldown
    update_action if @action || @next_action
  end
  #----------------------------------------------------------------------------
  # * Cool down reduce
  #----------------------------------------------------------------------------
  def update_cooldown
    battler.stiff -= 1 if battler.stiff > 0
    battler.skill_cooldown.each do |id, cdt|
      battler.skill_cooldown[id] -= 1 if cdt > 0
    end
    battler.item_cooldown.each do |id, cdt|
      battler.item_cooldown[id] -= 1 if cdt > 0
    end
    battler.weapon_cooldown.each do |id, cdt|
      battler.weapon_cooldown[id] -= 1 if cdt > 0
    end
    battler.armor_cooldown.each do |id, cdt|
      battler.armor_cooldown[id] -= 1 if cdt > 0
    end
  end
  #----------------------------------------------------------------------------
  # * Can perform action?
  #----------------------------------------------------------------------------
  def actable?
    return false if $game_message.busy?
    return false if !movable?
    return true
  end
  #----------------------------------------------------------------------------
  def battler
    return @enemy if self.is_a?(Game_Event) && @enemy
    return actor  if (self.is_a?(Game_Player) || self.is_a?(Game_Follower)) && actor
    return self
  end
  #----------------------------------------------------------------------------
  def determine_targets(item)
    if item.is_a?(RPG::Item) && item.for_friend?
      return battler
    elsif item.is_a?(RPG::Weapon)
      return battler
    elsif item.for_all? && (!$game_system.autotarget_aoe || Input.press?(:kALT))
      return BattleManager.target_selection(self, item)
    elsif item.scope == BattleManager::Scope_OneEnemy && 
      (!$game_system.autotarget  || Input.press?(:kALT))
      return BattleManager.target_selection(self, item)
    end
    return BattleManager.autotarget(battler, item)
  end
  #----------------------------------------------------------------------------
  # * Item usage process
  #----------------------------------------------------------------------------
  def process_tool_action(item)    
    return if item.nil?
    return unless actable?
    if !usable_test_passed?(item)
      Audio.se_play("Audio/SE/Cursor1", 80, 100) if self.is_a?(Game_Player)
      return false
    end
    targets = determine_targets(item)
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
    puts "[Debug]: Use item: #{item}, target: #{target}"
    target = BattleManager.autotarget(self, item) if target.nil?
    name = target.name rescue nil
    puts "[Debug]: Item final target: #{target}(#{name}) at #{[target.x,target.y]}"
    @next_action = Game_Action.new(self, target, item)
  end
  #----------------------------------------------------------------------------
  # * Update current action
  #----------------------------------------------------------------------------
  def update_action
    if @next_action && battler.stiff == 0
      @action      = @next_action.dup
      @next_action = nil
    end
    return if @action.nil?
    @action.update
    execute_action     if @action.cast_done? && !@action.casted?
    @action = nil      if @action.done?
  end
  #----------------------------------------------------------------------------
  # * Execute action
  #----------------------------------------------------------------------------
  def execute_action
    @action.execute
    turn_toward_character(@action.target)
    debug_print("#{self.name} execute action: #{@action.item.name}")
    process_skill_action  if @action.item.is_a?(RPG::Skill)
    process_item_action   if @action.item.is_a?(RPG::Item)
    process_weapon_action if @action.item.is_a?(RPG::Weapon)
    process_armor_action  if @action.item.is_a?(RPG::Armor)
    apply_action_stiff
  end
  #----------------------------------------------------------------------------
  def apply_action_stiff
    battler.stiff = action_stiff
  end
  #----------------------------------------------------------------------------
  def process_skill_action(action = @action)
    tool_se = action.item.tool_soundeffect
    volume  = tool_se.last * $game_system.volume(:sfx) * 0.01
    Audio.se_play('Audio/Se/' + tool_se.first, volume, 100) if tool_se.first
    use_item(action.item) if action.item.tool_animmoment == 1 # Projectile
    proj = Game_Projectile.new(action) if action.item.tool_graphic
    SceneManager.setup_projectile(proj) if action.item.tool_graphic
    battler.skill_cooldown[action.item.id] = action.item.tool_cooldown || 0
  end
  #----------------------------------------------------------------------------
  def process_item_action
    BattleManager.execute_action(@action)
    battler.item_cooldown[@action.item.id] = @action.item.tool_cooldown || 0
  end
  #----------------------------------------------------------------------------
  def process_weapon_action
    SceneManager.setup_weapon_use(@action)
    battler.weapon_cooldown[@action.item.id] = @action.item.tool_cooldown || 0
  end
  #----------------------------------------------------------------------------
  def process_armor_action
    battler.armor_cooldown[@action.item.id] = @action.item.tool_cooldown || 0
  end
  #----------------------------------------------------------------------------
  # * Pop-up text
  #----------------------------------------------------------------------------
  def popup_info(text, color = DND::COLOR::White, icon_id = 0)
    color = DND::COLOR::White if color.nil?
    @queued_popups << [text, color, icon_id]
  end
  #----------------------------------------------------------------------------
  def update_popups
    @popup_timer -= 1 if @popup_timer > 0
    execute_popup if !@queued_popups.empty? && @popup_timer == 0
  end
  #----------------------------------------------------------------------------
  def execute_popup
    @popup_timer = 15
    info = @queued_popups.shift
    text = info[0]; color = info[1]; icon_id = info[2];
    SceneManager.setup_popinfo(text, POS.new(screen_x, screen_y), color, icon_id)
  end
  #----------------------------------------------------------------------------
  # * A short time that cannot do next action continually
  #----------------------------------------------------------------------------
  def action_stiff
    return 20
  end
  #----------------------------------------------------------------------------
  # * Determine cast time needed for item
  # tag: casting
  #----------------------------------------------------------------------------
  def item_casting_time(item)
    timer = [item.tool_castime - ctr, 0].max
    timer
  end
  #----------------------------------------------------------------------------
  def valid_battler?
    return true if self.is_a?(Game_Event) && @enemy
    return true if (self.is_a?(Game_Follower) || self.is_a?(Game_Player)) && actor
    return false
  end
  #----------------------------------------------------------------------------
  # * Hash position address to single integer
  #----------------------------------------------------------------------------
  def hash_pos
    return (@x * 1000 + @y)
  end
  #----------------------------------------------------------------------------
  def action; @action end
end
