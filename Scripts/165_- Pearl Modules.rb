
module PearlKernel
  
  # Default enemy sensor self switch
  Enemy_Sensor = "B"
  
  # Default enemy sensor (distance in tiles the enemy is able to see the Player
  Sensor = 7
  
  # Default enemy knockdown self switch (used to display knockdowned graphic)
  KnockdownSelfW = "C"
  
  # Deafault Enemy collapse
  DefaultCollapse = 'zoom_vertical'
  
  # While in party battle on map, the game player is the manager of the group
  # Which distance the player can see the enemies?, this is used, to determine
  # wheter the follower can start fighting. enemy away from this tiles
  # whil be ignored untill the player is near them
  # distamce measured in tiles
  PlayerRange = 7
  
  # When a follower fail an action this balloon is played, runs out of mana etc.
  FailBalloon = 1
  
  # Start the game with the ABS huds turned on?
  StartWithHud = true
  
  # Do you want to activate the followers dead poses?
  FollowerDeadPose = true
  
  # Do you want to activate the single player mode?
  # this only avoid you accesing the player slection menu and the K key is used
  # to open the quick tool selection menu
  SinglePlayer = false
  
  #-----------------------------------------------------------------------------
  @gaugeback = Color.new(0, 0, 0, 100)
  def self.draw_hp(obj, battler, x, y, w, h, color, name=nil)
    tag = 'Hp' ; c = color
    name = battler.name if !name.nil?
    draw_gauge(obj, battler.hp, battler.mhp, x, y, w, h, c, tag, name)
  end
  
  def self.draw_mp(obj, battler, x, y, w, h, color, name=nil)
    tag = 'Ep' ; c = color
    name = battler.name if !name.nil?
    draw_gauge(obj, battler.mp, battler.mmp, x, y, w, h, c, tag, name)
  end
  
  def self.draw_exp(obj, battler, x, y, w, h, color, name=nil)
    tag = 'Exp' ; c = color
    name = battler.name if !name.nil?
    draw_gauge(obj,battler.exp, battler.next_level_exp, x, y, w, h, c, tag,name)
  end
  
  def self.draw_tp(obj, x, y, actor)
    string = 'Tp ' + (actor.tp).to_i.to_s
    obj.fill_rect(x, y + 10 , string.length * 9, 12, @gaugeback)
    obj.draw_text(x, y, obj.width, 32, string)
  end
  
  def self.draw_gauge(obj, nm, max, x, y, w, h, col, tag, name)
    obj.font.shadow = true
    w2 = w - 2 ; max = 1 if max == 0
    obj.fill_rect(x, y - 1, w, h + 2, @gaugeback)
    obj.fill_rect(x+1, y+1, w2*nm/max, h/2 - 1, col[0])
    obj.fill_rect(x+1, y + h/2, w2*nm/max, h/2 - 1, col[1])
    obj.draw_text(x, y + h - 22, w, 32, nm.to_s, 2)
    obj.draw_text(x + 4, y + h - 22, w, 32, tag)
    obj.draw_text(x, y - 25, w, 32, name, 1) if !name.nil?
  end
  
  # image based bars definition 
  def self.image_hp(bitmap, x, y, back, image, battler, name=nil)
    tag = 'Hp'
    name = battler.name if !name.nil?
    draw_i_gauge(bitmap, x, y, back, image, battler.hp, battler.mhp, tag, name)
  end
  
  def self.image_mp(bitmap, x, y, back, image, battler, name=nil)
    tag = 'Ep'
    name = battler.name if !name.nil?
    draw_i_gauge(bitmap, x, y, back, image, battler.mp, battler.mmp, tag, name)
  end
  
  def self.image_exp(bitmap, x, y, back, image, battler, name=nil)
    tag = 'Exp'
    name = battler.name if !name.nil?
    exp, nexte = battler.exp, battler.next_level_exp
    draw_i_gauge(bitmap, x, y, back, image, exp, nexte, tag, name)
  end
  
  def self.draw_i_gauge(bitmap, x, y, back, image, nm, max, tag, name)
    cw = back.width  
    ch = back.height 
    max = 1 if max == 0
    src_rect = Rect.new(0, 0, cw, ch)    
    bitmap.blt(x - 10, y - ch + 30,  back, src_rect)
    cw = image.width  * nm / max
    ch = image.height 
    src_rect = Rect.new(0, 0, cw, ch)
    bitmap.blt(x - 10, y - ch + 30, image, src_rect)
    bitmap.draw_text(x - 4, y + back.height - 14, back.width, 32, tag)
    bitmap.draw_text(x - 12, y + back.height - 14, back.width, 32, nm.to_s, 2)
    bitmap.draw_text(x - 6, y - 10, back.width, 32, name, 1) if !name.nil?
  end
  
  def self.has_data?
    !user_graphic.nil?
  end
  
  def self.load_item(item) 
    @item = item
  end
  
  def self.user_graphic()      @item.tool_data("User Graphic = ", false)    end
  def self.user_animespeed()   @item.tool_data("User Anime Speed = ")       end
  def self.tool_cooldown()     @item.tool_data("Tool Cooldown = ")          end
  def self.tool_graphic()      @item.tool_data("Tool Graphic = ", false)    end
  def self.tool_index()        @item.tool_data("Tool Index = ")             end
  def self.tool_size()         @item.tool_data("Tool Size = ")              end
  def self.tool_distance()     @item.tool_data("Tool Distance = ")          end
  def self.tool_effectdelay()  @item.tool_data("Tool Effect Delay = ")      end
  def self.tool_destroydelay() @item.tool_data("Tool Destroy Delay = ")     end
  def self.tool_speed()         @item.tool_float("Tool Speed = ")            end
  def self.tool_castime()       @item.tool_data("Tool Cast Time = ")         end
  def self.tool_castanimation() @item.tool_data("Tool Cast Animation = ")    end
  def self.tool_blowpower()     @item.tool_data("Tool Blow Power = ")        end
  def self.tool_piercing()      @item.tool_data("Tool Piercing = ", false)   end
  def self.tool_animation() @item.tool_data("Tool Animation When = ", false) end
  def self.tool_anirepeat() @item.tool_data("Tool Animation Repeat = ",false)end
  def self.tool_special() @item.tool_data("Tool Special = ", false)          end
  def self.tool_target() @item.tool_data("Tool Target = ", false)            end
  def self.tool_invoke() @item.tool_data("Tool Invoke Skill = ")             end
  def self.tool_guardrate() @item.tool_data("Tool Guard Rate = ")            end
  def self.tool_knockdown() @item.tool_data("Tool Knockdown Rate = ")        end
  def self.tool_soundse() @item.tool_data("Tool Sound Se = ", false)         end
  def self.tool_itemcost() @item.tool_data("Tool Item Cost = ")              end
  def self.tool_shortjump() @item.tool_data("Tool Short Jump = ", false)     end
  def self.tool_through() @item.tool_data("Tool Through = ", false)          end
  def self.tool_priority() @item.tool_data("Tool Priority = ")               end
  def self.tool_selfdamage() @item.tool_data("Tool Self Damage = ", false)   end
  def self.tool_hitshake() @item.tool_data("Tool Hit Shake = ", false)       end
  def self.tool_combo() @item.tool_data("Tool Combo Tool = ", false)         end
  
  def self.knock_actor(actor)
    a = actor.actor.tool_data("Knockdown Graphic = ", false)
    b = actor.actor.tool_data("Knockdown Index = ")
    c = actor.actor.tool_data("Knockdown pattern = ")
    d = actor.actor.tool_data("Knockdown Direction = ")
    return nil if a.nil?
    return [a, b, c, d]
  end
  
  def self.jump_hit?(target)
    t = target.enemy.tool_data("Hit Jump = ", false) if target.is_a?(Game_Enemy)
    t = target.actor.tool_data("Hit Jump = ", false) if target.is_a?(Game_Actor)
    return true if !t.nil? and t == "true"
    return true if t.nil?
    return false
  end
  
  def self.voices(b)
    voices = b.actor.tool_data("Battler Voices = ",false) if b.is_a?(Game_Actor)
    voices = b.enemy.tool_data("Battler Voices = ",false) if b.is_a?(Game_Enemy)
    voices = voices.split(", ") unless voices.nil?
    voices
  end
  
  def self.hitvoices(b)
    voices = b.actor.tool_data("Hit Voices = ",false) if b.is_a?(Game_Actor)
    voices = b.enemy.tool_data("Hit Voices = ",false) if b.is_a?(Game_Enemy)
    voices = voices.split(", ") unless voices.nil?
    voices
  end
  
  # check for iconset
  def self.check_iconset(item, tag, object)
    data = item.tool_data(tag, false)
    return if data.nil?
    v = [item.icon_index, data.to_sym] if data == "animated" ||
    data == "static" || data == "shielding"
    object.is_a?(Projectile) ? object.pro_iconset = v : object.user_iconset = v
  end
  
  def self.clean_back?
    @clean_back == true
  end
