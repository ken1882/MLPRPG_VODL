#==============================================================================
# +++ MOG - Weather EX (v1.6) +++
#==============================================================================
# By Moghunter 
# http://www.atelier-rgss.com/
#==============================================================================
# Sistema de clima com efeitos animados.
#==============================================================================
# As imagens usadas pelo sistema do clima devem ser gravadas na pasta
#
# GRAPHICS/WEATHER/
#
#==============================================================================
# UTILIZAÇÃO
# 
# Use o comando abaixo através da função chamar script.*(Evento)
#
# weather(TYPE, POWER, IMAGE_FILE)
#
# TYPE - Tipo de clima. (de 0 a 6)
# POWER - Quantidade de partículas na tela. (de 1 a 10)
# IMAGE_FILE - Nome da imagem.
#
# Exemplo (Eg)
#
# weather(0, 5, "Leaf")
#
#==============================================================================
# Tipos de Clima.
#
# O sistema vem com 7 climas pré-configurados, que podem ser testados na demo
# que vem com esse script.
#
# 0 - (Rain)  
# 1 - (Wind)
# 2 - (Fog)  
# 3 - (Light)
# 4 - (Snow)
# 5 - (Spark)
# 6 - (Random)
#
#==============================================================================
# NOTA
#
# Evite de usar imagens muito pesadas ou de tamanho grande, caso for usar
# diminua o poder do clima para evitar lag.
#
#==============================================================================
#==============================================================================
# Para parar o clima use o comando abaixo.
#
# weather_stop
#
#==============================================================================
# Para parar reativar o clima com as caracteríticas préviamente usadas use o
# comando abaixo.
#
# weather_restore
#==============================================================================
# Se você precisar ativar um novo clima mas deseja gravar as caracteríticas 
# do clima atual para ser reativado depois use os códigos abaixo.
#
# weather_store
# weather_restore_store
#
#==============================================================================

#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 1.6 - Correção na ordem de dispose do Viewport o que causava Crash em 
#         alguns projetos (Problemas de compatibilidade).
# v 1.5 - Correção definitiva para erro de Crash randômico. 
# v 1.4 - Melhoria no sistema de dispose. * (Para quem estiver tendo problema 
#         com crashes randômicos.)
# v 1.3 - Adição do comando weather_store e weather_recover_store
# v 1.2 - Melhor codificação e compatibilidade.
# v 1.1 - Correção do Bug de salvar através do evento.
# v 1.0 - Weather EX ativo na batalha.
#       - Função restore/pause que permite reativar o clima com as
#         caracteríticas previamente usadas, ou seja, dá uma pausa no clima.
# v 0.9 - Melhoria no sistema de dispose.
#==============================================================================
module MOG_WEATHER_EX
  #Prioridade do clima na tela.
  WEATHER_SCREEN_Z = 50 
  #Definição da eficiência do poder do clima.
  #NOTA -  Um valor muito alto pode causar lag, dependendo do tipo de clima e
  #        imagem usada.
  WEATHER_POWER_EFIC = 5
  #Ativar o clima no sistema de batalha.
  WEATHER_BATTLE = false
end

#==============================================================================
# ■ Cache
#==============================================================================
module Cache
  
  #--------------------------------------------------------------------------
  # ● Weather
  #--------------------------------------------------------------------------
  def self.weather(filename)
      load_bitmap("Graphics/Weather/", filename)
  end
  
end

#==============================================================================
# ■ Game System
#==============================================================================
class Game_System
  
  attr_accessor :weather
  attr_accessor :weather_restore
  attr_accessor :weather_record_set
  attr_accessor :weather_temp
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias weather_ex_initialize initialize  
  def initialize
      @weather = [-1,0,""]
      @weather_restore = [-1,0,""]
      @weather_temp = [-1,0,""]
      @weather_record_set = [-1,0,""]
      weather_ex_initialize 
  end  
  
end  

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp

  attr_accessor :weather_ex_set
  attr_accessor :weather_fade
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias mog_weather_ex_temp_initialize initialize
  def initialize
      @weather_ex_set = []
      @weather_fade = false
      mog_weather_ex_temp_initialize
  end  
  
end

