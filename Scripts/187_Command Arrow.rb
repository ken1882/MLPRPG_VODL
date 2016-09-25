#============================================================================
# Command Arrows
#----------------------------------------------------------------------------
# Display under the battler position, showing an AI's next movement
#============================================================================
class Command_Arrows < Sprite_Base
  #----------------------------------------------------------------------------
  # Constants
  #----------------------------------------------------------------------------
  
  #----------------------------------------------------------------------------
  # Object initialization
  #----------------------------------------------------------------------------
  def initialize(viewport, parent_sprite, battler)
    super(viewport)
    @parent_sprite = parent_sprite
    @battler       = battler
    
    self.ox = 0
    self.oy = 0
    set_bitmap
    update
  end
  #----------------------------------------------------------------------------
  # Sets the bitmap
  #----------------------------------------------------------------------------
  def set_bitmap
    bmp = Bitmap.new(32, 32)
    self.bitmap = bmp
    
    if @battler.is_a?(Game_Event)
      color = GTBS::RED.color
      #draw_sight(battler)
    else
      color = GTBS::BLUE.color
    end
    
    self.bitmap.draw_circle( 16, 16, 13, color, 2)
    self.z = 0
  end
  #----------------------------------------------------------------------------
  # Dispose method
  #----------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #----------------------------------------------------------------------------
  # Update Process
  #----------------------------------------------------------------------------
  def update
    self.visible = $tactic_enabled
    return unless $tactic_enabled
    self.visible = false if self.dead?
    
    self.x = parent_sprite.x - 16
    self.y = parent_sprite.y - 28
    super
  end
  #----------------------------------------------------------------------------
  # Get direction angle
  #----------------------------------------------------------------------------
  def direction_angle(battler)
    d = battler.direction
    case d
    when 2; return [90,180]
    when 4; return [150, 30]
    when 6; return [330,210]
    when 8; return [300, 60]
    end
  end
  #----------------------------------------------------------------------------
  # Draw sight limit, useless for now
  #----------------------------------------------------------------------------
  def draw_sight(battler)
    return if battler.sensor.nil?
    
    sensor = battler.sensor
    angle1 = battler.determind_sight_angles(60).at(0)
    angle2 = battler.determind_sight_angles(60).at(1)
    x = battler.screen_x
    y = battler.screen_y
    left_x   = x + Math.rotation_matrix(battler.sensor,0, angle1, true).at(0) * 32
    left_y   = y + Math.rotation_matrix(battler.sensor,0, angle1, true).at(1) * 32
    right_x  = x + Math.rotation_matrix(battler.sensor,0, angle2, true).at(0) * 32
    right_y  = y + Math.rotation_matrix(battler.sensor,0, angle2, true).at(1) * 32
    angles = direction_angle(battler)
    color = GTBS::YELLOW.color
    self.bitmap.draw_line(x, y, left_x, left_y,color)
    self.bitmap.draw_line(x, y, right_x, right_y,color)
    if angle1 > angle2; angle1,angle2 = angle2,angle1 end
    self.bitmap.draw_circle(battler.screen_x, battler.screen_y, sensor*32, color, 1, angle1, angle2)
  end
  #----------------------------------------------------------------------------
  def parent_sprite; @parent_sprite end
  #----------------------------------------------------------------------------
  def battler; @battler end
  #----------------------------------------------------------------------------
  def dead?
    @battler.is_a?(Game_Event) && @battler.enemy.dead?
  end
  #----------------------------------------------------------------------------
  def adjacent?(sx, sy)
    return (sx - self.x).abs <= 4 && (sy - self.y).abs <= 4
  end
  #----------------------------------------------------------------------------
end
