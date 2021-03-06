#===============================================================================
# * Sprite_Weapon
#-------------------------------------------------------------------------------
#   Disaply the wielding weapon on the Scene_Map
#===============================================================================
class Sprite_Icon < Sprite
  #--------------------------------------------------------------------------
  attr_reader :icon_id
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(instance, viewport, icon_id, game_x = 0, game_y = 0)
    @icon_id = icon_id
    super(viewport)
    @instance   = instance
    @instance_x = game_x
    @instance_y = game_y
    create_bitmap
  end
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Bitmap.new(24, 24)
    draw_icon(@icon_id)
  end
  #--------------------------------------------------------------------------
  def change_icon(id)
    @icon_id = id
    draw_icon(@icon_id)
  end
  #--------------------------------------------------------------------------
  def update
    super
    self.x = screen_x
    self.y = screen_y
  end
  #--------------------------------------------------------------------------
  # * Get Screen X-Coordinates
  #--------------------------------------------------------------------------
  def screen_x
    $game_map.adjust_x(@instance_x) * 32 + 16
  end
  #--------------------------------------------------------------------------
  # * Get Screen Y-Coordinates
  #--------------------------------------------------------------------------
  def screen_y
    $game_map.adjust_y(@instance_y) * 32 + 32
  end
  #--------------------------------------------------------------------------
  def dispose
    super
    @instance.unlink_sprite
    @instance = nil
  end
end
