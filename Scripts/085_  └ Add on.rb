#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================
class Game_CharacterBase
  
  attr_reader :animation_queue
  #--------------------------------------------------------------------------
  # * Alias: Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_cbmembers init_public_members
  def init_public_members
    init_public_cbmembers
    @move_speed = 4
  end
  #--------------------------------------------------------------------------
  # * Create sprites for multi-animation display, call from Spriteset_Map
  #--------------------------------------------------------------------------
  def create_animation_queue
    @animation_queue = Array.new(3){ |index|
      index = Sprite_Animation.new(nil, self)
    }
  end
  #--------------------------------------------------------------------------
  # * Start animation
  #--------------------------------------------------------------------------
  def start_animation(animation)
    
    if animation.is_a?(Numeric)
      id = animation
      animation = $data_animations[id]
    else
      id = animation.id
    end
    
    if animation_id > 0
      @animation_queue.each {|sprite|
        if !sprite.animation?
          sprite.start_animation(animation)
          break
        end
      } # check idle animation sprite
    else
      @animation_id = id
    end
    
  end
  #--------------------------------------------------------------------------
  # * Alias: update animation
  #--------------------------------------------------------------------------
  alias update_multi_animation update_animation
  def update_animation
    @animation_queue.each{|sprite| sprite.update if sprite.animation?}
    update_multi_animation
  end
  
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose_sprites
    @animation_queue.each{|sprite| sprite.dispose}
    @animation_queue.clear
  end
  #--------------------------------------------------------------------------
  # * Determine if Dashing
  #--------------------------------------------------------------------------
  def dash?
    return false
  end
  #--------------------------------------------------------------------------
  # * Calculate Move Distance per Frame
  #--------------------------------------------------------------------------
  def distance_per_frame
    re = (2 ** (real_move_speed).to_i / 256.0)
    return re
  end
end
