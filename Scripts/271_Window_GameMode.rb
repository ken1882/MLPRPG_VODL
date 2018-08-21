#==============================================================================
# ** Window_GameMode
#------------------------------------------------------------------------------
#  For selecting game mode in title screen, mostly are main/DLC/tutorial
#==============================================================================
class Window_GameMode < Window_ImageCommand
  include PONY::GameMode
  #------------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    self.back_opacity = 0xff
    swap_skin(WindowSkin::ModeWindow)
    create_cursor_sprite
  end
  #------------------------------------------------------------------------------
  def contents_width
    return Graphics.width
  end
  #------------------------------------------------------------------------------
  def contents_height
    return (item_height + standard_padding) * item_max + spacing
  end
  #------------------------------------------------------------------------------
  def window_height
    Graphics.height - 68
  end
  #-----------------------------------------------------------------------------
  def window_width
    Graphics.width + standard_padding * 2
  end
  #-----------------------------------------------------------------------------
  def item_height
    return 128
  end
  #-----------------------------------------------------------------------------
  def item_width
    Graphics.width
  end
  #-----------------------------------------------------------------------------
  def make_command_list
    for mode in Modes
      add_command(mode.name, mode.symbol, mode.image, mode.enabled, nil, mode.help)
    end
  end
  #-----------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.y += index * standard_padding
    rect
  end
  #-----------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    bmp = Cache.UI(@list[index][:image])
    src = Rect.new(0, 0, item_width, item_height)
    enabled = @list[index][:enabled]
    contents.blt(rect.x, rect.y, bmp, src, enabled ? 255 : translucent_alpha)
    bmp.dispose
    #-- draw mode name
    text_width = text_size(@list[index][:name]).width + 8
    offset = POS.new(38, 12)
    rect.x = rect.width - text_width - offset.x;
    rect.y = rect.y + rect.height - line_height - offset.y
    rect.width = text_width
    rect.height = line_height
    contents.draw_text(rect, @list[index][:name])
  end
  #-----------------------------------------------------------------------------
  def help_window=(hw)
    super
    refresh
  end
  #------------------------------------------------------------------------------
  def update_cursor(forced = false)
    return unless @cursor_sprite && (index_changed? || forced)
    rect = item_rect(@index)
    @cursor_sprite.x = self.x + rect.x + standard_padding
    @cursor_sprite.y = self.y + rect.y + standard_padding - self.oy
    Sound.play_cursor if active?
    case @index
    when 0
      @cursor_sprite.tone.set(Tone_VODL)
    when 1
      @cursor_sprite.tone.set(Tone_Tutorial)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Tone: Not needed
  #--------------------------------------------------------------------------
  def update_tone
  end
  #------------------------------------------------------------------------------
  def create_cursor_sprite
    @cursor_sprite = Sprite.new
    @cursor_sprite.bitmap = Cache.UI(CursorImage)
    @cursor_sprite.z = self.z + 1
    @child_sprite << @cursor_sprite
  end
  #------------------------------------------------------------------------------
  def set_z(nz)
    return unless nz
    super
    @cursor_sprite.z = nz + 1
  end
  #------------------------------------------------------------------------------
  def cursor_sprite
    @cursor_sprite
  end
  #------------------------------------------------------------------------------  
end # last work: title scene game mode stuff
