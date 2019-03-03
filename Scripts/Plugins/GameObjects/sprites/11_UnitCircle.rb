#============================================================================
# Unit Circle
#----------------------------------------------------------------------------
# Display under the battler position
#============================================================================
class Unit_Circle < Sprite_Base
  #----------------------------------------------------------------------------
  attr_accessor :character
  #----------------------------------------------------------------------------
  # *) Object initialization
  #----------------------------------------------------------------------------
  def initialize(viewport, character)
    super(viewport)
    @character = character
    self.z = viewport.z
    set_bitmap
    hide
  end
  #----------------------------------------------------------------------------
  # *) Sets the bitmap
  #----------------------------------------------------------------------------
  def set_bitmap
    self.bitmap = Bitmap.new(32, 32)
    if @character.is_a?(Game_Event) && (@character && @character.team_id != 0)
      color = DND::COLOR::Red
      #draw_sight
    else
      color = DND::COLOR::Blue
    end
    self.bitmap.draw_circle( 16, 16, 13, color, 2)
    update_position
  end
  #----------------------------------------------------------------------------
  # * Position update
  #----------------------------------------------------------------------------
  def update_position
    return hide if !BattleManager.valid_battler?(@character)
    self.x = @character.screen_x - 16
    self.y = @character.screen_y - 28
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
    update_position
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
    update_position
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
  # * Draw sight limit, useless for now
  #----------------------------------------------------------------------------
  def draw_sight
    #return if @character.sensor.nil?
    #self.bitmap = load_bitmap("Graphics/Lights/", "RS5")
  end
  #----------------------------------------------------------------------------
  def dead?
    return true if @character.is_a?(Game_Event) && @character.enemy.nil?
    return @character.dead?
  end
  #----------------------------------------------------------------------------
  def alive?
    return !dead?
  end
  #----------------------------------------------------------------------------
  def adjacent?(sx, sy)
    return (sx - self.x).abs <= 4 && (sy - self.y).abs <= 4
  end
  #----------------------------------------------------------------------------
end
