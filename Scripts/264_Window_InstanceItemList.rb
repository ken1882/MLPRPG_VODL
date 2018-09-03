#==============================================================================
# ** Window_InstanceItemList
#------------------------------------------------------------------------------
#  Just like item list, but return the selected item after ok processed
#==============================================================================
# tag: command ( Instance Item List
class Window_InstanceItemList < Window_ItemList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @return_item = nil
  end
  #--------------------------------------------------------------------------
  def update
    super
    return process_terminate if @return_item && !active?
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return !@data[index].nil?
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
  end # def make item list
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
  end
  #--------------------------------------------------------------------------
  def include?(item)
    return true
  end
  #--------------------------------------------------------------------------
  def call_ok_handler
    super
    @return_item = @data[index]
  end
  #--------------------------------------------------------------------------
  def call_cancel_handler
    super
    @return_item = :nil
  end
  #--------------------------------------------------------------------------
  def process_terminate
    begin
      re = @return_item.dup
    rescue Exception
      re = @return_item
    end
    @return_item = nil
    debug_print "Instance Item List return: #{re}"
    return re
  end
end
