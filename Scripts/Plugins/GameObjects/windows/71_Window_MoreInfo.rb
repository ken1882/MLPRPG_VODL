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
  #--------------------------------------------------------------------------
  alias initialize_dnd initialize
  def initialize(x, y, width, height)
    create_info_window
    initialize_dnd(x, y, width, height)
    set_handler(:moreinfo, method(:process_moreinfo))
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
  alias update_moreinfo update
  def update
    if @info_window.visible?
      process_overlay_handling
      @info_window.update
    end
    update_moreinfo
  end
  #--------------------------------------------------------------------------
  # * Process overlay window handling
  #--------------------------------------------------------------------------
  def process_overlay_handling
    if moreinfo_enabled?
      if Input.trigger?(:kTAB) || Mouse.click?(3)
        process_moreinfo(:kTAB)
      elsif Input.trigger?(:B)
        process_moreinfo(:B)
      end # Input.trigger?
    end # @button cooldown
  end
  #--------------------------------------------------------------------------
  # *) Moreinfo is enabled?
  #--------------------------------------------------------------------------
  def moreinfo_enabled?
    handle?(:moreinfo) && (active? || @info_window.visible?)
  end
  #--------------------------------------------------------------------------
  # * Processing show/hide more info window
  #--------------------------------------------------------------------------
  def process_moreinfo(key = :kTAB)
    item = show_moreinfo?
    return if !item
    @info_window.set_item(item) if !@info_window.visible?
    if @info_window.visible?
      @info_window.hide
      Sound.play_cancel
      heatup_button
      @overlayed = false
      activate
    elsif key == :kTAB
      @info_window.show
      Audio.se_play("Audio/SE/BG_Select", 90, 100)
      heatup_button
      @overlayed = true
      deactivate
    end
  end
  #--------------------------------------------------------------------------
  # * Show more info?
  #--------------------------------------------------------------------------
  def show_moreinfo?
    item = @data[index] if !@data.nil? && @data[index]
    item = self.item    if !item && self.methods.include?(:item)
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
  include DND::Utility
  #--------------------------------------------------------------------------
  IndexColor = Color.new(240, 225, 185)
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :index                    # cursor position
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item              = nil
    @display_category  = nil
    @actor             = nil
    @pages             = []
    @first_page_offset = 0
    @index = -1
    @handler = {}
    create_background
    self.windowskin = Cache.system(WindowSkin::MapInfo) if WindowSkin::Enable
    self.opacity = 255
    self.hide
    self.z = PONY::SpriteDepth::Table[:win_info]
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
    update_mouse
  end 
  #--------------------------------------------------------------------------
  def update_mouse
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Cache.background("scroll")
    @background_sprite.z = self.z - 10
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Show window
  #--------------------------------------------------------------------------
  def show
    create_background
    super
  end
  #--------------------------------------------------------------------------
  # * Hide window
  #--------------------------------------------------------------------------
  def hide
    dispose_background
    super
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
    @first_page_offset = get_item_param_lines
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
    cursor_pagedown   if Input.trigger?(:DOWN) || Mouse.scroll_down?
    cursor_pageup     if Input.trigger?(:UP)   || Mouse.scroll_up?
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
    if index == 0
      cy = 0
      DND::ItemParamDec[:item].each do |param|
        cy = draw_param(param, cy)
      end
    end
    draw_description(index)
  end
  #--------------------------------------------------------------------------
  # *) Draw Weapon Info
  #--------------------------------------------------------------------------
  def draw_weapon_info(index)
    if index == 0
      cy = 0
      DND::ItemParamDec[:weapon].each do |param|
        draw_param(param, cy)
        cy += line_height
      end
    end
    draw_description(index)
  end
  #--------------------------------------------------------------------------
  # *) Draw Armor Info
  #--------------------------------------------------------------------------
  def draw_armor_info(index)
    if index == 0
      cy = 0
      DND::ItemParamDec[:armor].each do |param|
        draw_param(param, cy)
        cy += line_height
      end
    end
    draw_description(index)
  end
  #--------------------------------------------------------------------------
  # *) Draw Skill Info
  #--------------------------------------------------------------------------
  def draw_skill_info(index)
    if index == 0
      cy = 0
      DND::ItemParamDec[:skill].each do |param|
        draw_param(param, cy)
        cy += line_height
      end
    end
    draw_description(index)
  end
  #--------------------------------------------------------------------------
  def get_item_param_lines
    return DND::ItemParamDec[:skill].size  if @item.is_a?(RPG::Skill)
    return DND::ItemParamDec[:weapon].size if @item.is_a?(RPG::Weapon)
    return DND::ItemParamDec[:armor].size  if @item.is_a?(RPG::Armor)
    return DND::ItemParamDec[:item].size   if @item.is_a?(RPG::Item)
    return 0
  end
  
  #--------------------------------------------------------------------------
  # *) setup_description_pages
  #--------------------------------------------------------------------------
  def setup_description_pages
    page_cnt = 0; cnt = @first_page_offset + 1;
    info = @item.information
    @pages[page_cnt] = []
    texts = FileManager.textwrap(info, contents_width, contents)
    texts.each do |line|
      if (self.y + (cnt + 2) * line_height) >= self.height
        page_cnt += 1; @pages[page_cnt] = []; cnt = 1;
      end
      @pages[page_cnt].push(line)
      cnt += 1
    end
  end
  #--------------------------------------------------------------------------
  # *) Draw Item params
  #--------------------------------------------------------------------------
  def draw_param(param, cy)
    
    rect = Rect.new(0, cy, contents.width, line_height)
    change_color(DND::COLOR::Tan)
    case param
    when :wtype
      draw_text(rect, Vocab::Equipment::Type)
      text = sprintf("%s", Vocab::DND::WEAPON_TYPE_NAME[@item.wtype_id])
    when :atype
      draw_text(rect, Vocab::Equipment::Type)
      text = sprintf("%s", Vocab::DND::ARMOR_TYPE_NAME[@item.atype_id])
    when :stype
      draw_text(rect, Vocab::Equipment::Type)
      if @item.scope == BattleManager::Scope_None || BattleManager::Scope_User
        text = Vocab::None
      else
        text = sprintf("%s", Vocab::DND::SKILL_TYPE_NAME[@item.stype_id])
      end
    when :ac
      draw_text(rect, Vocab::Equipment::AC)
      text = sprintf("%s", @item.armor_class)
    when :speed
      draw_text(rect, Vocab::Equipment::Speed)
      if @item.scope == BattleManager::Scope_None
        text = Vocab::None
      else
        text = sprintf("%s", @item.wield_speed)
      end
    when :range
      draw_text(rect, Vocab::Equipment::Range)
      text = sprintf("%s", @item.tool_distance)
    when :damage
      return if @item.damage_index.nil?
      @item.damage_index.each do |feat|
        change_color(DND::COLOR::Tan)
        draw_text(rect, Vocab::Equipment::Damage)
        info = sprintf("%dd%d +(%d), %s; %s",feat[0],feat[1],feat[2], get_element_name(feat[3]), get_param_name(feat[4]))
        change_color(normal_color)
        draw_text(rect, info, 2)
        cy += line_height
      end
      return cy
    when :casting
      draw_text(rect, Vocab::Equipment::CastingTime)
      if (@item.tool_castime | 0) > 10
        text = sprintf("%s sec", (@item.tool_castime / 60.0).round(2))
      else
        text = Vocab::None
      end
    when :cost
      draw_text(rect, Vocab::Equipment::Cost)
      text = sprintf("%s", @item.mp_cost)
    when :cooldown
      draw_text(rect, Vocab::Equipment::Cooldown)
      if @item.tool_cooldown
        text = sprintf("%s sec", (@item.tool_cooldown / 60.0).round(2))
      else
        text = Vocab::None
      end
    when :save
      draw_text(rect, Vocab::Equipment::SavingThrow)
      if @item.dmg_saves
        text = sprintf("%s, %s", get_saving_name(@item.dmg_saves), get_param_name(get_param_id(@item.dmg_saves.last)))
      else
        text = Vocab::None
      end
    else
      return cy
    end
    change_color(normal_color)
    draw_text(rect, text, 2)
    return cy + line_height
  end
  #--------------------------------------------------------------------------
  # *) Draw Item Info
  #--------------------------------------------------------------------------
  def draw_description(page_id)
    cy = @first_page_offset * line_height
    w  = contents.width
    change_color(system_color)
    draw_text(0, cy, w, line_height, "Description:")
    
    change_color(index_color)
    cnt = 1
    @pages[page_id].each do |line|
      draw_text(0, (cy + cnt * line_height), w, line_height, line , 1)
      cnt += 1
    end
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  def index_color
    IndexColor
  end
end
#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
