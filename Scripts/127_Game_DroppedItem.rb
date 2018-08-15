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
    @sprite = SceneManager.register_item_drop(self, @x, @y)
  end
  #--------------------------------------------------------------------------
  def unlink_sprite
    @sprite = nil
  end
  #--------------------------------------------------------------------------
  def picked?
    @loots.empty?
  end
  #--------------------------------------------------------------------------
  def process_pickup
    @loots.each do |loot|
      if loot.is_a?(Fixnum)
        $game_party.gain_gold(loot, Vocab::Coinbase, Vocab::BlockChain::DropLoot)
      else
        $game_party.gain_item(loot, 1, Vocab::Coinbase, Vocab::BlockChain::DropLoot)
      end
    end
    Audio.se_play('Audio/SE/coin01', 80 * $game_system.volume(:sfx) * 0.01, 100)
    @loots.clear
    dispose
  end
  #--------------------------------------------------------------------------
  def merge(gold, items = [])
    @loots[0] += gold
    @loots << items
  end
  #--------------------------------------------------------------------------
  def sprite_valid?
    return false if @sprite.nil?
    return @sprite.disposed?
  end  
end
