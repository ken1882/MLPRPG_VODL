#==============================================================================
#   * SystemExit
# -----------------------------------------------------------------------------
# Raised by exit to initiate the termination of the script.
#==============================================================================
class SystemExit
  
  alias initialize_dnd initialize
  def initialize(status, msg = nil)
    msgbox("Error!")
    #initialize_dnd(status, msg)
  end
  
end
