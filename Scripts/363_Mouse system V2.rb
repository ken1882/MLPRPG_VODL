#===============================================================================
# Mouse System
# By Jet10985(Jet)
# Some code by Daniel Martin
#===============================================================================
# This script will allow full use of the mouse inside of Ace for various
# purposes.
# This script has: 13 customization options.
#===============================================================================
# Overwritten Methods:
# Game_Player: move_by_input
# Window_NameInput: item_max
#-------------------------------------------------------------------------------
# Aliased methods:
# Scene_Title: start
# Scene_Map: update, terminate, update_transfer_player
# Input: update, trigger?, press?, repeat?, dir8/dir4
# Window_Selectable: update
# Scene_File: update, top_index=
# Game_Event: update, setup_page
# Game_Player: check_action_event, get_on_off_vehicle
# Game_System: initialize, on_after_load
#===============================================================================
=begin
Showing text above event when mouse hovers:
If you want a message to appear over an event's head if the mouse is hovering
over the event, put this comment in the event:
MOUSE TEXT MESSAGE HERE
everything after TEXT will be the hovering display.
--------------------------------------------------------------------------------
Change mouse picture above event when mouse hovers:
If you want the mouse's picture to temporarily change whne over an event, put
this comment in the event
MOUSE PIC NAME/NUMBER
if you put a name, the mouse will become that picture, but if you put a number
then the mouse will become the icon that is the id number
--------------------------------------------------------------------------------
Specific mouse click movement routes:
If you want the player to land specifically in a square around an event when
they click to move on the event, put one of these comments in the event:
MOUSE MOVE UP/LEFT/RIGHT/DOWN
only put the direction that you want the player to land on.
--------------------------------------------------------------------------------
Click to activate:
If you want an event to automatically start when it is clicked on, place
this in an event comment:
MOUSE CLICK
--------------------------------------------------------------------------------
Ignore Events:
To have an event be ignored when the mouse makes it's movement path(as if the
event isn't there), put this comment in the event:
MOUSE THROUGH
--------------------------------------------------------------------------------
You can do some extra things with the mouse using event "Script..." commands:
Mouse.set_pos(x, y) will set the mouse's position to the x and y specified.
Mouse.area?(x, y, width, height) will check if the mouse is inside the given
rectangle, on-screen. This does not account for a scrolled map.
Mouse.grid will return where on the screen the mouse is, not accounting for
a scrolled map. Returns an array: [x, y]
Mouse.true_grid will return where on the map the mouse is, accounting for a
scrolled map. Returns an array: [x, y]
Mouse.click?(1 or 2) will return true/false depending on if a mouse button was
clicked, in only the current frame. Use 1 for left-click, 2 for right-click.
Mouse.press?(1 or 2) will return true/false depending on if a mouse button is
currently being pressed. Use 1 for left-click, 2 for right-click.
swap_mouse_cursor(data) will change the idle look of the mouse icon, and it will
persist on the savefile. data is either the name of a picture eg "cursor-icon2"
or the number of an icon eg 12. Images should be in quotes, whereas icons should
just be the number.
--------------------------------------------------------------------------------
Extra Notes:
You can activate action button events by standing next to the event and clicking
on it with the mouse.
=end
module Jet
  module MouseSystem
    
    # This is the image used to display the cursor in-game.
    CURSOR_IMAGE = "cursor-picture"
    
    # If the above image does not exist, the icon at this index will be used.
    CURSOR_ICON = 10821
    
    # turning ths switch on will completely disable the mouse.
    TURN_MOUSE_OFF_SWITCH = 99
    
    # Do you want the player to be able to move using the mouse?
    # This can be changed in-game using toggle_mouse_movement(true/false)
    ALLOW_MOUSE_MOVEMENT = true
    
    # Do you want to check for diagonal movement as well? Please note this
    # enables regular diagonal movement with the keyboard as well.
    DO_DIAGONAL_MOVEMENT = false
    
    # If the tile they click on for movement is not passable, do you want
    # to check the surround tiles for a movable area?
    CHECK_FOR_MOVES = true
    
    # Would you like a black box to outline the exact tile the mouse is over?
    DEV_OUTLINE = false
    
    # Do you want the mouse to be confined to the game window?
    CLIP_CURSOR = false
    
    # Allow the use of the mouse wheel to scroll selectable windows?
    USE_WHEEL_DETECTION = true
    
  end
  
  module HoverText
    
    # This is the font for the hovering mouse text.
    FONT = "Verdana"
    
    # This is the font color for hovering mouse text.
    COLOR = Color.new(255, 255, 255, 255)
    
    # This is the font size for hovering mouse text.
    SIZE = 20
    
  end
  
  module Pathfinder
    
    # While mainly for coders, you may change this value to allow the
    # pathfinder more time to find a path. 1000 is default, as it is enough for
    # a 100x100 maze.
    MAXIMUM_ITERATIONS = 1000
    
    # This is a hash of directional values, please don't modify this.
    DIRECTIONAL_VALUES = {[1, 0] => 6, [-1, 0] => 4, [0, 1] => 2, [0, -1] => 8,
        [-1, 1] => 1, [-1, -1] => 7, [1, 1] => 3, [1, -1] => 9}
        
    # This is a hash of diagonal keys, please don't modify this.
    DIAGONAL_VALUES = {[-1, 1] => [4, 2], [-1, -1] => [4, 8], 
        [1, 1] => [6, 2], [1, -1] => [6, 8], [1, 0] => [6, 6], [-1, 0] => [4, 4], 
        [0, 1] => [2, 2], [0, -1] => [8, 8]}
    
  end
