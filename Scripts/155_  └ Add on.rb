#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a super class of all windows within the game.
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system(WindowSkin::Default) if !self.windowskin
    update_padding
    update_tone
    create_contents
    @opening = @closing = false
  end
  #--------------------------------------------------------------------------
  def swap_skin(skin = WindowSkin::Default)
    return unless WindowSkin::Enable
    self.windowskin = skin
  end
  #--------------------------------------------------------------------------
  # * Draw text in static position
  #--------------------------------------------------------------------------
  def draw_code_text(x, y, text)
    width = (Font.default_size * 0.5).to_i
    cnt = 0
    text = "" unless text
    text.each_char do |char|
      bsize = [char.bytesize, 2].min
      rect = Rect.new(x + width * cnt, y, width * bsize, line_height)
      if char.ord == 10
        cnt = 0
        y += line_height
      else
        draw_text(rect, char)
        cnt += bsize
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Start button cooldown
  #--------------------------------------------------------------------------
  def heatup_button(multipler = 1)
    SceneManager.scene.heatup_button(multipler) rescue false
  end
  #--------------------------------------------------------------------------
  # * Button cooldown finished
  #--------------------------------------------------------------------------
  def button_cooled?
    SceneManager.scene.button_cooled? rescue false
  end
  #--------------------------------------------------------------------------
  # * Window visible? tag: modified
  #--------------------------------------------------------------------------
  def visible?
    return visible
  end
  #--------------------------------------------------------------------------
  # * Window Active
  #--------------------------------------------------------------------------
  def active?
    return active
  end
  #--------------------------------------------------------------------------
  # * Icon Sprite Creation
  #--------------------------------------------------------------------------
  def create_icon_sprite(x, y, z, icon_index)
    sprite        = Sprite.new
    sprite.x      = x
    sprite.y      = y
    sprite.z      = z
    sprite.bitmap = Bitmap.new(24,24)
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    sprite.bitmap.blt(0, 0, Cache.iconset, rect)
    return sprite
  end
  #--------------------------------------------------------------------------
  def text_width_for_rect(text)
    return contents.text_size(text).width + contents.font.size
  end
  #--------------------------------------------------------------------------
end
