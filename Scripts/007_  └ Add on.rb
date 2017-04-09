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
  @cache_sprite     = {}    # Sprites cache
  @cache_projectile = []    # Map Projectiles cache
  @bitmaps          = []
  #--------------------------------------------------------------------------
  # * Get UI Graphic
  #--------------------------------------------------------------------------
  def self.UI(filename)
    load_bitmap("Graphics/UI/", filename)
  end
  #--------------------------------------------------------------------------
  # * Store projectiles
  #--------------------------------------------------------------------------
  def self.store_projectile(projs)
    @cache_projectile = projs.dup
  end
  #--------------------------------------------------------------------------
  # * Retrieve stored cahce
  #--------------------------------------------------------------------------
  def self.projectile
    re = @cache_projectile.dup
    @cache_projectile.clear
    return re
  end
  #--------------------------------------------------------------------------
  def self.clear_projectiles
    puts '[Debug]: Clear projectiles/bitmap cahce'
    @cache_projectile.clear
    @bitmaps.each do |bitmap|
      if bitmap.disposed?
        bitmap.freeze
        bitmap = nil
        @bitmaps.delete(bitmap)
      end
    end
  end
  #--------------------------------------------------------------------------
  def self.link_bitmap(bitmap)
    @bitmaps.push(bitmap)
  end
end
