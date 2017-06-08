#==============================================================================
# ** Window_Input
#------------------------------------------------------------------------------
#   Allow user to input texts via Windows build-in mehtod
#==============================================================================
class Window_Input < Window_Base
  include PONY::API
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  WS_POPUP        = 0x80000000
  WS_CHILD        = 0x40000000
  WS_VISIBLE      = 0x10000000
  WS_DISABLED     = 0x08000000
  ES_AUTOSCROLL   = 0x00000080
  ES_NUMBER       = 0x00002000
  EM_SETSEL       = 0xb1
  EM_GETSEL       = 0xb0
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :hwnd
  attr_accessor :index
  attr_accessor :focus
  #--------------------------------------------------------------------------
  def get_windowstyle(args)
    ws  = WS_CHILD
    ws |= WS_POPUP      if args[:popup]
    ws |= WS_DISABLED   if args[:visible]
    ws |= ES_NUMBER     if args[:number]
    ws |= ES_AUTOSCROLL if args[:autoscroll]
    return ws
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 0, width = 480, height = 24, attributes = {})
    super(x, y, width, fitting_height(1))
    self.windowskin = Cache.system(WindowSkin::InputBox)
    wstyle  = get_windowstyle(attributes)
    @hwnd = CreateWindowEx.call(1, "Edit", "", wstyle,
                                x, y, width, height, Hwnd, 0, 
                                GetModuleHandle.call(nil), 0)
    #-----------------------------------------------------------------------
    # > init vars
    @viewport        = SceneManager.viewport
    @width           = width
    @height          = height
    @display_width   = (@width - spacing * 2) / item_width
    @char_limit      = attributes[:autoscroll] ? 256 : @display_width
    @last_str        = ""
    @last_len        = 0
    @last_index      = 0
    @last_select     = 0
    @index           = 0
    @select_start    = 0
    @select_end      = 0
    @select_ori      = 0
    @enter_cnt       = 0
    @display_bot     = 0
    @display_top     = 0
    @wchar_num       = 0
    @index_width     = []
    @keyboard_action = []
    @arrow_sprites   = []
    @focus           = true
    self.z = @viewport.z
    
    create_sprites
    SetFocus.call(@hwnd) if focus
  end
  #--------------------------------------------------------------------------
  def spacing
    return 4
  end
  #--------------------------------------------------------------------------
  def item_width
    Font.default_size / 2
  end
  #--------------------------------------------------------------------------
  def create_sprites
    create_second_viewport
    create_cursor(x, y)
    create_arrows
  end
  #--------------------------------------------------------------------------
  def create_second_viewport
    @viewport2 = Viewport.new
    @viewport2.z = 300
  end
  #--------------------------------------------------------------------------
  # * Create Cursor Sprite
  #--------------------------------------------------------------------------
  def create_cursor(cx, cy)
    @cursor = Sprite.new(@viewport2)
    @cursor.bitmap = Bitmap.new(4, item_width * 2)
    @cursor.bitmap.fill_rect(0, 0, 1, item_width * 2, DND::COLOR::Purple)
    @cursor.x, @cursor.y = cx, cy + spacing * 3
  end
  #--------------------------------------------------------------------------
  # * Create hint arrow for existance of other undisplayed text
  #--------------------------------------------------------------------------
  def create_arrows
    bx, by = 80, 16
    bw, bh = 8, 16
    2.times do |i|
      sprite = Sprite.new(@viewport2)
      sprite.bitmap = Bitmap.new(bw, bh)
      sx     = (i == 0 ? bx : (bx + bw + bh)) # 0 for left, 1 for right arrow
      rect   = Rect.new(sx, by + bw, bw, bh)
      sprite.bitmap.blt(0, 0, self.windowskin, rect)
      sprite.y = self.y + (@height - bh) + spacing * 2
      sprite.x = i == 0 ? self.x + 2 : self.x + @width - bw
      @arrow_sprites.push(sprite)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    return unless update_focus
    super
    update_keyboard
    sync_window
    return if disposed?
    update_cursor
    update_selection
  end
  #--------------------------------------------------------------------------
  def update_focus
    focus_window if !@focus && Mouse.click?(1) &&  Mouse.collide_sprite?(self)
    wfocus = (GetFocus.call(0) == @hwnd) if @focus
    kill_focus   if !wfocus || (@focus && Mouse.click?(1) && !Mouse.collide_sprite?(self))
    return @focus
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @cursor.dispose
    @arrow_sprites.each {|sprite| sprite.dispose}
    @viewport2.dispose
    super
  end
  #--------------------------------------------------------------------------
  # * Synchorize index with Win32 window
  #--------------------------------------------------------------------------
  def sync_window
    buffer = get_window_text
    return process_limited(buffer) if @strlen > @char_limit
    @lpstr = EasyConv::s2u(buffer)
    terminated = process_ok if @last_len == @strlen
    return if @last_str == @lpstr || terminated
    clear_awaits
    update_contents
  end
  #--------------------------------------------------------------------------
  def get_window_text
    @strlen = (GetWindowTextLength.call(@hwnd) + 1) | 0
    buffer  = '\0' * @strlen
    GetWindowText.call(@hwnd, buffer, @strlen)
    return buffer
  end
  #--------------------------------------------------------------------------
  def update_contents
    calc_index_width
    update_index
    refresh
  end
  #--------------------------------------------------------------------------
  def update_index
    @index += @strlen - @last_len
    @last_str = @lpstr
    @last_len = @strlen
  end
  #--------------------------------------------------------------------------
  # * Set Win32 edit window text to in-game text if max out numbercap
  #--------------------------------------------------------------------------
  def process_limited(buffer)
    buffer = buffer[0...@char_limit]
    SetWindowText.call(@hwnd, EasyConv::u2s(@lpstr))
    SendMessage.call(@hwnd, EM_SETSEL, @strlen, @strlen)
  end
  #--------------------------------------------------------------------------
  # * Refresh 
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_code_text(spacing / 2, 0, @lpstr[@display_bot..@display_top])
  end
  #--------------------------------------------------------------------------
  # * Get Char Byte size
  #--------------------------------------------------------------------------
  def index_bsize(index)
    [2, @lpstr[index].bytesize].min rescue 1
  end
  #--------------------------------------------------------------------------
  # * DP the texts width for faster query
  #--------------------------------------------------------------------------
  def calc_index_width
    sum = 0
    @index_width[0] = 0
    for i in 0..@strlen
      sum += item_width * index_bsize(i)
      @index_width[i+1] = sum
    end
  end
  #--------------------------------------------------------------------------
  # * Gets the texts width in range
  #--------------------------------------------------------------------------
  def index_width(start, rear)
    rear, start = start,rear if start > rear
    rear = @strlen - 1 if rear > @strlen - 1
    return @index_width[rear] - @index_width[start]
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    @cursor.visible = (Time.now.sec & 1).to_bool
    unpack_message(SendMessage.call(@hwnd, EM_GETSEL, 0, 0))
    
    clear_awaits if @last_index != @index
    @cursor.show if @last_index != @index
    update_cursor_position
    @last_index = @index
    refresh
  end
  #--------------------------------------------------------------------------
  def update_cursor_position
    ensure_cursor_visible
    update_padding
    offset_x = index_width(@display_bot, @index)
    @cursor.x = self.x + spacing * 2 + offset_x
  end
  #--------------------------------------------------------------------------
  # * Ensure cursor index is visible and auto sctoll
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    @display_top = @display_bot + @display_width - 1
    byte_index = index_width(0, @index) / item_width
    @wchar_num = (index_width(0, @display_bot) - @display_bot * item_width) / item_width
    if byte_index < @display_bot
      @display_bot = byte_index
    elsif byte_index > @display_top + @wchar_num
      @display_bot = byte_index - @display_width - @wchar_num + 1
    end
    @display_top = @display_bot + @display_width - 1
  end
  #--------------------------------------------------------------------------
  def update_padding
    return unless @display_bot
    @display_bot > 0 ? @arrow_sprites[0].show : @arrow_sprites[0].hide
    @display_top < @strlen - @wchar_num - 1 ? @arrow_sprites[1].show : @arrow_sprites[1].hide
  end
  #--------------------------------------------------------------------------
  def unpack_message(msg)
    bt = msg.to_s(2)
    @select_start = bt[[bt.length - 16, 0].max...bt.length].to_i(2)
    @select_end   = msg >> 16
    if @select_start == @select_end
      @index      = @select_end
      @select_ori = @select_end if Input.press?(:kSHIFT)
    else
      @index = @select_start < @select_ori ? @select_start : @select_end
    end
  end
  #--------------------------------------------------------------------------
  # * Return text
  #--------------------------------------------------------------------------
  def text
    @lpstr
  end
  #--------------------------------------------------------------------------
  def update_keyboard
    return if Input.trigger?(:kENTER) || Input.trigger?(:kESC)
    return unless Keyboard.press_any_key || Input.trigger?(:kDEL) || Input.trigger?(:kBACKSPACE)
    @keyboard_action.push(true)
    clear_awaits if Input.trigger?(:kDEL) || Input.trigger?(:kBACKSPACE)
    clear_awaits if @last_select != hash_select
    @last_select = hash_select
  end
  #--------------------------------------------------------------------------
  def update_selection
    return cursor_rect.empty if @select_start == @select_end
    width = index_width(@select_end, @select_start)
    cx = @select_start > @display_bot ? index_width(@select_start, @display_bot) : 0
    cursor_rect.set(cx, 0, width, 24)
  end
  #--------------------------------------------------------------------------
  def focus_window
    SetFocus.call(@hwnd)
    @focus = true
  end
  #--------------------------------------------------------------------------
  def kill_focus
    SetFocus.call(Hwnd)
    @focus = false
    @cursor.visible = false
  end
  #--------------------------------------------------------------------------
  def clear_awaits
    @keyboard_action.clear
    @enter_cnt = 0
  end
  #--------------------------------------------------------------------------
  def hash_select
    @select_start * 1000 + @select_end
  end
  #--------------------------------------------------------------------------
  def process_ok
    @enter_cnt += 1 if Input.trigger?(:kENTER)
    return if !@keyboard_action.empty? && @enter_cnt < 3
    if Input.trigger?(:kENTER)
      return process_terminate
    elsif Input.trigger?(:kESC)
      @lpstr = ""
      return process_terminate
    end
    return false
  end
  #--------------------------------------------------------------------------
  def process_terminate
    kill_focus
    dispose
    debug_print "String received from win32 window: ", @lpstr
    @enter_cnt = 0
    SceneManager.send_input(@lpstr)
    return true
  end
end
