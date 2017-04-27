#==============================================================================
module Graphics
  #-----------------------------------------------------------------------------
  # * Alias Method: Transition
  #-----------------------------------------------------------------------------
  class << self; alias transition_dnd transition; end
  def self.transition(duration = 10, filename = "", vague = 40)
    puts SPLIT_LINE
    puts "[Debug]: Map Transition"
    transition_dnd(duration, filename, vague)
    puts "[Debug]: Map Transition Successful"
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
  alias init_dnd initialize
  def initialize(*args)
    init_dnd(*args)
    #Cache.link_bitmap(self)
  end
  #-----------------------------------------------------------------------------
  alias dispose_cachelink dispose
  def dispose
    dispose_cachelink
    #Cache.destroy_bitmap(self)
  end
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
end
#==============================================================================
class Sprite
  #-----------------------------------------------------------------------------
  alias init_spcache initialize
  def initialize(*args)
    init_spcache(*args)
    #Cache.link_bitmap(self)
  end
  #-----------------------------------------------------------------------------
  alias dispose_spcachelink dispose
  def dispose
    dispose_spcachelink
    #Cache.destroy_bitmap(self)
  end
  
end