end
($imported ||= {})["Falcao Pearl ABS Liquid"] = true
class RPG::BaseItem
  attr_reader :has_data
  def tool_data(comment, sw=true)
    if @note =~ /#{comment}(.*)/i
      @has_data = true
      return sw ? $1.to_i : $1.to_s.sub("\r","")
    end
  end
  
  def tool_float(comment)
    return  $1.to_f if @note =~ /#{comment}(.*)/i
  end
  
  def cool_enabled?
    @cd_dis = @note.include?("Tool Cooldown Display = true") if @cd_dis.nil?
    @cd_dis
  end
  
  def itemcost
    if @i_cost.nil?
      @note =~ /Tool Item Cost = (.*)/i ? @i_cost = $1.to_i : @i_cost = 0
    end
    @i_cost
  end
end
# Pearl ABS Input module
module PearlKey
 
  # numbers
  N0 = 0x30; N1 = 0x31; N2 = 0x32; N3 = 0x33; N4 = 0x34
  N5 = 0x35; N6 = 0x36; N7 = 0x37; N8 = 0x38; N9 = 0x39
  
  # keys
  A = 0x41; B = 0x42; C = 0x43; D = 0x44; E = 0x45
  F = 0x46; G = 0x47; H = 0x48; I = 0x49; J = 0x4A
  K = 0x4B; L = 0x4C; M = 0x4D; N = 0x4E; O = 0x4F
  P = 0x50; Q = 0x51; R = 0x52; S = 0x53; T = 0x54
  U = 0x55; V = 0x56; W = 0x57; X = 0x58; Y = 0x59; Z = 0x5A
  @unpack_string = 'b'*256
  @last_array = '0'*256
  @press = Array.new(256, false)
  @trigger = Array.new(256, false)
  @release = Array.new(256, false)
  @getKeyboardState = Win32API.new('user32', 'GetKeyboardState', ['P'], 'V')
  @getAsyncKeyState = Win32API.new('user32', 'GetAsyncKeyState', 'i', 'i')
  @getKeyboardState.call(@last_array)
  
  @last_array = @last_array.unpack(@unpack_string)
  for i in 0...@last_array.size
    @press[i] = @getAsyncKeyState.call(i) == 0 ? false : true
  end
 
  def self.update
    @trigger = Array.new(256, false)
    @release = Array.new(256, false)
    array = '0'*256
    @getKeyboardState.call(array)
    array = array.unpack(@unpack_string)
    for i in 0...array.size
      if array[i] != @last_array[i]
        @press[i] = @getAsyncKeyState.call(i) == 0 ? false : true
        if !@press[i]
          @release[i] = true
        else
          @trigger[i] = true
        end
      else
        if @press[i] == true
          @press[i] = @getAsyncKeyState.call(i) == 0 ? false : true
          @release[i] = true if !@press[i]
        end
      end
    end
    @last_array = array
  end
  
  def self.press?(key)
    return Input.press?(key)
  end
 
  def self.trigger?(key)
    return Input.trigger?(key)
  end
