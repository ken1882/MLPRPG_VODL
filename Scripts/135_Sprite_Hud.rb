#==============================================================================
# ** Sprite_Hud
#------------------------------------------------------------------------------
#  Sprite for displaying the stat of party members, including hp, ep and action
#==============================================================================
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
    @viewport      = viewport
    self.x         = 4
    self.y         = 4 + HudSize.at(1) * party_index
    self.z         = viewport ? viewport.z : 1000
    create_layout
  end
  #--------------------------------------------------------------------------
  # * Load layout
  #--------------------------------------------------------------------------
  def create_layout
    return if @actor.nil?
    filename         = @party_index == 0 ? LeadLayoutFilename : LayoutFilename
    self.bitmap      = Cache.UI(filename)
    @contents        = Sprite.new(@viewport)
    @contents.bitmap = Bitmap.new(*ContentBitmapSize)
    @face_sprite     = Sprite.new(@viewport)
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
    dectect_actor_change
    update_visibility
    return if @actor.nil?
    update_values
    refresh if @actor_changed || @last_hash != hash_value
    update_timer
  end
  #--------------------------------------------------------------------------
  def dectect_actor_change
    actor = battler
    #actor = $game_party.members[@party_index]
    return unless need_refresh?(actor)
    
    @actor = actor
    create_layout if !@face_sprite
    @actor_changed = true
  end
  #--------------------------------------------------------------------------
  def need_refresh?(actor)
    return true  if @need_refresh
    return false if !@actor_changed && actor == @actor
    return false if actor.nil?
    return true
  end
  #--------------------------------------------------------------------------
  def update_visibility(forced = false)
    return hide if @actor.nil? || ($game_system.hide_huds? && visible?) || forced
    return show if !$game_system.hide_huds? && !visible?
  end
  #--------------------------------------------------------------------------
  # * Update value and bars
  #--------------------------------------------------------------------------
  def update_values
    on_actor_change if @actor_changed
    return hide if @actor.nil?
    @hp     = @actor.hp
    @mp     = @actor.mp
    @mhp    = @actor.mhp
    @mmp    = @actor.mmp
    @action = @actor.next_action.nil? ? @actor.action : @actor.next_action
  end
  #--------------------------------------------------------------------------
  def update_timer
    @se_timer     += 1 if @flag_low_hp
    return if SceneManager.tactic_enabled?
    @face_timer   += 1 if @flag_temp_face
    @action_timer += 1 if @flag_action
    draw_action(@actor.action) if @action_timer >= 90
  end
  #--------------------------------------------------------------------------
  def battler
    if @party_index == 0
      return $game_player.actor
    else
      return $game_player.followers[@party_index - 1].actor
    end
  end
  #--------------------------------------------------------------------------
  # * Hash value
  #--------------------------------------------------------------------------
  def hash_value
    actor = battler
    return -1 if actor.nil?
    value  = actor.mp * 100 + actor.hp * 10 + actor.hashid + @party_index
    value += actor.action.nil? ? 0 : actor.action.item.hashid
    return value
  end
  #--------------------------------------------------------------------------
  def on_actor_change
    @actor = battler
    return hide if @actor.nil?
    @action = nil
    @hp     = @actor.hp
    @mp     = @actor.mp
    @mhp    = @actor.mhp
    @mmp    = @actor.mmp
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(redetect = false)
    dectect_actor_change if redetect
    return hide if @actor.nil?
    update_values if redetect || @actor_changed
    draw_name
    draw_hp
    draw_mp
    draw_action
    draw_face
    @last_hash = hash_value
    @actor_changed = false
    update_visibility(true) if $game_system.hide_huds?
  end
  #--------------------------------------------------------------------------
  def draw_name
    return unless @actor_changed
    rect = NameRect
    @contents.bitmap.font.size = 18
    @contents.bitmap.clear_rect(rect)
    color = PONY::Menu_UI::NAME_COLOR[@actor.id] rescue nil
    @contents.bitmap.font.color.set(color) if color
    @contents.bitmap.draw_text(rect, @actor.name, 1) 
    @contents.bitmap.font.color.set(DND::COLOR::White) if color
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
  def draw_action(action = nil)
    clear_action
    @action = action.dup if action
    return unless @action
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
    bitmap = Cache.iconset
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    @contents.bitmap.blt(x, y, bitmap, rect)
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @face_sprite.dispose if @face_sprite
    @contents.dispose    if @contents
    super
  end
   #--------------------------------------------------------------------------
  def hide
    @face_sprite.hide if @face_sprite
    @contents.hide    if @contents
    super
  end
  #--------------------------------------------------------------------------
  def show
    @face_sprite.show if @face_sprite
    @contents.show    if @contents
    super
  end
  #--------------------------------------------------------------------------
end
