#==============================================================================
# +++ MOG - MUSIC ROOM  (v2.2) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Sistema que permite escutar as músicas tocadas durante o jogo.
#==============================================================================
#==============================================================================
# UTILIZAÇÃO
#
# 1 - Crie uma pasta com o nome MUSIC COVER
#     /Graphics/Music_Room/
# 
# 2 - Copie os seguintes arquivos contidos na Demo.
#     Layout.png
#     Layout2.png
#
#==============================================================================
# OPCIONAL
#
# Para adicionar imagens vinculadas as músicas nomeie a imagem da
# música com o mesmo nome do arquivo de música.
#
# Exemplo (eg)
# 
# Nome da música
# Theme5.MP3 (Ogg/mid/etc...)
#
# Nome do imagem
# Theme5.png
#
#==============================================================================
# Para chamar o script use o comando abaixo.
#
# music_room
#
#==============================================================================
# ● Version History
#==============================================================================
# 2.1 - Melhor codificação,
# 2.0 - Verificação da música direto no módulo de áudio, o que deixa
#       compátivel praticamente com todos os script que tocam música.
#     - Opção de ocultar determinadas músicas na lista músicas.
#     - Compatibilidade com resoluções maiores que o padrão normal.
#==============================================================================
module MOG_MUSIC_ROOM
  # Ocultar a música na lista.
  #
  # FORCE_HIDE_MUSIC = ["Battle3","Battle5","Ending"]
  #
  FORCE_HIDE_MUSIC = [] 
  # Ocultar músicas não disponíveis da lista.
  HIDE_UNAVAILABLE_MUSIC = true
  #Definição da informação da música apresentada na janela de ajuda.
  MUSIC_INFO = {  
    "Battle_Theme2" => "Battle Theme 2 (by Freedom House)",
    "Tales of the Abyss Final Battle Music" => "Tales of the Abyss Final Battle Music (by Bandai Namco)",
    "No Quarter" => "No Quarter (by McTricky)",
    
  }
  # Posição da janela da lista de músicas. 
  MUSIC_LIST_POSITION_TEXT = [0, 200]
  # Posição do layout da lista de músicas.
  MUSIC_LIST_POSITION_LAYOUT = [0, 195] 
  # Tempo para ocultar a janela de lista de músicas.
  MUSICLIST_FADE_TIME = 1#(Sec) 
  # Ativar a animação do gráfico do personagem. *(Não é obrigatório ser
  # a imagem de um personagem, você pode criar outros efeitos de animações 
  # no lugar do personagem.
  CHARACTER_SPRITE = false
  # Velociadade da animação do personagem.
  CHARACTER_ANIMATION_SPEED = 30
  # Posição do personagem
  CHARACTER_POSITION = [300,140]
  # Definição da palavra Completado.
  COMPLETED_WORD =  "Completed"
  # Posição do texto de informação.
  INFO_POSITION = [0,373]  
  # Incluir músicas contidas no RTP.
  INCLUDE_RTP = true
  # Definição do diretório que foi instalado o RTP.
  # Por padrão o caminho do diretório foi baseado no Windows 7 (64Bits).
  # Outros sistemas operacionais o caminho do diretório é diferente.
  RTP_PATH = "C:/Program Files (x86)/Common Files/Enterbrain/RGSS3/RPGVXAce/Audio/BGM/"
  # Ativar o comando Music Box no menu principal.
  MENU_COMMAND = true
  # Nome do comando 
  MENU_COMMAND_NAME = "Music Room"  
end

$imported = {} if $imported.nil?
$imported[:mog_music_room] = true

