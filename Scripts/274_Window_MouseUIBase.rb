#==============================================================================
# ** Window_MouseUIBase
#------------------------------------------------------------------------------
#  A totally mouse-oriented UI
#==============================================================================
class Window_MouseUIBase < Window_Base
  #--------------------------------------------------------------------------
  attr_reader :buttons
  attr_reader :currnent_index, :current_group
  attr_reader :index
  attr_reader :groups
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @index_changed = false
    @buttons = []
    @groups  = {}
    @button_symbol_table = {}
    @mouse_hovered = Mouse.collide_sprite?(self)
    unselect
  end
  #-----------------------------------------------------------------------------
  # * Functions that not used
  #-----------------------------------------------------------------------------
  def update_tone; end
  #-----------------------------------------------------------------------------
  def unselect
    select(-1)
  end
  #-----------------------------------------------------------------------------
  def select(sig)
    return select_index(sig.index)  if sig.is_a?(Game_InteractiveButton)
    return select_index(sig)        if sig.is_a?(Numeric)
    return select_symbol(sig)       if sig.is_a?(Symbol)
    debug_print("[Warning]: Invalid datatype for #{self} selection")
  end
  #-----------------------------------------------------------------------------
  def select_index(_index)
    return if _index && _index == @index
    unfocus_item(@index)
    @index = _index
    hilight_item(@index)
    @index_changed = true
  end
  #-----------------------------------------------------------------------------
  def select_symbol(sym)
    select_index(@buttons.find_index{|but| but.symbol == sym}.index)
  end
  #-----------------------------------------------------------------------------
  def hilight_item(item)
    item.focus_sprite
  end
  #-----------------------------------------------------------------------------
  def unfocus_item(item)
    item.unfocus_sprite
  end
  #-----------------------------------------------------------------------------
  def current_item
    @buttons[@index]
  end
  #-----------------------------------------------------------------------------
  def current_group
    @groups[current_item.group] || []
  end
  #-----------------------------------------------------------------------------
  def index_changed?
    @index_changed
  end
  #-----------------------------------------------------------------------------
  def update
    @index_changed = false
    super
    return unless visible?
    update_mouse
    update_keyboard if active?
  end
  #------------------------------------------------------------------------------
  def update_mouse_selection
    @buttons.each_with_index do |but, i|
      next unless but.active? && but.sprite_valid?(but.sprite)
      next unless @index != i && Mouse.collide_sprite?(but.sprite) 
      select_index(i)
    end
  end
  #-----------------------------------------------------------------------------
  def update_mouse
    update_mouse_selection if Mouse.moved?
  end
  #-----------------------------------------------------------------------------
  def update_keyboard
    update_navigate
    update_trigger
  end
  #-----------------------------------------------------------------------------
  def update_navigate
    cur = current_item
    return unless cur && (cur.up rescue false) && (cur.down rescue false) && 
                  (cur.left rescue false) && (cur.right rescue false)
    cur = cur.up    if Input.trigger?(:UP)
    cur = cur.down  if Input.trigger?(:DOWN)
    cur = cur.right if Input.trigger?(:RIGHT)
    cur = cur.left  if Input.trigger?(:LEFT)
    select_index(cur.index)
  end
  #-----------------------------------------------------------------------------
  def update_trigger
    process_trigger(current_item) if button_cooled? && Input.trigger?(:C)
  end
  #-----------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #-----------------------------------------------------------------------------
  def item_max
    @buttons.size
  end
  #-----------------------------------------------------------------------------
  def draw_all_items
    item_max.times do |i|
      draw_item(i)
    end
  end
  #-----------------------------------------------------------------------------
  def draw_item(i)
    @buttons[i].refresh
  end
  #-----------------------------------------------------------------------------
  def process_trigger(button)
    return if button.handler.nil?
    heatup_button
    button.handler.call(get_button_args(button))
  end
  #-----------------------------------------------------------------------------
  def add_button(*args)
    button = Game_InteractiveButton.new(args)
    button.create_sprite
    _index = @buttons.size
    button.index = _index
    @button_symbol_table[button.symbol] = _index
    add_group(button) if button.group
    @buttons.push(button)
  end
  #-----------------------------------------------------------------------------
  def add_group(button)
    (@groups[button.group] ||= []) << button
    button.group_index = @groups[button.group].size - 1
    build_group_nodemap(button)
  end
  #-----------------------------------------------------------------------------
  def build_group_nodemap(button)
    group = @groups[button.group]
    return if group.size == 1
    cur = group.first
    group.each do |node|
      build_nodemap(node, button)
    end
  end
#-----------------------------------------------------------------------------
  def build_nodemap(node, button)
    cur = node
    while true
      # if button is at right of current node
      if button.x > cur.x
        # iterate next if node->right has item and button also at right of it
        if cur.right != cur && cur.right.x < button.x
          cur = cur.right
          next
        # either node->right point node itself or button in at middle of node and node->right
        else
          button.left = cur
          cur.right.left = button
          cur.right, button.right = button, cur.right
          break
        end
      # if button is at left of current node
      elsif button.x < cur.x
        # iterate next if node->left has item and button also at left of it
        if cur.left != cur && cur.left.x > button.x
          cur = cur.left
          next
        # either node->left point node itself or button in at middle of node and node->left
        else
          button.right = cur
          cur.left.right = button
          cur.left, button.left = button, cur.left
          break
        end
      # if button is at up of current node
      elsif button.y > cur.y
        if cur.up != cur && cur.up.y < button.y
          cur = cur.up
          next
        else
          button.up = cur
          cur.up.down = button
          cur.up, button.up = button, cur.up
          break
        end
      # if button is at down of current node
      elsif button.y < cur.y
        if cur.down != cur && cur.down.y > button.y
          cur = cur.down
          next
        else
          button.down = cur
          cur.down.up = button
          cur.down, button.down = button, cur.down
          break
        end
      else
        debug_print("[Warning]: Can't find proper place to insert node #{button} where at (#{button.x}, #{button.y})")
        break
      end
    end # while true
  end
  #-----------------------------------------------------------------------------
  def dispose
    dispose_all_buttons
    super
  end
  #-----------------------------------------------------------------------------
  def dispose_all_buttons
    @buttons.each do |but| but.dispose end
  end
  #-----------------------------------------------------------------------------
  def get_button_args(button)
  end
  #-----------------------------------------------------------------------------
end
