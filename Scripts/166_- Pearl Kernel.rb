#===============================================================================
# * Falcao Pearl ABS script shelf # 1
#
# This script is the Heart of Pearl ABS Liquid, it handles all the character
# management, the tools variables and the input module, enemy registration etc.
#===============================================================================
#===============================================================================
#===============================================================================
# Game character
class Game_CharacterBase
  #----------------------------------------------------------------------------
  attr_accessor :just_hitted, :anime_speed, :blowpower, :targeting, :x, :y
  attr_accessor :battler_guarding, :knockdown_data, :colapse_time, :opacity
  attr_accessor :zoomfx_x, :zoomfx_y, :targeted_character, :stuck_timer
  attr_accessor :send_dispose_signal, :follower_attacktimer, :stopped_movement
  attr_accessor :hookshoting, :battler_chain, :pattern, :user_move_distance
  attr_accessor :move_speed, :through, :being_grabbed, :making_spiral
  attr_accessor :direction, :direction_fix, :zfx_bol, :buff_pop_stack
  attr_accessor :die_through, :target_index, :using_custom_g, :combodata
  attr_accessor :originalasp, :doingcombo, :angle_fx
  attr_accessor :user_iconset, :pro_iconset, :respawn_count
  #----------------------------------------------------------------------------
  #----------------------------------------------------------------------------
  # *) Initialize Object
  #----------------------------------------------------------------------------
  alias falcaopearl_abmain_ini initialize
  def initialize
    @zfx_bol = false
    @just_hitted = 0
    @anime_speed = 0
    @respawn_count = 0
    @blowpower = [0, dir=2, dirfix=false, s=4, wait_reset=0]
    @user_casting = [0, nil]
    @send_dispose_signal = false
    @targeting = [false, item=nil, char=nil]
    @colapse_time = 0
    @stopped_movement = 0
    @follower_attacktimer = 0
    set_hook_variables
    @target_index = 0
    @using_custom_g = false
    @combodata = []
    @angle_fx = 0.0
    #--------------
    @zoomfx_x = 1.0
    @zoomfx_y = 1.0
    @stuck_timer = 0
    @battler_guarding = [false, nil]
    @knockdown_data = [0, nil, nil, nil, nil]
    @state_poptimer = [0, 0]
    @making_spiral = false
    @buff_pop_stack = []
    @doingcombo = 0
    @range_view = 2
    @originalasp = 0
    falcaopearl_abmain_ini
  end
  
  def set_hook_variables
    @hookshoting = [on=false, hooking=false, grabing=false, delay=0]
    @battler_chain = []
    @user_move_distance = [steps=0, speed=nil, trought=nil, cor=nil, evmove=nil]
    @being_grabbed = false
  end
 
  # projectiles at nt
  def projectiles_xy_nt(x, y)
    $game_player.projectiles.select {|pro| pro.pos_nt?(x, y) }
  end
  
  # collide with projectiles
  def collide_with_projectiles?(x, y)
    projectiles_xy_nt(x, y).any? do |pro|
      pro.normal_priority? || self.is_a?(Projectile)
    end
  end
  
  def zoom(x, y)
    @zoomfx_x = x
    @zoomfx_y = y
  end
  
  alias falcaopearl_collide_with collide_with_characters?
  def collide_with_characters?(x, y)
    return true if collide_with_projectiles?(x, y)
    falcaopearl_collide_with(x, y)
  end
  
  # follow character straigh and diagonal
  def follow_char(character)
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    if sx != 0 && sy != 0
      move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
    elsif sx != 0
      move_straight(sx > 0 ? 4 : 6)
    elsif sy != 0
      move_straight(sy > 0 ? 8 : 2)
    end
  end
  
  def on_battle_screen?(out = 0)
    max_w = (Graphics.width / 32).to_i - 1
    max_h = (Graphics.height / 32).to_i - 1
    sx = (screen_x / 32).to_i
    sy = (screen_y / 32).to_i
    if sx.between?(0 - out, max_w + out) and sy.between?(0 - out, max_h + out)
      return true
    end
    return false
  end
  
   # jump to specific tiles
  def jumpto_tile(x, y)
    jumpto(0, [x, y])
  end
  
  # jumpto character ( 0 = Game Player, 1 and up event id)
  def jumpto(char_id, tilexy=nil)
    char_id > 0 ? char = $game_map.events[char_id] : char = $game_player
    tilexy.nil? ? condxy = [char.x, char.y] : condxy = [tilexy[0], tilexy[1]]
    jx = + eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] >= @x
    jy = - eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] <= @y
    jx = - eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] <= @x
    jy = - eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] <= @y
    jx = - eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] <= @x
    jy = + eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] >= @y
    jx = + eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] >= @x
    jy = + eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] >= @y
    jump(jx, jy)
  end
  
  # distance
  def eval_distance(target)
    if target.is_a?(Array)
      distance_x = (@x - target[0]).abs
      distance_y = (@y - target[1]).abs
    else
      distance_x = (@x - target.x).abs
      distance_y = (@y - target.y).abs
    end
    return [distance_x, distance_y] 
  end
  
  # check if the game player and follower are executing an action
  def battler_acting?
    return true if @user_casting[0] > 0 || @targeting[0]
    return true if @knockdown_data[0] > 0 and battler.deadposing.nil?
    return true if @anime_speed > 0
    return true if @hookshoting[0] || @making_spiral
    if self.is_a?(Game_Player)
      $game_player.followers.each {|f| return true if f.battler_acting?}
    end
    return false
  end
  def battler
  end
  
  #use single tools
  def use_weapon(id)
    return unless tool_can_use?
    process_tool_action($data_weapons[id])
  end
  
  def use_item(id)
    return unless tool_can_use?
    process_tool_action($data_items[id])
  end
  
  def use_skill(id)
    return unless tool_can_use?
    process_tool_action($data_skills[id])
  end
  
  def use_armor(id)
    return unless tool_can_use?
    process_tool_action($data_armors[id])
  end
  
  # use multiple tools
  def rand_weapon(*args)
    return unless tool_can_use?
    process_tool_action($data_weapons[args[rand(args.size)]])
  end
  
  def rand_item(*args)
    return unless tool_can_use?
    process_tool_action($data_items[args[rand(args.size)]])
  end
  
  def rand_skill(*args)
    return unless tool_can_use?
    process_tool_action($data_skills[args[rand(args.size)]])
  end
  
  def rand_armor(*args)
    return unless tool_can_use?
    process_tool_action($data_armors[args[rand(args.size)]])
  end
  
  def tool_can_use?
    return false if @hookshoting[0] || @making_spiral
    return false if @user_casting[0] > 0 || @targeting[0]
    return false if battler.nil?
    return false if battler.dead?
    return false if @doingcombo > 0 || @battler_guarding[0]
    return false if $game_message.busy?
    return true
  end
  #---------------------------------------------------------------------------
  #  *) load target selection
  # tag: target
  #---------------------------------------------------------------------------
  def load_target_selection(item)
    @targeting[0] = true; @targeting[1] = item
    if self.is_a?(Game_Player)
      $game_player.pearl_menu_call = [:battler, 2]
    elsif self.is_a?(Game_Follower)
      @targeting[2] = @targeted_character
      @targeting = [false, item=nil, char=nil] if @targeting[2].nil?
    elsif self.is_a?(Projectile)
      if user.is_a?(Game_Player)
        user.targeting[0] = true; user.targeting[1] = item
        $game_player.pearl_menu_call = [:battler, 2]
      end
      if user.is_a?(Game_Follower)
        @targeting[2] = user.targeted_character
        @targeting = [false, item=nil, char=nil] if @targeting[2].nil?
      end
    end
  end
  
  def playdead
    @angle_fx = 90
  end
  
  def resetplaydead
    @angle_fx = 0.0
  end
  #action canceling
  def force_cancel_actions
    @user_casting[0] = 0
    @anime_speed = 0
  end
  
  def speed(x)
    @move_speed = x
  end
  
  def anima(x)
    @animation_id = x
  end
  #----------------------------------------------------------------------------
  # aply melee params
  #----------------------------------------------------------------------------
  def apply_weapon_param(weapon, add)
    id = 0
    for param in weapon.params
      add ? battler.add_param(id, param) : battler.add_param(id, -param)
      id += 1
    end
  end
  #----------------------------------------------------------------------------
  #   Short script call for poping damage text
  #----------------------------------------------------------------------------
  def pop_damage(custom=nil)
    $game_player.damage_pop.push(DamagePop_Obj.new(self, custom))
  end
  #----------------------------------------------------------------------------
  # *) Determind effective range
  #----------------------------------------------------------------------------
  def determind_effective_range(range)
    range *= 2
    case direction
    when 2; return [0,range]
    when 4; return [-range,0]
    when 6; return [range,0]
    when 8; return [0,-range]
    end
  end
  #----------------------------------------------------------------------------
  # *) check if target is unable to move
  #----------------------------------------------------------------------------
  def force_stopped?
    return true if @anime_speed > 0 || @knockdown_data[0] > 0 ||
    @stopped_movement > 0 || @hookshoting[0] || @angle_fx != 0.0
    return true if @making_spiral
    return false
  end
  #----------------------------------------------------------------------------
  # *) sensor
  #----------------------------------------------------------------------------
  def obj_size?(target, size)
    return false if size.nil?
    distance = Math.hypot(@x - target.x, @y - target.y)
    enable   = (distance <= size - 0.5)
    return true if enable
    return false
  end
  
  #----------------------------------------------------------------------------
  # *) sensor body
  #----------------------------------------------------------------------------
  def body_size?(target, size, source = nil)
    #target: target x and y
    return true if (target[0] - @x).abs < 0.4 && (target[1] - @y).abs < 0.4
    return false if Math.hypot(target[0] - @x, target[1] - @y) > size
    ex = @user.x * 4 + @user.determind_effective_range(size).at(0)
    ey = @user.y * 4 + @user.determind_effective_range(size).at(1)
    enable = (target[0]*4 - ex).abs < 3 && (target[1]*4 - ey).abs < 3
    enable ||= @user.face_toward_character?(source, size) if source
    return enable
  end
  #----------------------------------------------------------------------------
  # *) face to face
  #----------------------------------------------------------------------------
  def faceto_face?(target)
    return (target.direction + @direction) == 10
  end
  
  def adjustcxy
    push_x, push_y =   0,   1 if @direction == 2
    push_x, push_y = - 1,   0 if @direction == 4
    push_x, push_y =   1,   0 if @direction == 6
    push_x, push_y =   0, - 1 if @direction == 8
    return [push_x, push_y]
  end
  
  def in_frontof?(target)
    return true if @direction == 2 and @x == target.x and (@y+1) == target.y
    return true if @direction == 4 and (@x-1) == target.x and @y == target.y
    return true if @direction == 6 and (@x+1) == target.x and @y == target.y
    return true if @direction == 8 and @x == target.x and (@y-1) == target.y
    return false
  end
  
  # detect map edges ignoring loop maps
  def facing_corners?
    case $game_map.map.scroll_type
    when 1 then return false if @direction == 2 || @direction == 8
    when 2 then return false if @direction == 4 || @direction == 6
    when 3 then return false
    end
    m = $game_map
    unless @x.between?(1, m.width - 2) && @y.between?(1, m.height - 2)
      return true if @x == 0 and @direction == 4
      return true if @y == 0 and @direction == 8
      return true if @x == m.width  - 1  and @direction == 6
      return true if @y == m.height - 1  and @direction == 2
    end
    return false
  end
  
  # item usable test
  def usable_test_passed?(item)
    return true if battler.is_a?(Game_Enemy) && item.is_a?(RPG::Item)
    itemcost = item.tool_data("Tool Item Cost = ")
    invoke = item.tool_data("Tool Invoke Skill = ")
    @hint_cooldown = 0 if @hint_cooldown.nil?
    @hint_cooldown -= 1 if @hint_cooldown > 0
    
    if battler.is_a?(Game_Actor) and itemcost != nil and itemcost != 0
      if !battler.usable?($data_items[itemcost])        
        
        if @hint_cooldown == 0
          #text = sprintf("%s - run out of %s", battler.name, $data_items[itemcost].name)
          #$game_map.interpreter.gab(text)
          SceneManager.display_info(text)
          @hint_cooldown = 120
        end
        
        return false
      end
    end
    if item.is_a?(RPG::Skill) || item.is_a?(RPG::Item)
      return false if !battler.usable?(item)
    else
      if invoke != nil and invoke != 0
        return false if !battler.usable?($data_skills[invoke])
      else
        return false if !battler.attack_usable?
      end
    end
    return true
  end
  
  # process the tool and verify wheter can be used
  # tag: attack
  # tag: item
  # tag: tool
  def process_tool_action(item)
    PearlKernel.load_item(item)
    return if !battler.tool_ready?(item)
    
    unless PearlKernel.has_data?
      if item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
        msgbox('Tool data missing') if $DEBUG
        return
      end
      if item.scope.between?(1, 6)
        msgbox('Tool data missing') if $DEBUG
        return
      elsif item.scope == 0
        return
        
      elsif !battler.usable?(item)
        RPG::SE.new("Cursor1", 80).play if self.is_a?(Game_Player)
        return 
      end
    end
    
    if PearlKernel.has_data? and not usable_test_passed?(item)
      RPG::SE.new("Cursor1", 80).play if self.is_a?(Game_Player)
      return
    end
    
    @user_casting = [PearlKernel.tool_castime,item] if PearlKernel.has_data?
    if @user_casting[0] > 0
      @animation_id = 0
      @animation_id = PearlKernel.tool_castanimation
    else
      load_abs_tool(item)
    end
  end
  #----------------------------------------------------------------------------
  # *) load the abs tool
  # tag: target
  #----------------------------------------------------------------------------
  def load_abs_tool(item)
    return if @knockdown_data[0] > 0
    PearlKernel.load_item(item)
  
    return if self.is_a?(Game_Follower) and @targeted_character.nil?
    
    if !@targeting[0] and  self.battler.is_a?(Game_Actor)
      if item.is_a?(RPG::Skill) || item.is_a?(RPG::Item)
        # apply target to skills items 
        if PearlKernel.tool_target == "true" || item.scope == 7 ||
          item.scope == 9
          load_target_selection(item)
          return
        end
      else
        # apply target parsing the invoked skill to weapons and armors
        invoke = PearlKernel.tool_invoke
        if invoke != nil && invoke > 0 && invoke != 1 && invoke != 2
          invokeskill = $data_skills[invoke]
          if PearlKernel.tool_target == "true" || invokeskill.scope == 7 ||
            invokeskill.scope == 9
            load_target_selection(item)
            return
          end
          # apply target to normal weapon and armor without invoking
        else
          if PearlKernel.tool_target == "true"
            load_target_selection(item)
            return
          end
        end
      end
    end
    
    if item.is_a?(RPG::Skill) || item.is_a?(RPG::Item)
      battler.use_item(item) 
      
    else
      if PearlKernel.tool_invoke != 0
        battler.use_item($data_skills[PearlKernel.tool_invoke])
      end
    end
    
    # if the tool has data continue
    if PearlKernel.has_data?
      consume_ammo_item(item) if battler.is_a?(Game_Actor) && item.tool_itemcost != 0
      @anime_speed = PearlKernel.user_animespeed
      battler.apply_cooldown(item, PearlKernel.tool_cooldown)
    end
    create_projectile_object(item)
    create_anime_sprite_object(item)
  end
  
  # projectile creator
  def create_projectile_object(item)
    if PearlKernel.tool_special == "hook"
      PearlKernel.tool_distance.times {|i|
      $game_player.projectiles.push(Projectile.new(self, item, i))}
      @hookshoting[0] = true
    elsif PearlKernel.tool_special == "triple"       # loads 3 projectiles
      for i in [:uno, :dos, :tres]
        $game_player.projectiles.push(Projectile.new(self, item, i))
      end
    elsif PearlKernel.tool_special == "quintuple"     #loads 5 projectiles
      for i in [:uno, :dos, :tres, :cuatro, :cinco]
        $game_player.projectiles.push(Projectile.new(self, item, i))
      end
    elsif PearlKernel.tool_special == "octuple"       # loads 8 projectiles
      for i in [:uno, :dos, :tres, :cuatro, :cinco, :seis, :siete, :ocho]
        $game_player.projectiles.push(Projectile.new(self, item, i))
      end
    else # load default projectile
      $game_player.projectiles.push(Projectile.new(self, item))
    end
  end
  
  # User anime sprite creation
  def create_anime_sprite_object(item)
    $game_player.anime_action.each {|i|
    if i.user == self
      if i.custom_graphic
        @transparent = false 
        i.user.using_custom_g = false
      end
      $game_player.anime_action.delete(i)
    end}
    
    if PearlKernel.user_graphic != "nil"
      return if PearlKernel.user_graphic.nil?
      $game_player.anime_action.push(Anime_Obj.new(self, item))
    end
    
    # using iconset graphic
    if PearlKernel.user_graphic == "nil" and
      !item.tool_data("User Iconset = ", false).nil?
      return if PearlKernel.user_graphic.nil?
      $game_player.anime_action.push(Anime_Obj.new(self, item))
    end
  end
  
  # consume ammo item
  def consume_ammo_item(item)
    itemcost = $data_items[PearlKernel.tool_itemcost]
    return if item.is_a?(RPG::Item) and item.consumable and item == itemcost
    battler.use_item(itemcost)
  end
  
  alias falcaopearl_chaupdate update
  def update
    update_falcao_pearl_abs
    falcaopearl_chaupdate
  end
  #---------------------------------------------------------------------------
  # Falcao pearl abs main update
  #---------------------------------------------------------------------------
  def update_falcao_pearl_abs
    if @user_move_distance[0] > 0 and not moving?
      move_forward ; @user_move_distance[0] -= 1
    end
    return if battler.nil?
    update_pearlabs_timing
    update_followers_attack if self.is_a?(Game_Follower) && self.visible?
    
    if @targeting[2] != nil
      load_abs_tool(@targeting[1]) if battler.is_a?(Game_Actor)
      @targeting = [false, item=nil, char=nil]
    end
    update_battler_collapse
    update_state_effects
    
    @combodata.each {|combo|
    if combo[3] > 0
      combo[3] -= 1
      if combo[3] == 0
        perform_combo(combo[0], combo[1], combo[2])
        @combodata.delete(combo)
      end
      break
    end}
  end
  #---------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------
  def perform_combo(kind, id, jumpp)
    if jumpp == 'jump'
      jump(0, 0)
      move_forward
    end
    case kind
    when :weapon then use_weapon(id)
    when :armor  then use_armor(id)
    when :item   then use_item(id)
    when :skill  then use_skill(id)
    end
    @doingcombo = 12
  end
  
  #-------------------------------------------------
  
  # buff timer 
  def update_buff_timing
    battler.buff_turns.each do |id, value|
      if battler.buff_turns[id] > 0
        battler.buff_turns[id] -= 1
        if battler.buff_turns[id] <= 0
          battler.remove_buff(id)
          pop_damage
        end
      end
    end
  end
  
  #blow power effect
  def update_blow_power_effect
    if @blowpower[4] > 0
      @blowpower[4] -= 1
      if @blowpower[4] == 0
        @direction_fix = @blowpower[2]
        @move_speed = @blowpower[3]
      end
    end
    if @blowpower[0] > 0 and !moving?
      @move_speed = 5.5
      @direction_fix = true
      move_straight(@blowpower[1]); @blowpower[0] -= 1
      if @blowpower[0] == 0
        @blowpower[4] = 10
      end
    end
  end
  
  # Pearl timing
  def update_pearlabs_timing
    @just_hitted -= 1 if @just_hitted > 0
    @stopped_movement -= 1 if @stopped_movement > 0
    @doingcombo -= 1 if @doingcombo > 0
    
    # hookshooting
    if @hookshoting[3] > 0
      @hookshoting[3] -= 1
      if @hookshoting[3] == 0
        @hookshoting = [false, false, false, 0] 
        @user_move_distance[3].being_grabbed = false if
        @user_move_distance[3].is_a?(Game_Event)
        @user_move_distance[3] = nil
      end
    end
    update_buff_timing
    update_blow_power_effect
    # anime 
    if @anime_speed > 0
      @pattern = 0 
      @anime_speed -= 1
    end
    # casting
    if @user_casting[0] > 0
      @user_casting[0] -= 1
      load_abs_tool(@user_casting[1]) if @user_casting[0] == 0 
    end
    update_knockdown
  end
  
  # Update battler collapse
  
  def check_for_dead_four
    return if $game_party.members.size <= 4
    SceneManager.goto(Scene_Gameover) if all_fourdead?
  end
 
  def all_fourdead?
    m = $game_party.battle_members
    return true if m[0].dead? && m[1].dead? && m[2].dead? && m[3].dead?
    return false
  end
  
  def update_battler_collapse
    if @colapse_time > 0
      @colapse_time -= 1 
      force_cancel_actions
      if battler.is_a?(Game_Actor)
        Sound.play_actor_collapse if @secollapse.nil?
        @secollapse = true
        
        if @colapse_time == 0
          @secollapse = nil
          for event in $game_map.event_enemies 
            if event.agroto_f == self
              event.agroto_f = nil
            end
          end
          
          check_for_dead_four
          member = $game_party.battle_members
          # swap and reset player
          if self.is_a?(Game_Player)
            reset_knockdown_actors
            battler.deadposing = $game_map.map_id if PearlKernel::FollowerDeadPose
            $game_party.swap_order(0,3) if !member[3].nil? and !member[3].dead?
            $game_party.swap_order(0,2) if !member[2].nil? and !member[2].dead?
            $game_party.swap_order(0,1) if !member[1].nil? and !member[1].dead?
          else
            if PearlKernel::FollowerDeadPose
              battler.deadposing = $game_map.map_id
              if !$game_player.follower_fighting? and member.size > 2
                swap_dead_follower
              else
                $game_player.reserved_swap << battler.id if member.size > 2
              end
            end
          end
        end
        
      elsif battler.is_a?(Game_Enemy)
        @die_through = @through if @die_through.nil?
        @through = true
        apply_collapse_anime(battler.collapse_type)
        @secollapse = true
        battler.object ? @transparent = true : @opacity -= 2 if !@deadposee
        if @colapse_time == 0
          self.kill_enemy
        end
      end
    end
  end
  
  def swap_dead_follower
    reset_knockdown_actors
    member = $game_party.battle_members
    member.each_with_index.each do |actorr, i|
      next unless actorr.id == self.actor.id
      case member.size
      when 3
        break if i == 2
        $game_party.swap_order(i, 2)
      when 4
        break if i == 3
        if !member[3].dead?
          $game_party.swap_order(i, 3) 
          break
        end
        if !member[2].dead?  
          $game_party.swap_order(i, 2) 
          break
        end
      end
    end
  end
  def apply_collapse_anime(type)
    # sound and animation
    if battler.die_animation != nil
      @animation_id = battler.die_animation if @secollapse.nil?
    else
      Sound.play_enemy_collapse if @secollapse.nil? and !battler.object
    end
    return if battler.object
    if @deadposee
      @knockdown_data[0] = 8
      return
    end
    type = PearlKernel::DefaultCollapse if type.nil?
    case type.to_sym
    when :zoom_vertical
      @zoomfx_x -= 0.03
      @zoomfx_y += 0.02
    when :zoom_horizontal
      @zoomfx_x += 0.03
      @zoomfx_y -= 0.02
    when :zoom_maximize
      @zoomfx_x += 0.02
      @zoomfx_y += 0.02
    when :zoom_minimize
      @zoomfx_x -= 0.02
      @zoomfx_y -= 0.02
    end
  end
  
  # konck down engine update
  def update_knockdown
    if @knockdown_data[0] > 0
      @knockdown_data[0] -= 1
      @knockdown_data[0] == 0 ? knowdown_effect(2) : knowdown_effect(1)
      if @knockdown_data[1] != nil
        @pattern = @knockdown_data[2]
        @direction = @knockdown_data[3]
      end
    end
  end
  
  def knowdown_effect(type)
    return if self.is_a?(Projectile)
    if type[0] == 1
      if @knockdown_data[1] == nil
        if battler.is_a?(Game_Enemy)
          if self.knockdown_enable
            force_cancel_actions
            self_sw = PearlKernel::KnockdownSelfW
            $game_self_switches[[$game_map.map_id, self.id, self_sw]] = true
            @knockdown_data[1] = self_sw
            self.refresh
            @knockdown_data[2] = self.page.graphic.pattern
            @knockdown_data[3] = self.page.graphic.direction
            $game_map.screen.start_shake(7, 4, 20)
          end
          
          @knockdown_data[0] = 0 if @knockdown_data[1] == nil
       elsif battler.is_a?(Game_Actor)
         if PearlKernel.knock_actor(self.actor) != nil and
           if @knockdown_data[1] == nil
             force_cancel_actions
             @knockdown_data[1] = @character_name
             @knockdown_data[4] = @character_index
             @character_name = PearlKernel.knock_actor(self.actor)[0]
             @character_index = PearlKernel.knock_actor(self.actor)[1]
             @knockdown_data[2] = PearlKernel.knock_actor(self.actor)[2]
             @knockdown_data[3] = PearlKernel.knock_actor(self.actor)[3]
             $game_map.screen.start_shake(7, 4, 20) if battler.deadposing.nil?
           end
         end
         @knockdown_data[0] = 0 if @knockdown_data[1] == nil
        end
      end
    elsif type == 2
      if battler.is_a?(Game_Enemy)
        if @deadposee and battler.dead?
          @knockdown_data[1] = nil
          return 
        end
        $game_self_switches[[$game_map.map_id, self.id, 
        @knockdown_data[1]]] = false if @knockdown_data[1] != nil
        @knockdown_data[1] = nil
      else
        @character_name = @knockdown_data[1]
        @character_index = @knockdown_data[4]
        @knockdown_data[1] = nil
      end
    end
  end
  
  #================================
  # states
  def primary_state_ani
    return nil if battler.states[0].nil?
    return battler.states[0].tool_data("State Animation = ")
  end
  
  # higer priority state animation displayed
  def update_state_effects
    return if battler.nil?
    @state_poptimer[0] += 1 unless primary_state_ani.nil?
    if @state_poptimer[0] == 30
      @animation_id = primary_state_ani
      @animation_id = 0 if @animation_id.nil?
    elsif @state_poptimer[0] == 180
      @state_poptimer[0] = 0
    end
    update_state_action_steps 
  end
  
  # update state actions
  def update_state_action_steps
    for state in battler.states
      if state.remove_by_walking
        if !battler.state_steps[state.id].nil? &&
          battler.state_steps[state.id] > 0
          battler.state_steps[state.id] -= 1 
        end
        if battler.state_steps[state.id] == 0
          battler.remove_state(state.id)
          pop_damage
        end
      end
      if state.restriction == 4
        @stopped_movement = 10
        @pattern = 2 if @knockdown_data[0] == 0
      end
      state.features.each do |feature|
        if feature.code == 22 
          @knockdown_data[0] =10 if state.restriction == 4 && feature.data_id==1
          next unless feature.data_id.between?(7, 9)
          apply_regen_state(state, feature.data_id)
        end
      end
    end
  end
  
  # apply regen for hp, mp and tp
  def apply_regen_state(state, type)
    random = state.tool_data("State Effect Rand Rate = ") 
    random = 120 if random.nil?
    if rand(random) == 1
      battler.regenerate_hp if type == 7
      battler.regenerate_mp if type == 8
      battler.regenerate_tp if type == 9
      if type == 7 and battler.result.hp_damage == 0
        @colapse_time = 80
        battler.add_state(1)
        return
      end
      type == 9 ? pop_damage("Tp Up!") : pop_damage
    end
  end
  
  alias falcaopearl_update_anime_pattern update_anime_pattern
  def update_anime_pattern
    return if @anime_speed > 0 || @knockdown_data[0] > 0
    falcaopearl_update_anime_pattern
  end
  
  #=============================================================================
  # Reset Pearl ABS System
  
  # reset from game player call
  def reset_knockdown_actors
    # reset knock down
    if @knockdown_data[1] != nil
      @knockdown_data[0] = 0
      knowdown_effect(2)
    end
    # force clear knock down
    $game_player.followers.each do |follower|
      if follower.knockdown_data[1] != nil
        follower.knockdown_data[0] = 0
        follower.knowdown_effect(2)
      end
    end
  end
  
  # reset knockdown enemies game player call
  def reset_knockdown_enemies
    $game_map.events.values.each do |event|
      if event.knockdown_data[1] != nil
        event.knockdown_data[0] = 0
        event.knowdown_effect(2)
      end
      if event.deadposee and event.killed
        $game_self_switches[[$game_map.map_id, event.id,
        PearlKernel::KnockdownSelfW]] = false
      end
    end
  end
  
  # glabal reseting
  def pearl_abs_global_reset
    force_cancel_actions
    battler.remove_state(9) if @battler_guarding[0]
    @battler_guarding = [false, nil]
    @making_spiral = false
    set_hook_variables
    @using_custom_g = false
    $game_player.followers.each do |f|
      f.targeted_character = nil if !f.targeted_character.nil?
      f.stuck_timer = 0 if f.stuck_timer > 0
      f.follower_attacktimer = 0 if f.follower_attacktimer > 0
      f.force_cancel_actions unless f.visible?
      f.battler.remove_state(9) if f.battler_guarding[0]
      f.battler_guarding = [false, nil]
      f.set_hook_variables
      f.making_spiral = false
    end
    reset_knockdown_actors
    reset_knockdown_enemies
    $game_player.projectiles.clear
    $game_player.damage_pop.clear
    $game_player.anime_action.clear
    $game_player.enemy_drops.clear
    @send_dispose_signal = true
  end