end
#===============================================================================
# DON'T EDIT FURTHER UNLESS YOU KNOW WHAT TO DO.
#===============================================================================
module Mouse
  
  ClipCursor        = PONY::API::ClipCursor
  GetKeyState       = PONY::API::GetKeyState
  GetCursorPo       = PONY::API::GetCursorPos
  SetCursorPos      = PONY::API::SetCursorPos
  GetMessage        = PONY::API::GetMessage
  GetAsyncKeyState  = PONY::API::GetAsyncKeyState
  ScreenToClient    = PONY::API::ScreenToClient
  GetClientRect     = PONY::API::GetClientRect
  GetWindowRect     = PONY::API::GetWindowRect
  ShowCursor        = Win32API.new('user32', 'ShowCursor', 'i', 'i')
  
  @handle = PONY::API::Hwnd  
  
  Point = Struct.new(:x, :y)
  
  Message = Struct.new(:message, :wparam, :lparam, :pt)
  
  Param = Struct.new(:x, :y, :scroll)
  
  Scroll = 0x0000020A
  
  module_function
  
  def hiword(dword)
    return((dword & 0xffff0000) >> 16) & 0x0000ffff
  end
  
  def loword(dword)
    return dword & 0x0000ffff
  end
    
  def word2signed_short(value)
    return value if (value & 0x8000) == 0
    return -1 *((~value & 0x7fff) + 1)
  end
  
  def unpack_dword(buffer, offset = 0)
    bitso = buffer.bytes.to_a
    ret = bitso[offset + 0] & 0x000000ff
    ret |=(bitso[offset + 1] << (8 * 1)) & 0x0000ff00
    ret |=(bitso[offset + 2] << (8 * 2)) & 0x00ff0000
    ret |=(bitso[offset + 3] << (8 * 3)) & 0xff000000
    return ret
  end
  
  def unpack_msg(buffer)
    msg = Message.new
    msg.pt = Point.new
    msg.message = unpack_dword(buffer,4 * 1)
    msg.wparam = unpack_dword(buffer, 4 * 2)
    msg.lparam = unpack_dword(buffer,4 * 3)
    msg.pt.x = unpack_dword(buffer, 4 * 5)
    msg.pt.y = unpack_dword(buffer, 4 * 6)
    return msg
  end
  
  def wmcallback(msg)
    return unless msg.message == Scroll
    param = Param.new
    param.x = word2signed_short(loword(msg.lparam))
    param.y = word2signed_short(hiword(msg.lparam))
    param.scroll = word2signed_short(hiword(msg.wparam))
    return [param.x, param.y, param.scroll]
  end
  
  def scroll
    msg = "\0" * 32
    GetMessage.call(msg, @handle, 0, 0)
    ar = []
    msg.each_byte {|bin| ar << bin}
    r = wmcallback(unpack_msg(msg))
    return r if !r.nil?
  end
  
  def click?(button)
    return false if @pos[0] == 0 || @pos[1] == 0
    return true if @keys.include?(button)
    return false
  end
  
  def press?(button)
    return true if @press.include?(button)
    return false
  end
  
  def set_pos(x_pos = 0, y_pos = 0)
    rect = client_rect
    width = rect[2] - rect[0]
    height = rect[3] - rect[1]
    if (x_pos.between?(0, width) && y_pos.between?(0, height))
      SetCursorPos.call(rect[0] + x_pos, rect[1] + y_pos)
    end
  end
  
  def moved?
    @pos != @old_pos
  end
  
  def cursor
    @cursor
  end
  
  def set_cursor(image)
    (@cursor ||= Sprite_Cursor.new).set_cursor(image)
  end
  
  def revert_cursor
    (@cursor ||= Sprite_Cursor.new).revert
  end
  
  def update
    ClipCursor.call(client_rect.pack('l4')) if Jet::MouseSystem::CLIP_CURSOR
    if !$game_switches.nil? 
      if $game_switches[Jet::MouseSystem::TURN_MOUSE_OFF_SWITCH]
        @keys, @press = [], []
        @pos = [-1, -1]
        @cursor.update
        return
      end
    end
    @old_pos = @pos.dup
    @pos = Mouse.pos
    @keys.clear
    @press.clear
    @keys.push(1) if GetAsyncKeyState.call(1) & 0x01 == 1
    @keys.push(2) if GetAsyncKeyState.call(2) & 0x01 == 1
    @keys.push(3) if GetAsyncKeyState.call(4) & 0x01 == 1
    @press.push(1) if pressed?(1)
    @press.push(2) if pressed?(2)
    @press.push(3) if pressed?(4)
    @cursor.update rescue @cursor = Sprite_Cursor.new
  end
  
  def init
    @keys = []
    @press = []
    @pos = Mouse.pos
    @cursor = Sprite_Cursor.new
  end
  
  def pressed?(key)
    return true unless GetKeyState.call(key).between?(0, 1)
    return false
  end
  
  def global_pos
    pos = [0, 0].pack('ll')
    GetCursorPo.call(pos) != 0 ? (return pos.unpack('ll')) : (return [0, 0])
  end
  
  def pos
    x, y = screen_to_client(*global_pos)
    width, height = client_size
    begin
      x = 0 if x <= 0; y = 0 if y <= 0
      x = width if x >= width; y = height if y >= height
      return x, y
    end
  end
  
  def screen_to_client(x, y)
    return nil unless x && y
    pos = [x, y].pack('ll')
    if ScreenToClient.call(@handle, pos) != 0
      return pos.unpack('ll')
    else
      return [0, 0]
    end
  end
  
  def client_size
    rect = [0, 0, 0, 0].pack('l4')
    GetClientRect.call(@handle, rect)
    right,bottom = rect.unpack('l4')[2..3]
    return right, bottom
  end
  
  def client_rect
    rect = [0, 0, 0, 0].pack('l4')
    GetWindowRect.call(@handle || @hwnd, rect)
    posi = rect.unpack('l4')[0..1]
    GetClientRect.call(@handle || @hwnd, rect)
    size = rect.unpack('l4')[2..3]
    scr = screen_to_client(*posi)
    x1 = posi[0] + scr[0].abs
    y1 = posi[1] + scr[1].abs
    x2 = size[0] + posi[0]
    y2 = size[1] + posi[1] + scr[1].abs
    rect = [x1, y1, x2, y2]
    rect
  end
  
  def grid
    [(@pos[0]/32),(@pos[1]/32)]
  end
  
  def true_grid
    xy = @pos
    x = ((xy[0] + ($game_map.display_x * 32)) / 32).floor
    y = ((xy[1] + ($game_map.display_y * 32)) / 32).floor
    [x, y]
  end
  
  def grid_by_pos
    [pos[0] / 32, pos[1] / 32]
  end
  
  def true_grid_by_pos
    xy = pos
    x = ((xy[0] + ($game_map.display_x * 32)) / 32).floor
    y = ((xy[1] + ($game_map.display_y * 32)) / 32).floor
    [x, y]
  end
  
  def area?(x, y, width, height)
    @pos[0].between?(x, width + x) && @pos[1].between?(y, height + y)
  end
  
  class Sprite_Cursor < Sprite
    
    attr_reader :cursor_bitmap
    
    def initialize
      super(nil)
      self.z = 50000
      @bitmap_cache = initial_bitmap
      # tag: modified
      #if Jet::MouseSystem::DEV_OUTLINE
        create_outline
      #end
    end
    
    def swap_bitmap(data)
      begin
        self.bitmap = Cache.picture(data)
      rescue
        self.bitmap = Bitmap.new(24, 24)
        icon_index = data
        rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
        self.bitmap.blt(0, 0, Cache.system("Iconset"), rect, 255)
      end
      @bitmap_cache = self.bitmap.dup
      @cursor_bitmap = data
    end
    
    def initial_bitmap
      begin
        self.bitmap = Cache.picture(Jet::MouseSystem::CURSOR_IMAGE)
        @cursor_bitmap = Jet::MouseSystem::CURSOR_IMAGE
      rescue
        self.bitmap = Bitmap.new(24, 24)
        icon_index = Jet::MouseSystem::CURSOR_ICON
        rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
        self.bitmap.blt(0, 0, Cache.system("Iconset"), rect, 255)
        @cursor_bitmap = Jet::MouseSystem::CURSOR_ICON
      end
      self.bitmap.dup
    end
    
    def set_cursor(image)
      if image.is_a?(Integer)
        self.bitmap = Bitmap.new(24, 24)
        icon_index = image
        rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
        self.bitmap.blt(0, 0, Cache.system("Iconset"), rect, 255)
      else
        self.bitmap = Cache.picture(image)
      end
    end
    
    def revert
      self.bitmap = @bitmap_cache.dup
    end
    
    def update
      super
      self.x, self.y = *Mouse.pos
      self.visible = !$game_switches[Jet::MouseSystem::TURN_MOUSE_OFF_SWITCH]
      if !@outline.nil?
        x = Mouse.true_grid_by_pos[0] * 32
        x -= $game_map.display_x.floor * 32
        x -= ($game_map.display_x % 1) * 32
        y = Mouse.true_grid_by_pos[1] * 32
        y -= $game_map.display_y.floor * 32
        y -= ($game_map.display_y % 1) * 32
        @outline.x = x
        @outline.y = [y, 1].max
      end
    end
  end
