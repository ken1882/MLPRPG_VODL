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
    @user      = user
    @timer     = 0 
    @index     = 0
    @animation_sprite = Sprite_Animation.new(viewport)
    super(viewport)
    create_bitmap
    self.ox    = 22
    self.oy    = 22
  end
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Bitmap.new(24,24)
    index = user.primary_weapon.icon_index rescue nil
    refresh_weapon(index)
    hide
  end
  #--------------------------------------------------------------------------
  def refresh_weapon(index)
    return if !index
    temp = SceneManager.iconset#Cache.system("Iconset")
    self.bitmap.clear
    self.bitmap.blt(0,0,temp,Rect.new(index % 16 * 24, index / 16 * 24, 24, 24))
    #temp.dispose
    #temp = nil
    @index = index
  end
  #--------------------------------------------------------------------------
  def setup_action(action)
    @action = action
    puts "[Warning]: Sprite Weapon has different owner: #{@user.name} #{action.user.name}" if @user != action.user
    index = action.item.icon_index
    refesh_weapon(index) if index != @index
    @timer = 0
    @attacking = true
    show
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
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
    dir = @user.direction
    self.x = @user.screen_x + Wield_Dir_Offest[dir][0]
    self.y = @user.screen_y + Wield_Dir_Offest[dir][1]
    case @timer
    when 0
      self.angle = Wield_Angles[dir][0]
      self.z     = Wield_Depth_Correction[dir]
    when 3
      self.angle = Wield_Angles[dir][1]
      self.z     = Wield_Depth_Correction[dir]
    when 6
      self.angle = Wield_Angles[dir][2]
      self.z     = Wield_Depth_Correction[dir]
      BattleManager.execute_action(@action)
      setup_animation
    when 9
      self.angle = Wield_Angles[dir][3]
      self.z     = Wield_Depth_Correction[dir]
    when 12
      terminate_attack
    end
    @timer += 1
  end
  #--------------------------------------------------------------------------
  def terminate_attack
    @attacking = false
    hide
  end
  #--------------------------------------------------------------------------
  def setup_animation
    animation_id = @action.item.tool_animation
    return unless animation_id > 0
    dir = @user.direction
    pos = POS.new(@user.real_x + OffsetX[dir] / 32.0, @user.real_y + OffsetY[dir] / 32.0)
    @animation_sprite.character = pos 
    animation = $data_animations[animation_id]
    @animation_sprite.start_animation(animation)
  end
  #--------------------------------------------------------------------------
  def dispose
    @animation_sprite.dispose
    super
  end
  #--------------------------------------------------------------------------
end
