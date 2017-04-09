#==============================================================================
# ** Scene_Wait
#------------------------------------------------------------------------------
#  Scene for wait system stuff processing
#==============================================================================
class Scene_Wait < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_background
    create_viewport
    create_loading_sprites
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_sprite
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewport
    @viewport = Viewport.new
    @viewport.z = 100
  end
  #--------------------------------------------------------------------------
  # * Create Loading Sprites
  #--------------------------------------------------------------------------
  def create_loading_sprites
    @sprite = Sprite_Base.new(@viewport)
    @animation = $data_animations[155]
    @sprite_index = 0
    @sprite.x = Graphics.width  / 2
    @sprite.y = Graphics.height / 2
    update_sprite
  end
   
  def update_sprite
    @sprite.start_animation(@animation) if @sprite_index == 0
    @sprite_index = (@sprite_index + 1) % 48
    @sprite.update
  end
  
end
