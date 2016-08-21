#==============================================================================
# +++ MOG - Schala ATB Gauge (ver 1.9) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Adiciona um medidor circular de ATB, incluindo os ícones
# dos respectivos battlers.
#==============================================================================
# Arquivos necessários.
#
# ATB_Layout.png
# ATB_Enemy.png
# ATB_Actor.png
#
# Coloque as imagens na pasta
#
#            /Graphics/Schala_ATB/
#
#==============================================================================
# Opcional - Ícones específicos dos personagens.
#==============================================================================
# Nomeie os arquivos das seguinte forma.
#
# ATB_ + Battler_Name.png
#
# ATB_Aluxes.png
# ATB_Slime.png
# ...
# ...
# ...
#
#==============================================================================
# Compatível com :
#
# - MOG ATB System (v 1.0)
# - Victor's Active Time Battle (1.05)
# - C Winter's Active Time Battle (1.62)
#
#==============================================================================

#==============================================================================
# Histórico
#==============================================================================
# 1.9 - Refresh ao a posição dos battlers.
# 1.8 - Melhoria no sistema de ocultar a hud.
#==============================================================================
$imported = {} if $imported.nil?
$imported[:mog_schala_atb] = true

module SCHALA_ATB_GAUGE
  #Posição geral do medidor
  LAYOUT_POS = [440,25]
  #Posição do Ícones dos battlers.
  POINT_POS = [2,0]
  #Tamanho circular da imagem.
  GAUGE_SIZE = 36
  #Prioridade do medidor de sprite.
  SPRITE_Z = 90
end

#==============================================================================
# ** Cache
#==============================================================================
module Cache

  #--------------------------------------------------------------------------
  # * Hud
  #--------------------------------------------------------------------------
  def self.schala_atb(filename)
      load_bitmap("Graphics/Schala_ATB/", filename)
  end

end

#==============================================================================
# ■ Game BattlerBase
#==============================================================================
class Game_BattlerBase
   attr_accessor :hidden
end
 
#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
  attr_accessor :schala_gauge_data
  attr_accessor :battle_end
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------      
  alias mog_schala_gauge_initialize initialize
  def initialize
      @schala_gauge_data = [false,false] ; @battle_end = false
      mog_schala_gauge_initialize
  end
  
end

#===============================================================================
# ■ Spriteset_Battle
#===============================================================================
class Spriteset_Battle
   
  #--------------------------------------------------------------------------
  # ● Update Battle Start
  #--------------------------------------------------------------------------        
  alias mog_schala_atb_initialize initialize
  def initialize
      mog_schala_atb_initialize
      create_schala_atb
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------  
  alias mog_schala_atb_dispose dispose
  def dispose
      mog_schala_atb_dispose
      dispose_schala_atb
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------          
  alias mog_schala_atb_update update
  def update
      mog_schala_atb_update
      update_schala_atb
  end  

  #--------------------------------------------------------------------------
  # ● Create Schala ATB
  #--------------------------------------------------------------------------    
  def create_schala_atb
      return if @schala_atb != nil
      @schala_atb = Schala_ATB_Gauge.new
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Schala ATB
  #--------------------------------------------------------------------------    
  def dispose_schala_atb
      return if @schala_atb == nil
      @schala_atb.dispose ; @schala_atb = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Update Schala ATB
  #--------------------------------------------------------------------------    
  def update_schala_atb
      return if @schala_atb == nil
      @schala_atb.update
  end
    
end 

#==============================================================================
# ** Game Interpreter
#==============================================================================
class Game_Interpreter
  
 #--------------------------------------------------------------------------
 # * Command_129
 #--------------------------------------------------------------------------
 alias mog_schala_gauge_command_129 command_129
 def command_129
     mog_schala_gauge_command_129
     $game_temp.schala_gauge_data[1] = true if SceneManager.scene_is?(Scene_Battle)
 end
  
 #--------------------------------------------------------------------------
 # ● Command 335
 #--------------------------------------------------------------------------
 alias mog_schala_gauge_command_335 command_335
 def command_335
     mog_schala_gauge_command_335
     $game_temp.schala_gauge_data[1] = true if SceneManager.scene_is?(Scene_Battle)
 end  
 
end

