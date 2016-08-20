#==============================================================================
# +++ MOG - Touhou Map Name (v1.4) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Sistema animado que apresenta o nome do mapa no estilo Touhou.
#==============================================================================
# Serão necessários as seguintes imagens na pasta Graphics/System/
#
# Map_Name_Particle.png
# Map_Name_Layout.png
#
#==============================================================================
# Use o código abaixo para ativar o script.
#
# $game_temp.mapname = true
#
#==============================================================================
#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 1.4 - Melhoria na codificação.
#==============================================================================

module MOG_TOUHOU_MAP_NAME
  # Posição geral da hud.
  MAP_NAME_POSITION = [272,192]
  # Posição das letras.
  MAP_NAME_WORD_POSITION = [-30,18]
  # Posição das particulas.
  MAP_NAME_PARTICLE_POSITION = [-100,-50]
  # Prioridade da hud.
  MAP_NAME_Z = 50
  # Ativar o nome do mapa automaticamente.
  MAP_NAME_AUTOMATIC = false
end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp

 attr_accessor :mapname_conf
 attr_accessor :mapname_layout_conf
 attr_accessor :mapname_duration
 attr_accessor :mapname
 
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                   
  alias mog_map_name_initialize initialize
  def initialize
      @mapname_conf = [] 
      @mapname_layout_conf = []
      @mapname_duration = [false,-1,2]
      @mapname = false
      mog_map_name_initialize
  end  
end

#==============================================================================
# ■ Game Player
#==============================================================================
class Game_Player < Game_Character  

 #--------------------------------------------------------------------------
 # ● Perform Transfer
 #--------------------------------------------------------------------------                     
  alias mog_touhou_map_name_perform_transfer perform_transfer
  def perform_transfer
      m_id = $game_map.map_id
      mog_touhou_map_name_perform_transfer
      if MOG_TOUHOU_MAP_NAME::MAP_NAME_AUTOMATIC
         if m_id != $game_map.map_id and $game_map.display_name != ""
            $game_temp.mapname = true
         end
      end    
  end

end  

#==============================================================================
# ■ Map Name
#==============================================================================
class Map_Name < Sprite
  include MOG_TOUHOU_MAP_NAME
  
  attr_reader   :letter
  attr_reader   :turn
  attr_reader   :animation_duration
  attr_reader   :text_duration
  attr_reader   :duration

 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                 
  def initialize(letter,x,y, zoom, opac,duration, animation_dutation, text_duration,turn, center_x, viewport = nil)      
      super(viewport)
      @letter = letter
      @turn = turn
      @duration = duration
      @animation_duration = animation_dutation
      @animation_duration2 = animation_dutation
      @text_duration = text_duration
      self.bitmap = Bitmap.new(32,32)
      self.bitmap.font.size = 32
      self.bitmap.font.bold = true
      self.bitmap.font.italic = true
      self.bitmap.draw_text(0,0, 32, 32, @letter.to_s,0)
      self.z = 999
      self.zoom_x = zoom
      self.zoom_y = zoom
      self.ox =  -100
      self.oy =  -100
      self.x = x 
      self.y = y
      self.z = MAP_NAME_Z + 2
      self.opacity = opac
  end  
  
 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------               
  def dispose_word
      return if self.bitmap == nil
      self.bitmap.dispose
      self.bitmap = nil
  end  
  
 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------               
  def update
      super
      update_animation
  end
      
 #--------------------------------------------------------------------------
 # ● Update Animation
 #--------------------------------------------------------------------------                 
  def update_animation
      @animation_duration -= 1 if @animation_duration > 0
      return if @animation_duration > 0 
      if self.zoom_x > 1
         self.zoom_x -= 0.06
         self.x += 5
         self.y += 6        
         self.opacity += 35
         self.zoom_y = self.zoom_x
         if self.zoom_x <= 1
            self.zoom_x = 1
            self.zoom_y = self.zoom_x
            self.opacity = 255
            @text_duration = @duration - @animation_duration2
         end       
       else
          @text_duration -= 1
       end
  end
      
