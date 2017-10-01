#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  A character class with mainly movement route and other such processing
# added. It is used as a super class of Game_Player, Game_Follower,
# GameVehicle, and Game_Event.
#==============================================================================
class Game_Character < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :zoom_x
  attr_reader :zoom_y
  attr_reader :knockbacks
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_memdnd init_public_members
  def init_public_members
    @zoom_x = @zoom_y = 1.0
    @zoom_duration_x = @zoom_duration_y = 0
    @knockbacks = []
    init_public_memdnd
  end
  #----------------------------------------------------------------------------
  # *) Frame update
  #----------------------------------------------------------------------------
  def update
    super
    update_zoom
    update_knockback if !@knockbacks.empty?
    @pathfinding_timer -= 1 if @pathfinding_timer > 0
  end
  #----------------------------------------------------------------------------
  # *) Update Zooming
  #----------------------------------------------------------------------------
  def update_zoom
    return unless @zooming
    @zooming = false
    flag = @zoom_delta_x <=> 0
    if @zoom_x * flag > @target_zoom_x * flag
      @zoom_x = @target_zoom_x
    elsif @zoom_x != @target_zoom_x
      @zoom_x += @zoom_delta_x
      @zooming = true
    end
    flag = @zoom_delta_y <=> 0
    if @zoom_y * flag > @target_zoom_y * flag
      @zoom_y = @target_zoom_y
    elsif @zoom_y != @target_zoom_y
      @zoom_y += @zoom_delta_y
      @zooming = true
    end
  end
  #----------------------------------------------------------------------------
  # *) Zoom Character
  #----------------------------------------------------------------------------
  def zoom(x, y, dx = 0, dy = 0)
    @target_zoom_x, @target_zoom_y = x, y
    @zoom_delta_x = (x - @zoom_x).to_f / dx
    @zoom_delta_y = (y - @zoom_y).to_f / dy
    @zooming = true
  end
  #----------------------------------------------------------------------------
  def apply_knockback(direction, power)
    return if power < 1
    @knockbacks.clear
    power.times{@knockbacks << direction}
  end
  #----------------------------------------------------------------------------
  # * Update knockbacks
  #----------------------------------------------------------------------------
  def update_knockback
    dir = @knockbacks.shift
    if pixel_passable?(@px, @py, dir)
      @px += Tile_Range[dir][0]
      @py += Tile_Range[dir][1]
      @real_x = @x
      @real_y = @y
      @x += Pixel_Range[dir][0]
      @y += Pixel_Range[dir][1]
    end
  end
  #----------------------------------------------------------------------------
  # *) check if straight line path is able to see
  #----------------------------------------------------------------------------
  def path_clear?(x1, y1, x2, y2)
    dx = x2 - x1;
    if(dx == 0)
      return straight_path_clear?(x1,y1,y2)
    elsif(dx < 0)
      return path_clear?(x2,y2,x1,y1);
    end
    
    dy = y2 - y1;
    sgny = (dy >= 0 ? 1 : -1);
    delta = (dy.to_f / dx.to_f).abs;
    error = 0.0;
    
    y = y1
    x = x1
    while x <= x2
      result = false
      (1..4).each do |i|
        result |= pixel_passable?((x + 0.5).to_i, (y + 0.5).to_i, i*2 );
      end
      return false if !result
      
      error += (delta / 4)
      while error >= 0.5
        result = false
        (1..4).each do |i|
          result |= pixel_passable?((x + 0.5).to_i, (y + 0.5).to_i, i*2 );
        end
        return false if !result        
        y = y + sgny;
        error -= 1.0;
      end # while
      
      x += 0.25
    end # while x
    
    return true
  end
  #----------------------------------------------------------------------------
  # *) straight path clear?
  #----------------------------------------------------------------------------
  def straight_path_clear?(x1, y1, y2)
    y = y1
    while y <= y2
      result = false
      (1..4).each do |i|
        result |= pixel_passable?(x1 , y , i*2 )
      end
      return false if !result    
      y += 0.25
    end # for y
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Movement is Possible
  #--------------------------------------------------------------------------
  def movable?
    return false if @move_route_forcing
    return false if $game_message.busy? || $game_message.visible
    return true
  end
  #----------------------------------------------------------------------------
  # * Die when hitpoint drop to zero
  #----------------------------------------------------------------------------
  def kill
    SceneManager.display_info("#{self.name} - knocked out")
    $game_map.need_refresh = true
    set_target(nil)
  end
  #----------------------------------------------------------------------------
  def swap_member(char)
    pos1 = pos
    pos2 = char.pos
    moveto(pos2.x, pos2.y)
    char.moveto(pos1.x, pos1.y)
  end
  #----------------------------------------------------------------------------
  def process_event_death
    drop_loots if $game_player.is_opponent?(self)
    set_target(nil)
    apply_event_death_effect
    start_animation(@enemy.death_animation)
  end
  #----------------------------------------------------------------------------
  def apply_event_death_effect
    sws = @enemy.death_switch_self
    swg = @enemy.death_switch_global
    vrsi, vrsv = *@enemy.death_var_self if @enemy.death_var_self
    vrgi, vrgv = *@enemy.death_var_global
    if sws
      key = [@map_id, @event.id, sws]
      $game_self_switches[key] = true
    end
    $game_switches[swg] = true    if swg  > 0
    @self_vars[vrsi] = vrsv       if vrsi && vrsv
    $game_variables[vrgi] = vrgv  if vrgi > 0
  end
  #----------------------------------------------------------------------------
  def process_actor_death(se_play = true)
    Sound.play(actor.death_sound) if actor.death_sound && se_play
    @character_name  = actor.death_graphic
    @character_index = actor.death_index
    @pattern         = actor.death_pattern
    @direction       = actor.death_direction
    debug_print "#{actor.name} is knocked out!"
  end
  #----------------------------------------------------------------------------
  def revive_character
    @character_name  = actor.character_name
    @character_index = actor.character_index
  end
  #----------------------------------------------------------------------------
  def distance_to_character(charactor)
    return Math.hypot(@x - charactor.x, @y - charactor.y)
  end
  #----------------------------------------------------------------------------
  def id
    return actor.id if methods.include?(:actor)
    return @id
  end
  #----------------------------------------------------------------------------
  def drop_loots
    exp   = @enemy.exp / $game_party.members.size
    gold  = @enemy.gold
    loots = @enemy.make_drop_items
    $game_party.gain_exp(exp)
    #last work: register loot drops
  end
  #----------------------------------------------------------------------------
  def map_char
    return self
  end
  
end
