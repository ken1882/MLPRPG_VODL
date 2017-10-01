#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  This sprite is used to display characters. It observes an instance of the
# Game_Character class and automatically changes sprite state.
#==============================================================================
class Sprite_Character < Sprite_Base
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
    return false if @old_pos == hash_pos
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
    return @character.screen_x * 1000 + @character.screen_y + @character.screen_z
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Rectangle
  #--------------------------------------------------------------------------
  def update_src_rect
    if @tile_id == 0
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
      @old_pattern = pattern
    end
  end
  #----------------------------------------------------------------------------
  # * Overwrite update position.
  # To limit screen_x and screen_y to be called many times
  # 
  # moved from Thro anti-lag
  #----------------------------------------------------------------------------
  def update_position
    move_animation(@sx - x, @sy - y)
    self.x = @sx
    self.y = @sy
    self.z = @character.screen_z
  end
  #--------------------------------------------------------------------------
  # * Update Position
  #--------------------------------------------------------------------------
  alias update_spchar_position update_position
  def update_position
    @old_pos = hash_pos
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
end
