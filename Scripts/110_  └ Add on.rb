#==============================================================================
# ** Sprite
#==============================================================================
class Sprite
  #--------------------------------------------------------------------------
  # * Sprite visible?
  #--------------------------------------------------------------------------
  def visible?
    return self.visible
  end
  
end
#==============================================================================
# ** Sprite_Base
#------------------------------------------------------------------------------
#  A sprite class with animation display processing added.
#==============================================================================
class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  attr_reader :ani_sprites
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    super
    update_animation if animation?
    @@ani_checker.clear
    @@ani_spr_checker.clear
  end
  #--------------------------------------------------------------------------
  # * Update Animation
  #--------------------------------------------------------------------------
  def update_animation
    @ani_duration -= 1
    if @ani_duration % @ani_rate == 0
      if @ani_duration > 0
        frame_index = @animation.frame_max
        frame_index -= (@ani_duration + @ani_rate - 1) / @ani_rate
        animation_set_sprites(@animation.frames[frame_index])
        @animation.timings.each do |timing|
          animation_process_timing(timing) if timing.frame == frame_index
        end
      else
        end_animation
      end # @ani_duration
    end # @ani_dur % rate == 0
  end # def update_ani
  
end # class SpBase
