#===============================================================================
# * Game_DroppedItem
#-------------------------------------------------------------------------------
#   The dropped item on the map
#===============================================================================
class Game_DroppedItem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :map_id
  attr_reader :loots
  attr_reader :sprite
  attr_accessor :x
  attr_accessor :y
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(map_id, x, y, loots)
    @map_id = map_id
    @x      = x
    @y      = y 
    @loots  = loots
  end
  #--------------------------------------------------------------------------
  def update
    @sprite.update unless @sprite.nil? || @sprite.disposed?
    if $game_player.adjacent?(@x + 0.5, @y + 0.5)
      process_pickup
    end
  end
  #--------------------------------------------------------------------------
  def dispose
    return if @sprite.nil? || @sprite.disposed?
    @sprite.dispose
  end
  #--------------------------------------------------------------------------
  def deploy_sprite
    @sprite = SceneManager.register_item_drop(@x, @y)
  end
  #--------------------------------------------------------------------------
  def picked?
    @loots.empty?
  end
  #--------------------------------------------------------------------------
  def process_pickup
    loots.each do |loot|
      if loot.is_a?(Fixnum)
        $game_party.gain_gold(loot)
      else
        $game_party.gain_item(loot, 1)
      end
    end
    Audio.se_play('Audio/SE/coin01', 100, 100)
    @loots.clear
    dispose
  end
  #--------------------------------------------------------------------------
end
