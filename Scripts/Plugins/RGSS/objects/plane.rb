#==============================================================================
# ** Plane
#------------------------------------------------------------------------------
#  Planes are special Sprites that tile bitmap patterns across the entire
# screen and are used to display parallax backgrounds and so on.
#==============================================================================
# Effectus's improvement
Object.send(:remove_const, :Plane)
class Plane < Sprite
  #--------------------------------------------------------------------------
  # * Set Bitmap
  #--------------------------------------------------------------------------
  def bitmap=(new_bitmap)
    return if new_bitmap == @real_bitmap && viewport == @last_viewport
    if @real_bitmap
      @real_bitmap  = nil
      self.bitmap.dispose
    end
    return super(new_bitmap) unless new_bitmap
    vw = viewport ? viewport.rect.width  : Graphics.width
    vh = viewport ? viewport.rect.height : Graphics.height
    @real_width  = new_bitmap.width
    @real_height = new_bitmap.height
    super(Bitmap.new(vw + @real_width, vh + @real_height))
    horizontal = vw / @real_width  + 1 + (vw % @real_width  > 0 ? 1 : 0)
    vertical   = vh / @real_height + 1 + (vh % @real_height > 0 ? 1 : 0)
    horizontal.times do |bx|
      vertical.times do |by|
        bitmap.blt(
          bx * @real_width,
          by * @real_height, new_bitmap,
          new_bitmap.rect
        )
      end
    end
    @last_viewport = viewport
    @real_bitmap   = new_bitmap
  end
  #--------------------------------------------------------------------------
  # * Set Offset X
  #--------------------------------------------------------------------------
  def ox=(value)
    super(@real_bitmap ? value % @real_width  : value)
  end
  #--------------------------------------------------------------------------
  # * Set Offset Y
  #--------------------------------------------------------------------------
  def oy=(value)
    super(@real_bitmap ? value % @real_height : value)
  end
  #--------------------------------------------------------------------------
  # * Bitmap
  #--------------------------------------------------------------------------
  def bitmap
    @real_bitmap ? @real_bitmap : super
  end
  #--------------------------------------------------------------------------
  # * Set Viewport
  #--------------------------------------------------------------------------
  def viewport=(new_viewport)
    if new_viewport != viewport
      super(new_viewport)
      self.bitmap = @real_bitmap if @real_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    if @real_bitmap
      @real_bitmap = nil
      self.bitmap.dispose
    end
    super
  end
  #-----------------------------------------------------------------------------
end