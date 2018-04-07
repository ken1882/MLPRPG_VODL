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
  def start_animation(animation, mirror = false)
    
    if animation.is_a?(Numeric)
      id = animation
      animation = $data_animations[id]
    else
      id = animation.id
    end
    create_animation_queue if @animation_queue.nil?
    if animation_id > 0
      @animation_queue.each {|sprite|
        if !sprite.animation?
          sprite.start_animation(animation, mirror)
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
    return if @animation_queue.nil?
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
  #--------------------------------------------------------------------------
  def pos
    return POS.new(@real_x, @real_y)
  end
  #----------------------------------------------------------------------------
  def battler
    return self
  end
  #----------------------------------------------------------------------------
  def path_passable?(x, y, dir, ignore_chars = [])
    px = x * 4; py = y * 4;
    return false unless $game_map.pixel_valid?(px,py)
    return true  if @through || debug_through?
    return false if $game_map.pixel_table[px,py,0] == 0
    return false if character_collided?(px, py, ignore_chars)
    return true
  end
  #----------------------------------------------------------------------------
  def character_collided?(px, py, ignores = [])
    return false if through_character?
    return true  if collide_with_events?(px, py, ignores)
    return true  if collide_with_follower?(px, py, ignores)
    return true  if collide_with_player?(px, py, ignores)
    return false
  end
  #----------------------------------------------------------------------------
  def through_character?
    false || @through
  end
  #--------------------------------------------------------------------------
  # * Collide with Events?                                              [REP]
  #--------------------------------------------------------------------------
  def collide_with_events?(px, py, ignores = [])
    x, y = px * Pixel_Core::Pixel, py * Pixel_Core::Pixel;
    $game_map.effectus_event_pos[y * $game_map.width + x].each do |event|
      next if event == self
      next if event.through_character?
      next unless event.normal_priority?
      next if ignores.include?(event)
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        return true
      end
    end
    return false
  end
  #----------------------------------------------------------------------------
  def collide_with_follower?(px,py,ignores = [])
    $game_player.followers.each do |follower|
      next if ignores.include?(follower) || (follower.actor && ignores.include?(follower.actor))
      next if follower.dead? || follower.through_character?
      return follower if (follower.px - px).abs <= follower.cx && (follower.py - py).abs <= follower.cy
    end
    return false
  end
  #----------------------------------------------------------------------------
  def collide_with_player?(px,py,ignores = [])
    return false if ignores.include?($game_player)
    return false if ($game_player.actor && ignores.include?($game_player.actor))
    return false if $game_player.dead?
    return ($game_player.px - px).abs <= @cx && ($game_player.py - py).abs <= @cy
  end
  #----------------------------------------------------------------------------
  
end
