#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  A character class with mainly movement route and other such processing
# added. It is used as a super class of Game_Player, Game_Follower,
# GameVehicle, and Game_Event.
#==============================================================================
class Game_Character < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :zoom_x
  attr_reader :zoom_y
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_memdnd init_public_members
  def init_public_members
    @zoom_x = @zoom_y = 1.0
    @zoom_duration_x = @zoom_duration_y = 0
    init_public_memdnd
  end
  #----------------------------------------------------------------------------
  # *) Frame update
  #----------------------------------------------------------------------------
  def update
    super
    update_zoom
  end
  #----------------------------------------------------------------------------
  # *) Update Zooming
  #----------------------------------------------------------------------------
  def update_zoom
    return unless @zooming
    dx, dy = @zoom_duration_x, @zoom_duration_y
    
    if @zoom_x == @target_zoom_x
      @zoom_duration_x = 0
    elsif dx == 0
      @zoom_x = @target_zoom_x
    elsif dx > 0
      @zoom_x = (@zoom_x * (dx - 1) + @target_zoom_x) / dx
      @target_zoom_x -= 1
    end
    
    if @zoom_y == @target_zoom_y
      @zoom_duration_y = 0
    elsif dy == 0
      @zoom_y = @target_zoom_y
    elsif dy > 0
      @zoom_y = (@zoom_y * (dy - 1) + @target_zoom_y) / dy
      @target_zoom_y -= 1
    end
    puts "Zoom: #{@zoom_x} #{@zoom_y}"
    @zooming = false if dx == 0 && dy == 0
  end
  #----------------------------------------------------------------------------
  # *) Zoom Character
  #----------------------------------------------------------------------------
  def zoom(x, y, dx = 0, dy = 0)
    @target_zoom_x, @target_zoom_y = x, y
    @zoom_duration_x, @zoom_duration_y = dx, dy
    @zooming = true
  end
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
      return false if !result
      
      error += (delta / 4)
      while error >= 0.5
        result = false
        (1..4).each do |i|
          result |= pixel_passable?((x + 0.5).to_i, (y + 0.5).to_i, i*2 );
        end
        return false if !result        
        y = y + sgny;
        error -= 1.0;
      end # while
      
      x += 0.25
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
  #----------------------------------------------------------------------------
  def distance_to_character(charactor)
    return Math.hypot(@x - charactor.x, @y - charactor.y)
  end
  #----------------------------------------------------------------------------
  def id
    return actor.id if methods.include?(:actor)
    return @id
  end
end
