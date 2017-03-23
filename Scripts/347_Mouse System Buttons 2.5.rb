#===========================================================================#
#  #*****************#                                                      #
#  #*** By Falcao ***#         Mouse System Buttons 2.5                     #
#  #*****************#         This is a button based mouse script, allow   #
#                              create as many buttons you want to the map   #
#                              screen or map ground, also provide you full  #
#       RMVXACE                mouse interaction within the game play       #
#                                                                           #
#                                                                           #
# Falcao RGSS site:  http://falcaorgss.wordpress.com                        #
# Falcao Forum site: http://makerpalace.com                                 #
#                                                                           #
#===========================================================================#
#----------------------------------------------------------------------------
# * Version 2.5 change log (Date: June 9 2013)
#
# Fixed non-refreshing item description bug
# Fixed Save file selection issue
# Added ability to start events even if the player is no facing the event 
# Removed option to display arrow selector on save file
# Added compatibility for multiples game resolutions
# Item selection with mouse is now more occurate
# Fixed issue with pearl skillbar (when clicking any tool perform path finding)
# Cleaned up some code
#
#----------------------------------------------------------------------------
# * Version 2.0 change log (Date: January 13 2013)
#
# - Added path finding, now the game player is able to move using the mouse
# - Now you are able to change the mouse cursor icon in game
# - Two new notetags added to change the mouse cursor by event comment tags
# - Fixed crash when pointing a notetagged event with a valid condition
#----------------------------------------------------------------------------
# * Version 1.6 change log (Date: November 21 2012)
# 
# - Added compatibility for any game screen resolution
# - System optimized to consume less cpu than before
# - Added extra compatibility for Pearl ABS Liquid
# - Removed the font fix
# - Added the imported bolean
#----------------------------------------------------------------------------
# * Version 1.5 change log
#
# - Fixed cursor sound over loading on selectable windows
# - Fixed bug when selecting event graphic tileset that have mouse comment tag
# - FIxed minor bug when transfering (event name now erase completely)
# - Added option to turn on / off arrow selector on save file
# - Important! changes on mouse comment tags! 
#   ~ CLICK START change to MOUSE START
#   ~ ANIMATION   change to MOUSE ANIMATION
#   ~ NAME        change to MOUSE NAME
#
#---------------------------------------------------------------------------
# * installation
#
# Copy and paste this script above main done!
#
# * Mouse triggers 
#   - Left click:     Action button
#   - Right click:    Cancel button, close windows
#   - Mouse wheel middle button:   DASH
#
#---------------------------------------------------------------------------
# * Main features
# 
# - Allow you create buttons and configure them to do something
# - Events can be buttons too, map ground buttons! for some puzzles etc.
# - Allow you display event name 
# - Full mouse interaction
# - WASD movement optional
# - Path finding feature, player is able to move using the mouse
# - Mouse cursor changing in-game enabled
#---------------------------------------------------------------------------
# * Event buttons commands
# 
# Write this lines on event comments tags
# 
# MOUSE START       - Event start when you click the event
# MOUSE ANIMATION x - Show animation when mouse is over event,
#                     ex: MOUSE ANIMATION 1
# MOUSE NAME x      - Display event name when mouse is over event,
#                     ex: MOUSE NAME Falcao
# MOUSE ICON x      - change the mouse cursor icon when it is over the event
#                     change x for the icon index to display
# MOUSE PIC X       - Change the mouse cursor when is over an event but in this
#                     case it display a picture graphic name, change x for the
#                     picture name
#------------------------------------------------------------------------------
# * Script calls
#
# Call this line to turn off/on the mouse cursor within the game true/false
# Mouse.show_cursor(false)
#
# If you want to change the mouse cursor manually use the following script calls
# Mouse.set_cursor(:iconset, x)     - change x for any icon index
#
# if you want to show a picture instead iconset use the next script call
# Mouse.set_cursor(:picture, name)  - change name for picture name
#-----------------------------------------------------------------------------
module Map_Buttons
# You can easily insert as many buttons you want to the map screen
# define here below your buttons parameters
  
  Insert = {
#-----------------------------------------------------------------------------
#  A => [B, C, D, E, F]
#  
#  A = Button number
#
#  B = Name 
#  C = X position in screen tile
#  D = Y position in screen tile
#  E = Icon, if you want a picture write picture 'name' otherwise icon index
#  F = What this button gonna do?, you have two options, call scene or call
#  common event, if you want scene put scene name, if you want common event
#  put common event ID
  
  # This button call the menu screen
  #1=> ["Menu", 16, 11, 117, Scene_Menu],  
  
  # This button call a common event ID 1
  #2=>  ["Bestiary",  16, 12, 121, 1],
  
  
  }
