#===============================================================================
# * Sprite_Projectile
#-------------------------------------------------------------------------------
#   Projectiles in the game, game cannot be saved if any projectile exist
#===============================================================================
class Sprite_Projectile < Sprite_Character
  #--------------------------------------------------------------------------
  # * Public character Variables
  #--------------------------------------------------------------------------
  attr_reader   :executed
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(viewport, character)
    @tile_id = character.tile_id
    @character_name  = character.character_name
    @executed = false
    super(viewport, character)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_dispose
  end
  #--------------------------------------------------------------------------
  # * Dispose when executed
  #--------------------------------------------------------------------------
  def update_dispose
    return unless @executed
    return if animation?
    self.dispose
  end
  #--------------------------------------------------------------------------
  # * Determine if Graphic Changed
  #--------------------------------------------------------------------------
  def graphic_changed?
    @character_index != @character.character_index
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Bitmap
  #--------------------------------------------------------------------------
  def update_bitmap
    if graphic_changed?
      @character_index = @character.character_index
      set_character_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # * Execute effect on collide
  #--------------------------------------------------------------------------
  def execute_collide
    @character.execute_action
    start_collide_animation
  end
  #--------------------------------------------------------------------------
  # * Execute animation when collided
  #--------------------------------------------------------------------------
  def start_collide_animation
    if !animation? && @character.item.tool_animation > 0
      @character.transparent = true
      animation = $data_animations[@character.item.tool_animation]
      start_animation(animation)
      @executed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Set Character Bitmap
  #--------------------------------------------------------------------------
  def set_character_bitmap
    self.bitmap = Cache.Arms(@character_name)
    sign = @character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      @cw = bitmap.width / 3
      @ch = bitmap.height / 4
    else
      @cw = bitmap.width / 12
      @ch = bitmap.height / 8
    end
    self.ox = @cw / 2
    self.oy = @ch
  end
  #--------------------------------------------------------------------------
  # * Set New Effect
  #--------------------------------------------------------------------------
  def setup_new_effect
  end
  
end
