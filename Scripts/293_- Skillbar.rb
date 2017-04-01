#===============================================================================
# * Falcao Pearl ABS script shelf # 4
#
# This script handles the Skillbar funtions
# it is designed to support the 'Mouse System Buttons script 1.6 and above too
# you can trigger tools by clicking the icons on the toolbar!
#===============================================================================
module PearlSkillBar
  
  # Skillbar X position in tiles
  Tile_X = 2
  
  # Skillbar Y position in tiles
  Tile_Y = 14
  
  # Layout graphic
  LayOutImage = "Skillbar"
  
  # Follower attack command icon index
  ToggleIcon = 116
  
  #    * Commands
  #
  # PearlSkillBar.hide        - hide the skillbar 
  # PearlSkillBar.show        - show the skillbar
  #-----------------------------------------------------------------------------
  
  def self.hide
    $game_system.skillbar_enable = true
  end
  
  def self.show
    $game_system.skillbar_enable = nil
  end
  
  def self.hidden?
    !$game_system.skillbar_enable.nil?
  end
end
class Game_System
  attr_accessor :skillbar_enable, :pearlbars, :enemy_lifeobject
  alias falcaopearl_abs_hud initialize
  def initialize
    unless PearlKernel::StartWithHud
      @skillbar_enable = true
      @pearlbars = true
    end
    falcaopearl_abs_hud
  end
