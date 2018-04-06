#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Characters to be added to the end of enemy names
  #--------------------------------------------------------------------------
  LETTER_TABLE_HALF = [' A',' B',' C',' D',' E',' F',' G',' H',' I',' J',
                       ' K',' L',' M',' N',' O',' P',' Q',' R',' S',' T',
                       ' U',' V',' W',' X',' Y',' Z']
  LETTER_TABLE_FULL = ['Ａ','Ｂ','Ｃ','Ｄ','Ｅ','Ｆ','Ｇ','Ｈ','Ｉ','Ｊ',
                       'Ｋ','Ｌ','Ｍ','Ｎ','Ｏ','Ｐ','Ｑ','Ｒ','Ｓ','Ｔ',
                       'Ｕ','Ｖ','Ｗ','Ｘ','Ｙ','Ｚ']
  #--------------------------------------------------------------------------
  #  Constants
  #--------------------------------------------------------------------------
  Battler_Updates   = 20
  ProjPoolSize      = 20
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :map
  attr_reader   :max_width, :max_height
  attr_reader   :enemy_names_count
  attr_accessor :action_battlers, :unit_table
  attr_accessor :timer, :timestop_timer
  attr_accessor :enemies
  attr_accessor :accurate_event_positions
  attr_accessor :event_battler_instance, :queued_actions
  attr_reader   :item_drops, :projectile_pool, :cache_projectile
  attr_accessor :fog_enabled                      # Light effect fog
  attr_reader   :active_enemies, :active_enemy_count
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_opt initialize
  def initialize
    @timer           = 0
    @timestop_timer  = 0
    @item_drops      = {}
    @accurate_event_positions = {}
    @event_battler_instance   = {}
    @enemies            = []
    @queued_actions     = []
    @active_enemies     = []
    @projectile_pool    = []
    @cache_projectile   = []
    @flag_after_load    = false
    @fog_enabled        = false
    @enemy_update_index = 0
    @active_enemy_count = 0
    allocate_pools
    init_battle_members
    initialize_opt
    set_max_edge
  end
  #--------------------------------------------------------------------------
  def map
    @map
  end
  #--------------------------------------------------------------------------
  def set_max_edge
    @max_width  = (Graphics.width / 32).truncate
    @max_height = (Graphics.height / 32).truncate
  end
  #--------------------------------------------------------------------------
  def init_battle_members
    @action_battlers   = {}
    @unit_table        = {}
    @enemy_names_count = {}
    BattleManager::Team_Number.times {|key| @action_battlers[key] = Array.new()}
  end
  #--------------------------------------------------------------------------
  def assign_party_battler
    @action_battlers[0] = $game_party.battle_members
    @enemies.each do |battler|
      @action_battlers[0] << battler if battler.team_id == 0
    end
  end
  #--------------------------------------------------------------------------
  # * Setup
  # tag: loading
  #--------------------------------------------------------------------------
  def setup(map_id)
    dispose_sprites
    dispose_item_drops
    save_battler_instance if @map_id > 0
    @event_battler_instance[map_id] = Hash.new if @event_battler_instance[map_id].nil?
    clear_battlers
    SceneManager.dispose_temp_sprites if map_id != @map_id
    BattleManager.setup
    
    debug_print "Setup map: #{map_id}"
    SceneManager.reserve_loading_screen(map_id)
    Graphics.fadein(60)
    SceneManager.set_loading_phase("Mining Block Chain", -1)
    
    @active_enemies.clear
    @active_enemy_count = 0
    BlockChain.mining
    $game_party.sync_blockchain
    setup_battlers
    setup_loading(map_id)
    setup_camera
    load_map_settings
    @item_drops[@map_id] = Array.new if @item_drops[@map_id].nil?
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    @need_refresh = false
    @map.battle_bgm = $battle_bgm
    @backup = nil
    deploy_map_item_drops
    after_setup
  end
  #--------------------------------------------------------------------------
  def setup_loading(map_id)
    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rvdata2", @map_id))
    load_total = 4 + @map.events.size + 10
    load_total = 180 if load_total < 180
    SceneManager.set_loading_phase('Load Map', load_total)
  end
  #--------------------------------------------------------------------------
  def setup_camera
    @tileset_id = @map.tileset_id
    @display_x = 0
    @display_y = 0
  end
  #--------------------------------------------------------------------------
  def load_map_settings
    @fog_enabled = false
    @map.note.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Map::LightEffect
        @fog_enabled = $1.to_i
      end
    end
    
    if $game_map.fog_enabled
      puts "Fog enabled: #{@fog_enabled}"
      $game_map.effect_surface.change_color(60,0,0,0,@fog_enabled)
    else
      puts "Fog disbled"
      $game_map.effect_surface.change_color(60,255,255,0,0)
    end
  end
  #--------------------------------------------------------------------------
  # * Setup battler
  #--------------------------------------------------------------------------
  def setup_battlers
    $game_party.battle_members[0].map_char = $game_player
    $game_player.followers.each do |follower|
      SceneManager.update_loading # tag: loading
      next if !follower.actor
      follower.actor.map_char = follower
    end
    assign_party_battler
  end
  #--------------------------------------------------------------------------
  # * Event Setup
  #--------------------------------------------------------------------------
  def setup_events
    @events  = {}
    
    @map.events.each do |i, event|
      SceneManager.update_loading # tag: loading
      eve = Game_Event.new(@map_id, event)
      next if eve.terminated?
      @events[i] = eve
    end
    
    @common_events = parallel_common_events.collect do |common_event|
      Game_CommonEvent.new(common_event.id)
    end
    refresh_tile_events
  end
  #--------------------------------------------------------------------------
  # * Processes after setups
  #--------------------------------------------------------------------------
  def after_setup
    $game_player.center($game_player.new_x, $game_player.new_y) if SceneManager.scene_is?(Scene_Map)
    SceneManager.update_loading while SceneManager.loading?
    SceneManager.destroy_loading_screen unless $game_temp.loading_destroy_delay
  end
  #-----------------------------------------------------------------------------
  # * Overwrite method : Refresh
  # > Moved from Theo Anti-Lag
  #-----------------------------------------------------------------------------
  def refresh
    BattleManager.refresh
    SceneManager.spriteset.refresh rescue nil
    return table_refresh if table_update? && Theo::AntiLag::PageCheck_Enchancer
    @events.each_value {|event| next if event.never_refresh; event.refresh }
    @common_events.each {|event| event.refresh }
    refresh_tile_events
    @need_refresh = false
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_map_dnd refresh
  def refresh
    setup_battlers
    refresh_map_dnd
    debug_print "Map Refreshed"
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #     main:  Interpreter update flag
  #--------------------------------------------------------------------------
  # tag: timeflow
  alias update_gmap_timer update
  def update(main = false)
    update_timer
    update_drops
    update_queued_actions
    update_enemies
    update_gmap_timer(main)
  end
  #--------------------------------------------------------------------------
  def update_queued_actions
    @queued_actions.each do |action|
      action.effect_delay -= 1
      if action.effect_delay <= 0
        BattleManager.apply_action_effect(action) 
        @queued_actions.delete(action)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update timer 
  #--------------------------------------------------------------------------
  def update_timer
    @timer += 1
    process_battler_regenerate if @timer % DND::BattlerSetting::RegenerateTime == 0
    process_timecycle_end      if @timer >= PONY::TimeCycle
  end
  #--------------------------------------------------------------------------
  # * Update NPC battler
  #--------------------------------------------------------------------------
  def update_enemies
    @active_enemy_count = [@active_enemy_count, 0].max
    return if @active_enemy_count == 0
    
    battler = @active_enemies[@enemy_update_index]
    if battler.nil?
      @active_enemies = @active_enemies.compact
      @active_enemy_count = @active_enemies.size
    else
      battler.update_battler
    end
    @enemy_update_index = (@enemy_update_index + 1) % @active_enemy_count
  end
  #--------------------------------------------------------------------------
  def remove_active_enemy(enemy)
    @active_enemies.delete(enemy)
    @active_enemy_count -= 1
  end
  #--------------------------------------------------------------------------
  def add_active_enemy(enemy)
    return if @active_enemies.include?(enemy)
    @active_enemies << enemy
    @active_enemy_count += 1
  end
  #--------------------------------------------------------------------------
  def process_battler_regenerate
    BattleManager.regenerate_all
  end
  #--------------------------------------------------------------------------
  def process_timecycle_end
    @timer = 0
    BattleManager.on_turn_end
    BattleManager.clear_flag(:in_battle)
  end
  #--------------------------------------------------------------------------
  def terminate_event(event)
    puts "Terminate event: #{event.id}"
    @events.delete(event.id)
    @cached_events.delete(event) if @cached_events
    @keep_update_events.delete(event) if @keep_update_events
    @forced_update_events.delete(event) if @forced_update_events
  end
  #--------------------------------------------------------------------------
  # * Push character into active battlers
  #--------------------------------------------------------------------------
  def register_battler(battler)
    if @unit_table[battler.hashid]
      debug_print "Battler register failed: #{battler}"
      return
    end
    @enemies << battler
    @action_battlers[battler.team_id] << battler
    @unit_table[battler.hashid] = battler
    SceneManager.scene.register_battle_unit(battler) if SceneManager.scene_is?(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * Remove unit
  #--------------------------------------------------------------------------
  def resign_battle_unit(battler)
    @enemies.delete(battler)
    @action_battlers[battler.team_id].delete(battler)
    @unit_table[battler.hashid] = nil
    debug_print "Battler resigned #{battler}"
    SceneManager.scene.resign_battle_unit(battler) if SceneManager.scene_is?(Scene_Map)
  end
  #--------------------------------------------------------------------------
  def all_battlers
    re = []
    @action_battlers.each do |key, team|
      team.each {|battler| re << battler}
    end
    return re
  end
  #--------------------------------------------------------------------------
  def all_alive_battlers
    re = []
    @action_battlers.each do |key, battlers|
      battlers.each {|battler| re << battler unless battler.dead?}
    end
    return re
  end
  #--------------------------------------------------------------------------
  def dead_battlers
    re = []
    @action_battlers.each do |key, battlers|
      battlers.each {|battler| re << battler if battler.dead?}
    end
    return re
  end
  #--------------------------------------------------------------------------
  # * Return alive allied battlers
  #--------------------------------------------------------------------------
  def ally_battler(battler = $game_palyer)
    return @action_battlers[battler.team_id].compact.select{|char| !char.dead?}
  end
  #--------------------------------------------------------------------------
  # * Return dead allies
  #--------------------------------------------------------------------------
  def dead_allies(battler = $game_player)
    return @action_battlers[battler.team_id].compact.select{|char| char.dead?}
  end
  #--------------------------------------------------------------------------
  # * Return alive hostile battlers
  #--------------------------------------------------------------------------
  def opponent_battler(battler = $game_player)
    opponents = []
    @action_battlers.each do |key, members|
      next if key == battler.team_id
      members.compact.each do |member|
        next if member.dead?
        opponents.push(member)
      end
    end
    return opponents
  end
  #--------------------------------------------------------------------------
  # * Return dead hostile battlers
  #--------------------------------------------------------------------------
  def dead_opponents(battler = $game_player)
    opponents = []
    @action_battlers.each do |key, members|
      next if key == battler.team_id
      members.compact.each do |member|
        next unless member.dead?
        opponents.push(member)
      end
    end
    return opponents
  end
  #--------------------------------------------------------------------------
  # * Add letters (ABC, etc) to enemy characters with the same name
  #--------------------------------------------------------------------------
  def make_unique_names
    @enemies.each do |enemy|
      next unless enemy.alive?
      next unless enemy.letter.empty?
      n = @enemy_names_count[enemy.original_name] || 0
      enemy.letter = letter_table[n % letter_table.size]
      @enemy_names_count[enemy.original_name] = n + 1
    end
    @enemies.each do |enemy|
      n = @enemy_names_count[enemy.original_name] || 0
      enemy.plural = true if n >= 2
    end
  end
  #--------------------------------------------------------------------------
  # * Get Text Table to Place Behind Enemy Name
  #--------------------------------------------------------------------------
  def letter_table
    $game_system.japanese? ? LETTER_TABLE_FULL : LETTER_TABLE_HALF
  end
  #--------------------------------------------------------------------------
  def on_game_save
    dispose_sprites
    dispose_lights
    dispose_item_drops
    @events.each do |key, event|
      pos = [POS.new(event.real_x, event.real_y),POS.new(event.x, event.y), POS.new(event.px, event.py)]
      @accurate_event_positions[key] = pos
    end
    save_battler_instance
    super_dispose
  end
  #--------------------------------------------------------------------------
  def dispose_sprites
    @events.each do |key, event|
      event.dispose_sprites
    end
  end
  #--------------------------------------------------------------------------
  def after_game_load
    @flag_after_load = true
  end
  #--------------------------------------------------------------------------
  def on_after_load
    @enemy_names_count = {}
    @flag_after_load = false
    relocate_events
    all_battlers.each do |battler|
      resign_battle_unit(battler) if !BattleManager.valid_battler?(battler)
    end
    debug_print "Action battler count: #{all_battlers.size}"
    make_unique_names
  end
  #--------------------------------------------------------------------------
  def clear_battlers
    all_battlers.each do |battler|
      resign_battle_unit(battler)
    end
    init_battle_members
  end
  #--------------------------------------------------------------------------
  def relocate_events
    @accurate_event_positions.each do |key, pos|
      next if @events[key].nil?
      @events[key].load_position(*pos)
    end
    @accurate_event_positions.clear
  end
  #--------------------------------------------------------------------------
  def update_vehicles
  end
  #--------------------------------------------------------------------------
  def update_drops
    @item_drops[@map_id].each do |drops|
      @item_drops[@map_id].delete(drops) if drops.picked?
      drops.update
    end
  end
  #--------------------------------------------------------------------------
  def deploy_map_item_drops
    @item_drops[@map_id] = Array.new if @item_drops[@map_id].nil?
    @item_drops[@map_id].each do |drops|
      next if drops.sprite_valid?
      deploy_item_drop(drops)
    end
  end
  #--------------------------------------------------------------------------
  def dispose_item_drops
    @item_drops[@map_id] = Array.new if @item_drops[@map_id].nil?
    @item_drops[@map_id].each do |drops|
      drops.dispose
    end
  end
  #--------------------------------------------------------------------------
  def register_item_drop(x, y, gold, loots)
    return if loots.empty? && gold < 1
    @item_drops[@map_id].each do |drop|
      if (drop.x - x).abs < 1 && (drop.y - y).abs < 1
        return drop.merge(gold, loots)
      end
    end
    loots.unshift(gold)
    drops = Game_DroppedItem.new(@map_id, x, y, loots)
    @item_drops[@map_id] << drops
    deploy_item_drop(drops)
  end
  #--------------------------------------------------------------------------
  def deploy_item_drop(drops)
    return if drops.map_id != @map_id
    drops.deploy_sprite
  end
  #--------------------------------------------------------------------------
  def refresh_condition_events
    @events.each_value do |eve|
      eve.refresh if eve.condition_flag
    end
  end
  #--------------------------------------------------------------------------
  def save_battler_instance
    @event_battler_instance[@map_id] = Hash.new if @event_battler_instance[@map_id].nil?
    @events.each do |key, event|
      @event_battler_instance[@map_id][key] = event.enemy if BattleManager.valid_battler?(event) && !event.dead?
    end
  end
  #--------------------------------------------------------------------------
  def all_dead?(team_id)
    return !(@enemies.select{|c| c.team_id == team_id}.any?{|b| !b.dead?})
  end
  #--------------------------------------------------------------------------
  def cache_crash_backup
    @backup = Marshal.dump($game_map) rescue @backup
  end
  #--------------------------------------------------------------------------
  def get_cached_backup
    return @backup
  end
  #--------------------------------------------------------------------------
  def dispose_lights
    @lantern.dispose if @lantern
    @surfaces.each{|s| s.dispose} if @surfaces
    @light_sources.each { |source| source.dispose_light } if @light_sources
    if @light_surface
      @light_surface.bitmap.dispose
      @light_surface.dispose
      @light_surface = nil
    end
  end
  #--------------------------------------------------------------------------
  def super_dispose
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Window) || ivar.is_a?(Sprite) || ivar.is_a?(Bitmap)
    end
  end
  #--------------------------------------------------------------------------
  # * Store projectiles
  #--------------------------------------------------------------------------
  def store_projectile(projs)
    debug_print "Projectile stored (#{projs.size})"
    @cache_projectile = projs.dup
    @cache_projectile.each{|proj| proj.dispose_sprite}
  end
  #--------------------------------------------------------------------------
  # * Retrieve stored cache
  #--------------------------------------------------------------------------
  def get_cached_projectile
    return @cache_projectile
  end
  #--------------------------------------------------------------------------
  def clear_projectiles
    debug_print "Clear projectiles cache (#{@cache_projectile.size})"
    @cache_projectile.clear
  end
  #--------------------------------------------------------------------------
  def allocate_pools
    ProjPoolSize.times{|i| self.allocate_proj}
  end
  #--------------------------------------------------------------------------
  def allocate_proj
    proj = Game_Projectile.allocate
    proj.deactivate
    @projectile_pool << proj
  end
  #--------------------------------------------------------------------------
  def get_idle_proj
    re = @projectile_pool.find{|proj| !proj.active?}
    re
  end
  #--------------------------------------------------------------------------
end
