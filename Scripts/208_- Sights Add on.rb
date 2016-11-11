#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================
class Game_CharacterBase
  #----------------------------------------------------------------------------
  # *) Determind sight angle
  #----------------------------------------------------------------------------
  def determind_sight_angles(angle)
    case direction
    when 2; value = [270 + angle, 270 - angle]
    when 4; value = [180 + angle, 180 - angle]
    when 6; value = [  0 + angle,   0 - angle]
    when 8; value = [ 90 + angle,  90 - angle]
    end
    value[0] = (value[0] + 360) % 360
    value[1] = (value[1] + 360) % 360
    return value
  end
  #----------------------------------------------------------------------------
  # *) sight
  #----------------------------------------------------------------------------
  def in_sight?(target, size)
    return false if size.nil?
    
    angle = determind_sight_angles(60)
    result = Math.in_arc?(target.x, target.y, @x, @y, angle[0], angle[1], size)
    result &= path_clear?(@x, @y, target.x, target.y)
    
    return result
  end
  #----------------------------------------------------------------------------
  # *) check if straight line path is able to see
  #----------------------------------------------------------------------------
  def path_clear?(x1, y1, x2, y2)
    dx = x2 - x1;
    if(dx == 0)
      return straight_path_clear?(x1,y1,y2)
    elsif(dx < 0)
      return path_clear?(x2,y2,x1,y1);
    end
    
    dy = y2 - y1;
    sgny = (dy >= 0 ? 1 : -1);
    delta = (dy.to_f / dx.to_f).abs;
    error = 0.0;
    
    y = y1
    x = x1
    while x <= x2
      result = false
      (1..4).each do |i|
        result |= pixel_passable?((x + 0.5).to_i, (y + 0.5).to_i, i*2 );
      end
      #p sprintf("%6d,%6d",x,y) if self.is_a?(Game_Follower) && self.actor != nil && !result
      return false if !result
      
      error += (delta / 4)
      while error >= 0.5
        result = false
        (1..4).each do |i|
          result |= pixel_passable?((x + 0.5).to_i, (y + 0.5).to_i, i*2 );
        end
        #p sprintf("%6d,%6d",x,y) if self.is_a?(Game_Follower) && self.actor != nil && !result
        return false if !result        
        y = y + sgny;
        error -= 1.0;
      end # while
      
      x += 0.25
      #puts "#{x} #{y}" if self.is_a?(Game_Follower) && self.actor != nil
    end # while x
    
    return true
  end
  #----------------------------------------------------------------------------
  # *) straight path clear?
  #----------------------------------------------------------------------------
  def straight_path_clear?(x1, y1, y2)
    y = y1
    while y <= y2
      result = false
      (1..4).each do |i|
        result |= pixel_passable?(x1 , y , i*2 )
      end
      return false if !result    
      y += 0.25
    end # for y
    return true
  end
  
  #-------------------
end