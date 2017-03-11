
#==============================================================================
# +++ MOG - Wallpaper EX (V1.1) +++
#==============================================================================
# By Moghunter
# http://www.atelier-rgss.com
#==============================================================================
# - Adiciona um papel de parede e adiciona alguns efeitos animados.
#==============================================================================
# Para mudar de papel de parede no meio do jogo basta usar o código abaixo.
#
# $game_system.wallpaper = "FILE_NAME"
#
#==============================================================================
# E para mudar de velocidade de scroll use o código abaixo.
#
# $game_system.wallpaper_scroll = [ SPEED_X, SPEED_Y]
#
#==============================================================================
# Serão necessários os seguintes arquivos na pasta GRAPHICS/SYSTEM.
# 
# Menu_Particles.png
# wallpaper
#
#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 1.1 - Melhoria no sistema de dispose de imagens.
#==============================================================================
module MOG_WALLPAPER_EX
  #Ativar Particulas animadas.
  PARTICLES = true
  #Numero de particulas.
  NUMBER_OF_PARTICLES = 10
  #Deslizar a imagem de fundo.
  BACKGROUND_SCROLL_SPEED = [0,0]
  #Definição da opacidade das janelas.
  WINDOW_OPACITY = 48
  
  Wallpapers = [
    "Circle_of_friendship","Generosity","Kindness","Laughter",
    "Loyalty","Magic","Honesty"
  ]
end
#==============================================================================
# ■ Game_System
#==============================================================================
class Game_System
  
  attr_accessor :wallpaper
  attr_accessor :wallpaper_scroll
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------  
  alias mog_wallpaper_initialize initialize
  def initialize
      mog_wallpaper_initialize
      @wallpaper = "Wallpaper"    
      @wallpaper_scroll = MOG_WALLPAPER_EX::BACKGROUND_SCROLL_SPEED
  end
  
end  
#==============================================================================
# ■ Menu Particles
#==============================================================================
class Menu_Particles < Sprite
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------             
  def initialize(viewport = nil)
      super(viewport)
      self.bitmap = Cache.system("Menu_Particles")
      reset_setting(true)
  end  
  
 #--------------------------------------------------------------------------
 # ● Reset Setting
 #--------------------------------------------------------------------------               
  def reset_setting(start)
      zoom = (50 + rand(100)) / 100.1
      self.zoom_x = zoom
      self.zoom_y = zoom
      self.x = rand(544)
      if start
         self.y = rand(416 + self.bitmap.height)
      else
         self.y = 416 + rand(32 + self.bitmap.height)
      end        
      self.opacity = 0
      self.blend_type = 1
      @speed_x = 0
      @speed_y = [[rand(3), 3].min, 1].max
      @speed_a = 0#rand(3)
  end
  
 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------               
  def dispose
      super
      self.bitmap.dispose
  end  
  
 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------               
  def update
      super
      self.x += @speed_x
      self.y -= @speed_y
      self.angle += @speed_a      
      self.opacity += 5
      reset_setting(false) if self.y < 0
  end  
  
end
#==============================================================================
# ■ LAYOUT_EX
#==============================================================================
module WALLPAPER_EX
  
  include MOG_WALLPAPER_EX
  
  #--------------------------------------------------------------------------
  # ● Start
  #--------------------------------------------------------------------------          
  def start
      super
      create_particles
  end   
  
  #--------------------------------------------------------------------------
  # ● Set Window OPACITY
  #--------------------------------------------------------------------------            
  def set_window_opacity    
      instance_variables.each do |varname|
          ivar = instance_variable_get(varname)
           if ivar.is_a?(Window) 
              ivar.opacity = WINDOW_OPACITY  
          end
      end
  end
 
  #--------------------------------------------------------------------------
  # ● Create Particles
  #--------------------------------------------------------------------------  
  def create_particles
      return unless PARTICLES
      dispose_menu_particles
      @particle_viewport = Viewport.new(-32, -32, 576, 448)
      @particle_bitmap =[]
      for i in 0...NUMBER_OF_PARTICLES
          @particle_bitmap.push(Menu_Particles.new(@particle_viewport))
      end  
  end  
  #--------------------------------------------------------------------------
  # ● Create Background
  #--------------------------------------------------------------------------
  def create_background
      @background_sprite = Plane.new
      @background_sprite.bitmap = Cache.system($game_system.wallpaper) rescue nil
      @background_sprite.bitmap = SceneManager.background_bitmap if @background_sprite.bitmap == nil
  end
 
 #--------------------------------------------------------------------------
 # ● Dispose Light
 #--------------------------------------------------------------------------              
  def dispose_menu_particles
      return unless PARTICLES
      if @particle_bitmap != nil
         @particle_bitmap.each {|sprite| sprite.dispose} 
         @particle_viewport.dispose
         @particle_bitmap = nil
      end      
  end     
  
  #--------------------------------------------------------------------------
  # ● Dispose Background
  #--------------------------------------------------------------------------
  def dispose_background
      return if @background_sprite == nil
      @background_sprite.bitmap.dispose
      @background_sprite.dispose
      @background_sprite = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Terminate
  #--------------------------------------------------------------------------  
  def terminate
      super
      dispose_menu_particles
  end    
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  def update
      super
      update_background
      update_particle
  end
  
  #--------------------------------------------------------------------------
  # ● Update Background
  #--------------------------------------------------------------------------    
  def update_background
      @background_sprite.ox += $game_system.wallpaper_scroll[0]
      @background_sprite.oy += $game_system.wallpaper_scroll[1] 
  end
  
 #--------------------------------------------------------------------------
 # ● Update Particle
 #--------------------------------------------------------------------------              
 def update_particle
     return unless PARTICLES
     @particle_bitmap.each {|sprite| sprite.update }
 end  
  