end
class << Input
  alias jet5888_press? press?
  def press?(arg)
    if arg == Input::C
      return true if Mouse.press?(1)
    elsif arg == Input::B
      return true if Mouse.press?(2)
    end
    jet5888_press?(arg)
  end
  
  alias jet5888_repeat? repeat?
  def repeat?(arg)
    if arg == Input::C
      return true if Mouse.click?(1)
    elsif arg == Input::B
      return true if Mouse.click?(2)
    end
    jet5888_repeat?(arg)
  end
  
  alias jet5888_trigger? trigger?
  def trigger?(arg)
    if arg == Input::C
      return true if Mouse.click?(1)
    elsif arg == Input::B
      return true if Mouse.click?(2)
    end
    jet5888_trigger?(arg)
  end
  
  alias jet8432_update update
  def update(*args, &block)
    jet8432_update(*args, &block)
    Mouse.update
  end
end
class Window_Selectable
  
  alias jet1084_update update
  def update(*args, &block)
    jet1084_update(*args, &block)
    @scrolled ||= false
    return if $game_switches[Jet::MouseSystem::TURN_MOUSE_OFF_SWITCH]
    update_scroll if self.active && self.visible && Jet::MouseSystem::USE_WHEEL_DETECTION
    update_mouse  if self.active && self.visible && (Mouse.moved? or @scrolled)
  end
  
  def update_scroll
    return if !scrollable?
    
    f = Mouse.scroll
    if !f.nil?
      Mouse.flag_scroll = f[2]
      if f[2] < 0
        if contents.height > self.height && self.oy - contents.height < -self.height + 32
          self.top_row = self.top_row + 1
        end
      else
        self.top_row = self.top_row - 1 if contents.height > self.height
      end
      @scrolled = true
    else
      Mouse.flag_scroll = nil
    end
  end
  
  def scrollable?
    @scroll_enable
  end
  
  def update_mouse
    @scrolled = false
    orig_index = @index
    rects = []
    add_x = self.x + 16 - self.ox
    add_y = self.y + 16 - self.oy
    
    if !self.viewport.nil?
      add_x += self.viewport.rect.x - self.viewport.ox
      add_y += self.viewport.rect.y - self.viewport.oy
    end
    
    unless self.is_a?(Window_PopInfo)
      self.item_max.times {|i|
        @index = i
        mouse_update_cursor
        rects << cursor_rect.dup
      }
      
      @index = orig_index
      
      rects.each_with_index {|rect, i|
        if Mouse.area?(rect.x + add_x, rect.y + add_y, rect.width, rect.height)
          @index = i
        end
      }
    end # skip selecting if window is a popup info
    update_cursor
    call_update_help
  end
  
  def mouse_update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
    elsif @index < 0
      cursor_rect.empty
    else
      cursor_rect.set(item_rect(@index))
    end
  end
