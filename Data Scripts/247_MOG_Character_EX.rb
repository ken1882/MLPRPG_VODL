#==============================================================================
# +++ MOG - Character EX (v1.2) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Adiciona vários efeitos visuais animados nos characters.
#==============================================================================

#==============================================================================
# ■ AUTO MODE (Animated Effects)
#==============================================================================
# Os efeitos começam automaticamente, coloque no evento os sequintes
# comentários para ativar os efeitos.
#
# <Effects = EFFECT_TYPE> 
#
# EX
#
# <Effects = Breath>
# <Effects = Ghost>
# <Effects = Clear>   
#
#  <--- EFFECT_TYPE --->
# 
# ●   Breath 
# Ativa o efeito de respiração. (LOOP EFFECT)
#
# ●   Big Breath
# Ativa o efeito de loop de zoom in e out. (LOOP EFFECT)
#
# ●   Ghost
# Ativa o efeito de desaparecer e aparecer. (LOOP EFFECT)
#
# ●   Swing
# Ativa o efeito do character balançar para os lados.
#
# ●   Swing Loop
# Ativa o efeito do character balançar para os lados. (LOOP EFFECT)
#
# ●  Spin
# Faz o character girar em 360 graus
#
# ●  Spin Loop 
# Faz o character girar em 360 graus. (LOOP EFFECT)
#
# ●  Slime Breath
# Ativa o efeito de movimento semelhante ao de um slime. (LOOP EFFECT)
#
# ●  Crazy
# 
# Faz o character virar para esquerda e direita rapidamente. (LOOP EFFECT)
#
# ●  Appear
# Ativa o efeito de aparição.
#
# ●  Disappear
# Ativa o efeito de desaparecer.
#
# ●  Dwarf
# Deixa o character anão.
#
# ●  Giant
# Deixa o character gigante.
#
# ●  Normal
# Faz o character voltar ao normal de forma gradual.
#
# ●  Clear
# Cancela todos os efeitos.
#
#==============================================================================

#==============================================================================
# ■ MANUAL MODE (Animated Effects)
#==============================================================================
# Use o código abaixo através do comando chamar script. 
#
# char_effect(EVENT_ID, EFFECT_TYPE)
#
# EX -    char_effect( 10,"Breath")
#         char_effect( 0, "Dwarf")     
#
# ● EVENT_ID
# - Maior que 0 para definir as IDs dos eventos no mapa.
# - Iguál a 0 para ativar os efeitos no personagem principal (Leader).
# - Menor que 0 para definir as IDs dos sequidores.
#
# ● EFFECT_TYPE
# - Use os mesmos nomes dos efeitos da ativação automática.
# 
#==============================================================================

#==============================================================================
# ■ EXTRA EFFECTS (Fix Values)
#==============================================================================
#
# ●     <Zoom = X> 
#   
# ●     <Opacity = X> 
#
# ●     <Blend Type = X>   
#    
# ●     <Mirror = X>   
#
#==============================================================================

#==============================================================================
# ■ CANCEL EFFECTS        (Loop Effects)
#==============================================================================
#
# ●     char_effect(EVENT_ID, "Clear")
# EX -  char_effect(15, "Clear") 
#
# Para cancelar um evento(Personagem) especifico.
#
# ●     clear_all_events_effects
# Para cancelar todos os efeitos dos eventos no mapa.
#
# ●     clear_all_party_effects     
# Para cancelar todos os efeitos do grupo(Personagem).
#
# ●     clear_all_ex_effects
# Para cancelar tudo.
#
#==============================================================================


#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 1.2 - Adição dos comandos para definir valores fixos nos characters.
# v 1.1 - Correção na definição da ID dos personagens aliados.
#==============================================================================

