#==============================================================================
# +++ MOG - CP Animation (v1.0)+++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Ativa uma animação apresentando os personagens que usarão as 
# habilidades de cooperação.
#
# NOTA - É necessãrio ter o script MOG ATB para este script funcionar
#
#==============================================================================
# UTILIZAÇÃO
#==============================================================================
# Coloque a tag abaixo no caixa de notas das habilidades de cooperação.
#
# <CP Animation>
#
#==============================================================================
# IMAGENS
#==============================================================================
# Grave as imagens dos personagens na pasta Graphics/Pictures/
#
# Actor + INDEX.jpg
#
# Ex
#
# Actor1.png
# Actor2.png
# Actor3.png
# ...
#
#==============================================================================

$imported = {} if $imported.nil?
$imported[:mog_atb_cp_animation] = true

#==============================================================================
# ■ Scene Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Before Execute Coomperation Skill.
  #--------------------------------------------------------------------------  
  alias mog_atb_ct_animation_before_execute_cooperation_skill before_execute_cooperation_skill
  def before_execute_cooperation_skill
      execute_cp_animation if can_execute_cp_animation?
      mog_atb_ct_animation_before_execute_cooperation_skill
  end  
  
  #--------------------------------------------------------------------------
  # ● Can Execute CP Animation
  #--------------------------------------------------------------------------  
  def can_execute_cp_animation?
      return false if current_cp_members.size == 0
      return true if subject_action.note =~ /<CP Animation>/      
      return false
  end
  
  #--------------------------------------------------------------------------
  # ● Execute CP Animation
  #--------------------------------------------------------------------------  
  def execute_cp_animation
      cp_anim = CP_Animation.new(current_cp_members)
      loop do ; cp_anim.update ; break if cp_anim.phase == 100 
      Graphics.update ; end ; cp_anim.terminate
  end
  
end

#==============================================================================
# ■ CP Animation
#==============================================================================
class CP_Animation
  
  attr_accessor :phase
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  def initialize(members)
      @phase = 0 ; @sprites = []      
      members.each_with_index do |actor, index|
          @sprites[index] = [Sprite.new, 120 + (15 * index),0]
          @sprites[index][0].bitmap = Cache.picture("Actor" + actor.id.to_s)
          x1 = Graphics.width / members.size
          @sprites[index][0].ox = @sprites[index][0].bitmap.width / 2
          @sprites[index][0].oy = @sprites[index][0].bitmap.height / 2
          @sprites[index][2] = (x1 / 2) + (x1 * index) 
          @sprites[index][0].x = @sprites[index][2] - 30
          @sprites[index][0].y = Graphics.height - (@sprites[index][0].bitmap.height - @sprites[index][0].oy)
          @sprites[index][0].z = 11000 + index ; @sprites[index][0].opacity = 0
          @sprites[index][0].zoom_x =  1.30 ; @sprites[index][0].zoom_y =  @sprites[index][0].zoom_x
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Terminate
  #--------------------------------------------------------------------------  
  def terminate
      @sprites.each {|sprite| sprite[0].bitmap.dispose ; sprite[0].dispose }
  end

  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  def update
      phase_end = true
      for sprite in @sprites
          phase_end = false if sprite[1] > 0 ; sprite[1] -= 1 if sprite[1] > 0
          case sprite[1]
          when 90..120 
            sprite[0].opacity += 9 ; sprite[0].x += 1 if sprite[0].x < sprite[2]
            sprite[0].zoom_x -= 0.01 if sprite[0].zoom_x > 1.00
          when 0..30 
            sprite[0].opacity -= 9 ; sprite[0].x += 1
          end
          sprite[0].zoom_y =  sprite[0].zoom_x
      end
         @phase = 100 if phase_end
    end
  
end