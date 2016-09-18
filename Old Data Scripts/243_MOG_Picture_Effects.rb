#==============================================================================
# +++ MOG - Picture Effects (v1.0) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# O script adicina novos efeitos na função mostrar imagem, possibilitando 
# criar animações complexas de maneira simples e rápida.
# O script também adiciona a função definir a posição da imagem baseado 
# na posição do character ou na posição real XY da tela.
#==============================================================================
# EFEITOS
#==============================================================================
# 0 - Tremer Tipo A
# 1 - Tremer Tipo B
# 2 - Efeito de Respirar
# 3 - Efeito de Auto Zoom (Loop)
# 4 - Efeito de Fade (Loop)
# 5 - Efeito de Rolar em duas direções.
# 6 - Efeito de Wave.
# 7 - Efeito de Animação por frames, estilo GIF.
#
# É possível utilizar todos os efeitos ao mesmo tempo.
#
#==============================================================================
# UTILIZAÇÃO
#==============================================================================
# Use o comando abaixo através do comando evento.
#
# picture_effect(PICTURE_ID ,EFFECT_TYPE ,POWER , SPEED)
#
# PICTURE_ID = ID da imagem.
# EFFECT TYPE = Tipo de efetio da imagem. (0 a 7)
# POWER = Poder do efeito. 
# SPEED = Velocidade do efeito.
#
# Exemplo
#
# picture_effect(1,5,10,50)
#
#==============================================================================
# Efeito de animação por frames. (Efeito tipo 7)
#==============================================================================
# Para ativar o efeito de animação por frames é necessário ter e nomear os
# arquivos da seguinte forma.
#
# Picture_Name.png  (A imagem que deve ser escolhida no comando do evento.)
# Picture_Name0.png
# Picture_Name1.png
# Picture_Name2.png
# Picture_Name3.png
# Picture_Name4.png
# ...
#
#==============================================================================
# Posições Especiais para as imagens
#==============================================================================
# Use o comando abaixo para definir a posiçao da imagem.
#
# picture_position(PICTURE ID, TARGET ID)
#
# PICTURE ID = ID da imagem
# TARGET ID = ID do alvo
#
# 0        = Posição normal. 
# 1..999   = Posição do evento (ID).
# -1       = Posição do player.
# -2       = Posição fixa da imagem.
#
#==============================================================================
# Cancelar o Efeito
#==============================================================================
# Você pode usar o comando apagar imagem do evento, ou usar o comando abaixo.
#
# picture_effects_clear(PICTURE_ID)
#
#==============================================================================
module MOG_PICURE_EFFECTS
  # Definição da posição Z das pictures. 
  # É possível usar o comando "set_picture_z(value)" para mudar o valor Z
  # no meio do jogo
  DEFAULT_SCREEN_Z = 100
end

$imported = {} if $imported.nil?
$imported[:mog_picture_effects] = true

#==============================================================================
# ■ Game Picture
#==============================================================================
class Game_Picture
  attr_accessor :effect_ex
  attr_accessor :anime_frames
  attr_accessor :position
  
  #--------------------------------------------------------------------------
  # ● Init Basic
  #--------------------------------------------------------------------------
  alias mog_picture_ex_init_basic init_basic
  def init_basic
      init_effect_ex
      mog_picture_ex_init_basic
  end

  #--------------------------------------------------------------------------
  # ● Erase
  #--------------------------------------------------------------------------
  alias mog_picture_ex_erase erase
  def erase
      init_effect_ex
      mog_picture_ex_erase
  end

  #--------------------------------------------------------------------------
  # ● Init Effect EX
  #--------------------------------------------------------------------------
  def init_effect_ex
      @effect_ex = [] ; @anime_frames = [] ; @position = [0,nil,0,0]
  end
    
end

#==============================================================================
# ■ Game System
#==============================================================================
class Game_System
  attr_accessor :picture_screen_z

  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  alias mog_picture_ex_initialize initialize
  def initialize
      @picture_screen_z = MOG_PICURE_EFFECTS::DEFAULT_SCREEN_Z
      mog_picture_ex_initialize      
  end
  
end