end

#==============================================================================
# ■ Particle_Name_Map
#==============================================================================
class Particle_Name_Map < Sprite
  
  include MOG_TOUHOU_MAP_NAME
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------             
  def initialize(viewport = nil,x,y,ax,ay)
      super(viewport)
      self.bitmap = Cache.system("Map_Name_Particle")
      @pos = [x + self.bitmap.width,y - self.bitmap.height]
      @area = [ax - (self.bitmap.width * 4),ay - self.bitmap.height]
      reset_setting
  end  
  
 #--------------------------------------------------------------------------
 # ● Reset Setting
 #--------------------------------------------------------------------------               
  def reset_setting
      zoom = (50 + rand(100)) / 100.1
      self.zoom_x = zoom
      self.zoom_y = zoom
      self.x = @pos[0] + rand(@area[0])
      self.y = @pos[1] + rand(@area[1])
      self.z = MAP_NAME_Z + 1
      self.opacity = 0
      self.angle = rand(360)
      self.blend_type = 0
      @speed_x = 0
      @speed_y = [[rand(4), 4].min, 1].max
      @speed_a = rand(3)
      @fade_y = @pos[1] + 32
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
      self.y -= @speed_y
      self.opacity -= self.y > @fade_y ? -8 : 5
      reset_setting if self.y < 0
  end  
  
 #--------------------------------------------------------------------------
 # ● Update Fade
 #--------------------------------------------------------------------------               
  def update_fade
      self.y -= @speed_y
      self.opacity -= 5
  end    
  
end

#==============================================================================
# ■ Spriteset Map
#==============================================================================
class Spriteset_Map
 
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                 
  alias mog_mapname_initialize initialize
  def initialize
      mog_mapname_initialize
      create_touhou_map_name
  end  
  
 #--------------------------------------------------------------------------
 # ● Create Touhou Map Name
 #--------------------------------------------------------------------------                   
 def create_touhou_map_name
     return if @th_map != nil
     @th_map = Touhou_Map_Sprites.new
 end
  
 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------                 
  alias mog_th_mapname_dispose dispose 
  def dispose
      mog_th_mapname_dispose
      dispose_touhou_map_name
  end   
  
 #--------------------------------------------------------------------------
 # ● Dispose Touhou Map Name
 #--------------------------------------------------------------------------                   
  def dispose_touhou_map_name
      return if @th_map == nil
      @th_map.dispose
      @th_map = nil
  end
  
 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------                 
  alias mog_th_mapname_update update
  def update
      mog_th_mapname_update
      update_touhou_map_name
  end    
  
 #--------------------------------------------------------------------------
 # ● Update Touhou Map Name
 #--------------------------------------------------------------------------                   
  def update_touhou_map_name
      return if @th_map == nil
      @th_map.update
  end
  
end

