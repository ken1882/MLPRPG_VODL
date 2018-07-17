#==============================================================================
# ** Pony
#------------------------------------------------------------------------------
#  Pony should poni pony
#==============================================================================
$imported = {} if $imported.nil?
module PONY
	module Menu_UI
		First_Item_Position =  [168, 20]
		Second_Item_Position = [10, 35]
    
    NAME_COLOR = {
      1 => Color.new(215, 170, 225),
      2 => Color.new(245, 140,  90),
      4 => Color.new(255, 255, 255),
      5 => Color.new( 60, 175, 230),
      6 => Color.new(250, 145, 250),
      7 => Color.new(235, 235, 140),
    }
    
	end
end
#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a super class of all windows within the game.
#==============================================================================
class Window_Base < Window
  include PONY::Menu_UI
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
    self.windowskin = skin.is_a?(String) ? Cache.system(skin) : skin
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
    return visible rescue false
  end
  #--------------------------------------------------------------------------
  # * Window Active
  #--------------------------------------------------------------------------
  def active?
    return active rescue false
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
  def select_cursor_needed?
    return false
  end
  #--------------------------------------------------------------------------
  # * Draw Name
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, x, y, width = 112)
    change_color(NAME_COLOR[actor.id])
    draw_text(x, y, width, line_height, actor.name)
  end
  #--------------------------------------------------------------------------
  # * Draw Class
  #--------------------------------------------------------------------------
  def draw_actor_class(actor, x, y, width = 200, dualwrap = false)
    change_color(normal_color)
    text = sprintf("%s %d", actor.class.name, actor.class_level[actor.class_id])
    if actor.dualclass_id > 0
      dt = sprintf("%s %d",actor.dualclass.name, actor.class_level[actor.dualclass_id])
      if dualwrap
        draw_text(x, y + line_height, width, line_height, dt)
      else
        text += '/' + dt
      end
    end
    draw_text(x, y, width, line_height, text)
  end
  #--------------------------------------------------------------------------
end
