class RPG::BaseItem
  
  def has_note_tag?(what)
    !get_note_tags(what).empty?
  end
  
  def get_note_tags(what)
    timings = note.split("\r\n").map{|x| x.split(":")}.keep_if{|x| x[0] == what};
    # this is really inefficient, by the way; optimize it later
    return timings.map{|x| x[1]}
  end
  
  def get_first_note_tag(what)
    temp = get_note_tags(what)
    return nil if !temp
    temp.first
  end
end
class RPG::Actor < RPG::BaseItem
end
class RPG::Class < RPG::BaseItem
end
# For whatever it's worth, you can do whatever the heck you like with these
#  functions.
class Bitmap
  # Implementation of Bresenham's algorithm with dirty hacks
  def draw_line(x1,y1,x2,y2,col)
    #puts "#{x1},#{y1}; #{x2},#{y2}"
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
  
  def draw_vertical_line(x,y1,y2,col)
    for y in y1..y2
      self.set_pixel(x,y,col);
    end
  end
  
  ############################################################################
  
  def swap_font(what_font)
    # I am highly suspicious of obj.dup, and need to check memory usage some time
    temp_font = self.font.dup;    
    self.font = what_font;    
    yield;
    self.font = temp_font;
  end
  
  ############################################################################
  
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
end
