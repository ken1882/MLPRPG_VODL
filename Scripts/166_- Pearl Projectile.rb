#===============================================================================
# * Falcao Pearl ABS script shelf # 2
#
# This script handles all the Projectiles in pearl ABS, this class is the
# responsable of manage each tool settings, do not touch anything or your
# pc will explode
#===============================================================================
class Projectile < Game_Character
  attr_accessor :draw_it, :destroy_it, :user, :tool_retracting, :customsteps
  attr_accessor :tool_distance, :original_distance, :agroto_f, :pick_able
  attr_accessor :tool_destroy_delay
  attr_reader   :ammo_proj
  #-------------------------------------------------------------------------------
  # Object Initialize
  #-------------------------------------------------------------------------------
  def initialize(user, item, custom = nil, ammo_proj = false)
    super()
    PearlKernel.load_item(item)
    @tool_special = PearlKernel.tool_special
    @draw_it = false
    @destroy_it = false
    @user    = user
    @item = item
    load_ammo_index if ammo_proj
    @step_anime = true
    @through = true if PearlKernel.tool_through == "true"
    @through = false if PearlKernel.tool_through.nil?
    
    moveto(user.x, user.y)
    set_direction(user.direction)
    @customsteps = custom if custom.is_a?(Fixnum)
    @original_item = @item
    @target_effect = [false, target=nil]
    
    @tool_special = "autotarget" if user.is_a?(Game_Follower) || (user.is_a?(Game_Player) && $game_party.leader.state?(2))
    set_targeting
    
    return if PearlKernel.user_graphic.nil?
    load_item_data
    jump(0, 0) if @user.passable?(@user.x, @user.y, @user.direction) and
    PearlKernel.tool_shortjump == "true"
    if @tool_special == "triple"
      @triple = custom
      move_forward if @tool_distance > 2
    elsif @tool_special == "quintuple"
      @quintuple = custom
      move_forward if @tool_distance > 2
    elsif @tool_special == "octuple"
      @octuple = custom
      if @octuple == :seis || @octuple == :siete || @octuple == :ocho
        @direction = 8 if @user.direction == 2
        @direction = 6 if @user.direction == 4
        @direction = 4 if @user.direction == 6
        @direction = 2 if @user.direction == 8
      end
    elsif @tool_special.split(" ").include?('common_event') 
      @commonevent_id = @tool_special.sub("common_event ","").to_i
      for i in $data_common_events[@commonevent_id].list
        if i.code == 205
          force_move_route(i.parameters[1])
        end
      end
      @tool_distance = 0
    end
    @move_speed == 6 ? @mini_opacity = 7 : @mini_opacity = 9
    @opacity = 0
    check_combo_effect
    apply_item_transform if @item.is_a?(RPG::Weapon) || @item.is_a?(RPG::Armor)
  end
  #-------------------------------------------------------------------------------
  # combo
  #-------------------------------------------------------------------------------
  def check_combo_effect
    c = PearlKernel.tool_combo
    return if c == 'nil' || c.nil?
    c = c.split(", ")
    return unless rand(101) <= c[2].to_i
    case c[0]
    when 'weapon' then @user.combodata << [:weapon, c[1].to_i, c[3], 20]
    when 'armor'  then @user.combodata << [:armor,  c[1].to_i, c[3], 20]
    when 'item'   then @user.combodata << [:item,   c[1].to_i, c[3], 20]
    when 'skill'  then @user.combodata << [:skill,  c[1].to_i, c[3], 20]
    end
    @has_combo = true
  end
  #-------------------------------------------------------------------------------
  # Get projectile battler, it take the properies of the user
  #-------------------------------------------------------------------------------
  def battler
    return nil if @commonevent_id.nil?
    return @user.battler
  end
  #-------------------------------------------------------------------------------
  # make target
  #-------------------------------------------------------------------------------
  def set_targeting
    return if @tool_special == "hook" || @tool_special == "boomerang" ||
    @tool_special == "shield" || @tool_special == "spiral" || 
    @tool_special == "triple" || @tool_special == "quintuple" ||
    @tool_special == "autotarget" || @tool_special == "random" ||
    
    @commonevent_id != nil
    if @user.targeting[0]
      @target_effect = [@user.targeting[0], @user.targeting[2]]
      @user.turn_toward_character(@target_effect[1])
    end
    if PearlKernel.tool_target == "true" and @user.battler.is_a?(Game_Enemy)
      target = $game_player
      target = @user.agroto_f if @user.agroto_f != nil
      @user.targeting = [true, nil, target]
      @target_effect = [@user.targeting[0], @user.targeting[2]]
      @user.turn_toward_character(target)
    end
  end
  #-------------------------------------------------------------------------------
  #  *) Load item variables
  #-------------------------------------------------------------------------------
  def load_item_data
    @character_name = PearlKernel.tool_graphic
    if @character_name == "nil"
      @character_name = @user.character_name 
      @transparent = true
    end
    @character_index      = PearlKernel.tool_index
    @tool_size            = PearlKernel.tool_size
    @tool_distance        = PearlKernel.tool_distance * 8
    @tool_effect_delay    = PearlKernel.tool_effectdelay
    @tool_destroy_delay   = PearlKernel.tool_destroydelay
    @move_speed           = PearlKernel.tool_speed
    @tool_blow_power      = PearlKernel.tool_blowpower
    @tool_piercing        = PearlKernel.tool_piercing
    @tool_piercing        = PearlKernel.tool_piercing == "true"
    @tool_end_anime       = PearlKernel.tool_animation
    if @tool_end_anime.split(" ").include?('delay')
      @tool_end_anime = @tool_end_anime.sub("delay ","").to_i
    end
    @tool_animerepeat     = PearlKernel.tool_anirepeat == "true"
    @tool_invoke = PearlKernel.tool_invoke
    @tool_guardrate = PearlKernel.tool_guardrate
    @tool_knockdownrate = PearlKernel.tool_knockdown
    @tool_selfdamage = PearlKernel.tool_selfdamage == "true"
    @tool_hitshake = PearlKernel.tool_hitshake == "true"
    sound = PearlKernel.tool_soundse
    RPG::SE.new(sound, 80).play rescue nil # SOUND
    @original_distance = @tool_distance
    @mnganime = 0
    
    if @customsteps != nil
      @pattern = 0
      @tool_distance = @customsteps
      @pattern = 1 if @customsteps + 1 == @original_distance
      @transparent = true if @customsteps == 0
      @user.battler_chain.push(self)
    end
    @tool_retracting = false
    if @tool_special == "area" and @target_effect[0]
      @user.turn_toward_character(@target_effect[1])
      moveto(@target_effect[1].x, @target_effect[1].y)
    end
    
    @originaldestory_delay = @tool_destroy_delay
    @priority_type = PearlKernel.tool_priority
    
    if @tool_special == "spiral"
      @spintimer = 0
      @dir_was = @user.direction
      moveto(@user.x + @user.adjustcxy[0], @user.y + @user.adjustcxy[1]) if
      !@user.facing_corners?
      @spintimes = @tool_distance
      @tool_distance = 0
      @user.making_spiral = true
    end
    
    PearlKernel.check_iconset(@item, "Projectile Iconset = ", self)
    
    @character_name = "" if @pro_iconset != nil
    
    @pick_able = @item.note.include?('<pick up>')
    @ignore_followers = @item.note.include?('<ignore_followers>')
    if @tool_special != "shield" and !@item.note.include?('<ignore_voices>')
      voices = PearlKernel.voices(@user.battler)
      RPG::SE.new(voices[rand(voices.size)], 80).play unless voices.nil?
    end
    apply_item_transform if @item.is_a?(RPG::Weapon) || @item.is_a?(RPG::Armor)
  end
  #-------------------------------------------------------------------------------
  # *) Load Ammo index
  #-------------------------------------------------------------------------------
  def load_ammo_index
    return if !@user.battler.is_a?(Game_Actor)
    @ammo_proj = @user.battler.equips[2]
  end
  #-------------------------------------------------------------------------------
  # *) After loading tool variables check if the tool can be transformed (w/a)
  #-------------------------------------------------------------------------------
  def apply_item_transform
    if @tool_invoke > 0 and @tool_invoke != 1 and @tool_invoke != 2
      @item = $data_skills[@tool_invoke]
    end
  end
  #-------------------------------------------------------------------------------
  # *) item magical?
  #-------------------------------------------------------------------------------
  def magical_item?
    return true if @item.is_a?(RPG::Skill) || @item.is_a?(RPG::Item)
    return false
  end
  #-------------------------------------------------------------------------------
  # Frame update
  #-------------------------------------------------------------------------------
  def update
    super
    if magical_item?
      case @item.scope
      when 0 # scope 0 apply the effect to the user
        apply_self_effect(@user, true)
        return
      when 7 # heal one ally
        apply_effectto_selection
        return
      when 8 # heall all
        apply_effectto_all_allies
        return
      when 9 # revive one ally
        apply_effectto_selection
        return
      when 10 # revive all
        apply_effectto_all_allies
        return
      when 11 # to the user
        apply_self_effect(@user, true)
        return
      end
    end
    @precombi = @user.doingcombo > 0 if @precombi.nil?
    update_tool_token
   # continue when the scopes has not benefical effects
    if @target_effect[0]
      follow_char(@target_effect[1]) if !moving?
      @tool_distance = 0
    end
    @tool_distance = 0 if @tool_special == "area"
    update_timer
    
    #---------------------------------------------------------------------------
    # Tool special shield engine
    #---------------------------------------------------------------------------
    if @item.is_a?(RPG::Armor) and @tool_special == "shield"
      if !@user.battler_guarding[0]
        if @tool_invoke > 0
          @user.battler.melee_attack_apply(@user.battler,@tool_invoke)
        else
          @user.battler.item_apply(@user.battler, $data_skills[2])
        end
        @user.battler_guarding[0] = true
        @user.battler_guarding[1] = @tool_guardrate
        # shield directions
      elsif @user.battler_guarding[0]
        if @user.battler.is_a?(Game_Actor)
          if @user.is_a?(Game_Player)
            if PearlKey.press?(Key::Armor[0]) and 
              @tool_destroy_delay <= @originaldestory_delay - 16
              @tool_destroy_delay = 10
              @user.anime_speed = 10
            end
            @user.direction = 2 if Input.dir4 == 2
            @user.direction = 4 if Input.dir4 == 4
            @user.direction = 6 if Input.dir4 == 6
            @user.direction = 8 if Input.dir4 == 8
          end
        else
          if @user.is_a?(Game_Event) and @user.agroto_f != nil
            @user.turn_toward_character(@user.agroto_f)
          else
            @user.turn_toward_character($game_player)
          end
        end
      end
      if @tool_destroy_delay == 0
        @user.battler.remove_state(9)
        @user.battler_guarding = [false, nil]
      end
      return
    end
    
    # if not shield given continue
    update_hookshotdef if @customsteps != nil          # update hookshot
    update_boomerand if @tool_special == "boomerang"   # update boomerang
    update_spiral if @tool_special == "spiral"         # update spiral
    return if @transparent and @customsteps != nil     # return is tranparent
    update_damage                                      # update damage
  end
  
  #-----------------------------------------------------------------------------
  # hookshot mode
  #-----------------------------------------------------------------------------
   def update_hookshotdef
    @tool_destroy_delay = 1000 ; @tool_size = 1
    @move_speed = 6 if @move_speed != 6
    @tool_piercing = true if !@tool_piercing
    for event in $game_map.events_withtags
      if obj_size?(event, @tool_size)
        if event.hook_pull && !@user.hookshoting[1]
          break if @transparent
          break if event.x == @user.x and event.y == @user.y
          @user.hookshoting[1] = true
          @tool_distance = 0
          @user.user_move_distance[0] = @customsteps
          @user.user_move_distance[1] = @user.move_speed
          @user.user_move_distance[2] = @user.through
          @user.user_move_distance[3] = [@x, @y]
          @user.move_speed = @move_speed
          @user.through = true
          @user.battler_chain.each {|c| c.tool_distance = 0
          if c.customsteps == c.original_distance - 1 # this is the last chain
            if c.in_frontof?(self)
              self.pattern = c.pattern # pattern change for convenience
              c.pattern = 0
            end
          end
          }
          
        elsif event.hook_grab and !@user.hookshoting[2]
          break if event.being_grabbed
          break if @user.in_frontof?(event)
          event.being_grabbed = true
          @user.hookshoting[2] = true
          @user.battler_chain.each {|i|
          i.pattern = 1 if i.customsteps == @customsteps - 2
          next if i.customsteps < @customsteps - 1
          i.transparent = true} # make trnparent when grabing
          event.user_move_distance[0] = @customsteps
          event.user_move_distance[1] = event.move_speed
          event.user_move_distance[2] = event.through
          @user.user_move_distance[3] = event
          event.move_speed = @move_speed - 0.3
          event.through = true
          event.turn_toward_character(@user)
        end
      end
    end
    #-------------------------------------------------------------------------------
    # if the user being pulled
    #-------------------------------------------------------------------------------
    if @user.hookshoting[1]
      @user.battler_chain.each do |pr|
        if pr.x == @user.x and pr.y == @user.y
          pr.destroy_it = true
          if @user.user_move_distance[3][0] == @user.x and 
            @user.user_move_distance[3][1] == @user.y
            @user.battler_chain.clear
            @user.move_speed = @user.user_move_distance[1]
            @user.through = @user.user_move_distance[2]
            @user.hookshoting[3] = 30
            @user.hookshoting[1] = false
            if @user.is_a?(Game_Player) and !@user.follower_fighting?
              @user.followers.gather 
            end
          end
        end
      end
      return 
    # if the user is grabbing
    elsif @user.hookshoting[2]
      event = @user.user_move_distance[3]
      if @user.in_frontof?(event)
        event.move_speed = event.user_move_distance[1]
        event.through = event.user_move_distance[2]
        @user.hookshoting[2] = false
        event.user_move_distance[0] = 0
        @user.hookshoting[3] = 70
      end
    end
    
    # retracting engine hookshot
    if @customsteps + 1 == @original_distance && @tool_distance == 0 && !moving?
      @user.battler_chain.each do |projectile|
        next if projectile.tool_retracting
        projectile.tool_retracting = true
        projectile.direction_fix = true
      end
    end
      
    # retraction
    @user.battler_chain.each do |pr|
      if pr.tool_retracting
        pr.destroy_it = true if @user.facing_corners?
        pr.move_toward_character(@user) if !pr.moving?
        if pr.x == @user.x and pr.y == @user.y
          pr.destroy_it = true 
          if pr.customsteps == pr.original_distance - 1
            @user.battler_chain.clear
            @user.hookshoting[3] = 10
          end
        end
      end
    end
  end 
  
  # Special Boomerang
  def update_boomerand
    $game_map.events_withtags.each do |event|
      if event.boom_grab || !event.dropped_items.empty?
        if event.boom_grabdata.nil? and obj_size?(event, @tool_size)
          event.boom_grabdata = [event.move_speed, event.through]
          event.move_speed = 6
          event.through = true
        end
      end
  
      # event being grabbed by boomerang
      if !event.boom_grabdata.nil?
        event.x, event.y = @x, @y
        if event.obj_size?(@user, 2)
          reset_boomed(event)
          unless event.jumping?
            event.jumpto_tile(@user.x, @user.y) 
            event.direction = event.page.graphic.direction rescue 2
            event.start if event.boom_start && !event.killed
          end
        end
        reset_boomed(event) if @tool_destroy_delay == 1 and obj_size?(event, 1) 
      end
    end
    #------------------------------------------------------------------------
    # prepare the tool to be destoryed when colliding with user
    #------------------------------------------------------------------------
    if @tool_destroy_delay <= @originaldestory_delay - 50
      move_toward_character(@user) if !moving?
      if @x == @user.x and @y == @user.y
        @user.anime_speed = 0
        @destroy_it = true 
      end
    end
  end
  
  def reset_boomed(event)
    event.move_speed = event.boom_grabdata[0]
    event.through = event.boom_grabdata[1]
    event.boom_grabdata = nil
  end
  
  # Special Spiral
  def update_spiral
    @spintimer += 1
    case @spintimer
    when 6  then make_rounds(1)
    when 12 then make_rounds(2)
    when 18 then make_rounds(3)
    when 24 then make_rounds(4)
      if @spintimes > 1
        @spintimer = 0
        @spintimes -= 1
      end
    when 40
      @destroy_it = true 
      @user.anime_speed = 0
    end
  end
  
  # move the tool and the user to fforn direction
  def movetofront(dir, conditional)
    @user.direction = dir if @user.direction == conditional
    moveto(@user.x + @user.adjustcxy[0], @user.y + @user.adjustcxy[1]) if
    !@user.facing_corners?
    @direction = @user.direction
  end
  
  # make round depending of the user direction
  def make_rounds(type)
    case type
    when 1
      movetofront(4, 2) if @dir_was == 2 ; movetofront(8, 4) if @dir_was == 4
      movetofront(2, 6) if @dir_was == 6 ; movetofront(6, 8) if @dir_was == 8
    when 2
      movetofront(8, 4) if @dir_was == 2 ; movetofront(6, 8) if @dir_was == 4
      movetofront(4, 2) if @dir_was == 6 ; movetofront(2, 6) if @dir_was == 8
    when 3
      movetofront(6, 8) if @dir_was == 2 ; movetofront(2, 6) if @dir_was == 4
      movetofront(8, 4) if @dir_was == 6 ; movetofront(4, 2) if @dir_was == 8
    when 4
      movetofront(2, 6) if @dir_was == 2 ; movetofront(4, 2) if @dir_was == 4
      movetofront(6, 8) if @dir_was == 6 ; movetofront(8, 4) if @dir_was == 8
    end
  end
  
  #============================================================================
  # Apply benefical effects to users and allies
  
  # apply effect to a single selection
  def apply_effectto_selection
    
    # if the battler is a game actor the effect going to a target
    if @user.battler.is_a?(Game_Actor)
      apply_self_effect(@target_effect[1], true) 
    else
    
      # Enemies choose a random target ally
      all = []
      for event in $game_map.event_enemies
        if event.on_battle_screen?
          next if event.battler.object
          if @item.scope == 9 and event.killed
            all.push(event)
            apply_self_effect(event, true)
            event.apply_respawn
            return
          end
          all.push(event)
        end
      end
      
      # if scope for the user
      if @item.scope == 9
        apply_self_effect(@user, true)
        return
      end
      all.push(@user)
      target = all[rand(all.size)]  
      apply_self_effect(target, true) if !target.nil?
      apply_self_effect(@user, true) if target.nil?
    end
  end
  
  # effect to all allies
  def apply_effectto_all_allies
    
    # apply effect to all battle menbers actors
    if @user.battler.is_a?(Game_Actor)
      $game_player.followers.each {|i|
      next unless i.visible?
      next if i.battler.dead? and @item.scope == 8
      apply_self_effect(i, pop=true)}
      apply_self_effect($game_player, pop=true)
      
      # Apply effect to all enemies allies
    elsif @user.battler.is_a?(Game_Enemy)
      for event in $game_map.event_enemies
        if event.on_battle_screen?
          next if event.battler.object || event.page.nil?
          next if @item.scope == 8 and event.battler.dead?
          if event.battler.dead?
            @item.scope == 10 ? event.apply_respawn : next
          end
          event.battler.item_apply(event.battler, @item)
          $game_player.damage_pop.push(DamagePop_Obj.new(event))
          event.animation_id = animation
        end
      end
      apply_self_effect(@user, true)
    end
  end
  
  # direct effect
  def apply_self_effect(target, pop=true)
    target.battler.item_apply(target.battler, @item)
    target.animation_id = animation
    $game_player.damage_pop.push(DamagePop_Obj.new(target))
    @destroy_it = true
  end
  
  #============================================================================
  # update damage depending if the user is an enemy or actor
  def update_damage
    if @user.battler.is_a?(Game_Actor)
      apply_damageto_enemy
      if @tool_selfdamage
        apply_damageto_player
        apply_damageto_followers unless @ignore_followers
      end
    elsif @user.battler.is_a?(Game_Enemy)
      if $game_player.normal_walk?
        apply_damageto_player 
        apply_damageto_followers unless @ignore_followers
      end
      
      apply_damageto_enemy if @tool_selfdamage
    end
  end
  #-------------------------------------------------------------------------------
  # *) Timer updater
  # tag: projectile
  #-------------------------------------------------------------------------------
  def update_timer
    passable = pixel_passable?(@x , @y , @direction)
    update_tool_movement if passable
    
    @mini_opacity -= 1 if  @mini_opacity > 0
    @opacity = 255 if @mini_opacity == 1
    @tool_effect_delay -= 1 if @tool_effect_delay > 0
    
    if @tool_distance == 0
      @tool_destroy_delay -= 1 if @tool_destroy_delay > 0
      @destroy_it = true if @tool_destroy_delay == 0
    elsif !passable
      @tool_destroy_delay -= 1 if @tool_destroy_delay > 0
      @destroy_it = true if @tool_destroy_delay == 0
    end
    update_animation_setting
  end
  
  #=============================================================================
  # * movement
  def make_diagonal_a
    move_diagonal(4, 2) if @direction == 2
    move_diagonal(4, 8) if @direction == 4
    move_diagonal(6, 8) if @direction == 6
    move_diagonal(4, 8) if @direction == 8
  end
  
  def make_diagonal_b
    move_diagonal(6, 2) if @direction == 2
    move_diagonal(4, 2) if @direction == 4
    move_diagonal(6, 2) if @direction == 6
    move_diagonal(6, 8) if @direction == 8
  end
  
  def make_direction_a
    @direction = 4 if @user.direction == 2
    @direction = 8 if @user.direction == 4
    @direction = 2 if @user.direction == 6
    @direction = 6 if @user.direction == 8
    @direction_done = true
  end
  
  def make_direction_b
    @direction = 6 if @user.direction == 2
    @direction = 2 if @user.direction == 4
    @direction = 8 if @user.direction == 6
    @direction = 4 if @user.direction == 8
    @direction_done = true
  end
  #----------------------------------------------------------------------------
  # *) update tool movement
  #----------------------------------------------------------------------------
  def update_tool_movement
    if @tool_distance > 0 && !moving?
      
      if @triple != nil # tripple definition
        case @triple
        when :uno  then make_diagonal_a
        when :dos  then move_forward
        when :tres then make_diagonal_b
        end
        @tool_distance -= 1
        
      elsif @quintuple != nil # quintuple definition
        case @quintuple
        when :uno    ; make_direction_a  if @direction_done.nil?; move_forward
        when :dos    ; make_diagonal_a
        when :tres   ; move_forward
        when :cuatro ; make_diagonal_b   
        when :cinco  ; make_direction_b if @direction_done.nil? ; move_forward
        end
        @tool_distance -= 1
        
      elsif @octuple != nil  # octuple
        case @octuple
        when :uno    ; make_direction_a  if @direction_done.nil?; move_forward
        when :dos    ; make_diagonal_a
        when :tres   ; move_forward
        when :cuatro ; make_diagonal_b   
        when :cinco  ; make_direction_b if @direction_done.nil? ; move_forward
        when :seis   ; make_diagonal_a
        when :siete  ; move_forward
        when :ocho   ; make_diagonal_b
        end
        @tool_distance -= 1
        
      elsif @tool_special == "autotarget" # autotarget
        if @autotargeting.nil?
          @autotargeting = []
          # chose any event enemy on the map if the user is an actor
          if @user.battler.is_a?(Game_Actor)
            for event in $game_map.event_enemies
              if @user.is_a?(Game_Follower) and @user.targeted_character != nil
                @autotargeting = [true, @user.targeted_character]
                #@user.turn_toward_character(@user.targeted_character)
                move_forward
                return
              end
              if event.enemy_ready? and event.on_battle_screen? and
                obj_size?(event, 8)
                @autotargeting = [true, event]
                #@user.turn_toward_character(event)
                move_forward
                return
              end
            end
            # choose a game actor if the user is an enemy          
          elsif @user.battler.is_a?(Game_Enemy)
            @user.agroto_f.nil? ? target =$game_player : target = @user.agroto_f
            @autotargeting = [true, target] if obj_size?(target, 8)
          end
        end
        
        if @autotargeting[0]
          follow_char(@autotargeting[1])
          @autotargeting.clear if @autotargeting[1].x == @x and
          @autotargeting[1].y == @y
        else
          move_forward
        end
        @tool_distance -= 1
        # random
      elsif @tool_special == "random"
        move_forward if @tool_distance == @original_distance - 1
        move_forward if @tool_distance == @original_distance - 2
        move_random  if @tool_distance <= @original_distance - 3
        @tool_distance -= 1
       
      # boomerang redirect movement
      elsif @tool_special == "boomerang"
        
        if @user.is_a?(Game_Player)
          case Input.dir8
          when 1 then move_diagonal(4, 2) 
          when 3 then move_diagonal(6, 2)
          when 7 then move_diagonal(4, 8)
          when 9 then move_diagonal(6, 8)
          else #not input just move straig
            move_forward
          end
          # not game player just move straight
        else
          move_forward
        end
        @tool_distance -= 1
        # reserved for common event function
      elsif @commonevent_id != nil
  
      else # normal move forward behavior
        move_forward ; @tool_distance -= 1
      end
    end
  end
  #----------------------------------------------------------------------------
  # tool animation
  #----------------------------------------------------------------------------
  def update_animation_setting
    case @tool_end_anime
    when "end"
      if @tool_destroy_delay >= 8 and @tool_destroy_delay <= 16
        @animation_id = animation 
      end
    when "acting"
      if @tool_animerepeat
        @animation_id = animation if @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime == 12
      else
        @animation_id = animation if @mnganime == 0
        @mnganime = 1
      end
    end
    
    if @tool_end_anime.is_a?(Fixnum)
      @animation_id = animation  if @tool_destroy_delay == @tool_end_anime
    end
  end
  #----------------------------------------------------------------------------
  # Get the animation to be played
  #----------------------------------------------------------------------------
  def animation
    if @item.is_a?(RPG::Armor)
      return $data_skills[@tool_invoke].animation_id if @tool_invoke > 0
      return 0
    end
    
    _id = @item.animation_id
    if _id == 0
      if @item.tool_itemcosttype != nil
        if @user.is_a?(Game_Player)
          battler = $game_party.leader
        elsif @user.is_a?(Game_Follower)
          battler = @user.actor
        end
        
        if battler
          ammo = battler.equips[battler.class.ammo_slot_id]
          _id = ammo.animation_id if !ammo.nil?
        end
        
      end
    end
    
    return _id
  end
  #----------------------------------------------------------------------------
  # apply damage to enemy
  # tag: damage
  #----------------------------------------------------------------------------
  def apply_damageto_enemy
    return if @tool_effect_delay > 0
    $game_map.event_enemies.each do |event|
      next if event.collapsing?
      if event.battler.body_sized > 0
        enabled = body_size?([event.x, event.y], @tool_size)
        enabled = body_size?([event.x - 1, event.y], @tool_size) if !enabled 
        enabled = body_size?([event.x, event.y - 1], @tool_size) if !enabled
        enabled = body_size?([event.x + 1, event.y], @tool_size) if !enabled
        enabled = body_size?([event.x , event.y + 1], @tool_size) if !enabled
        if event.battler.body_sized == 2
          enabled = body_size?([event.x-1, event.y-1], @tool_size) if !enabled 
          enabled = body_size?([event.x, event.y - 2], @tool_size) if !enabled
          enabled = body_size?([event.x+1, event.y-1], @tool_size) if !enabled
        end
      else
        enabled = body_size?([event.x, event.y], @tool_size, event)
      end
      
      if enabled and (event.just_hitted[user.hash_id] == 0 || !event.just_hitted[user.hash_id])
        event.just_hitted[user.hash_id] = 20
        next if event.page.nil?
        if !enable_dame_execution?(event.battler)
          unless event.battler.object
            RPG::SE.new(Key::GuardSe, 80).play
            event.pop_damage('Guard')
            play_hit_animation(event)
            event.setup_target(@user)
          end
          return
        end
        #-------------------------
        execute_damageto_enemy(event)
      end
    end
  end
  
  # check wheter the enemy is killed by spefific items
  def enable_dame_execution?(enemy)
    weapon = enemy.kill_weapon if @original_item.is_a?(RPG::Weapon)
    armor = enemy.kill_armor   if @original_item.is_a?(RPG::Armor)
    item = enemy.kill_item     if @original_item.is_a?(RPG::Item)
    skill = enemy.kill_skill   if @original_item.is_a?(RPG::Skill)
    if enemy.has_kill_with?
      return true if !weapon.nil? && weapon.include?(@original_item.id)
      return true if !armor.nil?  && armor.include?(@original_item.id)
      return true if !item.nil?   && item.include?(@original_item.id)
      return true if !skill.nil?  && skill.include?(@original_item.id)
      return false
    end
    return true
  end
  
  # execute damage to enemy
  def execute_damageto_enemy(event)
    event.being_targeted = false if event.being_targeted
    event.epassive = false if event.epassive
    
    if event.agroto_f.nil? and @user.is_a?(Game_Follower)
      event.agroto_f = @user if rand(5) == 1
    end
    
    if event.agroto_f != nil and @user.is_a?(Game_Player)
      event.agroto_f = nil if rand(2) == 1
    end
    
    if !event.battler.object
      return if guard_success?(event, 1)
    end
    
    execute_damage(event)
    return if event.battler.object
    $game_player.damage_pop.push(DamagePop_Obj.new(event)) unless
    guard_success?(event, 2)
    apply_blow_power(event) unless event.battler.k_back_dis
    
    case (event.battler.hp.to_f / event.battler.mhp.to_f * 100.0)
    when 0..10 then activate_lhp_switch(event.battler.lowhp_10)
    when 0..25 then activate_lhp_switch(event.battler.lowhp_25)
    when 0..50 then activate_lhp_switch(event.battler.lowhp_50)
    when 0..75 then activate_lhp_switch(event.battler.lowhp_75)
    end
  end
  
  def activate_lhp_switch(switch)
    $game_switches[switch] = true if !switch.nil? and !$game_switches[switch]
  end
  
  #----------------------------------------------------------------------------
  # apply damage to player
  # tag: damage
  #----------------------------------------------------------------------------
  def apply_damageto_player
    return if @tool_effect_delay > 0 || $game_player.battler.dead?
    if obj_size?($game_player, @tool_size) and (!$game_player.just_hitted[user.hash_id] || $game_player.just_hitted[user.hash_id].zero?)
      $game_player.just_hitted[user.hash_id] = 20
      return if guard_success?($game_player, 1)
      execute_damage($game_player)
      $game_player.damage_pop.push(DamagePop_Obj.new($game_player)) unless
      guard_success?($game_player, 2)
      apply_blow_power($game_player)
    end
  end
  #----------------------------------------------------------------------------
  # Apply damage to followers
  # tag: damage
  #----------------------------------------------------------------------------
  def apply_damageto_followers
    return if @tool_effect_delay > 0
    # followers
    for actor in $game_player.followers
      next unless actor.visible?
      if obj_size?(actor, @tool_size) and (actor.just_hitted[user.hash_id] == 0 || !actor.just_hitted[user.hash_id])
        actor.just_hitted[user.hash_id] = 20
        next if actor.battler.dead?
        return if guard_success?(actor, 1)
        execute_damage(actor)
        $game_player.damage_pop.push(DamagePop_Obj.new(actor)) unless
        guard_success?(actor, 2)
        apply_blow_power(actor)
      end
    end
  end
  
  def precombo(sym)
    @item.is_a?(RPG::Weapon) ? e=@user.actor.equips[0] : e=@user.actor.equips[1]
    return if e.nil?
    if sym == :apply
      @user.apply_weapon_param(e, false) 
      @user.apply_weapon_param(@item, true)
    elsif sym == :remove
      @user.apply_weapon_param(@item, false)  
      @user.apply_weapon_param(e, true) 
    end
  end
  #-----------------------------------------------------------------------------
  # Execute damage to the target
  # tag: damage
  #-----------------------------------------------------------------------------
  def execute_damage(target)
    
    if magical_item?
      target.battler.item_apply(@user.battler, @item)
    else
      @user.apply_weapon_param(@item, true) if @user.battler.is_a?(Game_Enemy)
      precombo(:apply) if @user.battler.is_a?(Game_Actor) && @precombi
      if @tool_invoke > 0
        target.battler.melee_attack_apply(@user.battler, @tool_invoke)
      else
        _item = @ammo_proj.nil? ? @item : @ammo_proj
        target.battler.attack_apply(@user.battler, _item)
      end
      @user.apply_weapon_param(@item, false) if @user.battler.is_a?(Game_Enemy)
      precombo(:remove) if @user.battler.is_a?(Game_Actor) && @precombi
    end
    
    target.colapse_time = 60 if target.battler.dead? 
    return if target.battler.is_a?(Game_Enemy) and target.battler.object
    hp_d = target.battler.result.hp_drain
    @user.pop_damage(['Drain ' + hp_d.to_s, Color.new(10,220,45)]) if hp_d > 0
    mp_d = target.battler.result.mp_drain
    @user.pop_damage(['Drain ' + mp_d.to_s, Color.new(20,160,225)]) if mp_d > 0
    return if target.battler_guarding[0]
    return if target.battler.result.hp_damage < 0
    return if target.battler.result.hp_damage == 0
    target.jump(0, 0) if PearlKernel.jump_hit?(target.battler) and 
    @tool_blow_power < 2
    
    voices = PearlKernel.hitvoices(target.battler)
    RPG::SE.new(voices[rand(voices.size)], 80).play unless voices.nil?
    
    $game_map.screen.start_shake(8, 6, 24) if @tool_hitshake
    return if target.hookshoting[0] || @user.making_spiral
    return if @tool_knockdownrate == 0
    if rand(101) <= @tool_knockdownrate
      target.knockdown_data[0] = 60
    end
  end
  
  # Check guard if the user is using the shield
  def guard_success?(userr, type)
    if userr.battler_guarding[0]
       # guard
      if type == 1
        if rand(101) <= userr.battler_guarding[1]
          return false unless faceto_face?(userr)
          RPG::SE.new(Key::GuardSe, 80).play
          $game_player.damage_pop.push(DamagePop_Obj.new(userr, 2))
          unless @user.making_spiral
            @tool_distance = 0
            @tool_destroy_delay = 0
          end
          play_hit_animation(userr)
          return true
        end
        # block
      elsif type == 2
        return false unless faceto_face?(userr)
        $game_player.damage_pop.push(DamagePop_Obj.new(userr, 1))
        return true
      end
    end
    return false
  end
  
  # this metthod make the tool wait for the animation to be displayed when hit
  def apply_passive_state
    @transparent = true
    @tool_effect_delay = 1000 * 1000
    @tool_destroy_delay = 60
    @animation_id = animation
    @tool_distance = 0
  end
  
  # hit animation
  def play_hit_animation(target)
    if @target_effect[0] || !@tool_piercing
      @tool_end_anime == "hit" ?  apply_passive_state : @destroy_it = true
    else
      target.animation_id = animation if @tool_end_anime == "hit" 
    end
  end
  
  # blow powers effects
  def apply_blow_power(target)
    play_hit_animation(target)
    return if target.battler.result.hp_damage < 1
    return if target.hookshoting[0] || @user.making_spiral
    target.blowpower = [@tool_blow_power, @direction, target.direction_fix,
    target.move_speed, 0] if target.blowpower[0] == 0 and
    target.blowpower[4] == 0
    #follower blow
    if target.is_a?(Game_Player)
      target.followers.each {|f|
      next unless f.visible?
      next if f.battler.dead?
      f.blowpower = [@tool_blow_power, @direction, f.direction_fix,
      f.move_speed, 0] if f.blowpower[0] == 0 and f.blowpower[4] == 0
      }
    end
  end
  
  # pattern
  def update_anime_pattern
    return if @tool_special == "hook"
    super
  end
  
  # Activate events by tool token id
  def update_tool_token
    return if @tool_effect_delay > 0
    $game_map.events_withtags.each do |event|
      if obj_size?(event, @tool_size) and event.start_delay == 0
        wid = event.token_weapon
        aid = event.token_armor
        iid = event.token_item
        sid = event.token_skill
        item = @original_item
        case item
        when RPG::Weapon; start_token(event) if wid.include?(item.id)
        when RPG::Armor ; start_token(event) if aid.include?(item.id)
        when RPG::Item  ; start_token(event) if iid.include?(item.id)
        when RPG::Skill ; start_token(event) if sid.include?(item.id)
        end
      end
    end
  end
  
  # trigger event
  def start_token(event)
    $game_map.events_withtags.delete(event)
    event.start
    event.start_delay = 30
  end
  
  def move_straight(d, turn_ok = true)
    return if force_stopped?
    super
  end
end