end
class Window_NameInput
  
  def item_max
    90
  end
end
class Scene_File
  
  alias jet3467_update update
  def update(*args, &block)
    update_mouse if Mouse.moved?
    jet3467_update(*args, &block)
  end
  
  alias jet7222_top_index top_index=
  def top_index=(*args, &block)
    @last_cursor_move = 0 if @last_cursor_move.nil?
    @last_cursor_move -= 1
    return if @last_cursor_move > 0 && Mouse.moved?
    jet7222_top_index(*args, &block)
    @last_cursor_move = 10
  end
  
  def update_mouse
    self.item_max.times {|i|
      ix = @savefile_windows[i].x
      iy = @savefile_windows[i].y + 48 - @savefile_viewport.oy
      iw = @savefile_windows[i].width
      ih = @savefile_windows[i].height
      if Mouse.area?(ix, iy, iw, ih)
        @savefile_windows[@index].selected = false
        @savefile_windows[i].selected = true
        @index = i
      end
    }
    ensure_cursor_visible
  end
end
class Game_Temp
  
  attr_accessor :mouse_character, :mouse_movement, :mouse_path
  
end
class Window_MousePopUp < Window_Base
  
  def initialize(event, text)
    rect = Bitmap.new(1, 1).text_size(text)
    width = rect.width
    height = rect.height
    super(event.screen_x - width / 2, event.screen_y - 48, width + 32, height + 32)
    self.opacity = 0
    self.contents.font.name = Jet::HoverText::FONT
    self.contents.font.color = Jet::HoverText::COLOR
    self.contents.font.size = Jet::HoverText::SIZE
    @text = text
    @event = event
    refresh
  end
  
  def refresh
    contents.clear
    draw_text(0, 0, contents.width, contents.height, @text)
  end
  
  def update
    super
    self.visible = !@event.erased? && Mouse.true_grid_by_pos == [@event.x, @event.y]
    self.x = @event.screen_x - contents.width / 2 - 8
    self.y = @event.screen_y - 64
  end