#===============================================================================
# ■ Game System
#===============================================================================
class Game_System
  
  attr_accessor  :music_book_list
  attr_accessor  :avaliable_music_list
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                     
  alias mog_music_book_initialize initialize
  
  def initialize
      mog_music_book_initialize
      music_book_setup
  end

 #--------------------------------------------------------------------------
 # ● Music Book Setup
 #--------------------------------------------------------------------------                   
  def music_book_setup
      return if !SceneManager.scene_is?(Scene_Title)
      
      @music_book_list = []
      @avaliable_music_list = []
      #@music_book_list.push([$data_system.title_bgm.name,false]) if $data_system.title_bgm.name != ""
      path = "Audio/BGM/"  
      make_music_list(path)  
      if MOG_MUSIC_ROOM::INCLUDE_RTP
         path = MOG_MUSIC_ROOM::RTP_PATH
         make_music_list(path)
      end
  end  
    
 #--------------------------------------------------------------------------
 # ● Make_Music_List
 #--------------------------------------------------------------------------                       
  def make_music_list(path)
      return if !File.directory?(path)
      
      list = Dir.entries(path) 
      for i in 2...list.size 
          file_name = File.basename(list[i].to_s,  ".*")
          @music_book_list.push([file_name,false]) unless repeated_song?(file_name)
      end    
   end
  
 #--------------------------------------------------------------------------
 # ● Repeated Song?
 #--------------------------------------------------------------------------                          
  def repeated_song?(file_name)
      
      for i in MOG_MUSIC_ROOM::FORCE_HIDE_MUSIC
          return true if file_name == i
      end    
      for i in 0...@music_book_list.size         
         return true if @music_book_list[i].include?(file_name)
      end
      return false 
  end  
   
 #--------------------------------------------------------------------------
 # ● Make Avaliable Music List
 #--------------------------------------------------------------------------                          
 def make_avaliable_music_list
     @avaliable_music_list = []
     
     for i in @music_book_list
         @avaliable_music_list.push(i) if i[1] 
     end           
 end
         
end  

#==============================================================================
# ■ Game Interpreter
#==============================================================================
class Game_Interpreter
  
 #--------------------------------------------------------------------------
 # ● Music Room
 #--------------------------------------------------------------------------                          
 def music_room
     SceneManager.call(Scene_Music_Box)
 end
  
end

#===============================================================================
# ■ RPG Audio
#===============================================================================
class << Audio
  
 #--------------------------------------------------------------------------
 # ● Bgm Play
 #--------------------------------------------------------------------------                          
  alias mog_music_box_bgm_play bgm_play
  def bgm_play(filename, volume, pitch, pos = 0)
      mog_music_box_bgm_play(filename, volume, pitch, pos)
      check_music_book(filename)
  end
  
 #--------------------------------------------------------------------------
 # ● Check Music Book
 #--------------------------------------------------------------------------                   
  def check_music_book(filename)
      return if $game_system.music_book_list == nil      
      return if filename == nil or filename == ""   
      path = "Audio/BGM/"   
      for i in 0...$game_system.music_book_list.size
          song_name = path.to_s + $game_system.music_book_list[i][0].to_s
          if song_name.to_s == filename.to_s
             $game_system.music_book_list[i][1] = true
             break
          end  
      end  
  end    
  
end
  
#===============================================================================
# ■ RPG Cache
#===============================================================================
module Cache
  
  #--------------------------------------------------------------------------
  # ● Music Cover
  #--------------------------------------------------------------------------
  def self.music_cover(filename)
      load_bitmap("Graphics/Music_Room/", filename)
  end
  
end  

#===============================================================================
# ■ RPG_FileTest 
#===============================================================================
module RPG_FileTest
  
  #--------------------------------------------------------------------------
  # ● RPG_FileTest.music_cover_exist?
  #--------------------------------------------------------------------------
  def RPG_FileTest.music_cover_exist?(filename)
      return Cache.music_cover(filename) rescue return false
  end  
  
end

