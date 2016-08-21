#==============================================================================
# +++ MOG - ATB SKILL NAME (v1.1) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Apresenta uma janela com o nome da ação do battler.
# Recomendado para quem usa o MOG ATB que não apresenta a janela de LOG.
#==============================================================================
# Será necessário ter as imagens
#
# Skill_Name_1.png
# Skill_Name_2.png
# 
# Na pasta /Graphics/Huds/Battle/
#==============================================================================

#==============================================================================
# HISTÓRICO
#==============================================================================
# v1.1 - Correção de não ativar o nome quando não se define uma animação.
#==============================================================================
module MOG_ATB_SKILL_NAME
  #Definição da posição da janela. 
  SKILL_NAME_POSITION = [Graphics.width  / 2,50]
  #Definição da posição do layout.
  SKILL_NAME_LAYOUT_POSITION = [10,-18]
  #Ativar animação de deslize.
  SKILL_NAME_SLIDE_ANIMATION = true
  #Definição da posição Z.
  SKILL_NAME_Z = 150  
  #Definições da fonte.
  SKILL_NAME_FONT_SIZE = 20
  SKILL_NAME_FONT_BOLD = true
  SKILL_NAME_FONT_ITALIC = false
  SKILL_NAME_FONT_COLOR = [255,255,255,255]
  # Coloque as IDs dos items que você quer desativar o nome.
  # DISABLE_ITEM_NAME = [5 , 8 , 21]
  DISABLE_ITEM_NAME = []
  # Coloque as IDs das skills que você quer desativar o nome.
  # DISABLE_SKILL_NAME = [25 , 36 , 98]
  DISABLE_SKILL_NAME = [127,128,129,130,131,156,160]  
end

$imported = {} if $imported.nil?
$imported[:mog_atb_skill_name] = true

#==============================================================================
# ** Game Temp
#==============================================================================
class Game_Temp
  
  attr_accessor :skill_name_bh
  attr_accessor :show_skill_name
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------    
  alias mog_skill_name_temp_initialize initialize
  def initialize
      @skill_name_bh = [nil,false] ; @show_skill_name = false
      mog_skill_name_temp_initialize
  end  
  
end

#==============================================================================
# ** Cache
#==============================================================================
module Cache

  #--------------------------------------------------------------------------
  # * Hud
  #--------------------------------------------------------------------------
  def self.battle_hud(filename)
      load_bitmap("Graphics/Huds/Battle/", filename)
  end

end

#==============================================================================
# ** Scene Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------    
  alias mog_skill_name_use_item use_item
  def use_item
      set_bh_skill_name  
      mog_skill_name_use_item
      $game_temp.show_skill_name = false
  end
  
  #--------------------------------------------------------------------------
  # * Set BH Skill Name
  #--------------------------------------------------------------------------    
  def set_bh_skill_name
      return if !can_execute_bh_skill_name?
      item = @subject.current_action.item ; $game_temp.show_skill_name = true
      $game_temp.skill_name_bh = [@subject.current_action.item,true]
  end
  
  #--------------------------------------------------------------------------
  # * Can Execute BH Skill Name
  #--------------------------------------------------------------------------    
  def can_execute_bh_skill_name?
      return false if @subject.current_action == nil
      return false if @subject.current_action.item == nil
      item_id = @subject.current_action.item.id rescue nil
      return false if item_id == nil
      if @subject.current_action.item.is_a?(RPG::Skill)
         return false if MOG_ATB_SKILL_NAME::DISABLE_SKILL_NAME.include?(item_id)
         return false if item_id == @subject.attack_skill_id
         return false if item_id == @subject.guard_skill_id
      elsif @subject.current_action.item.is_a?(RPG::Item)
         return false if MOG_ATB_SKILL_NAME::DISABLE_ITEM_NAME.include?(item_id)
      end
      return true
  end
  
end

