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
    @button_cooldown -= 1 if @button_cooldown > 0
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
    
    @info_window.set_item(item)
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
    item = self.item if !item && self.methods.include?(:item) && self.item.is_a?(RPG::BaseItem)
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
  # initialize
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item             = nil
    @display_category = nil
    @actor            = nil
    self.hide
    self.z = 200
    refresh
  end
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    return if @item.nil?
    contents.clear
    if    @item.is_a?(RPG::Item);   draw_item_info
    elsif @item.is_a?(RPG::Weapon); draw_weapon_info
    elsif @item.is_a?(RPG::Armor);  draw_armor_info
    elsif @item.is_a?(RPG::Skill);  draw_skill_info
    end
  end
  #--------------------------------------------------------------------------
  # *) Set item
  #--------------------------------------------------------------------------
  def set_item(item, actor = nil)
    @item  = item
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # *) Draw Item Info
  #--------------------------------------------------------------------------
  def draw_item_info
    cnt = 0
    draw_description(line_height * cnt); cnt += 1
    
  end
  #--------------------------------------------------------------------------
  # *) Draw Weapon Info
  #--------------------------------------------------------------------------
  def draw_weapon_info
    cnt = 0
    draw_description(line_height * cnt); cnt += 1
    
  end
  #--------------------------------------------------------------------------
  # *) Draw Armor Info
  #--------------------------------------------------------------------------
  def draw_armor_info
    cnt = 0
    draw_description(line_height * cnt); cnt += 1
    
  end
  #--------------------------------------------------------------------------
  # *) Draw Skill Info
  #--------------------------------------------------------------------------
  def draw_skill_info
    cnt = 0
    draw_description(line_height * cnt); cnt += 1
    
  end
  
  #--------------------------------------------------------------------------
  # *) Draw Item Info
  #--------------------------------------------------------------------------
  def draw_description(y)
    w = contents.width
    change_color(system_color)
    draw_text(0, y, w, line_height, "Description:")
    change_color(normal_color)
    
    cnt = 1
    info = @item.information
    text = ""
    i = 0
    while i < info.size
      while text.size < 75
        break if info[i].nil?
        text += info[i]
        i += 1
        text += '-' if text.size == 75 && info[i].match(/^[[:alpha:]]$/) && info[i-1].match(/^[[:alpha:]]$/)
      end
      draw_text(0, (y + cnt * line_height), w, line_height, text , 4)
      cnt += 1
      text = ""
    end
    
  end
  
  #--------------------------------------------------------------------------
end
#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