#==============================================================================
# ■ Game Interpreter
#==============================================================================
class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # ● Weather
  #--------------------------------------------------------------------------    
  def weather(type = -1, power = 0, image = "")
      $game_temp.weather_fade = false
      $game_system.weather.clear
      $game_system.weather = [type,power,image]
  end
  
  #--------------------------------------------------------------------------
  # ● Weather Stop
  #--------------------------------------------------------------------------     
  def weather_stop
      $game_temp.weather_fade = false
      $game_system.weather.clear
      $game_system.weather = [-1,0,""]
      $game_system.weather_restore  = [-1,0,""]
      $game_system.weather_temp = [-1,0,""]      
  end
  
  #--------------------------------------------------------------------------
  # ● Weather Restore
  #--------------------------------------------------------------------------       
  def weather_restore
      $game_temp.weather_fade = false
      if $game_system.weather[0] != -1
         w = $game_system.weather
         $game_system.weather_restore = [w[0],w[1],w[2]] 
         $game_system.weather.clear
         $game_system.weather = [-1,0,""]
         return
      end
      w = $game_system.weather_restore 
      weather(w[0],w[1],w[2])
  end
  
  #--------------------------------------------------------------------------
  # ● Weather Fade
  #--------------------------------------------------------------------------         
  def weather_fade(value)
      $game_temp.weather_fade = value
  end
  
  #--------------------------------------------------------------------------
  # ● Weather Store
  #--------------------------------------------------------------------------           
  def weather_store
      w = $game_system.weather 
      $game_system.weather_record_set = [w[0],w[1],w[2]]
  end  
  
  #--------------------------------------------------------------------------
  # ● Weather Restore Store
  #--------------------------------------------------------------------------           
  def weather_restore_store
      w = $game_system.weather_record_set
      weather(w[0],w[1],w[2])      
  end    
  
end  

