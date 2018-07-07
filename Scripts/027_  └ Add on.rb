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
  @sprite_linker      = []
  @undisposed_sprites = []
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
  def self.link_sprite(sprite)
    @sprite_linker << sprite
  end
  #--------------------------------------------------------------------------
  def self.unchain_linker(sprite)
    @sprite_linker.delete(sprite)
  end
  #--------------------------------------------------------------------------
  def self.clear_sprite
    @undisposed_sprites.clear
    @sprite_linker.each do |sp|
      if sp.disposed?
        @sprite_linker.delete(sp)
      else
        debug_print("Warning: undisposed sprite #{sp}")
        @undisposed_sprites << sp
      end
    end
  end
  #--------------------------------------------------------------------------
  def self.undisposed_sprites
    @undisposed_sprites.select!{|sp| !sp.disposed?}
    return @undisposed_sprites
  end
  #--------------------------------------------------------------------------
  # * Free all cached sprites
  #--------------------------------------------------------------------------
  def self.release
    @iconset.dispose
    @iconset = nil
  end
end
