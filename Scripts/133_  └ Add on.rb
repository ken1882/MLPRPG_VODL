
#==============================================================================
# ** Sprite_Picture
#------------------------------------------------------------------------------
#  This sprite is used to display pictures. It observes an instance of the
# Game_Picture class and automatically changes sprite states.
#==============================================================================
class Sprite_Picture < Sprite
  
  #--------------------------------------------------------------------------
  # * Frame Update.                                                     [REP]
  #--------------------------------------------------------------------------
  def update
    super
    if @picture.name   != @effectus_old_name
      @effectus_old_name = nil
      update_bitmap 
    end
    update_origin if @picture.origin != @effectus_old_origin
    update_position
    if @effectus_old_zoom_x != @picture.zoom_x ||
       @effectus_old_zoom_y != @picture.zoom_y
      update_zoom
    end
    update_other
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Bitmap.                                    [REP]
  #--------------------------------------------------------------------------
  def update_bitmap
    @effectus_old_name = @picture.name
    if @effectus_old_name.empty?
      self.bitmap = nil
    else
      self.bitmap = Cache.picture(@effectus_old_name)
      @effectus_center_x = bitmap.width  / 2
      @effectus_center_y = bitmap.height / 2
    end
  end
  #--------------------------------------------------------------------------
  # * Update Origin.                                                    [REP]
  #--------------------------------------------------------------------------
  def update_origin
    @effectus_old_origin = @picture.origin
    if @effectus_old_origin == 0
      self.ox = 0
      self.oy = 0
    else
      self.ox = @effectus_center_x
      self.oy = @effectus_center_y
    end
  end
  #--------------------------------------------------------------------------
  # * Update Zoom Factor.                                               [REP]
  #--------------------------------------------------------------------------
  def update_zoom
    @effectus_old_zoom_x = @picture.zoom_x
    @effectus_old_zoom_y = @picture.zoom_y
    self.zoom_x = @effectus_old_zoom_x / 100.0
    self.zoom_y = @effectus_old_zoom_y / 100.0
  end
  #--------------------------------------------------------------------------
  # * Update Other.                                                     [REP]
  #--------------------------------------------------------------------------
  def update_other
    if @effectus_old_opacity != @picture.opacity
      @effectus_old_opacity = @picture.opacity
      self.opacity = @effectus_old_opacity
    end
    if @effectus_old_blend_type != @picture.blend_type
      @effectus_old_blend_type = @picture.blend_type
      self.blend_type = @effectus_old_blend_type
    end
    if @effectus_old_angle != @picture.angle
      @effectus_old_angle = @picture.angle
      self.angle = @effectus_old_angle
    end
    if @effectus_old_tone != @picture.tone    
      @effectus_old_tone = @picture.tone.dup
      self.tone.set(@effectus_old_tone)
    end
  end
  
end