#==============================================================================
# ■ Window_Picture
#==============================================================================
class Window_Music_List < Window_Selectable

  include MOG_MUSIC_ROOM
  
 #------------------------------------------------------------------------------
 # ● Initialize
 #------------------------------------------------------------------------------   
  def initialize
      
      super(0, 0, Graphics.width, 155)
      self.opacity = 0
      @index = -1
      if HIDE_UNAVAILABLE_MUSIC
         @music_list = $game_system.avaliable_music_list
      else   
         @music_list = $game_system.music_book_list
      end  
      @item_max = @music_list.size
      refresh
      select(0)
      activate
  end

 #------------------------------------------------------------------------------
 # ● Refresh
 #------------------------------------------------------------------------------   
  def refresh
      if self.contents != nil
         self.contents.dispose
         self.contents = nil
      end
      if @item_max > 0         
         self.contents = Bitmap.new(width - 32, 24 * @item_max) 
         for i in 0...@item_max
            draw_item(i)
         end
         return 
      end
      self.contents = Bitmap.new(width - 32, 24) 
      self.contents.draw_text(x,y,Graphics.width - 32,32,"No Data",0)    
  end
  
 #------------------------------------------------------------------------------
 # ● draw_item
 #------------------------------------------------------------------------------   
  def draw_item(index)
      x = 0
      y = 24 * index
      if @music_list[index][1]
         change_color(normal_color,true)
         music_name = MUSIC_INFO[@music_list[index][0].to_s] rescue nil
         music_name = @music_list[index][0].to_s if music_name == nil
         music = "N" + sprintf("%02d", index + 1).to_s +  " - " + music_name.to_s
      else
         change_color(normal_color,false)
         music = "N" + sprintf("%02d", index + 1).to_s +  " - Not Available"
      end  
      self.contents.draw_text(x,y,Graphics.width - 32,32,music,0)
  end
  
 #------------------------------------------------------------------------------
 # ● Col Max
 #------------------------------------------------------------------------------       
  def col_max
      return 1
  end
    
 #------------------------------------------------------------------------------
 # ● Item Max
 #------------------------------------------------------------------------------         
  def item_max
      return @item_max == nil ? 0 : @item_max 
  end  
  
end

