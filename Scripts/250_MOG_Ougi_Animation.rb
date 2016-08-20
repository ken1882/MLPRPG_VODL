#==============================================================================
# +++ MOG - Ougi Animation  (v1.8) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Apresenta uma animação em pictures antes de ativar alguma ação.
#==============================================================================
# Serão necessários os seguintes arquivos na pasta Graphics/Pictures/.
#
# Actor + ID.png
# Actor + ID + _Ougi.png
#
#==============================================================================
# EXEMPLO
#==============================================================================
# Actor1.png
# Actor1_Ougi.png
#
# Enemy7.png
# Enemy7_ougi.png
#
#==============================================================================
# Para ativar a animação basta colocar o seguinte comentário na caixa de notas
# da skill ou itens.
#
# <Ougi Animation>
#
#==============================================================================

#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 3.7 - Melhoria na compatibilidade de scripts.
#==============================================================================

$imported = {} if $imported.nil?
$imported[:mog_ougi_animation] = true

module MOG_OUGI_ANIMATION
  #Definição do som ao ativar a animação.  
  SOUND_FILE = "Flash2"  
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Use Item
  #--------------------------------------------------------------------------
  alias mog_sp_animation_use_item use_item
  def use_item
      update_sp_animation
      mog_sp_animation_use_item 
  end
  
  #--------------------------------------------------------------------------
  # ● Can SP Animation?
  #--------------------------------------------------------------------------    
  def can_sp_animation?
      skill = @subject.current_action.item
      return true if skill.note =~ /<Ougi Animation>/
      return false
  end
  
  #--------------------------------------------------------------------------
  # ● Update SP Animation
  #--------------------------------------------------------------------------  
  def update_sp_animation
      return unless can_sp_animation?       
      special_animation = Ougi_Animation.new(@subject)
      if $imported[:mog_menu_cursor]    
         valor_x = $game_temp.menu_cursor[2] ; $game_temp.menu_cursor[2] = -999
         force_cursor_visible(false)
      end
      loop do
          @ougi_ref = true
          special_animation.update ; Graphics.update ; Input.update
          break if special_animation.phase == 3
      end
      special_animation.dispose
      $game_temp.menu_cursor[2] = valor_x if $imported[:mog_menu_cursor]
  end

end

#==============================================================================
# ■ Ougi Animation
#==============================================================================
class Ougi_Animation
  
  include MOG_OUGI_ANIMATION 
  attr_accessor :phase
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------    
  def initialize(subject)      
      @phase = 0 ; create_battler(subject) ; create_background(subject)
      Audio.se_play("Audio/SE/" + SOUND_FILE.to_s, 100, 100) rescue nil if @phase != 3
  end    
  
  #--------------------------------------------------------------------------
  # ● Create Background
  #--------------------------------------------------------------------------      
  def create_background(subject)
      @background_sprite = Sprite.new
      if subject.is_a?(Game_Actor)
         battler_id = "Actor" + subject.id.to_s
      else   
         battler_id = "Enemy" + subject.enemy_id.to_s
      end       
      bname = battler_id.to_s + "_Ougi"if bname == nil
      @background_sprite.bitmap = Cache.picture(bname) rescue nil      
      @background_sprite.z = 11000 ; @background_sprite.opacity = 0
      @background_sprite.zoom_x = 1.00 ; @background_sprite.zoom_y = 1.00
      if @background_sprite.bitmap != nil
         @background_sprite.ox = @background_sprite.bitmap.width / 2
         @background_sprite.oy = @background_sprite.bitmap.height / 2
         @background_sprite.x = @background_sprite.ox 
         @background_sprite.y = @background_sprite.oy
      end
      @phase = @background_sprite.bitmap != nil ? 0 : 3 
  end
  
  #--------------------------------------------------------------------------
  # ● Create Battler
  #--------------------------------------------------------------------------      
  def create_battler(subject)
      @battler_sprite = Sprite.new
      if subject.is_a?(Game_Actor)
         bname = "Actor" + subject.id.to_s
      else   
         bname = "Enemy" + subject.enemy_id.to_s
      end  
      @battler_sprite.bitmap = Cache.picture(bname) rescue nil
      @battler_sprite.z = 12000 ; @battler_org = [0,0]
      if @battler_sprite.bitmap != nil
         @battler_sprite.ox = @battler_sprite.bitmap.width / 2
         @battler_sprite.oy = @battler_sprite.bitmap.height / 2
         px = @battler_sprite.ox  + ((Graphics.width / 2) - (@battler_sprite.bitmap.width / 2))
         @battler_sprite.y = @battler_sprite.oy + (Graphics.height - @battler_sprite.bitmap.height)
         @battler_org = [px - 130,px]
         @battler_sprite.x = @battler_org[0] 
     end
     @battler_sprite.zoom_x = 2 ; @battler_sprite.zoom_y = 2
     @battler_sprite.opacity = 0
     @phase = @battler_sprite.bitmap != nil ? 0 : 3     
  end       
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------    
  def dispose
      dispose_battler_sprite ; dispose_background_sprite
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Battler Sprite
  #--------------------------------------------------------------------------      
  def dispose_battler_sprite
      return if @battler_sprite == nil
      if @battler_sprite.bitmap != nil
         @battler_sprite.bitmap.dispose ; @battler_sprite.bitmap = nil
      end
      @battler_sprite.dispose ; @battler_sprite = nil    
  end  
  
  #--------------------------------------------------------------------------
  # ● Dispose Background Sprite
  #--------------------------------------------------------------------------        
  def dispose_background_sprite
      return if @background_sprite == nil
      if @background_sprite.bitmap != nil
         @background_sprite.bitmap.dispose ; @background_sprite.bitmap = nil
      end  
      @background_sprite.dispose ; @background_sprite = nil
  end  
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------    
  def update
      return if @phase == 3
      case @phase
        when 0; update_start 
        when 1; update_slide 
        when 2; update_end  
     end
     @background_sprite.zoom_x += 0.004
     @background_sprite.zoom_y = @background_sprite.zoom_x
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Start
  #--------------------------------------------------------------------------      
  def update_start
      @battler_sprite.zoom_x -= 0.03 ; @battler_sprite.opacity += 5
      @background_sprite.opacity += 10 ; @battler_sprite.x += 3
      if @battler_sprite.zoom_x <= 1.00
         @battler_sprite.zoom_x = 1.00 ; @battler_sprite.opacity = 255
         @background_sprite.opacity = 255 ; @phase = 1
      end   
      @battler_sprite.zoom_y = @battler_sprite.zoom_x 
  end  
      
  #--------------------------------------------------------------------------
  # ● Update Slide
  #--------------------------------------------------------------------------        
  def update_slide
      @battler_sprite.x += 1 ; @phase = 2 if @battler_sprite.x >= @battler_org[1]
  end

  #--------------------------------------------------------------------------
  # ● Update End
  #--------------------------------------------------------------------------        
  def update_end
      @battler_sprite.zoom_x += 0.03
      @battler_sprite.zoom_y = @battler_sprite.zoom_x
      @battler_sprite.opacity -= 5 ; @background_sprite.opacity -= 5
      @phase = 3 if @battler_sprite.opacity <= 0
  end  
  
end