#==============================================================================
# ■ Game_CharacterBase
#==============================================================================
class Game_CharacterBase
  
  attr_accessor :effects
  attr_accessor :opacity
  attr_accessor :erased
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :mirror
  attr_accessor :angle
  attr_accessor :blend_type
  
  #--------------------------------------------------------------------------
  # ● initialize
  #--------------------------------------------------------------------------  
  alias mog_character_effects_initialize initialize
  def initialize
      @effects = ["",0,false]
      @zoom_x = 1.00
      @zoom_y = 1.00
      @mirror = false
      @angle = 0
      mog_character_effects_initialize
  end
  
  #--------------------------------------------------------------------------
  # ● Clear Effects
  #--------------------------------------------------------------------------      
  def clear_effects
      @effects = ["",0,false]
      @zoom_x = 1.00
      @zoom_y = 1.00
      @mirror = false
      @angle = 0
      @opacity = 255
      @blend_type = 0
  end  
  
  #--------------------------------------------------------------------------
  # ● update
  #--------------------------------------------------------------------------    
  alias mog_character_ex_effects_update update
  def update
      mog_character_ex_effects_update
      update_character_ex_effects
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Character EX Effects
  #--------------------------------------------------------------------------      
  def update_character_ex_effects
      return if @erased or @effects[0] == ""
      check_new_effect if @effects[2]
      case @effects[0] 
         when "Breath";        update_breath_effect
         when "Ghost";         update_ghost_effect           
         when "Big Breath";    update_big_breath_effect
         when "Slime Breath";  update_slime_breath_effect               
         when "Spin Loop";     update_spin_loop_effect           
         when "Swing Loop";    update_swing_loop_effect
         when "Crazy";         update_crazy_effect           
         when "Appear";        update_appear_effect
         when "Disappear";     update_disappear_effect
         when "Swing";         update_swing_effect
         when "Spin";          update_spin_effect
         when "Dwarf";         update_dwarf_effect
         when "Giant";         update_giant_effect
         when "Normal";         update_normal_effect  
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Check New Effect
  #--------------------------------------------------------------------------        
  def check_new_effect
      @effects[2] = false
      @effects[1] = 0
      unless @effects[0] == "Normal"
             @opacity = 255
             @angle = 0
             @mirror = false
             unless (@effects[0] == "Dwarf" or @effects[0] == "Giant") 
                  @zoom_x = 1.00
                  @zoom_y = 1.00
             end                   
      end     
      case @effects[0] 
         when "Breath"
            @effects[1] = rand(60)
         when "Appear"
            @zoom_x = 0.1
            @zoom_y = 3.5
            @opacity = 0
         when "Ghost"
            @opacity = rand(255)
         when "Swing Loop"
            @angle = 20
            @effects[1] = rand(60)
         when "Spin Loop"
            @angle = rand(360)
         when "Slime Breath"
            @effects[1] = rand(60)
         when "Big Breath"
            @effects[1] = rand(60)
         when "Normal"
            pre_angle = 360 * (@angle / 360).truncate
            @angle = @angle - pre_angle
            @angle = 0 if @angle < 0
      end
  end  
  
  #--------------------------------------------------------------------------
  # ● Check New Effect
  #--------------------------------------------------------------------------          
  def update_breath_effect
      @effects[1] += 1
      case @effects[1]
         when 0..25
           @zoom_y += 0.005
           if @zoom_y > 1.12
              @zoom_y = 1.12
              @effects[1] = 26
           end  
         when 26..50
           @zoom_y -= 0.005
           if @zoom_y < 1.0 
              @zoom_y = 1.0
              @effects[1] = 51
           end           
         else
           @zoom_x = 1
           @zoom_y = 1
           @effects[1] = 0 
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Update Ghost Effect
  #--------------------------------------------------------------------------            
  def update_ghost_effect
      @effects[1] += 1
      case @effects[1]
         when 0..55
             @opacity += 5
             @effects[1] = 56 if @opacity >= 255
         when 56..120
             @opacity -= 5
             @effects[1] = 121 if @opacity <= 0
         else
            @opacity = 0
            @effects[1] = 0
      end 
  end  

  #--------------------------------------------------------------------------
  # ● Update Swing Loop Effect
  #--------------------------------------------------------------------------              
  def update_swing_loop_effect
      @effects[1] += 1
      case @effects[1]
         when 0..40
            @angle -= 1
            if @angle < -19
               @angle = -19
               @effects[1] = 41
            end  
         when 41..80 
            @angle += 1
            if @angle > 19
               @angle = 19
               @effects[1] = 81
            end   
         else
            @angle = 20
            @effects[1] = 0
       end
  end  

  #--------------------------------------------------------------------------
  # ● Update Swing Effect
  #--------------------------------------------------------------------------              
  def update_swing_effect
      @effects[1] += 1
      case @effects[1]
         when 0..20
            @angle -= 1
         when 21..60 
            @angle += 1
         when 61..80  
            @angle -= 1
         else
            clear_effects
      end     
  end  
    
  #--------------------------------------------------------------------------
  # ● Update Spin Loop Effect
  #--------------------------------------------------------------------------                
  def update_spin_loop_effect
      @angle += 3
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Spin Effect
  #--------------------------------------------------------------------------                
  def update_spin_effect
      @angle += 10
      clear_effects if @angle >= 360
  end    
  
  #--------------------------------------------------------------------------
  # ● Update Slime Breath Effect
  #--------------------------------------------------------------------------          
  def update_slime_breath_effect
      @effects[1] += 1
      case @effects[1]
         when 0..30
           @zoom_x += 0.005
           @zoom_y -= 0.005
           if @zoom_x > 1.145 
              @zoom_x = 1.145
              @zoom_y = 0.855
              @effects[1] = 31
           end             
         when 31..60
           @zoom_x -= 0.005
           @zoom_y += 0.005    
           if @zoom_x < 1.0
              @zoom_x = 1.0
              @zoom_y = 1.0
              @effects[1] = 61
           end             
         else
           @zoom_x = 1
           @zoom_y = 1.0
           @effects[1] = 0 
      end
  end  
 
  #--------------------------------------------------------------------------
  # ● Update Big Breath Effect
  #--------------------------------------------------------------------------          
  def update_big_breath_effect
      @effects[1] += 1
      case @effects[1]
         when 0..30
           @zoom_x += 0.02
           @zoom_y = @zoom_x 
           if @zoom_x > 1.6   
              @zoom_x = 1.6         
              @zoom_y = @zoom_x 
              @effects[1] = 31
           end
         when 31..60
           @zoom_x -= 0.02
           @zoom_y = @zoom_x 
           if @zoom_x < 1.0    
              @zoom_x = 1.0
              @zoom_y = @zoom_x 
              @effects[1] = 61 
           end   
         else
           @zoom_x = 1
           @zoom_y = 1
           @effects[1] = 0 
      end
  end    
  
  #--------------------------------------------------------------------------
  # ● Update Disappear Effect
  #--------------------------------------------------------------------------            
  def update_disappear_effect
      @zoom_x -= 0.01
      @zoom_y += 0.05
      @opacity -= 3      
  end
  
  #--------------------------------------------------------------------------
  # ● Update Appear Effect
  #--------------------------------------------------------------------------            
  def update_appear_effect
      @zoom_x += 0.02
      @zoom_x = 1.0 if @zoom_x > 1.0
      @zoom_y -= 0.05
      @zoom_y = 1.0 if @zoom_y < 1.0
      @opacity += 3
      clear_effects if @opacity >= 255
  end  

  #--------------------------------------------------------------------------
  # ● Update Crazy Effect
  #--------------------------------------------------------------------------              
  def update_crazy_effect
      @effects[1] += 1
      case @effects[1]
         when 1..5
           @mirror = false
         when 6..10
           @mirror = true
         else
           @mirror = false
           @effects[1] = 0 
      end      
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Dwarf Effect
  #--------------------------------------------------------------------------                
  def update_dwarf_effect
      if @zoom_x > 0.5
         @zoom_x -= 0.01
         @zoom_y -= 0.01
      end       
  end
  
  #--------------------------------------------------------------------------
  # ● Update Giant Effect
  #--------------------------------------------------------------------------                
  def update_giant_effect
      if @zoom_x < 1.8
         @zoom_x += 0.01
         @zoom_y += 0.01
      end       
  end   
  
  #--------------------------------------------------------------------------
  # ● Update Normal
  #--------------------------------------------------------------------------                  
  def update_normal_effect  
      if @zoom_x > 1.0 
         @zoom_x -= 0.01
         @zoom_x = 1.0 if @zoom_x < 1.0  
      elsif @zoom_x < 1.0 
         @zoom_x += 0.01
         @zoom_x = 1.0 if @zoom_x > 1.0              
      end
      if @zoom_y > 1.0 
         @zoom_y -= 0.01
         @zoom_y = 1.0 if @zoom_y < 1.0  
      elsif @zoom_y < 1.0 
         @zoom_y += 0.01
         @zoom_y = 1.0 if @zoom_y > 1.0              
     end        
     if @opacity < 255
        @opacity += 2 
        @opacity = 255 if @opacity > 255
     end
     if @angle > 0 
        @angle -= 5 
        @angle = 0 if @angle < 0
     end   
     if (@zoom_x == 1.0 and @zoom_y == 1.0 and @opacity == 255 and @angle == 0)
        clear_effects
     end  
  end  
  