end
# Input module update engine
class << Input
  alias falcaopearl_abs_cooldown_update update
  def Input.update
    update_pearl_abs_cooldown
    update_popwindow if !$game_temp.nil? and !$game_temp.pop_windowdata.nil?
    update_pearl_abs_respawn
    falcaopearl_abs_cooldown_update
  end
  
  
  def update_pearl_abs_respawn
    $game_map.event_enemies.each do |event|
      if event.respawn_count > 0
        event.respawn_count -= 1
        if event.respawn_count == 0
          event.battler.remove_state(event.battler.death_state_id)
          event.battler.hp = event.battler.mhp
          event.battler.mp = event.battler.mmp
          event.apply_respawn
          event.animation_id = event.respawn_anim
        end
      end
    end
  end
  
  alias falcaopearl_trigger trigger?
  def trigger?(constant)
    return true if constant == :B and PearlKey.trigger?(PearlKey::B)
    falcaopearl_trigger(constant)
  end
  
  # pop window global
  def update_popwindow
    $game_temp.pop_windowdata[0] -= 1 if $game_temp.pop_windowdata[0] > 0
    if @temp_window.nil?
      tag = $game_temp.pop_windowdata[2]
      string = $game_temp.pop_windowdata[1] + tag
      width = (string.length * 9) - 10
      x, y = Graphics.width / 2 - width / 2,  Graphics.height / 2 - 64 / 2
      @temp_window = Window_Base.new(x, y, width, 64)
      @temp_window.contents.font.size = 20
      @temp_window.draw_text(-10, -6, width, 32, tag, 1)
      @temp_window.draw_text(-10, 14, width, 32, $game_temp.pop_windowdata[1],1)
      @current_scene = SceneManager.scene.class 
    end
    
    if $game_temp.pop_windowdata[0] == 0 || 
      @current_scene != SceneManager.scene.class 
      @temp_window.dispose
      @temp_window = nil
      $game_temp.pop_windowdata = nil
    end
  end
  
  def update_pearl_abs_cooldown
    PearlKey.update
    eval_cooldown($game_party.all_members) if !$game_party.nil?
    eval_cooldown($game_map.enemies) if !$game_map.nil?
  end
  
  # cooldown update
  def eval_cooldown(operand)
    for sub in operand
      sub.skill_cooldown.each {|sid, sv| # skill
      if sub.skill_cooldown[sid] > 0
        sub.skill_cooldown[sid] -= 1
        sub.skill_cooldown.delete(sid) if sub.skill_cooldown[sid] == 0
      end}
      sub.item_cooldown.each {|iid, iv| # item
      if sub.item_cooldown[iid] > 0
        sub.item_cooldown[iid] -= 1
        sub.item_cooldown.delete(iid) if sub.item_cooldown[iid] == 0
      end}
      sub.weapon_cooldown.each {|wid, wv| # weapon
      if sub.weapon_cooldown[wid] > 0
        sub.weapon_cooldown[wid] -= 1
        sub.weapon_cooldown.delete(wid) if sub.weapon_cooldown[wid] == 0
      end}
      sub.armor_cooldown.each {|aid, av| #armor
      if sub.armor_cooldown[aid] > 0
        sub.armor_cooldown[aid] -= 1 
        sub.armor_cooldown.delete(aid) if sub.armor_cooldown[aid] == 0
      end}
    end
  end
end
