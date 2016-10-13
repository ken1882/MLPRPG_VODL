#===============================================================================
# * Falcao Pearl ABS script shelf # 5
#
# This script handles all sprites of Pearl ABS engine
#===============================================================================
# Anime action enguine
class Anime_Obj < Game_Character
  attr_accessor :draw_it, :destroy_it, :item, :user, :original_speed
  attr_reader   :custom_graphic
  def initialize(user, item)
    super()
    PearlKernel.load_item(item)
    @draw_it = false
    @destroy_it = false
    @item = item
    @user = user
    @custom_graphic = false
    graphic = PearlKernel.user_graphic
    if graphic.split(" ").include?('custom') 
      graphic = graphic.sub("custom ","")
      @custom_graphic = true
      user.transparent = true
      user.using_custom_g = true
    end
    @character_name = graphic
    moveto(@user.x, @user.y)
    set_direction(@user.direction)
    @original_speed = PearlKernel.user_animespeed
    
    #patch
    PearlKernel.check_iconset(@item, "User Iconset = ", self)
    @character_name = "" if @user_iconset != nil
  end
end
# Sprite character added battlers as enemies and the anime sprites fit
class Sprite_Character < Sprite_Base
  alias falcaopearl_update_position update_position
  def update_position
    if !@character.battler.nil? and @character.battler.is_a?(
      Game_Enemy) and @character.battler.breath_enable
      apply_breath_effect(@character)
    end
    self.zoom_x = @character.zoomfx_x
    self.zoom_y = @character.zoomfx_y
    self.angle = @character.angle_fx
    falcaopearl_update_position
    update_anime_object_pos
  end
  
  # anime object position and action
  def update_anime_object_pos
    if @character.is_a?(Anime_Obj)
      if @character.custom_graphic
        add = 0
      else
        @ch == 128 ? add = 48 : add = (@ch / 2) / 2
      end
      self.x = @character.user.screen_x
      self.y = @character.user.screen_y + add
      self.z = @character.user.screen_z + 1
      @character.direction = @character.user.direction
      if @character.user.anime_speed == 0
        if @character.custom_graphic
          @character.user.transparent = false 
          @character.user.using_custom_g = false
        end
        @character.destroy_it = true 
      end
      if @character.user.making_spiral
        @character.direction == 8 ? @character.pattern=1 : @character.pattern=2
        return
      end
      a= @character.user.anime_speed.to_f/@character.original_speed.to_f * 100.0
      case a
      when 80..100 ; @character.pattern = 0 
      when 60..80  ; @character.pattern = 1
      when 25..60  ; @character.pattern = 2
      end
    end
  end
  
  # Enemy battler graphics engine
  alias falcaopearl_battler_bitmap set_character_bitmap
  def set_character_bitmap
    if battler_graphic?
      self.bitmap= Cache.battler(@character_name,@character.battler.battler_hue)
      self.ox = self.bitmap.width / 2
      self.oy = self.bitmap.height
      return
    end
    falcaopearl_battler_bitmap
  end
  
  def battler_graphic?
    if !@character.battler.nil? and @character.battler.is_a?(
      Game_Enemy) and @character.battler.battler_graphic
      return false if @character.page.nil?
      @character_name = @character.battler.battler_name
      return true 
    end
    return false
  end
  
  alias falcaopearl_battler_graphic update_src_rect
  def update_src_rect
    return if battler_graphic?
    falcaopearl_battler_graphic
  end
  
  # breath effect
  def apply_breath_effect(char)
    return if @character.is_a?(Game_Event) and @character.erased
    char.zoomfx_x -= 0.0023 if !char.zfx_bol
    char.zoomfx_y -= 0.0023 if !char.zfx_bol
    char.zoomfx_x += 0.0023 if  char.zfx_bol
    char.zoomfx_y += 0.0023 if  char.zfx_bol
    char.zfx_bol = true if char.zoomfx_x <= 0.93
    char.zfx_bol = false if char.zoomfx_x >= 1.0
  end
