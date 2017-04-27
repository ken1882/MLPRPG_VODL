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
  @cache_sprite     = []    # Sprites cache
  @cache_projectile = []    # Map Projectiles cache
  #--------------------------------------------------------------------------
  # * Get UI Graphic
  #--------------------------------------------------------------------------
  def self.UI(filename)
    load_bitmap("Graphics/UI/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get BG Graphic
  #--------------------------------------------------------------------------
  def self.background(filename)
    load_bitmap("Graphics/Background/", filename)
  end
  #--------------------------------------------------------------------------
  # * Store projectiles
  #--------------------------------------------------------------------------
  def self.store_projectile(projs)
    puts "[Debug]: Projectile stored (#{projs.size})"
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
    puts "[Debug]: Clear sprite/bitmap cache (#{@cache_sprite.size})"
    @cache_projectile.clear
    @cache_sprite.each do |bitmap|
      destroy_bitmap(bitmap)
    end
    @cache_sprite.clear
  end
  #--------------------------------------------------------------------------
  def self.link_bitmap(bitmap)
    @cache_sprite.push(bitmap)
  end
  #--------------------------------------------------------------------------
  def self.unchain_bitmap(bitmap)
    @cache_sprite.delete(bitmap)
  end
  #--------------------------------------------------------------------------
  def self.destroy_bitmap(bitmap)
    if bitmap && !bitmap.disposed?
      bitmap.dispose
      bitmap = nil
    end
    @cache_sprite.delete(bitmap)
  end
  #--------------------------------------------------------------------------
end
