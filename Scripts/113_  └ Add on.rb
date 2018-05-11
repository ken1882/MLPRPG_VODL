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
  attr_accessor :aggressive_level
  attr_accessor :condition_flag
  attr_accessor :terminate_cd
  attr_accessor :priority_type
  #--------------------------------------------------------------------------
  # * Overwrite: Object Initialization
  #     event:  RPG::Event
  #--------------------------------------------------------------------------
  def initialize(map_id, event)
    super()
    @map_id = map_id
    @event = event
    @id = @event.id
    @terminate_cd = 0
    moveto(@event.x, @event.y)
    collect_code_conditions
    refresh
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_event_opt initialize
  def initialize(map_id, event)
    @self_vars        = Array.new(4){|i| i = 0}
    @terminated       = false
    @static_object    = false
    @sight_timer      = 5 + rand(20)
    @sight_lost_timer = 0
    @stuck_timer      = 0
    @code_conditions  = []
    initialize_event_opt(map_id, event)
    hash_self
  end
  #--------------------------------------------------------------------------
  # * Initialize.                                                       [REP]
  #--------------------------------------------------------------------------
  alias init_effectus initialize
  def initialize(map_id, event)
    init_effectus(map_id, event)
    triggers    = $game_map.effectus_etriggers
    tile_events = $game_map.effectus_tile_events
    @event.pages.each do |page|
      condition = page.condition
      if condition.switch1_valid
        trigger_symbol = :"switch_#{condition.switch1_id}"
        unless triggers[trigger_symbol].include?(self)
          triggers[trigger_symbol]  << self 
        end
      end
      if condition.switch2_valid
        trigger_symbol = :"switch_#{condition.switch2_id}"
        unless triggers[trigger_symbol].include?(self)
          triggers[trigger_symbol]  << self 
        end
      end
      if condition.variable_valid
        trigger_symbol = :"variable_#{condition.variable_id}"
        unless triggers[trigger_symbol].include?(self)
          triggers[trigger_symbol]  << self 
        end
      end
      if condition.self_switch_valid
        key = [@map_id, @event.id, condition.self_switch_ch]
        unless triggers[key].include?(self)
          triggers[key] << self
        end
      end
      if condition.item_valid
        trigger_symbol = :"item_id_#{condition.item_id}"
        unless triggers[trigger_symbol].include?(self)
          triggers[trigger_symbol]  << self 
        end
      end
      if condition.actor_valid
        trigger_symbol = :"actor_id_#{condition.actor_id}"
        unless triggers[trigger_symbol].include?(self)
          triggers[trigger_symbol]  << self 
        end
      end
      if page.graphic.tile_id > 0 && page.priority_type == 0
        unless tile_events.include?(self)
          tile_events << self
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  def collect_code_conditions
    @event.pages.each do |page|
      for command in page.list
        condition_push_flag = false
        if command.code == 108
          command.parameters[0].split(/[\r\n]+/).each do |line|
            if line =~ DND::REGEX::Event::Condition
              puts "#{event.name} code condition: #{$1}"
              page.condition.code_condition << $1 
            end
          end # each line in comment
        end # if the command is comment
      end # each command in page list
    end # each page in event
  end
  #--------------------------------------------------------------------------
  # * Determine if Event Page Conditions Are Met
  #--------------------------------------------------------------------------
  alias :code_condition_met? :conditions_met?
  def conditions_met?(page)
    re = code_condition_met?(page)
    return re if !re
    c = page.condition
    if !c.code_condition.empty?
      @condition_flag = true
      re = false
      $event = self
      c.code_condition.each do |code|
        puts "#{$event.id}: #{code} #{eval(code) rescue false}"
        re ||= eval(code) rescue false
      end
      return re
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Init Public Members.                                              [REP]
  #--------------------------------------------------------------------------
  def init_public_members
    super
    @trigger = 0
    @list = nil
    @starting = false
    if $game_map.effectus_event_starting == self
      $game_map.effectus_event_starting = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Start.                                                            [REP]
  #--------------------------------------------------------------------------
  def start
    return if empty?
    @starting = true
    lock if trigger_in?([0,1,2])
    $game_map.effectus_event_starting = self
  end
  #--------------------------------------------------------------------------
  # * Start Event
  #--------------------------------------------------------------------------
  alias start_gevt_dnd start
  def start
    return if SceneManager.time_stopped?
    start_gevt_dnd
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
  #--------------------------------------------------------------------------
  # * Clear Starting Flag.                                              [REP]
  #--------------------------------------------------------------------------
  def clear_starting_flag
    @starting = false
    if $game_map.effectus_event_starting == self
      $game_map.effectus_event_starting = nil
    end
  end
  #----------------------------------------------------------------------------
  # * Get comments in event page
  #----------------------------------------------------------------------------
  def get_comments
    return unless @list
    comments = ""
    cnt = 0
    listn = @list.size
    while cnt < listn
      if @list[cnt].code == 108
        comments += @list[cnt].parameters[0] + 10.chr
        while cnt < listn && @list[cnt + 1].code == 408
          cnt += 1
          comments += @list[cnt].parameters[0] + 10.chr
        end
      end
      cnt += 1
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
    if @enemy
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
        debug_print "#{event.name} #{@id} is a static object"
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
    if $game_map.event_battler_instance[$game_map.map_id][@id]
      @enemy = $game_map.event_battler_instance[$game_map.map_id][@id]
      @enemy = Game_Enemy.new($game_map.enemies.size, id) if @enemy.dead?
      @enemy.map_char = self
    else
      @enemy = Game_Enemy.new($game_map.enemies.size, id)
      @enemy.map_char = self
    end
    
    debug_print "Spawn enemy #{@enemy.name} at event #{@id}"
    BattleManager.register_battler(self)
    $game_map.make_unique_names
    @enemy.load_tactic_commands
  end
  #--------------------------------------------------------------------------
  # * Move Type : Random.                                               [REP]
  #--------------------------------------------------------------------------
  def move_type_random
    case rand(6)
    when 0 then move_random
    when 1 then move_random
    when 2 then move_forward
    when 3 then move_forward
    when 4 then move_forward
    when 5 then @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Move Type : Approach.                                             [REP]
  #--------------------------------------------------------------------------
  def move_type_toward_player
    if near_the_player?
      case rand(6)
      when 0 then move_toward_player
      when 1 then move_toward_player
      when 2 then move_toward_player
      when 3 then move_toward_player
      when 4 then move_random
      when 5 then move_forward
      end
    else
      move_random
    end
  end
  #----------------------------------------------------------------------------
  def update_terminate
    @terminate_cd -= 1
    if @terminate_cd <= 0
      @terminated = true
    end
  end
  #----------------------------------------------------------------------------
  # * Permanently delete the event
  #----------------------------------------------------------------------------
  def terminate
    @terminate_cd = 180 if (@terminate_cd || 0) <= 0
  end
  #----------------------------------------------------------------------------
  def terminated?
    @terminated
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_gvednd update
  def update
    active = MakerSystems::Effectus::PREVENT_OFFSCREEN_UPDATES
    update_terminate if @terminate_cd > 0
    update_gvednd unless active
    if effectus_near_the_screen? || @effectus_wait_for_animation || @balloon_id > 0
      update_gvednd
      update_effectus_sprite
    else
      update_effectus_route
    end
    
    update_position_registeration unless @effectus_position_registered
    update_position_moved if effectus_moved?
  end
  alias effectus_original_update update_gvednd
  #--------------------------------------------------------------------------
  # * Overwrite: Update During Autonomous Movement
  #--------------------------------------------------------------------------
  def update_self_movement
    return if $game_system.story_mode?
    if !@pathfinding_moves.empty?
      process_pathfinding_movement
    #elsif BattleManager.valid_battler?(self) && @current_target
    #  chase_target
    elsif near_the_screen? && @stop_count > stop_count_threshold
      case @move_type
      when 1;  move_type_random
      when 2;  move_type_toward_player
      when 3;  move_type_custom
      end
    end
  end
  #----------------------------------------------------------------------------
  def battler
    return @enemy if @enemy
    return super
  end
  #--------------------------------------------------------------------------
  def controlable?
    return true if !@enemy
    return super && @enemy.controlable?
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
    refresh
    puts "#{event.id} #{event.name} killed"
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
  # * Refresh. tag: effectus                                            [REP]
  #--------------------------------------------------------------------------
  def refresh
    new_page = @erased ? nil : find_proper_page
    setup_page(new_page) if !new_page || new_page != @page
    @effectus_always_update = false
    if @page && @page.list
      @page.list.each do |command|
        next unless command.code == 108
        MakerSystems::Effectus::PATTERNS.each do |string| 
          next unless command.parameters[0].include?(string)
          @effectus_always_update = true                
          break
        end
        break if @effectus_always_update
      end
    end
    @effectus_always_update = true if trigger == 3 || trigger == 4
    if $game_map.effectus_hard_events.include?(self)
      unless @effectus_always_update
        $game_map.effectus_hard_events.delete(self)
      end
    else
      if @effectus_always_update
        $game_map.effectus_hard_events << self
      end
    end
    if tile? || @effectus_tile
      if $game_map.effectus_pass_table
        unless @effectus_tile && tile?
          $game_map.effectus_release(@x, @y)
        end
      end
    end
    @effectus_tile = tile?
    if @effectus_tile
      unless @effectus_tile_registered
        @effectus_tile_registered = true
        $game_map.effectus_etile_pos[@y * $game_map.width + @x] << self
      end
    else
      if @effectus_tile_registered
        $game_map.effectus_etile_pos[@y * $game_map.width + @x].delete(self)
        @effectus_tile_registered = nil
      end
    end
    unless @effectus_position_registered
      $game_map.effectus_event_pos[@y * $game_map.width + @x] << self
      @effectus_last_x = @x
      @effectus_last_y = @y
      @effectus_position_registered = true
    end
    unless @character_name == @effectus_last_character_name
      bitmap = Cache.character(@character_name)
      string = @character_name[/^[\!\$]./]
      if string && string.include?('$')
        @effectus_bw = bitmap.width / 3 
        @effectus_bh = bitmap.height / 4 
      else
        @effectus_bw = bitmap.width / 12
        @effectus_bh = bitmap.height / 8
      end
      @effectus_last_character_name = @character_name
      @effectus_special_calculus = @effectus_bw > 32 || @effectus_bh > 32
    end
  end
  #--------------------------------------------------------------------------
  # * Near the Screen?                                                  [NEW]
  #--------------------------------------------------------------------------
  if MakerSystems::Effectus::SCREEN_TILE_DIVMOD
    def effectus_near_the_screen?
      if @effectus_special_calculus
        sx = (@real_x - $game_map.display_x) * 32 + 16
        sy = (@real_y - $game_map.display_y) * 32 + 32 - shift_y - jump_height
        sx + @effectus_bw > 0 && 
        sx - @effectus_bw < Graphics.width &&
        sy + @effectus_bh > 0 &&
        sy - @effectus_bh < Graphics.height
      else
        @real_x > $game_map.display_x - 1 &&
        @real_x < $game_map.display_x + Graphics.width  / 32 + 1 &&
        @real_y > $game_map.display_y - 1 &&
        @real_y < $game_map.display_y + Graphics.height / 32 + 1
      end
    end
  else
    def effectus_near_the_screen?
      if @effectus_special_calculus
        sx = (@real_x - $game_map.display_x) * 32 + 16
        sy = (@real_y - $game_map.display_y) * 32 + 32 - shift_y - jump_height
        sx + @effectus_bw > 0 && 
        sx - @effectus_bw < Graphics.width &&
        sy + @effectus_bh > 0 &&
        sy - @effectus_bh < Graphics.height
      else
        @real_x > $game_map.display_x - 1 &&
        @real_x < $game_map.display_x + Graphics.width  / 32 &&
        @real_y > $game_map.display_y - 1 &&
        @real_y < $game_map.display_y + Graphics.height / 32
      end
    end
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
    return @team_id = @enemy.team_id if @enemy
    return nil
    #return DND::BattlerSetting::TeamID
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
    return @aggressive_level = @enemy.enemy.aggressive_level if @enemy
    return DND::BattlerSetting::AggressiveLevel
  end
  #----------------------------------------------------------------------------
  def move_limit
    return @move_limit       if @move_limit
    return @enemy.move_limit if @enemy
    return DND::BattlerSetting::MoveLimit
  end
  #---------------------------------------------------------------------------
  def weapon_level_prof
    return @weapon_level_prof     if @weapon_level_prof
    return @weapon_level_prof = @enemy.weapon_level_prof if @enemy
    return 0
  end
  #----------------------------------------------------------------------------
  def body_size
    return @enemy.enemy.body_size * @zoom_x if @enemy
    return DND::BattlerSetting::BodySize
  end
  #----------------------------------------------------------------------------
  def death_animation
    return @enemy.enemy.death_animation if @enemy
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
    super
  end
  #--------------------------------------------------------------------------
  def default_ammo
    return @default_ammo if @default_ammo
    return @default_ammo = @enemy.default_ammo if @enemy
    return 0
  end
  #--------------------------------------------------------------------------
  def primary_weapon
    return @enemy.default_weapon if @enemy
  end
  #----------------------------------------------------------------------------
  def secondary_weapon
    return @enemy.secondary_weapon if @enemy
  end
  #----------------------------------------------------------------------------
  def static_object?
    return @static_object
  end
  #--------------------------------------------------------------------------
  def casting_animation 
    return super if !@enemy
    return @enemy.enemy.casting_animation rescue super
  end
  #--------------------------------------------------------------------------
  def get_ammo_item(item)
    if item.is_a?(RPG::Weapon) && item.tool_itemcost_type > 0
      return $data_weapons[default_ammo]
    elsif (item.tool_itemcost || 0) > 0
      return $data_items[item.tool_itemcost]
    end
  end
  #--------------------------------------------------------------------------
  # * Detect Collision with Character.                                  [REP]
  #--------------------------------------------------------------------------
  def collide_with_characters?(x, y)
    super || (normal_priority? && $game_player.collide?(x, y))
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
