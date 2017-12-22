#==============================================================================
# ** Window_MultiCommand
#------------------------------------------------------------------------------
#  This window deals with general command choices with depth level manage 
#  ability.
#==============================================================================
class Window_MultiCommand < Window_Command
  #--------------------------------------------------------------------------
  attr_reader   :category_stack
  attr_reader   :current_category
  attr_reader   :category_tree
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @current_category = :main
    @category_stack   = []
    @category_tree    = {}
    super
  end
  #--------------------------------------------------------------------------
  def current_category
    @current_category
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max(cat = current_category)
    @list[cat].size
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max(cat = current_category)
    @list[cat].size
  end
  #--------------------------------------------------------------------------
  # * Clear Command List
  #--------------------------------------------------------------------------
  def clear_command_list
    @list = {}
    @list[:main] = []
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
  end
  #--------------------------------------------------------------------------
  # * Add Command
  #     name    : Command name
  #     symbol  : Corresponding symbol
  #     enabled : Activation state flag
  #     ext     : Arbitrary extended data
  #--------------------------------------------------------------------------
  def add_command(*args)
    case args.size
    when 1 # Hash initializer
      cat = args[:category]
      @list[cat] = Array.new unless @list[cat]
      content = {
        :name     => args[:name],
        :symbol   => args[:symbol],
        :enabled  => args[:enabled] ? args[:enabled] : true,
        :ext      => args[:ext],
        :help     => args[:help],
      }
      @list[cat].push(content)
    else
      name    = args[0]; symbol = args[1]; 
      enabled = args[2] ? args[2] : true;
      ext     = args[3] ? args[3] : nil;
      help    = args[4] ? args[4] : nil;
      cat     = args[5] ? args[5] : :main;
      @list[cat] = Array.new unless @list[cat]
      @list[cat].push({:name=>name, :symbol=>symbol, :enabled=>enabled, :ext=>ext, :help => help})
    end
  end
  #--------------------------------------------------------------------------
  # * Get Command Name
  #--------------------------------------------------------------------------
  def command_name(index, cat = current_category)
    @list[cat][index][:name]
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Command
  #--------------------------------------------------------------------------
  def command_enabled?(index, cat = current_category)
    @list[cat][index][:enabled]
  end
  #--------------------------------------------------------------------------
  # * Get Command Data of Selection Item
  #--------------------------------------------------------------------------
  def current_data
    index >= 0 ? @list[current_category][index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    current_data ? current_data[:enabled] : false
  end
  #--------------------------------------------------------------------------
  # * Get Symbol of Selection Item
  #--------------------------------------------------------------------------
  def current_symbol
    current_data ? current_data[:symbol] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Extended Data of Selected Item
  #--------------------------------------------------------------------------
  def current_ext
    current_data ? current_data[:ext] : nil
  end
  #--------------------------------------------------------------------------
  # * Move Cursor to Command with Specified Symbol
  #--------------------------------------------------------------------------
  def select_symbol(symbol, cat = current_category)
    @list[cat].each_index {|i| select(i) if @list[cat][i][:symbol] == symbol }
  end
  #--------------------------------------------------------------------------
  # * Move Cursor to Command with Specified Extended Data
  #--------------------------------------------------------------------------
  def select_ext(ext, cat = current_category)
    @list[cat].each_index {|i| select(i) if @list[cat][i][:ext] == ext }
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color, command_enabled?(index))
    draw_text(item_rect_for_text(index), command_name(index), alignment)
  end
  #--------------------------------------------------------------------------
  # * Call Cancel Handler
  #--------------------------------------------------------------------------
  def call_cancel_handler
    return call_handler(:cancel) if @current_category == :main
    return return_top_category
  end
  #--------------------------------------------------------------------------
  def set_category(cat)
    @category_stack.push(@current_category)
    @current_category = cat
    refresh_item
  end
  #--------------------------------------------------------------------------
  def return_top_category
    set_category(@category_stack.pop)
  end
  #--------------------------------------------------------------------------
  def link_category(parent, child)
    @category_tree[parent] = child
  end
  #--------------------------------------------------------------------------
  def refresh
    @current_category = :main
    @category_stack   = []
    super
  end
  #--------------------------------------------------------------------------
  def refresh_item
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Call OK Handler
  #--------------------------------------------------------------------------
  def call_ok_handler
    if handle?(current_symbol)
      call_handler(current_symbol)
    elsif @category_tree[parent]
      set_category(@category_tree[parent])
    else
      activate
    end # last work: multi cmd window
  end
  #--------------------------------------------------------------------------
end
