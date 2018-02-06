#==============================================================================
module Graphics
  #-----------------------------------------------------------------------------
  # * Alias Method: Transition
  #-----------------------------------------------------------------------------
  class << self; alias transition_dnd transition; end
  def self.transition(duration = 10, filename = "", vague = 40)
    puts SPLIT_LINE
    debug_print "Graphics Transition"
    @transitioning = true
    transition_dnd(duration, filename, vague)
    @transitioning = false
    debug_print "Transition Successful"
  end
  #-----------------------------------------------------------------------------
  def self.transitioning?
    return @transitioning
  end
  #-----------------------------------------------------------------------------
  def self.center_width(cx)
    return [(width  - cx) / 2, 0].max
  end
  #-----------------------------------------------------------------------------
  def self.center_height(cy)
    return [(height - cy) / 2, 0].max
  end
  #-----------------------------------------------------------------------------
end
#==============================================================================
class Bitmap
  #-----------------------------------------------------------------------------
  # Implementation of Bresenham's algorithm with dirty hacks
  def draw_line(x1,y1,x2,y2,col)
    dx = x2 - x1;
    if(dx == 0)
      # Algo divides by zero otherwise; dirty hack for now
      return draw_vertical_line(x1,y1,y2,col)
    elsif(dx < 0)
      # Algo doesn't support drawing right to left right now; dirty hack
      return draw_line(x2,y2,x1,y1,col);
    end
    dy = y2 - y1;
    sgny = (dy >= 0 ? 1 : -1);
    delta = (dy.to_f / dx.to_f).abs;
    error = 0.0;
    
    y = y1;
    for x in x1.to_i..x2.to_i
      self.set_pixel(x,y,col);
      error += delta;
      while error >= 0.5
        self.set_pixel(x,y,col);
        y = y + sgny;
        error -= 1.0;
      end
    end
  end
  #-----------------------------------------------------------------------------
  def draw_vertical_line(x,y1,y2,col)
    for y in y1..y2
      self.set_pixel(x,y,col);
    end
  end
  #-----------------------------------------------------------------------------
  def swap_font(what_font)
    # I am highly suspicious of obj.dup, and need to check memory usage some time
    temp_font = self.font.dup;    
    self.font = what_font;    
    yield;
    self.font = temp_font;
  end
  #-----------------------------------------------------------------------------
  def draw_paragraph(x,y,w,text)
    cx = x;
    cy = y;
    
    paras = text.split(/\r?\n/); # Split along paragraphs, firstly.
    paras.map!{|x| x.split(" ")}
  
    row_height = text_size("George").height; # probably a better way to do this
    space_width = text_size(" ").width;
    paras.each do |paragraph|
      paragraph.each do |word|
        word = word.strip
        word_size = text_size(word);
        if(cx + word_size.width >= w)
          cx = 0;
          cy += row_height;
        end
        #fill_rect(cx,cy,size.width,size.height,Color.new(rand(255),rand(255),rand(255), 80));
        draw_text(cx,cy,1000,word_size.height,"#{word}");
        cx += word_size.width + space_width;
      end
      cy += row_height;
      cx = 0;
    end
    
    return cy;
  end
  #-----------------------------------------------------------------------------
  def draw_circle(cx, cy, rad, color, thick = 1, start_angle = 0, end_angle = 360)
    rad -= 1
    error   = -rad
    x, y    = rad, 0
    
    while (x >= y)
      if (end_angle >= 270 - (61 * y / rad))
        self.fill_rect(cx + x, cy + y, thick, thick, color)
      end
      
      if (x != 0 && end_angle > 90 + (61 * y / rad))
        self.fill_rect(cx - x, cy + y, thick, thick, color)
      end
      
      if (y != 0 && end_angle > 270 + (61 * y / rad))
        self.fill_rect(cx + x, cy - y, thick, thick, color)
      end
      
      if (x != 0 && y != 0 && end_angle >= 90 - (61 * y / rad))
        self.fill_rect(cx - x, cy - y, thick, thick, color)
      end
    
      if (x != y)
        self.fill_rect(cx + y, cy + x, thick, thick, color) if (end_angle > 180 + (61 * y / rad))
        self.fill_rect(cx - y, cy + x, thick, thick, color) if (y != 0 && end_angle >= 180 - (61 * y / rad))
        self.fill_rect(cx + y, cy - x, thick, thick, color) if (x != 0 && end_angle >= 360 - (61 * y / rad))
        self.fill_rect(cx - y, cy - x, thick, thick, color) if (y != 0 && x != 0 && end_angle > (61 * y / rad))
      end
      
      error += (y << 1) | 1
      y	 += 1
      if (error >= 0)
        error -= (x << 1) + 1
        x	 -= 1
      end
    end # while
  end # def draw_circle
  #-----------------------------------------------------------------------------
  def marshal_dump
    nil
  end
  #-----------------------------------------------------------------------------
  def marshal_load
    nil
  end
  #--------------------------------------------------------------------------
  def deactivate
    self.clear
    super
  end
  #--------------------------------------------------------------------------