# * General configutration
# Mouse cursor icon, if you want a picture write pic 'name' otherwise icon index
  CursorIcon = 10821
# Switch ID to turn off/on the icons on the screen
  Switch = 28
  
# Allow movement with  W A S D keys true/false
  WASD_Movement = true
  
# When you click on event, do you want the player to ignore the self movement?
  IgnoreEventPath = true
  
# Switch id to enable or disable the path finding feature
  PathFinderSwitch = 500
#
#----------------------------------------------------------------------------
#
# * License
#
# You can use this script in non comercial games, in you need it for comercial
# games let me know. falmc99@gmail.com
#-----------------------------------------------------------------------------
  def self.check_value(value)
    return 'numeric' if value.is_a? Fixnum 
    return 'string'
  end
end
($imported ||= {})[:Mouse_System_Buttons] = 2.0
# This class create all screen and event buttons on game screen
class Interactive_Buttoms
  attr_reader :cursoring
  def initialize
    create_screen_buttoms
    @ani_delay = 0
    @pearl_abs = $imported["Falcao Pearl ABS Liquid"]
  end
  
  def create_screen_buttoms
    @buttons_sprites = []
    for i in Map_Buttons::Insert.values
      @buttons_sprites.push(Sprite_Buttons.new(i[0], i[1], i[2], i[3], i[4]))
    end
  end
  
  def create_button_text
    if @button_text.nil?
      @button_text = Sprite.new
      @button_text.bitmap = Bitmap.new(100, 32)
      @button_text.z = 50
      @button_text.bitmap.font.size = 16
    end
  end
  
  def dispose_screen_buttons
    for button in @buttons_sprites
      button.dispose
    end
    @buttons_sprites = []
  end
  
  def dispose_button_text
    if not @button_text.nil?
      @button_text.dispose
      @button_text.bitmap.dispose
      @button_text = nil
    end
  end
  
  def dispose
    dispose_screen_buttons
    dispose_button_text
  end
  
  def update
    if $game_switches[Map_Buttons::Switch] and not @buttons_sprites.empty?
      dispose_screen_buttons
    elsif not $game_switches[Map_Buttons::Switch] and @buttons_sprites.empty?
      create_screen_buttoms
    end
    update_buttons
    update_event_selection
  end
  
  # path update
  def update_path
    return if $game_switches[Map_Buttons::PathFinderSwitch]
    return if $game_message.busy?
    return unless $game_player.normal_walk?
    @mxx, @myy = Mouse.map_grid[0], Mouse.map_grid[1]
    if Map_Buttons::IgnoreEventPath
      $game_map.events.values.each do |event|
        return if event.x == @mxx and event.y == @myy
      end
    end
  end
  
  
  def on_toolbar?
    return false unless @pearl_abs
    9.times.each {|x| return true if @mxx == PearlSkillBar::Tile_X + x and
    @myy == PearlSkillBar::Tile_Y}
    return false
  end
  
  
  def update_buttons
    for button in @buttons_sprites
      button.update
      if button.zooming
        @screen_b = true
        create_button_text
        if button.x > 272 
          x, y = button.px * 32 - 98, button.py * 32
          draw_button_text(x, y, button.name, 2)
        elsif button.x < 272 
          x, y = button.px * 32 + 31, button.py * 32
          draw_button_text(x, y, button.name, 0)
        end
      end
    end
    
    if @screen_b != nil
      unless mouse_over_button?
        dispose_button_text
        @screen_b = nil
      end
    end
  end
  
  def reset_cursor
    if Map_Buttons::check_value(@cursoring[1]) == 'numeric'
      Mouse.set_cursor(:iconset, @cursoring[1], true)
    else
      Mouse.set_cursor(:picture, @cursoring[1], true)
    end
    @cursoring = nil
  end
  
  def apply_iconchanging(sym, operand, event)
    cursor = $game_system.cursorr
    cursor = Map_Buttons::CursorIcon if cursor.nil?
    @cursoring = [event, cursor]
    Mouse.set_cursor(sym, operand, true)
  end
  
  def update_event_selection
    return if @screen_b #disable event buttom if mouse over screen buttom
    update_path if Mouse.trigger?(0)
    for event in $game_map.events.values
      next if event.page.nil?
      
      if Mouse.adjacent?(event.x, event.y)
        if Mouse.trigger?(0) && !$game_map.interpreter.running?
          if event.mouse_start
            event.start
          else
            $game_player.move_to_position(event.x, event.y, tool_range: 1)
            $game_player.target_event = event
          end
        end
        
        if event.square_size?($game_player, 2)
          if Mouse.trigger?(0) and !$game_map.interpreter.running?
            event.start
          end
        end
        
        anime = event.mouse_animation
        if anime != 0
          @ani_delay += 1
          event.animation_id = anime if @ani_delay == 1
          @ani_delay = 0 if @ani_delay > 16
        end
        name = event.mouse_name
        if name != ""
          @eve = [event.x, event.y, event, name]
          create_button_text
        end
        icon = event.mouse_iconset
        picture = event.mouse_picture
        if !icon.nil? and icon != 0 and @cursoring.nil?
          apply_iconchanging(:iconset, icon, event)
        elsif !picture.nil? and picture != "" and @cursoring.nil?
          apply_iconchanging(:picture, picture, event)
        end
      end
    end
    
    if @cursoring != nil
      reset_cursor if not mouse_over_event?(@cursoring[0].x, @cursoring[0].y)
    end
    
    if @eve != nil
      @eve[2].ch_oy.nil? ? event_oy = 32 : event_oy = @eve[2].ch_oy
      if event_oy > 32
        draw_button_text(@eve[2].screen_x - 49,
        @eve[2].screen_y - event_oy / 2 - 50, @eve[3], 1)
      else
        draw_button_text(@eve[2].screen_x - 49,
        @eve[2].screen_y - event_oy / 2 - 36, @eve[3], 1)
      end
      if not mouse_over_event?(@eve[0], @eve[1])
        dispose_button_text
        @eve = nil
      end
    end
  end
  
  def draw_button_text(x, y, text, a=0)
    return if @button_text.nil?
    @button_text.x = x
    @button_text.y = y
    return if @old_name == text
    @button_text.bitmap.clear
    @button_text.bitmap.draw_text(2, 0, @button_text.bitmap.width, 32, text, a)
    @old_name = text
  end
  
  def mouse_over_button?
    for button in @buttons_sprites
      if Mouse.object_area?(button.x, button.y - 6, button.width, button.height)
        return true
      end
    end
    @old_name = nil
    return false
  end
  
  def mouse_over_event?(event_x, event_y)
    if Mouse.adjacent?(event_x, event_y)
      return true
    end
    @old_name = nil
    return false
  end