end
#sprite characters part 2 (icon graphics feature
class Sprite_Character < Sprite_Base
 
  def iconset_graphic?
    !@character.user_iconset.nil? || !@character.pro_iconset.nil?
  end
 
  alias falcao_fantastic_bit update_bitmap
  def update_bitmap
    if iconset_graphic?
      if @apply_iconset.nil?
        icon = @character.user_iconset[0] if !@character.user_iconset.nil? and
        @character.is_a?(Anime_Obj)
        icon = @character.pro_iconset[0] if !@character.pro_iconset.nil? and
        @character.is_a?(Projectile)
        set_iconsetbitmap(icon)
        @apply_iconset = true
      end
      apply_breath_effect2(@character) if !@character.pro_iconset.nil? and
      @character.is_a?(Projectile) and @character.pro_iconset[1] == :animated
      @enable_angle = @character.user_iconset[1] if
      !@character.user_iconset.nil? and @character.is_a?(Anime_Obj)
      return
    end
    falcao_fantastic_bit
  end
 
  alias falcao_fantastic_update_position update_position
  def update_position
    falcao_fantastic_update_position
    set_angle_changes(@enable_angle) if @enable_angle != nil
  end
 
  def apply_angle_pattern(x_plus, y_plus, angle)
    self.x = @character.user.screen_x + x_plus
    self.y = @character.user.screen_y + y_plus
    self.angle = angle
  end
 
  def set_angle_changes(type)
    ani= @character.user.anime_speed.to_f/@character.original_speed.to_f * 100.0
    case ani
    when 80..100
      perform_animated(0) if type == :animated
    when 60..80
      perform_animated(1) if type == :animated
    when 0..60
      perform_animated(2) if type == :animated
    end
    if type != :animated
      perform_static       if type == :static
      perform_shielding    if type == :shielding
    end
  end
 
  # animated
  def perform_animated(pattern)
    case pattern
    when 0
      apply_angle_pattern(10, -12, -166) if @character.user.direction == 2
      if @character.user.direction == 4 || @character.user.direction == 6
        apply_angle_pattern(-8, -26, -46)
        self.z = @character.user.screen_z - 1
      end
      apply_angle_pattern(-22, -10, 0)   if @character.user.direction == 8
    when 1
      apply_angle_pattern(0, 0, -266)   if @character.user.direction == 2
      apply_angle_pattern(-20, -10, 12) if @character.user.direction == 4
      apply_angle_pattern(7, -20, -78)  if @character.user.direction == 6
      if @character.user.direction == 8
        apply_angle_pattern(-8, -26, -46)
        self.z = @character.user.screen_z - 1
      end
    when 2
      apply_angle_pattern(8, -5, -210)    if @character.user.direction == 2
      apply_angle_pattern(-10, 2, 52)     if @character.user.direction == 4
      apply_angle_pattern(8, -15, -126)  if @character.user.direction == 6
      apply_angle_pattern(10, -16, - 100) if @character.user.direction == 8
    end
  end
 
  # static
  def perform_static
    apply_angle_pattern(8, -5, -210)    if @character.user.direction == 2
    apply_angle_pattern(-10, 2, 52)     if @character.user.direction == 4
    apply_angle_pattern(8, -15, -126)  if @character.user.direction == 6
    if @character.user.direction == 8
      apply_angle_pattern(-8, -26, -46)
      self.z = @character.user.screen_z - 1
    end
  end
 
  # shielding
  def perform_shielding
    apply_angle_pattern(2, 4, 0)    if @character.user.direction == 2
    apply_angle_pattern(-10, 0, 0)     if @character.user.direction == 4
    if @character.user.direction == 6
      apply_angle_pattern(10, 0, 0)  
      self.z = @character.user.screen_z - 1
    elsif @character.user.direction == 8
      apply_angle_pattern(11, -9, 0)  
      self.z = @character.user.screen_z - 1
    end
  end
 
  def apply_breath_effect2(char)
    char.zoomfx_x -= 0.03 if !char.zfx_bol
    char.zoomfx_y -= 0.03 if !char.zfx_bol
    char.zoomfx_x += 0.03 if char.zfx_bol
    char.zoomfx_y += 0.03 if char.zfx_bol
    char.zfx_bol = true if char.zoomfx_x <= 0.84
    char.zfx_bol = false if char.zoomfx_x >= 1.0
  end
 
  alias falcao_fantastic_src update_src_rect
  def update_src_rect
    return if iconset_graphic?
    falcao_fantastic_src
  end
 
  def set_iconsetbitmap(icon_index, enabled = true)
    self.bitmap = Bitmap.new(24, 24)
    bit = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.bitmap.blt(0, 0, bit, rect, enabled ? 255 : 150)
    @cw = self.ox = 12
    @ch = self.oy = 24
  end
