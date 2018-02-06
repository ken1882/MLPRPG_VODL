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
  ProjPoolSize  = 20
  #--------------------------------------------------------------------------
  # * Module instance
  #--------------------------------------------------------------------------
  @cache_sprite     = []    # Sprites cache
  @cache_projectile = []    # Map Projectiles cache
  @projectile_pool  = []    # Projectile Pool for Game_Projectile
  #--------------------------------------------------------------------------
  def self.init
    @iconset = system("Iconset")
    self.allocate_pools
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
  # * Store projectiles
  #--------------------------------------------------------------------------
  def self.store_projectile(projs)
    debug_print "Projectile stored (#{projs.size})"
    @cache_projectile = projs.dup
  end
  #--------------------------------------------------------------------------
  # * Retrieve stored cache
  #--------------------------------------------------------------------------
  def self.projectile
    re = @cache_projectile.dup
    @cache_projectile.clear
    return re
  end
  #--------------------------------------------------------------------------
  def self.clear_projectiles
    debug_print "Clear sprite/bitmap cache (#{@cache_sprite.size})"
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
  def self.iconset
    @iconset
  end
  #--------------------------------------------------------------------------
  def self.allocate_pools
    ProjPoolSize.times{|i| self.allocate_proj}
  end
  #--------------------------------------------------------------------------
  def self.allocate_proj
    proj = Game_Projectile.allocate
    proj.deactivate
    @projectile_pool << proj
  end
  #--------------------------------------------------------------------------
  def self.get_idle_proj
    re = @projectile_pool.find{|proj| !proj.active?}
    re
  end
  #--------------------------------------------------------------------------
  # * Free all cached sprites
  #--------------------------------------------------------------------------
  def self.release
    @iconset.dispose
    @iconset = nil
  end
end
