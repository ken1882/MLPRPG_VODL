#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  attr_reader :viewport1
  attr_reader :viewport3
  attr_reader :viewport2
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_spsetmap_dnd initialize
  def initialize
    init_spsetmap_dnd
    create_hud
  end
  #--------------------------------------------------------------------------
  # *) Create heads-up display on map
  #--------------------------------------------------------------------------
  def create_hud
    $game_party.skillbar.create_layout(@viewport2)
  end
  #--------------------------------------------------------------------------
  # * Create Character Sprite (group)
  #--------------------------------------------------------------------------
  def create_characters
    @character_sprites = []
    @battler_sprites   = []
    @unitcir_sprites   = []
    $game_map.events.values.each do |event|
      sprite = Sprite_Character.new(@viewport1, event)
      @character_sprites.push(sprite)
      regist_battle_unit(sprite) if event.enemy
    end
    
    
    $game_player.followers.reverse_each do |follower|
      sprite = Sprite_Character.new(@viewport1, follower)
      @character_sprites.push(sprite)
      regist_battle_unit(sprite) if follower.actor
    end
    
    player_sprite = Sprite_Character.new(@viewport1, $game_player)
    @character_sprites.push(player_sprite)
    regist_battle_unit(player_sprite)
    
    @map_id = $game_map.map_id
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_spsetmap_opt update
  def update
    $game_party.skillbar.update
    update_spsetmap_opt
  end
  #--------------------------------------------------------------------------
  def regist_battle_unit(sprite)
    @battler_sprites.push(sprite)
    @unitcir_sprites.push(Unit_Circle.new(@viewport1, sprite))
    return true
  end
  #--------------------------------------------------------------------------
  def dispose_unit_circles
    @battler_sprites.each do |sprite|
      sprite.dispose unless !sprite || sprite.disposed?
      sprite = nil
    end
    @unitcir_sprites.each do |sprite|
      sprite.dispose unless !sprite || sprite.disposed?
      sprite = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  alias dispose_spmap_opt dispose
  def dispose
    dispose_spmap_opt
    dispose_unit_circles
    $game_party.skillbar.dispose_layout
  end
end
