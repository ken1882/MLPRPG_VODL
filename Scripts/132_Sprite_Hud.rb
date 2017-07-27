#==============================================================================
# ** Sprite_Hud
#------------------------------------------------------------------------------
#  Sprite for displaying the stat of party members, including hp, ep, states
# and current action.
#==============================================================================
# tag: 1 ( Sprite Hud
class Sprite_Hud < Sprite_Base
  include PONY::Hud
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  Color_HP = DND::COLOR::HitPoint
  Color_EP = DND::COLOR::EnergyPoint
  #--------------------------------------------------------------------------
  # * Public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :actor
  attr_reader   :party_index
  attr_reader   :hp
  attr_reader   :mp
  attr_reader   :states
  attr_reader   :action
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor, party_index, viewport = nil)
    super(viewport)
    @actor       = actor
    @party_index = party_index
    @hp          = 0
    @mp          = 0
    @states      = []
    @action      = nil
    @last_hash   = 0
    self.x       = 4
    self.y       = 4 + HudSize * party_index
    create_layout(viewport)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Load layout
  #--------------------------------------------------------------------------
  def create_layout(viewport)
    filename         = @party_index == 0 ? LeadLayoutFilename : LayoutFilename
    self.bitmap      = Cache.UI(filename)
    @faces           = Cache.UI(FaceFilename + actor.id)
    @contents        = Sprite.new(viewport)
    @contents.bitmap = Bitmap.new(@layout.width, @layout.height)
  end
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    super
    self.visible = $game_switches[16] rescue true
    update_values
  end
  #--------------------------------------------------------------------------
  # * Update value and bars
  #--------------------------------------------------------------------------
  def update_values
    @hp     = @actor.hp
    @mp     = @actor.mp
    @states = @actor.states.collect{|state| state.id}
    @action = @actor.action
    refresh if @last_hash != hash_vlaue
  end
  #--------------------------------------------------------------------------
  # * Hash value
  #--------------------------------------------------------------------------
  def hash_value
    value  = @mp * 100 + @hp * 10
    value += @action.nil? ? 0 : @action.item.hashid
    return value
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(actor = @actor)
    @actor = actor
    return hide if actor.nil?
    draw_hp
    draw_mp
    draw_states
    draw_action
    draw_face
    @last_hash = hash_vlaue
  end
  #--------------------------------------------------------------------------
  def draw_hp
    rect = HPBarRect
    rect.width *= actor.hp / actor.mhp
    @contents.fill_rect(rect, DND::COLOR::HitPoint)
  end
  #--------------------------------------------------------------------------
  def draw_mp
    rect = EPBarRect
    rect.width *= actor.mp / actor.mmp
    @contents.fill_rect(rect, DND::COLOR::EnergyPoint)
  end
  #--------------------------------------------------------------------------
  def draw_states
    rect = StatRect
    @contents.clear_rect(rect)
  end
  #--------------------------------------------------------------------------
  def draw_action
    return if @action
    rect = StatRect
    backcolor1 = Color.new(0, 0, 0, 192)
    backcolor2 = Color.new(0, 0, 0, 0)
    @contents.clear_rect(rect)
    @contents.gradient_fill_rect(rect, backcolor1, backcolor2)
    @contents.draw_icon(@action.item.icon_index, recy.x, rect.y)
    rect.x += 26
    @contents.draw_text(rect, @action.item.name)
  end # tag: last work
  #--------------------------------------------------------------------------
  def draw_face
    
  end
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    @contents.blt(x, y, bitmap, rect, 0xff)
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    super
    
  end
   #--------------------------------------------------------------------------
  def hide
    
    super
  end
  #--------------------------------------------------------------------------
  def show
    
    super
  end
  #--------------------------------------------------------------------------
end
