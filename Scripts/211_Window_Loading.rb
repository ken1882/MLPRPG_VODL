#==============================================================================
# ** Window_Loaing
#------------------------------------------------------------------------------
#   Display loading status 
#==============================================================================
class Window_Loading < Window_Overlay
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, information, overlay_self = false)
    super(x, y, information, overlay_self)
    create_viewport
    create_loading_sprites
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viweport
    @viewport = Viewport.new
    @viewport.z = 100
  end
  #--------------------------------------------------------------------------
  # * Create Loading Sprites
  #--------------------------------------------------------------------------
  def create_loading_sprites
    @sprite = Sprite.new(@viewport)
    @sprite.bitmap = Cache.Character("$twilight_gallop_left")
  end
  
end
