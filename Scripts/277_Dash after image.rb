=begin
#==============================================================================
 * Character Afterimages - v1.1
  Author: Quack
  Date: 20/11/2012
#==============================================================================
What it does:
Allows you to add afterimage effects to player and events.

Call Script command set_afterimage(id, has_image, speed = 0) allows you to add
or remove afterimage from a character.
Explanation of the commands parameters:
id: id of a character. -1=player, 0=this event, above zero=event with this id
has_image: if true, adds afterimage to character, else removes it
speed: the lowest movement speed at which the characters afterimage becomes visible.

Event notetags:
<afterimage> - Adds afterimage to this event
<afterimage_speed: X> . The lowest movement speed at which the afterimage becomes 
visible (0 by default, ergo always)

If you want the players afterimage to only be visible while dashing, just use
this in a Call Script command:
$game_player.image_only_on_dash(true)

Instructions/Install notes:
Just paste under Materials like you would most scripts.

Terms of Use:
Use it however you wish, but do give credit if you do.

Credits:
Victor for the Game_Event.note from his basic module for saving me time.

Bugs:
None I've found so far.

History:
20/11/2012 - Added features, changed name of script to Character Afterimages
18/11/2012 - First release
=end

#==============================================================================
# * Settings Start
#==============================================================================
module QUACK
  module AFTERIMAGE
    DISABLE_SWITCH = 3 #if this switch is set to true no afterimages will be visible.
    # Afterimage visual settings:
    START_OPACITY = 240 #the amount of opacity an image starts with
    OPACITY_STEP = 6 #the amount of opacity removed from an image each frame
    IMAGE_SPAWN_INTERVAL = 4 #how often in frames an afterimage is spawn
  end
end
#==============================================================================
# * Settings End
#==============================================================================
class Spriteset_Map
  alias afterimg_init initialize
  def initialize
    @image_sprites = []
    @count = 0
    afterimg_init
  end

  alias afterimg_update update
  def update
    afterimg_update
    update_character_images
  end

  def update_character_images
    if !@image_sprites.nil?
      @image_sprites.each {|s| s.update }
    end 

    if !@image_sprites.nil?
      if @image_sprites.size > 0
        i = @image_sprites.size
        @image_sprites.size.times {
          i -= 1
          if @image_sprites[i].opacity <= 0
              @image_sprites[i].dispose
              @image_sprites.delete_at(i)
          end
        }
      end
    end

    if !$game_switches[QUACK::AFTERIMAGE::DISABLE_SWITCH]
      @count += 1
      if @count >= QUACK::AFTERIMAGE::IMAGE_SPAWN_INTERVAL
        @count = 0
        for i in $game_map.events.keys
          create_image($game_map.events[i]) if $game_map.events[i].has_afterimage?
        end

        if $game_player.has_afterimage?
          if $game_player.afterimage_only_on_dash?
            create_image($game_player) if $game_player.dash?
          else
            create_image($game_player)
          end
        end
      end
    end
  end

  def create_image(char)
    @image_sprites << Sprite_Character_Afterimage.new(@viewport1, char)
  end

  alias afterimg_dispose dispose
  def dispose
    afterimg_dispose
    dispose_image_sprites
  end

  def dispose_image_sprites
    @image_sprites.each {|s| s.dispose }
    @image_sprites.clear
  end
end

class Sprite_Character_Afterimage < Sprite_Character
  def initialize(viewport, character = nil)
    @opacityx = QUACK::AFTERIMAGE::START_OPACITY
    @jump_height = $game_player.jump_height
    @xx = character.real_x
    @yy = character.real_y
    super(viewport, character)
    @character = character
    self.opacity = @opacityx
    self.x = $game_map.adjust_x(@xx) * 32 + 16
    self.y = $game_map.adjust_y(@yy) * 32 + 32 - 4 - @jump_height
    self.z = @character.screen_z# - 1
    self.blend_type = 0
    @visible = true
    update
    @u = true
  end

  def no_opacity?
    return @opacityx < QUACK::AFTERIMAGE::OPACITY_STEP
  end

  def update
    super
    if @opacityx >= QUACK::AFTERIMAGE::OPACITY_STEP
      @opacityx -= QUACK::AFTERIMAGE::OPACITY_STEP
      self.opacity = @opacityx
      self.x = $game_map.adjust_x(@xx) * 32 + 16
      self.y = $game_map.adjust_y(@yy) * 32 + 32 - 4 - @jump_height
    end
  end

  def update_balloon; end
  def setup_new_effect; end
  def update_position; end
  def update_other; end

  def update_bitmap
    if graphic_changed? && @u
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_index = @character.character_index
      if @tile_id > 0
        set_tile_bitmap
      else
        set_character_bitmap
      end
    end
  end

  def update_src_rect
    if @tile_id == 0 && @u
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
      @u = false
    end
  end
end

class Game_Character < Game_CharacterBase
  alias afterimg_game_character_init initialize
  def initialize
    afterimg_game_character_init
    @afterimage = false
    @afterimage_speed = 0
  end

  def has_afterimage?; @afterimage && @afterimage_speed <= real_move_speed; end
  def set_afterimage(val); @afterimage = val; end
  def set_afterimage_speed(val); @afterimage_speed = val; end
end

class Game_Event < Game_Character
if !$imported[:ve_basic_module]
  def note
    return ""     if !@page || !@page.list || @page.list.size <= 0
    return @notes if @notes && @page.list == @note_page
    @note_page = @page.list.dup
    comment_list = []
    @page.list.each do |item|
      next unless item && (item.code == 108 || item.code == 408)
      comment_list.push(item.parameters[0])
    end
    @notes = comment_list.join("\r\n")
    @notes
  end 
end # if !$imported[:ve_basic_module]

  alias afterimg_setup_page_settings setup_page_settings
  def setup_page_settings
    afterimg_setup_page_settings
    @afterimage = note =~ /<AFTERIMAGE>/i ? true : @afterimage
    @afterimage_speed = note =~ /<AFTERIMAGE_SPEED: (.*)>/i ? $1.to_i : @afterimage_speed
  end
end

class Game_Player
  alias afterimg_game_player_init initialize
  def initialize
    @afterimage_on_dash = false
    afterimg_game_player_init
  end

  def afterimage_only_on_dash?
    @afterimage_on_dash
  end

  def image_only_on_dash(val)
    @afterimage_on_dash = val
  end
end

class Game_Interpreter
  def set_afterimage(id, has_image, speed = 0)
    c = get_character(id)
    c.set_afterimage(has_image)
    c.set_afterimage_speed(speed)
  end
end