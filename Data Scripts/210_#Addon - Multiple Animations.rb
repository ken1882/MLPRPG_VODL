# =============================================================================
# Theolized Sideview Battle System (TSBS) - Multiple Animations
# Version : 1.2
# Contact : www.rpgmakerid.com (or) http://www.theolized.com
# (English Documentation)
# -----------------------------------------------------------------------------
# Requires :
# >> Theolized SBS v1.4 or more
# =============================================================================
($imported ||= {})[:TSBS_MultiAnime] = true
# =============================================================================
# Change Logs:
# -----------------------------------------------------------------------------
# 2014.09.16 - Compatibility with Battle Camera
# 2014.09.05 - Delete anim_top reset
# 2014.07.15 - Fixed to screen animation positioning
# 2014.06.23 - Multiple animation on anim guard
# 2014.05.13 - Fixed wrong animation flash target
# 2014.05.02 - Finished script
# =============================================================================
=begin

  Introduction :
  By default, when animation played over the battler and if you played another
  animation, the previous animation will be replaced. By using this script, you
  could play both animations without erasing the previous animation.
  
  How to use :
  Put this script below TSBS implementation
  This script work automatically. There's not configuration and such
  
  Even it named multianime, you still can not activate two different animation
  at same time. It's only handled the previous animation not to be replaced
  until it finished. You can activate two different animation by place a one
  frame gap like
  
  Example :
  [:cast, 123],
  [:wait, 1],   # <-- wait 1 frame
  [:cast, 60],
  [:wait, 1],   # <-- wait 1 frame
  [:cast, 23],

=end
#==============================================================================
# No config. Do not touch below this line!
#==============================================================================
# ** Sprite_MultiAnime
#------------------------------------------------------------------------------
#  This sprite is used to display multiple animations. Instance of this object
# is created when play animation over Sprite_Battler and Sprite_AnimGuard. It
# replaces how start_animation is handled
#==============================================================================

if $imported[:TSBS]
  
class Sprite_MultiAnime < Sprite_Base
  include TSBS_AnimRewrite
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(viewport, ref_sprite, anime, flip = false)
    super(viewport)
    @ref_sprite = ref_sprite
    @anim_origin = TSBS::Screen_Point.new
    update_reference_sprite
    start_animation(anime, flip)
  end
  # --------------------------------------------------------------------------
  # * Camera reposition case?
  # --------------------------------------------------------------------------
  def camera_reposition_case?
    $imported[:TSBS_Camera] && @animation.position != 3
  end
  # --------------------------------------------------------------------------
  # * Set animation origin
  # --------------------------------------------------------------------------
  def set_animation_origin
    unless camera_reposition_case?
      super      
      return
    end
    if @ref_sprite.is_a?(Sprite_OneAnim)
      @anim_origin.x = @ref_sprite.screen_point.x - ox + width / 2
      @anim_origin.y = @ref_sprite.screen_point.y - oy
    else
      @anim_origin.x = @ref_sprite.battler.x - ox + width / 2
      @anim_origin.y = @ref_sprite.battler.y - oy
    end
    if @animation.position == 0
      @anim_origin.y -= height / 2
    elsif @animation.position == 2
      @anim_origin.y += height / 2
    end
    update_anim_origin_reference
  end
  # --------------------------------------------------------------------------
  # * Update Animation Origin Reference
  # --------------------------------------------------------------------------
  def update_anim_origin_reference
    @ani_ox = @anim_origin.screen_x
    @ani_oy = @anim_origin.screen_y
  end
  # --------------------------------------------------------------------------
  # * Update per frame
  # --------------------------------------------------------------------------
  def update
    update_anim_position
    update_reference_sprite
    super
    dispose if !animation?
  end
  # --------------------------------------------------------------------------
  # * Get difference X
  # --------------------------------------------------------------------------
  def diff_x
    @ref_sprite.x - x
  end
  # --------------------------------------------------------------------------
  # * Get difference Y
  # --------------------------------------------------------------------------
  def diff_y
    @ref_sprite.y - y
  end
  # --------------------------------------------------------------------------
  # * Move animation follow (non-camera)
  # --------------------------------------------------------------------------
  def move_animation(dx, dy)
    if @animation && @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # * Move animation follow (camera relative)
  # --------------------------------------------------------------------------
  def move_animation_camera_relative_follow
    if @animation.position != 3
      last_screen_x = @anim_origin.screen_x
      last_screen_y = @anim_origin.screen_y
      @anim_origin.x = @ref_sprite.battler.x
      @anim_origin.y = @ref_sprite.battler.y - oy
      update_anim_origin_reference
      dx = (@ani_ox - last_screen_x).round
      dy = (@ani_oy - last_screen_y).round
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # * Move animation static (camera relative)
  # --------------------------------------------------------------------------
  def move_animation_camera_relative_static
    if @animation.position != 3
      last_screen_x = @ani_ox
      last_screen_y = @ani_oy
      update_anim_origin_reference
      dx = (@ani_ox - last_screen_x).round
      dy = (@ani_oy - last_screen_y).round
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # * Update animation position
  # --------------------------------------------------------------------------
  def update_anim_position
    return unless @animation
    camera = $imported[:TSBS_Camera]
    if @anim_follow && !camera
      move_animation(diff_x, diff_y)
    elsif @anim_follow && camera
      move_animation_camera_relative_follow
    elsif camera
      move_animation_camera_relative_static
    end
  end
  # --------------------------------------------------------------------------
  # * Update reference sprite
  # --------------------------------------------------------------------------
  def update_reference_sprite
    src_rect.set(@ref_sprite.src_rect)
    self.ox = @ref_sprite.ox
    self.oy = @ref_sprite.oy
    self.x = @ref_sprite.x
    self.y = @ref_sprite.y
    self.z = (@animation && @animation.position != 3 ? @ref_sprite.z : 
      Graphics.height)
  end
  # --------------------------------------------------------------------------
  # * Start animation 
  # --------------------------------------------------------------------------
  def start_animation(anime, flip = false)
    @anim_top = $game_temp.anim_top
    @anim_follow = $game_temp.anim_follow
    super(anime, flip)
  end
  # --------------------------------------------------------------------------
  # * Redirect flash
  # --------------------------------------------------------------------------
  def flash(*args)
    @ref_sprite.flash(*args)
  end
  
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display battlers. It observes an instance of the
# Game_Battler class and automatically changes sprite states.
#==============================================================================