#==============================================================================
# ■ Weather_EX
#==============================================================================
class Weather_EX < Sprite
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  def initialize(viewport = nil ,type = 0, image_name = "",index = 0,nx,ny)
      super(viewport)
      self.bitmap = Cache.weather(image_name.to_s)
      self.opacity = 0
      @cw = self.bitmap.width
      @ch = self.bitmap.height
      @angle_speed = 0
      @x_speed = 0
      @y_speed = 0
      @zoom_speed = 0
      @opacity_speed = 0
      @type = type
      @index = index
      @old_nx = nx
      @old_ny = ny
      type_setup(nx,ny)
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------    
  def dispose
      dispose_sprite_weather_ex
      super
  end

  #--------------------------------------------------------------------------
  # ● Dispose Sprite Weather EX
  #--------------------------------------------------------------------------      
  def dispose_sprite_weather_ex
      return if self.bitmap == nil
      self.bitmap.dispose
      self.bitmap = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Pre Values
  #--------------------------------------------------------------------------    
  def pre_values(index)
      return if  $game_temp.weather_ex_set[index] == nil
      self.x = $game_temp.weather_ex_set[index][0]
      self.y = $game_temp.weather_ex_set[index][1]
      self.opacity = $game_temp.weather_ex_set[index][2]
      self.angle = $game_temp.weather_ex_set[index][3]
      self.zoom_x = $game_temp.weather_ex_set[index][4]
      self.zoom_y = $game_temp.weather_ex_set[index][4]
      $game_temp.weather_ex_set[index].clear
      $game_temp.weather_ex_set[index] = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Type Setup
  #--------------------------------------------------------------------------      
  def type_setup(nx = 0, ny = 0)
      @cw2 = [(672 + @cw) + nx, -(96 + @cw) + nx]
      @ch2 = [(576 + @ch) + ny, -(96 + @ch) + ny]
      check_weather_type
      pre_values(@index)
      @opacity_speed = -1 if $game_temp.weather_fade
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------    
  def update_weather(nx = 0, ny = 0)
      self.x += @x_speed
      self.y += @y_speed
      self.opacity += @opacity_speed
      self.angle += @angle_speed
      self.zoom_x += @zoom_speed
      self.zoom_y += @zoom_speed
      check_loop_map(nx,ny)
      type_setup(nx,ny) if can_reset_setup?
  end  

  #--------------------------------------------------------------------------
  # ● Check Loop Map
  #--------------------------------------------------------------------------        
  def check_loop_map(nx,ny)
      if (@old_nx - nx).abs > 32
         @cw2 = [(672 + @cw) + nx, -(96 + @cw) + nx]
         self.x += nx
         self.x -= @old_nx if nx == 0
      end   
      if (@old_ny - ny).abs > 32
         @ch2 = [(576 + @ch) + ny, -(96 + @ch) + ny]
         self.y += ny
         self.y -= @old_ny if ny == 0
      end         
      @old_nx = nx
      @old_ny = ny    
  end  
    
  #--------------------------------------------------------------------------
  # ● Can Reset Setup
  #--------------------------------------------------------------------------      
  def can_reset_setup?
      return true if self.x > @cw2[0] or self.x <  @cw2[1]
      return true if self.y > @ch2[0]  or self.y < @ch2[1] 
      return true if self.opacity == 0
      return true if self.zoom_x > 2.0 or self.zoom_x < 0.5 
      return false
  end
  
 #--------------------------------------------------------------------------
 # ● Check Weather Type
 #--------------------------------------------------------------------------                         
 def check_weather_type 
     case @type
         when 0;   rain
         when 1;   wind   
         when 2;   fog
         when 3;   light
         when 4;   snow
         when 5;   spark
         when 6;   random                  
      end
 end
    
 #--------------------------------------------------------------------------
 # ● Snow
 #--------------------------------------------------------------------------                          
 def snow
     self.angle = rand(360)
     self.x = rand(@cw2[0])
     self.y = rand(@ch2[0])
     self.opacity = 1
     self.zoom_x = (rand(100) + 50) / 100.0
     self.zoom_y = self.zoom_x
     @y_speed = [[rand(5), 1].max, 5].min
     @opacity_speed = 5
     @angle_speed = rand(3)
 end   
 
 #--------------------------------------------------------------------------
 # ● Spark
 #--------------------------------------------------------------------------                           
 def spark
     self.angle = rand(360)
     self.x = rand(@cw2[0])
     self.y = rand(@ch2[0])
     self.opacity = 1
     self.zoom_x = (rand(100) + 100) / 100.0
     self.zoom_y = self.zoom_x
     self.blend_type = 1     
     @opacity_speed = 10
     @zoom_speed = -0.01
 end
 
 #--------------------------------------------------------------------------
 # ● Rain
 #--------------------------------------------------------------------------                          
 def rain
     self.x = rand(@cw2[0])       
     if @start == nil
        self.y = rand(@ch2[0]) 
        @start = true
     else
        self.y = @ch2[1]        
     end   
     self.opacity = 1
     self.zoom_y = (rand(50) + 100) / 100.0
     self.zoom_x = (rand(25) + 100) / 100.0
     @y_speed = [[rand(10) + 10, 10].max, 20].min
     @opacity_speed = 10
 end    
 
 #--------------------------------------------------------------------------
 # ● Fog
 #--------------------------------------------------------------------------                            
 def fog
     rand_angle = rand(2)
     self.angle = rand_angle == 1 ? 180 : 0
     self.x = rand(@cw2[0])
     self.y = rand(@ch2[0])
     self.opacity = 1
     self.zoom_x = (rand(100) + 50) / 100.0
     self.zoom_y = self.zoom_x
     @x_speed = [[rand(10), 1].max, 10].min
     @opacity_speed = 10
 end
 
 #--------------------------------------------------------------------------
 # ● Light
 #--------------------------------------------------------------------------                           
 def light 
     self.angle = rand(360)
     self.x = rand(@cw2[0])
     self.y = rand(@ch2[0])
     self.opacity = 1
     self.zoom_x = (rand(100) + 50) / 100.0
     self.zoom_y = self.zoom_x
     self.blend_type = 1
     @angle_speed = [[rand(3), 1].max, 3].min
     @y_speed = -[[rand(10), 1].max, 10].min
     @opacity_speed = 2
 end
 
 #--------------------------------------------------------------------------
 # ● Wind
 #--------------------------------------------------------------------------                          
 def wind
     self.angle = rand(360)
     self.x = rand(@cw2[0])
     self.y = rand(@ch2[0])
     self.opacity = 1
     self.zoom_x = (rand(100) + 50) / 100.0
     self.zoom_y = self.zoom_x
     @x_speed = [[rand(10), 1].max, 10].min
     @y_speed = [[rand(10), 1].max, 10].min
     @opacity_speed = 10
 end   
      
 #--------------------------------------------------------------------------
 # ● Random
 #--------------------------------------------------------------------------                          
 def random
     self.angle = rand(360)
     self.x = rand(@cw2[0])
     self.y = rand(@ch2[0])
     self.opacity = 1
     self.zoom_x = (rand(100) + 50) / 100.0
     self.zoom_y = self.zoom_x
     x_s = [[rand(10), 1].max, 10].min
     y_s = [[rand(10), 1].max, 10].min
     rand_x = rand(2)
     rand_y = rand(2)
     @x_speed = rand_x == 1 ? x_s : -x_s
     @y_speed = rand_y == 1 ? y_s : -y_s      
     @opacity_speed = 10
 end    
 