end
class Sprite_PearlTool < Sprite
  include PearlSkillBar
  attr_accessor :actor
  def initialize(view, custom_pos=nil)
    super(view)
    @layout = ::Sprite.new(view)
    @layout.bitmap = Cache.picture(LayOutImage)
    @icons = ::Sprite.new(view)
    @icons.bitmap = Bitmap.new(@layout.bitmap.width, @layout.bitmap.height)
    self.bitmap = Bitmap.new(@layout.bitmap.width+32, @layout.bitmap.height+32)
    
    
    @layout.x = (Graphics.width - @layout.bitmap.width) / 2
    @layout.y = Graphics.height - 50
    @icons.x = @layout.x
    @icons.y = @layout.y
    $game_variables.global_vars[:skillbar_pos] = POS.new(@layout.x, @layout.y)
    self.x = @layout.x
    self.y = @layout.y
    self.z = self.z + 1
    
    
    @item_hash_value = 0  # hash value
    
    @actor = $game_player.actor
    @actor.apply_usability
    @old_usability = []
    8.times.each {|i| @old_usability[i] = @actor.usability[i]}
    @framer = 0
    @info_keys = ::Sprite.new(view)
    @info_keys.bitmap = Bitmap.new(self.bitmap.width, self.bitmap.height)
    @info_keys.x = self.x; @info_keys.y = self.y; @info_keys.z = self.z
    draw_key_info
    refresh_icons
    refresh_texts
    @view = view
    @on_map = SceneManager.scene_is?(Scene_Map)
    @mouse_exist = defined?(Map_Buttons).is_a?(String)
    @mouse_exist = false if @mouse_exist && !SceneManager.scene_is?(Scene_Map)
    update
  end
  
  def draw_key_info
    @info_keys.bitmap.font.size = 15
    letters = HotKeys::SkillBar
    cx = 22
    for i in letters
      name = HotKeys.name(i)
      @info_keys.bitmap.draw_text(cx, 6, @info_keys.bitmap.width, 32, name)
      cx += 32
    end
  end
  
  def refresh_texts
    self.bitmap.clear
    self.bitmap.font.size = 15
    refresh_cooldown
    refresh_ammo
  end
  
  def number(operand)
    return (operand / 60).to_i + 1
  end
  #----------------------------------------------------------------------------
  # *) Blame the original scripter
  #----------------------------------------------------------------------------
  def flagged(item, type)
    return :false if !item.cool_enabled? && type == 1
    if type == 2
      return item.tool_itemcost || !item.tool_itemcosttype.nil?
    end
    return true
  end
  #----------------------------------------------------------------------------
  # Refresh toolbar icons
  #----------------------------------------------------------------------------
  def refresh_icons
    @icons.bitmap.clear
    icon = @actor.get_equipped_items
    icon.push(ToggleIcon)
    
    x = 4
    icon.each {|i| 
    if !i.nil? and !i.is_a?(Fixnum)
      if i.is_a?(RPG::Item) || i.is_a?(RPG::Skill)
        draw_icon(i.icon_index, x, 6, @actor.usable?(i))
      else
        if i.is_a?(RPG::Weapon)
          enable = @actor.usability[0] ; enable = true if enable.nil?
          draw_icon(i.icon_index, x, 6, enable)
        elsif i.is_a?(RPG::Armor)
           enable = @actor.usability[1] ; enable = true if enable.nil?
           draw_icon(i.icon_index, x, 6, enable)
        end
      end
    end
    
    draw_icon(i, x, 6) if i.is_a?(Fixnum) ; x += 32}
    @now_equip = @actor.get_equipped_items
  end
  
  def update
    update_mouse_tiles if @mouse_exist
    update_cooldown
    update_ammo_tools
    update_usability_enable
    
    cur_equips = @actor.get_equipped_items
    cur_equips.each_index do |i|
      if cur_equips[i] != @now_equip[i]
        refresh_icons
        break
      end
    end
    
    update_fade_effect
  end
  
  # fade effect when player is behind the toolbar
  def update_fade_effect
    if behind_toolbar?
      if self.opacity >= 60
        self.opacity -= 10
        @layout.opacity = @icons.opacity = @info_keys.opacity = self.opacity
      end
    elsif self.opacity != 255
      self.opacity += 10
      @layout.opacity = @icons.opacity = @info_keys.opacity = self.opacity
    end
  end
  
  def behind_toolbar?
    return false unless @on_map
    px = ($game_player.screen_x / 32).to_i
    py = ($game_player.screen_y / 32).to_i
    17.times.each {|x| return true if px == Tile_X + x and py == Tile_Y}
    return false
  end
  
  # refresh the icons when the usability change
  def update_usability_enable
    8.times.each {|i| refresh_icons if @old_usability[i] != @actor.usability[i]}
  end
  
  #--------------------------------------------------------------------------
  # *) Ammunition engine
  #--------------------------------------------------------------------------
  def ammo_ready?(item)
    return false if item.nil?
    return true  if item.has_data.nil? && item.is_a?(RPG::Item) &&
    item.consumable
    return true  if item.methods.include?(:ammo_type_id) && !item.ammo_type_id.nil?
    return false if flagged(item, 2).nil?
    return true  if flagged(item, 2) != 0
    return false
  end
  #--------------------------------------------------------------------------
  # *) Get Item cost
  #--------------------------------------------------------------------------
  def itemcost(item)
    return $game_party.item_number(item) if item.has_data.nil? &&
    item.is_a?(RPG::Item) && item.consumble && item.ammo_type_id.nil?
    ammo_slot_id = @actor.class.ammo_slot_id
    if !flagged(item, 2).nil? and flagged(item, 2) != 0
      return $game_party.item_number($data_items[flagged(item, 2)])
    elsif @actor.equips[ammo_slot_id] != nil
      return $game_party.item_number(@actor.equips[ammo_slot_id]) + 1
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # *) Hash item number
  #--------------------------------------------------------------------------
  def hash_item_number(number)
    return (number << 2 | 1) << 1
  end
  #--------------------------------------------------------------------------
  # *) Refresh Ammos
  #--------------------------------------------------------------------------
  def refresh_ammo
    #--------------------------------------------------------------------------
    if ammo_ready?(@actor.equips[0]) 
      @wnumber = itemcost(@actor.equips[0])
      self.bitmap.draw_text(16, 10, 32,32, @wnumber.to_s, 1)
    end
    #--------------------------------------------------------------------------
    if ammo_ready?(@actor.equips[1]) 
      @anumber = itemcost(@actor.equips[1])
      self.bitmap.draw_text(48, 10, 32,32, @anumber.to_s, 1)
    end
    #--------------------------------------------------------------------------
    px = 48 + 32
    py = 10
    cnt = 0
    
    items = @actor.get_equipped_items(false)
    @item_hash_value = 0
    items.each do |item|
      if ammo_ready?(item)
        item_cost_number = itemcost(item)
        self.bitmap.draw_text(px + 32 * cnt, py, 32,32, item_cost_number.to_s, 1)
        @item_hash_value += hash_item_number(item.id + item_cost_number)
      end
      cnt += 1
    end
    #--------------------------------------------------------------------------
  end
  #--------------------------------------------------------------------------
  # *) Update ammo tools
  #--------------------------------------------------------------------------
  def update_ammo_tools
    refresh_texts if ammo_ready?(@actor.equips[0]) && 
    @wnumber != itemcost(@actor.equips[0])
    refresh_texts if ammo_ready?(@actor.equips[1]) && 
    @anumber != itemcost(@actor.equips[1])
    
    items = @actor.get_equipped_items(false)
    cur_item_hash_value = 0
    
    items.each do |item|
      if ammo_ready?(item)
        item_cost_number = itemcost(item)
        cur_item_hash_value += hash_item_number(item.id + item_cost_number)
      end
    end
    refresh_texts if @item_hash_value != cur_item_hash_value
  end
  
  #--------------------------------------------------------------------------
  # cooldown engine
  # tag: cooldown
  #--------------------------------------------------------------------------
  def cool_down_active?
    result = false
    result ||= weapon_cooldown > 0 || armor_cooldown > 0;
    
    cds = []
    items = @actor.get_equipped_items(false)
    items.each do |item| cds << object_cooldown(item) end
    result ||= cds.any? {|cooldown| cooldown > 0};
    
    return result
  end
  #--------------------------------------------------------------------------
  # *) weapon cooldown
  #--------------------------------------------------------------------------
  def weapon_cooldown
    if !@actor.equips[0].nil?
      return 0 if flagged(@actor.equips[0], 1) == :false
      cd =  @actor.weapon_cooldown[@actor.equips[0].id]
      return cd unless cd.nil? 
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # *) armor cooldown
  #--------------------------------------------------------------------------
  def armor_cooldown
   if !@actor.equips[1].nil?
      return 0 if flagged(@actor.equips[1], 1) == :false
      cd = @actor.armor_cooldown[@actor.equips[1].id]
      return cd unless cd.nil? 
    end
    return 0
  end
  #----------------------------------------------------------------------------
  # *) Item cooldowns
  #----------------------------------------------------------------------------
  def object_cooldown(item)
    return 0 if item.nil?
    return 0 if flagged(item, 1) == :false
    
    cooldown_item = 0
    if item.is_a?(RPG::Skill)
      cooldown_time = @actor.skill_cooldown[item.id]
    else
      cooldown_time = @actor.item_cooldown[item.id] 
    end
    cooldown_time = cooldown_time.nil? ? 0 : cooldown_time
    return cooldown_time
  end
  #----------------------------------------------------------------------------
  # *) Refresh Cooldown
  # tag: cooldown
  #----------------------------------------------------------------------------
  def refresh_cooldown
    wcd = number(weapon_cooldown)
    self.bitmap.draw_text(18, 36,32,32, wcd.to_s, 1) if weapon_cooldown > 10
    #--------------------------------------------------------------------------
    acd = number(armor_cooldown)
    self.bitmap.draw_text(50, 36,32,32, acd.to_s, 1) if armor_cooldown > 10
    #--------------------------------------------------------------------------
    items = @actor.get_equipped_items
    px = 82
    py = 36
    
    items.each do |item|
      cooldown_time = object_cooldown(item)
      cooldown_num  = number(cooldown_time)
      self.bitmap.draw_text(px, 36,32,32, cooldown_num.to_s, 1) if cooldown_time > 10
      px += 32
    end
    #--------------------------------------------------------------------------
  end
  
  def update_cooldown
    if @on_map and @actor != $game_player.actor
      @actor = $game_player.actor
      refresh_icons
      refresh_texts
    end
    
    if $game_player.refresh_skillbar > 0
      $game_player.refresh_skillbar -= 1
      if $game_player.refresh_skillbar == 0
        @actor.apply_usability
        refresh_icons
      end
    end
    
    if cool_down_active?
      refresh_texts if @framer == 0
      @framer += 1; @framer = 0 if @framer == 10 
    else
      @framer = 0
    end
  end
  
  # if mouse exist update the mouse settings
  def update_mouse_tiles
    
    offset = 30
    $game_player.mouse_skillbar_index = -1
    for i in 0...HotKeys::SkillBarSize
      $game_player.mouse_skillbar_index = i if Mouse.object_area?(@layout.x + i * 32, 
                                                        @layout.y, 
                                                        offset, offset)
    end    
    
    return if $ExtraEffects == false
    if $game_player.mouse_skillbar_index >= 0
      create_mouse_blink
      update_mouse_blink_position
      @mouse_blink.opacity -= 3
      @mouse_blink.opacity = 70 if @mouse_blink.opacity <= 6
    else
      dispose_mouse_blink
    end
  end
  
  # update mouse blink position
  def update_mouse_blink_position
    @mouse_blink.x = @layout.x + 5 + ($game_player.mouse_skillbar_index * 32)
  end
  
  def create_mouse_blink
    return if !@mouse_blink.nil?
    @mouse_blink = ::Sprite.new(@view)
    @mouse_blink.bitmap = Bitmap.new(22, 22)
    @mouse_blink.bitmap.fill_rect(0, 0, 22, 22, Color.new(255,255,255))
    @mouse_blink.y = @layout.y + 3
    @mouse_blink.z = self.z
    @mouse_blink.opacity = 70
  end
  
  def dispose_mouse_blink
    return if @mouse_blink.nil?
    @mouse_blink.dispose
    @mouse_blink = nil
  end
  #--------- end of mouse settings
  
  def dispose
    self.bitmap.dispose
    @layout.bitmap.dispose
    @layout.dispose
    @icons.bitmap.dispose
    @icons.dispose
    @info_keys.bitmap.dispose
    @info_keys.dispose
    super
  end
  
  def draw_icon(icon_index, x, y, enabled = true)
    bit = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    @icons.bitmap.blt(x, y, bit, rect, enabled ? 255 : 150)
  end
end