end
# Set buttons sprites
class Spriteset_Map
  
  alias falcao_insert_buttuns_view create_viewports
  def create_viewports
    @interact_buttoms = Interactive_Buttoms.new
    falcao_insert_buttuns_view
  end
  
  alias falcao_insert_buttuns_dis dispose
  def dispose
    @interact_buttoms.reset_cursor if @interact_buttoms.cursoring != nil
    @interact_buttoms.dispose
    falcao_insert_buttuns_dis
  end
  
  alias falcao_insert_buttuns_up update
  def update
    if $game_player.clear_mousepointers
      @interact_buttoms.dispose if @interact_buttoms
      $game_player.clear_mousepointers = nil
    end
    @interact_buttoms.update if @interact_buttoms
    falcao_insert_buttuns_up
  end
end
# comments definition
class Game_Event < Game_Character
  attr_reader   :mouse_start, :mouse_animation, :mouse_name, :mouse_iconset
  attr_reader   :mouse_picture, :page
  alias falcaomouse_setup setup_page_settings
  def setup_page_settings
    falcaomouse_setup
    @mouse_start     = check_comment("MOUSE START")
    @mouse_animation = check_value("MOUSE ANIMATION")
    @mouse_name      = check_name("MOUSE NAME")
    @mouse_iconset   = check_value("MOUSE ICON")
    @mouse_picture   = check_name("MOUSE PIC")
  end
  def check_comment(comment)
    return false if @list.nil? or @list.size <= 0
    for item in @list
      if item.code == 108 or item.code == 408
        if item.parameters[0].include?(comment)
          return true
        end
      end
    end
    return false
  end
  
  def check_value(comment)
    return 0 if @list.nil? or @list.size <= 0
    for item in @list
      if item.code == 108 or item.code == 408
        if item.parameters[0] =~ /#{comment}[ ]?(\d+)?/
          return $1.to_i
        end
      end
    end
    return 0
  end
  
  def check_name(comment)
    return "" if @list.nil? or @list.size <= 0
    for item in @list
      next unless item.code == 108 or item.code == 408
      if item.parameters[0] =~ /#{comment} (.*)/
        return $1.to_s
      end
    end
    return ""
  end
  
  def square_size?(target, size)
    distance = (@x - target.x).abs + (@y - target.y).abs
    enable   = (distance <= size-1)
    return true if enable
    return false
  end
  
