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
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @current_category = :main
    @category_stack   = []
    super
  end
  #--------------------------------------------------------------------------
  def current_category
    @current_category
  end
  #--------------------------------------------------------------------------
  def entry_categories
    [:main]
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
  #     help    : Help window when hit tab
  #--------------------------------------------------------------------------
  #   add_command(name, symbol, enabled = true, ext = nil, help = nil, cat = main, child = nil)
  def add_command(*args)
    case args.size
    when 1 # Hash initializer
      args = args[0]
      cat = args[:category] ? args[:category] : :main
      content = {
        :name     => args[:name],
        :symbol   => args[:symbol],
        :enabled  => args[:enabled].nil? ? true : args[:enabled],
        :ext      => args[:ext],
        :help     => args[:help],
        :child    => args[:child],
      }
    else
      name    = args[0]; symbol = args[1]; 
      enabled = args[2].nil? ? true  : args[2];
      ext     = args[3]
      help    = args[4]
      cat     = args[5].nil? ? :main : args[5];
      child   = args[6]
      content = {:name=>name, :symbol=>symbol, :enabled => enabled,
                        :ext=>ext, :help => help, :child => child}
    end
    (@list[cat] ||= []) << content
  end
  #--------------------------------------------------------------------------
  # * Get Command Name
  #--------------------------------------------------------------------------
  def command_name(index, cat = current_category)
    @list[cat][index][:name]
  end
  #--------------------------------------------------------------------------
  # * Get Command Help
  #--------------------------------------------------------------------------
  def command_help(index, cat = current_category)
    return @list[cat][index][:help]
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
  # * Call Cancel Handler
  #--------------------------------------------------------------------------
  def call_cancel_handler
    return call_handler(:cancel) if entry_categories.include?(@current_category)
    return return_top_category
  end
  #--------------------------------------------------------------------------
  def set_category(cat)
    @category_stack.push(@current_category)
    @current_category = cat
    refresh_item
    activate
  end
  #--------------------------------------------------------------------------
  def return_top_category
    set_category(@category_stack.pop)
  end
  #--------------------------------------------------------------------------
  def refresh
    @current_category = :main
    @category_stack   = []
    super
    set_default_handlers
  end
  #--------------------------------------------------------------------------
  def refresh_item
    contents.clear
    draw_all_items
    select(0)
  end
  #--------------------------------------------------------------------------
  def set_default_handlers
  end
  #--------------------------------------------------------------------------
  # * Call OK Handler
  #--------------------------------------------------------------------------
  def call_ok_handler
    return set_category(current_data[:child]) if current_data[:child]
    return super
  end
  #--------------------------------------------------------------------------
end
