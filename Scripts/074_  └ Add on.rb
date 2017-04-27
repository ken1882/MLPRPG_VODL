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
  attr_accessor :projectiles, :enemies
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_opt initialize
  def initialize
    @projectiles = []
    @enemies = []
    initialize_opt
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  # tag: tactic
  #--------------------------------------------------------------------------
  def update_tactic
    refresh if @need_refresh
    update_interpreter if main
    update_scroll
    update_events
    update_vehicles
    update_parallax
    @screen.update
  end
  #--------------------------------------------------------------------------
  # * Setup
  # tag: loading
  #--------------------------------------------------------------------------
  def setup(map_id)
    dispose_projectiles if map_id != @map_id
    @enemies.clear
    puts "[Debug]: Setup map: #{map_id}"
    SceneManager.reserve_loading_screen(map_id)
    Graphics.fadein(60)
    SceneManager.set_loading_phase("Mining Block Chain", -1)
    BlockChain.mining
    
    setup_battlers
    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rvdata2", @map_id))
    load_total = 4 + @map.events.size + 10
    load_total = 180 if load_total < 180
    SceneManager.set_loading_phase('Load Map', load_total)
    
    @tileset_id = @map.tileset_id
    @display_x = 0
    @display_y = 0
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    @need_refresh = false
    $game_player.center($game_player.new_x, $game_player.new_y) if SceneManager.scene_is?(Scene_Map)
    SceneManager.update_loading while SceneManager.loading?
    SceneManager.destroy_loading_screen unless $game_temp.loading_destroy_delay
  end
  #--------------------------------------------------------------------------
  # * Setup battler
  #--------------------------------------------------------------------------
  def setup_battlers
    puts "[Debug]: Setup Battlers"
    $game_party.battle_members[0].map_char = $game_player
    $game_player.followers.each do |follower|
      SceneManager.update_loading # tag: loading
      next if !follower.actor
      follower.actor.map_char = follower
    end
    puts "[Debug]: Battlers ready"
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
      @events[i] = eve unless eve.comment_include?("<no update>")
      @enemies.push(@events[i]) if @events[i] && setup_npc_battler(@events[i])
    end
    
    BattleManager.setup(@enemies)
    
    @common_events = parallel_common_events.collect do |common_event|
      Game_CommonEvent.new(common_event.id)
    end
    refresh_tile_events
  end
  #--------------------------------------------------------------------------
  # * Setup Non-Player Battler
  #--------------------------------------------------------------------------
  def setup_npc_battler(event)
    return false unless event.event.name =~ DND::REGEX::NPCEvent
    event.enemy = Game_Enemy.new(@enemies.size, $1.to_i)
    event.enemy.map_char = event
    return true
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #     main:  Interpreter update flag
  #--------------------------------------------------------------------------
  alias update_gamemap_opt update
  def update(main = false)
    update_gamemap_opt(main)
    update_projectile
  end
  #--------------------------------------------------------------------------
  def setup_projectile(obj)
    @projectiles.push(obj)
  end
  #--------------------------------------------------------------------------
  def setup_popinfo(text, position, color)
    @projectiles.push( Game_PopInfo.new(text, position, color) )
  end
  #--------------------------------------------------------------------------
  def update_projectile
    n = @projectiles.size
    for i in 0...n
      if @projectiles[i].nil?
        @projectiles.delete_at(i); next
      end
      @projectiles[i].update
      @projectiles.delete_at(i) if @projectiles[i].sprite.disposed?
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose projectiles
  #--------------------------------------------------------------------------
  def dispose_projectiles
    puts "[Debug]: Dispose projectiles (#{@projectiles.size})"
    @projectiles.each do |proj|
      proj.disepose_sprite
    end
    puts '[Debug]: Dispose successed'
    @projectiles.clear
  end
  #--------------------------------------------------------------------------
  # * Restore projectiles
  #--------------------------------------------------------------------------
  def restore_projectile
    @projectiles = Cache.projectile
    @projectiles.each {|proj| proj.restore}
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_map_dnd refresh
  def refresh
    refresh_map_dnd
    setup_battlers
    puts "[Debug]: Map Refreshed"
  end
  #--------------------------------------------------------------------------
  # * Update Vehicles
  #--------------------------------------------------------------------------
  def update_vehicles
  end
end