#==============================================================================
# ** Game Party
#==============================================================================
class Game_Party < Game_Unit
    
 #--------------------------------------------------------------------------
 # * Swap Order
 #--------------------------------------------------------------------------
 alias mog_schala_gauge_swap_order swap_order
 def swap_order(index1, index2)
      mog_schala_gauge_swap_order(index1, index2)
      $game_temp.schala_gauge_data[1] = true if SceneManager.scene_is?(Scene_Battle)
 end  
  
end

#==============================================================================
# Schala ATB Gauge
#==============================================================================
class Schala_ATB_Gauge
  include SCHALA_ATB_GAUGE
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------            
  def initialize
      $game_temp.schala_gauge_data[0] = false ; @schala_gauge = [] ; create_sprites
  end

  #--------------------------------------------------------------------------
  # ● Create Sprites
  #--------------------------------------------------------------------------            
  def create_sprites
      return if $game_party.members.size == 0 or $game_troop.members.size == 0
      battlers.each do |i| @schala_gauge.push(Schala_Sprite_Target.new(nil,i)) end
      @schala_layout = Sprite.new
      @schala_layout.bitmap = Cache.schala_atb("ATB_Layout")
      @schala_layout.x = LAYOUT_POS[0] ; @schala_layout.y = LAYOUT_POS[1] 
      @schala_layout.z = SPRITE_Z ; @schala_layout.opacity = 0
  end
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #-------------------------------------------------------------------------- 
  def battlers
      return $game_troop.members + $game_party.battle_members
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------
  def dispose
      @schala_gauge.each {|sprite| sprite.dipose_schala_point }
      return if @schala_layout == nil
      @schala_layout.bitmap.dispose ; @schala_layout.dispose ; @schala_layout = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  def update
      return if @schala_layout == nil
      @schala_gauge.each {|sprite| sprite.update_schala_point }
      if can_fade_layout?
         @schala_layout.opacity -= 10
      else   
         @schala_layout.opacity += 15
      end  
      @schala_layout.visible = !$game_message.visible
      refresh_gauge if $game_temp.schala_gauge_data[1]
  end  
    
  #--------------------------------------------------------------------------
  # ● Can Fade Layout
  #--------------------------------------------------------------------------  
  def can_fade_layout?
      return true if $game_temp.schala_gauge_data[0]
      return true if $game_temp.battle_end
      return true if $game_message.visible
      return false
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Gauge
  #--------------------------------------------------------------------------  
  def refresh_gauge
      $game_temp.schala_gauge_data[1] = false ; dispose ; create_sprites
  end
  
end

