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
  ES_AUTOHSCROLL  = 0x00000080
  ES_NUMBER       = 0x00002000
  ES_MULTILINE    = 0x00000004
  EM_SETSEL       = 0xb1
  EM_GETSEL       = 0xb0
  
  AutoScroll_ChatLimit = 256
  #--------------------------------------------------------------------------
  Number_Full = {
    '０' => '0',
    '１' => '1',
    '２' => '2',
    '３' => '3',
    '４' => '4',
    '５' => '5',
    '６' => '6',
    '７' => '7',
    '８' => '8',
    '９' => '9',
  }
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :hwnd
  attr_accessor :index
  attr_accessor :focus
  #--------------------------------------------------------------------------
  def get_windowstyle(args)
    ws  = WS_CHILD
    #ws |= ES_MULTILINE
    ws |= WS_POPUP        if args[:popup]
    ws |= WS_DISABLED     if args[:visible]
    ws |= ES_NUMBER       if args[:number]
    ws |= ES_AUTOHSCROLL  if args[:autoscroll]
    return ws
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 0, width = Graphics.width - 40, attributes = {})
    #-----------------------------------------------------------------------
    # > init vars
    @window_width    = width
    @viewport        = SceneManager.viewport
    @char_limit      = attributes[:autoscroll] ? AutoScroll_ChatLimit : @display_width / item_width
    @char_limit      = attributes[:limit] if attributes[:limit]
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
    @number_only     = attributes[:number]
    @entered         = false
    @need_refresh    = true
    @display_bot_index = 0
    @display_top_index = 0
    #-----------------------------------------------------------------------
    super(x, y, width, window_height)
    self.windowskin = Cache.system(WindowSkin::InputBox)
    wstyle  = get_windowstyle(attributes)
    @hwnd = CreateWindowEx.call(1, "Edit", "", wstyle,
                                x, y, width, height, Hwnd, 0, 
                                GetModuleHandle.call(nil), 0)
    #-----------------------------------------------------------------------
    self.ox = 0
    self.z  = @viewport.z
    @display_width = contents.width - spacing * 2
    #-----------------------------------------------------------------------
    create_sprites
    create_background if attributes[:dim_background]
    draw_title(attributes[:title])
    SetFocus.call(@hwnd) if focus
  end
  #--------------------------------------------------------------------------
  def spacing
    return 4
  end
  #--------------------------------------------------------------------------
  def window_height
    line_height * 2
  end
  #--------------------------------------------------------------------------
  def window_width
    @window_width
  end
  #--------------------------------------------------------------------------
  def item_width
    Font.default_size / 2
  end
  #--------------------------------------------------------------------------
  def create_sprites
    self.arrows_visible = false
    create_second_viewport
    create_cursor(x, y)
    create_arrows
    create_text_sprite
  end
  #--------------------------------------------------------------------------
  def create_second_viewport
    @viewport2 = Viewport.new
    @viewport2.z = 300
  end
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new(@viewport)
    @background_sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @background_sprite.opacity = 128
    @background_sprite.z = self.z - 1
    color = Color.new(16,16,16)
    @background_sprite.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, color)
  end
  #--------------------------------------------------------------------------
  def create_text_sprite
    @text_sprite = Sprite.new(@viewport2)
    @text_sprite.bitmap = Bitmap.new(Graphics.width, line_height * 2)
    @text_sprite.x = 0
    @text_sprite.y = self.y - line_height
    @text_sprite.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # * Create Cursor Sprite
  #--------------------------------------------------------------------------
  def create_cursor(cx, cy)
    @cursor = Sprite.new(@viewport2)
    @cursor.bitmap = Bitmap.new(4, item_width * 2)
    @cursor.bitmap.fill_rect(0, 0, 1, item_width * 2, DND::COLOR::White)
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
      sprite.y = self.y + (window_height - bh) - spacing * 4 
      sprite.x = i == 0 ? self.x + 2 : self.x + window_width - bw
      @arrow_sprites.push(sprite.hide)
    end
  end
  #--------------------------------------------------------------------------
  def draw_title(title)
    return unless title
    cw = [text_width_for_rect(title), Graphics.width].min
    cx = [[(Graphics.width - cw) / 2, 0].max, Graphics.width].min
    rect = Rect.new(cx, 0, cw, line_height)
    @text_sprite.bitmap.draw_text(rect, title)
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
    return if @index > @char_limit || (@index_width.size != @strlen+2)
    update_cursor
    update_selection
  end
  #--------------------------------------------------------------------------
  def update_focus
    focus_window if active? || !@focus && Mouse.click?(1) &&  Mouse.collide_sprite?(self)
    wfocus = (GetFocus.call(0) == @hwnd) if @focus
    kill_focus   if !wfocus || (@focus && Mouse.click?(1) && !Mouse.collide_sprite?(self))
    return @focus
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @background_sprite.dispose if @background_sprite
    @text_sprite.dispose
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
    @lpstr = EasyConv::s2u(buffer)
    return process_limited if @strlen > @char_limit + 1
    terminated = process_ok if @last_len == @strlen
    return if @last_str == @lpstr || terminated
    @need_refresh = true
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
    @last_len = @strlen
    @last_str = @lpstr
  end
  #--------------------------------------------------------------------------
  # * Set Win32 edit window text to in-game text if max out numbercap
  #--------------------------------------------------------------------------
  def process_limited
    @lpstr  = @lpstr[0...@char_limit]
    @strlen = @char_limit
    @index  = @char_limit
    SetWindowText.call(@hwnd, EasyConv::u2s(@lpstr))
    SendMessage.call(@hwnd, EM_SETSEL, @strlen, @strlen)
  end
  #--------------------------------------------------------------------------
  # * Refresh 
  #--------------------------------------------------------------------------
  def refresh
    return unless @need_refresh
    @need_refresh = false
    contents.clear
    rect = Rect.new(spacing / 2, 0, @index_width[@strlen], line_height)
    rect.width += contents.font.size
    draw_text(rect, @lpstr[@display_bot_index..@display_top_index])
  end
  #--------------------------------------------------------------------------
  # * DP the texts width for faster query
  #--------------------------------------------------------------------------
  def calc_index_width
    @index_width = [0]
    sum = 0
    for i in 0..@strlen
      sum += self.contents.text_size(@lpstr[i]).width
      @index_width[i+1] = sum
      @index = [@index, i+1].max
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
    offset_x = index_width(@display_bot_index, @index)
    @cursor.x = self.x + spacing * 2 + offset_x + 2
  end
  #--------------------------------------------------------------------------
  def get_display_selection_bot
    offset = @display_width
    cur    = @index
    while offset > 0 && cur > 0
      width   = @index_width[cur] - @index_width[cur - 1]
      offset -= width
      return cur + 1 if offset < 0
      cur    -= 1
    end
    return cur
  end
  #--------------------------------------------------------------------------
  def get_display_selection_top
    offset = @display_width
    cur    = @index
    while offset > 0 && cur < @strlen
      width   = @index_width[cur + 1] - @index_width[cur]
      offset -= width
      cur    += 1
    end
    return cur
  end
  #--------------------------------------------------------------------------
  # * Ensure cursor index is visible and auto sctoll
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    next_cursor_x = @index_width[@index]
    return if next_cursor_x.nil?
    
    if next_cursor_x > @display_top
      @display_bot = next_cursor_x - @display_width
      @display_bot_index = get_display_selection_bot
      @display_top_index = @index
    elsif next_cursor_x < @display_bot
      @display_bot = next_cursor_x
      @display_bot_index = @index
      @display_top_index = get_display_selection_top
    else
      @display_top_index = [@display_top_index, @index].max
      @display_bot_index = [@display_bot_index, 0].max
    end
    @display_top = @display_bot + @display_width
  end
  #--------------------------------------------------------------------------
  def update_padding
    return unless @display_width && @index_width[@strlen]
    
    @display_bot > 0 ? @arrow_sprites[0].show : @arrow_sprites[0].hide
    @display_top < @index_width[@strlen] ? @arrow_sprites[1].show : @arrow_sprites[1].hide
  end
  #--------------------------------------------------------------------------
  def unpack_message(msg)
    bt = msg.to_s(2)
    @select_start = bt[[bt.length - 16, 0].max...bt.length].to_i(2)
    @select_end   = msg >> 16
    if @select_start == @select_end
      @need_refresh = true if @index != @select_end
      @index      = @select_end
      @select_ori = @select_end if Input.press?(:kSHIFT)
    else
      @need_refresh = true if @index != @select_end || @index != @select_end
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
    puts "#{[@select_end, @select_start]}"
    if @select_end > @select_start && @select_start < @display_bot_index
      width = [index_width(@select_end, @display_bot_index) + 2, contents.width].min
    else
      width = [index_width(@select_end, @select_start) + 2, contents.width].min
    end
    
    if @select_start > @display_bot_index
      cx  = index_width(@select_start, @display_bot_index)
    else
      cx  = 0
    end
    cursor_rect.set(cx, 0, width, 24)
  end
  #--------------------------------------------------------------------------
  def focus_window
    activate
    SetFocus.call(@hwnd)
    @focus = true
  end
  #--------------------------------------------------------------------------
  def kill_focus
    deactivate
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
    @enter_cnt += 1 if Input.trigger?(:kENTER) || Input.trigger?(:kESC)
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
  def replace_chars
    @lpstr.gsub!(/[０１２３４５６７８９]/, Number_Full)
    @lpstr.gsub!(/[^0123456789]/, '') if @number_only
  end
  #--------------------------------------------------------------------------
  def process_terminate
    replace_chars
    kill_focus
    dispose
    debug_print "String received from win32 window: ", @lpstr
    @enter_cnt = 0
    SceneManager.send_input(@lpstr)
    SceneManager.scene.heatup_button(5)
    return true
  end
end