end
#==============================================================================
# ● Scene Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  include WALLPAPER_EX
  
 #--------------------------------------------------------------------------
 # ● Start
 #--------------------------------------------------------------------------                
  alias mog_layout_ex_start start
  def start
      wallpapers = MOG_WALLPAPER_EX::Wallpapers
      $game_system.wallpaper = wallpapers[rand(wallpapers.size)]
      mog_layout_ex_start
      set_window_opacity
  end  
end
#==============================================================================
# ● Scene Item
#==============================================================================
class Scene_Item < Scene_ItemBase
  include WALLPAPER_EX
  
 #--------------------------------------------------------------------------
 # ● Start
 #--------------------------------------------------------------------------                
  alias mog_layout_ex_start start
  def start
      mog_layout_ex_start
      set_window_opacity
  end  
end
#==============================================================================
# ● Scene Skill
#==============================================================================
class Scene_Skill < Scene_ItemBase
  include WALLPAPER_EX
  
 #--------------------------------------------------------------------------
 # ● Start
 #--------------------------------------------------------------------------                
  alias mog_layout_ex_start start
  def start
      mog_layout_ex_start
      set_window_opacity
  end  
end
#==============================================================================
# ● Scene Equip
#==============================================================================
class Scene_Equip < Scene_MenuBase
  include WALLPAPER_EX
  
 #--------------------------------------------------------------------------
 # ● Start
 #--------------------------------------------------------------------------                
  alias mog_layout_ex_start start
  def start
      mog_layout_ex_start
      set_window_opacity
  end  
end
#==============================================================================
# ● Scene Status
#==============================================================================
class Scene_Status < Scene_MenuBase
  include WALLPAPER_EX
  
 #--------------------------------------------------------------------------
 # ● Start
 #--------------------------------------------------------------------------                
  alias mog_layout_ex_start start
  def start
      mog_layout_ex_start
      set_window_opacity
  end  
end
#==============================================================================
# ● Scene File
#==============================================================================
class Scene_File < Scene_MenuBase
  include WALLPAPER_EX
  
 #--------------------------------------------------------------------------
 # ● Start
 #--------------------------------------------------------------------------                
  alias mog_layout_ex_start start
  def start
      mog_layout_ex_start
      set_window_opacity
  end  
end
#==============================================================================
# ● Scene End
#==============================================================================
class Scene_End < Scene_MenuBase
  include WALLPAPER_EX
  
 #--------------------------------------------------------------------------
 # ● Start
 #--------------------------------------------------------------------------                
  alias mog_layout_ex_start start
  def start
      mog_layout_ex_start
      set_window_opacity
  end  
end
#==============================================================================
# ● Window SaveFile
#==============================================================================
class Window_SaveFile < Window_Base
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                  
  alias mog_wallpaper_initialize initialize 
  def initialize(height, index)
      mog_wallpaper_initialize(height, index)
      self.opacity = WALLPAPER_EX::WINDOW_OPACITY if can_opacity_window?
  end
    
 #--------------------------------------------------------------------------
 # ● Can Opacity Window
 #--------------------------------------------------------------------------                    
  def can_opacity_window?
      return true
  end  
end
$mog_rgss3_wallpaper_ex = true