#===============================================================================
# ■ Scene Music Box
#===============================================================================
class Scene_Music_Box
 include MOG_MUSIC_ROOM
 
 #--------------------------------------------------------------------------
 # ● Main
 #--------------------------------------------------------------------------               
  def main
      execute_dispose
      create_music_list
      create_layout
      create_sprite_now_playing
      create_character
      execute_loop
      execute_dispose      
  end 
 
 #--------------------------------------------------------------------------
 # ● Execute Loop
 #--------------------------------------------------------------------------                 
  def execute_loop
      Graphics.transition
      loop do
           Graphics.update
           Input.update
           update
           break if SceneManager.scene != self
     end        
   end  
  
 #--------------------------------------------------------------------------
 # ● Create Layout
 #--------------------------------------------------------------------------                 
  def create_layout
      @background = Sprite.new
      @background.z = 1
      make_background_zero
      @layout = Sprite.new
      @layout.bitmap = Cache.music_cover("Layout")
      @layout.z = 90
      @old_index = -1
  end
  
 #--------------------------------------------------------------------------
 # ● create Sprite now Playing
 #--------------------------------------------------------------------------                   
  def create_sprite_now_playing
      
      @now_playing = Plane.new
      @now_playing.bitmap = Bitmap.new(Graphics.width,Graphics.height)
      @now_playing.z = 100
      check_completion
      make_now_playing(true)
  end  
 
 #--------------------------------------------------------------------------
 # ● Check Completion
 #--------------------------------------------------------------------------                     
  def check_completion
      
      comp = 0
      for i in 0...$game_system.music_book_list.size
          comp += 1 if $game_system.music_book_list[i][1]        
      end
      if  $game_system.music_book_list.size > 0   
          @completed = "( " + COMPLETED_WORD + " " + (comp.to_f / $game_system.music_book_list.size * 100).truncate.to_s + "% )"
      else
          @completed = "( " + COMPLETED_WORD + " )"
      end
  end
  
 #--------------------------------------------------------------------------
 # ● Screen Rev X
 #--------------------------------------------------------------------------                     
  def screen_rev_x
      Graphics.width - 544
  end
  
 #--------------------------------------------------------------------------
 # ● Screen Rev Y
 #--------------------------------------------------------------------------                     
  def screen_rev_y
      Graphics.height - 416
  end  
  
 #--------------------------------------------------------------------------
 # ● Create_Character
 #--------------------------------------------------------------------------                       
  def create_character
      return if !CHARACTER_SPRITE
      @character_index = 0
      @character_animation_speed = 0
      @character = Sprite.new
      @character.z = 80
      @character_image = Cache.music_cover("Character")
      @character_frame_max = @character_image.width / @character_image.height
      @character_width = @character_image.width / @character_frame_max  
      @character.bitmap = Bitmap.new(@character_width,@character_image.height)
      @character.x = CHARACTER_POSITION[0] + screen_rev_x
      @character.y = CHARACTER_POSITION[1] + screen_rev_y  
      make_character_bitmap
  end
  
 #--------------------------------------------------------------------------
 # ● Make Now Playing
 #--------------------------------------------------------------------------                     
 def make_now_playing(init = false) 
     @now_playing.bitmap.clear
     @now_playing.bitmap.font.size = 20
     @now_playing.bitmap.font.bold = true     
     music_name = MUSIC_INFO[song_name.to_s] rescue nil
     music_name = song_name if music_name == nil
     text = music_name.to_s + "   " + @completed
     text = @completed if init
     @now_playing.bitmap.draw_text(INFO_POSITION[0] + screen_rev_x,INFO_POSITION[1] + screen_rev_y, Graphics.width, 32, text.to_s,1)       
     @now_playing.opacity = 0 
 end
 
 #--------------------------------------------------------------------------
 # ● Make Background Zero
 #--------------------------------------------------------------------------                     
 def make_background_zero
     if @background.bitmap != nil
        @background.bitmap.dispose
        @background.bitmap = nil
     end   
     if RPG_FileTest.music_cover_exist?("Background")
        @background.bitmap = Cache.music_cover("Background")
        @background.ox = @background.bitmap.width / 2
        @background.oy = @background.bitmap.height / 2
        @background.x = Graphics.width / 2
        @background.y = Graphics.height / 2          
     else
        @background.bitmap = Cache.music_cover("")
     end   
 end
 
 #--------------------------------------------------------------------------
 # ● Make Background
 #--------------------------------------------------------------------------                   
 def make_background 
     if @background.bitmap != nil
        @background.bitmap.dispose
        @background.bitmap = nil
     end  
     if RPG_FileTest.music_cover_exist?(song_name)
        @background.bitmap = Cache.music_cover(song_name)
        @background.ox = @background.width / 2
        @background.oy = @background.height / 2
        @background.x = Graphics.width / 2
        @background.y = Graphics.height / 2           
     else
        @background.bitmap = Cache.music_cover("")
     end  
     @background.opacity = 0
 end
 
 #--------------------------------------------------------------------------
 # ● Song Name
 #--------------------------------------------------------------------------                    
 def song_name
     if @music_list.size == 0       
        return ""
     end  
     return @music_list[@music_list_window.index][0].to_s
 end
 
 #--------------------------------------------------------------------------
 # ● Create_Music_List
 #--------------------------------------------------------------------------                     
  def create_music_list
      $game_system.make_avaliable_music_list
      if HIDE_UNAVAILABLE_MUSIC
         @music_list = $game_system.avaliable_music_list
      else   
         @music_list = $game_system.music_book_list
      end        
      @stop = true
      @layout2 = Sprite.new
      @layout2.bitmap = Cache.music_cover("Layout2")
      @layout_org_position = [MUSIC_LIST_POSITION_LAYOUT[0],MUSIC_LIST_POSITION_LAYOUT[1] + screen_rev_y ]      
      @layout2.y = @layout_org_position[1]
      @layout2.z = 90    
      @music_list_window = Window_Music_List.new
      @music_list_window.z = 100
      @music_list_window_org = [MUSIC_LIST_POSITION_TEXT[0],MUSIC_LIST_POSITION_TEXT[1] + screen_rev_y]
      @music_list_window.y = @music_list_window_org[1]
      @music_index = @music_list_window.index
      @fade_max =  60 + 60 * MUSICLIST_FADE_TIME
      @fade_time = @fade_max
      @music_list_window.x = -Graphics.width
      @music_list_window.contents_opacity = 0
      @layout2.x = -Graphics.width
      @layout2.opacity = 0        
  end  
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------                   
  def initialize
      BattleManager.save_bgm_and_bgs
      RPG::BGM.fade(2 * 1000)
      RPG::BGS.fade(2 * 1000)
      @w_visible = true
  end
   
  
 #--------------------------------------------------------------------------
 # ● Execute Dispose
 #--------------------------------------------------------------------------                   
  def execute_dispose
      return if @layout == nil
      Graphics.freeze
      @music_list_window.dispose
      if @background.bitmap != nil
         @background.bitmap.dispose
      end       
      @background.dispose
      @layout.bitmap.dispose
      @layout.dispose
      @layout = nil
      @layout2.bitmap.dispose
      @layout2.dispose      
      @now_playing.bitmap.dispose
      @now_playing.dispose
      if CHARACTER_SPRITE 
         @character.bitmap.dispose
         @character.dispose
         @character_image.dispose
      end   
      RPG::BGM.stop
      BattleManager.replay_bgm_and_bgs
  end
  
 #--------------------------------------------------------------------------
 # ● Hide_Layout
 #--------------------------------------------------------------------------                       
  def hide_layout
      Sound.play_ok
      @w_visible = @w_visible == true ? false : true
      @fade_time = @w_visible ? @fade_max : 0
      @layout.visible = @w_visible
      if CHARACTER_SPRITE 
         @character.visible = @w_visible
      end  
  end   
  
 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------                   
  def update
      update_commands
      update_animation
  end

 #--------------------------------------------------------------------------
 # ● Update Animation
 #--------------------------------------------------------------------------                     
  def update_animation
      @now_playing.opacity += 2
      @now_playing.ox += 1
      update_list_fade
      update_character_animation
      update_background_animation
  end  
 
 #--------------------------------------------------------------------------
 # ● Update Background Animation
 #--------------------------------------------------------------------------                       
  def update_background_animation
      @background.opacity += 1
  end 
      
 #--------------------------------------------------------------------------
 # ● Update Character Animation
 #--------------------------------------------------------------------------                       
  def update_character_animation
      return if !CHARACTER_SPRITE or @stop 
      @character_animation_speed += 1
      if @character_animation_speed > CHARACTER_ANIMATION_SPEED
         @character_animation_speed = 0
         @character_index += 1
         @character_index = 0 if @character_index >= @character_frame_max
         make_character_bitmap    
      end
  end
 
 #--------------------------------------------------------------------------
 # ● Make Character_bitmap
 #--------------------------------------------------------------------------                         
  def make_character_bitmap
      @character.bitmap.clear
      src_rect_back = Rect.new(@character_width * @character_index, 0,@character_width,@character_image.height)
      @character.bitmap.blt(0,0, @character_image, src_rect_back)  
  end
 
 #--------------------------------------------------------------------------
 # ● Update List Fade
 #--------------------------------------------------------------------------                       
  def update_list_fade
      @fade_time = @fade_max if moved?
      slide_speed = 5
      fade_speed = 3
      if @fade_time > 0
         @fade_time -= 1 unless @stop
         @layout2.opacity += fade_speed * 2
         @music_list_window.contents_opacity += fade_speed * 2
         if @music_list_window.x < @music_list_window_org[0]
            @music_list_window.x += slide_speed * 2
            @layout2.x += slide_speed * 2
            if @music_list_window.x >= @music_list_window_org[0]
               @music_list_window.x = @music_list_window_org[0]
               @layout2.x = @layout_org_position[0]
            end  
         end
      else
         @music_list_window.x -= slide_speed
         @music_list_window.contents_opacity -= fade_speed
         @layout2.x -= slide_speed
         @layout2.opacity -= fade_speed
         if @music_list_window.x < -Graphics.width
            @music_list_window.x = -Graphics.width
            @music_list_window.contents_opacity = 0
            @layout2.x = -Graphics.width
            @layout2.opacity = 0         
          end  
      end 
  end  

 #--------------------------------------------------------------------------
 # ● Moved?
 #--------------------------------------------------------------------------                       
  def moved?
      return true if Input.trigger?(:C)
      return true if Input.trigger?(:B)
      return true if Input.trigger?(:X)
      return true if Input.trigger?(:R)
      return true if Input.trigger?(:L)
      return true if Input.press?(Input.dir4)
      return false
  end  
  
 #--------------------------------------------------------------------------
 # ● Update Commands
 #--------------------------------------------------------------------------                     
  def update_commands
      @music_list_window.update
      if Input.trigger?(:B)
         return_to_scene
      elsif Input.trigger?(:C)
         play_song
      elsif Input.trigger?(:X)
         stop_song
      elsif Input.trigger?(:Y)
         hide_layout
      end  
  end
  
 #--------------------------------------------------------------------------
 # ● Return to Scene
 #--------------------------------------------------------------------------                           
  def return_to_scene
      return if @fade_time == 0 and @layout2.opacity == 0
      Sound.play_cancel
      SceneManager.return
  end
       
 #--------------------------------------------------------------------------
 # ● index_changed?
 #--------------------------------------------------------------------------                         
  def index_changed?
      if @old_index != @music_list_window.index
         @old_index = @music_list_window.index
         return true
      end  
      return false
  end  
  
 #--------------------------------------------------------------------------
 # ● Play Song
 #--------------------------------------------------------------------------                       
  def play_song
      return if @music_list.size == 0
      return if @fade_time == 0 and @layout2.opacity == 0
      if @music_list[@music_list_window.index][1]
         if index_changed? or @stop
            Sound.play_ok            
            @stop = false 
            Audio.bgm_play("Audio/BGM/" +  song_name, 100, 100) rescue nil
            make_background
            make_now_playing
          end  
      else
         Sound.play_buzzer
      end      
  end  
  
 #--------------------------------------------------------------------------
 # ● Stop Song
 #--------------------------------------------------------------------------                         
  def stop_song
      Sound.play_ok
      @stop = true
      RPG::BGM.fade(3 * 1000)
      make_now_playing(true)   
  end  
end

if MOG_MUSIC_ROOM::MENU_COMMAND
#==============================================================================
# ■ Window Menu Command
#==============================================================================
class Window_MenuCommand < Window_Command  
  
 #------------------------------------------------------------------------------
 # ● Add Main Commands
 #------------------------------------------------------------------------------     
  alias mog_musicbox_add_main_commands add_main_commands
  def add_main_commands
      mog_musicbox_add_main_commands
      add_command(MOG_MUSIC_ROOM::MENU_COMMAND_NAME, :musicbox, main_commands_enabled)
  end
end   

#==============================================================================
# ■ Scene Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  
 #------------------------------------------------------------------------------
 # ● Create Command Windows
 #------------------------------------------------------------------------------       
   alias mog_musicbox_create_command_window create_command_window
   def create_command_window
       mog_musicbox_create_command_window
       @command_window.set_handler(:musicbox,     method(:Music_Box))
   end
   
 #------------------------------------------------------------------------------
 # ● Music Box
 #------------------------------------------------------------------------------        
   def Music_Box
       SceneManager.call(Scene_Music_Box)
   end
 
end   
 
end
