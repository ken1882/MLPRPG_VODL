#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  This module loads graphics, creates bitmap objects, and retains them.
# To speed up load times and conserve memory, this module holds the
# created bitmap object in the internal hash, allowing the program to
# return preexisting objects when the same bitmap is requested again.
#==============================================================================
module Cache
  
  # Sprites cache
  @cache_sprite = {}
  #--------------------------------------------------------------------------
  # * Get UI Graphic
  #--------------------------------------------------------------------------
  def self.UI(filename)
    load_bitmap("Graphics/UI/", filename)
  end
end
