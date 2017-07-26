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
  attr_reader :character_sprites
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
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_tileset if @tileset != $game_map.tileset    
    update_tilemap
    update_parallax
    update_characters
    update_shadow
    update_weather
    update_pictures
    update_timer
    update_viewports
  end
  #--------------------------------------------------------------------------
  # * Update Tileset
  #--------------------------------------------------------------------------
  def update_tileset
    load_tileset
    refresh_characters
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
    @unitcir_sprites   = []
    @unit_table        = {}
    
    $game_map.events.values.each do |event|
      create_character_sprite(event)
    end
    
    $game_player.followers.reverse_each do |follower|
      sprite = create_character_sprite(follower)
      register_battle_unit(follower) if follower.actor
    end
    
    player_sprite = create_character_sprite($game_player)
    register_battle_unit($game_player)
    
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
  def create_character_sprite(character)
    sprite = Sprite_Character.new(@viewport1, character)
    @character_sprites.push(sprite)
    character.create_animation_queue
    return sprite
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
      @popups.delete_at(i) if !@popups[i].sprite || @popups[i].sprite.disposed?
    end
  end
  #--------------------------------------------------------------------------
  # * Attach sprite a unit circle
  #--------------------------------------------------------------------------
  # tag: 1 ( Spriteset_Map
  def register_battle_unit(battler)
    sprite = Unit_Circle.new(@viewport1, battler)
    @unitcir_sprites << sprite
    @unit_table[battler.hashid] = @unitcir_sprites.size - 1
  end
  #--------------------------------------------------------------------------
  # * Remove unit circle
  #--------------------------------------------------------------------------
  def resign_battle_unit(battler)
    loc = @unit_table[battler.hashid]
    sprite = @unitcir_sprites.delete_at(loc)
    @unit_table.delete(battler.hashid)
    dispose_sprite(sprite)
  end
  #--------------------------------------------------------------------------
  # * Free all unit sprites
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
  # * Push new projectile sprite
  #--------------------------------------------------------------------------
  def setup_projectile(obj)
    @projectiles.push(obj)
  end
  #--------------------------------------------------------------------------
  # * Setup popup text
  #--------------------------------------------------------------------------
  def setup_popinfo(text, position, color)
    @popups.push( Game_PopInfo.new(text, position, color) )
  end
  #--------------------------------------------------------------------------
  # * Dispose projectiles
  #--------------------------------------------------------------------------
  def dispose_projectiles
    @projectiles.each do |proj|
      proj.dispose_sprite
    end
    @projectiles.clear
  end
  #--------------------------------------------------------------------------
  # * Dispose pop-ups
  #--------------------------------------------------------------------------
  def dispose_popups
    @popups.each do |sprite|
      sprite.dispose_sprite
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
      dispose_sprite(sprite)
    end
  end
  #--------------------------------------------------------------------------
  def dispose_sprite(sprite)
    sprite.character.dispose_sprites if sprite.character
    sprite.dispose
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
  #--------------------------------------------------------------------------
  def event_usable?(character)
    return true unless character.is_a?(Game_Event)
    return character.character_name || character.terminated
  end
  #--------------------------------------------------------------------------
  # * Update Aircraft Shadow Sprite
  #--------------------------------------------------------------------------
  def update_shadow
    
  end
  #--------------------------------------------------------------------------
  # * Update Viewport
  #--------------------------------------------------------------------------
  def update_viewports
    @viewport1.tone.set($game_map.screen.tone)
    @viewport1.ox = $game_map.screen.shake
    @viewport2.color.set($game_map.screen.flash_color)
    @viewport3.color.set(0, 0, 0, 255 - $game_map.screen.brightness)
    @viewport1.update
    @viewport2.update
    @viewport3.update
  end
  #--------------------------------------------------------------------------
  # * Update Parallax
  #--------------------------------------------------------------------------
  def update_parallax
    if @parallax_name != $game_map.parallax_name
      @parallax_name = $game_map.parallax_name
      @parallax.bitmap.dispose if @parallax.bitmap
      @parallax.bitmap = Cache.parallax(@parallax_name)
      Graphics.frame_reset
    end
    return if @parallax_name.size == 0
    @parallax.ox = $game_map.parallax_ox(@parallax.bitmap)
    @parallax.oy = $game_map.parallax_oy(@parallax.bitmap)
  end
  
end
