#==============================================================================
# ** Pony
#------------------------------------------------------------------------------
#  Pony should poni pony
#==============================================================================
$imported = {} if $imported.nil?
module PONY
	module Menu_UI
		First_Item_Position =  [155, 20]
		Second_Item_Position = [10, 35]
    
    NAME_COLOR = {
      1 => 30,
      2 => 2,
      4 => 0,
      5 => 23,
      6 => 27,
      7 => 17,
    }
    
	end
end
#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================
class Window_MenuStatus < Window_Selectable
  include PONY::Menu_UI
  attr_reader :index_list
  attr_reader :list_indicator
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_menustat initialize
  def initialize(x, y)
  	create_index_list
  	initialize_menustat(x, y)
  end
  #--------------------------------------------------------------------------
  def create_index_list
  	@list_indicator = 0
    _max = item_max
    if _max > 1
      @index_list = [1]
      for i in 0...item_max
        next if i == 1
        @index_list.push(i)
      end
    else
      @index_list = [0]
    end
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    Graphics.height
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    Graphics.height - fitting_height(1)
  end
  #--------------------------------------------------------------------------
  # * Get corresponding character image
  #--------------------------------------------------------------------------
  def get_actor_image(id, leader)
    image_filename = leader ? "Lead" : ""
  	image_filename += "Char_" + id.to_s
  	Cache.UI(image_filename) rescue nil
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    150
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    200
  end
  #--------------------------------------------------------------------------
  # * Get Position for Item
  #--------------------------------------------------------------------------
  def item_position(index)
  	case index
  	when 0
  		First_Item_Position
  	when 1
  		Second_Item_Position
  	else
  		[First_Item_Position[0] + 162 * (index - 1), First_Item_Position[1] + 15 * (index - 1)]
  	end
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = item_position(index).at(0)
    rect.y = item_position(index).at(1)
    rect
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.members[index]
    return if actor.nil?
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    
    #draw_item_background(index)
    draw_actor_image(actor.id, rect.x, index == 0)
    #draw_actor_simple_status(actor, rect.x + 3 , window_height - fitting_height(2))
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Image
  #--------------------------------------------------------------------------
  def draw_actor_image(id, cx, leader)
  	bitmap 	= get_actor_image(id, leader)
  	cy 		= window_height - fitting_height(2) - bitmap.height - 5
  	rect 	= Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(cx, cy, bitmap, rect)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    #draw_actor_name(actor, x, y)
    #draw_actor_level(actor, x, y + line_height * 1)
    #draw_actor_icons(actor, x, y + line_height * 2)
    #draw_actor_class(actor, x + 120, y)
    draw_actor_hp(actor, x, y + line_height * 1)
    draw_actor_mp(actor, x, y + line_height * 2)
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 4
  end
  #--------------------------------------------------------------------------
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return 8
  end
  #--------------------------------------------------------------------------
  # * Get Leading Digits
  #--------------------------------------------------------------------------
  def top_col
    ox / (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # * Set Leading Digits
  #--------------------------------------------------------------------------
  def top_col=(col)
    col = 0 if col < 0
    col = col_max - 1 if col > col_max - 1
    self.ox = col * (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # * Get Trailing Digits
  #--------------------------------------------------------------------------
  def bottom_col
    top_col + col_max - 1
  end
  #--------------------------------------------------------------------------
  # * Set Trailing Digits
  #--------------------------------------------------------------------------
  def bottom_col=(col)
    self.top_col = col - (col_max - 1)
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_col = index if index < top_col
    self.bottom_col = index if index > bottom_col
  end
  #--------------------------------------------------------------------------
  # * Get Alignment
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if col_max >= 2 && (@list_indicator < item_max - 1 || (wrap && horizontal?))
      @list_indicator = (@list_indicator + 1) % item_max
      select(@index_list[@list_indicator])
    elsif @list_indicator == item_max - 1
      @list_indicator = 0
      select(@index_list[@list_indicator])
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if col_max >= 2 && (@list_indicator > 0 || (wrap && horizontal?))
      @list_indicator = (@list_indicator - 1 + item_max) % item_max
      select(@index_list[@list_indicator])
    elsif @list_indicator == 0
      @list_indicator = item_max - 1
      select(@index_list[@list_indicator])
    end
  end
  
  #--------------------------------------------------------------------------
  # * Deselect Item
  #--------------------------------------------------------------------------
  def unselect
    self.index = -1
    @list_indicator = 0
  end
end
