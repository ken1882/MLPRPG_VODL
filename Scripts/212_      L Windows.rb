
# Inheriting from Window_Base instead of Window_Selectable, since I'd have to
#  rewrite like half of the code anyways.
class Window_Spellbook < Window_Selectable
  
  def initialize(x, y, height, actor, combat = false)
    super(x, y, window_width, height)
    @vertical = false
    @handler = {}
    
    @oldx = x;
    @oldwidth = window_width;
    @cursor_x = 0;
    @cursor_y = 0;
    
    @infos_window = nil;
    
    @row_max = 0
    @col_max = 0
    @spell_count = 0
    @slot_indexes = [];
    
    @combat = combat
    
    self.windowskin = Cache.system($SPELLBOOK_SKIN)                             #
    self.actor = actor
    update_cursor
  end
  
  def actor=(x)
    return if !x
    
    @actor = x;
    @has_casting = @actor.has_vancian_casting?
    if @has_casting
      @slot_indexes = [];
      @actor.active_spell_slots.each do |spell_level|
        @slot_indexes.push(spell_level.length)
      end
      @col_max = @slot_indexes.max
      @row_max = @slot_indexes.length
      
      @spell_count = @actor.active_spell_slots.inject(0){|sum,o| sum + o.length}
      @index = 0;
    else
      @slot_indexes = [];
      @col_max = 0
      @row_max = 0
      @spell_count = 0
      @index = 0;
    end
    refresh;
  end
  
  
################################################################################
  def current_element()
    level, slot = index_to_spell_tuple
    [level, slot, @actor.active_spell_slots[level][slot]]
  end
  
  # better ordering for other funcs
  def index_to_spell_tuple(n = index)
    x,y = index_to_tuple(n)
    [y,x]
  end
  
  def index_to_tuple(n = index)
    y = 0;
    # TODO: check this code later, because this might have issues
    while(y < @row_max && n >= @slot_indexes[y])
      n -= @slot_indexes[y]
      y += 1
    end
    return [n,y]
  end
  def tuple_to_index(x,y)
    n = x;
    y.times do |i|
      n += @slot_indexes[i]
    end
    n
  end
  def row
    index_to_tuple(index)[1]
  end
  def row_width(n)
    @slot_indexes[n]
  end
  
################################################################################
  
  
  def refresh
    contents.clear
    draw_spellbook
  end
  
  def update
    process_handling
    process_cursor_move
  end
  
  def process_handling
    return unless open? && active
    val = super
    return val if val
    return process_delete if Input.trigger?(:A)  
  end
  
################################################################################
  def window_width
    2 * Graphics.width / 5;
  end
  def row_max
    @row_max || 1
  end
  def col_max
    @col_max || 1
  end
  def spacing
    6
  end
  def item_max
    @spell_count || 0
  end
  def item_width
    ICON_SIZE
  end
  def item_height
    ICON_SIZE
  end
  
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    x,y = index_to_tuple(index)
    rect.x = 20 + x * (item_width + spacing)
    rect.y = 30 + y * (item_height + spacing)
    rect
  end
  
################################################################################
  
  def current_item_enabled?
    return false unless @has_casting
    
    x,y = index_to_tuple()
    spell_slot = @actor.active_spell_slots[y][x]
    
    if !@combat
      return !(spell_slot[:spell_id] && !spell_slot[:expended])# || spell_slot[:replaceable]
    else
      # also ensure that it can be cast normally.
      return spell_slot[:spell_id] && !spell_slot[:expended] \
              && @actor.usable?($data_skills[spell_slot[:spell_id]]);
    end
  end
  
  def cursor_movable?
    active && open?# && !@cursor_fix && !@cursor_all && item_max > 0
  end
  