end
class Game_Event
  
  attr_accessor :text_box
  
  def check_for_comment(regexp)
    return false if empty?
    for item in @list
      if item.code == 108 or item.code == 408
        if !item.parameters[0][regexp].nil?
          return $1.nil? ? true : $1
        end
      end
    end
    return false
  end
  
  def mouse_empty?
    return true if empty?
    return @list.reject {|a| [108, 408].include?(a.code) }.size <= 1
  end
  
  alias jet3745_setup_page setup_page
  def setup_page(*args, &block)
    jet3745_setup_page(*args, &block)
    @text_box = nil
    @mouse_activated = nil
    @mouse_cursor = nil
  end
  
  def mouse_activated?
    @mouse_activated ||= check_for_comment(/MOUSE[ ]*CLICK/i)
  end
  
  def text_box
    @text_box ||= (
      if (a = check_for_comment(/MOUSE[ ]*TEXT[ ]*(.+)/i))
        Window_MousePopUp.new(self, a)
      else
        false
      end
    )
  end
  
  def mouse_cursor
    @mouse_cursor ||= (
      if (a = check_for_comment(/MOUSE[ ]*PIC[ ]*(\d+)/i))
        a.to_i
      elsif (a = check_for_comment(/MOUSE[ ]*PIC[ ]*(.+)/i))
        a
      else
        false
      end
    )
  end
  
  def erased?
    @erased
  end
  
  def check_mouse_change
    if mouse_cursor
      Mouse.set_cursor(@mouse_cursor)
      return true
    end
    return false
  end
  
  alias jet3845_update update
  def update(*args, &block)
    jet3845_update(*args, &block)
    @text_box.update if text_box
  end
