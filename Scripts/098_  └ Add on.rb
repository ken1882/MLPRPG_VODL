#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :enemy
  attr_reader   :event
  attr_reader   :terminated
  attr_reader   :sight_timer
  attr_reader   :sight_lost_timer
  attr_reader   :stuck_timer
  attr_accessor :static_object
  #--------------------------------------------------------------------------
  attr_accessor :default_weapon
  attr_accessor :last_target
  attr_accessor :cool_down
  attr_accessor :recover
  attr_accessor :target_switch
  attr_accessor :self_vars
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     event:  RPG::Event
  #--------------------------------------------------------------------------
  alias initialize_event_opt initialize
  def initialize(map_id, event)
    @self_vars        = Array.new(4){|i| i = 0}
    @terminated       = false
    @static_object    = false
    @sight_timer      = rand(20)
    @sight_lost_timer = 0
    @stuck_timer      = 0
    initialize_event_opt(map_id, event)
    hash_self
  end
  #--------------------------------------------------------------------------
  # * overwrite method: setup_page_settings
  #--------------------------------------------------------------------------
  def setup_page_settings
    @tile_id          = @page.graphic.tile_id
    @character_name   = @page.graphic.character_name
    @character_index  = @page.graphic.character_index
    
    if @original_direction != @page.graphic.direction
      @direction          = @page.graphic.direction
      @original_direction = @direction
      @prelock_direction  = 0
    end
    
    if @original_pattern != @page.graphic.pattern
      @pattern            = @page.graphic.pattern
      @original_pattern   = @pattern
    end
    
    @move_type          = @page.move_type
    @move_speed         = @page.move_speed
    @move_frequency     = @page.move_frequency
    
    #tag: modified here
    if !@on_path_finding || @on_path_finding.nil?
      @move_route         = @page.move_route
      @move_route_index   = 0               
      @move_route_forcing = false           
    end
    
    @walk_anime         = @page.walk_anime
    @step_anime         = @page.step_anime
    @direction_fix      = @page.direction_fix
    @through            = @page.through
    @priority_type      = @page.priority_type
    @trigger            = @page.trigger
    @list               = @page.list
    @interpreter = @trigger == 4 ? Game_Interpreter.new : nil
  end
  #----------------------------------------------------------------------------
  # * Get comments in event page
  #----------------------------------------------------------------------------
  def get_comments
    return unless @list
    comments = ""
    for command in @list
      next unless command.code == 108
      command.parameters[0].split(/[\r\n]+/).each do |text|
        comments += text
      end
    end
    return comments
  end
  #--------------------------------------------------------
  # *) check if comment is in event page
  #--------------------------------------------------------
  def comment_include?(comment)
    return if comment.nil? || @list.nil?
    comment = comment.to_s
    for command in @list
      if command.code == 108
        return true if command.parameters[0].include?(comment)
      end # if command.code
    end # for command
    return false
  end # def comment
  #-------------------------------------------------------------------------------
  # * Alias: setup page
  #-------------------------------------------------------------------------------
  alias setup_page_dnd setup_page
  def setup_page(new_page)
    setup_page_dnd(new_page)
    setup_enemy(new_page.nil?)
  end
  #-------------------------------------------------------------------------------
  # * Setup enemy
  #-------------------------------------------------------------------------------
  def setup_enemy(invalid)
    if @enemy && !terminated?
      BattleManager.resign_battle_unit(self)
      @enemy = nil
    end
    unless invalid && @list.nil?
      load_npc_attributes
    end
  end
  #-------------------------------------------------------------------------------
  # * Load comment command configs in page
  #-------------------------------------------------------------------------------
  def load_npc_attributes
    comments = get_comments
    npc_config = false
    comments.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Event::Terminated
        terminate
      when DND::REGEX::Event::Frozen
        freeze
      when DND::REGEX::NPCEvent::Enemy
        spawn_npc_battler($1.to_i)
      when DND::REGEX::NPCEvent::ConfigON
        npc_config = true
      when DND::REGEX::NPCEvent::ConfigOFF
        npc_config = false
      when DND::REGEX::NPCEvent::StaticObject
        @static_object = true
      end
      process_npc_event_config(line) if npc_config
    end # each comment line
  end
  #-------------------------------------------------------------------------------
  # * Load params of REGEX::Character in event comment command
  #-------------------------------------------------------------------------------
  def process_npc_event_config(line)
    case line
    when DND::REGEX::Character::DefaultWeapon
      @default_weapon = $data_weapons[$1.to_i]
    when DND::REGEX::Character::TeamID
      @team_id = $1.to_i
    when DND::REGEX::Character::DeathSwitchSelf
      @death_switch_self = $1.upcase
    when DND::REGEX::Character::DeathSwitchGlobal
      @death_switch_global = $1.to_i
    when DND::REGEX::Character::DeathVarSelf
      @death_var_self = [$1.to_i, $2.to_i]
    when DND::REGEX::Character::DeathVarGlobal
      @death_var_global = [$1.to_i, $2.to_i]
    when DND::REGEX::Character::VisibleSight
      @visible_sight = $1.to_i
    when DND::REGEX::Character::BlindSight
      @blind_sight   = $1.to_i
    when DND::REGEX::Character::Infravision
      @infravision   = $1.to_i.to_bool
    when DND::REGEX::Character::AggressiveLevel
      @aggressive_level = $1.to_i
    when DND::REGEX::Character::MoveLimit
      @move_limit      = $1.to_i
    when DND::REGEX::Character::DeathAnimation
      @death_animation = $1.to_i
    end
  end
  #-------------------------------------------------------------------------------
  # * Spawn NPC battler
  #-------------------------------------------------------------------------------
  def spawn_npc_battler(id)
    @enemy = Game_Enemy.new($game_map.enemies.size, id)
    @enemy.map_char = self
    debug_print "Spawn enemy #{@enemy.name} at event #{@id}"
    BattleManager.register_battler(self)
    $game_map.make_unique_names
  end
  #----------------------------------------------------------------------------
  # * Permanently delete the event
  #----------------------------------------------------------------------------
  def terminate
    @terminated = true
    $game_map.terminate_event(self)
  end
  #----------------------------------------------------------------------------
  def terminated?
    @terminated
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Update During Autonomous Movement
  #--------------------------------------------------------------------------
  def update_self_movement
    if !@pathfinding_moves.empty?
      process_pathfinding_movement
    elsif near_the_screen? && @stop_count > stop_count_threshold
      case @move_type
      when 1;  move_type_random
      when 2;  move_type_toward_player
      when 3;  move_type_custom
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Freeze event from update
  #----------------------------------------------------------------------------
  alias ruby_freeze freeze
  def freeze
    @frozen = true
  end
  #----------------------------------------------------------------------------
  def unfreeze
    @frozen = false
  end
  #----------------------------------------------------------------------------
  alias :ruby_frozen? :frozen?
  def frozen?
    @frozen
  end
  #----------------------------------------------------------------------------
  def dead?
    return true if @enemy.nil?
    return @enemy.dead?
  end
  #----------------------------------------------------------------------------
  def name(original_event = false)
    return @enemy.name if !original_event && @enemy
    return event.name
  end
  #----------------------------------------------------------------------------
  # * Die when hitpoint drop to zero
  #----------------------------------------------------------------------------
  def kill
    process_event_death
    super
  end
  #-------------------------------------------------------------------------------
  # * Params to method
  #-------------------------------------------------------------------------------
  def default_weapon
    return @default_weapon             if @default_weapon
    return @enemy.enemy.default_weapon if @enemy
    returnDND::BattlerSetting::DefaultWeapon
  end
  #--------------------------------------------------------------------------
  # * Determine if Movement is Possible
  #--------------------------------------------------------------------------
  def movable?
    return false if @enemy && !@enemy.movable?
    return super
  end
  #----------------------------------------------------------------------------
  def team_id
    return @team_id       if @team_id
    return @enemy.enemy.team_id if @enemy
    return DND::BattlerSetting::TeamID
  end
  #----------------------------------------------------------------------------
  def death_switch_self
    return @death_switch_self             if @death_switch_self
    return @enemy.enemy.death_switch_self if @enemy
    return DND::BattlerSetting::DeathSwitchSelf
  end
  #----------------------------------------------------------------------------
  def death_switch_global
    return @death_switch_global             if @death_switch_global
    return @enemy.enemy.death_switch_global if @enemy
    return DND::BattlerSetting::DeathSwitchGlobal
  end
  #----------------------------------------------------------------------------
  def death_var_self
    return @death_var_self             if @death_var_self
    return @enemy.enemy.death_var_self if @enemy
    return DND::BattlerSetting::DeathVarSelf
  end
  #----------------------------------------------------------------------------
  def death_var_global
    return @death_var_global             if @death_var_global
    return @enemy.enemy.death_var_global if @enemy
    return DND::BattlerSetting::DeathVarGlobal
  end
  #----------------------------------------------------------------------------
  def visible_sight
    return @visible_sight             if @visible_sight
    return @enemy.enemy.visible_sight if @enemy
    return DND::BattlerSetting::VisibleSight
  end
  #----------------------------------------------------------------------------
  def blind_sight
    return @blind_sight             if @blind_sight
    return @enemy.enemy.blind_sight if @enemy
    return DND::BattlerSetting::BlindSight
  end
  #----------------------------------------------------------------------------
  def infravision
    return @infravision             if @infravision
    return @enemy.enemy.infravision if @enemy
    return DND::BattlerSetting::Infravision
  end
  #----------------------------------------------------------------------------
  def aggressive_level
    return @aggressive_level     if @aggressive_level
    return @enemy.enemy.aggressive_level if @enemy
    return DND::BattlerSetting::AggressiveLevel
  end
  #----------------------------------------------------------------------------
  def move_limit
    return @move_limit       if @move_limit
    return @enemy.move_limit if @enemy
    return DND::BattlerSetting::MoveLimit
  end
  #----------------------------------------------------------------------------
  def body_size
    return @body_size * @zoom_x       if @body_size
    return @enemy.body_size * @zoom_x if @enemy
    return DND::BattlerSetting::BodySize
  end
  #----------------------------------------------------------------------------
  def death_animation
    return @death_animation             if @death_animation
    return @enemy.enemy.death_animation if @enemey
    return DND::BattlerSetting::DeathAnimation
  end
  #--------------------------------------------------------------------------
  def face_name
    return @enemy.face_name if @enemy
    return nil
  end
  #--------------------------------------------------------------------------
  def face_index
    return @enemy.face_index if @enemy
    return 0
  end
  #--------------------------------------------------------------------------
  def weapon_cooldown
    return @enemy.weapon_cooldown if @enemy
    return {}
  end
  #--------------------------------------------------------------------------
  def armor_cooldown
    return @enemy.armor_cooldown if @enemy
    return {}
  end
  #--------------------------------------------------------------------------
  def skill_cooldown
    return @enemy.skill_cooldown if @enemy
    return {}
  end
  #--------------------------------------------------------------------------
  def item_cooldown
    return @enemy.item_cooldown if @enemy
    return {}
  end
  
  #--------------------------------------------------------------------------
  def hash_self
    base  = (@map_id * 1000 + @id)
    base += @enemy.hashid if @enemy
    base  = base.to_s + self.inspect
    @hashid = PONY.Sha256(base).to_i(16)
  end
  #--------------------------------------------------------------------------
  def primary_weapon
    return @enemy.default_weapon if @enemy
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Game_Enemy
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, *args) if @enemy.nil?
    @enemy.method(symbol).call(*args)
  end
  
end
