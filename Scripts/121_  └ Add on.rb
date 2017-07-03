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
  attr_reader :projectiles
  attr_reader :popups
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_spsetmap_dnd initialize
  def initialize
    @projectiles = []
    @popups      = []
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
  # * Overwrite: Create Character Sprite (group)
  #--------------------------------------------------------------------------
  def create_characters
    @character_sprites = []
    @battler_sprites   = []
    @unitcir_sprites   = []
    
    $game_map.events.values.each do |event|
      sprite = Sprite_Character.new(@viewport1, event)
      @character_sprites.push(sprite)
      event.create_animation_queue
      regist_battle_unit(sprite) if event.enemy
    end
    
    $game_player.followers.reverse_each do |follower|
      sprite = Sprite_Character.new(@viewport1, follower)
      @character_sprites.push(sprite)
      follower.create_animation_queue
      regist_battle_unit(sprite) if follower.actor
    end
    
    player_sprite = Sprite_Character.new(@viewport1, $game_player)
    $game_player.create_animation_queue
    @character_sprites.push(player_sprite)
    regist_battle_unit(player_sprite)
    
    @map_id = $game_map.map_id
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_spsetmap_opt update
  def update
    update_skillbar
    update_projectiles
    update_popups
    update_spsetmap_opt
  end
  #--------------------------------------------------------------------------
  def update_skillbar
    $game_party.skillbar.update
  end
  #--------------------------------------------------------------------------
  def update_projectiles
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
  def update_popups
    n = @popups.size
    for i in 0...n
      if @popups[i].nil?
        @popups.delete_at(i); next
      end
      @popups[i].update
      @popups.delete_at(i) if @popups[i].sprite.disposed?
    end
  end
  #--------------------------------------------------------------------------
  def regist_battle_unit(sprite)
    @battler_sprites.push(sprite)
    @unitcir_sprites.push(Unit_Circle.new(@viewport1, sprite))
    return true
  end
  #--------------------------------------------------------------------------
  def dispose_units
    @battler_sprites.each do |sprite|
      sprite.dispose unless !sprite || sprite.disposed?
    end
    @unitcir_sprites.each do |sprite|
      sprite.dispose unless !sprite || sprite.disposed?
    end
    @battler_sprites.clear
    @unitcir_sprites.clear
  end
   #--------------------------------------------------------------------------
  def setup_projectile(obj)
    @projectiles.push(obj)
  end
  #--------------------------------------------------------------------------
  def setup_popinfo(text, position, color)
    @popups.push( Game_PopInfo.new(text, position, color) )
  end
  #--------------------------------------------------------------------------
  # * Dispose projectiles
  #--------------------------------------------------------------------------
  def dispose_projectiles
    @projectiles.each do |proj|
      proj.disepose_sprite
    end
    @projectiles.clear
  end
  #--------------------------------------------------------------------------
  # * Dispose pop-ups
  #--------------------------------------------------------------------------
  def dispose_popups
    @popups.each do |sprite|
      sprite.disepose_sprite
    end
    @popups.clear
  end
  #--------------------------------------------------------------------------
  # * Restore projectiles
  #--------------------------------------------------------------------------
  def restore_projectile
    @projectiles = Cache.projectile
    @projectiles.each {|proj| proj.restore}
  end
  #--------------------------------------------------------------------------
  def dispose_temp_sprites
    dispose_projectiles
    dispose_popups
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Free Character Sprite
  #--------------------------------------------------------------------------
  def dispose_characters
    @character_sprites.each do |sprite| 
      sprite.character.dispose_sprites if sprite.character
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  alias dispose_spmap_opt dispose
  def dispose
    dispose_spmap_opt
    dispose_units
    dispose_temp_sprites
    $game_party.skillbar.dispose_layout
  end
end