end
#===============================================================================
# Drop sprites
#------------------------------------------------------------------------------
# This class handle the items that dropped from enemy
#------------------------------------------------------------------------------
class Sprite_EnemyDrop < Sprite
  #------------------------------------------------------------------------------
  # Instance Variables
  #------------------------------------------------------------------------------
  attr_reader   :event
  #------------------------------------------------------------------------------
  # *) Object Initialize
  #------------------------------------------------------------------------------
  def initialize(viewport, event, item)
    super(viewport)
    @event = event
    @item = item
    @drop_quantity = @item.tool_data("Drop Quantity = ")
    @drop_quantity = 1 if @drop_quantity.nil?
    self.z = $game_player.screen_z - 1
    @object_zooming = 0
    set_bitmap
    update
  end
  #------------------------------------------------------------------------------
  # *) Update
  #------------------------------------------------------------------------------
  def update
    super
    self.bush_depth = @event.bush_depth
    @object_zooming += 1
    
    case @object_zooming
    when 1..8  ; self.zoom_x -= 0.01 ;  self.zoom_y -= 0.01
    when 9..16 ; self.zoom_x += 0.01 ;  self.zoom_y += 0.01
    when 17..24 ; self.zoom_x = 1.0  ;  self.zoom_y = 1.0; @object_zooming = 0 
    end
    
    self.x = @event.screen_x - 12
    self.y = @event.screen_y - 24
    
    if @event.adjacent?($game_player.x, $game_player.y)
      complete_action
      return
    end
    
    complete_action(false) if @event.respawn_count == 1
  end
  #------------------------------------------------------------------------------
  # *) Picked up
  #------------------------------------------------------------------------------
  def complete_action(gaining=true)
    $game_party.gain_item(@item, @drop_quantity) if gaining
    dispose
    @event.dropped_items.delete(@item)
    $game_map.events_withtags.delete(@event)
  end
  #------------------------------------------------------------------------------
  # *) Dispose
  #------------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose
    super
  end
  #------------------------------------------------------------------------------
  # *) Set bitmap
  #------------------------------------------------------------------------------
  def set_bitmap
    self.bitmap = Bitmap.new(26, 38)
    bitmap = Cache.system("Iconset")
    icon = @item.icon_index
    rect = Rect.new(icon % 16 * 24, icon / 16 * 24, 24, 24)
    self.bitmap.blt(0, 0, bitmap, rect)
    
    ##num adds
    return if @drop_quantity == 0
    self.bitmap.font.size = 14
    self.bitmap.font.bold = true
    self.bitmap.draw_text(0, 8, 26, 32, @drop_quantity.to_s, 1)
  end
