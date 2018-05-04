#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  This module loads graphics, creates bitmap objects, and retains them.
# To speed up load times and conserve memory, this module holds the
# created bitmap object in the internal hash, allowing the program to
# return preexisting objects when the same bitmap is requested again.
#==============================================================================
module Cache
  #--------------------------------------------------------------------------
  # * Module instance
  #--------------------------------------------------------------------------
  
  #--------------------------------------------------------------------------
  def self.init
    @iconset = system("Iconset")
    @target  = Popups("targeted")
  end
  #--------------------------------------------------------------------------
  def self.Popups(filename)
    load_bitmap("Graphics/Popups/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get UI Graphic
  #--------------------------------------------------------------------------
  def self.UI(filename)
    load_bitmap("Graphics/UI/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Arms Graphic
  #--------------------------------------------------------------------------
  def self.Arms(filename)
    load_bitmap("Graphics/Arms/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get BG Graphic
  #--------------------------------------------------------------------------
  def self.background(filename)
    load_bitmap("Graphics/Background/", filename)
  end
  #--------------------------------------------------------------------------
  def self.tilemap(filename)
    load_bitmap("Graphics/Tilemap/", filename)
  end
  #--------------------------------------------------------------------------
  def self.iconset
    @iconset
  end
  #--------------------------------------------------------------------------
  def self.target_sprite
    @target
  end
  #--------------------------------------------------------------------------
  # * Free all cached sprites
  #--------------------------------------------------------------------------
  def self.release
    @iconset.dispose
    @iconset = nil
  end
end
