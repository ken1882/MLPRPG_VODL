#==============================================================================
# +++ MOG - Boss HP Meter (V1.5) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Apresenta um medidor animado com o HP do inimigo. 
#
#==============================================================================
# UTILIZAÇÃO
#==============================================================================
# Coloque o seguinte comentário na caixa de notas do inimigo.
#
# <Boss HP Meter>
#
# Caso desejar ocultar o valor numérico do HP use o código abaixo.
#
# <Boss HP Hide Number>
#
#==============================================================================
# Caso precisar mudar a posição do medidor no meio do jogo use o código abaixo
#
# boss_hp_position(X,Y)
#
#==============================================================================
# Serão necessários as imagens.
#
# Battle_Boss_Meter.png
# Battle_Boss_Meter_Layout.png
#==============================================================================
# FACES (Opcional)
#==============================================================================
# Nomeie o arquivo da face da seguinte maneira. (Graphics/Faces/)
#
# Enemy_Name + _F.png         (Slime_F.png)
#
# ou
#
# BF_ + ID.png          (BF_11.png)
#
#==============================================================================
# Definindo o LEVEL (Opcional)
#==============================================================================
# Coloque o seguinte comentário na caixa de notas do inimigo.
#
# <Level = X>
#
#==============================================================================

#==============================================================================
# Histórico
#==============================================================================
# v1.5 - Definição do nome da face pelo ID do battler
# v1.4 - Melhoria de compatibilidade de scripts.
#==============================================================================

$imported = {} if $imported.nil?
$imported[:mog_blitz_commands] = true

module MOG_BOSS_HP_METER
    #Posição geral do layout.
    LAYOUT_POSITION = [60,30]
    #Posição do medidor.
    METER_POSITION = [3,3]
    #Posição do nome do inimigo.
    NAME_POSITION = [16,8]
    #Posição da face.
    FACE_POSITION = [0,-30]
    #Posição do level do inimigo.
    LEVEL_POSITION = [150, -24]#[290, 0]
    #Posição do numero  de HP
    HP_NUMBER_POSITION = [230, 5]
    #Definição do espaço da palavra HP e o valor de numérico.
    HP_STRING_SPACE = 36
    #Ativar efeito wave
    HP_NUMBER_WAVE_EFFECT = true
    #Definição da palavra Level.
    LEVEL_WORD = "Level "
    #Velocidade de animação do medidor
    METER_ANIMATION_SPEED = 10    
    #Definição do tamanho da fonte.
    FONT_SIZE = 16
    #Ativar contorno na fonte.
    FONT_BOLD = true
    #Fonte em itálico.
    FONT_ITALIC = true
    #Definição da cor da fonte.
    FONT_COLOR = Color.new(255,255,255)
    #Definição da prioridade da HUD.
    PRIORITY_Z = 50
end

#==============================================================================
# ■ Game System
#==============================================================================
class Game_System
  
 attr_accessor :boss_hp_meter 
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------  
 alias mog_boss_hp_meter_initialize initialize
 def initialize
     ix = MOG_BOSS_HP_METER::LAYOUT_POSITION[0]
     iy = MOG_BOSS_HP_METER::LAYOUT_POSITION[1]
     @boss_hp_meter = [ix,iy,false,"",0,1,0,nil,0,false]
     mog_boss_hp_meter_initialize
 end
  
end

#==============================================================================
# ■ Game Enemy
#==============================================================================
class Game_Enemy < Game_Battler
   
  attr_accessor :boss_hp_meter
  attr_accessor :boss_hp_number
  attr_accessor :class
  attr_accessor :level
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  alias mog_boss_hp_meter_initialize initialize
  def initialize(index, enemy_id)
      mog_boss_hp_meter_initialize(index, enemy_id)
      @boss_hp_meter = enemy.note =~ /<Boss HP Meter>/ ? true : false 
      @boss_hp_number = enemy.note =~ /<Boss HP Hide Number>/ ? false : true
      @level = enemy.note =~ /<Level = (\d+)>/i ? $1.to_i : define_enemy_level.to_i
      
      @class = enemy.note =~ /<Boss HP Meter>/ ? "Boss" : "Minon"
      @class = enemy.note =~ /<Elite>/ ? "Elite" : "Minon"
  end  
    
  def define_enemy_level
    return (self.atk + self.def + self.mat + self.mdf + self.luk)/20 + self.agi/10
  end
  

