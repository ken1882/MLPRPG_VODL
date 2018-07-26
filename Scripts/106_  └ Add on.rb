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
  attr_reader     :zoom_x
  attr_reader     :zoom_y
  attr_reader     :knockbacks
  attr_reader     :through_character
  attr_reader     :altitude
  attr_reader     :last_quadtree_index, :quadtree_index
  attr_accessor   :through                  # pass-through
  attr_accessor   :step_anime               # stepping animation
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_memdnd init_public_members
  def init_public_members
    @zoom_x = @zoom_y = 1.0
    @zoom_duration_x = @zoom_duration_y = 0
    @knockbacks = []
    @through_character = false
    @altitude   = 0
    init_public_memdnd
  end
  #----------------------------------------------------------------------------
  # *) Frame update
  #----------------------------------------------------------------------------
  def update
    super
    update_zoom
    update_quadtree_index
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
  def static_object?
    return false
  end
  #----------------------------------------------------------------------------
  def apply_knockback(direction, power)
    return if power < 1
    return if static_object?
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
  #--------------------------------------------------------------------------
  def obstacle_touched?(x, y, dir = @direction)
    #x += Pixel_Core::Tile_Range[dir][0]
    #y += Pixel_Core::Tile_Range[dir][1]
    px, py = (x*4).to_i, (y*4).to_i;
    return true  if !$game_map.pixel_valid?(px,py) || $game_map.over_edge?(x, y)
    return true  if $game_map.pixel_table[px,py,1] == 0
    return true  if collide_event_objects?(x, y)
    return false
  end
  #----------------------------------------------------------------------------
  def seeable?(x, y, dir = @direction)
    return true if !obstacle_touched?(x, y, dir)
    case dir
    when 6; x += 0.8;
    when 2; y += 0.8;
    end
    return $game_map.get_tile_altitude(x,y) > 0
  end
  #----------------------------------------------------------------------------
  def collide_event_objects?(x, y)
    poshash = y * $game_map.width + x
    for event in $game_map.effectus_event_pos[poshash]
      next if event.through || event == self || event.enemy
      return true if event.static_object?
      return true if event.priority_type == 1
    end
    return false
  end
  #----------------------------------------------------------------------------
  # *) check if path between two dot is clear
  #----------------------------------------------------------------------------
  def path_clear?(x1, y1, x2, y2)
    dx = x2 - x1;
    if(dx == 0)
      return straight_path_clear?(x1,y1,y2)
    elsif(dx < 0)
      return path_clear?(x2,y2,x1,y1);
    end
    
    dy    = y2 - y1;
    sgny  = (dy >= 0 ? 1 : -1);
    delta = (dy.to_f / dx.to_f).abs;
    error = 0.0;
    
    x,y = x1, y1
    while x <= x2
      return false if obstacle_touched?(x, y)
      error += (delta / 4)
      while error >= 0.5
        return false if obstacle_touched?(x, y)
        y     += sgny
        error -= 1.0
      end # while
      x += 0.25
    end # while x
    
    return true
  end
  #----------------------------------------------------------------------------
  # *) check if can see the location
  #----------------------------------------------------------------------------
  def can_see?(*args)
    case args.size
    when 1
      return can_see?(@x, @y, args[0].x, args[0].y)
    when 4
      x1, y1 = args[0], args[1]
      x2, y2 = args[2], args[3]
    else
      raise ArgumentError
    end
    
    dx = x2 - x1;
    if(dx == 0)
      return straight_path_seeable?(x1,y1,y2)
    elsif(dx < 0)
      return can_see?(x2,y2,x1,y1);
    end
    
    dy    = y2 - y1;
    sgny  = (dy >= 0 ? 1 : -1);
    delta = (dy.to_f / dx.to_f).abs;
    error = 0.0;
    
    x,y = x1, y1
    while x <= x2
      return false if !seeable?(x, y)
      error += (delta / 4)
      while error >= 0.5
        return false if !seeable?(x, y)
        y     += sgny
        error -= 1.0
      end # while
      x += 0.25
    end # while x
    
    return true
  end
  #----------------------------------------------------------------------------
  # *) straight path seeable?
  #----------------------------------------------------------------------------
  def straight_path_seeable?(x1, y1, y2)
    y = y1
    while y <= y2
      result = false
      (1..4).each do |i|
        result |= seeable?(x1 , y , i*2 )
      end
      return false if !result
      y += 0.25
    end # for y
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
    #SceneManager.display_info("#{self.name} - knocked out")
    $game_map.need_refresh = true
    @ori_through = @through
    cancel_action_without_penalty(true)
    @next_action = nil
    set_target(nil)
  end
  #----------------------------------------------------------------------------
  def swap_member(char)
    dir1, dir2 = @direction, char.direction
    pos1 = pos
    pos2 = char.pos
    moveto(pos2.x, pos2.y)
    char.moveto(pos1.x, pos1.y)
    @action, char.action = char.action, @action
    @next_action, char.next_action = char.next_action, @next_action
    @casting_flag, char.casting_flag = char.casting_flag, @casting_flag
    @step_anime, char.step_anime = char.step_anime, @step_anime
    set_direction(dir2); char.set_direction(dir1);
  end
  #----------------------------------------------------------------------------
  def process_event_death
    drop_loots if $game_player.is_opponent?(self)
    apply_event_death_effect
    start_animation(@enemy.death_animation)
  end
  #----------------------------------------------------------------------------
  def apply_event_death_effect
    sws = @enemy.death_switch_self
    swg = @enemy.death_switch_global
    vrsi, vrsv = *@enemy.death_var_self if @enemy.death_var_self
    vrgi, vrgv = *@enemy.death_var_global
    return if sws.nil? && swg + vrsi + vrgi == 0
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
    update_security
    @through = @ori_through
    @character_name  = actor.character_name
    @character_index = actor.character_index
    moveto($game_player.x, $game_player.y) if distance_to_player > 2
    set_target(nil)
  end
  #----------------------------------------------------------------------------
  def distance_to_character(charactor)
    return Math.hypot(@x - charactor.x, @y - charactor.y)
  end
  #----------------------------------------------------------------------------
  def distance_to_player
    charactor = $game_player
    return Math.hypot(@x - charactor.x, @y - charactor.y)
  end
  #----------------------------------------------------------------------------
  def id
    return actor.id if methods.include?(:actor)
    return @id
  end
  #----------------------------------------------------------------------------
  def change_team(new_id)
    return unless BattleManager.valid_battler?(self)
    battler.team_id = new_id
    $game_map.resign_battle_unit(self)
    $game_map.register_battler(self)
  end
  #----------------------------------------------------------------------------
  def drop_loots
    exp   = @enemy.exp
    gold  = @enemy.gold
    loots = @enemy.make_drop_items
    BattleManager.add_party_exp(exp)
    loots = [] if loots.nil?
    $game_map.register_item_drop(@x, @y, gold, loots)
  end
  #----------------------------------------------------------------------------
  def map_char
    return self
  end
  #---------------------------------------------------------------------------
  def weapon_level_prof
    return 0 if !BattleManager.valid_battler?(self)
    battler.weapon_level_prof
  end
  #--------------------------------------------------------------------------
  def casting_animation 
    return DND::BattlerSetting::CastingAnimation
  end
  #--------------------------------------------------------------------------
  # * Turn Toward Character
  #--------------------------------------------------------------------------
  def turn_toward_character(character)
    return @direction if character.pos == pos
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    if sx.abs > sy.abs
      re = set_direction(sx > 0 ? 4 : 6)
    elsif sy != 0
      re = set_direction(sy > 0 ? 8 : 2)
    end
    return re
  end
  #--------------------------------------------------------------------------
  def target_front_position(range)
    pos = POS.new(@x, @y)
    case @direction
    when 2
      pos.y = [pos.y + range, $game_map.height - 1].min
    when 4
      pos.x = [pos.x - range, 0].max
    when 6
      pos.x = [pos.x + range, $game_map.width - 1].min
    when 8
      pos.y = [pos.y - range, 0].max
    end
    return pos
  end
  #--------------------------------------------------------------------------
  # * Don't do anything
  #--------------------------------------------------------------------------
  def halt?
    return true if casting?
    return true if frozen?
    return false
  end
  #--------------------------------------------------------------------------
  def casting?
    return false if @action.nil?
    return true  if @casting_flag
    return true  if @action.casting?
    return false
  end
  #--------------------------------------------------------------------------
  def casting_index
    @character_index
  end
  #--------------------------------------------------------------------------
  def get_ammo_item(item)
  end
  #--------------------------------------------------------------------------
  def secure_hash
    return unless battler
    battler.secure_hash
  end
  #--------------------------------------------------------------------------
  def through_character?
    return true  if @through_character || @through
    return false if battler == self
    return battler.state?(PONY::StateID[:free_movement])
  end
  #--------------------------------------------------------------------------
  def altitude=(_new)
    @altitude = _new
  end
  #--------------------------------------------------------------------------
  def visible_sight
    return 5
  end
  #--------------------------------------------------------------------------
  # * Move away from character if given character can see self
  #--------------------------------------------------------------------------
  def escape_from_threat(threat)
    return if distance_to_character(threat) > threat.visible_sight
    move_away_from_character(threat)
  end
  #--------------------------------------------------------------------------
  def effectus_near_the_screen?
    true
  end
  #--------------------------------------------------------------------------
  def setup_quadtree_index
    @last_quadtree_index = $game_map.get_quadtree_index(@x, @y)
    $game_map.collision_quadtree[@last_quadtree_index] << self
  end
  #--------------------------------------------------------------------------
  def update_quadtree_index
    quadtree = $game_map.collision_quadtree
    new_index = $game_map.get_quadtree_index(@x, @y)
    return if new_index == @last_quadtree_index
    @quadtree_index = new_index
    #puts "#{name} #{@last_quadtree_index}" if self.is_a?(Game_Player) || distance_to_character($game_player) < 5
    begin
      quadtree[new_index] << quadtree[@last_quadtree_index].delete(self)
    rescue Exception => e
      msgbox [name, @last_quadtree_index]
      raise e
    end
    @last_quadtree_index = new_index
  end
  #--------------------------------------------------------------------------
end
