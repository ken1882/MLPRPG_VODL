#==============================================================================
# ■ Window_StatusCommand
#==============================================================================
class Window_StatusCommand < Window_Command
  #-----------------------------------------------------------------------------
  MouseTimer = 5
  #-----------------------------------------------------------------------------
  def get_mouse_timer
    return MouseTimer
  end
  #-----------------------------------------------------------------------------
end
#==============================================================================
# ■ Window_StatusItem
#==============================================================================
class Window_StatusItem < Window_Base
  #-----------------------------------------------------------------------------
  attr_accessor :skillbar
  #--------------------------------------------------------------------------
  # * alias method : initialize
  #--------------------------------------------------------------------------
  alias init_skillbar initialize
  def initialize(dx, dy, command_window)
    create_skillbar
    init_skillbar(dx, dy, command_window)
  end
  #--------------------------------------------------------------------------
  # * Create skillbar instance
  #--------------------------------------------------------------------------
  def create_skillbar
    @skillbar = $game_party.skillbar
    @skillbar.create_layout(SceneManager.viewport, 1)
    @skillbar.hide
  end
  #--------------------------------------------------------------------------
  # * alias: refresh
  #--------------------------------------------------------------------------
  alias refresh_skillbar refresh
  def refresh
    ori_opa = self.opacity
    @skillbar.hide
    refresh_skillbar
    self.opacity = ori_opa
  end
  #--------------------------------------------------------------------------
  # * alias method: draw actor general
  #--------------------------------------------------------------------------
  alias draw_actor_general_skillbar draw_actor_general
  def draw_actor_general
    @skillbar.show
    @skillbar.z = self.z + 1
    @skillbar.refresh(@actor)
    draw_actor_general_skillbar
  end
  #--------------------------------------------------------------------------
  # * Draw current setting of tactic logic
  #--------------------------------------------------------------------------
  def draw_tactic_overview
  end # queued: tactics AI
  #--------------------------------------------------------------------------
  # * dispose window
  #--------------------------------------------------------------------------
  def dispose
    @skillbar.dispose_layout
    super
  end
  #-----------------------------------------------------------------------------
end
#==============================================================================
# ■ Scene_Status
#==============================================================================
class Scene_Status < Scene_MenuBase
  #--------------------------------------------------------------------------
  alias start_scstat start
  def start
    start_scstat
    @skillbar = @item_window.skillbar
    create_foreground
  end
  #--------------------------------------------------------------------------
  alias update_scstat_skillbar update
  def update
    update_scstat_skillbar
    return unless @skillbar.edit_enabled
    @skillbar.update
    on_edit_end
  end
  #--------------------------------------------------------------------------
  def create_foreground
    @foreground = Sprite.new(@viewport)
    @foreground.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    wy = @help_window.height
    @foreground.bitmap.fill_rect(0, wy, Graphics.width, Graphics.height - wy, DND::COLOR::Black)
    cx = @skillbar.x + 32 * 4
    cy = @skillbar.y - 2
    crect = Rect.new(cx, cy, 32 * HotKeys::HotKeys.size, 32)
    @foreground.bitmap.clear_rect(crect)
    @foreground.z = PONY::SpriteDepth::Table[:foreground]
    @foreground.opacity = 196
    @foreground.hide
  end
  #--------------------------------------------------------------------------
  # * Activate edit mode of skillbar
  #--------------------------------------------------------------------------
  def edit_skillbar
    return unless @skillbar
    @skillbar.edit_enabled = true
    @help_window.set_text(Vocab::Skillbar::MouseEdit)
    @foreground.show
  end
  #--------------------------------------------------------------------------
  def on_edit_end
    return unless Input.trigger?(:B)
    @skillbar.cancel_edit
    Sound.play_cancel
    @command_window.activate
    @skillbar.unselect
    @foreground.hide
  end
  #--------------------------------------------------------------------------
  def call_tactic_scene
    @command_window.activate
    #raise_overlay_window(:popinfo, "Not available yet!")
    SceneManager.call(Scene_Tactic)
  end
  #--------------------------------------------------------------------------
  alias terminate_scstat terminate
  def terminate
    @foreground.dispose
    terminate_scstat
  end
  
end