end
#===============================================================================
# Evets as enemies registration
class Game_Event < Game_Character
  attr_accessor :enemy, :move_type, :page, :deadposee
  attr_accessor :being_targeted, :agroto_f, :draw_drop, :dropped_items
  attr_accessor :start_delay, :epassive, :erased, :killed, :boom_grabdata
  attr_reader   :token_weapon, :token_armor,:token_item,:token_skill,:boom_start
  attr_reader   :hook_pull, :hook_grab, :event, :knockdown_enable, :boom_grab
  attr_reader   :respawn_anim
  
  alias falcaopearlabs_iniev initialize
  def initialize(map_id, event)
    @inrangeev = nil
    @being_targeted = false
    @agroto_f = nil
    @draw_drop = false
    @dropped_items = []
    @epassive = false
    @touch_damage = 0
    @start_delay = 0
    @touch_atkdelay = 0
    @killed = false
    @knockdown_enable = false
    @deadposee = false
    @respawn_anim = 0
    create_token_arrays
    falcaopearlabs_iniev(map_id, event)
    register_enemy(event)
  end
  
  def create_token_arrays
    @token_weapon = []
    @token_armor  = []
    @token_item   = []
    @token_skill  = []
  end
  
  alias falcaopearl_setup_page_settings setup_page_settings
  def setup_page_settings
    create_token_arrays
    falcaopearl_setup_page_settings
    wtag = string_data("<start_with_weapon: ")
    @token_weapon = wtag.split(",").map { |s| s.to_i } if wtag != nil
    atag = string_data("<start_with_armor: ")
    @token_armor = atag.split(",").map { |s| s.to_i } if atag != nil
    itag = string_data("<start_with_item: ")
    @token_item = itag.split(",").map { |s| s.to_i } if itag != nil
    stag = string_data("<start_with_skill: ")
    @token_skill = stag.split(",").map { |s| s.to_i } if stag != nil
    @hook_pull = string_data("<hook_pull: ") == "true"
    @hook_grab = string_data("<hook_grab: ") == "true"
    @boom_grab = string_data("<boom_grab: ") == "true"
    @boom_start = string_data("<boomed_start: ") == "true"
    @direction_fix = false if @hook_grab
    if has_token? || @hook_pull || @hook_grab || @boom_grab || @boom_start
      $game_map.events_withtags.push(self) unless
      $game_map.events_withtags.include?(self)
    end
  end
  
  def has_token?
    !@token_weapon.empty? || !@token_armor.empty? || !@token_item.empty? ||
    !@token_skill.empty?
  end
  
  def register_enemy(event)
    
    if !$game_system.remain_killed[$game_map.map_id].nil? and
      $game_system.remain_killed[$game_map.map_id].include?(self.id)
      return
    end
    
    @enemy  = Game_Enemy.new(0, $1.to_i) if event.name =~ /<enemy: (.*)>/i
    if @enemy != nil
      passive = @enemy.enemy.tool_data("Enemy Passive = ", false)
      @epassive = true if passive == "true"
      touch = @enemy.enemy.tool_data("Enemy Touch Damage Range = ")
      @sensor = @enemy.esensor
      @touch_damage = touch if touch != nil
      $game_map.event_enemies.push(self) # new separate enemy list
      $game_map.enemies.push(@enemy)     # just enemies used in the cooldown
      @event.pages.each do |page|
        if page.condition.self_switch_valid and
          page.condition.self_switch_ch == PearlKernel::KnockdownSelfW
          @knockdown_enable = true
          break
        end
      end
      pose = @enemy.enemy.tool_data("Enemy Dead Pose = ", false) == "true"
      @deadposee = true if pose and @knockdown_enable
    end
  end
  
  def sensor; @sensor end
  
  def update_state_effects
    @killed ? return : super
  end
  
  def collapsing?
    return true if @killed || @colapse_time > 0
    return false
  end
  
  def enemy_ready?
    return false if @enemy.nil? || @page.nil? || collapsing? || @enemy.object
    return true
  end
  
  def battler
    return @enemy
  end
  
  def apply_respawn
    return if @colapse_time > 0
    @draw_drop = false
    @dropped_items.clear
    @through = @die_through
    @through = false if @through.nil?
    @die_through = nil
    @secollapse = nil
    @colapse_time = 0
    @erased = false ; @opacity = 255
    @zoomfx_x = 1.0 ; @zoomfx_y = 1.0
    @killed = false
    @priority_type = 1 if @deadposee
    resetdeadpose
    refresh
  end
  
  def resetdeadpose
    if @deadposee
      $game_self_switches[[$game_map.map_id, @id,
      PearlKernel::KnockdownSelfW]] = false
    end
  end
  
  def kill_enemy
    @secollapse = nil
    @killed = true
    @priority_type = 0 if @deadposee
    gain_exp
    gain_gold
    etext = 'Exp '  + @enemy.exp.to_s if @enemy.exp > 0
    gtext = 'Gold ' + @enemy.gold.to_s if @enemy.gold > 0
    $game_player.pop_damage("#{etext} #{gtext}") if etext || gtext
    make_drop_items
    run_assigned_commands
  end
  
  def run_assigned_commands
    transform = @enemy.enemy.tool_data("Enemy Die Transform = ")
    switch = @enemy.enemy.tool_data("Enemy Die Switch = ")
    $game_switches[switch] = true if switch != nil
    variable = @enemy.enemy.tool_data("Enemy Die Variable = ")
    $game_variables[variable] += 1 if variable != nil
    self_sw = @enemy.enemy.tool_data("Enemy Die Self Switch = ", false)
    #$game_map.event_enemies.delete(self) if @enemy.object
    #$game_map.enemies.delete(@enemy) if @enemy.object
    if self_sw.is_a?(String)
      $game_self_switches[[$game_map.map_id, self.id, self_sw]] = true
      apply_respawn
      $game_map.event_enemies.delete(self)
      $game_map.enemies.delete(@enemy)
      unless $game_system.remain_killed.has_key?($game_map.map_id)
        $game_system.remain_killed[$game_map.map_id] = []
      end
      $game_system.remain_killed[$game_map.map_id].push(self.id) unless
      $game_system.remain_killed[$game_map.map_id].include?(self.id)
      @enemy = nil
    else
      erase unless @deadposee
      respawn = @enemy.enemy.tool_data("Enemy Respawn Seconds = ")
      animation = @enemy.enemy.tool_data("Enemy Respawn Animation = ")
      @respawn_count = respawn * 60 unless respawn.nil?
      
      @respawn_anim = animation unless animation.nil?
      
    end
    if transform != nil
      @enemy = Game_Enemy.new(0, transform)
      apply_respawn
    end
  end
  
  def make_drop_items
    @dropped_items = @enemy.make_drop_items
    unless @dropped_items.empty?
      $game_player.enemy_drops.push(self)
      $game_map.events_withtags.push(self) unless 
      $game_map.events_withtags.include?(self)
    end
  end
  
  def gain_exp
    return if @enemy.exp == 0
    $game_party.all_members.each do |actor|
      actor.gain_exp(@enemy.exp)
    end
  end
  
  def gain_gold
    return if @enemy.gold == 0
    $game_party.gain_gold(@enemy.gold)
  end
  
  alias falcaopearlabs_updatev update
  def update
    @start_delay -= 1 if @start_delay > 0
    @touch_atkdelay -= 1 if @touch_atkdelay > 0
    update_enemy_sensor unless @enemy.nil?
    update_enemy_touch_damage unless @enemy.nil?
    falcaopearlabs_updatev
  end
  
  def update_enemy_touch_damage
    return unless @touch_damage > 0
    return unless @character_name != ""
    return if @epassive || @killed
    return if @touch_atkdelay > 0
    unless @enemy.object
      @agroto_f.nil? ? target = $game_player : target = @agroto_f
    else
      target = $game_player
      $game_player.followers.each do |follower|
        next unless follower.visible?
        if obj_size?(follower, @touch_damage) and !follower.battler.dead?
          execute_touch_damage(follower)
        end
      end
    end
    execute_touch_damage(target) if obj_size?(target, @touch_damage)
  end
  
  def execute_touch_damage(target)
    target.battler.attack_apply(@enemy, @enemy.enemy.default_weapon)
    target.pop_damage
    @touch_atkdelay = 50
    target.colapse_time = 60 if target.battler.dead?
    return if target.battler.result.hp_damage == 0
    target.jump(0, 0)
  end
  #----------------------------------------------------------------------------
  # enemy sensor
  # tag: sight
  #----------------------------------------------------------------------------
  def update_enemy_sensor
    return if @hookshoting[0]
    return if @epassive
    if @sensor != nil
      target = @agroto_f.nil? ? $game_player : @agroto_f
      
      
      if in_sight?(target, @sensor)
        data = [$game_map.map_id, @id, PearlKernel::Enemy_Sensor]
        if @inrangeev.nil? and !$game_self_switches[[data[0], data[1], data[2]]]
          $game_self_switches[[data[0], data[1], data[2]]] = true
          @inrangeev = true
        end
      elsif @inrangeev != nil
        data = [$game_map.map_id, @id, PearlKernel::Enemy_Sensor]
        if $game_self_switches[[data[0], data[1], data[2]]] && !obj_size?(target, @sensor)
          $game_self_switches[[data[0], data[1], data[2]]] = false
          @inrangeev = nil
        end
      end
    end
  end
  
  # on battle pixel, take a lot of time procesing, but it is very exact
  def on_battle_pixel?(out=0)
    w = Graphics.width + out; h = Graphics.height + out
    return true if screen_x.between?(0 - out,w) and screen_y.between?(0 - out,h)
    return false
  end
  def cmt_data(comment)
    return 0 if @list.nil? or @list.size <= 0
    for item in @list
      if item.code == 108 or item.code == 408
        return $1.to_i if item.parameters[0] =~ /#{comment}(.*)>/i
      end
    end
    return 0
  end
  
  def string_data(comment)
    return nil if @list.nil? or @list.size <= 0
    for item in @list
      if item.code == 108 or item.code == 408
        return $1.to_s if item.parameters[0] =~ /#{comment}(.*)>/i
      end
    end
    return nil
  end
  
  # stop event movement
  alias falcaopearl_update_self_movement update_self_movement
  def update_self_movement
    return if !@boom_grabdata.nil?
    return if force_stopped? || @colapse_time > 0 || @blowpower[0] > 0
    falcaopearl_update_self_movement
  end