end
#===============================================================================
# Dead icon sprites for player and followers
class Sprite_DeadIcon < Sprite
  attr_reader   :character
  def initialize(viewport, character)
    super(viewport)
    @character = character
    self.bitmap = Bitmap.new(24, 24)
    bitmap = Cache.system("Iconset")
    icon = 1
    rect = Rect.new(icon % 16 * 24, icon / 16 * 24, 24, 24)
    self.bitmap.blt(0, 0, bitmap, rect)
    @knok = @character.actor.actor.tool_data("Knockdown Graphic = ",false)!= nil
    update
  end
  
  def update
    super
    self.x = @character.screen_x - 10
    self.y = @character.screen_y - 54
    self.z = @character.screen_z + 1
    self.opacity = @character.opacity
    self.visible = !@character.transparent
    if @knok
      @character.knockdown_data[0] = 10 if !@character.battler.deadposing.nil?
    else
      @character.playdead
      @character.direction = 8
      self.x = @character.screen_x - 26
    end
  end
  
  def dispose
    self.bitmap.dispose
    @character.angle_fx = 0.0 unless @knok
    super
  end
end
#===============================================================================
# State and buff icons sprites
class StateBuffIcons < Sprite
  def initialize(viewport, mode)
    super(viewport)
    @mode = mode
    self.bitmap = Bitmap.new(36, 134)
    @picture = Cache.system("Iconset")
    if @mode == "States"
      self.x = Graphics.width - 36
      self.y = 90
    else
      self.x = Graphics.width - 36
      self.y = 230
    end
    @actor = $game_player.actor
    @old_status = []
    refresh_icons
    update
  end
  
  def icons
    return @actor.state_icons if @mode == 'States'
    return @actor.buff_icons  if @mode == 'Buffs'
  end
  
  def update
    5.times.each {|i| 
    if @old_status[i] != icons[i]
      refresh_icons
      $game_player.actor.apply_usability
    end}
    if @actor != $game_player.actor
      @actor = $game_player.actor
      refresh_icons
    end
  end
  
  def dispose
    self.bitmap.dispose
    super
  end
  
  def refresh_icons
    self.bitmap.clear
    self.bitmap.font.size = 15
    self.bitmap.draw_text(-2, -8, self.bitmap.width + 6, 32, @mode, 1) 
    y = 12; count = 0
    for i in icons
      draw_icon(6, y, i)
      y += 24; count += 1
      break if count == 5
    end
    5.times.each {|i| @old_status[i] = icons[i]}
  end
  
  def draw_icon(x, y, index)
    icon = index
    rect = Rect.new(icon % 16 * 24, icon / 16 * 24, 24, 24)
    self.bitmap.blt(x, y, @picture, rect)
  end
end
#===============================================================================
#  * Damage pop engine
class DamagePop_Obj < Game_Character
  attr_accessor :draw_it, :destroy_it, :target, :dmgcustom, :timingg, :plus_time
  attr_accessor :plus_time
  def initialize(target, custom=nil)
    super()
    @draw_it = false
    @destroy_it = false
    @target = target
    @timingg = 70
    @plus_time = 0.0
    @dmgcustom = custom
    moveto(@target.x, @target.y)
  end
