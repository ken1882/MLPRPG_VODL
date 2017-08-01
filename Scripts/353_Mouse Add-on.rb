#==============================================================================
# * Mouse add-ons
#==============================================================================
module Mouse
  #------------------------------------------------------------------------------
  module_function
  #------------------------------------------------------------------------------
  def scroll_up?
    return !@flag_scroll.nil? && @flag_scroll > 0
  end
  #------------------------------------------------------------------------------
  def scroll_down?
    return !@flag_scroll.nil? && @flag_scroll < 0
  end
  #------------------------------------------------------------------------------
  def collide_sprite?(sprite)
    return false if !sprite.is_a?(Rect) && sprite.disposed?
    return area?(sprite.x, sprite.y, sprite.width, sprite.height) rescue false
  end
  #------------------------------------------------------------------------------
  # * Check if mouse pointer if over skillbar
  #------------------------------------------------------------------------------
  def hover_skillbar?(index)
    return if $game_party.skillbar.sprite.nil? || $game_party.skillbar.sprite.disposed?
    sx = $game_party.skillbar.sprite.true_x
    sy = $game_party.skillbar.sprite.true_y
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
    #return window ? collide_sprite?(window) && !window.active? : false
    return window ? collide_sprite?(window) : false
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
    #-----------------------------------------------------------------------------
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
      update_tactic
      @outline.visible = SceneManager.tactic_enabled?
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