end
class Game_System
  attr_accessor :remain_killed
  alias falcao_fantastic_store_ini initialize
  def initialize
    falcao_fantastic_store_ini
    @remain_killed = {}
  end
end
#===============================================================================
# mist
class Game_Map
  attr_reader   :map
  attr_accessor :event_enemies, :enemies, :events_withtags
  alias falcaopearl_enemycontrol_ini initialize
  def initialize
    @event_enemies = []
    @enemies = []
    @events_withtags = []
    falcaopearl_enemycontrol_ini
  end
  
  alias falcaopearl_enemycontrol_setup setup
  def setup(map_id)
    @event_enemies.clear
    @enemies.clear
    @events_withtags.clear
    falcaopearl_enemycontrol_setup(map_id)
    if $game_temp.loadingg != nil
      @event_enemies.each do |event|
        event.resetdeadpose
      end
      $game_temp.loadingg = nil
    end
  end
  
  alias falcaopearl_damage_floor damage_floor?
  def damage_floor?(x, y)
    return if $game_player.hookshoting[1]
    falcaopearl_damage_floor(x, y)
  end
end
class Game_Temp
  attr_accessor :pop_windowdata, :loadingg
  def pop_w(time, name, text)
    return unless @pop_windowdata.nil?
    @pop_windowdata = [time, text, name]
  end
