#==============================================================================
# ** Game_InteractiveButton
#------------------------------------------------------------------------------
#  Do what it namely does
#==============================================================================
class Game_InteractiveButton
  #------------------------------------------------------------------------------
  attr_reader :symbol, :image
  attr_reader :x, :y
  attr_reader :width, :height
  attr_reader :handler
  attr_reader :active, :group
  attr_reader :sprite
  #------------------------------------------------------------------------------
  def initialize(*args)
    if args.size == 1 # hash initializer
      inf = args[0]
      @symbol   = inf.symbol
      @image    = inf.image
      @x, @y    = (inf.x || 0), (inf.y || 0)
      @width    = inf.width  || 0
      @height   = inf.height || 0
      @handler  = inf.handler
      @active   = inf.active || 0
      @group    = inf.group
    else
      @symbol   = args[0]
      @image    = args[1]
      @x, @y    = (args[2] || 0), (args[3] || 0)
      @width    = args[4] || 0
      @height   = args[5] || 0
      @handler  = args[6]
      @active   = args[7] || false
      @group    = args[8]
    end
  end
  #------------------------------------------------------------------------------
  def active?
    @active
  end
  #------------------------------------------------------------------------------
  def activate
    @active = true
    self
  end
  #------------------------------------------------------------------------------
  def deactivate
    @active = false
    self
  end
  #------------------------------------------------------------------------------
  def create_sprite(viewport = nil)
    @sprite = ::Sprite.new(viewport)
    if image
      @sprite.bitmap = Cache.UI(image)
      @width  = @sprite.bitmap.width
      @height = @sprite.bitmap.height
    else
      @sprite.bitmap = Bitmap.new([@width, 1].max, [@height, 1].max)
    end
    @sprite
  end
  #------------------------------------------------------------------------------
  def dispose
    return unless sprite_valid?(@sprite)
    @sprite.dispose
    @sprite = nil
  end
  #------------------------------------------------------------------------------
end
