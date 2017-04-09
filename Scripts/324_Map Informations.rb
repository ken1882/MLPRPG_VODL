#==============================================================================
# ** Window_InformationLog
#------------------------------------------------------------------------------
#  This window is for displaying something happened in map, e.g. a trap is
# triggered, state added, spell cast etc.
# Use SceneManager.display_info( text ) to show the information(s).
#==============================================================================
class Window_InformationLog < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width  - window_width  - 100, 
          Graphics.height - window_height - 50 , 
          window_width, window_height)
          
    self.z = 100
    self.opacity = 255
    @lines = []                                    # Window texts index
    @num_wait = 0                                  # Wait time for next display
    create_back_bitmap
    create_back_sprite
    deactivate
    self.windowskin = Cache.system(WindowSkin::MapInfo)  if WindowSkin::Enable
    refresh
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    self.visible = !$game_switches[16]
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_back_bitmap
    dispose_back_sprite
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
    line = ""
    text.each_char do |ch|
      line += ch
      @lines.push(line) if line.size > 74
      line = ""         if line.size > 74
    end
    @lines.shift      if item_max > item_limit
    @lines.push(line) if line.size > 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Text From Last Line
  #--------------------------------------------------------------------------
  def last_text
    @lines[-1]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    make_font_smaller
    create_contents
    draw_all_items
    make_font_bigger
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
    draw_text(0, rect.y, 320, 18, @lines[line_number])
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    make_font_smaller
    self.contents.font.color = Color.new(255,255,255, [self.opacity ,150].max)
    item_max.times {|i| draw_item(i) }
    self.index = item_max - 1
    self.index = -1
    make_font_bigger
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
  # show
  #--------------------------------------------------------------------------
  def show
    super
    activate
    select([item_max - 1, 0].max)
  end
  #--------------------------------------------------------------------------
  # *) update fade effect
  #--------------------------------------------------------------------------
  def update_fade_effect
    if behind_toolbar?
      if self.opacity > 100
        self.opacity = 60
        refresh
      end
    elsif self.opacity != 255
      self.opacity = 255
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # *) data
  #--------------------------------------------------------------------------
  def data
    @lines
  end
  #-------------------------------------------------------------------------
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_window_info update
  def update
    @window_info.update_fade_effect
    update_window_info
  end
  #--------------------------------------------------------------------------
  # *) window infos
  #--------------------------------------------------------------------------
  def window_informations
    @window_info.data
  end
  #--------------------------------------------------------------------------
  # *) check_window_info_resume
  #--------------------------------------------------------------------------
  def check_window_info_resume
    SceneManager.resume_map_info
  end
  #--------------------------------------------------------------------------
  # *) update_transfer_player
  #--------------------------------------------------------------------------
  alias update_transfer_player_dnd update_transfer_player
  def update_transfer_player
    #@window_info.clear                    if $game_player.transfer?
    #SceneManager.clear_map_infos          if $game_player.transfer?
    update_transfer_player_dnd
  end
  
  #---------------------------------------
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
  @need_resume_map_infos = false
  #--------------------------------------------------------------------------
  # * Call
  #--------------------------------------------------------------------------
  class << self; alias save_map_info_call call; end
  def self.call(scene_class)
    save_map_infos if @scene.is_a?(Scene_Map)
    save_map_info_call(scene_class)
  end
  #--------------------------------------------------------------------------
  # * Save map informations
  #--------------------------------------------------------------------------
  def self.save_map_infos
    @saved_map_infos = scene.window_informations
    @need_resume_map_infos = @saved_map_infos.size > 0
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
    return if !@need_resume_map_infos
    @saved_map_infos.each do |info|
      self.display_info(info)
    end
    @need_resume_map_infos = false
  end
  #--------------------------------------------------------------------------
end
