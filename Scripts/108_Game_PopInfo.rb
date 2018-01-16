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
  def initialize(text, pos, color, icon_id)
    @x, @y = pos.x, [pos.y - 32, 0].max
    @info  = text
    @icon_id = icon_id
    @sprite = Sprite_Base.new(SceneManager.viewport2)
    @time = 60
    @color = color
    create_bitmap
  end
  #--------------------------------------------------------------------------
  def text_width
    return 4 * @info.size
  end
  #--------------------------------------------------------------------------
  # * Create bitmap for textsa
  #--------------------------------------------------------------------------
  def create_bitmap
    @sprite.x, @sprite.y = @x - text_width + 4, @y
    sw  = Font.default_size * @info.size / 2
    sw += 25 if @icon_id > 0
    line_height = 24
    @sprite.bitmap = Bitmap.new(sw, line_height)
    if @icon_id > 0
      rect = Rect.new(@icon_id % 16 * 24, @icon_id / 16 * 24, 24, 24)
      @sprite.bitmap.blt(0, 0, Cache.iconset, rect)
    end
    @sprite.bitmap.font.color.set(@color)
    @sprite.bitmap.draw_text(@icon_id > 0 ? 25 : 0, 0, sw, line_height, @info)
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
