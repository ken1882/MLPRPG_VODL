#==============================================================================
# +++ MOG - ATB Meter (v1.2)+++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Adiciona medidores de ATB nos inimigos e aliados.
#==============================================================================
# Histórico
#==============================================================================
# v1.2 - Compatibilidade com MOG Battle Camera.
#==============================================================================
$imported = {} if $imported.nil?
$imported[:mog_atb_meter] = true

module MOG_ATB_Meter
  #Ativar os medidores nos aliados.
  ENABLE_FOR_ACTOR = false
  #Ativar os medidores nos inimigos.
  ENABLE_FOR_ENEMY = true
  #Ativar Medidor animado. (É necessário dividir a largura da imagem por 3)
  GRADIENT_ANIMATION = true
  #Posição da Hud é fixa.(false = a posição é baseada na posição real do battler)
  HUD_POSITION_FIX = false
  #Definição da posição Z dos sprites. (Para Ajustes)
  SCREEN_Z = -90
  #Definição da posição do Layout
  LAYOUT_POSITION = [0,0]
  #Definição da posição do medidor.
  METER_POSITION = [0,0]
  # Não modifique essa parte.
  # ☢CAUTION!!☢ Don't Touch.^_^ 
  FIXED_ACTOR_POSITION = []
  FIXED_ENEMY_POSITION = []
  # Definição especifica do medidor baseado na ID da posição do Battler ou
  # a ID do battler no caso dos inimigos.
  # Essa opção serve para fazer ajustes na posição do sprite
  FIXED_ACTOR_POSITION[0] = [0,-64]
  FIXED_ACTOR_POSITION[1] = [0,-64]
  FIXED_ACTOR_POSITION[2] = [0,-64]
  FIXED_ACTOR_POSITION[3] = [0,-64]
  
  FIXED_ENEMY_POSITION[11] = [0,-64] # Remilia Scarlet
  FIXED_ENEMY_POSITION[12] = [0,-64] # Frandle Scarlet
  FIXED_ENEMY_POSITION[950] = [-30,-20]
  FIXED_ENEMY_POSITION[951] = [-50,-30] 
  FIXED_ENEMY_POSITION[952] = [-100,-60]
end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
 
  attr_accessor :battle_end
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------      
  alias mog_atb_meter_initialize initialize
  def initialize
      @battle_end = false
      mog_atb_meter_initialize
  end
  
end

#===============================================================================
# ■ Spriteset_Battle
#===============================================================================
class Sprite_Battler < Sprite_Base
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------  
  alias mog_atb_meter_dispose dispose
  def dispose
      dispose_atb_meter
      mog_atb_meter_dispose      
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------          
  alias mog_atb_meter_update update
  def update
      mog_atb_meter_update
      update_atb_meter
  end
    
  #--------------------------------------------------------------------------
  # ● Refresh ATB Meter
  #--------------------------------------------------------------------------          
  def refresh_atb_meter
      return if @atb_meter != nil
      @atb_meter = ATB_Meter.new(@battler)
      @atb_created = true
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose ATB Meter
  #--------------------------------------------------------------------------          
  def dispose_atb_meter
      return if @atb_meter == nil
      @atb_meter.dispose
  end
  
  #--------------------------------------------------------------------------
  # ● Update ATB Meter
  #--------------------------------------------------------------------------          
  def update_atb_meter
      refresh_atb_meter if @atb_created == nil
      return if @atb_meter == nil
      @atb_meter.update
  end
  
end