class Sprite_Battler
  attr_reader :multianimes
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  alias tsbs_multianim_init initialize
  def initialize(viewport, battler = nil)
    @multianimes = []
    tsbs_multianim_init(viewport, battler)
  end
  # --------------------------------------------------------------------------
  # * Start animation
  # --------------------------------------------------------------------------
  def start_animation(anime, flip = false)
    spr_anim = Sprite_MultiAnime.new(viewport, self, anime, flip)
    multianimes.push(spr_anim)
  end
  # --------------------------------------------------------------------------
  # * Update per frame
  # --------------------------------------------------------------------------
  alias tsbs_multianim_update update
  def update
    tsbs_multianim_update
    multianimes.delete_if do |anime|
      anime.update
      anime.disposed?
    end
  end
  # --------------------------------------------------------------------------
  # * Dispose
  # --------------------------------------------------------------------------
  alias tsbs_multianim_dispose dispose
  def dispose
    tsbs_multianim_dispose
    multianimes.each do |anime|
      anime.dispose
    end
  end
  # --------------------------------------------------------------------------
  # * Animation?
  # --------------------------------------------------------------------------
  def animation?
    !multianimes.empty?
  end
  # --------------------------------------------------------------------------
  # * Delete update animation
  # --------------------------------------------------------------------------
  def update_animation
  end  
  
end

#==============================================================================
# ** Sprite_AnimGuard
#------------------------------------------------------------------------------
#  This sprite handles battler animation guard. It's a simply dummy sprite that
# created from Sprite_Base just for play an animation. Used within the 
# Sprite_Battler class
#==============================================================================

class Sprite_AnimGuard
  attr_reader :multianimes
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  alias tsbs_multianim_init initialize
  def initialize(spr_battler, vport = nil)
    @multianimes = []
    tsbs_multianim_init(spr_battler, vport)
  end
  # --------------------------------------------------------------------------
  # * Start animation
  # --------------------------------------------------------------------------
  def start_animation(anime, flip = false)
    spr_anim = Sprite_MultiAnime.new(viewport, self, anime, flip)
    multianimes.push(spr_anim)
  end
  # --------------------------------------------------------------------------
  # * Update per frame
  # --------------------------------------------------------------------------
  alias tsbs_multianim_update update
  def update
    tsbs_multianim_update
    multianimes.delete_if do |anime|
      anime.update
      anime.disposed?
    end
  end
  # --------------------------------------------------------------------------
  # * Dispose
  # --------------------------------------------------------------------------
  alias tsbs_multianim_dispose dispose
  def dispose
    tsbs_multianim_dispose
    multianimes.each do |anime|
      anime.dispose
    end
  end
  # --------------------------------------------------------------------------
  # * Animation?
  # --------------------------------------------------------------------------
  def animation?
    !multianimes.empty?
  end
  # --------------------------------------------------------------------------
  # * Delete update animation
  # --------------------------------------------------------------------------
  def update_animation
  end  
  
end
end