end

#==============================================================================
# ■ Game Event
#==============================================================================
class Game_Event < Game_Character  
  
 #--------------------------------------------------------------------------
 # ● Setup Page Setting
 #--------------------------------------------------------------------------                     
  alias mog_character_effects_setup_page_settings setup_page_settings
  def setup_page_settings
      mog_character_effects_setup_page_settings
      setup_character_ex_effects
  end
    
 #--------------------------------------------------------------------------
 # ● Setup Character Effects
 #--------------------------------------------------------------------------                       
  def setup_character_ex_effects
      return if @list == nil
      for command in @list
      if command.code == 108
         if command.parameters[0] =~ /<Effects = ([^>]*)>/
            @effects = [$1,0,true]
         end   
         if command.parameters[0] =~ /<Zoom = (\d+)>/i 
            @zoom_x = $1.to_i
            @zoom_y = @zoom_x
         end   
         if command.parameters[0] =~ /<Opacity = (\d+)>/i 
            @opacity = $1.to_i
         end   
         if command.parameters[0] =~ /<Blend Type = (\d+)>/i   
            @blend_type = $1.to_i           
         end 
         if command.parameters[0] =~ /<Mirror = (\w+)>/i
            @mirror = $1
         end            
       end
      end 
  end
end  

#==============================================================================
# ■ Sprite Character
#==============================================================================
class Sprite_Character < Sprite_Base
  
  #--------------------------------------------------------------------------
  # ● Update Other
  #--------------------------------------------------------------------------    
  alias mog_character_ex_effects_update_other update_other
  def update_other
      mog_character_ex_effects_update_other
      update_other_ex
  end  

  #--------------------------------------------------------------------------
  # ● Update_other_EX
  #--------------------------------------------------------------------------      
  def update_other_ex
      self.zoom_x = @character.zoom_x
      self.zoom_y = @character.zoom_y
      self.mirror = @character.mirror
      self.angle = @character.angle    
  end  
  
