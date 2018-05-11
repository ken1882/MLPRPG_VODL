#===============================================================================
# * Sprite_Weapon
#-------------------------------------------------------------------------------
#   Disaply the wielding weapon on the Scene_Map
#===============================================================================
class Sprite_Weapon < Sprite
  include DND::Graphics
  OffsetX = { 2 => 0, 4 => -16, 6 => 20, 8 => 0}
  OffsetY = { 4 => -12, 8 => -28, 2 => 8, 6 => -12}
  #--------------------------------------------------------------------------
  # * Public character Variables
  #--------------------------------------------------------------------------
  attr_reader   :attacking
  attr_reader   :animation_sprite
  attr_accessor :timer
  attr_accessor :user
  attr_accessor :action
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(viewport, user)
    @attacking = false
    @user      = user.battler ? user.battler : user
    @timer     = 0 
    @index     = 0
    @animation_sprite = Sprite_Animation.new(viewport)
    super(viewport)
    create_bitmap
  end
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Bitmap.new(24,24)
    refresh_weapon(@user.primary_weapon)
    hide
  end
  #--------------------------------------------------------------------------
  def refresh_weapon(item)
    return if !item
    
    if item.user_graphic.upcase.include?("ICON")
      return if item.icon_index == @graphic
      @type = 0
      index = item.icon_index rescue nil
      temp = Cache.iconset
      self.bitmap = Bitmap.new(24, 24)
      self.bitmap.blt(0,0,temp,Rect.new(index % 16 * 24, index / 16 * 24, 24, 24))
      self.src_rect.set(0,0,24,24)
      self.ox    = 22
      self.oy    = 22
      @graphic = index
    elsif item.user_graphic && item.user_graphic != @graphic
      @type = 1
      self.angle = 0
      self.bitmap = Cache.Arms(item.user_graphic)
      @cw = self.bitmap.width  / 3;
      @ch = self.bitmap.height / 4;
      self.src_rect.set(0, 0, @cw, @ch)
      self.ox = @cw / 2
      self.oy = @ch
      @graphic = item.user_graphic
    end
  end
  #--------------------------------------------------------------------------
  def setup_action(action)
    @action = action
    puts "[Warning]: Sprite Weapon has different owner: #{@user.name} #{action.user.name}" if @user.map_char != action.user.map_char
    refresh_weapon(action.item)
    @timer = 0
    @attacking = true
    show
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    return if disposed?
    super
    update_animation
    update_attacking if @attacking
  end
  #--------------------------------------------------------------------------
  def update_animation
    @animation_sprite.update
  end
  #--------------------------------------------------------------------------
  def update_attacking
    if SceneManager.time_stopped?
      return unless $game_system.time_stopper && $game_system.time_stopper.map_char == @user.map_char
    end
    @dir = @user.map_char.direction
    update_icon_sprite  if @type == 0
    update_image_sprite if @type == 1
    @action.time = 3
    @timer += 1
  end
  #--------------------------------------------------------------------------
  def update_icon_sprite
    self.x = @user.map_char.screen_x + Wield_Dir_Offest[@dir][0]
    self.y = @user.map_char.screen_y + Wield_Dir_Offest[@dir][1]
    case @timer
    when 0
      self.angle = Wield_Angles[@dir][0]
      self.z     = Wield_Depth_Correction[@dir]
    when 3
      self.angle = Wield_Angles[@dir][1]
      self.z     = Wield_Depth_Correction[@dir]
    when 6
      self.angle = Wield_Angles[@dir][2]
      self.z     = Wield_Depth_Correction[@dir]
      BattleManager.execute_action(@action)
      setup_animation
    when 9
      self.angle = Wield_Angles[@dir][3]
      self.z     = Wield_Depth_Correction[@dir]
    when 12
      terminate_attack
    end
  end
  #--------------------------------------------------------------------------
  def update_image_sprite
    self.x = @user.map_char.screen_x
    self.y = @user.map_char.screen_y + 22
    sy = (@dir - 2) / 2 * @ch
    case @timer
    when 0
      sx = 0
      self.src_rect.set(sx, sy, @cw, @ch)
    when 4
      sx = @cw
      self.src_rect.set(sx, sy, @cw, @ch)
      BattleManager.execute_action(@action)
      setup_animation
    when 8
      sx = @cw * 2
      self.src_rect.set(sx, sy, @cw, @ch)
    when 12
      terminate_attack
    end
  end
  #--------------------------------------------------------------------------
  def terminate_attack
    @attacking = false
    @action.resume
    hide
  end
  #--------------------------------------------------------------------------
  def setup_animation
    animation_id = @action.item.tool_animation
    return unless animation_id > 0
    dir = @user.map_char.direction
    pos = POS.new(@user.map_char.real_x + OffsetX[dir] / 32.0, @user.map_char.real_y + OffsetY[dir] / 32.0)
    @animation_sprite.character = pos 
    animation = $data_animations[animation_id]
    @animation_sprite.start_animation(animation, @dir == 6 || @dir == 2)
  end
  #--------------------------------------------------------------------------
  def dispose
    @animation_sprite.dispose
    super
  end
  #--------------------------------------------------------------------------
  def relocate
    @dir = @user.direction
    if @type == 0
      self.x = @user.map_char.screen_x + Wield_Dir_Offest[@dir][0]
      self.y = @user.map_char.screen_y + Wield_Dir_Offest[@dir][1]
    else
      self.x = @user.map_char.screen_x
      self.y = @user.map_char.screen_y + 22
    end
    @animation_sprite.relocate
  end
  #--------------------------------------------------------------------------
end
