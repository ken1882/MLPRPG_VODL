#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  This class performs the item screen processing.
#==============================================================================
class Scene_Item < Scene_ItemBase
  include WALLPAPER_EX
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  HotkeyPauseTime  = 60
  #--------------------------------------------------------------------------
  # * Alias method: Start Processing
  #--------------------------------------------------------------------------
  alias start_dnd start
  def start
    start_dnd
    init_vars
    create_action_window
    create_skillbar
    create_foreground
  end
  #--------------------------------------------------------------------------
  def init_vars
    @hotkey_ok_pause = false
    @timer           = 0
  end
  #--------------------------------------------------------------------------
  alias update_scitemaction update
  def update
    update_scitemaction
    update_hotkey_selection if @skillbar.visible? && !@hotkey_ok_pause
    update_hotkey_timer if @hotkey_ok_pause
  end
  #--------------------------------------------------------------------------
  def update_hotkey_selection
    @skillbar.update
    assign_hotkey(@skillbar.get_monitor)
    on_hotekey_cancel if Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  def create_action_window
    @action_window = Window_ItemAction.new
    @action_window.set_handler(:use_ok,     method(:action_use))
    @action_window.set_handler(:sel_hotkey, method(:action_hotkey))
    @action_window.set_handler(:cancel, method(:on_action_cancel))
    @action_window.z = 200
    @action_window.deactivate
  end
  #--------------------------------------------------------------------------
  def create_skillbar
    @skillbar = $game_party.skillbar
    @skillbar.create_layout(@viewport, 1)
    @skillbar.hide
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
    @foreground.z = 2000
    @foreground.opacity = 196
    @foreground.hide
  end
  #--------------------------------------------------------------------------
  def update_hotkey_timer
    @timer += 1
    if @timer >= HotkeyPauseTime
      on_hotkey_end
      @timer = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    $game_party.last_item.object = item
    show_action_window
  end
  #--------------------------------------------------------------------------
  # * On action cancel
  #--------------------------------------------------------------------------
  def on_action_cancel
    hide_action_window(true)
  end
  #--------------------------------------------------------------------------
  def on_hotekey_cancel
    @skillbar.hide
    @foreground.hide
    on_action_cancel
    Sound.play_cancel
  end
  #--------------------------------------------------------------------------
  def show_action_window
    @action_window.x = [@item_window.cursor_rect.x + @action_window.width, Graphics.width - @action_window.width].min
    @action_window.y = @item_window.cursor_rect.y + @item_window.y
    @action_window.show.activate(item)
    @action_window.select(0)
  end
  #--------------------------------------------------------------------------
  def hide_action_window(reactive = false)
    @action_window.hide.deactivate
    activate_item_window if reactive
  end
  #--------------------------------------------------------------------------
  def action_use
    hide_action_window
    determine_item
  end
  #--------------------------------------------------------------------------
  def action_hotkey
    hide_action_window
    @help_window.clear
    @help_window.set_text("Select or presss 1~0 to set hotkey")
    @skillbar.show
    @foreground.show
    @skillbar.refresh
  end
  #--------------------------------------------------------------------------
  def assign_hotkey(index)
    return unless index
    @actor.assigned_hotkey[HotKeys.assigned_hotkey_index(index)] = item
    @skillbar.refresh
    on_hotkey_ok(index)
  end
  #--------------------------------------------------------------------------
  def on_hotkey_ok(index)
    Sound.play_ok
    keyname = HotKeys.name(HotKeys::SkillBar[index])
    info = sprintf("Success! You assigned %s at hotkey %s", item.name, keyname)
    @help_window.set_text(info)
    @hotkey_ok_pause = true
  end
  #--------------------------------------------------------------------------
  def on_hotkey_end
    @hotkey_ok_pause = false
    @skillbar.hide
    @foreground.hide
    on_action_cancel
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_ItemList.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,       method(:on_item_ok))
    @item_window.set_handler(:cancel,   method(:on_item_cancel))
    @item_window.set_handler(:next_actor_v, method(:next_actor))
    @item_window.set_handler(:prev_actor_c, method(:prev_actor))
    @category_window.item_window = @item_window
  end
  #--------------------------------------------------------------------------
  def on_actor_change
    @item_window.actor = @actor
    @skillbar.refresh(@actor)
  end
  #--------------------------------------------------------------------------
  alias terminate_scitemaction terminate
  def terminate
    @action_window.dispose
    @skillbar.dispose_layout
    @foreground.dispose
    terminate_scitemaction
  end
end