end

#==============================================================================
# ■ Module Weather EX
#==============================================================================
module Module_Weather_EX
  
 #--------------------------------------------------------------------------
 # ● Create Weather EX
 #--------------------------------------------------------------------------                   
  def create_weather_ex
      dispose_weather_ex
      create_weather_viewport
      create_weather_sprite     
  end
  
 #--------------------------------------------------------------------------
 # ● Dispose Wheater EX
 #--------------------------------------------------------------------------                     
  def dispose_weather_ex
      dispose_weather_ex_sprite
      dispose_weather_ex_viewport
  end  
 
 #--------------------------------------------------------------------------
 # ● Create Weather Viewport
 #--------------------------------------------------------------------------                     
  def create_weather_viewport
      dispose_weather_ex_viewport
      @viewport_weather_ex = Viewport.new(-32, -32, 576, 448)
      @viewport_weather_ex.z = MOG_WEATHER_EX::WEATHER_SCREEN_Z
      @viewport_weather_ex.ox = ($game_map.display_x * 32)
      @viewport_weather_ex.oy = ($game_map.display_y * 32)      
  end  

 #--------------------------------------------------------------------------
 # ● Create Weather Sprite
 #--------------------------------------------------------------------------                       
  def create_weather_sprite
      dispose_weather_ex_sprite
      @old_weather = $game_system.weather
      return if $game_system.weather == [] or $game_system.weather[0] == -1
      @weather_ex = []
      index = 0
      power_efic = MOG_WEATHER_EX::WEATHER_POWER_EFIC
      power_efic = 1 if power_efic < 1
      power = [[$game_system.weather[1] * power_efic, power_efic].max, 999].min
      for i in 0...power
          @weather_ex.push(Weather_EX.new(@viewport_weather_ex,$game_system.weather[0],$game_system.weather[2],index, @viewport_weather_ex.ox, @viewport_weather_ex.oy))
          index += 1
      end            
  end

 #--------------------------------------------------------------------------
 # ● Dispose Weather EX Viewport 
 #--------------------------------------------------------------------------                       
  def dispose_weather_ex_viewport
      return if @viewport_weather_ex == nil 
      @viewport_weather_ex.dispose
  end  
  
 #--------------------------------------------------------------------------
 # ● Dispose Weather EX
 #--------------------------------------------------------------------------                   
  def dispose_weather_ex_sprite
      return if @weather_ex == nil
      index = 0
      for i in @weather_ex
          $game_temp.weather_ex_set[index] = [] if $game_temp.weather_ex_set[index] == nil
          $game_temp.weather_ex_set[index].push(i.x,i.y,i.opacity,i.angle,i.zoom_x)
          i.dispose
          index += 1
      end
      @weather_ex.each {|sprite| sprite.dispose}  
      @weather_ex.clear
      @weather_ex = nil
  end
  
 #--------------------------------------------------------------------------
 # ● Dispose Refresh
 #--------------------------------------------------------------------------                    
  def dispose_refresh
      $game_temp.weather_ex_set.clear
      return if @weather_ex == nil
      @weather_ex.each {|sprite| sprite.dispose}
      @weather_ex.clear
      @weather_ex = nil
  end  
  
 #--------------------------------------------------------------------------
 # ● Update Weather EX
 #--------------------------------------------------------------------------                   
  def update_weather_ex
      refresh_weather_ex
      update_weather_ex_viewport
      return if @weather_ex == nil
      @weather_ex.each {|sprite| sprite.update_weather(@viewport_weather_ex.ox,@viewport_weather_ex.oy)} 
  end
  
 #--------------------------------------------------------------------------
 # ● Update Weather Ex Viewport
 #--------------------------------------------------------------------------                     
  def update_weather_ex_viewport
      return if @viewport_weather_ex == nil
      @viewport_weather_ex.ox = ($game_map.display_x * 32)
      @viewport_weather_ex.oy = ($game_map.display_y * 32)
  end
 
 #--------------------------------------------------------------------------
 # ● Refresh Weather EX
 #--------------------------------------------------------------------------                     
  def refresh_weather_ex
      return if @old_weather == nil
      return if @old_weather == $game_system.weather
      dispose_refresh
      create_weather_sprite
  end  