#==============================================================================
# ■ Game Interpreter
#==============================================================================
class Game_Interpreter

  #--------------------------------------------------------------------------
  # ● Set Pictures
  #--------------------------------------------------------------------------
  def set_pictures
      return $game_troop.screen.pictures if SceneManager.scene_is?(Scene_Battle)
      return $game_map.screen.pictures if SceneManager.scene_is?(Scene_Map)
  end  

  #--------------------------------------------------------------------------
  # ● Picture Effect
  #--------------------------------------------------------------------------
  def picture_effect(id,type, power = nil,speed = nil,misc = nil)
      pictures = set_pictures
      return if pictures.nil?
      power = set_standard_power(type) if power == nil
      power = 1 if type == 4 and power < 1
      speed = set_standard_speed(type) if speed == nil
      pictures[id].effect_ex[0] = nil if type == 1
      pictures[id].effect_ex[1] = nil if type == 0
      pictures[id].effect_ex[type] = [power,speed,0]
      pictures[id].effect_ex[type] = [0,0,0,power * 0.00005,speed, 0,0] if [2,3].include?(type)
      pictures[id].effect_ex[type] = [255,0,0,255 / power, power,speed,0] if type == 4
      pictures[id].effect_ex[type] = [0,0,power,speed,0] if type == 5
      pictures[id].effect_ex[type] = [true,power * 10,speed * 100] if type == 6   
      pictures[id].anime_frames = [true,[],power,0,0,speed,0] if type == 7
  end

  #--------------------------------------------------------------------------
  # ● Set Standard Power
  #--------------------------------------------------------------------------
  def set_standard_power(type)
      return 6   if type == 2
      return 30  if type == 3
      return 120 if type == 4
      return 10
  end   
  
  #--------------------------------------------------------------------------
  # ● Set Standard Speed
  #--------------------------------------------------------------------------
  def set_standard_speed(type)
      return 3 if [0,1].include?(type)
      return 0 if [2,3,4].include?(type)
      return 2 if type == 5
      return 0 if type == 7
      return 10
  end  
    
  #--------------------------------------------------------------------------
  # ● Picture Position
  #--------------------------------------------------------------------------
  def picture_position(id,target_id)
      pictures = set_pictures
      return if pictures.nil?
      pictures[id].position = [0,nil,0,0] if [-2,0].include?(pictures[id].position[0])
      pictures[id].effect_ex.clear
      target = 0 ; target = $game_player if target_id == -1
      if target_id > 0
      $game_map.events.values.each do |e| target = e if e.id == target_id end
      end
      pictures[id].position[0] = target_id
      pictures[id].position[1] = target
  end  
 
  #--------------------------------------------------------------------------
  # ● Set Picture Z
  #--------------------------------------------------------------------------
  def set_picture_z(value)
      $game_system.picture_screen_z = value
  end
    
  #--------------------------------------------------------------------------
  # ● Picture Effects Clear
  #--------------------------------------------------------------------------
  def picture_effects_clear(id)
      pictures = set_pictures
      return if pictures.nil?
      pictures[id].effect_ex.clear ; pictures[id].anime_frames.clear
      pictures[id].position = [0,nil,0,0]
  end    
  
end

#==============================================================================
# ■ Game Map
#==============================================================================
class Game_Map
  
  #--------------------------------------------------------------------------
  # ● Setup
  #--------------------------------------------------------------------------
  alias mog_picture_ex_setup setup
  def setup(map_id)
      mog_picture_ex_setup(map_id)
      clear_picture_position rescue  nil
  end
  
  #--------------------------------------------------------------------------
  # ● Clear Picture Position
  #--------------------------------------------------------------------------
  def clear_picture_position
      pictures = $game_troop.screen.pictures if SceneManager.scene_is?(Scene_Battle)
      pictures = $game_map.screen.pictures if SceneManager.scene_is?(Scene_Map)
      return if pictures == nil
      pictures.each {|p| 
      p.position = [-1000,nil,0,0] if p.position[0] > 0 or p.position[1] == nil}    
  end
  
end

