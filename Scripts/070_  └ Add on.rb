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
  attr_accessor :event_enemies, :enemies, :events_withtags
  attr_accessor :projectiles
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_opt initialize
  def initialize
    @event_enemies = []
    @enemies = []
    @events_withtags = []
    @projectiles = []
    initialize_opt
  end 
  #--------------------------------------------------------------------------
  alias setup_opt setup
  def setup(map_id)
    @event_enemies.clear
    @enemies.clear
    @events_withtags.clear
    puts "[Debug]: Setup map: #{map_id}"
    setup_battlers
    setup_opt(map_id)
    if $game_temp.loadingg != nil
      @event_enemies.each do |event|
        event.resetdeadpose
      end
      $game_temp.loadingg = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Setup battler
  #--------------------------------------------------------------------------
  def setup_battlers
    puts "[Debug]: Setup Battlers"
    $game_party.battle_members[0].map_char = $game_player
    $game_player.followers.each do |follower|
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
      proj.sprite.dispose
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
