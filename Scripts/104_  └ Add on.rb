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
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     character : Game_Character
  #--------------------------------------------------------------------------
  alias init_spchar_opt initialize
  def initialize(viewport, character = nil)
    init_spchar_opt(viewport, character)
    @old_pos = 0
    @old_pattern = 1
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_spchar_opt update
  def update
    update_spchar_opt if update_needed?
  end
  #--------------------------------------------------------------------------
  # * Check if sprite should update
  #--------------------------------------------------------------------------
  def update_needed?
    return true  if graphic_changed? || animation? rescue false
    return false if !@character
    return true  if @character.pattern != @old_pattern
    return false if @old_pos == hash_pos
    return true
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
  #--------------------------------------------------------------------------
  # * Update Position
  #--------------------------------------------------------------------------
  alias update_spchar_position update_position
  def update_position
    @old_pos = hash_pos
    update_spchar_position
  end
end
