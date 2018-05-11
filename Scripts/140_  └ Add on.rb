#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  TILESIZE = 32
  EFFECTUS_EMPTY_STR = ''
  #--------------------------------------------------------------------------
  attr_reader :viewport1, :viewport2, :viewport3
  attr_reader :projectiles, :popups
  attr_reader :character_sprites, :unitcir_sprites
  attr_reader :hud_sprite, :tilemap, :tile_layer
  attr_reader :player_target_sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_spsetmap_dnd initialize
  def initialize
    @projectiles = []
    @popups      = []
    @weapon_sprites = {}
    @drop_sprites = []
    create_huds
    create_tile_layer
    create_player_target_sprite
    init_spsetmap_dnd
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
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_spsetmap_opt update
  def update
    update_skillbar
    update_projectiles
    update_popups
    update_huds
    update_weapons
    update_tile_layer
    update_player_target_sprite
    update_spsetmap_opt
  end
  #--------------------------------------------------------------------------
  # * Update Tileset
  #--------------------------------------------------------------------------
  def update_tileset
    load_tileset
    refresh_characters
  end
  #--------------------------------------------------------------------------
  def create_player_target_sprite
    @player_target_sprite = ::Sprite.new(@viewport)
    @player_target_sprite.bitmap = Cache.target_sprite
  end
  #--------------------------------------------------------------------------
  def create_tile_layer
    @tile_layer   = Sprite.new(@viewport1)
    @tile_layer.z = 1
    @tile_layer.bitmap = Bitmap.new($game_map.width * 32, $game_map.height * 32)
  end
  #--------------------------------------------------------------------------
  # *) Create heads-up display on map
  #--------------------------------------------------------------------------
  def create_huds
    $game_party.skillbar.create_layout(@viewport2)
    @hud_sprite = []
    4.times do |index|
      member = $game_party.members[index]
      @hud_sprite << Sprite_Hud.new(member, index, @viewport2)
    end
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
    
    $game_map.enemies.each {|battler| register_battle_unit(battler)}
    
    $game_player.followers.reverse_each do |follower|
      create_character_sprite(follower)
      register_battle_unit(follower)
    end
    
    player_sprite = create_character_sprite($game_player)
    register_battle_unit($game_player)
    
    @map_id = $game_map.map_id
  end
  #-----------------------------------------------------------------------------
  # * Create layout for tactic cursor
  #-----------------------------------------------------------------------------
  def create_tactic_cursor(instance)
    @tactic_cursor = Sprite_TacticCursor.new(@viewport1, instance)
  end
  #--------------------------------------------------------------------------
  def create_character_sprite(character)
    sprite = Sprite_Character.new(@viewport1, character)
    @character_sprites.push(sprite)
    character.create_animation_queue
    return sprite
  end
  #--------------------------------------------------------------------------
  # * Vanilla Update Sprites.                                           [NEW]
  #--------------------------------------------------------------------------
  def effectus_vanilla_update_sprites
    @character_sprites.each { |sprite| sprite.effectus_vanilla_update }
  end
  #--------------------------------------------------------------------------
  def update_player_target_sprite
    target = $game_player.current_target
    return @player_target_sprite.hide unless target
    @player_target_sprite.show unless @player_target_sprite.visible?
    cx, cy = target.screen_x - 16, target.screen_y - 28
    @player_target_sprite.moveto(cx, cy)
  end
  #--------------------------------------------------------------------------
  def update_skillbar
    $game_party.skillbar.update
  end
  #--------------------------------------------------------------------------
  def update_huds
    @hud_sprite.each{|sp| sp.update}
  end
  #--------------------------------------------------------------------------
  def update_projectiles
    n = @projectiles.size
    for i in 0...n
      if @projectiles[i].nil? || !@projectiles[i].active? || @projectiles[i].sprite.nil?
        @projectiles.delete_at(i); next;
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
  def update_units
    @unitcir_sprites.each {|sprite| sprite.update}
  end
  #--------------------------------------------------------------------------
  def update_weapons
    @weapon_sprites.values.each do |sprite|
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  def update_tile_layer
    @tile_layer.ox = $game_map.display_x * 32
    @tile_layer.oy = $game_map.display_y * 32
  end
  #--------------------------------------------------------------------------
  # * Update Tilemap
  #--------------------------------------------------------------------------
  def update_tilemap(main = true)
    @tilemap.map_data = $game_map.data
    @tilemap.ox = $game_map.display_x * 32
    @tilemap.oy = $game_map.display_y * 32
    @tilemap.update if main
  end
  #--------------------------------------------------------------------------
  def relocate_units
    update_tilemap
    @character_sprites.each do |sprite|
      sprite.relocate
    end
    @projectiles.each do |sprite|
      sprite.relocate
    end
    @weapon_sprites.each do |key, sprite|
      sprite.relocate
    end
  end
  #--------------------------------------------------------------------------
  # * Attach sprite a unit circle
  #--------------------------------------------------------------------------
  def register_battle_unit(battler)
    if @unit_table[battler.hashid]
      debug_print "Battler has already registered: #{battler}"
      return
    end
    sprite = Unit_Circle.new(@viewport1, battler)
    @weapon_sprites[battler.battler.hashid] = Sprite_Weapon.new(@viewport1, battler)
    @unitcir_sprites << sprite
    @unit_table[battler.hashid] = @unitcir_sprites.size - 1
    debug_print "Battler registered #{battler}"
  end
  #--------------------------------------------------------------------------
  # * Remove unit circle
  #--------------------------------------------------------------------------
  def resign_battle_unit(battler)
    loc = @unit_table[battler.hashid]
    return if loc.nil?
    sprite  = @unitcir_sprites.delete_at(loc)
    wsprite = @weapon_sprites[battler.hashid]
    dispose_sprite(sprite)
    dispose_sprite(wsprite)
    @unit_table.delete(battler.hashid)
    @weapon_sprites.delete(battler.hashid)
  end
  #--------------------------------------------------------------------------
  # * Free all unit sprites
  #--------------------------------------------------------------------------
  def dispose_units
    @unitcir_sprites.each do |sprite|
      sprite.dispose unless !sprite || sprite.disposed?
    end
    @unitcir_sprites.clear
  end
  #--------------------------------------------------------------------------
  # * Push new projectile sprite
  #--------------------------------------------------------------------------
  def setup_projectile(obj) # final method
    @projectiles.push(obj)
  end
  #--------------------------------------------------------------------------
  # * Setup popup text
  #--------------------------------------------------------------------------
  def setup_popinfo(text, position, color, icon_id)
    @popups.push( Game_PopInfo.new(text, position, color, icon_id) )
  end
  #--------------------------------------------------------------------------
  # * Display unit circles
  #--------------------------------------------------------------------------
  def show_units
    @unitcir_sprites.each do |sprite|
      sprite.show if BattleManager.valid_battler?(sprite.character)
    end
    @tactic_cursor.show if @tactic_cursor
  end
  #--------------------------------------------------------------------------
  # * Set up weapon graphic
  #--------------------------------------------------------------------------
  def setup_weapon_use(action) # final method
    @weapon_sprites[action.user.hashid].setup_action(action)
  end
  #--------------------------------------------------------------------------
  # * Hide unit circles
  #--------------------------------------------------------------------------
  def hide_units
    @unitcir_sprites.each do |sprite|
      sprite.hide
    end
    @tactic_cursor.hide if @tactic_cursor
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
    @projectiles = $game_map.get_cached_projectile.dup
    @projectiles.each do |proj|
      proj.restore
    end
    $game_map.clear_projectiles
  end
  #--------------------------------------------------------------------------
  def dispose_temp_sprites
    $game_map.store_projectile(@projectiles)
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
    @character_sprites.clear
    $game_temp.effectus_sprites.each_value { |sprite| sprite.dispose }
    $game_temp.effectus_sprites.clear
  end
  #--------------------------------------------------------------------------
  def dispose_huds
    $game_party.skillbar.dispose_layout
    @hud_sprite.each {|sprite| sprite.dispose if sprite && !sprite.disposed?}
    @hud_sprite.clear
  end
  #--------------------------------------------------------------------------
  def dispose_weapons
    @weapon_sprites.values.each do |sprite|
      sprite.dispose
    end
    @weapon_sprites.clear
  end
  #--------------------------------------------------------------------------
  def dispose_sprite(sprite)
    return if sprite.nil?
    sprite.character.dispose_sprites if sprite.is_a?(Sprite_Character)
    sprite.dispose
  end
  #--------------------------------------------------------------------------
  def dispose_event(event)
    return unless event
    sprite = @character_sprites.find {|sp| sp.character == event}
    return unless sprite
    dispose_sprite(sprite)
    @character_sprites.delete(sprite)
    $game_temp.effectus_sprites[event.id].dispose if $game_temp.effectus_sprites[event.id]
    $game_temp.effectus_sprites.delete(event.id)
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  alias dispose_spmap_opt dispose
  def dispose
    dispose_spmap_opt
    dispose_units
    dispose_temp_sprites
    dispose_huds
    dispose_weapons
    dispose_drops
    dispose_sprite(@player_target_sprite)
    dispose_sprite(@tile_layer)
    dispose_sprite(@tactic_cursor)
  end
  #--------------------------------------------------------------------------
  def event_usable?(character)
    return true unless character.is_a?(Game_Event)
    return character.character_name || character.terminated?
  end
  #--------------------------------------------------------------------------
  def refresh
    @hud_sprite.each {|sprite| sprite.refresh(true)}
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
    if @viewport1.tone != $game_map.screen.tone 
      @viewport1.tone.set($game_map.screen.tone)
    end
    @viewport1.ox = $game_map.screen.shake
    if @viewport2.color != $game_map.screen.flash_color
      @viewport2.color.set($game_map.screen.flash_color)
    end
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
  #--------------------------------------------------------------------------
  # * Deploy item drop sprite
  #--------------------------------------------------------------------------
  def register_item_drop(instance, x, y)
    sprite = Sprite_Icon.new(instance, @viewport1, PONY::IconID[:loot_drop], x - 0.5, y - 0.5)
    @drop_sprites << sprite
    return sprite
  end
  #--------------------------------------------------------------------------
  def dispose_drops
    @drop_sprites.each do |sprite|
      sprite.dispose unless sprite.disposed?
    end
  end
  #--------------------------------------------------------------------------
  def create_override_sprite(battler)
    @override = Sprite_Character.new(nil, battler)
    @override.z = 400
  end
  #--------------------------------------------------------------------------
  def dispose_override_sprite(battler)
    return if @override.nil? || @override.disposed?
    @override.dispose
    @override = nil
  end
  #--------------------------------------------------------------------------
  def draw_tile_picture(x, y, filename)
    bitmap = Cache.tilemap(filename)
    rect   = Rect.new(0, 0, bitmap.width, bitmap.height)
    @tile_layer.bitmap.blt(x * TILESIZE, y * TILESIZE, bitmap, rect)
  end
  #--------------------------------------------------------------------------
  def clear_tile_picture
    @tile_layer.bitmap.clear
  end
  #--------------------------------------------------------------------------
end
