#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :map
  attr_reader   :max_width, :max_height
  attr_accessor :timer
  attr_accessor :projectiles, :enemies
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_opt initialize
  def initialize
    @projectiles = []
    @enemies = []
    @timer   = 0
    initialize_opt
    set_max_edge
  end
  #--------------------------------------------------------------------------
  def set_max_edge
    @max_width  = (Graphics.width / 32).truncate
    @max_height = (Graphics.height / 32).truncate
  end
  #--------------------------------------------------------------------------
  # * Setup
  # tag: loading
  #--------------------------------------------------------------------------
  def setup(map_id)
    SceneManager.dispose_temp_sprites if map_id != @map_id
    BattleManager.setup
    @enemies.clear
    debug_print "Setup map: #{map_id}"
    
    SceneManager.reserve_loading_screen(map_id)
    Graphics.fadein(60)
    SceneManager.set_loading_phase("Mining Block Chain", -1)
    $mutex.synchronize{BlockChain.mining}
    setup_battlers
    setup_loading(map_id)
    setup_camera
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    @need_refresh = false
    
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
  # * Setup battler
  #--------------------------------------------------------------------------
  def setup_battlers
    debug_print "Setup Battlers"
    $game_party.battle_members[0].map_char = $game_player
    
    $game_player.followers.each do |follower|
      SceneManager.update_loading # tag: loading
      next if !follower.actor
      follower.actor.map_char = follower
    end
  end
  #--------------------------------------------------------------------------
  # * Event Setup
  #--------------------------------------------------------------------------
  def setup_events
    @events  = {}
    @enemies = []
    @map.events.each do |i, event|
      SceneManager.update_loading # tag: loading
      eve = Game_Event.new(@map_id, event)
      next if eve.terminated
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
    update_gmap_timer(main)
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
    @events.delete(event.id)
    @cached_events.delete(event)
  end
  #--------------------------------------------------------------------------
  def register_battle_unit(battler)
    if @spriteset
      @spriteset.register_battle_unit(battler)
    end
  end
  #--------------------------------------------------------------------------
  def resign_battle_unit(battler)
    if @spriteset
      @spriteset.resign_battle_unit(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Vehicles
  #--------------------------------------------------------------------------
  def update_vehicles
  end
  
end
