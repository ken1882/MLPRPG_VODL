#==============================================================================
# ** Sprite_Animation
#------------------------------------------------------------------------------
#  Sprite multi-animation display
#==============================================================================
class Sprite_Animation < Sprite_Base
  #--------------------------------------------------------------------------
  attr_accessor :character
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(viewport = nil, character = nil)
    super(viewport)
    @character = character
  end
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    update_position
    super
  end
  #--------------------------------------------------------------------------
  # * Sync character position
  #--------------------------------------------------------------------------
  def update_position
    return unless @character
    return unless SceneManager.scene_is?(Scene_Map)
    move_animation(@character.screen_x - x, @character.screen_y - y)
    self.x = @character.screen_x
    self.y = @character.screen_y
    self.z = @character.screen_z
  end
  #--------------------------------------------------------------------------
  # * Move Animation
  #--------------------------------------------------------------------------
  def move_animation(dx, dy)
    return if !@animation || @animation.position == 3
    @ani_ox += dx
    @ani_oy += dy
    @ani_sprites.each do |sprite|
      sprite.x += dx
      sprite.y += dy
    end
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    end_animation
    super
  end
end
