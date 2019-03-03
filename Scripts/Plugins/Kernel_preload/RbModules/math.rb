#===============================================================================
# Module Math
#===============================================================================
module Math
  #-----------------------------------------------------------------------------
  # * Module variables
  #-----------------------------------------------------------------------------
  @rotation_cache = {}
  #-----------------------------------------------------------------------------
  # * Get rotated position
  #-----------------------------------------------------------------------------
  def self.rotation_matrix(x, y, angle, flip = false)
    key  = (x * 10000 + y * 360 + angle)
    key *= flip ? -1 : 1
    if !@rotation_cache[key]
      rx = x * Math.cos(angle.to_rad) - y * Math.sin(angle.to_rad)
      ry = x * Math.sin(angle.to_rad) + y * Math.cos(angle.to_rad)
      ry *= -1 if flip
      @rotation_cache[key] = [rx.round(6), ry.round(6)]
    end
    return @rotation_cache[key]
  end
  #-----------------------------------------------------------------------------
  def self.slope(x1, y1, x2, y2)
    return nil if x2 == x1
    return (y2 - y1).to_f / (x2 - x1)
  end
  #-----------------------------------------------------------------------------
  # *) in arc:
  #
  # x1, y1: target coord
  # x2, y2: source coord
  # angle1, angle2: left's and right's Generalized Angle
  # distance: effective distance
  #-----------------------------------------------------------------------------
  def self.in_arc?(x1, y1, x2, y2, angle1, angle2, distance, original_dir)
    return false if self.hypot( x2 - x1, y2 - y1 ) > distance
    move_x = $game_map.width / 2
    move_y = $game_map.height / 2
    
    x1 = x1 - move_x
    y1 = move_y - y1
    x2 = x2 - move_x
    y2 = move_y - y2
    
    left_x    = x2 + self.rotation_matrix(1,0, angle1).at(0)
    left_y    = y2 + self.rotation_matrix(1,0, angle1).at(1)
    right_x   = x2 + self.rotation_matrix(1,0, angle2).at(0)
    right_y   = y2 + self.rotation_matrix(1,0, angle2).at(1)
    m1 = slope(x2, y2, left_x, left_y)
    m2 = slope(x2, y2, right_x, right_y)
    on_m1_right = on_m2_left = true
    
    offset1 = (left_y - m1 * left_x)
    offset2 = (right_y - m2 * right_x)
    delta   = m2 - m1
    delta_x = offset1 - offset2
    cx = delta_x.to_f / delta
    
    if m1.nil?
      on_m1_right = (angle1 == 90 ? x1 >= x2 : x1 <= x2)
    else
      if [4,7,8,9].include?(original_dir)
        on_m1_right = y1 >= m1 * x1 + offset1
      else
        on_m1_right = y1 <= m1 * x1 + offset1
      end
    end
    
    if m2.nil?
      on_m2_left = (angle2 == 270 ? x1 >= x2 : x1 <=x2)
    else
      if [4,1,2,3].include?(original_dir)
        on_m2_left = y1 <= m2 * x1 + offset2
      else
        on_m2_left = y1 >= m2 * x1 + offset2
      end
    end
    return on_m1_right && on_m2_left
  end
end