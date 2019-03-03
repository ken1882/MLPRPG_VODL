#==============================================================================
module Graphics
  #-----------------------------------------------------------------------------
  # * Alias Method: Transition
  #-----------------------------------------------------------------------------
  class << self; alias transition_dnd transition; end
  def self.transition(duration = 10, filename = "", vague = 40)
    puts SPLIT_LINE
    debug_print "Graphics Transition"
    @transitioning = true
    transition_dnd(duration, filename, vague)
    @transitioning = false
    debug_print "Transition Successful"
  end
  #-----------------------------------------------------------------------------
  def self.transitioning?
    return @transitioning
  end
  #-----------------------------------------------------------------------------
  def self.center_width(cx)
    return [(width  - cx) / 2, 0].max
  end
  #-----------------------------------------------------------------------------
  def self.center_height(cy)
    return [(height - cy) / 2, 0].max
  end
  #-----------------------------------------------------------------------------
end
