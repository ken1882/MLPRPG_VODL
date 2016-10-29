#==============================================================================
# * NoMethodError
# -----------------------------------------------------------------------------
# Raised when a method is called on a receiver which doesn't have it defined
# and also fails to respond with method_missing.
#==============================================================================
class NoMethodError
  #----------------------------------------------------------------------------
  # *) Object initialization
  #----------------------------------------------------------------------------
  alias initialize_dnd initialize
  def initialize(message, name, *args)
    caller.each do |msg|
      puts "#{msg}"
    end
    
    puts "No Method!"
    initialize_dnd(message, name, *args)
  end
  
end
