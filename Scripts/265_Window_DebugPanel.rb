#==============================================================================
# ** Window_DebugPanel
#------------------------------------------------------------------------------
#  This window class handles debug information, should not appear unless it's
# in debug mode. Calling this will not start a new scene.
#==============================================================================
class Window_DebugPanel < Window_Base
  #--------------------------------------------------------------------------
  CategoryList = [:switch, :variable, :bitmap]
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    @current_index = 0
    create_selecting_window
    create_content_window
    craete_help_window
    deactivate
    hide
  end
  #--------------------------------------------------------------------------
  def item_max
    CategoryList.size
  end
  #--------------------------------------------------------------------------
  def create_selecting_window
    @select_window = Window_DebugLeft(0,0)
    @select_window.set_handler(:ok,       method(:on_left_ok))
    @select_window.set_handler(:cancel,   method(:hide))
    @select_window.set_handler(:pagedown, method(:next_category))
    @select_window.set_handler(:pageup,   method(:prev_category))
    @select_window.category = CategoryList.first
  end
  #--------------------------------------------------------------------------
  def create_content_window
    wx = @select_window.width
    ww = Graphics.width - wx
    @content_window = Window_DebugRight.new(wx, 0, ww)
    @content_window.set_handler(:cancel, method(:on_right_cancel))
    @select_window.right_window = @right_window
  end
  #--------------------------------------------------------------------------
  def craete_help_window
    wx = @content_window.x
    wy = @content_window.height
    ww = @content_window.width
    wh = Graphics.height - wy
    @help_window = Window_Base.new(wx, wy, ww, wh)
  end
  #--------------------------------------------------------------------------
  # * Left [OK]
  #--------------------------------------------------------------------------
  def on_left_ok
    refresh_help_window
    @content_window.activate
    @content_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Right [Cancel]
  #--------------------------------------------------------------------------
  def on_right_cancel
    @select_window.activate
    @content_window.unselect
    @help_window.contents.clear
  end
  #--------------------------------------------------------------------------
  # * Refresh Help Window
  #--------------------------------------------------------------------------
  def refresh_help_window
    @help_window.draw_text_ex(4, 0, help_text)
  end
  #--------------------------------------------------------------------------
  # * Get Help Text
  #--------------------------------------------------------------------------
  def help_text
    case @select_window.category
    when :switch;   return Vocab::Debug::Switch;
    when :variable; return Vocab::Debug::Variable;
    when :bitmap;   return Vocab::Debug::Bitmap;
    end
    return ""
  end
  #--------------------------------------------------------------------------
  def get_category_data(category)
    case category
    when :switch;   return $game_switches;
    when :variable; return $game_variables;
    when :bitmap;   return Cache.undisposed_sprites;
    end
    return []
  end
  #--------------------------------------------------------------------------
  def prev_category
    @current_index = (@current_index - 1 + item_max) % item_max
    set_category(@current_index)
  end
  #--------------------------------------------------------------------------
  def next_category
    @current_index = (@current_index + 1) % item_max
    set_category(@current_index)
  end
  #--------------------------------------------------------------------------
  def set_category(index)
    category = CategoryList[@current_index]
    return if @select_window.category == category
  end # last work: debug panel
  #--------------------------------------------------------------------------
  def update
    super
    @help_window.update
    @select_window.update
    @content_window.update
  end
  #--------------------------------------------------------------------------
  def show
    @help_window.show
    @select_window.show
    @content_window.show
    super
  end
  #--------------------------------------------------------------------------
  def hide
    @help_window.hide
    @select_window.hide
    @content_window.hide
    super
  end
  #--------------------------------------------------------------------------
  def dispose
    @help_window.dispose
    @select_window.dispose
    @content_window.dispose
    super
  end
  #--------------------------------------------------------------------------
end
