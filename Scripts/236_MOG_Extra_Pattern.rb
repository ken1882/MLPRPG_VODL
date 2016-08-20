#==============================================================================
# +++ MOG - Extra Pattern (v1.0) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# O script permite definir a quantidade de frames de animações do personagem.
#==============================================================================

#==============================================================================
# UTILIZAÇÃO
#==============================================================================
# FILE_NAME[X].png
#
# X - Quantidade de frames.
#
# Alice[8].png
#
#==============================================================================

$imported = {} if $imported.nil?
$imported[:mog_extra_pattern] = true

#==============================================================================
# ■ Game_CharacterBase
#==============================================================================
class Game_CharacterBase

  attr_accessor :e_pattern
  attr_accessor :original_pattern
  
  #--------------------------------------------------------------------------
  # ● Init Public Members
  #--------------------------------------------------------------------------
  alias mog_extra_pattern_init_public_members init_public_members
  def init_public_members
      @e_pattern = 0
      mog_extra_pattern_init_public_members
  end

  #--------------------------------------------------------------------------
  # ● Update Anime Pattern
  #--------------------------------------------------------------------------
  alias mog_extra_pattern_update_anime_pattern update_anime_pattern
  def update_anime_pattern
      return if update_extra_anime_pattern?
      mog_extra_pattern_update_anime_pattern
  end    
     
  #--------------------------------------------------------------------------
  # ● Update Extra Anime Pattern
  #--------------------------------------------------------------------------  
  def update_extra_anime_pattern?
      return false if @e_pattern == 0
      if !@step_anime && @stop_count > 0
         @pattern = @original_pattern
      else
         @pattern = (@pattern + 1) % @e_pattern
      end
      return true 
  end  
  
  #--------------------------------------------------------------------------
  # ● Straighten
  #--------------------------------------------------------------------------
  alias mog_extra_pattern_straighten straighten
  def straighten
      mog_extra_pattern_straighten
      @pattern = 0 if (@walk_anime || @step_anime) and @e_pattern > 0
  end  
  
end  
  
#==============================================================================
# ■ Sprite Character 
#==============================================================================
class Sprite_Character < Sprite_Base
  
  #--------------------------------------------------------------------------
  # ● Set Character Bitmap
  #--------------------------------------------------------------------------
  alias mog_extra_pattern_set_character_bitmap set_character_bitmap
  def set_character_bitmap
      return if can_set_extra_pattern? rescue nil
      mog_extra_pattern_set_character_bitmap        
  end
  
  #--------------------------------------------------------------------------
  # ● Can Set Extra Pattern
  #--------------------------------------------------------------------------  
  def can_set_extra_pattern?
      if @character.character_name =~ /\[(\d+)]/i
         set_character_extra_pattern($1.to_i)
         return true
      end
      return false
  end
  
  #--------------------------------------------------------------------------
  # ● Set Character Extra Pattern
  #--------------------------------------------------------------------------    
  def set_character_extra_pattern(frames)
      self.bitmap = Cache.character(@character_name)
      @character.e_pattern = frames
      @character.pattern = 0
      @character.original_pattern = 0
      @cw = bitmap.width / @character.e_pattern
      @ch = bitmap.height / 4
      self.ox = @cw / 2
      self.oy = @ch     
      if $schala_battle_system != nil
         set_sprite_size(@ch,@cw) if @cw != nil and @cw != nil
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Update Scr Rect
  #--------------------------------------------------------------------------
  alias mog_extra_pattern_update_src_rect update_src_rect
  def update_src_rect
      return if update_extra_pattern_src_rect?
      mog_extra_pattern_update_src_rect
  end
  
  #--------------------------------------------------------------------------
  # ● Update Extra Pattern Src Rect
  #--------------------------------------------------------------------------  
  def update_extra_pattern_src_rect?
      return false if @character.e_pattern == 0
      pattern = @character.pattern < @character.e_pattern ? @character.pattern : 0
      sx = @character.pattern * @cw
      sy = ((@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
      return true
  end
  
end

#==============================================================================
# ■ Window Base
#==============================================================================
class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # ● Draw Character
  #--------------------------------------------------------------------------
  alias mog_extra_pattern_draw_character draw_character
  def draw_character(character_name, character_index, x, y)
      return if draw_character_extra_pattern?(character_name, character_index, x, y)
      mog_extra_pattern_draw_character(character_name, character_index, x, y)
  end  
    
  #--------------------------------------------------------------------------
  # ● Draw Character Extra Pattern
  #--------------------------------------------------------------------------  
  def draw_character_extra_pattern?(character_name, character_index, x, y)
      return false unless character_name
      if character_name =~ /\[(\d+)]/i
         bitmap = Cache.character(character_name)
         cw = bitmap.width / $1.to_i
         ch = bitmap.height / 4
         src_rect = Rect.new(0, 0, cw, ch)
         contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
         return true
      end
      return false
  end    
    
end  