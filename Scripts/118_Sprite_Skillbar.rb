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
    create_layout
    create_hover_bitmap(viewport)
  end
  #--------------------------------------------------------------------------
  def update
    super
    update_mouse_hover
  end
  #--------------------------------------------------------------------------
  def refresh
    
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
    draw_info_text
  end
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose unless !self.bitmap || !self.bitmap.disposed?
    self.bitmap = nil
    super
  end
  #--------------------------------------------------------------------------
  # *) Draw corresponding interactive key to each hotkey slot
  #--------------------------------------------------------------------------
  def draw_info_text
    letters = HotKeys::SkillBar
    self.bitmap.font.size = 16
    cx = 22
    for i in letters
      name = HotKeys.name(i)
      self.bitmap.draw_text(cx, 6, 32, 32, name)
      cx += 32
    end
    self.bitmap.font.size = Font.default_size
  end
  #--------------------------------------------------------------------------
  # *) Create hover/activated symbol
  #--------------------------------------------------------------------------
  def create_hover_bitmap(viewport)
    size = 24
    @hover_overlay = Sprite.new(viewport)
    @hover_overlay.x = true_x
    @hover_overlay.y = true_y
    @hover_overlay.z = self.z + 1
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
      end
    end
    @hover_overlay.visible = hovered
  end
  
end