end
# Create screen buttons sprites
class Sprite_Buttons < Sprite
  attr_reader   :px
  attr_reader   :py
  attr_reader   :name
  attr_reader   :zooming
  def initialize(name, px, py, icon_index, action=nil)
    super()
    self.z = 50
    @icon_index = icon_index
    @px = px 
    @py = py
    @action = action
    @object_zooming = 0
    @zooming = false
    @name = name
    set_bitmap
    update
  end
  
  def update
    super
    if Mouse.object_area?(self.x, self.y - 4, self.bitmap.width,
      self.bitmap.height)
      @zooming = true
      @object_zooming += 1
      case @object_zooming
      when 1..10  ; self.zoom_x -= 0.02 ;  self.zoom_y -= 0.02
      when 11..20 ; self.zoom_x += 0.02 ;  self.zoom_y += 0.02
      when 21..30 ; self.zoom_x = 1.0   ;  self.zoom_y = 1.0
        @object_zooming = 0 
      end
      if Mouse.trigger?(0) and @action != nil
        unless $game_map.interpreter.running?
          Sound.play_ok
          if @action == Scene_Menu and not $game_system.menu_disabled
            SceneManager.call(@action)
            Window_MenuCommand::init_command_position
            return
          end
         if Map_Buttons::check_value(@action) == 'numeric'
           $game_temp.reserve_common_event(@action)
         else
           SceneManager.call(@action)
         end
        end
      end
    elsif @object_zooming > 0
      self.zoom_x = 1.0
      self.zoom_y = 1.0
      @object_zooming = 0 
    else
      @zooming = false
    end
  end
  
  def set_bitmap
    if Map_Buttons::check_value(@icon_index) == 'numeric'
      self.bitmap = Bitmap.new(24, 24)
      bitmap = Cache.system("Iconset")
      rect = Rect.new(@icon_index % 16 * 24, @icon_index / 16 * 24, 24, 24)
      self.bitmap.blt(0, 0, bitmap, rect)
    else
      self.bitmap = Cache.picture(@icon_index)
    end
    self.x = @px * 32 + 4
    self.y = @py * 32 + 4
  end
end
# Sprite character
class Sprite_Character < Sprite_Base
  alias falcaoadd_oxy_set_character_bitmap set_character_bitmap
  def set_character_bitmap
    falcaoadd_oxy_set_character_bitmap
    @character.ch_oy = self.oy
  end
end
class Game_System
  attr_accessor :current_cursor
  def cursorr
    return Map_Buttons::CursorIcon if @current_cursor.nil?
    return @current_cursor
  end
