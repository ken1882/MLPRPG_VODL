#===============================================================================
# * Falcao Pearl ABS script shelf # 7
#
# Actor / Eenemies HP and MP bars display v 2.0 
#
# This script acts like an Add-On, the main system can run without this piece
# 
#-------------------------------------------------------------------------------
# * Features
# - Display HP, MP, experience and TP bars of the current player actor
# - Display the Enemy HP bar when was hit
# - Boss HP bar anabled
# - Display enemy states and buff / debuff icons
# - Non-graphical bars but hightly customizable
# - 2.0 now support images instead of script drawing bars
# * Usage and Installation
# Just copy and paste below the Pearl ABS System
# 
# * Commands
# PearlBars.hide          - Hide the actor bars
# PearlBars.show          - Show the actor bars (by default)
#
# PearlBars.enemy_auto(id)- Show automatically the enemy HP bars without need
# to hit, this is mostly used for bosses, change id for the event id
# Tag any enemy with   Enemy Boss Bar = true   to eneble the boss bar mode
#------------------------------------------------------------------------------
module PearlBars
  #=============================================================================
  # * Actors bars configuration 
  #
  # Bars x and y position on the screen
  ScreenPos_X = 10
  ScreenPos_Y = 10
  #
  # Dimentions of the bars you cant exceed 300 width x 100 height
  #                   x    y     width   height
  HP_BarDimentions = [8,   20,    118,    14]
  MP_BarDimentions = [8,   38,    118,    14]
  EX_BarDimentions = [8,   56,    118,    10]
  
  # Tp info     x   y
  TP_Info =    [8,  64]
  #
  # color definition
  #           color 1    R    G    B   Opa     color 2   R   G    B    Opa
  HP_Color = [Color.new(205, 255, 205, 200),   Color.new(10, 220, 45,  200)]
  MP_Color = [Color.new(180, 225, 245, 200),   Color.new(20, 160, 225, 200)]
  EX_Color = [Color.new(180, 225, 245, 200),   Color.new(20, 160, 225, 200)]
  
  # Do you want to display graphics instead of script drawing bars?
  # if so, fill this actors bars graphics requirements
  
  ActorsHp    = ""       # Actor Hp graphic bar name (inside quotation marks)
  ActorsMp    = ""       # Actor Mp graphic bar name
  ActorsExp   = ""       # Actor Experience, if you dont want it leave it ""
  ActorsBack  = ""       # Background semi-transparent bar
  
  #=============================================================================
  # * Normal Enemies bars
  #
  # Normal enemies Bars x and y position on the screen
  NeScreenPos_X = 390
  NeScreenPos_Y = 10
  #
  # Dimentions of the bars you cant exceed 300 width x 100 height
  #                    x    y     width   height
  EHP_BarDimentions = [8,   16,    126,    10]
  #
  # color definition
  #            color 1    R    G    B   Opa     color 2   R   G    B    Opa
  EHP_Color = [Color.new(205, 255, 205, 200),   Color.new(10, 220, 45,  200)]
  
  # if you want to display grahics bar pictures fill this
  NormalEne = ""           # normal enemy hp bar
  NormalBack = ""          # Background semi-transparent bar
  
  #=============================================================================
  # * Enemy Boss HP Bar
  #
  # Boss enemies Bar x and y position on the screen
  BeScreenPos_X = 180
  BeScreenPos_Y = 10
  #
  # Dimentions of the bars you cant exceed 640 width x 100 height
  #                    x    y     width   height
  BHP_BarDimentions = [8,   22,    330,    12]
  #
  #            color 1    R    G    B   Opa     color 2   R   G    B    Opa
  BHP_Color = [Color.new(205, 255, 205, 200),   Color.new(10, 220, 45,  200)]
  
  # if you want to display grahics bar pictures fill this
  BossEne = ""        # Boss enemy Hp bar
  BossBack = ""       # Background semi-transparent bar
  #=============================================================================
  
  def self.show() $game_system.pearlbars = nil  end
  def self.hide() $game_system.pearlbars = true end
    
  def self.enemy_auto(event_id)
    $game_system.enemy_lifeobject = $game_map.events[event_id]
  end
