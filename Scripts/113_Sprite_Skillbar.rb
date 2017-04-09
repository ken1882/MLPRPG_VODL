#==============================================================================
# ** Sprite_SkillBar
#------------------------------------------------------------------------------
#  Hotkey bar on the bottom of the screen.
#==============================================================================
class Sprite_SkillBar < Sprite
  include PONY::SkillBar
  #--------------------------------------------------------------------------
  # *) Instance Vars
  #--------------------------------------------------------------------------
  attr_reader :instance
  #--------------------------------------------------------------------------
  # *) Object Initialization
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    build_link
    
    create_layout(viewport)
    self.bitmap = Bitmap.new(@layout.bitmap.width + 32, @layout.bitmap.height + 32)
    self.x = @layout.x
    self.y = @layout.y
    self.z = self.z + 1
    crate_infokeys(viewport)
    @framer = 0
    @page   = 0
    @viewport = viewport
    @mouse_exist = defined?(Map_Buttons).is_a?(String)
    @mouse_exist = false if @mouse_exist && !SceneManager.scene_is?(Scene_Map)
    refresh_icons
    refresh_texts
    @instance.apply_usability
    update
  end
  
  def build_link
    $game_party.skillbar.sprite = self
    @instance = $game_party.skillbar
    @instance.update
  end
  
  def destroy_link
    $game_party.skillbar.sprite = nil
    @instance.update
    @instance = nil
  end
  
  # Layout Image
  def create_layout(viewport)
    @layout = ::Sprite.new(viewport)
    @layout.bitmap = Cache.picture(LayOutImage)
    @icons = ::Sprite.new(viewport)
    @icons.bitmap = Bitmap.new(@layout.bitmap.width, @layout.bitmap.height)
    @layout.x = (Graphics.width - @layout.bitmap.width) / 2
    @layout.y = Graphics.height - 50
    @icons.x = @layout.x
    @icons.y = @layout.y
  end
  
  # Hotkey corresponding input
  def crate_infokeys(viewport)
    @info_keys = ::Sprite.new(viewport)
    @info_keys.bitmap = Bitmap.new(self.bitmap.width, self.bitmap.height)
    @info_keys.x = self.x; @info_keys.y = self.y; @info_keys.z = self.z
    draw_key_info
  end
  
  # Skillbar select phase
  def phase
    return @stack.size
  end
  
  # Return to last selection phase
  def return_selection
    return if phase == 1
    return @stack.pop
  end
  
  # Return last selection phase
  def last_selection
    return @stack[phase - 1]
  end
  #----------------------------------------------------------------------------
  # Refresh toolbar icons
  #----------------------------------------------------------------------------
  def refresh_icons(stage = nil)
    @icons.bitmap.clear
    stage = phase if stage
    case stage
    when HotKeySelection
      draw_hotkey_icons
    when CastSelection
      draw_hotkey_icons(last_selection)
    when AllSelection
      draw_selections(last_selection)
    end
  end
  
  # Draw skill bar icons; activated: selected item
  def draw_hotkey_icons(activated = nil)
    icon = actor.get_hotkeys
    draw_all_icons(icon)
  end
  
  # Draw selections and left/right arrow
  def draw_selections
    case last_selection
    when AllSkillIcon
      @icons = actor.skills.collect {|i| i.icon_index}
    when AllItemIcon
    when VancianIcon
    end
  end
  
  def top_col
    return HotKeys::SkillBarSize
  end
  
  def bot_col
    return 3 # Weapon(0), Armor(1), Follower(2)
  end
  
  # Draw previous 12 items
  def page_left
  end
  
  # Draw previous 12 items
  def page_right
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
  
  def draw_all_icons(icon)
    cx = 4
    cy = 36
    icon.each do |i|
      next if i.nil?
      enable = actor.usability[0] if i.is_a?(RPG::Weapon)
      enable = actor.usability[1] if i.is_a?(RPG::Armor)
      enable = actor.usable?(i)   if i.is_a?(RPG::Item) || i.is_a?(RPG::Skill)
      enable = true if enable.nil?
      icon_index = i.is_a?(Fixnum) ? i : i.icon_index
      draw_icon(icon_index, cx, cy, enable)
      cx += 32
    end
  end
  
  # Refresh cooldown and ammo text
  def refresh_texts
    self.bitmap.clear
    self.bitmap.font.size = 15
    refresh_cooldown
    refresh_ammo
  end
  
  # SkillBar update
  def update
    update_mouse_tiles if @mouse_exist
    update_cooldown
    update_ammo_tools
  end
  
  # Item require ammo?
  def need_ammo?(item)
    return (item.tool_itemcost > 0) || !item.tool_itemcosttype.nil?
  end
  #--------------------------------------------------------------------------
  # *) Ammunition engine
  #--------------------------------------------------------------------------
  def ammo_ready?(item)
    return false if item.nil?
    return need_ammo?(item)
  end
  #--------------------------------------------------------------------------
  # *) Refresh Ammos
  #--------------------------------------------------------------------------
  def refresh_ammo
    cx = 16
    cy = 10
    items = actor.get_hotkeys
    items.each do |item|
      if ammo_ready?(item)
        self.bitmap.draw_text(cx, cy, 32,32, ammo_number(item).to_s, 1)
      end
      cx += 32
    end
  end
  #--------------------------------------------------------------------------
  # * Query the number of item's ammo left in inventory
  #--------------------------------------------------------------------------
  def ammo_number(item)
    return unless need_ammo?(item)
    ammo_item = item.tool_itemcost > 0 ? $data_items[item.tool_itemcost] : actor.equips[2]
    return $game_party.item_number(ammo_item)
  end
  #--------------------------------------------------------------------------
  # *) Update ammo tools
  #--------------------------------------------------------------------------
  def update_ammo_tools
    refresh_texts if @instance.need_update?
  end
  #--------------------------------------------------------------------------
  # cooldown engine
  # tag: cooldown
  #--------------------------------------------------------------------------
  def cool_down_active?
    result = false
    cds = []
    items = actor.get_hotkeys
    items.each {|item| cds << object_cooldown(item)}
    result ||= cds.any? {|cooldown| cooldown > 0};
    
    return result
  end
  #----------------------------------------------------------------------------
  # *) Item cooldowns
  #----------------------------------------------------------------------------
  def object_cooldown(item)
    return 0 if item.nil?
    return 0 if !item.cool_enabled?
    
    cooldown_time = 0
    if item.is_a?(RPG::Skill)
      cooldown_time = actor.skill_cooldown[item.id] || 0
    else
      cooldown_time = actor.item_cooldown[item.id] || 0
    end
    
    return cooldown_time
  end
  #----------------------------------------------------------------------------
  # *) Refresh Cooldown
  # tag: cooldown
  #----------------------------------------------------------------------------
  def refresh_cooldown
    items = actor.get_hotkeys
    cx = 6
    cy = 6
    items.each do |item|
      cooldown_time = object_cooldown(item)
      self.bitmap.draw_text(cx, cy, 32, 32, cooldown_time.to_sec.to_s, 1) if cooldown_time > 10
      cx += 32
    end
    #--------------------------------------------------------------------------
  end
  
  def actor; @instance.actor; end
  
  def swap_actor
    @instance.update
    refresh_icons
    refresh_texts
  end
  
  def update_cooldown
    
    if $game_player.refresh_skillbar > 0
      $game_player.refresh_skillbar -= 1
      if $game_player.refresh_skillbar == 0
        @instance.apply_usability
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
    return unless Mouse.moved?
    offset = 30
    $game_player.mouse_skillbar_index = -1
    for i in 0...HotKeys::SkillBarSize
      $game_player.mouse_skillbar_index = i if Mouse.object_area?(@layout.x + i * 32, 
                                                        @layout.y, 
                                                        offset, offset)
    end
    
    if $game_player.mouse_skillbar_index >= 0
      create_mouse_hover
      update_mouse_hover_position
    else
      dispose_mouse_hover
    end
  end
  
  # update mouse blink position
  def update_mouse_hover_position
    @mouse_hover.x = @layout.x + 5 + ($game_player.mouse_skillbar_index * 32)
  end
  
  def create_mouse_hover
    return if !@mouse_hover.nil?
    @mouse_hover = ::Sprite.new(@view)
    @mouse_hover.bitmap = Bitmap.new(22, 22)
    @mouse_hover.bitmap.fill_rect(0, 0, 22, 22, Color.new(255,255,255))
    @mouse_hover.y = @layout.y + 3
    @mouse_hover.z = self.z
    @mouse_hover.opacity = 70
  end
  
  def dispose_mouse_hover
    return if @mouse_hover.nil?
    @mouse_hover.dispose
    @mouse_hover = nil
  end
  #--------- end of mouse settings
  def dispose
    destroy_link
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