end
class Sprite_DamagePop < Sprite
  attr_reader   :target
  def initialize(viewport, target)
    super(viewport)
    @target = target
    self.bitmap = Bitmap.new(200, 50)
    self.bitmap.font.size = 20
    case rand(4)
    when 0 then @resto_plus = 0.5
    when 1 then @resto_plus = 0.6
    when 2 then @resto_plus = 0.7
    when 3 then @resto_plus = 0.8
    end
    create_text_for_display
    set_text
    update
  end
  
  def create_text_for_display
    battler = @target.target.battler
    value   = battler.result.hp_damage
    value2  = battler.result.mp_damage
    value3  = battler.result.tp_damage
    
    # hp damage texts
    if value > 0
      battler.result.critical ? @text = 'Critical ' + value.to_s :
      @text = value.to_s
    elsif value < 0
      self.bitmap.font.color = Color.new(10,220,45)
      @text = value.to_s.sub("-","")
    elsif battler.result.missed
      @text = 'Miss'
    elsif battler.result.evaded
      @text = 'Evaded'
    elsif !battler.result.hited
      @text = 'Blocked'
    elsif battler.result.success # tanget take no damage but result succes
      @text = value.to_s
    end
    
    # mp damage text 
    if value2 < 0
      self.bitmap.font.color = Color.new(20,160,225)
      @text = value2.to_s.sub("-","")
    elsif value2 > 0
      @text = 'Mp lose' + value2.to_s
    end
    
    # TP damage text 
    if value3 < 0
      self.bitmap.font.color = Color.new(20,160,225)
      @text = value3.to_s.sub("-","")
    elsif value3 > 0
      @text = 'Tp lose' + value3.to_s
    end
    
    # states and buff display
    if battler.result.status_affected?
      display_changed_states(battler)
      display_changed_buffs(battler)
    end
    
    # Custom text (it has hightest priority
    if !@target.dmgcustom.nil?
      if @target.dmgcustom == 1
        @text = 'Block ' + value.to_s
      elsif @target.dmgcustom == 2
        @text = 'Guard!'
      elsif @target.dmgcustom.is_a?(String)   
        @text = @target.dmgcustom
      elsif @target.dmgcustom.is_a?(Array)
        self.bitmap.font.color = @target.dmgcustom[1]
        @text = @target.dmgcustom[0]
      end
    end
    battler.result.clear
  end
  #------------------------------------------------
  # text set and position
  #------------------------------------------------
  def set_text
    self.x = @target.screen_x - 98
    self.y = @target.screen_y - 54
    self.z = 3 * 100
    self.opacity = @target.opacity
    #self.bitmap.font.bold = true
    self.bitmap.font.shadow = true
    item = @target.target.battler.used_item
      
    if item != nil and !item.scope.between?(1, 6) and 
      item.tool_data("User Graphic = ", false).nil?
      @text = item.name if @text.nil?
    end
    @target.target.battler.used_item = nil
    self.bitmap.draw_text(0, 0, 200, 32, @text, 1)
  end
  
  # Buffs display
  def display_changed_buffs(target)
    display_buffs(target, target.result.added_buffs, Vocab::BuffAdd)
    display_buffs(target, target.result.added_debuffs, Vocab::DebuffAdd)
    display_buffs(target, target.result.removed_buffs, Vocab::BuffRemove)
  end
  
  def display_buffs(target, buffs, fmt)
    buffs.each do |param_id|
      @text = sprintf(fmt,'', Vocab::param(param_id)).sub("'s","")
    end
  end
  
  # States display
  def display_changed_states(target)
    display_added_states(target)
    display_removed_states(target)
  end
  
  # Display added states
  def display_added_states(target)
    target.result.added_state_objects.each do |state|
      state_msg = target.actor? ? state.message1 : state.message2
      #target.perform_collapse_effect if state.id == target.death_state_id
      next if state_msg.empty?
      @text = state_msg
    end
  end
  
  # Display removed states
  def display_removed_states(target)
    target.result.removed_state_objects.each do |state|
      next if state.message4.empty?
      @text = state.message4
    end
  end
  
  def update
    @target.timingg -= 1 if @target.timingg > 0
    @target.plus_time += @resto_plus
    self.opacity -= 5 if @target.timingg <= 25
    @target.destroy_it = true if @target.timingg == 0
    self.x = @target.target.screen_x - 98
    self.y = @target.target.screen_y - 54 - @target.plus_time
  end
  
  def dispose
    self.bitmap.dispose
    super
  end