end
($imported ||= {})["Falcao Pearl ABS Life"] = true
class Spriteset_Map
  
  alias falcaopearl_lifebars_create create_pictures
  def create_pictures
    create_hud_lifebars
    falcaopearl_lifebars_create
  end
  
  def create_hud_lifebars
    @enemy_lifeobject = $game_system.enemy_lifeobject
    @enemyhpsp = Sprite_LifeBars.new(@viewport2, @enemy_lifeobject) if 
    not @enemy_lifeobject.nil?
  end
  
  def create_actorlifebars
    return if !@actor_lifebar.nil?
    @actor_lifebar = Sprite_LifeBars.new(@viewport2, $game_player)
  end
  
  def dispose_actorlifebars
    return if @actor_lifebar.nil?
    @actor_lifebar.dispose
    @actor_lifebar = nil
  end
  
  alias falcaopearl_lifebars_update update
  def update
    update_lifebars_sprites
    falcaopearl_lifebars_update
  end
  
  def update_lifebars_sprites
    $game_system.pearlbars.nil? ? create_actorlifebars : dispose_actorlifebars
    @actor_lifebar.update unless @actor_lifebar.nil?
    
    # enemy
    if !@enemyhpsp.nil?
      unless @enemyhpsp.disposed?
        @enemyhpsp.update 
      else
        @enemyhpsp.dispose
        @enemyhpsp = nil
        $game_system.enemy_lifeobject = nil
        @enemy_lifeobject = nil
      end
    end
    
    if @enemy_lifeobject != $game_system.enemy_lifeobject
      @enemyhpsp.dispose if !@enemyhpsp.nil?
      @enemyhpsp = nil
      @enemyhpsp = Sprite_LifeBars.new(@viewport2,$game_system.enemy_lifeobject)
      @enemy_lifeobject = $game_system.enemy_lifeobject
    end
  end
  alias falcaopearl_lifebars_dispose dispose
  def dispose
    dispose_actorlifebars
    @enemyhpsp.dispose unless @enemyhpsp.nil?
    falcaopearl_lifebars_dispose
  end