end
class Game_Party < Game_Unit
  
  alias falcaopearl_swap_order swap_order
  def swap_order(index1, index2)
    
    unless SceneManager.scene_is?(Scene_Map)
      
    if $game_player.in_combat_mode?
      elsif $game_player.any_collapsing?
        $game_temp.pop_w(180, 'Pearl ABS', 
        'You cannot switch player while collapsing!')
        return
      elsif $game_party.battle_members[index2].deadposing != nil
         $game_temp.pop_w(180, 'Pearl ABS', 
        'You cannot move a dead ally!')
        return
      end
    end
    $character_swapped = true
    pos1 = index1 == 0 ? [$game_player.x, $game_player.y] : [$game_player.followers[index1-1].x, $game_player.followers[index1 - 1].y]
    pos2 = index2 == 0 ? [$game_player.x, $game_player.y] : [$game_player.followers[index2-1].x, $game_player.followers[index2 - 1].y]
    
    if index1 == 0
      $game_player.moveto(pos2[0], pos2[1])
    else
      $game_player.followers[index1 - 1].moveto(pos2[0], pos2[1])
    end
    if index2 == 0
      $game_player.moveto(pos1[0], pos1[1])
    else
      $game_player.followers[index2 - 1].moveto(pos1[0], pos1[1])
    end
    
    falcaopearl_swap_order(index1, index2)
    $game_map.need_refresh = true
    $tbs_cursor.moveto($game_player.x, $game_player.y)
  end
end
class << DataManager
  alias falcaopearl_extract extract_save_contents
  def DataManager.extract_save_contents(contents)
    falcaopearl_extract(contents)
    $game_temp.loadingg = true
  end
end