#===============================================================================
# ■ Spriteset_Battle
#===============================================================================
class ATB_Meter
  include MOG_ATB_Meter
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------          
  def initialize(battler)
      screen_x = battler.screen_x rescue nil
      return if screen_x == nil
      if $imported[:mog_battle_hud_ex]
      return if battler.is_a?(Game_Actor) and SceneManager.face_battler?
      end
      if battler.is_a?(Game_Actor) and !ENABLE_FOR_ACTOR ; return ; end
      if battler.is_a?(Game_Enemy) and !ENABLE_FOR_ENEMY ; return ; end
      @battler = battler
      catb = ATB::MAX_AP rescue nil ; @ccwinter_atb = true if catb != nil 
      create_sprites ; set_sprites_position ;  update_meter ; update_position
  end
  
  #--------------------------------------------------------------------------
  # ● Create Sprites
  #--------------------------------------------------------------------------          
  def create_sprites
      @layout = Sprite.new ; @layout.bitmap = Cache.system("ATB_Layout")
      @layout.ox = @layout.bitmap.width / 2 ; @layout.oy = @layout.bitmap.height / 2
      @layout_oxy_org = [@layout.ox,@layout.oy]
      @meter_image = Cache.system("ATB_Meter")
      @meter_cw = GRADIENT_ANIMATION ? @meter_image.width / 3 : @meter_image.width
      @meter_ch = @meter_image.height / 3
      @meter_flow = 0 ; @meter_flow_max = @meter_cw * 2
      @meter = Sprite.new ; @meter.bitmap = Bitmap.new(@meter_cw,@meter_ch)
      @meter.ox = @meter.bitmap.width / 2 ; @meter.oy = @meter.bitmap.height / 2
      @meter_oxy_org = [@meter.ox,@meter.oy]
      @layout.opacity = 0 ; @meter.opacity = 0
  end  
  
  #--------------------------------------------------------------------------
  # ● Set Sprites Position
  #--------------------------------------------------------------------------          
  def set_sprites_position
      if @battler.is_a?(Game_Actor)
         if FIXED_ACTOR_POSITION[@battler.index] != nil
            @lp = [FIXED_ACTOR_POSITION[@battler.index][0],FIXED_ACTOR_POSITION[@battler.index][1] + @layout.height]
         else
            @lp = [LAYOUT_POSITION[0],LAYOUT_POSITION[1] + @layout.height]
         end
         @mp = [METER_POSITION[0],METER_POSITION[1]]
      else
         if FIXED_ENEMY_POSITION[@battler.enemy_id] != nil
            @lp = [FIXED_ENEMY_POSITION[@battler.enemy_id][0],FIXED_ENEMY_POSITION[@battler.enemy_id][1] + @layout.height]
         else
            @lp = [LAYOUT_POSITION[0],LAYOUT_POSITION[1] + @layout.height]
         end        
         @mp = [METER_POSITION[0],METER_POSITION[1]]
      end  
      @layout.x = @battler.screen_x + @lp[0] 
      @layout.y = @battler.screen_y + @lp[1]   
      @meter.x = @layout.x + @mp[0] ;  @meter.y = @layout.y + @mp[1]
      @layout.z = @battler.screen_z + SCREEN_Z ;  @meter.z = @layout.z + 1    
  end
  
  #--------------------------------------------------------------------------
  # ● Update Meter
  #--------------------------------------------------------------------------          
  def update_meter
      @meter.bitmap.clear
      @meter_flow = 0 if !GRADIENT_ANIMATION
      if actor_cast?
         meter_width = @meter_cw * actor_cast / actor_max_cast rescue nil
         meter_width = 0 if meter_width == nil 
         ch = @meter_ch * 2
      else
         meter_width = @meter_cw * actor_at / actor_max_at rescue nil
         meter_width = 0 if meter_width == nil         
         ch = actor_at >= actor_max_at ? @meter_ch : 0
      end   
      meter_src_rect = Rect.new(@meter_flow, ch ,meter_width, @meter_ch)
      @meter.bitmap.blt(0,0, @meter_image, meter_src_rect)  
      @meter_flow += 2
      @meter_flow = 0 if @meter_flow >= @meter_flow_max
      update_battle_camera if  update_battle_camera_atb_m?
  end
  
  #--------------------------------------------------------------------------
  # ● Update Battle Cursor
  #--------------------------------------------------------------------------              
  def update_battle_camera_atb_m?
      return false if $imported[:mog_battle_camera] == nil
      if $imported[:mog_battle_hud_ex] and SceneManager.face_battler?
         return false if @battler.is_a?(Game_Actor)
      end    
      return true
   end     
  
  #--------------------------------------------------------------------------
  # ● Update Battle Camera
  #--------------------------------------------------------------------------              
  def update_battle_camera
      @meter.ox = $game_temp.viewport_oxy[0] + @meter_oxy_org[0]
      @meter.oy = $game_temp.viewport_oxy[1] + @meter_oxy_org[1]
      @layout.ox = $game_temp.viewport_oxy[0] + @layout_oxy_org[0]
      @layout.oy = $game_temp.viewport_oxy[1] + @layout_oxy_org[1]
  end
   
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------          
  def dispose
      return if @layout == nil
      @layout.bitmap.dispose ; @layout.dispose
      @meter.bitmap.dispose ; @meter.dispose
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------          
  def update
      return if @layout == nil
      update_position if update_atb_position? ; update_meter ; update_visible
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------          
  def update_visible
      if sprite_visible? ; @layout.opacity += 10
      else ; @layout.opacity -= 10 
      end
      @meter.opacity = @layout.opacity
  end
  
  #--------------------------------------------------------------------------
  # ● Sprite Visible?
  #--------------------------------------------------------------------------          
  def sprite_visible?
      return false if $game_temp.battle_end
      return false if $game_message.visible
      return false if $game_troop.interpreter.running?
      return false if @battler.dead?
      return false if @battler.hidden?
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Update Position
  #--------------------------------------------------------------------------          
  def update_position
      @layout.z = @battler.screen_z + SCREEN_Z ; @meter.z = @layout.z + 1
      @layout.x = @battler.screen_x + @lp[0]
      @layout.y = @battler.screen_y + @lp[1]  
      @meter.x = @layout.x + @mp[0]
      @meter.y = @layout.y + @mp[1]
  end
  
  #--------------------------------------------------------------------------
  # ● Update ATB Position?
  #--------------------------------------------------------------------------          
  def update_atb_position?
      return false if HUD_POSITION_FIX
      if $imported[:mog_atb_system] and BattleManager.subject != nil
         return false if @battler == BattleManager.subject
         if @battler.is_a?(Game_Actor) and BattleManager.subject.is_a?(Game_Enemy)
            return false
         elsif @battler.is_a?(Game_Enemy) and BattleManager.subject.is_a?(Game_Actor)
            return false 
         end
      end
      return true
  end
  
  #--------------------------------------------------------------------------
  # * AT
  #--------------------------------------------------------------------------  
  def actor_at
      return @battler.atb if $imported[:mog_atb_system]
      return @battler.atb if $imported[:ve_active_time_battle]
      return @battler.catb_value if $imported["YSA-CATB"]
      return @battler.ap if @ccwinter_atb != nil
      return 0
  end

  #--------------------------------------------------------------------------
  # * Max AT
  #--------------------------------------------------------------------------  
  def actor_max_at
      return @battler.atb_max if $imported[:mog_atb_system]
      return @battler.max_atb if $imported[:ve_active_time_battle]
      return @battler.max_atb if $imported["YSA-CATB"]
      return ATB::MAX_AP if @ccwinter_atb != nil
      return 1
  end

  #--------------------------------------------------------------------------
  # ● Actor Cast
  #--------------------------------------------------------------------------            
  def actor_cast
      return @battler.atb_cast[1] rescue nil if $imported[:mog_atb_system]
      return -@battler.atb if $imported[:ve_active_time_battle]
      return @battler.chant_count rescue 0 if @ccwinter_atb != nil 
      return 0
  end

  #--------------------------------------------------------------------------
  # ● Actor Max Cast
  #--------------------------------------------------------------------------            
  def actor_max_cast
      if $imported[:mog_atb_system]
         return @battler.atb_cast[2] if @battler.atb_cast[2] != 0
         return @battler.atb_cast[0].speed.abs
      end   
      return @battler.max_atb if $imported[:ve_active_time_battle]
      return -@battler.max_chant_count rescue 1 if @ccwinter_atb != nil 
      return 1
  end  

  #--------------------------------------------------------------------------
  # ● Actor Cast?
  #--------------------------------------------------------------------------            
  def actor_cast?   
      if $imported[:mog_atb_system]
         return true if !@battler.atb_cast.empty?
      end   
      if $imported[:ve_active_time_battle]
         return true if @battler.cast_action?
      end       
      if @ccwinter_atb 
         return true if @battler.chanting? 
      end
      return false
  end    
  
end