#==============================================================================
# ** Window_Selectable
#------------------------------------------------------------------------------
#  This window class contains cursor movement and scroll functions.
#==============================================================================
class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :info_window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #-------------------------------------------------------------------------
  alias initialize_dnd initialize
  def initialize(x, y, width, height)
    create_info_window
    @button_cooldown = 0                      
    initialize_dnd(x, y, width, height)
    set_handler(:moreinfo, process_moreinfo)
  end
  #--------------------------------------------------------------------------
  # * Create Info Window
  #--------------------------------------------------------------------------
  def create_info_window
    @info_window = Window_Moreinfo.new(0, 0, Graphics.width, Graphics.height)
  end
  #--------------------------------------------------------------------------
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  alias process_handling_dnd process_handling
  def process_handling
    @button_cooldown -= 1   if @button_cooldown > 0
    @info_window.update     if @info_window.visible?
    return process_moreinfo if moreinfo_enabled? && Input.trigger?(:X) && @button_cooldown == 0
    process_handling_dnd    if !@info_window.visible?
  end
  #--------------------------------------------------------------------------
  # *) Moreinfo is enabled?
  #--------------------------------------------------------------------------
  def moreinfo_enabled?
    handle?(:moreinfo) && active?
  end
  #--------------------------------------------------------------------------
  # * Processing show/hide more info window
  #--------------------------------------------------------------------------
  def process_moreinfo
    item = show_moreinfo?
    return if !item
    
    @info_window.set_item(item) if !@info_window.visible?
    @info_window.visible ^= 1
    @info_window.visible? ? Audio.se_play("Audio/SE/BG_Select",100,100) : Sound.play_cancel
    @button_cooldown = 10
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  alias dnd_cursor_movable? cursor_movable?
  def cursor_movable?
    return !@info_window.visible && dnd_cursor_movable?
  end
  #--------------------------------------------------------------------------
  # * Show more info?
  #--------------------------------------------------------------------------
  def show_moreinfo?
    item = @data[index] if @data && @data[index]
    item = self.item if !item && self.methods.include?(:item)
    item = nil unless (item.is_a?(RPG::EquipItem) || item.is_a?(RPG::UsableItem))
    return item
  end
  
  #--------------------------------------------------------------------------
end
#==============================================================================
# ** Window_Moreinfo
#------------------------------------------------------------------------------
#  This window class display the detail information of selected item
#==============================================================================
class Window_Moreinfo < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :index                    # cursor position
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item             = nil
    @display_category = nil
    @actor            = nil
    @handler          = {}
    @pages            = []
    @index            = 0
    self.windowskin = Cache.system($ITEM_INFO_SKIN)
    self.opacity = 255
    self.hide
    self.z = 1000
    refresh
  end
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh(index = 0)
    return if @item.nil?
    contents.clear
    
    if    @item.is_a?(RPG::Item);   draw_item_info(index)
    elsif @item.is_a?(RPG::Weapon); draw_weapon_info(index)
    elsif @item.is_a?(RPG::Armor);  draw_armor_info(index)
    elsif @item.is_a?(RPG::Skill);  draw_skill_info(index)
    end
    draw_page_number
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    process_cursor_move
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    return active && open? && @pages.size > 1
  end
  #--------------------------------------------------------------------------
  # *) Set item
  #--------------------------------------------------------------------------
  def set_item(item, actor = nil)
    @pages = []
    @index = 0
    @item  = item
    @actor = actor
    setup_description_pages
    refresh(@index)
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown
    return if @index + 1 >= @pages.size
    @index += 1
    Audio.se_play("Audio/SE/Book2",80,100)
    refresh(@index)
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup
    return if @index - 1 < 0
    @index -= 1
    Audio.se_play("Audio/SE/Book2",80,100)
    refresh(@index)
  end
  #--------------------------------------------------------------------------
  # * Cursor Movement Processing
  #--------------------------------------------------------------------------
  def process_cursor_move
    return unless cursor_movable?
    cursor_pagedown   if Input.trigger?(:DOWN)
    cursor_pageup     if Input.trigger?(:UP)
  end
  #--------------------------------------------------------------------------
  # *) Draw Page Number
  #--------------------------------------------------------------------------
  def draw_page_number
    info = sprintf("Page: %2d/%2d", @index + 1, @pages.size)
    px = (self.width / 2) - (info.size * 8)
    py = self.height - line_height * 2
    draw_text(px, py, contents.width, line_height, info , 4)
  end
  #--------------------------------------------------------------------------
  # *) Draw Item Info
  #--------------------------------------------------------------------------
  def draw_item_info(index)
    cnt = 0
    draw_description(index)
    
  end
  #--------------------------------------------------------------------------
  # *) Draw Weapon Info
  #--------------------------------------------------------------------------
  def draw_weapon_info(index)
    cnt = 0
    draw_description(index)
    
  end
  #--------------------------------------------------------------------------
  # *) Draw Armor Info
  #--------------------------------------------------------------------------
  def draw_armor_info(index)
    cnt = 0
    draw_description(index)
    
  end
  #--------------------------------------------------------------------------
  # *) Draw Skill Info
  #--------------------------------------------------------------------------
  def draw_skill_info(index)
    cnt = 0
    draw_description(index)
    
  end
  #--------------------------------------------------------------------------
  # *) setup_description_pages
  #--------------------------------------------------------------------------
  def setup_description_pages
    cnt = 1
    page_cnt = 0
    info = @item.information
    text = " "
    i = 0
    @pages[page_cnt] = []
    
    while i < info.size
      while text.size < 73
        break if info[i].nil?
        text += info[i] unless info[i] == '|'
        i += 1
        break if info[i].nil? || info[i] == '|'
        text += '-' if text.size == 73 && info[i].match(/^[[:alpha:]]$/) && info[i-1].match(/^[[:alpha:]]$/)
      end
      
      if (y + (cnt + 2) * line_height) >= self.height
        page_cnt += 1
        @pages[page_cnt] = []
        cnt = 1
      end
      
      @pages[page_cnt].push(text)
      cnt += 1
      text = ""
    end
    
  end
  #--------------------------------------------------------------------------
  # *) Draw Item Info
  #--------------------------------------------------------------------------
  def draw_description(page_id)
    y = 0
    w = contents.width
    change_color(system_color)
    draw_text(0, y, w, line_height, "Description:")
    #change_color(Color.new(255,210,155))
    color_red   = 240
    color_green = 225
    color_blue  = 185
    change_color(Color.new(color_red, color_green, color_blue))
    cnt = 1
    @pages[page_id].each do |line|
      draw_text(0, (y + cnt * line_height), w, line_height, line , 4)
      cnt += 1
    end
    change_color(normal_color)
  end
  
  #--------------------------------------------------------------------------
end
#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
