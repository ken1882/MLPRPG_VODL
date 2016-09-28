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
  def initialize(viewport)
    super(viewport)
    self.ox = 0
    self.oy = 0
    set_subjects
    set_bitmap
    update
  end
  #----------------------------------------------------------------------------
  # Sets the bitmap
  #----------------------------------------------------------------------------
  def set_bitmap
    bmp = Bitmap.new(Graphic.width, Graphic.height)
    self.bitmap = bmp
    self.z = 0
  end
  #----------------------------------------------------------------------------
  # Sets the subjects
  #----------------------------------------------------------------------------
  def set_subjects
    @arrows = []
    @battlers = $game_player.followers
    @bitmap_arrows = {
      2 => Cache.picture("Tactics/Down"),
      4 => Cache.picture("Tactics/Left"),
      6 => Cache.picture("Tactics/Right"),
      8 => Cache.picture("Tactics/Up"),
    }
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
    update_pathfinding_arrows
    super
  end
  #----------------------------------------------------------------------------
  # Update Pathfinding Arrows
  #----------------------------------------------------------------------------
  def update_pathfinding_arrows
    
  end
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
