#==============================================================================
# ** Sprite_TacticCursor
#------------------------------------------------------------------------------
#  Cursor that display the tactic select
#==============================================================================
class Sprite_TacticCursor < Sprite
  #----------------------------------------------------------------------------
  attr_accessor :x, :y
  attr_accessor :instance
  #----------------------------------------------------------------------------
  # *) Object initialization
  #----------------------------------------------------------------------------
  def initialize(instance)
    @x, @y = instance.screen_x = instance.screen_y
    @instance = instance
  end
  #----------------------------------------------------------------------------
  # *) Update
  #----------------------------------------------------------------------------
  def update
    
  end
  #----------------------------------------------------------------------------
  # *) Create bitmap
  #----------------------------------------------------------------------------
  def create_bitmap
    bmp = Bitmap.new(32,32)
    #upper left corner
    bmp.fill_rect(0,0,15,15,Color.new(0,0,0,255))
    bmp.fill_rect(1,1,13,13,Color.new(255,255,255,255))
    bmp.fill_rect(4,4,10,10,Color.new(0,0,0,255))
    bmp.fill_rect(5,5,13,13,Color.new(0,0,0,0))
    #lower right corner
    bmp.fill_rect(18,18,15,15,Color.new(0,0,0,255))
    bmp.fill_rect(19,19,12,12,Color.new(255,255,255,255))
    bmp.fill_rect(18,18,10,10,Color.new(0,0,0,255))
    bmp.fill_rect(18,18,9,9,Color.new(0,0,0,0))
    #lower left corner
    bmp.fill_rect(0,18,15,15,Color.new(0,0,0,255))
    bmp.fill_rect(1,19,13,12,Color.new(255,255,255,255))
    bmp.fill_rect(4,18,10,10,Color.new(0,0,0,255))
    bmp.fill_rect(5,18,10,9,Color.new(0,0,0,0))
    #upper right corner
    bmp.fill_rect(18,0,15,15,Color.new(0,0,0,255))
    bmp.fill_rect(19,1,12,13,Color.new(255,255,255,255))
    bmp.fill_rect(18,4,10,10,Color.new(0,0,0,255))
    bmp.fill_rect(18,5,9,10,Color.new(0,0,0,0))
    self.bitmap = bmp
  end
  
end