#==============================================================================
# ** Spriteset Battle
#==============================================================================
class Spriteset_Battle
  include MOG_ATB_SKILL_NAME
  
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------    
  alias mog_skill_name_initialize initialize
  def initialize
      create_skill_name
      mog_skill_name_initialize
  end
  
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------    
  alias mog_skill_name_dispose dispose
  def dispose
      mog_skill_name_dispose
      dispose_skill_name
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------    
  alias mog_skill_name_update update
  def update
      mog_skill_name_update
      update_skill_name
  end
  
  #--------------------------------------------------------------------------
  # * Create Skill Name
  #--------------------------------------------------------------------------    
  def create_skill_name
      $game_temp.skill_name_bh = [nil,false] ; @skill_text = ["",0,false]
      @skill_name = Sprite.new
      @skill_name.bitmap = Bitmap.new(300,32)
      @skill_name.bitmap.font.size = SKILL_NAME_FONT_SIZE
      @skill_name.bitmap.font.bold = SKILL_NAME_FONT_BOLD
      @skill_name.bitmap.font.italic = SKILL_NAME_FONT_ITALIC
      @skill_name.bitmap.font.color = Color.new(SKILL_NAME_FONT_COLOR[0],SKILL_NAME_FONT_COLOR[1],SKILL_NAME_FONT_COLOR[2],SKILL_NAME_FONT_COLOR[3])
      @skill_name.z = SKILL_NAME_Z
      @skill_name_org = [SKILL_NAME_POSITION[0] - @skill_name.bitmap.width / 2,SKILL_NAME_POSITION[1] ]
      @skill_name.x = @skill_name_org[0] ; @skill_name.y = @skill_name_org[1]      
      @skill_name_l = Sprite.new
      @skill_name_l_image = [Cache.battle_hud("Skill_Name_1"),Cache.battle_hud("Skill_Name_2")]
      @skill_name_l.bitmap = @skill_name_l_image[0]
      @skill_name_l.z = SKILL_NAME_Z - 1
      @skill_name_l_org =[@skill_name.x + SKILL_NAME_LAYOUT_POSITION[0],@skill_name.y + SKILL_NAME_LAYOUT_POSITION[1]]
      @skill_name_l.x = @skill_name_l_org[0] ; @skill_name_l.y = @skill_name_l_org[1]      
      @skill_name.opacity = 0 ; @skill_name_l.opacity = @skill_name.opacity
      refresh_skill_name
  end
  
  #--------------------------------------------------------------------------
  # * Refresh Skill Name
  #--------------------------------------------------------------------------     
  def refresh_skill_name
      $game_temp.skill_name_bh[1] = false
      item = $game_temp.skill_name_bh[0]
      return if item == nil
      @skill_text[0] = item.name ; @skill_text[1] = 10     
      cm = @skill_text[0].to_s.split(//).size
      @center = (@skill_name.bitmap.font.size * cm) / 2
      @skill_name.bitmap.clear
      @skill_name.bitmap.draw_text(0,0,300,32,@skill_text[0].to_s,1)
      @skill_name.opacity = 0 ; @skill_name_l.opacity = @skill_name.opacity
      @skill_name.x = @skill_name_org[0] - 60 if SKILL_NAME_SLIDE_ANIMATION
      @skill_name_l.x = @skill_name_l_org[0] - 60 if SKILL_NAME_SLIDE_ANIMATION
      @skill_name_l.bitmap = item.is_a?(RPG::Skill) ? @skill_name_l_image[0] : @skill_name_l_image[1]
  end
  
  #--------------------------------------------------------------------------
  # * Dispose Skill Name
  #--------------------------------------------------------------------------    
  def dispose_skill_name
      return if @skill_name == nil
      @skill_name.bitmap.dispose ; @skill_name.dispose
      @skill_name_l.bitmap.dispose ; @skill_name_l.dispose
  end
  
  #--------------------------------------------------------------------------
  # * Update Skill Name
  #--------------------------------------------------------------------------    
  def update_skill_name
      return if @skill_name == nil
      if @skill_text[1] > 0 and !$game_temp.battle_end
         @skill_text[1] -= 1 if !$game_temp.show_skill_name
         @skill_name.opacity += 8
         @skill_name.x += 2 if @skill_name.x < @skill_name_org[0]
         @skill_name_l.x += 2 if @skill_name_l.x < @skill_name_l_org[0]
      else   
         if @skill_name.opacity > 0
            @skill_name.opacity -= 8
            @skill_name.x += 2 if SKILL_NAME_SLIDE_ANIMATION
            @skill_name_l.x += 2 if SKILL_NAME_SLIDE_ANIMATION
         end
      end   
      @skill_name_l.opacity =  @skill_name.opacity
      refresh_skill_name if $game_temp.skill_name_bh[1]
  end
  
end