end
class Game_System
  
  attr_accessor :mouse_movement, :cursor_bitmap
  
  alias jet2735_initialize initialize
  def initialize(*args, &block)
    jet2735_initialize(*args, &block)
    @mouse_movement = Jet::MouseSystem::ALLOW_MOUSE_MOVEMENT
    @cursor_bitmap = Mouse.cursor.cursor_bitmap
  end
  
  def change_cursor_bitmap(data)
    Mouse.cursor.swap_bitmap(data)
    @cursor_bitmap = data
  end
  
  alias jet3457_on_after_load on_after_load
  def on_after_load(*args, &block)
    jet3457_on_after_load(*args, &block)
    Mouse.cursor.swap_bitmap(@cursor_bitmap)
  end
end
class Game_Interpreter
  
  def swap_mouse_cursor(data)
    $game_system.change_cursor_bitmap(data)
  end
end
class Scene_Title
  
  alias jet0019_start start
  def start(*args, &block)
    Mouse.cursor.initial_bitmap
    jet0019_start(*args, &block)
  end
end
class Scene_Map
  #------------------------------------------------------------------------------
  alias jet3745_update update
  def update(*args, &block)
    jet3745_update
    check_mouse_movement if $game_system.mouse_movement
    check_mouse_icon_change
  end
  #------------------------------------------------------------------------------
  alias jet5687_terminate terminate
  def terminate(*args, &block)
    $game_map.events.values.each {|a| 
      a.text_box.dispose if a.text_box
      a.text_box = nil
    }
    Mouse.update
    jet5687_terminate(*args, &block)
  end
  #------------------------------------------------------------------------------
  def mouse_char
    $game_temp.mouse_character
  end
  #------------------------------------------------------------------------------
  # * tag: merge
  #------------------------------------------------------------------------------
  def check_mouse_icon_change
    changed_mouse = false
    $game_map.events_xy(*Mouse.true_grid_by_pos).each {|event|
      changed_mouse = changed_mouse || event.check_mouse_change
      @mouse_hovered = event if event.trigger == 0
      $game_player.target_event = event if Mouse.click?(2)
    }
    Mouse.revert_cursor unless changed_mouse
  end
  #------------------------------------------------------------------------------
  # tag: modified
  #------------------------------------------------------------------------------
  def check_mouse_movement
    return if $game_system.story_mode?
    $game_temp.mouse_character ||= $game_player
    if Mouse.click?(2) && !SceneManager.tactic_enabled?
      tx, ty = *Mouse.true_grid_by_pos
      $game_player.move_to_position(tx, ty, tool_range: 0)
    end
  end
  
end
