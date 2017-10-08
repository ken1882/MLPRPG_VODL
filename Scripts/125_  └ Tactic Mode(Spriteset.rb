#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================
# tag: tactic(Spriteset)
# tag: timeflow(Spriteset)
class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Overwrite: Update Character Sprite
  #--------------------------------------------------------------------------
  def update_characters
    refresh_characters if @map_id != $game_map.map_id
    @character_sprites.each do |sprite|
      sprite.update
      sprite.visible = $game_switches[6]
      if sprite.character && !event_usable?(sprite.character)
        @character_sprites.delete(sprite)
      end
    end
  end
  #-----------------------------------------------------------------------------
  def update_timelapse
    return update_tactic if SceneManager.tactic_enabled?
    return update_timestop if SceneManager.time_stopped?
  end
  #-----------------------------------------------------------------------------
  # * Update when tactic mode
  #-----------------------------------------------------------------------------
  def update_tactic
    update_tilemap
    update_skillbar
    update_tactic_cursor
    update_units
    update_viewports
    update_popups
    update_huds
  end
  #-----------------------------------------------------------------------------
  def update_tactic_cursor
    @tactic_cursor.update
  end
  #-----------------------------------------------------------------------------
  def update_timestop
    update_tilemap
    update_skillbar
    update_units
    update_viewports
    update_huds
    update_characters
    update_projectiles
    update_weapons
    update_popups
    @override.update unless @override.nil? || @override.disposed?
    return if $game_system.time_stopper.map_char.nil?
  end
  #-----------------------------------------------------------------------------
end
