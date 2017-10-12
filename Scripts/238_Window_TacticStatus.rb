#==============================================================================
# ** Window_TacticStatus
#------------------------------------------------------------------------------
#   Window display the selected battler's status on upper-right conrner in 
# tactic mode.
#==============================================================================
class Window_TacticStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  BarLayout = "HPEP_Layout"
  HP_Meter  = "HP_Meter"
  EP_Meter  = "EP_Meter"
  HP_Number = "HP_Number"
  EP_Number = "EP_Number"
  HPEP_Rect = Rect.new(0,0,160,60)
  BarRect   = Rect.new(0,0,128,8)
  DigitRect = Rect.new(0,0,18,21)
  HPBarRect = Rect.new(27,6,128,8)
  EPBarRect = Rect.new(27,44,128,8)
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x = Graphics.width - window_width, y = 0)
    super(x, y, window_width, window_height)
    @battler = nil
    create_layout
    hide
  end
  #--------------------------------------------------------------------------
  def window_width
    return 280
  end
  #--------------------------------------------------------------------------
  def window_height
    return 160
  end
  #--------------------------------------------------------------------------
  def contents_width
    width - standard_padding * 2
  end
  #--------------------------------------------------------------------------
  def contents_height
    height - standard_padding * 2
  end
  #--------------------------------------------------------------------------
  def update
    super
    return if @battler.nil?
    update_hp_effect
    update_mp_effect
  end
  #--------------------------------------------------------------------------
  # * Set current battler
  #--------------------------------------------------------------------------
  def setup_battler(battler)
    return if @battler == battler
    name = battler.nil? ? "nil" : battler.name
    @battler = battler
    refresh
  end
  #--------------------------------------------------------------------------
  def spacing
    return 8
  end
  #--------------------------------------------------------------------------
  # * Refresh contents
  #--------------------------------------------------------------------------
  def refresh
    clear_contents
    if BattleManager.valid_battler?(@battler)
      show
    else
      hide; return;
    end
    draw_battler_face
    draw_battler_name
    draw_battler_hp
    draw_battler_mp
    draw_battler_states
  end
  #--------------------------------------------------------------------------
  def create_layout
    @layout = Sprite.new
    @layout.bitmap = Cache.UI(BarLayout)
    @layout.x, @layout.y = self.x + spacing, self.y + line_height * 2 + spacing
    @layout.z = self.z + 1
    @fill_sprite = Sprite.new
    @fill_sprite.bitmap = Bitmap.new(@layout.width, @layout.height)
    @fill_sprite.x, @fill_sprite.y = @layout.x, @layout.y
    @fill_sprite.z = @layout.z + 1
    @text_sprite = Sprite.new
    @text_sprite.bitmap = Bitmap.new(@layout.width, @layout.height + line_height)
    @text_sprite.x, @text_sprite.y = @layout.x, @layout.y - line_height
    @text_sprite.z = @fill_sprite.z + 1
  end
  #--------------------------------------------------------------------------
  def draw_battler_face
    face_name  = @battler.face_name
    face_index = @battler.face_index
    x = window_width - 120 # 96 = face src rect width
    y = 0
    draw_face(face_name, face_index, x, y) if face_name && face_index
  end
  #--------------------------------------------------------------------------
  def draw_battler_name
    name = @battler.name rescue ""
    rect = Rect.new(8, 0, width, line_height)
    draw_text(rect, name, 0)
  end
  #--------------------------------------------------------------------------
  def draw_battler_hp
    mhp = battler.mhp == 0 ? 1 : battler.mhp
    @hp_cw = (battler.hp.to_f * HPBarRect.width / mhp).ceil
    @front_hp_rect  = BarRect.dup;
    @rear_hp_rect   = BarRect.dup;
    @rear_hp_rect.width = 0
    draw_hp_value
  end
  #--------------------------------------------------------------------------
  def draw_battler_mp
    mmp = battler.mmp == 0 ? 1 : battler.mmp
    @mp_cw = (battler.mp.to_f * EPBarRect.width / mmp).ceil
    @front_mp_rect  = BarRect.dup;
    @rear_mp_rect   = BarRect.dup;
    @rear_mp_rect.width = 0
    draw_mp_value
  end
    #--------------------------------------------------------------------------
  def draw_hp_value
    drect = HPBarRect.dup
    drect.y -= 2
    drect.height = line_height
    info = sprintf("%d/%d", battler.hp, battler.mhp)
    @text_sprite.bitmap.draw_text(drect, info, 2)
  end
    #--------------------------------------------------------------------------
  def draw_mp_value
    drect = EPBarRect.dup
    drect.height = line_height
    info = sprintf("%d/%d", battler.mp, battler.mmp)
    @text_sprite.bitmap.draw_text(drect, info, 2)
  end
  #--------------------------------------------------------------------------
  def draw_battler_states
    dx = spacing
    dy = contents_height - 32
    icons = @battler.state_icons
    reaction = PONY::StateID[:aggressive_level][@battler.aggressive_level]
    icons.unshift($data_states[reaction].icon_index)
    icons.each do |index|
      draw_icon(index, dx, dy)
      dx += 24
    end
  end
  #--------------------------------------------------------------------------
  def update_hp_effect
    return unless @hp_cw
    @fill_sprite.bitmap.clear_rect(HPBarRect)
    return if @hp_cw == 0
    bitmap = Cache.UI(HP_Meter)
    dx = HPBarRect.x; dy = HPBarRect.y;
    @rear_hp_rect.width  = (@rear_hp_rect.width + 1) % BarRect.width
    @front_hp_rect.width = BarRect.width - @rear_hp_rect.width
    @rear_hp_rect.x      = @front_hp_rect.width
    
    @fill_sprite.bitmap.blt(dx + @rear_hp_rect.width, dy, bitmap, @front_hp_rect)
    @fill_sprite.bitmap.blt(dx, dy, bitmap, @rear_hp_rect)
    crect = HPBarRect.dup
    crect.width -= @hp_cw; crect.x = dx + @hp_cw;
    @fill_sprite.bitmap.clear_rect(crect)
  end
  #--------------------------------------------------------------------------
  def update_mp_effect
    return unless @mp_cw
    @fill_sprite.bitmap.clear_rect(EPBarRect)
    return if @mp_cw == 0
    bitmap = Cache.UI(EP_Meter)
    dx = EPBarRect.x; dy = EPBarRect.y;
    @rear_mp_rect.width  = (@rear_mp_rect.width + 1) % BarRect.width
    @front_mp_rect.width = BarRect.width - @rear_mp_rect.width
    @rear_mp_rect.x      = @front_mp_rect.width
    
    @fill_sprite.bitmap.blt(dx + @rear_mp_rect.width, dy, bitmap, @front_mp_rect)
    @fill_sprite.bitmap.blt(dx, dy, bitmap, @rear_mp_rect)
    crect = EPBarRect.dup
    crect.width -= @mp_cw; crect.x = dx + @mp_cw;
    @fill_sprite.bitmap.clear_rect(crect)
  end
  #--------------------------------------------------------------------------
  def clear_contents
    contents.clear
    @text_sprite.bitmap.clear
  end
  #--------------------------------------------------------------------------
  def show
    @layout.show
    @fill_sprite.show
    @text_sprite.show
    super
  end
  #--------------------------------------------------------------------------
  def hide
    @layout.hide
    @fill_sprite.hide
    @text_sprite.hide
    super
  end
  #--------------------------------------------------------------------------
  def dispose
    @layout.dispose
    @fill_sprite.dispose
    @text_sprite.dispose
    super
  end
  #--------------------------------------------------------------------------
end
