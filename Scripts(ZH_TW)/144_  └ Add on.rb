#==============================================================================
# ** Window_Command
#------------------------------------------------------------------------------
#  This window deals with general command choices.
#==============================================================================
class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  # * Add Command
  #     name    : Command name
  #     symbol  : Corresponding symbol
  #     enabled : Activation state flag
  #     ext     : Arbitrary extended data
  #--------------------------------------------------------------------------
  def add_command(name, symbol, enabled = true, ext = nil, help = nil)
    @list.push({:name=>name, :symbol=>symbol, :enabled=>enabled, :ext=>ext, :help => help})
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    # got to tag: modified - ICON
  end
end
