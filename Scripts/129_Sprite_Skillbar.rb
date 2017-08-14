#==============================================================================
# ** Sprite_SkillBar
#------------------------------------------------------------------------------
#  Hotkey bar on the bottom of the screen.
#==============================================================================
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
    @instance = instance
    @dragging = false
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
    self.visible = !$game_switches[16] rescue true
    update_mouse_hover
    update_dragging
  end
  #--------------------------------------------------------------------------
  def refresh
    self.x = @instance.x
    self.y = @instance.y
    self.z = @instance.z
    @icon_sprite.z      = self.z + 2
    @cooldown_sprite.z  = self.z + 4
    @hover_overlay.z    = self.z + 6
    @text_sprite.z      = self.z + 8
    rect = Rect.new(0, 0, @icon_sprite.bitmap.width, @icon_sprite.bitmap.height)
    @icon_sprite.bitmap.clear_rect(rect)
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
  def create_cooldown_bitmap(viewport)
    @cooldown_sprite = Sprite.new(Viewport)
    @cooldown_sprite.x, @cooldown_sprite.y = self.x, self.y
    @cooldown_sprite.z = @icon_sprite.z + 1
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
    @instance.items.each do |item|
      cx += 32
      next if item.nil?
      enabled = item.is_a?(Numeric) || (actor.item_test(actor, item) && actor.usable?(item))
      icon_index = item.is_a?(Fixnum) ? item : item.icon_index
      bitmap = Cache.system("Iconset")
      rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      @icon_sprite.bitmap.blt(cx, cy, bitmap, rect, enabled ? 0xff : translucent_alpha)
    end
  end
  #--------------------------------------------------------------------------
  def drag_icon(index)
    item = @instance.items[index]
    icon_index = item.icon_index
    bitmap = Cache.system("Iconset")
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
  
  def actor
    @instance.actor
  end
  
end