################################################################################
  
  LINE_COLOUR = Color.new(255,255,255);
  ICON_SIZE = 24;
  FULL_SPACING = 30;
  MAX_ROWS = 7;
  
  EMPTY_SLOT_BORDER_COLOUR = Color.new(255,255,255);
  EMPTY_SLOT_CENTRE_COLOUR = Color.new(128,128,128,40);
  RESTRICTED_SLOT_BORDER_COLOUR = Color.new(255,128,128);
  RESTRICTED_SLOT_CENTRE_COLOUR = Color.new(128,64,64,40);
  REPLACEABLE_COLOUR = Color.new(0,255,0,128);
  
  def draw_empty_spellbook
    draw_text(0,0,self.width,24,@actor.name);
    
    draw_text(20,30,self.width,24,"N/A.");
  end
  
  # This will probably be good as a generic-ish function.
  def draw_spellbook
    return unless @actor
    return draw_empty_spellbook unless @has_casting
    
    draw_text(0,0,self.width,24,@actor.name);
    
    cx = 20;
    cy = 30
    
    # Draw spell level tiers
    @actor.max_spell_level.times do |i|
      y = cy + FULL_SPACING*i - (FULL_SPACING - ICON_SIZE)/2;
      contents.draw_line(0,y,self.width,y,LINE_COLOUR);
      draw_text(0,y+(FULL_SPACING - ICON_SIZE)/2,100,ICON_SIZE,"#{i+1}");
    end
    
    draw_all_items
  end
  
  def draw_item(index)
    x,y = index_to_tuple(index)
    spell_slot = @actor.active_spell_slots[y][x]
    
    spell_id = spell_slot[:spell_id]
    expended = spell_slot[:expended]
    restrictions = spell_slot[:restrictions]
    replaceable = spell_slot[:replaceable]
    
    rect = item_rect(index)
    
    if(spell_id)then
      draw_icon($data_skills[spell_id].icon_index, 
                rect.x, rect.y, !expended)
    else
      c = EMPTY_SLOT_BORDER_COLOUR;
      ic = EMPTY_SLOT_CENTRE_COLOUR;
      if restrictions
        c = RESTRICTED_SLOT_BORDER_COLOUR
        ic = RESTRICTED_SLOT_CENTRE_COLOUR
      end
      
      contents.fill_rect(rect.x+2, rect.y+2, rect.width-4, rect.height-4, c)
      contents.fill_rect(rect.x+3, rect.y+3, rect.width-6, rect.height-6, ic)
    end
    
    # Draw additional stuff on top to indicate more states.
    if replaceable
      contents.fill_rect(rect.x, rect.y + rect.height - 3, rect.width, 3, 
                         REPLACEABLE_COLOUR)
    end
  end
  
  def draw_all_items
    item_max.times {|i| draw_item(i) }
  end
  
################################################################################
  
  # Someone clicks ENTER at a node.
  def choose_node
    call_handler(:ok)
  end
  
  def cancel_out
    call_handler(:cancel)
  end
  
  def process_delete
    call_handler(:delete)
  end
  
  def select_slot
    call_handler(:select)
  end
  