end
# Mouse module
module Mouse
  
  GetKeyState    = Win32API.new('user32',    'GetAsyncKeyState', 'i',     'i')
  GetCursorPos   = Win32API.new('user32',    'GetCursorPos',     'p',     'i')
  GetClientRect  = Win32API.new('user32',    'GetClientRect',    %w(l p), 'i')
  ShowCursor     = Win32API.new('user32',    'ShowCursor',       'i',     'l')
  ScreenToClient = Win32API.new('user32',    'ScreenToClient',   %w(l p), 'i')
  Findwindow     = Win32API.new('user32',    'FindWindowA',      %w(p p), 'l')
  GetPrivatePro  = Win32API.new('kernel32',  'GetPrivateProfileStringA', 
  %w(p p p p l p), 'l')
                               
  ShowCursor.call(0)
  
  @triggers     =   [[0, 1], [0, 2], [0, 4]]
  @old_pos      =   0
  # Mouse Sprite
  
  def self.set_cursor(sym, operand, write=false)
    case sym
    when :iconset
      $mouse_cursor.bitmap = Bitmap.new(24, 24)
      bitmap = Cache.system("Iconset")
      rect = Rect.new(operand % 16 * 24, operand / 16 * 24, 24, 24)
      $mouse_cursor.bitmap.blt(0, 0, bitmap, rect)
    when :picture then $mouse_cursor.bitmap = Cache.picture(operand)
    end
    $game_system.current_cursor = operand if write
  end
  
  $mouse_cursor = Sprite.new
  icon = Map_Buttons::CursorIcon
  if Map_Buttons::check_value(icon) == 'numeric'
    set_cursor(:iconset, icon)
  else
    set_cursor(:picture, icon)
  end
  $mouse_cursor.z = 10001
  $mouse_cursor.x = $mouse_cursor.y = 1000
  $mouse_cursor.ox = 4
  
  def self.show_cursor(value)
    unless value
      @pos[0] = @pos[1] = 600
    end
    $mouse_cursor.visible = value
  end
  
  def self.map_grid
    return nil if @pos == nil 
    x = ($game_map.display_x) + (@pos[0].to_f / 32).to_f
    y = ($game_map.display_y) + (@pos[1].to_f / 32).to_f
    return [x,y]
  end
  
  def self.standing?
    return false if @old_px != @pos[0]
    return false if @old_py != @pos[1]
    return true
  end
  
  def self.input_keys
    $game_arrows.mode_on ? type = $game_arrows.in_type : type = Input::C
    keys = {0 => type, 1 => Input::B, 2 => Input::A}
    return keys
  end
  
  def self.object_area?(x, y, width, height)
    return false if @pos.nil?
    return @pos[0].between?(x, width + x) && @pos[1].between?(y, height + y)
  end
  
  def self.position
    return @pos == nil ? [0, 0] : @pos
  end
  
  def self.global_pos
    pos = [0, 0].pack('ll')
    return GetCursorPos.call(pos) == 0 ? nil : pos.unpack('ll')
  end
 
  def self.screen_to_client(x=0, y=0)
    pos = [x, y].pack('ll')
    return ScreenToClient.call(self.hwnd, pos) == 0 ? nil : pos.unpack('ll')
  end  
 
  def self.pos
    global_pos = [0, 0].pack('ll')    
    gx, gy = GetCursorPos.call(global_pos) == 0 ? nil : global_pos.unpack('ll')
    local_pos = [gx, gy].pack('ll')
    x, y = ScreenToClient.call(self.hwnd,
    local_pos) == 0 ? nil : local_pos.unpack('ll')
    begin
      if (x >= 0 && y >= 0 && x <= Graphics.width && y <= Graphics.height)
        @old_px, @old_py = x, y
        return x, y
      else
        return -20, -20
      end
    rescue
      return 0, 0 
    end
  end  
    
  def self.update
    @old_pos = @pos
    @pos = self.pos
    self.input_keys
    if !$mouse_cursor.visible && @old_pos != @pos
      $mouse_cursor.visible = true
    end
    if @old_pos != [-20, -20] && @pos == [-20, -20]
      ShowCursor.call(1)
    elsif @old_pos == [-20, -20] && @pos != [-20, -20]
       ShowCursor.call(0)
    end
    for i in @triggers
      n = GetKeyState.call(i[1])
      if [0, 1].include?(n)
        i[0] = (i[0] > 0 ? i[0] * -1 : 0)
      else
        i[0] = (i[0] > 0 ? i[0] + 1 : 1)
      end
    end
  end
  
  def self.moved?
    return @old_pos != @pos
  end
  
  # trigger definition
  def self.trigger?(id = 0)
    pos = self.pos
    if pos != [-20,-20]
    case id
      when 0  
        return @triggers[id][0] == 1
      when 1  
        if @triggers[1][0] == 1 && !$game_system.menu_disabled
          return @triggers[id][0] == 1 
        end
      when 2 
        return @triggers[id][0] == 1
      end    
    end
  end
  
  # repeat definition
  def self.repeat?(id = 0)
    if @triggers[id][0] <= 0
      return false
    else
      return @triggers[id][0] % 5 == 1 && @triggers[id][0] % 5 != 2
    end
  end
  
  #press definition
  def self.press?(id = 0)
    if @triggers[id][0] <= 0
      return false
    else
      return true 
    end
  end
  
  def self.screen_to_client(x=0, y=0)
    pos = [x, y].pack('ll')
    return ScreenToClient.call(self.hwnd, pos) == 0 ? nil : pos.unpack('ll')
  end
 
  def self.hwnd
    if @hwnd.nil?
      game_name = "\0" * 256
      GetPrivatePro.call('Game', 'Title', '', game_name, 255, ".\\Game.ini")
      game_name.delete!("\0")
      @hwnd = Findwindow.call('RGSS Player', game_name)
    end
    return @hwnd
  end
  
  def self.client_size
    rect = [0, 0, 0, 0].pack('l4')
    GetClientRect.call(self.hwnd, rect)
    right, bottom = rect.unpack('l4')[2..3]
    return right, bottom
  end