#=============================================================================
# Schala Sprite Target
#==============================================================================
class Schala_Sprite_Target < Sprite
  include SCHALA_ATB_GAUGE
    #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------              
  def initialize(viewport = nil,battler)
      super(viewport)
      @target = battler ; @gauge_size = GAUGE_SIZE
      return if @target == nil
      create_bitmap
      self.ox = @cw / 2 ; self.oy = @ch / 2 ; self.x = 0 ; self.y = 0
      self.z = @sz ; self.opacity = 0 ; @pos_y = 0
      @x2 = self.ox + LAYOUT_POS[0] + POINT_POS[0] + @gauge_size
      @y2 = self.oy + LAYOUT_POS[1] + POINT_POS[1] + @gauge_size
      (@gauge_size += 10 ; @x2 -= 2 ; @y2 -= 2) if @target.is_a?(Game_Enemy)
      @x = 0 ; @y = 0   
      @center = [LAYOUT_POS[0] + @gauge_size,LAYOUT_POS[1] + @gauge_size]
      catb = ATB::MAX_AP rescue nil ; @ccwinter_atb = true if catb != nil  
      @atb = actor_at
  end

  #--------------------------------------------------------------------------
  # ● Create Bitmap
  #--------------------------------------------------------------------------             
  def create_bitmap
      b_nm = @target.is_a?(Game_Actor) ? "Actor" : "Enemy"
      b_id = @target.is_a?(Game_Actor) ? @target.id : @target.enemy_id
      self.bitmap = Cache.schala_atb(b_nm.to_s + "_" + b_id.to_s) rescue nil
      self.bitmap = Cache.schala_atb(b_nm.to_s + "_ATB") if self.bitmap == nil rescue nil
      self.bitmap = Bitmap.new(16,16) if self.bitmap == nil    
      @cw = self.bitmap.width ; @ch = self.bitmap.height ; @sz = SPRITE_Z + 1  
  end

  #--------------------------------------------------------------------------
  # ● Dispose Schala Point
  #--------------------------------------------------------------------------             
  def dipose_schala_point
      return if self.bitmap == nil or self.bitmap.disposed?
      self.bitmap.dispose ; self.bitmap = nil
  end

  #--------------------------------------------------------------------------
  # ● Update Schala Point
  #--------------------------------------------------------------------------              
  def update_schala_point
      return if self.bitmap == nil or self.bitmap.disposed? or !self.visible
      if can_update_atb?
         self.opacity += 10 ; update_atb
      else
         self.opacity -= 10
      end
      self.x = @x ; self.y = @y ; self.opacity = 0 if $game_message.visible
  end
  
  #--------------------------------------------------------------------------
  # ● Check All Dead?
  #--------------------------------------------------------------------------              
  def check_all_dead?
      return if !@target.is_a?(Game_Enemy)
      self.visible = false ; $game_temp.schala_gauge_data[0] = true
      $game_troop.members.each {|b| $game_temp.schala_gauge_data[0] = false if !b.dead?}
  end
  
  #--------------------------------------------------------------------------
  # ● Can Update ATB
  #--------------------------------------------------------------------------  
  def can_update_atb?
      return false if @target == nil or @target.dead? or @target.hidden
      return false if $game_temp.schala_gauge_data[0]
      return false if $game_temp.battle_end
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Update ATB
  #--------------------------------------------------------------------------                
  def update_atb
      update_atb_type
      round = (2.0 * Math::PI / @atb_max) * -@atb
      @x = @x2 - ( @gauge_size * Math.sin( round ) ).to_i
      @y = @y2 - ( @gauge_size * Math.cos( round ) ).to_i
  end
  
  #--------------------------------------------------------------------------
  # ● Update ATB Type
  #--------------------------------------------------------------------------                  
  def update_atb_type
      if actor_cast?
         @atb_max = -actor_max_cast ;  @atb = actor_cast
      else
         @atb_max = actor_max_at ; @atb = actor_at
      end
      @atb_max = 1 if @atb_max == 0  
  end

  #--------------------------------------------------------------------------
  # * AT
  #--------------------------------------------------------------------------  
  def actor_at
      return @target.atb if $imported[:mog_atb_system]
      return @target.atb if $imported[:ve_active_time_battle]
      return @target.catb_value if $imported["YSA-CATB"]
      return @target.ap if @ccwinter_atb != nil
      return 0
  end
  
  #--------------------------------------------------------------------------
  # * Max AT
  #--------------------------------------------------------------------------  
  def actor_max_at
      return @target.atb_max if $imported[:mog_atb_system]
      return @target.max_atb if $imported[:ve_active_time_battle]
      return @target.max_atb if $imported["YSA-CATB"]
      return ATB::MAX_AP if @ccwinter_atb != nil
      return 1
  end
  
  #--------------------------------------------------------------------------
  # ● Actor Cast
  #--------------------------------------------------------------------------            
  def actor_cast
      return @target.atb_cast[1] if $imported[:mog_atb_system]
      return @target.atb if $imported[:ve_active_time_battle]
      return @target.chant_count rescue 0 if @ccwinter_atb != nil 
      return 0
  end
  
  #--------------------------------------------------------------------------
  # ● Actor Max Cast
  #--------------------------------------------------------------------------            
  def actor_max_cast
      if $imported[:mog_atb_system]
         return @target.atb_cast[2] if @target.atb_cast[2] != 0
         return @target.atb_cast[0].speed.abs
      end           
      return @target.max_atb if $imported[:ve_active_time_battle]
      return -@target.max_chant_count rescue 1 if @ccwinter_atb != nil 
      return 1
  end
    
  #--------------------------------------------------------------------------
  # ● Actor Cast?
  #--------------------------------------------------------------------------            
  def actor_cast?
      if $imported[:mog_atb_system]
         return true if !@target.atb_cast.empty? rescue false
      end   
      if $imported[:ve_active_time_battle]
         return true if @target.cast_action? rescue false
      end       
      if @ccwinter_atb 
         return true if @target.chanting? rescue false
      end
      return false
  end    
  
end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase     
      attr_accessor :chant_count
      attr_accessor :max_chant_count
end