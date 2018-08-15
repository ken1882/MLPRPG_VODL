#==============================================================================
# ** Sprite_TacticCursor
#------------------------------------------------------------------------------
#  Cursor that display the tactic select
#==============================================================================
class Sprite_TacticCursor < Sprite_Base
  #----------------------------------------------------------------------------
  attr_accessor :instance
  #----------------------------------------------------------------------------
  # *) Object initialization
  #----------------------------------------------------------------------------
  def initialize(viewport = nil, instance)
    super(viewport)
    @instance = instance
    create_bitmap
    self.ox = self.bitmap.width / 2
    self.oy = self.bitmap.height
    self.z  = PONY::SpriteDepth::Table[:character]
    update
    hide
  end
  #----------------------------------------------------------------------------
  # *) Update
  #----------------------------------------------------------------------------
  def update
    self.x = (@instance.screen_x - 16).to_i
    self.y = (@instance.screen_y - 16).to_i
  end
  #----------------------------------------------------------------------------
  # *) Create bitmap
  #----------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Bitmap.new(32,32)
    #upper left corner
    self.bitmap.fill_rect(0,0,15,15,Color.new(0,0,0,255))
    self.bitmap.fill_rect(1,1,13,13,Color.new(255,255,255,255))
    self.bitmap.fill_rect(4,4,10,10,Color.new(0,0,0,255))
    self.bitmap.fill_rect(5,5,13,13,Color.new(0,0,0,0))
    #lower right corner
    self.bitmap.fill_rect(18,18,15,15,Color.new(0,0,0,255))
    self.bitmap.fill_rect(19,19,12,12,Color.new(255,255,255,255))
    self.bitmap.fill_rect(18,18,10,10,Color.new(0,0,0,255))
    self.bitmap.fill_rect(18,18,9,9,Color.new(0,0,0,0))
    #lower left corner
    self.bitmap.fill_rect(0,18,15,15,Color.new(0,0,0,255))
    self.bitmap.fill_rect(1,19,13,12,Color.new(255,255,255,255))
    self.bitmap.fill_rect(4,18,10,10,Color.new(0,0,0,255))
    self.bitmap.fill_rect(5,18,10,9,Color.new(0,0,0,0))
    #upper right corner
    self.bitmap.fill_rect(18,0,15,15,Color.new(0,0,0,255))
    self.bitmap.fill_rect(19,1,12,13,Color.new(255,255,255,255))
    self.bitmap.fill_rect(18,4,10,10,Color.new(0,0,0,255))
    self.bitmap.fill_rect(18,5,9,10,Color.new(0,0,0,0))
  end
  #----------------------------------------------------------------------------
  def character; nil; end
  
end