end
# Input module aliased
class << Input
  unless self.method_defined?(:falcao21_mouse_update)
    alias_method :falcao21_mouse_update,   :update
    alias_method :falcao21_mouse_trigger?, :trigger?
    alias_method :falcao21_mouse_repeat?,  :repeat?
    alias_method :fal_mouse_input_press?,  :press?
  end
  
  def update
    if $mouse_cursor.visible
      Mouse.update
      $game_arrows.update
      mx, my = *Mouse.position
      $mouse_cursor.x = mx unless mx.nil?
      $mouse_cursor.y = my unless my.nil?    
    end
    falcao21_mouse_update
  end
  
  # trigger
  def trigger?(constant)
    return true if falcao21_mouse_trigger?(constant)
    unless Mouse.pos.nil?
      if Mouse.input_keys.has_value?(constant)
        mouse_trigger = Mouse.input_keys.index(constant)
        return true if Mouse.trigger?(mouse_trigger) 
      end
    end
    return false
  end
 
  # press
  def press?(constant)
    return true if fal_mouse_input_press?(constant)
    unless Mouse.pos.nil?
      if Mouse.input_keys.has_value?(constant)
        mouse_trigger = Mouse.input_keys.index(constant)
        return true if Mouse.press?(mouse_trigger)      
      end
    end
    return false
  end
  
  # repeat
  def repeat?(constant)
    return true if falcao21_mouse_repeat?(constant)
    unless Mouse.pos.nil?
      if Mouse.input_keys.has_value?(constant)
        mouse_trigger = Mouse.input_keys.index(constant)     
        return true if Mouse.repeat?(mouse_trigger)
      end
    end
    return false
  end
end
# Here your best friend, you can call this script within the game, scene etc.
# $game_arrows.create_arrows(x, y), create it, $game_arrows.dispose, delete it
class Game_Arrow_Selector
  attr_accessor :mode_on
  attr_accessor :in_type
  def initialize
    @mode_on = false
  end
  def create_arrows(x, y)
    return unless @arrows_sprites.nil?
    buttons = {1=> 'UP', 2=> 'RIGHT', 3=> 'DOWN',
    4=> 'LEFT', 5=> 'OK', 6=> 'Cancel'}
    @arrows_sprites = []
    for i in buttons.values
      @arrows_sprites.push(Garrows_Sprites.new(i, x, y))
    end
  end
  
  def dispose
    return if @arrows_sprites.nil?
    for arrow in @arrows_sprites
      arrow.dispose
    end
    @arrows_sprites = nil
    @mode_on = false
  end
  
  def update
    return if @arrows_sprites.nil?
    for arrow in @arrows_sprites
      arrow.update
    end
  end