end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
  
  attr_accessor :battle_end
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias mog_boss_hp_meter_initialize initialize
  def initialize
      @battle_end = false
      mog_boss_hp_meter_initialize 
  end  

end

#==============================================================================
# ■ Game Interpreter
#==============================================================================
class Game_Interpreter
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------    
 def boss_hp_position(x = 0,y = 0)
     $game_system.boss_hp_meter[0] = x
     $game_system.boss_hp_meter[1] = y
 end
  
end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp

  attr_accessor :cache_boss_hp
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------    
  alias mog_boss_hp_initialize initialize
  def initialize
      mog_boss_hp_initialize
      cache_bosshp
  end
  
 #--------------------------------------------------------------------------
 # ● Cache Bosshp
 #--------------------------------------------------------------------------  
  def cache_bosshp
      @cache_boss_hp = []
      @cache_boss_hp.push(Cache.system("Battle_Boss_Meter_Layout"))
      @cache_boss_hp.push(Cache.system("Battle_Boss_Meter"))
      @cache_boss_hp.push(Cache.system("Battle_Boss_Number"))
  end
  
end

#==============================================================================
# ■ Boss HP Meter
#==============================================================================
class Boss_HP_Meter
  include MOG_BOSS_HP_METER
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  def initialize(viewport = nil)
      clear_enemy_setup
      @hp_vieport = nil
      check_boss_avaliable
  end
  
  #--------------------------------------------------------------------------
  # ● Clear Enemy Setup
  #--------------------------------------------------------------------------    
  def clear_enemy_setup
      @name = ""    
      @hp = 0
      @hp2 = 0
      @hp3 = 0
      @maxhp = 0
      @hp_old = 0
      @level = nil
      $game_system.boss_hp_meter[2] = false
      $game_system.boss_hp_meter[3] = ""
      $game_system.boss_hp_meter[4] = 0
      $game_system.boss_hp_meter[5] = 1
      $game_system.boss_hp_meter[7] = nil
      $game_system.boss_hp_meter[8] = 0
      $game_system.boss_hp_meter[9] = true
  end

  #--------------------------------------------------------------------------
  # ● Check Boss Avaliable
  #--------------------------------------------------------------------------    
  def check_boss_avaliable
      return if $game_troop.all_dead?
      for i in $game_troop.members
          if i.boss_hp_meter and !i.hidden? and i.hp > 0
             create_boss_hp_meter(i)
             break 
          end
      end
  end

  #--------------------------------------------------------------------------
  # ● Create Boss HP Meter
  #--------------------------------------------------------------------------      
  def create_boss_hp_meter(i)
      $game_system.boss_hp_meter[2] = true
      $game_system.boss_hp_meter[3] = i.name
      $game_system.boss_hp_meter[4] = i.hp
      $game_system.boss_hp_meter[5] = i.mhp
      $game_system.boss_hp_meter[6] = i.hp
      $game_system.boss_hp_meter[7] = i.level rescue nil
      $game_system.boss_hp_meter[8] = 0
      $game_system.boss_hp_meter[9] = i.boss_hp_number
      $game_system.boss_hp_meter[10] = i.enemy_id
      refresh_hp_meter
      create_layout
      create_meter
      create_name
      create_face
      create_level
      create_hp_number
  end
    
  #--------------------------------------------------------------------------
  # ● Create Layout
  #--------------------------------------------------------------------------        
  def create_layout
      return if @layout != nil
      @layout = Sprite.new
      @layout.bitmap = $game_temp.cache_boss_hp[0]
      @layout.x = $game_system.boss_hp_meter[0]
      @layout.y = $game_system.boss_hp_meter[1]
      @layout.viewport = @hp_vieport
      @layout.z = PRIORITY_Z
  end
  
  #--------------------------------------------------------------------------
  # ● Create Meter
  #--------------------------------------------------------------------------          
  def create_meter
      return if @meter_image != nil
      hp_setup
      @meter_image = $game_temp.cache_boss_hp[1]
      @meter_cw = @meter_image.width / 3
      @meter_ch = @meter_image.height / 2
      @meter = Sprite.new
      @meter.bitmap = Bitmap.new(@meter_cw,@meter_ch)
      @meter.z = @layout.z + 1
      @meter.x = @layout.x + METER_POSITION[0]
      @meter.y = @layout.y + METER_POSITION[1]
      @meter.viewport = @hp_vieport
      @hp_flow = 0
      @hp_flow_max = @meter_cw * 2
      update_hp_meter
  end

  #--------------------------------------------------------------------------
  # ● Create Name
  #--------------------------------------------------------------------------            
  def create_name
      @name_sprite = Sprite.new
      @name_sprite.bitmap = Bitmap.new(200,32)
      @name_sprite.z = @layout.z + 2
      @name_sprite.x = @layout.x + NAME_POSITION[0]
      @name_sprite.y = @layout.y + NAME_POSITION[1]
      @name_sprite.bitmap.font.size = FONT_SIZE
      @name_sprite.bitmap.font.bold = FONT_BOLD
      @name_sprite.bitmap.font.italic = FONT_ITALIC
      @name_sprite.bitmap.font.color = FONT_COLOR
      @name_sprite.viewport = @hp_vieport
      refresh_name
  end
  
  #--------------------------------------------------------------------------
  # ● Create Face
  #--------------------------------------------------------------------------
  def create_face
      @face_sprite = Sprite.new
      @face_sprite.x = @layout.x + FACE_POSITION[0]
      @face_sprite.y = @layout.y + FACE_POSITION[1] 
      @face_sprite.z = @layout.z + 2
      @face_sprite.viewport = @hp_vieport
      refresh_face
  end

  #--------------------------------------------------------------------------
  # ● Create Level
  #--------------------------------------------------------------------------  
  def create_level
      @level_sprite = Sprite.new
      @level_sprite.bitmap = Bitmap.new(120,32)
      @level_sprite.z = @layout.z + 2
      @level_sprite.x = @layout.x + LEVEL_POSITION[0]
      @level_sprite.y = @layout.y + LEVEL_POSITION[1]
      @level_sprite.bitmap.font.size = FONT_SIZE
      @level_sprite.bitmap.font.bold = FONT_BOLD
      @level_sprite.bitmap.font.italic = FONT_ITALIC
      @level_sprite.bitmap.font.color = FONT_COLOR
      @level_sprite.viewport = @hp_vieport
      refresh_level
  end
  
  #--------------------------------------------------------------------------
  # ● Create HP Number
  #--------------------------------------------------------------------------    
  def create_hp_number
      @hp2 = $game_system.boss_hp_meter[4]
      @hp3 = @hp2
      @hp_old2 = @hp2
      @hp_ref = @hp_old2
      @hp_refresh = false    
      @hp_number_image = $game_temp.cache_boss_hp[2]
      @hp_cw = @hp_number_image.width / 10
      @hp_ch = @hp_number_image.height / 2
      @hp_ch2 = 0
      @hp_ch_range = HP_NUMBER_WAVE_EFFECT == true ? @hp_ch / 3 : 0
      @hp_number_sprite = Sprite.new
      @hp_number_sprite.bitmap = Bitmap.new(@hp_number_image.width, @hp_ch * 2)
      @hp_number_sprite.z = @layout.z + 2
      @hp_number_sprite.x = @layout.x + HP_NUMBER_POSITION[0]
      @hp_number_sprite.y = @layout.y + HP_NUMBER_POSITION[1]
      @hp_number_sprite.viewport = @hp_vieport
      @hp_number_sprite.visible = $game_system.boss_hp_meter[9]
      refresh_hp_number
  end
  
  #--------------------------------------------------------------------------
  # ● update_hp_number
  #--------------------------------------------------------------------------
  def update_hp_number
      return if @hp_number_sprite == nil
      @hp_number_sprite.visible = $game_system.boss_hp_meter[9]
      if @hp_old2 < $game_system.boss_hp_meter[4]
         number_refresh_speed
         @hp2 += @hp_ref     
         reset_hp_number  if @hp2 >= $game_system.boss_hp_meter[4]
      elsif @hp_old2 > $game_system.boss_hp_meter[4]           
         number_refresh_speed
         @hp2 -= @hp_ref                
         reset_hp_number if @hp2 <= $game_system.boss_hp_meter[4]
      end  
  end    
  
  #--------------------------------------------------------------------------
  # ● Number Refresh Speed
  #-------------------------------------------------------------------------- 
  def number_refresh_speed
      @hp_refresh = true  
      @hp_ref = (3 * (@hp_old2 - $game_system.boss_hp_meter[4]).abs / 100) rescue nil
      @hp_ref = 1 if @hp_ref == nil or @hp_ref < 1
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh HP Number
  #--------------------------------------------------------------------------      
  def refresh_hp_number
      return if @hp_number_sprite == nil
      @hp_refresh = false
      @hp_number_sprite.bitmap.clear
      number = @hp2.abs.to_s.split(//)
      @hp_ch2 = 0
      for r in 0..number.size - 1
          number_abs = number[r].to_i
          nsrc_rect = Rect.new(@hp_cw * number_abs, 0, @hp_cw, @hp_ch)
          @hp_ch2 = @hp_ch2 == @hp_ch_range ? 0 : @hp_ch_range
          @hp_number_sprite.bitmap.blt(HP_STRING_SPACE + (@hp_cw *  r), @hp_ch2, @hp_number_image, nsrc_rect)        
      end      
      nsrc_rect = Rect.new(0, @hp_ch, @hp_number_image.width, @hp_ch)
      @hp_number_sprite.bitmap.blt(0, 0, @hp_number_image, nsrc_rect)     
  end
  
  #--------------------------------------------------------------------------
  # ● Reset HP Number
  #--------------------------------------------------------------------------        
  def reset_hp_number
      @hp_refresh = true
      @hp_old2 = $game_system.boss_hp_meter[4]
      @hp2 = $game_system.boss_hp_meter[4]
      @hp_ref = 0
      refresh_hp_number 
  end
    
  #--------------------------------------------------------------------------
  # ● Refresh Level
  #--------------------------------------------------------------------------    
  def refresh_level
      return if @level_sprite == nil
      @level_sprite.bitmap.clear
      @level = $game_system.boss_hp_meter[7]
      return if @level == nil
      level_text = LEVEL_WORD + @level.to_s
      @level_sprite.bitmap.draw_text(0,0,120,32,level_text.to_s)
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Face
  #--------------------------------------------------------------------------  
  def refresh_face
      return if @face_sprite == nil
      dispose_bitmap_face
      @face_sprite.bitmap = Cache.face(@name + "_f") rescue nil
      @face_sprite.bitmap = Cache.face("BF_" + $game_system.boss_hp_meter[10].to_s) rescue nil if @face_sprite.bitmap == nil
      @face_sprite.bitmap = Cache.face("") if @face_sprite.bitmap == nil
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Name
  #--------------------------------------------------------------------------              
  def refresh_name
      return if @name_sprite == nil
      @name = $game_system.boss_hp_meter[3]    
      @name_sprite.bitmap.clear
      @name_sprite.bitmap.draw_text(0,0,190,32,@name.to_s)
      refresh_face
      refresh_level
      reset_hp_number
      @hp_old = @meter_cw * @hp / @maxhp
  end
  
  #--------------------------------------------------------------------------
  # ● HP Setup
  #--------------------------------------------------------------------------            
  def hp_setup
      @hp = $game_system.boss_hp_meter[4]
      @maxhp = $game_system.boss_hp_meter[5]
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------  
  def dispose
      dispose_layout
      dispose_meter
      dispose_name
      dispose_face
      dispose_level
      dispose_hp_number      
  end

  #--------------------------------------------------------------------------
  # ● Dispose Name
  #--------------------------------------------------------------------------              
  def dispose_name
      return if @name_sprite == nil
      @name_sprite.bitmap.dispose
      @name_sprite.dispose
      @name_sprite = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Layout
  #--------------------------------------------------------------------------    
  def dispose_layout
      return if @layout == nil
      @layout.dispose
      @layout = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Meter
  #--------------------------------------------------------------------------      
  def dispose_meter
      return if @meter == nil
      @meter.bitmap.dispose
      @meter.dispose
      @meter = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Face
  #--------------------------------------------------------------------------  
  def dispose_face
      return if @face_sprite == nil
      dispose_bitmap_face
      @face_sprite.dispose
      @face_sprite = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Bitmap Face
  #--------------------------------------------------------------------------    
  def dispose_bitmap_face
      return if @face_sprite == nil
      return if @face_sprite.bitmap == nil
      @face_sprite.bitmap.dispose rescue nil
      @face_sprite.bitmap = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Level
  #--------------------------------------------------------------------------    
  def dispose_level
      return if @level_sprite == nil
      @level_sprite.bitmap.dispose
      @level_sprite.dispose
      @level_sprite = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose HP Number
  #--------------------------------------------------------------------------      
  def dispose_hp_number
      return if @hp_number_sprite == nil
      @hp_number_sprite.bitmap.dispose
      @hp_number_sprite.dispose
  end    
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  def update
      refresh_hp_meter
      refresh_hp_number if @hp_refresh
      update_hp_meter
      update_hp_number
      update_fade_end
      update_visible
  end
  
  #--------------------------------------------------------------------------
  # ● Update Visible
  #--------------------------------------------------------------------------  
  def update_visible
      return if @meter_image == nil
      vis = bhp_visible?
      @layout.visible = vis    
      @meter.visible = vis    
      @name_sprite.visible = vis    
      @face_sprite.visible = vis    
      @level_sprite.visible = vis    
      @hp_number_sprite.visible = vis    
  end
  
  #--------------------------------------------------------------------------
  # ● Bhp Visible?
  #--------------------------------------------------------------------------  
  def bhp_visible?
      return false if $game_message.visible
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Update Fade End
  #--------------------------------------------------------------------------    
  def update_fade_end
      return if !$game_temp.battle_end
      return if @meter_image == nil
      @layout.opacity -= 5
      @meter.opacity -= 5
      @name_sprite.opacity -= 5
      @face_sprite.opacity -= 5
      @level_sprite.opacity -= 5
      @hp_number_sprite.opacity -= 5
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh HP Meter
  #--------------------------------------------------------------------------          
  def refresh_hp_meter
      return if !$game_system.boss_hp_meter[2]
      $game_system.boss_hp_meter[2] = false
      hp_setup
      refresh_name if @name != $game_system.boss_hp_meter[3]
  end
  
  #--------------------------------------------------------------------------
  # ● Update HP Meter
  #--------------------------------------------------------------------------            
  def update_hp_meter
      return if @meter_image == nil
      @meter.bitmap.clear
      hp_width = @meter_cw * @hp / @maxhp      
      execute_damage_flow(hp_width)      
      hp_src_rect = Rect.new(@hp_flow, 0,hp_width, @meter_ch)
      @meter.bitmap.blt(0,0, @meter_image, hp_src_rect)  
      @hp_flow += METER_ANIMATION_SPEED
      @hp_flow = 0 if @hp_flow >= @hp_flow_max
  end  
    
  #--------------------------------------------------------------------------
  # ● Execute Damage Flow
  #-------------------------------------------------------------------------- 
  def execute_damage_flow(hp_width)
      return if @hp_old == hp_width
      n = (@hp_old - hp_width).abs * 3 / 100
      damage_flow = [[n, 2].min,0.5].max
      @hp_old -= damage_flow      
      @hp_old = hp_width if @hp_old <= hp_width 
      src_rect_old = Rect.new(0,@meter_ch, @hp_old, @meter_ch)
      @meter.bitmap.blt(0,0, @meter_image, src_rect_old)       
  end    
  
end

#==============================================================================
# ■ Spriteset Battle
#==============================================================================
class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias mog_enemy_bhp_initialize initialize
  def initialize
      mog_enemy_bhp_initialize
      create_boss_hp_meter
  end
  
  #--------------------------------------------------------------------------
  # ● Create Boss HP Meter
  #--------------------------------------------------------------------------  
  def create_boss_hp_meter
      @boss_hp_meter = Boss_HP_Meter.new(@viewport1)
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------      
  alias mog_enemy_bhp_dispose dispose
  def dispose
      dispose_boss_hp_meter    
      mog_enemy_bhp_dispose
  end  

  #--------------------------------------------------------------------------
  # ● Dispose Boss HP Meter
  #--------------------------------------------------------------------------          
  def dispose_boss_hp_meter
      return if @boss_hp_meter == nil
      @boss_hp_meter.dispose
      @boss_hp_meter = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------        
  alias mog_enemy_bhp_update update
  def update
      mog_enemy_bhp_update
      update_boss_hp_meter
  end
  
  #--------------------------------------------------------------------------
  # ● Update Boss HP Meter
  #--------------------------------------------------------------------------            
  def update_boss_hp_meter
      return if @boss_hp_meter == nil
      @boss_hp_meter.update
  end
    
end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Item Apply
  #--------------------------------------------------------------------------        
  alias mog_boss_hp_item_apply item_apply
  def item_apply(user, item)
      check_boss_hp_before
      mog_boss_hp_item_apply(user, item)
      check_boss_hp_after
  end
  
  #--------------------------------------------------------------------------
  # ● Regenerate HP
  #--------------------------------------------------------------------------
  alias mog_boss_hp_regenerate_hp regenerate_hp
  def regenerate_hp
      check_boss_hp_before
      mog_boss_hp_regenerate_hp
      check_boss_hp_after
  end  
  
  #--------------------------------------------------------------------------
  # ● Check Boss HP Before
  #--------------------------------------------------------------------------          
  def check_boss_hp_before
      return if self.is_a?(Game_Actor)
      return if !self.boss_hp_meter
      $game_system.boss_hp_meter[6] = self.hp
  end
  
  #--------------------------------------------------------------------------
  # ● Check Boss HP After
  #--------------------------------------------------------------------------            
  def check_boss_hp_after
      return if self.is_a?(Game_Actor)
      return if !self.boss_hp_meter
      $game_system.boss_hp_meter[2] = true
      $game_system.boss_hp_meter[3] = self.name
      $game_system.boss_hp_meter[4] = self.hp
      $game_system.boss_hp_meter[5] = self.mhp
      $game_system.boss_hp_meter[7] = self.level rescue nil     
      $game_system.boss_hp_meter[9] = self.boss_hp_number
  end
  
end

#==============================================================================
# ■ Game_Interpreter
#==============================================================================
class Game_Interpreter

  #--------------------------------------------------------------------------
  # ● Check Boss Meter
  #--------------------------------------------------------------------------    
  def check_boss_meter
      return if !SceneManager.scene_is?(Scene_Battle)
      iterate_enemy_index(@params[0]) do |enemy|
        if enemy.boss_hp_meter
           $game_system.boss_hp_meter[2] = true
           $game_system.boss_hp_meter[3] = enemy.name
           $game_system.boss_hp_meter[4] = enemy.hp
           $game_system.boss_hp_meter[5] = enemy.mhp
           $game_system.boss_hp_meter[6] = enemy.hp   
           $game_system.boss_hp_meter[7] = enemy.level rescue nil
           $game_system.boss_hp_meter[9] = enemy.boss_hp_number
        end
     end
  end

  #--------------------------------------------------------------------------
  # ● Command 331
  #--------------------------------------------------------------------------  
  alias mog_boss_meter_command_331 command_331
  def command_331
      mog_boss_meter_command_331
      check_boss_meter
  end
  
  #--------------------------------------------------------------------------
  # ● Command 334
  #--------------------------------------------------------------------------  
  alias mog_boss_meter_command_334 command_334
  def command_334
      mog_boss_meter_command_334
      check_boss_meter
  end   
  
end

#==============================================================================
# ■ BattleManager
#==============================================================================
class << BattleManager
  
  #--------------------------------------------------------------------------
  # ● Init Members
  #--------------------------------------------------------------------------          
  alias mog_boss_meter_init_members init_members
  def init_members
      $game_temp.battle_end = false
      mog_boss_meter_init_members
  end  
  
  #--------------------------------------------------------------------------
  # ● Process Victory
  #--------------------------------------------------------------------------            
  alias mog_boss_meter_process_victory process_victory 
  def process_victory 
      $game_temp.battle_end = true
      mog_boss_meter_process_victory
  end
  
  #--------------------------------------------------------------------------
  # ● Process Abort
  #--------------------------------------------------------------------------            
  alias mog_boss_meter_process_abort process_abort
  def process_abort
      $game_temp.battle_end = true
      mog_boss_meter_process_abort
  end

  #--------------------------------------------------------------------------
  # ● Process Defeat
  #--------------------------------------------------------------------------            
  alias mog_boss_meter_process_defeat process_defeat
  def process_defeat
      $game_temp.battle_end = true
      mog_boss_meter_process_defeat
  end
  
end