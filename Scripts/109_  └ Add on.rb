#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Create Character Sprite
  #--------------------------------------------------------------------------
  def create_characters
    @character_sprites = []
    $game_map.events.values.each do |event|
      @character_sprites.push(Sprite_Character.new(@viewport1, event))
    end
    $game_player.followers.reverse_each do |follower|
      @character_sprites.push(Sprite_Character.new(@viewport1, follower))
    end
    @character_sprites.push(Sprite_Character.new(@viewport1, $game_player))
    @map_id = $game_map.map_id
  end
  #--------------------------------------------------------------------------
  def find_sprite(name, store = false)
    instance_variables.each do |varname|
      
      return instance_variable_get(varname) if varname == name
    end
  end
  
end