end
#===============================================================================
# Sprite set map
class Spriteset_Map
  
  alias falcaopearl_create_characters create_characters
  def create_characters
    create_pearl_abs_sprites
    falcaopearl_create_characters
  end
  
  def create_pearl_abs_sprites
    if $game_player.send_dispose_signal
      dispose_pearlabs_sprites
      $game_player.send_dispose_signal = false
    end
    @projectile_sprites = []
    $game_player.projectiles.each do |projectile|
      @projectile_sprites.push(Sprite_Character.new(@viewport1, projectile))
    end
    @damagepop_sprites = []
    $game_player.damage_pop.each do |target|
      @damagepop_sprites.push(Sprite_DamagePop.new(@viewport1, target))
    end
    @animeabs_sprites = []
    $game_player.anime_action.each do |anime|
      @animeabs_sprites.push(Sprite_Character.new(@viewport1, anime))
    end
    @enemy_drop_sprites = []
    $game_player.enemy_drops.each do |enemy|
      for i in enemy.dropped_items
        @enemy_drop_sprites.push(Sprite_EnemyDrop.new(@viewport1, enemy, i))
      end
    end
    @dead_iconsprites = []
    @dead_characters = []
  end
  
  # Drop sprites update
  def update_drop_sprites
    @enemy_drop_sprites.each {|sprite| sprite.update if !sprite.disposed?
    if sprite.disposed?
      @enemy_drop_sprites.delete(sprite)
      $game_player.enemy_drops.delete(sprite.event)
    end
    }
    $game_player.enemy_drops.each do |enemy|
      unless enemy.draw_drop
        for i in enemy.dropped_items
          @enemy_drop_sprites.push(Sprite_EnemyDrop.new(@viewport1, enemy, i))
        end
        enemy.draw_drop = true
      end
    end
  end
  
  alias falcaopearl_upsp_update update
  def update
    update_pearl_abs_main_sprites
    falcaopearl_upsp_update
  end
  
  # pearl abs main sprites update
  def update_pearl_abs_main_sprites
    if $game_player.pearl_menu_call[1] == 1
      dispose_tool_sprite
      dispose_state_icons
      dispose_buff_icons
      dispose_actorlifebars if $imported["Falcao Pearl ABS Life"]
      $game_player.pearl_menu_call[1] = 0
      case $game_player.pearl_menu_call[0]
      when :tools     then SceneManager.call(Scene_QuickTool) 
      when :character then SceneManager.call(Scene_CharacterSet)
      when :battler   then SceneManager.call(Scene_BattlerSelection)
      end
      return
    end
    update_projectile_sprites
    update_damagepop_sprites
    update_absanime_sprites
    update_dead_characters
    update_drop_sprites
    $game_system.skillbar_enable.nil? ? create_tool_sprite : dispose_tool_sprite
    @pearl_tool_sprite.update unless @pearl_tool_sprite.nil?
    $game_player.actor.state_icons.empty? ? dispose_state_icons :
    create_state_icons
    $game_player.actor.buff_icons.empty? ? dispose_buff_icons :
    create_buff_icons
    @states_sprites.update unless @states_sprites.nil?
    @buff_sprites.update unless @buff_sprites.nil?
  end
  
  # create tool sprite
  def create_tool_sprite
    return if !@pearl_tool_sprite.nil?
    @pearl_tool_sprite = Sprite_PearlTool.new(@viewport2)
  end
  
  # dispose tool sprite
  def dispose_tool_sprite
    return if @pearl_tool_sprite.nil?
    @pearl_tool_sprite.dispose
    @pearl_tool_sprite = nil
  end
  
  # Create State icons
  def create_state_icons
    return if !@states_sprites.nil?
    @states_sprites = StateBuffIcons.new(@viewport2, 'States')
  end
  
  # dispose state icons
  def dispose_state_icons
    return if @states_sprites.nil?
    @states_sprites.dispose
    @states_sprites = nil
  end
  
  # Create Buff icons
  def create_buff_icons
    return if !@buff_sprites.nil?
    @buff_sprites = StateBuffIcons.new(@viewport2, 'Buffs')
  end
  
  # dispose buff icons
  def dispose_buff_icons
    return if @buff_sprites.nil?
    @buff_sprites.dispose
    @buff_sprites = nil
  end
  
  # Projectiles
  def update_projectile_sprites
    @projectile_sprites.each {|sprite| sprite.update if !sprite.disposed?}
    $game_player.projectiles.each do |projectile|
      unless projectile.draw_it
        @projectile_sprites.push(Sprite_Character.new(@viewport1, projectile))
        projectile.draw_it = true
      end
      if projectile.destroy_it
        @projectile_sprites.each {|i|
        if i.character.is_a?(Projectile) and i.character.destroy_it
          i.dispose
          @projectile_sprites.delete(i)
        end
        }
        if projectile.user.making_spiral
          projectile.user.making_spiral = false
        end
        if projectile.user.battler_guarding[0]
          projectile.user.battler_guarding = [false, nil]
          projectile.user.battler.remove_state(9)
        end
        $game_player.projectiles.delete(projectile)
      end
    end
  end
  
  # Damage pop 
  def update_damagepop_sprites
    @damagepop_sprites.each {|sprite| sprite.update if !sprite.disposed?}
    $game_player.damage_pop.each do |target|
      unless target.draw_it
        @damagepop_sprites.push(Sprite_DamagePop.new(@viewport1, target))
        target.draw_it = true
      end
      if target.destroy_it
        @damagepop_sprites.each {|i|
        if i.target.destroy_it
          i.dispose
          @damagepop_sprites.delete(i)
        end
        }
        $game_player.damage_pop.delete(target)
      end
    end
  end
  
  #=================================
  # ANIME SPRITES
  def update_absanime_sprites
    @animeabs_sprites.each {|s| s.update if !s.disposed?
    unless $game_player.anime_action.include?(s.character)
      s.dispose
      @animeabs_sprites.delete(s)
      $game_player.anime_action.delete(s.character)
    end
    }
    $game_player.anime_action.each do |anime|
      unless anime.draw_it
        @animeabs_sprites.push(Sprite_Character.new(@viewport1, anime))
        anime.draw_it = true
      end
      if anime.destroy_it
        @animeabs_sprites.each {|i|
        if i.character.is_a?(Anime_Obj) and i.character.destroy_it
          i.dispose
          @animeabs_sprites.delete(i)
        end
        }
        $game_player.anime_action.delete(anime)
      end
    end
  end
  
  def update_dead_characters
    for follower in $game_player.followers
      next if follower.visible? == nil
      next unless follower.battler.dead?
      unless @dead_characters.include?(follower)
        sprite = Sprite_DeadIcon.new(@viewport1, follower)
        @dead_iconsprites.push(sprite)
        @dead_characters.push(follower)
      end
    end
    
    for sprite in @dead_iconsprites
      sprite.update if !sprite.disposed?
      if !sprite.character.battler.dead?
        @dead_iconsprites.delete(sprite)
        @dead_characters.delete(sprite.character)
        sprite.dispose
      end
    end
  end
  
  alias falcaopearl_spdispose dispose
  def dispose
    dispose_pearl_main_sprites
    falcaopearl_spdispose
  end
  
  # pearl abs disposing
  def dispose_pearl_main_sprites
    @dead_iconsprites.each {|icon| icon.dispose}
    dispose_tool_sprite
    dispose_state_icons
    dispose_buff_icons
    dispose_pearlabs_sprites
  end
  
  def dispose_pearlabs_sprites
    @projectile_sprites.each {|pro| pro.dispose}
    @projectile_sprites.clear
    @damagepop_sprites.each {|target| target.dispose}
    @damagepop_sprites.clear
    @animeabs_sprites.each {|anime| anime.dispose}
    @animeabs_sprites.clear
    @enemy_drop_sprites.each {|sprite| sprite.dispose}
    @enemy_drop_sprites.clear
  end
end