end
class Garrows_Sprites < Sprite
  def initialize(name, x, y)
    super()
    self.z = 1000
    @px, @py = x, y
    @name = name
    @object_zooming = 0
    @zooming = false
    set_bitmap
    update
  end
  
  def update
    super
    if Mouse.object_area?(self.x + @fix[0], self.y + @fix[1],
      self.bitmap.width + @fix[2], self.bitmap.height + @fix[3])
      $game_arrows.mode_on = true
      $game_arrows.in_type = Input::UP    if @name == 'UP'
      $game_arrows.in_type = Input::DOWN  if @name == 'DOWN'
      $game_arrows.in_type = Input::LEFT  if @name == 'LEFT'
      $game_arrows.in_type = Input::RIGHT if @name == 'RIGHT'
      $game_arrows.in_type = Input::C     if @name == 'OK'
      $game_arrows.in_type = Input::B     if @name == 'Cancel'
      @object_zooming += 1
      @zooming = true
      case @object_zooming
      when 1..10  ; self.zoom_x -= 0.01 ;  self.zoom_y -= 0.01
      when 11..20 ; self.zoom_x += 0.01 ;  self.zoom_y += 0.01
      when 21..30 ; self.zoom_x = 1.0   ;  self.zoom_y = 1.0
        @object_zooming = 0 
      end
    elsif @object_zooming > 0
      self.zoom_x = 1.0
      self.zoom_y = 1.0
      @object_zooming = 0 
    elsif @zooming
      @zooming = false
      $game_arrows.mode_on = false
    end
  end
  
  def set_bitmap
    self.bitmap = Bitmap.new(24, 15) if @name != 'Cancel'
    case @name
    when 'UP'
      self.x = @px + 25 ; self.y = @py - 2
      self.angle = 182  ; @fix = [-23, -18, 0,  0]
    when 'DOWN'
      self.x = @px + 1 ; self.y = @py + 26
      @fix = [0, -4, 0,  0]
    when 'LEFT'
      self.x = @px      ; self.y = @py + 1
      self.angle = - 92 ; @fix = [-14, -4, - 9,  9]
    when 'RIGHT'
      self.x = @px + 26  ; self.y = @py + 26
      self.angle = + 92  ; @fix = [0, - 26, - 9,  9]
    when 'OK'
      self.x = @px + 1  ; self.y = @py + 6
      @fix = [0, -4, 0,  0]
      self.bitmap.font.size = 20
      self.bitmap.draw_text(4, -7, self.bitmap.width, 32, @name)
      return
    when 'Cancel'
      self.x = @px - 11  ; self.y = @py + 42
      @fix = [0, -4, 0,  0]
      self.bitmap = Bitmap.new(50, 15)
      self.bitmap.font.size = 20
      self.bitmap.draw_text(2, -7, self.bitmap.width, 32, @name)
      return
    end
    draw_crappy_triangle(0, 0)
  end
  
  # This method create a crappy triangle pointing down
  def draw_crappy_triangle(px, py)
    color = Color.new(192, 224, 255, 255)
    x, y, w, =  0, 4, 24
    self.bitmap.fill_rect(px + 1, py, 22, 1, color)
    self.bitmap.fill_rect(px,     py + 1, 24, 4, color)
    for i in 1..10
      x += 1; y += 1; w -= 2
      self.bitmap.fill_rect(px + x, py + y,       w, 1, color) 
    end
  end
end
$game_arrows = Game_Arrow_Selector.new
# Arrow selector is displayed when Input number is on
class Game_Interpreter
  alias falcao_setup_num_input setup_num_input
  def setup_num_input(params)
    falcao_setup_num_input(params)
    $game_arrows.create_arrows(256, 194) if $game_message.position == 0
    $game_arrows.create_arrows(256, 340) if $game_message.position == 1
    $game_arrows.create_arrows(256, 180) if $game_message.position == 2
  end
