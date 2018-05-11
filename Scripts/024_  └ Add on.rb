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
  def self.clear_sprite
    window = SceneManager.scene.debug_window
    return unless window
    @undisposed_sprites.clear
    window.contents.clear
    cx = cy = 0
    my = 0
    @sprite_linker.each do |sp|
      if sp.disposed?
        @sprite_linker.delete(sp)
      else
        debug_print("Warning: undisposed sprite #{sp}")
        rect = Rect.new(0, 0, sp.bitmap.width, sp.bitmap.height)
        if cx + rect.width > window.width
          cx = 0; cy = my;
        end
        cx += rect.width; my = [my, rect.height].max
        window.contents.blt(cx, cy, sp.bitmap, rect)
        @undisposed_sprites << sp.bitmap
      end
    end
  end
  #--------------------------------------------------------------------------
  def self.undisposed_sprites
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