end  

#==============================================================================
# ■ Spriteset Map
#==============================================================================
class Spriteset_Map 
   include Module_Weather_EX  
   
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                   
  alias mog_weather_ex_initialize initialize 
  def initialize          
      dispose_weather_ex    
      mog_weather_ex_initialize
      create_weather_ex
  end

 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------                   
  alias mog_weather_ex_dispose dispose
  def dispose
      dispose_weather_ex    
      mog_weather_ex_dispose
  end  

 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------                   
  alias mog_weather_ex_update update
  def update
      mog_weather_ex_update
      update_weather_ex
  end  
    
end



if MOG_WEATHER_EX::WEATHER_BATTLE 
#==============================================================================
# ■ Spriteset Battle
#==============================================================================
class Spriteset_Battle  
  
   include Module_Weather_EX  
   
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                   
  alias mog_weather_ex_initialize initialize 
  def initialize          
      dispose_weather_ex    
      mog_weather_ex_initialize
      create_weather_ex
  end

 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------                   
  alias mog_weather_ex_dispose dispose
  def dispose
      dispose_weather_ex    
      mog_weather_ex_dispose
  end  

 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------                   
  alias mog_weather_ex_update update
  def update
      mog_weather_ex_update
      update_weather_ex
  end   
    
end

end

#=============================================================================
# ■ Scene Base
#=============================================================================
class Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Weather Recover Data
  #--------------------------------------------------------------------------  
  def weather_recover_data
      if $game_system.weather.empty? or 
          $game_system.weather[0] == -1 
          if !$game_system.weather_restore.empty? and 
             $game_system.weather_restore[0] != -1
             v = $game_system.weather_restore
             $game_system.weather = [v[0],v[1],v[2]]
          end
      end         
  end
  
  #--------------------------------------------------------------------------
  # ● Weather Restore
  #--------------------------------------------------------------------------       
  def weather_recover_scene
      return if $game_system.weather_temp.empty?
      return if $game_system.weather_temp[0] == -1
      w = $game_system.weather_temp
      $game_system.weather = [w[0],w[1],w[2]]
      $game_system.weather_temp.clear
      $game_system.weather_temp = [-1,0,""]
  end  
 
  #--------------------------------------------------------------------------
  # ● Main
  #--------------------------------------------------------------------------         
  alias mog_weather_ex_main main
  def main
      dispose_weather_ex_base
      weather_recover_scene if can_recover_weather_scene?
      mog_weather_ex_main
  end    
  
  #--------------------------------------------------------------------------
  # ● Can Recover Weather Scene
  #--------------------------------------------------------------------------         
  def can_recover_weather_scene?
      return true if SceneManager.scene_is?(Scene_Map)
      return true if SceneManager.scene_is?(Scene_Battle)
      return false
  end  
  
  #--------------------------------------------------------------------------
  # ● terminate
  #--------------------------------------------------------------------------         
  alias mog_weather_ex_terminate_base terminate
  def terminate
      mog_weather_ex_terminate_base
      dispose_weather_ex_base      
  end  

  #--------------------------------------------------------------------------
  # ● Dispose Weather EX Base
  #--------------------------------------------------------------------------           
  def dispose_weather_ex_base
      return if @spriteset == nil
      @spriteset.dispose_weather_ex rescue nil
  end        
  
end

#=============================================================================
# ■ Scene Load
#=============================================================================
class Scene_Load < Scene_File
  
  #--------------------------------------------------------------------------
  # ● On Load Success
  #--------------------------------------------------------------------------
  alias mog_weather_ex_on_load_success on_load_success
  def on_load_success
      mog_weather_ex_on_load_success
      weather_recover_data
  end
end

#=============================================================================
# ■ Scene Manager
#=============================================================================
class << SceneManager
  
  #--------------------------------------------------------------------------
  # ● Call
  #--------------------------------------------------------------------------         
  alias mog_weather_ex_call call
  def call(scene_class)
      weather_dispose
      mog_weather_ex_call(scene_class)
  end
  
  #--------------------------------------------------------------------------
  # ● Weather Restore
  #--------------------------------------------------------------------------       
  def weather_dispose
      return if $game_system.weather.empty?
      return if $game_system.weather[0] == -1
      w = $game_system.weather
      $game_system.weather_temp = [w[0],w[1],w[2]]
      $game_system.weather.clear
      $game_system.weather = [-1,0,""]
  end    
  
end

$mog_rgss3_weather_ex = true