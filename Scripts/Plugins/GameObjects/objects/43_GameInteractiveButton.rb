#==============================================================================
# ** Game_InteractiveButton
#------------------------------------------------------------------------------
#  Do what it namely does
#==============================================================================
class Game_InteractiveButton
  #------------------------------------------------------------------------------
  TriggerTimer = 4
  Node = Struct.new(:left, :right, :up, :down)
  #------------------------------------------------------------------------------
  attr_reader :symbol, :image
  attr_reader :x, :y, :z
  attr_reader :width, :height
  attr_reader :handler
  attr_reader :active, :group
  attr_reader :sprite
  attr_reader :help
  attr_reader :viewport
  attr_reader :show_text
  attr_reader :hovered, :triggered
  attr_accessor :index, :group_index, :node
  attr_reader :icon_id
  #------------------------------------------------------------------------------
  def initialize(*args)
    @hovered       = false
    @trigger_timer = 0
    @index         = nil
    @group_index   = nil
    @icon_id       = 0
    @node          = Node.new(self, self, self, self)
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
      @help     = inf.help || ''
      @show_text = inf.show_text || false
    else
      @symbol   = args[0]
      @image    = args[1]
      @x, @y    = (args[2] || 0), (args[3] || 0)
      @width    = args[4] || 0
      @height   = args[5] || 0
      @handler  = args[6]
      @active   = args[7] || false
      @group    = args[8]
      @help     = args[9] || ''
      @show_text = args[10] || false
    end
    if @image.is_a?(Symbol) && @image =~ /(?:icon)_(\d+)/i
      @icon_id = $1.to_i
    end
  end
  #------------------------------------------------------------------------------
  def refresh
    return unless @image
    @sprite.bitmap.clear
    draw_bitmap; draw_text;
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
  def unfocus_sprite
    return unless @hovered
    @hovered = false
    @sprite.opacity = active? ? translucent_alpha : translucent_beta
  end
  #------------------------------------------------------------------------------
  def focus_sprite
    return if @hovered
    @hovered = true
    @sprite.opacity = 0xff
  end
  #------------------------------------------------------------------------------
  def call_handler(*args)
    unless @handler
      return PONY::ERRNO.raise(:gib_nil_handler)
    end
    @handler.call(*args)
  end
  #------------------------------------------------------------------------------
  def create_sprite(viewport = nil)
    @sprite = ::Sprite.new(viewport)
    draw_bitmap
    @sprite.opacity = acitve? ? translucent_alpha : translucent_beta
    @sprite
  end
  #------------------------------------------------------------------------------
  def show_text=(enabled)
    @show_text = enabled
    refresh
  end
  #------------------------------------------------------------------------------
  def translucent_alpha
    return 0xc0
  end
  #------------------------------------------------------------------------------
  def translucent_beta
    return 0x60
  end
  #------------------------------------------------------------------------------
  def dispose
    return unless sprite_valid?(@sprite)
    @sprite.dispose
    @sprite = nil
  end
  #------------------------------------------------------------------------------
  def draw_bitmap
    if @icon_id
      draw_icon(@icon_id)
    elsif @image
      @sprite.bitmap = Cache.UI(image)
      @width  = @sprite.bitmap.width
      @height = @sprite.bitmap.height
    else
      @sprite.bitmap = Bitmap.new([@width, 1].max, [@height, 1].max)
    end
  end
  #------------------------------------------------------------------------------
  def draw_text
    return unless @image && @show_text
    rect = Rect.new(0, 0, @sprite.bitmap.text_size(@name).width, line_height)
    rect.y = [@sprite.height - rect.height - 2, 0].max
    @sprite.bitmap.draw_text(rect, @name, 1)
  end
  #------------------------------------------------------------------------------
  def moveto(*args)
    case args.size
    when 1
      pos = args[0]
      @x  = pos.x
      @y  = pox.y
    else
      @x, @y = args[0], args[1]
      @z     = args[2] unless args[2].nil?
    end
    if sprite_valid?
      @sprite.x, @sprite.y = @x, @y
      @sprite.z = @z
    end
  end
  #------------------------------------------------------------------------------
  def viewport=(vp)
    debug_print("Warning: Sprite already has a viewport #{@viewport}") if sprite_valid?(@viewport)
    @viewport = vp
  end
  #------------------------------------------------------------------------------
  def z=(nz)
    @z = nz
    @sprite.z = @z if sprite_valid?
  end
  #------------------------------------------------------------------------------
end