#==============================================================================
# ■ Sprite Picture
#==============================================================================
class Sprite_Picture < Sprite  
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------
  alias mog_picture_ex_dispose dispose
  def dispose
      mog_picture_ex_dispose
      @picture.effect_ex[6][0] = true if @picture.effect_ex[6]
      @picture.anime_frames[0] = true if @picture.effect_ex[7]
      dispose_pic_frames if !@picture.effect_ex[7]
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Pic Frames
  #--------------------------------------------------------------------------
  def dispose_pic_frames
      return if @pic_frames.nil?
      @pic_frames.each {|picture| picture.dispose } ; @pic_frames = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Update Bitmap
  #--------------------------------------------------------------------------
  alias mog_picture_ex_update_bitmap update_bitmap
  def update_bitmap
      refresh_effect_ex if @old_name_ex != @picture.name
      if !@picture.anime_frames.empty? and self.bitmap
         update_picture_animation ; return 
      end
      mog_picture_ex_update_bitmap
      create_picture_animation if can_create_frame_picture?
      set_wave_effect if can_set_wave_effect?
  end
 
  #--------------------------------------------------------------------------
  # ● Refresh effect EX
  #--------------------------------------------------------------------------
  def refresh_effect_ex
     (self.wave_amp = 0 ; self.wave_length = 1 ; self.wave_speed = 0) if !@picture.effect_ex[6]
      @old_name_ex = @picture.name
      create_picture_animation if @picture.effect_ex[7]
      set_wave_effect if can_set_wave_effect? 
  end
  
  #--------------------------------------------------------------------------
  # ● Can Create Frame Picture
  #--------------------------------------------------------------------------
  def can_create_frame_picture?
      return false if !@picture.anime_frames[0]
      return false if !self.bitmap
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Update Picture Animation
  #--------------------------------------------------------------------------
  def update_picture_animation
      return if @pic_frames == nil
      if @picture.anime_frames[6] > 0 ; @picture.anime_frames[6] -= 1 ; return 
      end
      @picture.anime_frames[4] += 1
      return if @picture.anime_frames[4] < @picture.anime_frames[2]
      self.bitmap = @pic_frames[@picture.anime_frames[3]]
      @picture.anime_frames[4] = 0 ; @picture.anime_frames[3] += 1
      if @picture.anime_frames[3] >= @pic_frames.size  
         @picture.anime_frames[3] = 0 ; @picture.anime_frames[6] = @picture.anime_frames[5]
      end   
  end  
  
  #--------------------------------------------------------------------------
  # ● Create Picture Animation
  #--------------------------------------------------------------------------
  def create_picture_animation
      dispose_pic_frames ; @pic_frames = [] ; @picture.anime_frames[0] = false     
      for index in 0...999
          @pic_frames.push(Cache.picture(@picture.name + index.to_s)) rescue nil
          break if @pic_frames[index] == nil
      end
      if @pic_frames.size <= 1
         dispose_pic_frames ; @pic_frames = nil ; @picture.anime_frames.clear
         @picture.effect_ex[7] = nil ; return
      end  
      self.bitmap = @pic_frames[@picture.anime_frames[3]]
      update_picture_animation
  end
  
  #--------------------------------------------------------------------------
  # ● Update Position
  #--------------------------------------------------------------------------
  def update_position      
      self.z = @picture.number + $game_system.picture_screen_z
      if @picture.effect_ex[0] ; update_shake_effect(0) ; return ; end
      if @picture.effect_ex[1] ; update_shake_effect(1) ; return ; end  
      self.x = pos_x ; self.y = pos_y ; set_oxy_correction      
  end

  #--------------------------------------------------------------------------
  # ● Pos X
  #--------------------------------------------------------------------------
  def pos_x
      return @picture.x
  end
  
  #--------------------------------------------------------------------------
  # ● Pos Y
  #--------------------------------------------------------------------------
  def pos_y
      return @picture.y
  end

  #--------------------------------------------------------------------------
  # ● Set Oxy Correction
  #--------------------------------------------------------------------------
  def set_oxy_correction
      return if @picture.position[0] == -2
      self.x += self.ox if @picture.effect_ex[3] or @picture.effect_ex[5]
      self.y += self.oy if @picture.effect_ex[2] or @picture.effect_ex[3] or @picture.effect_ex[5]
  end
  
  #--------------------------------------------------------------------------
  # ● Update Position
  #--------------------------------------------------------------------------
  def update_shake_effect(type)
      @picture.effect_ex[type][2] += 1
      return if @picture.effect_ex[type][2] < @picture.effect_ex[type][1]
      @picture.effect_ex[type][2] = 0
      self.x = pos_x + shake_effect(type)
      self.y = @picture.effect_ex[1] ? pos_y + shake_effect(type) : pos_y
      set_oxy_correction
  end

  #--------------------------------------------------------------------------
  # ● Shake Effect
  #--------------------------------------------------------------------------
  def shake_effect(type)
      -(@picture.effect_ex[type][0] / 2) +  rand(@picture.effect_ex[type][0]) 
  end

  #--------------------------------------------------------------------------
  # ● Update Other
  #--------------------------------------------------------------------------
  def update_other
      if @picture.effect_ex[4] ; update_opacity_ex
      else ; self.opacity = @picture.opacity
      end
      self.blend_type = @picture.blend_type
      if @picture.effect_ex[5] ; update_angle_ex
      else ; self.angle = @picture.angle
      end   
      self.tone.set(@picture.tone)
  end  

  #--------------------------------------------------------------------------
  # ● Update Angle EX
  #--------------------------------------------------------------------------
  def update_angle_ex
      @picture.effect_ex[5][4] += 1
      return if @picture.effect_ex[5][4] < @picture.effect_ex[5][3]
      @picture.effect_ex[5][4] = 0 ; @picture.effect_ex[5][1] += 1
      case @picture.effect_ex[5][1]
        when 0..@picture.effect_ex[5][2]
             @picture.effect_ex[5][0] += 1
        when @picture.effect_ex[5][2]..(@picture.effect_ex[5][2] * 3)
             @picture.effect_ex[5][0] -= 1
        when (@picture.effect_ex[5][2] * 3)..(-1 + @picture.effect_ex[5][2] * 4)
             @picture.effect_ex[5][0] += 1
        else ; @picture.effect_ex[5][0] = 0 ; @picture.effect_ex[5][1] = 0
      end
      self.angle = @picture.angle + @picture.effect_ex[5][0]
  end
  
  #--------------------------------------------------------------------------
  # ● Update Opacity EX
  #--------------------------------------------------------------------------
  def update_opacity_ex
      @picture.effect_ex[4][6] += 1
      return if @picture.effect_ex[4][6] < @picture.effect_ex[4][5]
      @picture.effect_ex[4][6] = 0 ; @picture.effect_ex[4][2] += 1
      case @picture.effect_ex[4][2]
        when 0..@picture.effect_ex[4][4] 
          @picture.effect_ex[4][0] -= @picture.effect_ex[4][3]
        when @picture.effect_ex[4][4]..(-1 + @picture.effect_ex[4][4] * 2)
          @picture.effect_ex[4][0] += @picture.effect_ex[4][3]          
        else
          @picture.effect_ex[4][0] = 255 ; @picture.effect_ex[4][2] = 0
      end
      self.opacity = @picture.effect_ex[4][0]
  end
  
  #--------------------------------------------------------------------------
  # ● Update Origin
  #--------------------------------------------------------------------------
  def update_origin
      return if !self.bitmap
      if force_center_oxy?
         self.ox = @picture.effect_ex[2] ? n_ox : (bitmap.width / 2) + n_ox
         self.oy = (bitmap.height / 2) + n_oy
         if @picture.position[0] > 0 or @picture.position[0] == -1
            execute_move(0,@picture.position[2],-@picture.position[1].screen_x) rescue nil
            execute_move(1,@picture.position[3],-@picture.position[1].screen_y) rescue nil
         end  
         return
      end
      if @picture.effect_ex[2] ; self.oy = (bitmap.height + n_oy) ; return ; end
      if @picture.origin == 0
         self.ox = n_ox ; self.oy = n_oy
      else
         self.ox = (bitmap.width / 2) + n_ox 
         self.oy = (bitmap.height / 2) + n_oy
      end       
  end

  #--------------------------------------------------------------------------
  # ● Force Center Oxy
  #--------------------------------------------------------------------------
  def force_center_oxy?
      return false if @picture.position.empty?
      return true if @picture.position[0] == -1
      return true if @picture.position[0] > 0
      return true if @picture.effect_ex[3]
      return true if @picture.effect_ex[5]
      return false
  end
  
  #--------------------------------------------------------------------------
  # ● N Ox
  #--------------------------------------------------------------------------
  def n_ox
      return @picture.position[2] if @picture.position[0] > 0 and @picture.position[2]
      return @picture.position[2] if @picture.position[0] == -1 and @picture.position[2]
      return $game_map.display_x * 32 if @picture.position[0] == -2
      return 1000 if @picture.position[0] == -1000
      return 0
  end
  
  #--------------------------------------------------------------------------
  # ● N Oy
  #--------------------------------------------------------------------------
  def n_oy
      return @picture.position[3] if @picture.position[0] > 0 and @picture.position[3] 
      return @picture.position[3] if @picture.position[0] == -1 and @picture.position[3] 
      return $game_map.display_y * 32 if @picture.position[0] == -2
      return 1000 if @picture.position[0] == -1000
      return 0
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Move
  #--------------------------------------------------------------------------      
  def execute_move(type,cp,np)
      sp = 5 + ((cp - np).abs / 5)
      if cp > np ;    cp -= sp ; cp = np if cp < np
      elsif cp < np ; cp += sp ; cp = np if cp > np
      end     
      @picture.position[2] = cp if type == 0 
      @picture.position[3] = cp if type == 1
  end    
  
  #--------------------------------------------------------------------------
  # ● Update Zoom
  #--------------------------------------------------------------------------
  alias mog_picture_ex_update_zoom update_zoom
  def update_zoom
      if @picture.effect_ex[2] ;  update_breath_effect ; return ; end
      if @picture.effect_ex[3] ;  update_auto_zoom_effect ; return ; end
      mog_picture_ex_update_zoom
  end    
     
  #--------------------------------------------------------------------------
  # ● Update Breath Effect
  #--------------------------------------------------------------------------
  def update_breath_effect
      self.zoom_x = @picture.zoom_x / 100.0
      self.zoom_y = @picture.zoom_y / 101.0 + auto_zoom(2)
  end  

  #--------------------------------------------------------------------------
  # ● Update Auto Zoom Effect
  #--------------------------------------------------------------------------
  def update_auto_zoom_effect
      self.zoom_x = @picture.zoom_x / 100.0 + auto_zoom(3)
      self.zoom_y = @picture.zoom_y / 100.0 + auto_zoom(3)
  end
  
  #--------------------------------------------------------------------------
  # ● Auto Zoom
  #--------------------------------------------------------------------------
  def auto_zoom(type)
      if @picture.effect_ex[type][6] == 0
         @picture.effect_ex[type][6] = 1
         @picture.effect_ex[type][0] = rand(50)
      end
      if @picture.effect_ex[type][5] < @picture.effect_ex[type][4]
         @picture.effect_ex[type][5] += 1
         return @picture.effect_ex[type][1]
      end    
      @picture.effect_ex[type][5] = 0
      @picture.effect_ex[type][2] -= 1
      return @picture.effect_ex[type][1] if @picture.effect_ex[type][2] > 0
      @picture.effect_ex[type][2] = 2 ; @picture.effect_ex[type][0] += 1
      case @picture.effect_ex[type][0]
         when 0..25 ; @picture.effect_ex[type][1] += @picture.effect_ex[type][3]         
         when 26..60 ; @picture.effect_ex[type][1] -= @picture.effect_ex[type][3]
         else ; @picture.effect_ex[type][0] = 0 ; @picture.effect_ex[type][1] = 0
      end
      @picture.effect_ex[type][1] = 0 if @picture.effect_ex[type][1] < 0
      @picture.effect_ex[type][1] = 0.25 if @picture.effect_ex[type][1] > 0.25 if type == 2
      return @picture.effect_ex[type][1]
  end

  #--------------------------------------------------------------------------
  # ● Can Set Wave Effect?
  #--------------------------------------------------------------------------
  def can_set_wave_effect?
      return false if !@picture.effect_ex[6]
      return false if !@picture.effect_ex[6][0]
      return false if !self.bitmap
      return true
  end

  #--------------------------------------------------------------------------
  # ● Set Wave Effect
  #--------------------------------------------------------------------------
  def set_wave_effect 
      @picture.effect_ex[6][0] = false
      self.wave_amp = @picture.effect_ex[6][1]
      self.wave_length = self.bitmap.width
      self.wave_speed = @picture.effect_ex[6][2]
  end  
   
end