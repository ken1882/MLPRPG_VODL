#==============================================================================
# * Mouse add-ons
#==============================================================================
module Mouse
  #-----------------------------------------------------------------------------
  module_function
  #-----------------------------------------------------------------------------
  def global_cursor_visible?
    return @global_cursor_visible
  end
  #-----------------------------------------------------------------------------
  def hide_global_cursor
    @global_cursor_visible = false
    p 'hide cursor'
    ShowCursor.call(0)
  end
  #-----------------------------------------------------------------------------
  def show_global_cursor
    @global_cursor_visible = true
    p 'show cursor'
    ShowCursor.call(1)
  end
  #-----------------------------------------------------------------------------
  def scroll_up?
    return !@flag_scroll.nil? && @flag_scroll > 0
  end
  #-----------------------------------------------------------------------------
  def scroll_down?
    return !@flag_scroll.nil? && @flag_scroll < 0
  end
  #-----------------------------------------------------------------------------
  def flag_scroll=(stat)
    @flag_scroll = stat
  end
  #-----------------------------------------------------------------------------
  def collide_sprite?(sprite)
    return false if !sprite.is_a?(Rect) && sprite.disposed?
    return area?(sprite.x, sprite.y, sprite.width, sprite.height) rescue false
  end
  #-----------------------------------------------------------------------------
  # * Check if mouse pointer if over skillbar
  #-----------------------------------------------------------------------------
  def hover_skillbar?(index = nil)
    return false if $game_party.skillbar.sprite.nil? || $game_party.skillbar.sprite.disposed?
    sx = $game_party.skillbar.sprite.true_x
    sy = $game_party.skillbar.sprite.true_y
    return area?(sx, sy, $game_party.skillbar.sprite.width, 32) if index.nil?
    return area?(sx + 32 * index, sy, 32, 32) rescue false
  end
  #------------------------------------------------------------------------------
  # * Hotkey triggered?
  #------------------------------------------------------------------------------
  def trigger_skillbar?(index)
    return hover_skillbar?(index) && click?(1) rescue false
  end
  #------------------------------------------------------------------------------
  # * Check if pointer if hovered the UI in Scene Map
  #------------------------------------------------------------------------------
  def hover_UI?
    return false unless SceneManager.scene_is?(Scene_Map)
    return true  if hover_window_log?
    return true  if collide_sprite?($game_party.skillbar.sprite)
    return false
  end
  #------------------------------------------------------------------------------
  def hover_window_log?
    window = SceneManager.scene.window_log
    return false if !window
    return true  if collide_sprite?(window.button_sprite)
    return false if !window.active?
    return collide_sprite?(window)
  end
  #------------------------------------------------------------------------------
  def trigger_sprite?(sprite)
    return collide_sprite?(sprite) && click?(1) rescue false
  end
  #------------------------------------------------------------------------------
  # * Return shortest pixel range from a sprite
  #------------------------------------------------------------------------------
  def distance_to_sprite(sprite)
    area_id = determine_area(sprite)
    case area_id
    when 1; return Math.hypot(@pos[0] - sprite.x, @pos[1] - sprite.y - sprite.height)
    when 2; return @pos[1] - sprite.y - sprite.height
    when 3; return Math.hypot(@pos[0] - sprite.x - sprite.width, @pos[0] - sprite.y - sprite.height)
    when 4; return sprite.x - @pos[0];
    when 5; return 0;
    when 6; return @pos[0] - sprite.x - sprite.width;
    when 7; return Math.hypot(@pos[0] - sprite.x, @pos[1] - sprite.y);
    when 8; return sprite.y - @pos[1]
    when 9; return Math.hypot(@pos[0] - sprite.x - sprite.width, @pos[1] - sprite.y);
    end
  end
  #------------------------------------------------------------------------------
  def determine_area(sprite)
    return determine_y_area(4, sprite) if @pos[0] < sprite.x
    return determine_y_area(6, sprite) if @pos[0] > sprite.x + sprite.width
    return determine_y_area(5, sprite)
  end
  #------------------------------------------------------------------------------
  def determine_y_area(base, sprite)
    return base + 3 if @pos[1] < sprite.y
    return base - 3 if @pos[1] > sprite.y + sprite.height
    return base
  end
  #=============================================================================
  # * Sprite_Cursor
  #-----------------------------------------------------------------------------
  #   The Cursor Sprite for mouse
  #=============================================================================
  class Sprite_Cursor < Sprite
    #---------------------------------------------------------------------------
    # * Outline sprite
    #---------------------------------------------------------------------------
    def create_outline
      @outline = Sprite.new(nil)
      @outline.bitmap = Bitmap.new(32, 32)
      @outline.bitmap.fill_rect(0, 0, 32, 32, Color.new(0, 0, 0, 190))
      @outline.bitmap.fill_rect(1, 1, 30, 30, Color.new(0, 0, 0, 0))
      @outline.hide
    end
    #-----------------------------------------------------------------------------
    alias update_tactic update
    def update
      @outline.visible = SceneManager.tactic_enabled?
      update_tactic
    end
    
  end
end
#==============================================================================
# * Scene_Map
#==============================================================================
class Scene_Map
  
  alias check_mouse_movement_hover check_mouse_movement
  def check_mouse_movement
    return if Mouse.hover_UI?
    check_mouse_movement_hover
  end
  
end
#==============================================================================
# ** Window_Selectable
#------------------------------------------------------------------------------
#  This window class contains cursor movement and scroll functions.
#==============================================================================
class Window_Selectable < Window_Base
  #---------------------------------------------------------------------------
  alias refresh_mouse_selection refresh
  def refresh
    @selection_rects = nil
    refresh_mouse_selection
  end
  #---------------------------------------------------------------------------
  def selection_rects_for_mouse
    return @selection_rects if @selection_rects
    @selection_rects = []
    item_max.times do |i|
      @selection_rects << get_selection_rect(i)
    end
    return @selection_rects
  end
  #---------------------------------------------------------------------------
  def get_selection_rect(index)
    return Rect.new(0, 0, contents.width, row_max * item_height) if @cursor_all
    return Rect.new(0,0,0,0) if index < 0
    return item_rect(index)
  end
  #---------------------------------------------------------------------------
  # * Update mouse movement
  #---------------------------------------------------------------------------
  def update_mouse
    return unless @mouse_timer == 0
    return unless Mouse.collide_sprite?(self)
    @mouse_timer = get_mouse_timer
    
    last_index = @index
    rects = []
    add_x = self.x + 16 - self.ox
    add_y = self.y + 16 - self.oy
    
    if !self.viewport.nil?
      add_x += self.viewport.rect.x - self.viewport.ox
      add_y += self.viewport.rect.y - self.viewport.oy
    end
    
    if select_cursor_needed?
      rects = selection_rects_for_mouse
      rects.each_with_index do |rect, i|
        select(i) if Mouse.area?(rect.x + add_x, rect.y + add_y, rect.width, rect.height)
      end
    end # skip selecting if window needn't to select anything
    return if last_index == @index
    update_cursor
    call_update_help
  end
  #---------------------------------------------------------------------------
end
