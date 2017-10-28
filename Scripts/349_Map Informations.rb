#==============================================================================
# ** Window_InformationLog
#------------------------------------------------------------------------------
#  This window is for displaying something happened in map, e.g. a trap is
# triggered, state added, spell cast etc.
# Use SceneManager.display_info( text ) to show the information(s).
#==============================================================================
class Window_InformationLog < Window_Selectable
  #--------------------------------------------------------------------------
  attr_reader :button_sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(data = [])
    super(Graphics.width  - window_width  - 100, 
          Graphics.height - window_height - 50 , 
          window_width, window_height)
          
    self.z = 100
    self.opacity = 255
    @lines = data ? data : []
    create_back_bitmap
    create_back_sprite
    create_active_icon(2141)
    deactivate
    self.windowskin = Cache.system(WindowSkin::MapInfo)  if WindowSkin::Enable
    contents.font.size = 16
    refresh
  end
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    hide_sprite = $game_system.hide_huds?
    if hide_sprite && visible?
      hide
    elsif !hide_sprite && !visible?
      show
    end
    update_active_icon
    super if active?
  end
  #--------------------------------------------------------------------------
  # * Activate trigger detect
  #--------------------------------------------------------------------------
  def update_active_icon
    update_deactivate if active?
    return unless Mouse.trigger_sprite?(@button_sprite) && button_cooled?
    heatup_button
    active? ? deactivate : activate
  end
  #--------------------------------------------------------------------------
  def update_deactivate
    return deactivate if Mouse.click?(2)
    return deactivate if Mouse.click?(1) && !Mouse.collide_sprite?(self)
    return deactivate if Mouse.distance_to_sprite(self) > 50
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_back_bitmap
    dispose_back_sprite
    dispose_button
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Suited to Specified Number of Lines
  #--------------------------------------------------------------------------
  def fitting_height(line_number)
    line_number * line_height + standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 200
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(max_line_number)
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Number of Lines
  #--------------------------------------------------------------------------
  def max_line_number
    return 3
  end
  #--------------------------------------------------------------------------
  # * Create Background Bitmap
  #--------------------------------------------------------------------------
  def create_back_bitmap
    @back_bitmap = Bitmap.new(width, height)
  end
  #--------------------------------------------------------------------------
  # * Create Background Sprite
  #--------------------------------------------------------------------------
  def create_back_sprite
    @back_sprite = Sprite.new
    @back_sprite.bitmap = @back_bitmap
    @back_sprite.y = y
    @back_sprite.z = z - 1
  end
  #--------------------------------------------------------------------------
  def create_active_icon(icon_index)
    @button_sprite        = Sprite.new
    @button_sprite.x      = x + window_width  - 26
    @button_sprite.y      = y + window_height - 26
    @button_sprite.z      = z + 1
    @button_sprite.bitmap = Bitmap.new(24,24)
    bitmap = Cache.iconset
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    @button_sprite.bitmap.blt(0, 0, bitmap, rect)
  end
  #--------------------------------------------------------------------------
  # * Free Background Bitmap
  #--------------------------------------------------------------------------
  def dispose_back_bitmap
    @back_bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Background Sprite
  #--------------------------------------------------------------------------
  def dispose_back_sprite
    @back_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Button Sprite
  #--------------------------------------------------------------------------
  def dispose_button
    @button_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    @num_wait = 0
    @lines.clear
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Number of Data Lines
  #--------------------------------------------------------------------------
  def line_number
    @lines.size
  end
  #--------------------------------------------------------------------------
  # * Go Back One Line
  #--------------------------------------------------------------------------
  def back_one
    @lines.pop
    refresh
  end
  #--------------------------------------------------------------------------
  # * Return to Designated Line
  #--------------------------------------------------------------------------
  def back_to(line_number)
    @lines.pop while @lines.size > line_number
    refresh
  end
  #--------------------------------------------------------------------------
  # * Add Text
  #--------------------------------------------------------------------------
  def add_text(text)
    lines = FileManager.textwrap(text, window_width * 1.5)
    lines.each do |line|
      @lines.shift      if item_max > item_limit
      @lines.push(line) if line.size > 0
    end
    refresh(true)
  end
  #--------------------------------------------------------------------------
  # * Get Text From Last Line
  #--------------------------------------------------------------------------
  def last_line
    @lines[-1]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(lazy = false)
    contents.clear
    contents.dispose
    create_contents
    draw_all_items(lazy)
  end
  #--------------------------------------------------------------------------
  # * Activate Window
  #--------------------------------------------------------------------------
  def activate
    super
    select(@lines.size - 1)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Deactivate Window
  #--------------------------------------------------------------------------
  def deactivate
    select(@lines.size - 1) if @lines
    unselect
    super
  end
  #--------------------------------------------------------------------------
  # * Get Background Rectangle
  #--------------------------------------------------------------------------
  def back_rect
    Rect.new(0, padding, width, line_number * line_height)
  end
  #--------------------------------------------------------------------------
  # * Get Background Color
  #--------------------------------------------------------------------------
  def back_color
    Color.new(0, 0, 0, back_opacity)
  end
  #--------------------------------------------------------------------------
  # * Get Background Opacity
  #--------------------------------------------------------------------------
  def back_opacity
    return 64
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = 18
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * 18
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    return 18
  end
  #--------------------------------------------------------------------------
  # * Item limit
  #--------------------------------------------------------------------------
  def item_limit
    100
  end
  #--------------------------------------------------------------------------
  # * Item max
  #--------------------------------------------------------------------------
  def item_max
    return 0 if @lines.nil?
    @lines.size
  end
  #--------------------------------------------------------------------------
  # * Remove the excess line
  #--------------------------------------------------------------------------
  def clean_excess
    n_times = item_max - item_limit
    n_times.times { @lines.shift }
  end
  #--------------------------------------------------------------------------
  # * Draw Line
  #--------------------------------------------------------------------------
  def draw_line(line_number)
    rect = item_rect_for_text(line_number)
    #draw_text(0, rect.y, 320, 20, @lines[line_number])
    draw_text_ex(0, rect.y, @lines[line_number])
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items(lazy = false)
    self.contents.font.color = Color.new(255,255,255, [self.opacity ,150].max)
    if lazy && item_max >= 4
      n = item_max - 4
      item_max.times do |i|
        next if i < n
        draw_item(i)
      end
    else
      item_max.times {|i| draw_item(i) }
    end
    self.index = item_max - 1
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    text = @lines[index]
    return if text.nil?
    rect = item_rect_for_text(index)
    draw_text_ex(rect.x, rect.y, text)
  end
  #--------------------------------------------------------------------------
  # * Draw Text with Control Characters
  #--------------------------------------------------------------------------
  def draw_text_ex(x, y, text)
    self.contents.font.size = 18
    y -= 4
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
  #--------------------------------------------------------------------------
  # * Check if character is behind window
  #--------------------------------------------------------------------------
  def behind_toolbar?
    px = ($game_player.screen_x / 32)
    py = ($game_player.screen_y / 32)
    return ( ((3 - px) < 0 && px <= 17) && (10.5 - py) < 0 ) ? true : false
  end
  #--------------------------------------------------------------------------
  # * Show the window
  #--------------------------------------------------------------------------
  def show
    return hide if $game_system.story_mode?
    super
    @back_sprite.show
    @button_sprite.show
    #activate
    #select([item_max - 1, 0].max)
    unselect
  end
  #--------------------------------------------------------------------------
  def hide
    @back_sprite.hide
    @button_sprite.hide
    super
  end
  #--------------------------------------------------------------------------
  # *) data
  #--------------------------------------------------------------------------
  def data
    return @lines
  end
  #-------------------------------------------------------------------------
end
#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================
module SceneManager
  #--------------------------------------------------------------------------
  # * Module Instance Variables
  #--------------------------------------------------------------------------
  @saved_map_infos = []
  #--------------------------------------------------------------------------
  # * Save map informations
  #--------------------------------------------------------------------------
  def self.save_map_infos(data)
    return if data.nil?
    @saved_map_infos = data
  end
  #--------------------------------------------------------------------------
  # * Clear map informations
  #--------------------------------------------------------------------------
  def self.clear_map_infos
    @saved_map_infos.clear
  end
  #--------------------------------------------------------------------------
  # * Resume map informations
  #--------------------------------------------------------------------------
  def self.resume_map_info
    return if @saved_map_infos.empty?
    re = @saved_map_infos.dup
    @saved_map_infos.clear
    return re
  end
  #--------------------------------------------------------------------------
end
