#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  This sprite is used to display characters. It observes an instance of the
# Game_Character class and automatically changes sprite state.
#==============================================================================
class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  EFFECTUS_RATE = MakerSystems::Effectus::SPRITE_CHARACTER_FULL_UPDATE_RATE
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :old_pos
  attr_accessor :old_pattern
  attr_accessor :old_direction
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     character : Game_Character
  #--------------------------------------------------------------------------
  alias init_spchar_opt initialize
  def initialize(viewport, character = nil)
    init_spchar_opt(viewport, character)
    @old_pos = 0
    @old_pattern = 1
    @translucent = false
    @deployed = false
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_spchar_opt update
  def update
    sync_characher_zoom
    update_visibility    if @translucent != @character.translucent rescue nil
    return update_object if @character.frozen?
    update_spchar_opt    if update_needed?
  end
  #--------------------------------------------------------------------------
  # * Synchornize zooming with insatnace class
  #--------------------------------------------------------------------------
  def sync_characher_zoom
    return unless @character
    newzoom = POS.new(@character.zoom_x, @character.zoom_y)
    return if @zoomhash && @zoomhash == newzoom
    self.zoom_x = @character.zoom_x
    self.zoom_y = @character.zoom_y
    @zoomhash = newzoom
  end
  #--------------------------------------------------------------------------
  # * Check if sprite should update
  #--------------------------------------------------------------------------
  def update_needed?
    return true  if @character.opacity != self.opacity rescue nil
    return true  if @character.animation_id > 0        rescue nil
    return true  if graphic_changed? || animation?     rescue nil
    return false if !@character
    return true  if @character.pattern != @old_pattern
    return true
  end
  #--------------------------------------------------------------------------
  def update_object
    if !@deployed
      @deployed = true
      update_spchar_opt
    else
      update_position
    end
  end
  #--------------------------------------------------------------------------
  # * Hash position
  #--------------------------------------------------------------------------
  def hash_pos
    return 0 unless @character
    return @character.screen_x * 4000 + @character.screen_y + @character.screen_z
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Rectangle
  #--------------------------------------------------------------------------
  def update_src_rect
    if @tile_id == 0
      return process_large_src_rect if @character_name.include?("%(6)")
      if @character.casting?
        index = @character.casting_index
      else
        index = @character.character_index
      end
      
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
      @old_pattern = pattern
    end
  end
  #----------------------------------------------------------------------------
  def process_large_src_rect
    if @character.moving?
      index = 1 
    elsif @character.casting?
      index = 2
    else
      index = 0
    end
    pattern = @character.pattern < 3 ? @character.pattern : 1
    sx = (index % 4 * 3 + pattern) * @cw
    sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
    self.src_rect.set(sx, sy, @cw, @ch)
    @old_pattern = pattern
  end
  #----------------------------------------------------------------------------
  # * Overwrite update position.
  # To limit screen_x and screen_y to be called many times
  # 
  # moved from Thro anti-lag, merged with effectus
  #----------------------------------------------------------------------------
  def update_position
    sx = (@character.real_x - $game_map.display_x) * 32 + 16
    sy = (@character.real_y - $game_map.display_y) * 32 + 32 -
          @character.shift_y - @character.jump_height
    move_animation(sx - x, sy - y) if @animation && @animation.position != 3
    if sx != @effectus_old_sx
      @effectus_old_sx = sx
      self.x = sx
    end
    if sy != @effectus_old_sy
      @effectus_old_sy = sy
      self.y = sy
    end
    ovz = PONY::SpriteDepth::Table[:override]
    self.z = $game_system.time_stopper == @character ? ovz : @character.screen_z
  end
  #--------------------------------------------------------------------------
  # * Update Position
  #--------------------------------------------------------------------------
  alias update_spchar_position update_position
  def update_position
    update_spchar_position
  end
  #--------------------------------------------------------------------------
  # * Move Animation
  #--------------------------------------------------------------------------
  def move_animation(dx, dy)
    return unless @animation && @animation.position != 3
    @ani_ox += dx
    @ani_oy += dy
    @ani_sprites.each do |sprite|
      sprite.x += dx
      sprite.y += dy
    end
  end # def move_animation
  #--------------------------------------------------------------------------
  def relocate
    @sx = @character.screen_x
    @sy = @character.screen_y
    update_bitmap
    update_src_rect
    update_position
  end
  #--------------------------------------------------------------------------
  # * Vanilla Update.                                                   [NEW]
  #--------------------------------------------------------------------------
  def effectus_vanilla_update
    update_bitmap   if graphic_changed?
    if @tile_id == 0 && (@character.pattern != @effectus_old_pattern ||
        @character.direction != @effectus_old_dir)
      update_src_rect 
    end
    update_position
    update_other
    update_balloon  if @balloon_duration > 0
    setup_new_effect
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Bitmap.                                    [REP]
  #--------------------------------------------------------------------------
  def update_bitmap
    @tile_id = @character.tile_id
    @character_name = @character.character_name
    @character_index = @character.character_index
    @tile_id > 0 ? set_tile_bitmap : set_character_bitmap
    @effectus_old_pattern = nil
  end
  #--------------------------------------------------------------------------
  # * Move Animation.                                                   [REP]
  #--------------------------------------------------------------------------
  def move_animation(dx, dy)
    @ani_ox += dx
    @ani_oy += dy
    @ani_sprites.each do |sprite|
      sprite.x += dx
      sprite.y += dy
    end
  end
  #--------------------------------------------------------------------------
  # * Update Balloon Icon.                                              [REP]
  #--------------------------------------------------------------------------
  def update_balloon
    @balloon_duration -= 1
    if @balloon_duration > 0
      @balloon_sprite.x = x
      @balloon_sprite.y = y - height
      @balloon_sprite.z = z + PONY::SpriteDepth::Table[:ballon]
      sx = balloon_frame_index * 32
      sy = (@balloon_id - 1) * 32
      @balloon_sprite.src_rect.set(sx, sy, 32, 32)
    else
      end_balloon
    end
  end
  #--------------------------------------------------------------------------
end
