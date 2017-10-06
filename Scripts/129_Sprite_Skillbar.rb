#==============================================================================
# ** Sprite_SkillBar
#------------------------------------------------------------------------------
#  Hotkey bar on the bottom of the screen.
#==============================================================================
#tag: skillbar
class Sprite_Skillbar < Sprite
  include PONY::SkillBar
  #--------------------------------------------------------------------------
  # *) Instance Vars
  #--------------------------------------------------------------------------
  attr_reader   :instance
  #--------------------------------------------------------------------------
  # *) Object Initialization
  #--------------------------------------------------------------------------
  def initialize(viewport, instance)
    super(viewport)
    @instance      = instance
    @dragging      = false
    @cooldown_flag = []
    create_layout
    create_text(viewport)
    create_icons(viewport)
    create_hover_bitmap(viewport)
    create_cooldown_sprite(viewport)
    create_dragging_sprite(viewport)
    unselect
  end
  #--------------------------------------------------------------------------
  def update
    super
    hide_sprite = $game_switches[16] rescue false
    if hide_sprite && visible?
      hide
    elsif !hide_sprite && !visible?
      show
    end
    update_mouse_hover
    update_dragging
    update_info
  end
  #--------------------------------------------------------------------------
  def refresh
    self.x = @instance.x
    self.y = @instance.y
    self.z = @instance.z
    clear_texts
    @icon_sprite.z      = self.z + 2
    @cooldown_sprite.z  = self.z + 4
    @hover_overlay.z    = self.z + 6
    @text_sprite.z      = self.z + 8
    @cooldown_flag      = []
    rect = Rect.new(0, 0, @icon_sprite.bitmap.width, @icon_sprite.bitmap.height)
    @icon_sprite.bitmap.clear_rect(rect)
    @cooldown_sprite.bitmap.clear
    draw_item_numbers
    draw_icons
  end
  #--------------------------------------------------------------------------
  def true_x; return (self.x + 4); end
  def true_y; return (self.y + 2); end
  #--------------------------------------------------------------------------
  # *) Create layout image
  #--------------------------------------------------------------------------
  def create_layout
    self.bitmap = Cache.UI(LayoutImage)
    self.x = Graphics.center_width(self.bitmap.width)
    self.y = Graphics.height - self.bitmap.height - 16
  end
  #--------------------------------------------------------------------------
  def create_text(viewport)
    @text_sprite = Sprite.new(viewport)
    @text_sprite.bitmap = Bitmap.new(self.width, self.height)
    @text_sprite.x, @text_sprite.y = self.x, self.y
    @text_sprite.z = self.z + 10
    draw_info_text
  end
  #--------------------------------------------------------------------------
  def create_cooldown_sprite(viewport)
    @cooldown_sprite = Sprite.new(viewport)
    @cooldown_sprite.bitmap = Bitmap.new(self.width, self.height)
    @cooldown_sprite.x, @cooldown_sprite.y = self.x, self.y
    @cooldown_sprite.z = @icon_sprite.z + 1
    @cooldown_sprite.opacity = translucent_alpha
  end
  #--------------------------------------------------------------------------
  def create_dragging_sprite(viewport)
    @drag_sprite = Sprite.new(viewport)
    @drag_sprite.bitmap = Bitmap.new(32, 32)
    @drag_sprite.z = 2000
  end
  #--------------------------------------------------------------------------
  # *) Draw corresponding interactive key to each hotkey slot
  #--------------------------------------------------------------------------
  def draw_info_text
    letters = HotKeys::SkillBar
    @text_sprite.bitmap.font.size = 16
    @text_sprite.bitmap.font.color.set(DND::COLOR::White)
    cx = 22
    for i in letters
      name = HotKeys.name(i)
      @text_sprite.bitmap.draw_text(cx, 6, 32, 32, name)
      cx += 32
    end
  end
  #--------------------------------------------------------------------------
  # *) Create hover/activated symbol
  #--------------------------------------------------------------------------
  def create_hover_bitmap(viewport)
    size = 24
    @hover_overlay = Sprite.new(viewport)
    @hover_overlay.x = true_x
    @hover_overlay.y = true_y
    @hover_overlay.z = self.z + 2
    @hover_overlay.opacity = 64
    
    rect = Rect.new(0, 0, size, size)
    @hover_overlay.bitmap = Bitmap.new(size, size)
    @hover_overlay.bitmap.fill_rect(rect, DND::COLOR::White)
    @hover_overlay.visible = false
  end
  #--------------------------------------------------------------------------
  def update_mouse_hover
    hovered = false
    for i in 0...HotKeys::SkillBarSize
      if (Mouse.hover_skillbar?(i))
        @hover_overlay.x = true_x + 32 * i
        hovered = true
        break
      end
    end
    @hover_overlay.visible = hovered
  end
  #--------------------------------------------------------------------------
  def create_icons(viewport)
    @icon_sprite = Sprite.new(viewport)
    @icon_sprite.x, @icon_sprite.y = self.x, self.y
    @icon_sprite.z = self.z + 1
    @icon_sprite.bitmap = Bitmap.new(self.width, self.height)
    draw_icons
  end
  #--------------------------------------------------------------------------
  def draw_icons
    cx = 4 - 32
    cy = 2
    @instance.items.each_with_index do |item, index|
      cx += 32
      next if item.nil?
      enabled = true
      if item.is_a?(Numeric) || item.is_a?(String)
        enabled = @instance.prev_page_available? if item == PrevPage_Flag
        enabled = @instance.next_page_available? if item == NextPage_Flag
      else
        enabled = actor.item_test(actor, item) && actor.usable?(item, true)
      end
      
      if item.is_a?(String)
        icon_index = item_hash = eval(item)
      elsif item.is_a?(Fixnum)
        icon_index = item_hash = item
      else
        icon_index = item.icon_index
        item_hash  = item.hashid
      end
      
      bitmap = Cache.iconset
      rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      @icon_sprite.bitmap.blt(cx, cy, bitmap, rect, enabled ? 0xff : translucent_alpha)
      @cooldown_flag[index] = true
    end
  end
  #--------------------------------------------------------------------------
  def drag_icon(index)
    item = @instance.items[index]
    icon_index = item.icon_index
    bitmap = Cache.iconset
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    @drag_sprite.bitmap.blt(0, 0, bitmap, rect, 0xff)
    @drag_sprite.x, @drag_sprite.y = *Mouse.pos
    @dragging = true
    @drag_sprite.show
    update_dragging
  end
  #--------------------------------------------------------------------------
  def release_drag
    rect = Rect.new(0, 0, 32, 32)
    @drag_sprite.bitmap.clear_rect(rect)
    @dragging = false
  end
  #--------------------------------------------------------------------------
  def update_dragging
    return unless @dragging
    @drag_sprite.x, @drag_sprite.y = *Mouse.pos
    @drag_sprite.x = [@drag_sprite.x - 16, 0].max
    @drag_sprite.y = [@drag_sprite.y - 16, 0].max
  end
  #--------------------------------------------------------------------------
  def update_info
    @instance.items.each_with_index do |item, index|
      cdt = actor.item_cooldown[item.id]    if item.is_a?(RPG::Item)
      cdt = actor.skill_cooldown[item.id]   if item.is_a?(RPG::Skill)
      cdt = actor.weapon_cooldown[item.id]  if item.is_a?(RPG::Weapon)
      cdt = actor.armor_cooldown[item.id]   if item.is_a?(RPG::Armor)
      next if cdt.nil?
      enabled = actor.cooldown_ready?(item)
      draw_cooldown_slot(index, enabled) if enabled != @cooldown_flag[index]
      draw_cooldown_text(index, item, cdt)
      @cooldown_flag[index] = enabled
    end
  end
  #--------------------------------------------------------------------------
  def draw_item_numbers
    @instance.items.each_with_index do |item, index|
      draw_item_number(index, consumable_item_count(item))
    end
  end
  #--------------------------------------------------------------------------
  def draw_item_number(index, number)
    rect = Rect.new(6 + 32 * index, 12, 16, 16)
    @text_sprite.bitmap.clear_rect(rect)
    return if number.nil?
    @text_sprite.bitmap.font.color.set(DND::COLOR::Green)
    @text_sprite.bitmap.draw_text(rect, number.to_s)
  end
  #--------------------------------------------------------------------------
  def draw_cooldown_slot(index, enabled)
    rect = Rect.new(4 + 32 * index, 2, 24, 24)
    return @cooldown_sprite.bitmap.clear_rect(rect) if enabled
    @cooldown_sprite.bitmap.fill_rect(rect, DND::COLOR::Black)
  end
  #--------------------------------------------------------------------------
  def draw_cooldown_text(index, item, cdt)
    rect = Rect.new(4 + 32 * index, 0, 32, 16)
    @text_sprite.bitmap.clear_rect(rect)
    return if item.tool_cooldown < 60 || (cdt | 0) == 0
    cdt = (cdt / 60.0)
    cdt = cdt < 1 ? cdt.round(1) : cdt.round(0)
    @text_sprite.bitmap.font.color.set(DND::COLOR::Yellow)
    @text_sprite.bitmap.draw_text(rect, cdt.to_s)
  end
  #--------------------------------------------------------------------------
  def clear_texts
    HotKeys::SkillBarSize.times do |index|
      # cooldown text
      rect = Rect.new(4 + 32 * index, 0, 32, 16)
      @text_sprite.bitmap.clear_rect(rect)
      # item numver text
      rect = Rect.new(6 + 32 * index, 12, 16, 16)
      @text_sprite.bitmap.clear_rect(rect)
    end
  end
  #--------------------------------------------------------------------------
  # * Return the value of the item need to be comsumed
  #--------------------------------------------------------------------------
  def consumable_item_count(item)
    if item.is_a?(RPG::BaseItem)
      if item.is_a?(RPG::Item)
        return $game_party.item_number(item)
      elsif item.is_a?(RPG::Weapon) && item.tool_itemcost_type > 0
        return $game_party.item_number(actor.current_ammo)
      elsif item.tool_itemcost || 0 > 0
        return $game_party.item_number($data_items[item.tool_itemcost])
      end
    end
    return nil
  end
  #--------------------------------------------------------------------------
  def unselect
    @hover_overlay.hide
  end
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose unless !self.bitmap || !self.bitmap.disposed?
    @icon_sprite.dispose
    @hover_overlay.dispose
    @text_sprite.dispose
    @drag_sprite.dispose
    @cooldown_sprite.dispose
    self.bitmap = nil
    super
  end
  #--------------------------------------------------------------------------
  def hide
    @icon_sprite.hide
    @hover_overlay.hide
    @text_sprite.hide
    @drag_sprite.hide
    @cooldown_sprite.hide
    super
  end
  #--------------------------------------------------------------------------
  def show
    @icon_sprite.show
    @hover_overlay.show
    @text_sprite.show
    @drag_sprite.show
    @cooldown_sprite.show
    unselect
    super
  end
  #--------------------------------------------------------------------------
  # * Get Alpha Value of Translucent Drawing
  #--------------------------------------------------------------------------
  def translucent_alpha
    return 160
  end
  #--------------------------------------------------------------------------
  def actor
    @instance.actor
  end
  
end