end
# Life bars sprite
class Sprite_LifeBars < Sprite
  include PearlBars
  def initialize(viewport, character)
    super(viewport)
    @character = character
    self.bitmap = Bitmap.new(boss? ? 640 : 300, 120)
    @old_hp = battler.hp
    @old_mp = battler.mp
    @erasetimer = 180
    @state_checker = []
    @buff_checker = []
    refresh_contents
    @view = viewport
    update
  end
  
  def boss?
    return true if battler.is_a?(Game_Enemy) && battler.boss_hud
    return false
  end
  
  def battler
    return @character.battler
  end
  
  def refresh_contents
    self.bitmap.clear
    self.bitmap.font.size = 19
    @erasetimer = 180
    self.opacity = 255
    if battler.is_a?(Game_Actor)
      @old_exp = battler.exp
      #@old_tp = battler.tp
      self.x = ScreenPos_X
      self.y = ScreenPos_Y
      self.bitmap.draw_text(0, 0, 100, 20,battler.name)
      
      h  = HP_BarDimentions ; m = MP_BarDimentions ; e = EX_BarDimentions
      if PearlBars::ActorsHp != ""
        @pimg = Cache.picture(PearlBars::ActorsHp)  if @pimg.nil?
        @bimg = Cache.picture(PearlBars::ActorsBack) if @bimg.nil?
        @pimp = Cache.picture(PearlBars::ActorsMp)  if @pimp.nil?
        PearlKernel.image_hp(self.bitmap, h[0] + 4, h[1],@bimg,
        @pimg, battler,true)
        PearlKernel.image_mp(self.bitmap, m[0] + 4, m[1], @bimg, @pimp, battler)
        if PearlBars::ActorsExp != ""
          @piexp = Cache.picture(PearlBars::ActorsExp)  if @piexp.nil?
          PearlKernel.image_exp(self.bitmap,e[0] + 4,e[1],@bimg,@piexp, battler)
        end
      else
        hc = HP_Color ; mc = MP_Color ; ec = EX_Color
        PearlKernel.draw_hp(self.bitmap,battler, h[0], h[1], h[2], h[3], hc)
        PearlKernel.draw_mp(self.bitmap,battler, m[0], m[1], m[2], m[3], mc)
        PearlKernel.draw_exp(self.bitmap,battler, e[0], e[1], e[2], e[3], ec)
      end
      #PearlKernel.draw_tp(self.bitmap, TP_Info[0], TP_Info[1], battler)
    else battler.is_a?(Game_Enemy)
      if boss?
        self.x = BeScreenPos_X
        self.y = BeScreenPos_Y
        h  = BHP_BarDimentions ; hc = BHP_Color
        if PearlBars::BossEne != ""
          @n_img = Cache.picture(PearlBars::BossEne) if @n_img.nil?
          @n_back = Cache.picture(PearlBars::BossBack) if @n_back.nil?
          PearlKernel.image_hp(self.bitmap, h[0] + 4, h[1],@n_back,
          @n_img, battler,true)
        else
          PearlKernel.draw_hp(self.bitmap,battler, h[0],h[1],h[2], h[3],hc,true)
        end
      else
        self.x = NeScreenPos_X
        self.y = NeScreenPos_Y
        h  = EHP_BarDimentions ; hc = EHP_Color
        if PearlBars::NormalEne != ""
          @n_img = Cache.picture(PearlBars::NormalEne) if @n_img.nil?
          @n_back = Cache.picture(PearlBars::NormalBack) if @n_back.nil?
          PearlKernel.image_hp(self.bitmap, h[0] + 4, h[1],@n_back,
          @n_img, battler,true)
        else
          PearlKernel.draw_hp(self.bitmap,battler,h[0],h[1],h[2], h[3], hc,true)
        end
      end
    end
  end
  
  def update
    super
    
    
    if battler.nil?
      dispose
      return
    end
    
    if @old_hp != battler.hp
      refresh_contents
      @old_hp = battler.hp
    end
    if @old_mp != battler.mp
      refresh_contents
      @character.actor.apply_usability if @character.is_a?(Game_Player)
      @old_mp = battler.mp
    end
    
    if battler.is_a?(Game_Actor)
      if @old_exp != battler.exp
        @old_exp = battler.exp
        refresh_contents
      end
      if @old_tp != battler.tp
        @old_tp = battler.tp
        @character.actor.apply_usability if @character.is_a?(Game_Player)
        refresh_contents
      end
      
    elsif battler.is_a?(Game_Enemy)
      if boss?
        dispose if battler.dead?
      else
        if @erasetimer > 0
          @erasetimer -= 1 
          self.opacity -= 10 if @erasetimer <= 25
          @states.opacity = self.opacity if !@states.nil?
          dispose if @erasetimer == 0
        end
      end
      update_enemy_status_icons
    end
  end
  
  # enemy status icons engine
  def update_enemy_status_icons
    display_status? ? create_states_icons : dispose_state_icons
    4.times.each {|i| refresh_states_icons if 
    @state_checker[i] != battler.state_icons[i]}
    2.times.each {|i| refresh_states_icons if 
    @buff_checker[i] != battler.buff_icons[i]}
  end
  
  def display_status?
    return true if !battler.state_icons.empty?
    return true if !battler.buff_icons.empty?
    return false
  end
  
  def create_states_icons
    return if disposed?
    return if !@states.nil?
    @states = ::Sprite.new(@view)
    @states.bitmap = Bitmap.new(144, 24)
    @n_back.nil? ? y_plus = BHP_BarDimentions[3] : y_plus = @n_back.height
    pos = [BeScreenPos_X, BeScreenPos_Y, y_plus] if  boss?
    pos = [NeScreenPos_X, NeScreenPos_Y, y_plus] if !boss?
    @states.x = pos[0] + 10
    @states.y = pos[1] + pos[2] + 24
    @states.zoom_x = 0.8
    @states.zoom_y = 0.8
    refresh_states_icons
  end
  
  def dispose_state_icons
    return if @states.nil?
    @states.bitmap.dispose
    @states.dispose
    @states = nil
  end
  
  def refresh_states_icons
    4.times.each {|i| @state_checker[i] = battler.state_icons[i]}
    2.times.each {|i| @buff_checker[i] = battler.buff_icons[i]}
    return if @states.nil?
    @states.bitmap.clear
    x = 0
    battler.state_icons.each {|icon| draw_icon(icon, x, 0) ; x += 24
    break if x == 96}
    count = 0
    battler.buff_icons.each {|icon| draw_icon(icon, x, 0) ; x += 24 ; count += 1
    break if count == 2}
  end
  
  def draw_icon(icon_index, x, y, enabled = true)
    bit = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    @states.bitmap.blt(x, y, bit, rect, enabled ? 255 : 150)
  end
  
  def dispose
    self.bitmap.dispose
    dispose_state_icons
    super
  end
end
# Make the enemy bars to load when enemy is hited
class Projectile < Game_Character
  alias falcao_lifebars_execute execute_damageto_enemy
  def execute_damageto_enemy(event)
    $game_system.enemy_lifeobject = event if @user.is_a?(Game_Player) &&
    !event.battler.object
    falcao_lifebars_execute(event)
  end
end