end
#==============================================================================
class Sprite
  #--------------------------------------------------------------------------
  # * Show
  #--------------------------------------------------------------------------
  def show
    self.visible = true
    self
  end
  #--------------------------------------------------------------------------
  # * Hide
  #--------------------------------------------------------------------------
  def hide
    self.visible = false
    self
  end
  #--------------------------------------------------------------------------
  def deactivate
    self.bitmap.clear
    super
  end
  #-----------------------------------------------------------------------------
  # * Query visibility
  #-----------------------------------------------------------------------------
  def visible?
    self.visible
  end
  #-----------------------------------------------------------------------------
  # * Change bitmap to an icon
  #-----------------------------------------------------------------------------
  def draw_icon(icon_index)
    self.bitmap = Bitmap.new(24, 24) if !self.bitmap
    crect = Rect.new(0,0,24,24)
    bitmap.clear_rect(crect)
    rect  = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.bitmap.blt(0, 0, Cache.iconset, rect)
  end
  #-----------------------------------------------------------------------------
end
#==============================================================================
Object.send(:remove_const, :Plane)
class Plane < Sprite
  #--------------------------------------------------------------------------
  # * Set Bitmap
  #--------------------------------------------------------------------------
  def bitmap=(new_bitmap)
    return if new_bitmap == @real_bitmap && viewport == @last_viewport
    if @real_bitmap
      @real_bitmap  = nil
      self.bitmap.dispose
    end
    return super(new_bitmap) unless new_bitmap
    vw = viewport ? viewport.rect.width  : Graphics.width
    vh = viewport ? viewport.rect.height : Graphics.height
    @real_width  = new_bitmap.width
    @real_height = new_bitmap.height
    super(Bitmap.new(vw + @real_width, vh + @real_height))
    horizontal = vw / @real_width  + 1 + (vw % @real_width  > 0 ? 1 : 0)
    vertical   = vh / @real_height + 1 + (vh % @real_height > 0 ? 1 : 0)
    horizontal.times do |bx|
      vertical.times do |by|
        bitmap.blt(
          bx * @real_width,
          by * @real_height, new_bitmap,
          new_bitmap.rect
        )
      end
    end
    @last_viewport = viewport
    @real_bitmap   = new_bitmap
  end
  #--------------------------------------------------------------------------
  # * Set Offset X
  #--------------------------------------------------------------------------
  def ox=(value)
    super(@real_bitmap ? value % @real_width  : value)
  end
  #--------------------------------------------------------------------------
  # * Set Offset Y
  #--------------------------------------------------------------------------
  def oy=(value)
    super(@real_bitmap ? value % @real_height : value)
  end
  #--------------------------------------------------------------------------
  # * Bitmap
  #--------------------------------------------------------------------------
  def bitmap
    @real_bitmap ? @real_bitmap : super
  end
  #--------------------------------------------------------------------------
  # * Set Viewport
  #--------------------------------------------------------------------------
  def viewport=(new_viewport)
    if new_viewport != viewport
      super(new_viewport)
      self.bitmap = @real_bitmap if @real_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    if @real_bitmap
      @real_bitmap  = nil
      self.bitmap.dispose
    end
    super
  end
  #-----------------------------------------------------------------------------
end
