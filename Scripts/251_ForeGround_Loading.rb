#==============================================================================
# ** ForeGround_Loading
#------------------------------------------------------------------------------
#   Display loading status 
#==============================================================================
class ForeGround_Loading
  attr_accessor :opacity
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(info = nil, animate_sprite = true, configs = {})
    @opacity  = 0
    @image    = info ? info.image : nil
    @title    = info ? info.name  : nil
    @subtitle = configs[:subtitle]
    create_viewport
    create_background
    create_loading_sprite
    create_text_sprite
    create_title_sprite
    create_subtitle_sprite
    @enable_sprite = animate_sprite
    @timer  = 0
    @goal   = 0
    @loaded = 0
    @phase  = ''
    @need_loaded = 0
    @src_rect = Rect.new(0, 0, 200, 200)
    @index = 0
  end
  #--------------------------------------------------------------------------
  # * Get Bitmap Width
  #--------------------------------------------------------------------------
  def bitmap_width
    return 200
  end
  #--------------------------------------------------------------------------
  # * Get Bitmap Height
  #--------------------------------------------------------------------------
  def bitmap_height
    return 200
  end
  #--------------------------------------------------------------------------
  # * Sprite change frequency
  #--------------------------------------------------------------------------
  def frequency
    return 4
  end
  #--------------------------------------------------------------------------
  def text_width(text, text_width = Font.default_size)
    return 1 if !text
    return [[(text.size * text_width / 2), 1].max, Graphics.width - 24].min
  end
  #--------------------------------------------------------------------------
  # *) Opacity
  #--------------------------------------------------------------------------
  def opacity=(value)
    @opacity = value
    @background.opacity   = value
    @sprite.opacity       = value if @sprite
    @text_sprite.opacity  = value
    @title_sprite.opacity = value if @title_sprite
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background = Plane.new
    if @image
      @background.bitmap = Cache.background(@image)
    else
      @background.bitmap = Cache.background("blank_black")
    end
    @background.z = 10 ** 8
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewport
    @viewport = Viewport.new
    @viewport.z = 10 ** 8 + 1
  end
  #--------------------------------------------------------------------------
  # * Create Loading Sprites
  #--------------------------------------------------------------------------
  def create_loading_sprite
    @sprite = Sprite.new(@viewport)
    @sprite.bitmap = get_load_sprite
    @sprite.x = Graphics.center_width(bitmap_width)
    @sprite.y = Graphics.center_height(bitmap_height * 1.3)
    @sprite.visible = false
  end
  #--------------------------------------------------------------------------
  # * Create Text Sprites
  #--------------------------------------------------------------------------
  def create_text_sprite
    bw = bitmap_width * 1.5
    @text_sprite = Sprite.new(@viewport)
    @text_sprite.bitmap = Bitmap.new(bw, Font.default_size)
    @text_sprite.x = Graphics.center_width(bw)
    @text_sprite.y = @sprite.y + bitmap_height
    @text_rect = Rect.new( 0, 0, bw, Font.default_size)
  end
  #--------------------------------------------------------------------------
  # * Create Title Text Sprites
  #--------------------------------------------------------------------------
  def create_title_sprite
    return unless @title
    fs = 48 # Font size for title
    tw = text_width(@title, fs)
    @title_sprite = Sprite.new(@viewport)
    @title_sprite.bitmap = Bitmap.new(tw, fs)
    @title_sprite.x = Graphics.center_width(tw)
    @title_sprite.y = Graphics.height / 10
    @title_sprite.bitmap.font.size = fs
    rect = Rect.new(0, 0, tw, fs)
    @title_sprite.bitmap.draw_text(rect, @title, 1)
  end
  #--------------------------------------------------------------------------
  def create_subtitle_sprite
    return unless @subtitle
    fs = 24
    tw = text_width(@subtitle, fs)
    texts = FileManager.textwrap(@subtitle, tw)
    lines = texts.size
    
    @subtitle_sprite = Sprite.new(@viewport)
    @subtitle_sprite.bitmap = Bitmap.new(tw, fs * lines)
    @subtitle_sprite.x = Graphics.center_width(tw)
    @subtitle_sprite.y = Graphics.height / 6
    @subtitle_sprite.bitmap.font.size = fs
    
    rect = Rect.new(0, 0, tw, fs)
    texts.each do |text|
      @subtitle_sprite.bitmap.draw_text(rect, text, 1)
      rect.y += fs
    end
  end
  #--------------------------------------------------------------------------
  def get_load_sprite
    filename = "$twilight_gallop_left"
    
    return Cache.character(filename)
  end  
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update(loaded = 1)
    return if $game_console.skip_loading?
    @timer  += 1
    @timer   = 0 if @timer == 120
    @loaded += loaded
    update_sprite
    update_text
  end
  #--------------------------------------------------------------------------
  # * Update Sprite
  #--------------------------------------------------------------------------
  def update_sprite
    return unless @sprite
    @sprite.visible = @enable_sprite
    @sprite.update
    @index += 1
    @index  = 0 if @index == 12 * frequency
    sx = (@index / frequency % 3) * bitmap_width
    sy = (@index / frequency / 3) * bitmap_height
    @sprite.src_rect.set(sx, sy, bitmap_width, bitmap_height)
  end
  #--------------------------------------------------------------------------
  # * Update Sprite
  #--------------------------------------------------------------------------
  def update_text
    @text_sprite.bitmap.clear_rect(@text_rect)
    draw_info_text
  end
  #--------------------------------------------------------------------------
  def loading_info
    re = sprintf("%s%s", @phase ? @phase : 'Loading', '.' * (@timer / 30))
    re += sprintf(" (%d)%", [(@loaded * 100 / @need_loaded).to_i, 100].min) if @need_loaded > 0
    re
  end
  #--------------------------------------------------------------------------
  def set_loading_phase(phase, total = 0)
    @phase = phase
    @need_loaded = total
    @loaded = 0
  end
  #--------------------------------------------------------------------------
  # * Draw Texts
  #--------------------------------------------------------------------------
  def draw_info_text
    cy = @sprite.y + bitmap_height + Font.default_size
    @text_sprite.bitmap.draw_text(@text_rect, loading_info, 1)
  end
  #--------------------------------------------------------------------------
  # * Terminate
  #--------------------------------------------------------------------------
  def terminate
    @viewport.dispose
    @background.dispose
    @text_sprite.dispose
    @sprite.dispose          if @sprite
    @title_sprite.dispose    if @title_sprite
    @subtitle_sprite.dispose if @subtitle_sprite
  end
  #--------------------------------------------------------------------------
  # * Loading?
  #--------------------------------------------------------------------------
  def loading?
    return true if @need_loaded == -1
    return @loaded <= @need_loaded + 10
  end
  
end
