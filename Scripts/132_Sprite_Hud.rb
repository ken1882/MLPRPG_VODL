#==============================================================================
# ** Sprite_Hud
#------------------------------------------------------------------------------
#  Sprite for displaying the stat of party members, including hp, ep and action
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
  attr_reader   :action
  attr_accessor :face_phase
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor, party_index, viewport = nil)
    super(viewport)
    @actor         = actor
    @party_index   = party_index
    @hp            = 0
    @mp            = 0
    @mhp           = 1
    @mmp           = 1
    @action        = nil
    @last_hash     = 0
    @last_face     = 0xff
    @face_timer    = 0
    @se_timer      = 0
    @action_timer  = 0
    @actor_changed = true
    self.x         = 4
    self.y         = 4 + HudSize.at(1) * party_index
    self.z         = viewport ? viewport.z : 1000
    create_layout(viewport)
  end
  #--------------------------------------------------------------------------
  # * Load layout
  #--------------------------------------------------------------------------
  def create_layout(viewport)
    filename         = @party_index == 0 ? LeadLayoutFilename : LayoutFilename
    self.bitmap      = Cache.UI(filename)
    @contents        = Sprite.new(viewport)
    @contents.bitmap = Bitmap.new(*ContentBitmapSize)
    @face_sprite     = Sprite.new(viewport)
    @face_sprite.bitmap = Bitmap.new(FaceHudRect.width, FaceHudRect.height)
    @contents.x, @contents.y       = self.x, self.y
    @face_sprite.x, @face_sprite.y = self.x, self.y
    @contents.z = self.z - 1
    @face_sprite.z  = self.z + 1
  end
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    super
    #self.visible = $game_switches[16] rescue true
    dectect_actor_change
    update_values
    update_timer
  end
  #--------------------------------------------------------------------------
  def dectect_actor_change
    return if !@actor_changed && $game_party.members[@party_index] == @actor
    actor = $game_party.members[@party_index]
    @mhp, @mmp = actor.mhp, actor.mmp
    @actor = actor
    @actor_changed = true
  end
  #--------------------------------------------------------------------------
  # * Update value and bars
  #--------------------------------------------------------------------------
  def update_values
    @hp     = @actor.hp
    @mp     = @actor.mp
    @action = @actor.action
    refresh if @actor_changed || @last_hash != hash_value
  end
  #--------------------------------------------------------------------------
  def update_timer
    @face_timer   += 1 if @flag_temp_face
    @se_timer     += 1 if @flag_low_hp
    @action_timer += 1 if @flag_action
    clear_action       if @action_timer >= 60
  end
  #--------------------------------------------------------------------------
  # * Hash value
  #--------------------------------------------------------------------------
  def hash_value
    actor = $game_party.members[@party_index]
    return -1 if actor.nil?
    value  = actor.mp * 100 + actor.hp * 10 + actor.hashid
    value += actor.action.nil? ? 0 : actor.action.item.hashid
    return value
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    return hide if @actor.nil?
    show if !visible?
    draw_name
    draw_hp
    draw_mp
    draw_action
    draw_face
    @last_hash = hash_value
    @actor_changed = false
  end
  #--------------------------------------------------------------------------
  def draw_name
    return unless @actor_changed
    rect = NameRect
    @contents.bitmap.font.size = 18
    @contents.bitmap.clear_rect(rect)
    @contents.bitmap.draw_text(rect, @actor.name, 1) 
  end
  #--------------------------------------------------------------------------
  def draw_hp
    rect = HPBarRect.dup
    @contents.bitmap.clear_rect(rect)
    rect.width = rect.width * @hp / @mhp
    @contents.bitmap.fill_rect(rect, DND::COLOR::HitPoint)
  end
  #--------------------------------------------------------------------------
  def draw_mp
    rect = EPBarRect.dup
    @contents.bitmap.clear_rect(rect)
    rect.width = rect.width.to_i * @mp / @mmp
    @contents.bitmap.fill_rect(rect, DND::COLOR::EnergyPoint)
  end
  #--------------------------------------------------------------------------
  def draw_action
    return unless @action
    clear_action
    rect = StatRect.dup
    backcolor1 = Color.new(0, 0, 0, 192)
    backcolor2 = Color.new(0, 0, 0, 0)
    @contents.bitmap.gradient_fill_rect(rect, backcolor1, backcolor2)
    draw_icon(@action.item.icon_index, rect.x, rect.y)
    rect.x += 26
    @contents.bitmap.draw_text(rect, @action.item.name)
    @flag_action  = true
  end
  #--------------------------------------------------------------------------
  def clear_action
    rect = StatRect.dup
    @contents.bitmap.clear_rect(rect)
    @flag_action = false
    @action_timer = 0
  end
  #--------------------------------------------------------------------------
  def draw_face
    phase = get_actor_status
    return if phase == @last_face && !@actor_changed
    @last_face = phase
    filename = FaceFilename + @actor.id.to_s
    bitmap   = Cache.UI(filename) rescue nil
    return if bitmap.nil?
    rect     = FaceHudRect
    src_rect = FaceSrcRect.dup
    src_rect.x = phase * src_rect.width
    @face_sprite.bitmap.clear_rect(rect)
    @face_sprite.bitmap.blt(0, 0, bitmap, src_rect)
  end
  #--------------------------------------------------------------------------
  def get_actor_status
    return PONY::Hud::FaceIdle
  end
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    @contents.bitmap.blt(x, y, bitmap, rect)
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @face_sprite.dispose
    @contents.dispose
    super
  end
   #--------------------------------------------------------------------------
  def hide
    @face_sprite.hide
    @contents.hide
    super
  end
  #--------------------------------------------------------------------------
  def show
    @face_sprite.show
    @contents.show
    super
  end
  #--------------------------------------------------------------------------
end
