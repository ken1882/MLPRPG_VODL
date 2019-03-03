#==============================================================================
# ** Window_DebugPanel
#------------------------------------------------------------------------------
#  This window class handles debug information, should not appear unless it's
# in debug mode. Calling this will not start a new scene.
#==============================================================================
class Window_DebugPanel < Window_Base
  #--------------------------------------------------------------------------
  CategoryList = [:switch, :variable, :sprite]
  #--------------------------------------------------------------------------
  attr_reader :select_window, :content_window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.z = PONY::SpriteDepth::Table[:win_debug]
    @current_index = 0
    create_windows
    deactivate
    hide
  end
  #--------------------------------------------------------------------------
  def item_max
    CategoryList.size
  end
  #--------------------------------------------------------------------------
  def create_windows
    create_selecting_window
    create_content_window
    create_help_window
    @select_window.right_window = @content_window
  end
  #--------------------------------------------------------------------------
  def create_selecting_window
    @select_window = Window_DebugLeft.new(0,0)
    @select_window.set_handler(:ok,       method(:on_left_ok))
    @select_window.set_handler(:cancel,   method(:hide))
    @select_window.set_handler(:pagedown, method(:next_category))
    @select_window.set_handler(:pageup,   method(:prev_category))
    @select_window.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  def create_content_window
    wx = @select_window.width
    ww = Graphics.width - wx
    @content_window = Window_DebugRight.new(wx, 0, ww)
    @content_window.set_handler(:cancel, method(:on_right_cancel))
    @content_window.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  def create_help_window
    wx = @content_window.x
    wy = @content_window.height
    ww = @content_window.width
    wh = Graphics.height - wy
    @help_window   = Window_Base.new(wx, wy, ww, wh)
    @help_window.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # * Left [OK]
  #--------------------------------------------------------------------------
  def on_left_ok
    @content_window.activate
    @content_window.select(0)
    refresh_help_window
  end
  #--------------------------------------------------------------------------
  # * Right [Cancel]
  #--------------------------------------------------------------------------
  def on_right_cancel
    @select_window.activate
    @content_window.unselect
    refresh_help_window
  end
  #--------------------------------------------------------------------------
  # * Refresh Help Window
  #--------------------------------------------------------------------------
  def refresh_help_window
    @help_window.contents.clear
    @help_window.draw_text_ex(4, 0, help_text)
  end
  #--------------------------------------------------------------------------
  # * Get Help Text
  #--------------------------------------------------------------------------
  def help_text
    case @select_window.category
    when :switch
      return @content_window.active? ? Vocab::Debug::SwitchHelp : Vocab::Debug::Switch;
    when :variable
      return @content_window.active? ? Vocab::Debug::VariableHelp : Vocab::Debug::Variable;
    when :sprite
      return @content_window.active? ? Vocab::Debug::SpriteHelp : Vocab::Debug::Sprite;
    end
    return ""
  end
  #--------------------------------------------------------------------------
  def get_category_data(category)
    case category
    when :switch;   return $game_switches;
    when :variable; return $game_variables;
    when :sprite;   return Cache.undisposed_sprites;
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
    @select_window.set_category(category, get_category_data(category))
    @content_window.unselect
    @content_window.deactivate
    @select_window.activate
    @select_window.select(0)
    refresh_help_window
  end
  #--------------------------------------------------------------------------
  def update
    super
    @help_window.update
    @select_window.update
    @content_window.update
  end
  #--------------------------------------------------------------------------
  def raise_overlay(args = {})
    show
  end
  #--------------------------------------------------------------------------
  def active?
    @select_window.active? || @content_window.active?
  end
  #--------------------------------------------------------------------------
  def show
    @help_window.show
    @select_window.show
    @content_window.show
    set_category(0)
    @select_window.activate
    super
  end
  #--------------------------------------------------------------------------
  def hide
    @help_window.hide if @help_window
    [@select_window, @content_window].each do |window|
      next unless window
      window.unselect
      window.hide
      window.deactivate
    end
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
