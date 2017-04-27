#============================================================================
# Unit Circle
#----------------------------------------------------------------------------
# Display under the battler position
#============================================================================
class Unit_Circle < Sprite_Base
  #----------------------------------------------------------------------------
  # *) Object initialization
  #----------------------------------------------------------------------------
  def initialize(viewport, parent_sprite)
    super(viewport)
    @parent_sprite = parent_sprite
    @battler = parent_sprite.character
    set_bitmap
    hide
  end
  #----------------------------------------------------------------------------
  # *) Sets the bitmap
  #----------------------------------------------------------------------------
  def set_bitmap
    self.bitmap = Bitmap.new(32, 32)
    
    if @battler.is_a?(Game_Event)
      color = DND::COLOR::White
      #draw_sight
    else
      color = DND::COLOR::Blue
    end
    self.bitmap.draw_circle( 16, 16, 13, color, 2)
    self.z = 0
  end
  #----------------------------------------------------------------------------
  # *) Dispose method
  #----------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil && !self.bitmap.disposed?
      self.bitmap.dispose
      self.bitmap = nil
    end
    super
  end
  #----------------------------------------------------------------------------
  def show
    self.visible = true
  end
  #----------------------------------------------------------------------------
  def hide
    self.visible = false
  end
  #----------------------------------------------------------------------------
  # *) Update Process
  #----------------------------------------------------------------------------
  def update
    return unless self.visible?
    self.hide if dead?
    self.x = @parent_sprite.x - 16
    self.y = @parent_sprite.y - 28
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
  def draw_sight
    return if @battler.sensor.nil?
    self.bitmap = load_bitmap("Graphics/Lights/", "RS5")
  end
  #----------------------------------------------------------------------------
  def parent_sprite; @parent_sprite end
  #----------------------------------------------------------------------------
  def battler; @battler end
  #----------------------------------------------------------------------------
  def dead?
    return true if @battler.is_a?(Game_Event) && @battler.enemy.nil?
    return @battler.dead?
  end
  #----------------------------------------------------------------------------
  def adjacent?(sx, sy)
    return (sx - self.x).abs <= 4 && (sy - self.y).abs <= 4
  end
  #----------------------------------------------------------------------------
end