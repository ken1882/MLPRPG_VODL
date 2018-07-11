#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================
class Window_ImageMenuStatus < Window_MenuStatus
  include PONY::Menu_UI
  attr_reader :index_list
  attr_reader :list_indicator
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
  	create_index_list
    @y = y
  	super(x, y)
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
    Graphics.height - (@y / 2)
  end
  #--------------------------------------------------------------------------
  # * Get corresponding character image
  #--------------------------------------------------------------------------
  def get_actor_image(id, leader)
    leader = false
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
  # * Get Image Height
  #--------------------------------------------------------------------------
  def image_height
    220
  end
  #--------------------------------------------------------------------------
  # * Get Position for Item
  #--------------------------------------------------------------------------
  def item_position(index, for_image = false, img_width = 0)
  	case index
  	when 0
  		cx = (for_image && img_width > 155) ? First_Item_Position[0] - img_width / 16 : First_Item_Position[0]
      cy = First_Item_Position[1]
  	when 1
      cx = Second_Item_Position[0]
      cy = Second_Item_Position[1]
  	else
      cx = First_Item_Position[0] + 145 * (index - 1)
      cx = First_Item_Position[0] + (145 - img_width / 8) * (index - 1) if for_image && img_width > 155
      cy = First_Item_Position[1] + 15 * (index - 1)
  	end
    [cx, cy]
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
  # * Get Rectangle for Ccursor
  #--------------------------------------------------------------------------
  def item_rect_for_cursor(index)
    rect = item_rect(index)
    rect.x += 6
    rect.y  = 0
    rect.height = fitting_height(0) + 6
    rect.width  = 148
    rect
  end
 
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    return 1
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
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect_for_cursor(@index))
    end
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    n = item_max
    item_max.times {|i| draw_item(n - 1 - i) }
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
    draw_actor_image(actor.id, index, index == 0)
    draw_actor_simple_status(actor, rect.x + 12, 0)
  end
  
  #--------------------------------------------------------------------------
  # * Draw Actor Image
  #--------------------------------------------------------------------------
  def draw_actor_image(id, index, leader)
  	bitmap = get_actor_image(id, leader)
    cx     = item_position(index, true, bitmap.width).at(0)
  	cy 		 = window_height - fitting_height(2) - bitmap.height - 5
  	rect 	 = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(cx, cy, bitmap, rect)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    draw_actor_class(actor, x, y + line_height, 168)
    draw_actor_hp(actor, x, y + line_height * 3)
    draw_actor_mp(actor, x, y + line_height * 4)
    draw_actor_icons(actor, x, window_height - fitting_height(2))
  end
end