end

#==============================================================================
# ■ CHARCTER EX EFFECTS COMMAND
#==============================================================================
module CHARACTER_EX_EFFECTS_COMMAND
  
  #--------------------------------------------------------------------------
  # ● Char Effect
  #--------------------------------------------------------------------------      
  def char_effect(event_id = 0, effect_type = "Breath")
      if event_id < 0
         target = $game_player.followers[event_id.abs - 1] rescue nil
      elsif event_id == 0
         target = $game_player rescue nil
      else  
         target = $game_map.events[event_id] rescue nil
      end
      execute_char_effect(target,effect_type) if target != nil
 end  
      
  #--------------------------------------------------------------------------
  # ● Execute Char Effect
  #--------------------------------------------------------------------------        
  def execute_char_effect(target,effect_type)
      if effect_type == "Clear"
         target.clear_effects rescue nil
         return
      end           
      target.effects[0] = effect_type.to_s rescue nil
      target.effects[2] = true rescue nil
  end
  
  #--------------------------------------------------------------------------
  # ● Clear_All_Events Effects
  #--------------------------------------------------------------------------            
  def clear_all_events_effects
      for event in $game_map.events.values
          event.clear_effects
      end  
  end

  #--------------------------------------------------------------------------
  # ● Clear_All_Party Effects
  #--------------------------------------------------------------------------              
  def clear_all_party_effects
      $game_player.clear_effects
      for folower in $game_player.followers
          folower.clear_effects
      end
  end
    
  #--------------------------------------------------------------------------
  # ● Clear_All_Char_Effects
  #--------------------------------------------------------------------------          
  def clear_all_ex_effects
      clear_all_events_effects
      clear_all_party_effects
  end
  
end  

#==============================================================================
# ■ Game Interpreter
#==============================================================================
class Game_Interpreter
   include CHARACTER_EX_EFFECTS_COMMAND
end  

#==============================================================================
# ■ Game_CharacterBase
#==============================================================================
class Game_CharacterBase
    include CHARACTER_EX_EFFECTS_COMMAND
end

$mog_rgss3_character_ex = true