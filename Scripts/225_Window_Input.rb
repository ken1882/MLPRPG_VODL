
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
  EM_SETSEL       = 0xb1
  EM_GETSEL       = 0xb0
  #--------------------------------------------------------------------------
  AutoScroll      = false # do not turn on this, wip
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :hwnd
  attr_accessor :index
  attr_accessor :focus
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 0, width = 480, height = 24, focus = true)
    super(x, y, width, fitting_height(1))
    self.windowskin = Cache.system(WindowSkin::InputBox)
    wstyle  = WS_CHILD
    wstyle |= ES_AUTOSCROLL if AutoScroll
    @hwnd = CreateWindowEx.call(1, "Edit", "", wstyle,
                                x, y, width, height, Hwnd, 0, 
                                GetModuleHandle.call(nil), 0)
    #-----------------------------------------------------------------------
    # > init vars
    @viewport        = SceneManager.viewport
    @width           = width
    @height          = height
    @dispaly_width   = (@width - spacing * 2) / item_width
    @char_limit      = AutoScroll ? 256 : @dispaly_width
    @last_str        = ""
    @last_len        = 0
    @last_index      = 0
    @last_select     = 0
    @index           = 0
    @select_start    = 0
    @select_end      = 0
    @select_ori      = 0
    @enter_cnt       = 0
    @index_width     = []
    @keyboard_action = []
    @arrow_sprites   = []
    @focus           = true
    create_cursor(x, y)
    create_arrows        if AutoScroll
    SetFocus.call(@hwnd) if focus
    self.z = 200
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    return if disposed?
    update_focus
    return unless @focus
    super
    update_keyboard
    sync_window
    return if disposed?
    update_cursor
    update_selection
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
  # * Create Cursor Sprite 
  #--------------------------------------------------------------------------
  def create_cursor(cx, cy)
    @cursor = Sprite.new(@viewport)
    @cursor.bitmap = Bitmap.new(4, item_width * 2)
    @cursor.bitmap.fill_rect(0, 0, 1, item_width * 2, DND::COLOR::White)
    @cursor.x, @cursor.y = cx, cy + spacing * 3
  end
  #--------------------------------------------------------------------------
  def create_arrows
    bx, by = 80, 16
    bw, bh = 16, 8
    2.times do |i|
      bitmap = Bitmap.new(bw, bh)
      @arrpw_spries.push(bitmap)
      sx     = (i == 0 ? bx : (bx + bw + bh)) # 0 for left, 1 for right arrow
      rect   = Rect.new(bx, by + bh, bw, bh)
      bitmap.blt(0, 0, @windowskin, rect)
    end
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @cursor.dispose
    @arrow_sprites.each {|sprite| sprite.dispose}
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
    draw_code_text(spacing / 2, 0, @lpstr)
  end
  #--------------------------------------------------------------------------
  # * Get Char Byte size
  #--------------------------------------------------------------------------
  def index_bsize(index)
    [2, @lpstr[index].bytesize].min rescue 1
  end
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
  def index_width(rear, start = 0)
    rear, start = start,rear if start > rear
    return @index_width[rear] - @index_width[start]
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    unpack_message(SendMessage.call(@hwnd, EM_GETSEL, 0, 0))
    @cursor.visible = (Time.now.sec & 1).to_bool
    clear_awaits if @last_index != @index
    @cursor.x = self.x + spacing * 3 + index_width(@index)
    @last_index = @index
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
  def update_focus
    focus_window if !@focus && Mouse.click?(1) &&  Mouse.collide_sprite?(self)
    wfocus = (GetFocus.call(0) == @hwnd) if @focus
    kill_focus   if !wfocus || (@focus && Mouse.click?(1) && !Mouse.collide_sprite?(self))
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
    cursor_rect.set(index_width(@select_start), 0, width, 24)
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