#==============================================================================
# ■ Touhou Map Sprites
#==============================================================================
class Touhou_Map_Sprites
 include MOG_TOUHOU_MAP_NAME
 
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                 
  def initialize
      @vis_time = 0
      @vis = map_name_visible?
      dispose
      create_map_name
      create_map_namelayout
      create_light      
  end
  
 #--------------------------------------------------------------------------
 # ● Create Map Name
 #--------------------------------------------------------------------------                 
  def create_map_name
      return if $game_temp.mapname_duration[2] > 0
      @map_name.each {|sprite| sprite.dispose_word} if @map_name != nil
      @map_name = [] 
      mapname = $game_map.display_name
      m_name = mapname.to_s.split(//)
      index = 0
      turn = 0
      duration = 20 * mapname.size      
      center_x = 10 * mapname.size
      $game_temp.mapname_duration[1] = (duration) + 64 if $game_temp.mapname_duration[1] <= 0
      x2 = (-170 + MAP_NAME_POSITION[0] + MAP_NAME_WORD_POSITION[0]) - center_x
      y2 = -170 + MAP_NAME_POSITION[1] + MAP_NAME_WORD_POSITION[1]
      if $game_temp.mapname_conf == [] 
         for i in m_name
             @map_name.push(Map_Name.new(i[0],(index * 20) + x2,y2,1.8,0,duration, 20 * index,0,turn,center_x))
             index += 1
             turn = turn == 0 ? 1 : 0
         end 
      else
         c = $game_temp.mapname_conf   
         for i in 0...c.size
             @map_name.push(Map_Name.new(c[index][0],c[index][1],c[index][2],c[index][3],c[index][4],c[index][5],c[index][6],c[index][7],turn,0))
             index += 1
             turn = turn == 0 ? 1 : 0 
         end        
      end
  end
  
 #--------------------------------------------------------------------------
 # ● Create Map Name Layout
 #--------------------------------------------------------------------------                   
 def create_map_namelayout
     return if $game_temp.mapname_duration[2] > 1
     if @map_name_layout != nil
        @map_name_layout.bitmap.dispose
        @map_name_layout.dispose
        @map_name_layout = nil
     end  
     @map_name_layout = Sprite.new
     @map_name_layout.bitmap = Cache.system("Map_Name_Layout.png")
     @map_name_layout.z = MAP_NAME_Z
     @map_name_org_position = [MAP_NAME_POSITION[0] - (@map_name_layout.bitmap.width / 2),MAP_NAME_POSITION[1] - (@map_name_layout.bitmap.height / 2)]
     if $game_temp.mapname_layout_conf == []
        @map_name_layout.x = @map_name_org_position[0] + 100
        @map_name_layout.y = @map_name_org_position[1]
        @map_name_layout.opacity = 0
     else
        @map_name_layout.x = $game_temp.mapname_layout_conf[0]
        @map_name_layout.y = $game_temp.mapname_layout_conf[1]
        @map_name_layout.opacity = $game_temp.mapname_layout_conf[2]
     end
 end  
 
  #--------------------------------------------------------------------------
  # ● Create Light
  #--------------------------------------------------------------------------  
  def create_light
      return if $game_temp.mapname_duration[2] > 1    
      x = MAP_NAME_POSITION[0] + MAP_NAME_PARTICLE_POSITION[0]
      y = MAP_NAME_POSITION[1] + MAP_NAME_PARTICLE_POSITION[1]    
      @particle_name =[]
      ax = @map_name_layout.bitmap.width - 32
      ay = @map_name_layout.bitmap.height - 32
      for i in 0...15
          @particle_name.push(Particle_Name_Map.new(nil,x,y,ax,ay))
      end  
  end 
 
 #--------------------------------------------------------------------------
 # ● Map Name Clear
 #--------------------------------------------------------------------------                   
 def map_name_clear
     @map_name.each {|sprite| sprite.dispose_word} if @map_name != nil
     @map_name = nil
     $game_temp.mapname_duration[0] = false
     $game_temp.mapname_duration[1] = -1
     $game_temp.mapname_conf.clear
     $game_temp.mapname_layout_conf.clear     
 end   
 
 #--------------------------------------------------------------------------
 # ● Layout Clear
 #--------------------------------------------------------------------------                         
  def layout_clear
      return if @map_name_layout == nil
      @map_name_layout.bitmap.dispose
      @map_name_layout.dispose
      @map_name_layout = nil
      $game_temp.mapname_layout_conf.clear
  end 
   
 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------                 
  def dispose
      dispose_map_name_word
      dispose_map_name_layout
      dispose_map_name_particle
  end  
  
 #--------------------------------------------------------------------------
 # ● Dispose Map Mame Layout
 #--------------------------------------------------------------------------                     
 def dispose_map_name_layout
     return if @map_name_layout == nil
     $game_temp.mapname_layout_conf[0] = @map_name_layout.x
     $game_temp.mapname_layout_conf[1] = @map_name_layout.y
     $game_temp.mapname_layout_conf[2] = @map_name_layout.opacity
     @map_name_layout.bitmap.dispose
     @map_name_layout.dispose
 end      
     
 #--------------------------------------------------------------------------
 # ● Particle_Name Clear
 #--------------------------------------------------------------------------                         
  def dispose_map_name_particle
      return if @particle_name == nil
      @particle_name.each {|sprite| sprite.dispose} 
      @particle_name = nil         
  end 
 
 #--------------------------------------------------------------------------
 # ● Dispose Map Mame Word
 #--------------------------------------------------------------------------                     
 def dispose_map_name_word
     return if @map_name == nil
     index = 0
     for i in @map_name
         if $game_temp.mapname_conf[index] == nil
            $game_temp.mapname_conf[index] = ["",0,0,0,0,0,0,0,0]
         end  
         $game_temp.mapname_conf[index][0] = i.letter
         $game_temp.mapname_conf[index][1] = i.x
         $game_temp.mapname_conf[index][2] = i.y
         $game_temp.mapname_conf[index][3] = i.zoom_x
         $game_temp.mapname_conf[index][4] = i.opacity           
         $game_temp.mapname_conf[index][5] = i.duration  
         $game_temp.mapname_conf[index][6] = i.animation_duration
         $game_temp.mapname_conf[index][7] = i.text_duration
         i.dispose_word
         index += 1
     end
     @map_name.each {|sprite| sprite.dispose_word}
     @map_name = nil
 end
      
 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------                 
  def update
      refresh_map_name 
      dispose_map_name_time
      update_word
      update_map_name_layout
  end  
  
 #--------------------------------------------------------------------------
 # ● Map Name Visible?
 #--------------------------------------------------------------------------                    
  def map_name_visible?
      return false if !SceneManager.scene_is?(Scene_Map)
      return false if @vis_time > 0
      return true
  end
  
 #--------------------------------------------------------------------------
 # ● Refresh Map Name
 #--------------------------------------------------------------------------                   
  def refresh_map_name
      return unless $game_temp.mapname
      $game_temp.mapname = false
      map_name_clear
      layout_clear
      dispose_map_name_particle
      $game_temp.mapname_duration[2] = 0      
      create_map_name
      create_map_namelayout
      create_light
  end  
  
 #--------------------------------------------------------------------------
 # ● Update Light
 #--------------------------------------------------------------------------              
 def update_light
     return if @particle_name == nil
     for sprite in @particle_name
         sprite.update
         sprite.visible = @vis
     end  
 end
      
 #--------------------------------------------------------------------------
 # ● Update Fade ight
 #--------------------------------------------------------------------------              
 def update_fade_light
     return if @particle_name == nil
     @particle_name.each {|sprite| sprite.update_fade}      
 end  
 
 #--------------------------------------------------------------------------
 # ● Update Map Name Layout
 #--------------------------------------------------------------------------                     
  def update_map_name_layout
      return if @map_name_layout == nil
      @vis = map_name_visible?
      if !@vis
         @vis_time = 1
      else
         @vis_time -= 1 if @vis_time > 0
      end  
      @map_name_layout.visible = @vis
      if @map_name != nil
         @map_name_layout.opacity += 5
         update_light
         if @map_name_layout.x > @map_name_org_position[0]
            @map_name_layout.x -= 1
         end  
      else
         @map_name_layout.x -= 2 
         @map_name_layout.opacity -= 8
         update_fade_light
         if @map_name_layout.opacity <= 0
            layout_clear 
            dispose_map_name_particle
            $game_temp.mapname_duration[2] = 2
         end   
      end
  end
  
 #--------------------------------------------------------------------------
 # ● Update Word
 #--------------------------------------------------------------------------                     
  def update_word
      return if @map_name == nil       
      for map_sprite in @map_name
          map_sprite.update 
          map_sprite.visible = @vis
      end  
  end  
  
 #--------------------------------------------------------------------------
 # ● Dispose Map Name Time
 #--------------------------------------------------------------------------                       
  def dispose_map_name_time
      if $game_temp.mapname_duration[1] > 0
         $game_temp.mapname_duration[1] -= 1 
         return
      end   
      return if $game_temp.mapname_duration[1] < 0
      map_name_clear
      $game_temp.mapname_duration[2] = 1
  end  
    
end

$mog_rgss3_touhou_map_name = true