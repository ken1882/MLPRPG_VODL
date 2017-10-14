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
  WINDOW_OPACITY = 80
  
  Wallpapers = [
    "Circle_of_friendship","Generosity","Kindness","Laughter",
    "Loyalty","Magic","Honesty"
  ]
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
           if ivar.is_a?(Window) && !ivar.disposed?
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
      sprite = Menu_Particles.new(@particle_viewport)
      @particle_bitmap.push(sprite)
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
     return if @particle_bitmap.any?{|bitmap| bitmap.disposed?}
     @particle_bitmap.each {|sprite| sprite.update }
 end  
  
end
