#===============================================================================
# * Game_PopInfo
#-------------------------------------------------------------------------------
#   Popup information text
#===============================================================================
class Game_PopInfo
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :x, :y
  attr_accessor :info
  attr_reader   :sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(text, pos, color, time = 60)
    @x, @y = pos.x, [pos.y - 32, 0].max
    @info = text
    @sprite = Sprite_Base.new(SceneManager.viewport2)
    @time = 30
    @color = color
    create_bitmap
  end
  #--------------------------------------------------------------------------
  # * Create bitmap for textsa
  #--------------------------------------------------------------------------
  def create_bitmap
    @sprite.x, @sprite.y = @x, @y
    sw = Font.default_size * @info.size / 2
    line_height = 24
    @sprite.bitmap = Bitmap.new(sw, line_height)
    @sprite.bitmap.font.color.set(@color)
    @sprite.bitmap.draw_text(0 , 0, sw, line_height, @info)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    return if @time == 0
    @y -= 0.5
    @sprite.y -= 0.5
    @time -= 1
    @sprite.update
    dispose_sprite if @time == 0
  end
  #--------------------------------------------------------------------------
  # * Restore bitmap
  #--------------------------------------------------------------------------
  def restore
    return if @time == 0
    @sprite = Sprite_Base.new(SceneManager.viewport2)
  end
  #--------------------------------------------------------------------------
  # * Sprite disposed?
  #--------------------------------------------------------------------------
  def disposed?
    @sprite.disposed?
  end
  #--------------------------------------------------------------------------
  # * Free Sprite
  #--------------------------------------------------------------------------
  def dispose_sprite
    return unless @sprite
    @sprite.dispose unless @sprite.disposed?
    @sprite = nil
  end
  #---------------------------------------------------------
end
