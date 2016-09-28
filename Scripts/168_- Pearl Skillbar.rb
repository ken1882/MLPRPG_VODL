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
  LayOutImage = "Pearl Skillbar"
  
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
    
    if custom_pos.nil?
      @layout.x = 45
      @layout.y = Graphics.height - 50
    else
      @layout.x = custom_pos[0]
      @layout.y = custom_pos[1]
    end
    
    @layout.x = 45
    @layout.y = Graphics.height - 50
    @icons.x = @layout.x
    @icons.y = @layout.y
    
    
    self.x = 38
    self.y = Graphics.height - 35
    self.z = self.z + 1
    
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
    letters = [Key::Weapon[1], Key::Armor[1], Key::Item[1], Key::Item2[1], Key::Item3[1],
    Key::Follower[1], Key::Skill[1], Key::Skill2[1], Key::Skill3[1], Key::Skill4[1],
    Key::Skill5[1], Key::Skill6[1], Key::Skill7[1], Key::Skill8[1], Key::Skill9[1],
    Key::Skill10[1],Key::SSkill[1],
    ]
    x = 28
    for i in letters
      @info_keys.bitmap.draw_text(x, -2, @info_keys.bitmap.width, 32, i) 
      x += 32
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
    return :false if !item.cool_enabled? and type == 1
    if type == 2
      return item.tool_itemcost || !item.tool_itemcosttype.nil?
    end
    
  end
  #----------------------------------------------------------------------------
  # Refresh toolbar icons
  #----------------------------------------------------------------------------
  def refresh_icons
    @icons.bitmap.clear
    icon = [@actor.equips[0], @actor.equips[1], @actor.assigned_item,
    @actor.assigned_item2, @actor.assigned_item3, ToggleIcon, @actor.assigned_skill,
    @actor.assigned_skill2, @actor.assigned_skill3, @actor.assigned_skill4, 
    @actor.assigned_skill5, @actor.assigned_skill6, @actor.assigned_skill7, 
    @actor.assigned_skill8, @actor.assigned_skill9, @actor.assigned_skill10,
    @actor.assigned_sskill, 
    ]
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
    @now_equip = [@actor.equips[0], @actor.equips[1], @actor.assigned_item,
    @actor.assigned_item2, @actor.assigned_item3, ToggleIcon, @actor.assigned_skill,
    @actor.assigned_skill2, @actor.assigned_skill3, @actor.assigned_skill4, 
    @actor.assigned_skill5, @actor.assigned_skill6, @actor.assigned_skill7, 
    @actor.assigned_skill8, @actor.assigned_skill9, @actor.assigned_skill10,
    @actor.assigned_sskill, 
    ]
  end
  
  def update
    update_mouse_tiles if @mouse_exist
    update_cooldown
    update_ammo_tools
    update_usability_enable
    refresh_icons if @now_equip[0] != @actor.equips[0]
    refresh_icons if @now_equip[1] != @actor.equips[1]
    refresh_icons if @now_equip[2] != @actor.assigned_item
    refresh_icons if @now_equip[3] != @actor.assigned_item2
    refresh_icons if @now_equip[4] != @actor.assigned_skill
    refresh_icons if @now_equip[5] != @actor.assigned_skill2
    refresh_icons if @now_equip[6] != @actor.assigned_skill3
    refresh_icons if @now_equip[7] != @actor.assigned_skill4
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
  
  #-----------------------------------------------
  # ammunition engine
  def ammo_ready?(item)
    return false if item.nil?
    return true  if item.has_data.nil? && item.is_a?(RPG::Item) &&
    item.consumable
    return true  if item.ammo_type_id != nil
    return false if flagged(item, 2).nil?
    return true  if flagged(item, 2) != 0
    return false
  end
  
  # get item cost
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
  
  # Ammo refresher
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
    if ammo_ready?(@actor.assigned_item) 
      @inumber = itemcost(@actor.assigned_item)
      self.bitmap.draw_text(80, 10, 32,32, @inumber.to_s, 1)
    end
    #--------------------------------------------------------------------------
    if ammo_ready?(@actor.assigned_item2) 
      @inumber2 = itemcost(@actor.assigned_item2)
      self.bitmap.draw_text(112, 10, 32,32, @inumber2.to_s, 1) # item 2
    end
    #--------------------------------------------------------------------------
    if ammo_ready?(@actor.assigned_item3) 
      @inumber3 = itemcost(@actor.assigned_item3)
      self.bitmap.draw_text(144, 10, 32,32, @inumber3.to_s, 1) # item 2
    end
    
    #--------------------------------------------------------------------------
    if ammo_ready?(@actor.assigned_skill) 
      @snumber = itemcost(@actor.assigned_skill)
      self.bitmap.draw_text(208, 10, 32,32, @snumber.to_s, 1)
    end
    #--------------------------------------------------------------------------
    if ammo_ready?(@actor.assigned_skill2) 
      @snumber2 = itemcost(@actor.assigned_skill2)
      self.bitmap.draw_text(240, 10, 32,32, @snumber2.to_s, 1) # skill 2
    end
    #--------------------------------------------------------------------------
    if ammo_ready?(@actor.assigned_skill3) 
      @snumber3 = itemcost(@actor.assigned_skill3)
      self.bitmap.draw_text(272, 10, 32,32, @snumber3.to_s, 1) # skill 3
    end
    #--------------------------------------------------------------------------
    if ammo_ready?(@actor.assigned_skill4) 
      @snumber4 = itemcost(@actor.assigned_skill4)
      self.bitmap.draw_text(304, 10, 32,32, @snumber4.to_s, 1) # skill 4
    end
    #--------------------------------------------------------------------------
  end
  
  def update_ammo_tools
    refresh_texts if ammo_ready?(@actor.equips[0]) && 
    @wnumber != itemcost(@actor.equips[0])
    refresh_texts if ammo_ready?(@actor.equips[1]) && 
    @anumber != itemcost(@actor.equips[1])
    
    if ammo_ready?(@actor.assigned_item) && 
      @inumber != itemcost(@actor.assigned_item)
      refresh_texts 
    end
    refresh_texts if ammo_ready?(@actor.assigned_item2) && #@inumber2
    @inumber2 != itemcost(@actor.assigned_item2)
    refresh_texts if ammo_ready?(@actor.assigned_skill) && 
    @snumber != itemcost(@actor.assigned_skill)
    refresh_texts if ammo_ready?(@actor.assigned_skill2) && #@snumber2
    @snumber2 != itemcost(@actor.assigned_skill2)
    # new anmmo
    refresh_texts if ammo_ready?(@actor.assigned_skill3) && #@snumber3
    @snumber3 != itemcost(@actor.assigned_skill3)
    refresh_texts if ammo_ready?(@actor.assigned_skill4) && #@snumber4
    @snumber4 != itemcost(@actor.assigned_skill4)
  end
  
  #--------------------------------------
  # cooldown engine
  def cool_down_active?
    return true if skill_cooldown > 0 || weapon_cooldown > 0 ||
    armor_cooldown > 0 || item_cooldown > 0 || skill_cooldown2 > 0 ||
    item_cooldown2 > 0 || skill_cooldown3 > 0 || skill_cooldown4 > 0
    return false
  end
  
  def weapon_cooldown
    if !@actor.equips[0].nil?
      return 0 if flagged(@actor.equips[0], 1) == :false
      cd =  @actor.weapon_cooldown[@actor.equips[0].id]
      return cd unless cd.nil? 
    end
    return 0
  end
  
  def armor_cooldown
   if !@actor.equips[1].nil?
      return 0 if flagged(@actor.equips[1], 1) == :false
      cd = @actor.armor_cooldown[@actor.equips[1].id]
      return cd unless cd.nil? 
    end
    return 0
  end
  
  def item_cooldown
    if !@actor.assigned_item.nil?
      return 0 if flagged(@actor.assigned_item, 1) == :false
      cd = @actor.item_cooldown[@actor.assigned_item.id] 
      return cd unless cd.nil? 
    end
    return 0
  end
  
  def item_cooldown2
    if !@actor.assigned_item2.nil?
      return 0 if flagged(@actor.assigned_item2, 1) == :false
      cd = @actor.item_cooldown[@actor.assigned_item2.id] 
      return cd unless cd.nil? 
    end
    return 0
  end
  
  def skill_cooldown
    if !@actor.assigned_skill.nil?
      return 0 if flagged(@actor.assigned_skill, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill.id]
      return cd unless cd.nil? 
    end
    return 0
  end
  
  def skill_cooldown2
    if !@actor.assigned_skill2.nil?
      return 0 if flagged(@actor.assigned_skill2, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill2.id]
      return cd unless cd.nil? 
    end
    return 0
  end
  
  # two new skillls
  def skill_cooldown3
    if !@actor.assigned_skill3.nil?
      return 0 if flagged(@actor.assigned_skill3, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill3.id]
      return cd unless cd.nil? 
    end
    return 0
  end
  
  def skill_cooldown4 # 4
    if !@actor.assigned_skill4.nil?
      return 0 if flagged(@actor.assigned_skill4, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill4.id]
      return cd unless cd.nil? 
    end
    return 0
  end
  
  
  # Cooldown refresher
  def refresh_cooldown
    wcd = number(weapon_cooldown)
    self.bitmap.draw_text(18, 36,32,32, wcd.to_s, 1) if weapon_cooldown > 10
    acd = number(armor_cooldown)
    self.bitmap.draw_text(50, 36,32,32, acd.to_s, 1) if armor_cooldown > 10
    icd = number(item_cooldown)
    self.bitmap.draw_text(82, 36,32,32, icd.to_s, 1) if item_cooldown > 10
    icd2 = number(item_cooldown2)
    self.bitmap.draw_text(112, 36,32,32, icd2.to_s, 1) if item_cooldown2 > 10
    scd = number(skill_cooldown)
    self.bitmap.draw_text(144, 36,32,32, scd.to_s, 1) if skill_cooldown > 10
    scd2 = number(skill_cooldown2)
    self.bitmap.draw_text(176, 36,32,32, scd2.to_s, 1) if skill_cooldown2 > 10
    scd3 = number(skill_cooldown3)
    self.bitmap.draw_text(208, 36,32,32, scd3.to_s, 1) if skill_cooldown3 > 10
    scd4 = number(skill_cooldown4)
    self.bitmap.draw_text(240, 36,32,32, scd4.to_s, 1) if skill_cooldown4 > 10
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
    mx = (Mouse.pos[0] / 32) ; my = (Mouse.pos[1] / 32)
    case [mx, my]
    when [Tile_X,     Tile_Y] then $game_player.mouse_over = 1
    when [Tile_X + 1, Tile_Y] then $game_player.mouse_over = 2
    when [Tile_X + 2, Tile_Y] then $game_player.mouse_over = 3
    when [Tile_X + 3, Tile_Y] then $game_player.mouse_over = 4
    when [Tile_X + 4, Tile_Y] then $game_player.mouse_over = 5
    when [Tile_X + 5, Tile_Y] then $game_player.mouse_over = 6
    when [Tile_X + 6, Tile_Y] then $game_player.mouse_over = 7
    when [Tile_X + 7, Tile_Y] then $game_player.mouse_over = 8
    when [Tile_X + 8, Tile_Y] then $game_player.mouse_over = 9
    else 
      $game_player.mouse_over = 0 if $game_player.mouse_over != 0
    end
    if $game_player.mouse_over > 0
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
    case $game_player.mouse_over
    when 1 then @mouse_blink.x = @layout.x + (5)
    when 2 then @mouse_blink.x = @layout.x + (5 + 32)
    when 3 then @mouse_blink.x = @layout.x + (5 + 64)
    when 4 then @mouse_blink.x = @layout.x + (5 + 96)
    when 5 then @mouse_blink.x = @layout.x + (5 + 128)
    when 6 then @mouse_blink.x = @layout.x + (5 + 160)
    when 7 then @mouse_blink.x = @layout.x + (5 + 192)
    when 8 then @mouse_blink.x = @layout.x + (5 + 224)
    when 9 then @mouse_blink.x = @layout.x + (5 + 256)
    end
  end
  
  def create_mouse_blink
    return if !@mouse_blink.nil?
    @mouse_blink = ::Sprite.new(@view)
    @mouse_blink.bitmap = Bitmap.new(22, 22)
    @mouse_blink.bitmap.fill_rect(0, 0, 22, 22, Color.new(255,255,255))
    @mouse_blink.y = @layout.y + 8
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
