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
    if @animation_queue
      @animation_queue.each{|sprite| sprite.update if sprite.animation?}
    end
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
  #--------------------------------------------------------------------------
  # * Passable?                                                         
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    ox = d == 4 ? -1 : d == 6 ? 1 : 0
    oy = d == 8 ? -1 : d == 2 ? 1 : 0
    return false unless $game_map.valid?(x + ox, y + oy)
    return true if @through || debug_through?
    return false unless map_passable?(x, y, d)
    return false unless map_passable?(x + ox, y + oy, 10 - d)
    return false if collide_with_characters?(x + ox, y + oy)
    return true
  end
  #--------------------------------------------------------------------------
  def load_position(real_pos, normal_pos, pixel_pos)
    @real_x = real_pos.x
    @real_y = real_pos.y
    @x      = normal_pos.x
    @y      = normal_pos.y
    @px     = pixel_pos.x
    @py     = pixel_pos.y
  end
  
end