end
# Arrow selector is disposed when press ok
class Window_NumberInput < Window_Base
  alias falcao_process_ok process_ok
  def process_ok
    falcao_process_ok
    $game_arrows.dispose
  end
end
# If event start with mouse
class Game_Player < Game_Character
  
  alias falcao_start_map_event start_map_event
  def start_map_event(x, y, triggers, normal, rect = collision_rect)
    $game_map.events_xy(x, y).each do |event_click|
      return if event_click.check_comment("MOUSE START")
    end  
    falcao_start_map_event(x, y, triggers, normal)
  end
end
# clear pointers when tranfering
class Game_Player < Game_Character
  attr_accessor :clear_mousepointers
  alias falcaomouse_perform_transfer perform_transfer
  def perform_transfer
    @clear_mousepointers = true if $game_map.map_id !=  @new_map_id
    falcaomouse_perform_transfer
  end
end
# Window selectable (Thanks wora for some lines here)
class Window_Selectable < Window_Base
  alias mouse_selection_ini initialize
  def initialize(*args)
    mouse_selection_ini(*args)
    @scroll_wait = 0
    @cursor_wait = 0
    @sdelay = 0
  end
  
  alias mouse_selection_update update
  def update
    update_mouse_selection if self.active and self.visible and !@overlayed
    @sdelay -= 1 if @sdelay > 0
    mouse_selection_update
  end
  
  def update_mouse_selection
    
    @cursor_wait -= 1 if @cursor_wait > 0
    plus_x = self.x + 16 - self.ox
    plus_y = self.y + 8 - self.oy
    
    unless self.viewport.nil?
      plus_x += self.viewport.rect.x - self.viewport.ox
      plus_y += self.viewport.rect.y - self.viewport.oy
    end
    
    (0..self.item_max - 1).each do |i|
      irect = item_rect(i)
      move_cursor(i) if Mouse.object_area?(
      irect.x + plus_x, irect.y + plus_y, irect.width, irect.height)
      update_cursor
    end
  end
  
  def play_mousecursor_se(index = -1)
    return if index == @index || @sdelay > 0
    Sound.play_cursor
    @sdelay = 5
  end
  
  
  def move_cursor(index)
    return if @index == index
    
    @scroll_wait -= 1 if @scroll_wait > 0
    row1 = @index / self.col_max
    row2 = index / self.col_max
    bottom = self.top_row + (self.page_row_max - 1)
    
    if row1 == self.top_row and row2 < self.top_row
      return if @scroll_wait > 0
      @index = [@index - self.col_max, 0].max
      @scroll_wait = 10
    elsif row1 == bottom and row2 > bottom
      return if @scroll_wait > 0
      @index = [@index + self.col_max, self.item_max - 1].min
      @scroll_wait = 10
    elsif Mouse.moved?
      @index = index
    end
    
    if Mouse.moved? || @scroll_wait > 0
      play_mousecursor_se
      select(@index)
    end
    
    return if @cursor_wait > 0
    @cursor_wait += 2
  end
end
class Window_NameInput
  def item_max
    return 90
  end
end
class Scene_File < Scene_MenuBase
  alias mouse_top_index top_index=
  def top_index=(index)
    @scroll_timer = 0 if @scroll_timer.nil? ; @scroll_timer -= 1
    return if @scroll_timer > 0
    mouse_top_index(index) ; @scroll_timer = 35
  end
  
  alias mouse_sb_update update
  def update
    (0..self.item_max - 1).each do |i|
      ix = @savefile_windows[i].x
      iy = @savefile_windows[i].y + 40 - @savefile_viewport.oy
      iw = @savefile_windows[i].width
      ih = @savefile_windows[i].height
      if Mouse.object_area?(ix, iy, iw, ih)
        @savefile_windows[@index].selected = false
        @savefile_windows[i].selected = true
        @index = i
      end
      ensure_cursor_visible
    end
    mouse_sb_update
  end
end