################################################################################
  
  def move_cursor_y(dy)
    x,y = index_to_tuple
    y += dy
    y = y < 0? 0 : y
    y = y >= row_max ? row_max - 1 : y
    
    width = row_width(y)
    return unless width
    
    x = x >= row_width(y) ? row_width(y) - 1 : x
    x = x < 0? 0 : x
    
    tuple_to_index(x,y)
  end
  
  def cursor_down(wrap = false)
    select(move_cursor_y(1))
  end
  def cursor_up(wrap = false)
    select(move_cursor_y(-1))
  end
  def cursor_right(wrap = false)
    if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
    end
  end
  def cursor_left(wrap = false)
    if col_max >= 2 && (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
    end
  end
    
  def update_cursor
    if @cursor_all
      cursor_rect.set(0,0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0 || !@has_casting
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
    end
  end
  
################################################################################
  def update_help
    return unless @actor
    if !@has_casting
      @help_window.clear
      return
    end
    
    select_slot
    
    level, slot = index_to_spell_tuple
    spell_index = @actor.active_spell_slots[level][slot][:spell_id]
    if(spell_index)then
      @help_window.set_item($data_skills[spell_index])
    else
      @help_window.clear
    end
  end
  
  def update_info
    return unless @actor
    if !@has_casting
      @help_window.clear
      return
    end
    
    level, slot = index_to_spell_tuple
    actual_slot = @actor.active_spell_slots[level][slot]
    spell_index = actual_slot[:spell_id]
    if(spell_index)then
      @infos_window.set_item($data_skills[spell_index])
    else
      @infos_window.set_slot(actual_slot)#.clear
    end
  end
  
  def call_update_help
    update_help if active && @help_window
    update_info if active && @infos_window
  end
  
  def infos_window=(x)
    @infos_window = x;
  end
  
################################################################################
end
class Window_SpellbookSkillList < Window_SkillList
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system($SPELLBOOK_SKIN)
    self.max_level = 1
  end
  
  
  def level
    @level
  end
  def max_level=(x)
    @max_level = x
  end
  def level=(x)
    @level = x
    refresh
  end
  
  def spellbook_help_window=(x)
    @spellbook_help_window = x;
  end
  def current_slot=(x)
    @current_slot = x
  end
  
  
  def update_help
    @help_window.set_item(item)
    if(@spellbook_help_window)
      @spellbook_help_window.set_item(item)
    end
  end
  
  def reset_cursor
    select(0)
  end
  
  def current_item_enabled?
    enable?(@data[index])
  end
  def include?(item)
    item# && item.stype_id == @stype_id
  end
  
  def check_value (a,b)
    
    if a == nil then a = 0 end
    if b == nil then b = 100 end
    if Float(a) <= Float(b) then
      return true
    else 
      return false
    end
  end
  def enable?(item)
    spell_id = $data_skills.index(item); # frustration sets in rapidly
    slots_ok = 
    
    
    @actor \
    && @actor.has_vancian_casting?  \
    && item \
    && check_value(@level , @max_level)  \
    && (!@current_slot || \
         @actor.is_slot_available_for_spell?(@current_slot, spell_id,@row))
    #@actor.usable?(item)
  end
  
  def col_max
    return 1
  end
  
  def include?(item)
    item && item.spell_level(SceneManager.scene.category) == @level
  end
  
  def make_item_list
    @data = @actor ? @actor.skills.select {|skill| include?(skill) } : []
  end
  
  def activate
    super
    opacity = 255;
  end
  
  def deactivate
    super
    cursor_rect.empty
  end
end
class Window_SpellbookInfo < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, line_number = 2)
    super(x, y, window_width, fitting_height(line_number))
    self.windowskin = Cache.system($SPELLBOOK_SKIN)
    @category = nil;
    @actor = nil;
  end
  
  def window_width
    3 * (Graphics.width / 5);
  end
  
  def category=(x)
    @category = x;
  end
  def actor=(x)
    @actor = x;
  end
  
  def clear
    contents.clear
  end
  
  RED_COLOR = Color.new(255,255,255)
  def set_item(item)
    clear
    return if !item
    
    # TODO: Maybe list what school of magic is being applied here.
    # this is kinda hacky right now; do some refactoring later
    y = 5;
    item.schools(@category).each do |school|
      txt = school;
      if VancianCS::TAG_TERMS.has_key?(school)
        txt = VancianCS::TAG_TERMS[school]
      end
      contents.draw_text(5,y,window_width,24,txt);
      y += 24;
    end
    
    enabled = false if @level != @row
    
    # Other pertinent information
    # MP and TP costs, and if we're able to cast it.
    y = 5;
    x = window_width - 60;
    # Draw MP, if applicable
    if item.mp_cost > 0
      if !@actor
        enabled = true;
      else
        enabled = @actor.mp >= item.mp_cost
      end
      
      if enabled
        contents.fill_rect(x, y, 30, 30, mp_cost_color);
      else
        disabled_color = Color.new(
          mp_cost_color.red / 2, mp_cost_color.green / 2, mp_cost_color.blue / 2
        )
        contents.fill_rect(x, y, 30, 30, disabled_color);
      end
      contents.draw_text(x,y,30,30,item.mp_cost,1);
      unless enabled
        contents.draw_line(x-1,y-1,x+31,y+31,RED_COLOR);
        contents.draw_line(x-1,y+31,x+31,y-1,RED_COLOR);
      end
      y += 32;
    end
    if item.tp_cost > 0
      if !@actor
        enabled = true;
      else
        enabled = @actor.tp >= item.tp_cost
      end
      
      if enabled
        contents.fill_rect(x, y, 24, 24, tp_cost_color);
      else
        disabled_color = Color.new(
          tp_cost_color.red / 2, tp_cost_color.green / 2, tp_cost_color.blue / 2
        )
        contents.fill_rect(x, y, 24, 24, disabled_color);
      end
      contents.draw_text(x,y,24,24,item.tp_cost,1);
      unless enabled
        contents.draw_line(x-1,y-1,x+25,y+25,RED_COLOR);
        contents.draw_line(x-1,y+25,x+25,y-1,RED_COLOR);
      end
      y += 26;
    end
    
    
    
    # Write pertinent stuff here
  end
  
  def set_slot(slot)
    clear
    return if !slot
    
    restrictions = slot[:restrictions]
    if !restrictions
      contents.draw_text(5,5,200,24,"No restrictions");
      return
    end
    
    # TODO: Allow specifying a custom string to override all other requirements
    outer_width = window_width
    write_requirement = ->(x, y, chunk) {
      tag, *list = chunk;
      # Can categorize things--but right now, it's a complete mess.
      #contents.draw_text(x,y,outer_width - x, 24, tag == :all ? "ALL OF:" : "ANY OF:");
      #y += 24
      #x += 5;
      list.each do |item|
        next unless item
        if item[0].is_a?(Symbol)
          y = write_requirement.call(x + 10, y, item)
        else
          text = item[1];
          contents.draw_text(x, y, outer_width - x, 24, text);
          y += 24
        end
      end
      y
    }
    write_requirement.call(5, 5, restrictions);
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
  end
end
class Window_SpellLevelBar < Window_HorzCommand
  def window_width
    3 * (Graphics.width / 5);
  end
  def item_width
    32
  end
  def col_max
    return 10
  end 
  def ok_enabled?
    return false
  end
  def command_enabled?(index)
    return @max_level > index if @max_level
    false
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if(@skill_window)then
      if(@skill_window.level != index + 1)
        @skill_window.level = index + 1
        @skill_window.reset_cursor
        @skill_window.refresh
      end
    end
    #@item_window.category = current_symbol if @item_window
  end
  
  def spacing
    return 0
  end
  
  def max_level=(x)
    @max_level = x
    @skill_window.max_level = x
    select(x-1)
    refresh
  end
  
  def level=(x)
    @level = x
    refresh
  end
  
  def level
    return @level if @level
    1
  end
  
  def make_command_list
    make_spell_levels_list(self.level)
  end
  
  def make_spell_levels_list(x)
    x.times do |i|
      add_command("#{i+1}", :some_level)
    end
  end
  
  def skill_window=(skill_window)
    @skill_window = skill_window
    
    update
  end
  
  def deactivate
    super
    cursor_rect.empty
  end
end
