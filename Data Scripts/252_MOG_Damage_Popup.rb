#==============================================================================
# +++ MOG - DAMAGEPOPUP  (v4.5) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Apresenta danos dos alvos em imagens.
#==============================================================================
# Serão necessários as imagems 
#
# Critical
# Evaded
# Exp
# Gold
# Level Up
# Missed
# MP
# Number
# TP
#
# As imagens devem ficar na pasta /GRAPHICS/DAMAGE/
#==============================================================================

#==============================================================================
# DAMAGE POPUP FOR CHARACTERS (Events)
#==============================================================================
# Caso desejar ativar manualmente os danos nos characters, basta usar os códigos
# abaixo.
#
# damage_popup(TARGET_ID,VALUE,"TYPE")
#
# TARGET_ID 
#      1...999 - Define a ID  do evento no mapa
#      0 - Define a ID sendo do jogador.(Player)
#      -1...-3 - Define  a ID dos aliados (Followers).
#
# VALUE
#       Define o valor em dano (Pode ser valores negativos) ou um texto.
#       No caso das codições defina a ID da condição. (Valore negativos
#       é apresentado a condição sendo removida.)
#
# TYPE (Opcional)
#      So use está opção para ativar srtings especiais.
#
#      "Exp" - Valor da string se torna em EXP.
#      "Gold" - Valor da string se torna em GOLD.
#      "States" - É apresentado o ícone e o nome da condição da condição.
#
#==============================================================================
# 
# damage_popup(1,999)
# damage_popup(4,"Save Point.")
# damage_popup(0,"I'm hungry!!!")            <- (Player)
# damage_popup(-1,"Booo!")                   <- (Follower ID1)
# damage_popup(0,2000,"Exp")                 <- Popup 2000 Exp
# damage_popup(0,5000,"Gold")                <- Popup 5000 Gold
#
#==============================================================================
# Use o código abaixo se desejar fazer o dano aparecer em todos os personagens. 
#
# damage_popup_party(TARGET_ID,STRING,"TYPE")
#
#==============================================================================
# ATIVAR OU DESATIVAR OS DANOS NO MAPA.
#==============================================================================
# É possível usar o código abaixo para ativar ou desativar a dano no mapa
# no meio do jogo, útil se você não quiser que alguma string de item ou
# dano apareça no meio de algum evento ou cena.
#
# damage_popup_map(true)        -> or (false)
#  
#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v 4.5 - Correção de ativar o dano quando o alvo é morto e o dano é zero.
#==============================================================================

$imported = {} if $imported.nil?
$imported[:mog_damage_popup] = true

module MOG_DAMAGEPOPUP
  #Ativar as strings de dano no mapa. (Default / Inicial)
  DAMAGE_POPUP_MAP = true
  #Apresentar o item ao ganhar. (Apenas no mapa). 
  ITEM_POPUP_MAP = true
  #Apresentar a exp e ouro do inimigo.
  EXP_GOLD_POPUP_BATTLE = true 
  EXP_GOLD_POPUP_MAP = true
  #Ativar a string de Level UP
  LEVEL_POPUP_BATTLE = true
  LEVEL_POPUP_MAP = true
  #Ativar as strings nas condições.
  STATES_POPUP_BATTLE = true
  STATES_POPUP_MAP = true
  #Definição da fonte (Nome de itens/ condições / etc...).
  FONT_SIZE = 28
  FONT_BOLD = true
  FONT_ITALIC = false
  FONT_COLOR = Color.new(255,255,255)
  FONT_COLOR_ITEM = Color.new(255,255,255)
  FONT_COLOR_STATUS_PLUS = Color.new(155,155,255)
  FONT_COLOR_STATUS_MINUS = Color.new(255,150,150)
  #Definição do espaço entre os danos.
  Y_SPACE = 28
  #Definição da posição Z do srpite.
  DAMAGE_Z = 151
end

#==============================================================================
# ■ Game_System
#==============================================================================
class Game_System
  attr_accessor :damage_popup_map 
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------         
  alias mog_damage_popup_initialize initialize
  def initialize
      @damage_popup_map = MOG_DAMAGEPOPUP::DAMAGE_POPUP_MAP
      mog_damage_popup_initialize
  end
  
  #--------------------------------------------------------------------------
  # ● Damage Popup Clear
  #--------------------------------------------------------------------------         
  def damage_popup_clear
      $game_party.character_members.each {|t|
      t.actor.damage.clear; t.actor.skip_dmg_popup = false ;
      t.damage.clear; t.skip_dmg_popup = false} rescue nil
      $game_map.events.values.each {|t| t.damage.clear ; 
      t.skip_dmg_popup = false} rescue nil
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
  alias mog_damage_temp_opup_initialize initialize
  def initialize
      @battle_end = false 
      mog_damage_temp_opup_initialize
  end
  
  #--------------------------------------------------------------------------
  # ● Sprite Visible
  #--------------------------------------------------------------------------    
  def sprite_visible
      return false if $game_message.visible
      return false if $game_temp.battle_end
      return true
  end 
    
end
#==============================================================================
# ■ Game CharacterBase
#==============================================================================
class Game_CharacterBase
  
  attr_accessor :damage ,:battler ,:skip_dmg_popup
  
  #--------------------------------------------------------------------------
  # ● Ini Public Members
  #--------------------------------------------------------------------------         
  alias mog_damage_popup_init_public_members init_public_members
  def init_public_members
      @damage = [] ; @skip_dmg_popup = false
      mog_damage_popup_init_public_members
  end
  
  #--------------------------------------------------------------------------
  # ● Damage Popup
  #--------------------------------------------------------------------------         
  def damage_popup(value,type = "String")      
      @damage.push([value,type])
  end  
  
end

#==============================================================================
# ■ Scene Map
#==============================================================================
class Scene_Map < Scene_Base  
  #--------------------------------------------------------------------------
  # ● Start
  #--------------------------------------------------------------------------
  alias mog_damage_popup_start start
  def start
      $game_system.damage_popup_clear ; $game_temp.battle_end = false
      mog_damage_popup_start
  end  
end

#==============================================================================
# ■ Game Player
#==============================================================================
class Game_Player < Game_Character    
  #--------------------------------------------------------------------------
  # ● Battler
  #--------------------------------------------------------------------------
  def battler
      actor
  end    
end

#==============================================================================
# ■ Game Follower
#==============================================================================
class Game_Follower < Game_Character  
  #--------------------------------------------------------------------------
  # ● Battler
  #--------------------------------------------------------------------------
  def battler
      actor
  end    
end

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================
class Game_BattlerBase  
  #--------------------------------------------------------------------------
  # ● Change HP
  #--------------------------------------------------------------------------         
  alias mog_damage_popup_change_hp change_hp
  def change_hp(value, enable_death)
      mog_damage_popup_change_hp(value, enable_death)
      self.damage.push([-value,"Hp"])
  end    
end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase  
  include MOG_DAMAGEPOPUP
  attr_accessor :damage , :skip_dmg_popup
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------         
  alias mog_damage_sprite_initialize initialize 
  def initialize      
      @damage = [] ; @skip_dmg_popup = false
      mog_damage_sprite_initialize 
  end  
    
  #--------------------------------------------------------------------------
  # ● Item Apply
  #--------------------------------------------------------------------------  
   alias mog_damage_pop_item_apply item_apply
   def item_apply(user, item)
       mog_damage_pop_item_apply(user, item)
       execute_damage_popup(user,item)
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Damage Popup
  #--------------------------------------------------------------------------
  def execute_damage_popup(user,item)
      
      if !@result.missed and !@result.evaded and @result.hit? and !@result.blocked
        #self.damage.push([@result.hp_damage,"HP",@result.critical]) if item.damage.to_hp? or @result.hp_damage != 0
        #user.damage.push([-@result.hp_drain,"HP",@result.critical]) if item.damage.type == 5
        #self.damage.push([@result.mp_damage,"MP",@result.critical]) if item.damage.to_mp? && @result.mp_damage != 0
        #user.damage.push([-@result.mp_drain,"MP",@result.critical]) if item.damage.type == 6
        #self.damage.push([@result.tp_damage,"TP",@result.critical]) if @result.tp_damage != 0
        
        self.popup_ary.push([@result.hp_damage,"HP",@result.critical]) if item.damage.to_hp? or @result.hp_damage != 0
        user.popup_ary.push([-@result.hp_drain,"HP",@result.critical]) if item.damage.type == 5
        self.popup_ary.push([@result.mp_damage,"MP",@result.critical]) if item.damage.to_mp? or @result.mp_damage != 0
        user.popup_ary.push([-@result.mp_drain,"MP",@result.critical]) if item.damage.type == 6
        self.popup_ary.push([@result.tp_damage,"TP",@result.critical]) if @result.tp_damage != 0
        
        self.dmg_popup = true
        user.dmg_popup = true
     elsif !self.dead?
        if @result.missed ; self.damage.push(["Missed","Missed"]) 
        elsif @result.evaded ; self.damage.push(["Evaded","Evaded"])
        elsif @result.blocked ; self.damage.push(["Blocked","Blocked"])
        end        
      end
  end
     
  #--------------------------------------------------------------------------
  # ● Regenerate HP
  #--------------------------------------------------------------------------
  alias mog_damage_pop_regenerate_hp regenerate_hp
  def regenerate_hp
      mog_damage_pop_regenerate_hp
      self.damage.push(["Regenerate",""]) if @result.hp_damage < 0  
      self.damage.push([@result.hp_damage,"HP"]) if @result.hp_damage != 0
  end

  #--------------------------------------------------------------------------
  # ● Regenerate MP
  #--------------------------------------------------------------------------
  alias mog_damage_pop_regenerate_mp regenerate_mp
  def regenerate_mp
      mog_damage_pop_regenerate_mp
      self.damage.push([@result.mp_damage,"MP"]) if @result.mp_damage != 0
  end
  
  #--------------------------------------------------------------------------
  # ● Regenerate TP
  #--------------------------------------------------------------------------
  alias mog_damage_pop_regenerate_tp regenerate_tp
  def regenerate_tp
      mog_damage_pop_regenerate_tp
      tp_damage = 100 * trg
      self.damage.push([tp_damage,"TP"]) if tp_damage != 0
  end

  #--------------------------------------------------------------------------
  # ● Added New State
  #--------------------------------------------------------------------------  
  alias mog_damage_pop_add_new_state add_new_state
  def add_new_state(state_id)
      mog_damage_pop_add_new_state(state_id)
      execute_popup_add_new_state(state_id)
  end
    
  #--------------------------------------------------------------------------
  # ● Execute Popup Add New State
  #--------------------------------------------------------------------------  
 def execute_popup_add_new_state(state_id)
      st = $data_states[state_id]
      if self.hp > 0
         unless (SceneManager.scene_is?(Scene_Battle) and !STATES_POPUP_BATTLE) or
                (SceneManager.scene_is?(Scene_Map) and !STATES_POPUP_MAP)
                self.damage.push([st.name.to_s,"States Plus",false,st.icon_index])
         end
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Remove State
  #--------------------------------------------------------------------------  
  alias mog_damage_pop_remove_state remove_state
  def remove_state(state_id)
      execute_popup_remove_state(state_id)  
      mog_damage_pop_remove_state(state_id)
  end      
  
  #--------------------------------------------------------------------------
  # ● Execute Popup Remove State
  #--------------------------------------------------------------------------  
  def execute_popup_remove_state(state_id)  
      if state?(state_id) and self.hp > 0
         st = $data_states[state_id] 
         unless (SceneManager.scene_is?(Scene_Battle) and !STATES_POPUP_BATTLE) or
                (SceneManager.scene_is?(Scene_Map) and !STATES_POPUP_MAP)
                self.damage.push([st.name.to_s,"States Minus",false,st.icon_index]) unless BattleManager.escape?
         end
      end
  end     

end

#==============================================================================
# ■ BattleManager
#==============================================================================
module BattleManager
  #--------------------------------------------------------------------------
  # ● Escape?
  #--------------------------------------------------------------------------
  def self.escape?
      @phase == nil
  end  
end

#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  attr_accessor :dmg_battle_mode
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------         
  alias mog_damage_popup_initialize initialize
  def initialize
      @dmg_battle_mode = false
      mog_damage_popup_initialize
  end
  
end

#==============================================================================
# ■ Scene Battle
#==============================================================================
class Scene_Battle < Scene_Base

  #--------------------------------------------------------------------------
  # ● Start
  #--------------------------------------------------------------------------         
  alias mog_damage_popup_start start
  def start
      $game_temp.dmg_battle_mode = true
      mog_damage_popup_start
  end
    
  #--------------------------------------------------------------------------
  # ● Terminate
  #--------------------------------------------------------------------------         
  alias mog_damage_popup_terminate terminate
  def terminate
      mog_damage_popup_terminate
      $game_temp.dmg_battle_mode = false
  end
  
end

#==============================================================================
# ■ Game Party
#==============================================================================
class Game_Party < Game_Unit

  #--------------------------------------------------------------------------
  # ● Character Members
  #--------------------------------------------------------------------------         
  def character_members
      char_m = [] ; char_m.push($game_player) 
      $game_player.followers.each do |f| char_m.push(f) end
      return char_m
  end
  
  #--------------------------------------------------------------------------
  # ● Gain Gold
  #--------------------------------------------------------------------------         
  alias mog_damage_popup_gain_gold gain_gold
  def gain_gold(amount)
      mog_damage_popup_gain_gold(amount)
      $game_party.members[0].damage.push([amount,"Gold"]) if can_damage_popup_gold?
  end  
  
  #--------------------------------------------------------------------------
  # ● Can Damage Popup Gold
  #--------------------------------------------------------------------------         
  def can_damage_popup_gold?
      return false if !SceneManager.scene_is?(Scene_Map)
      return false if $game_temp.dmg_battle_mode
      return false if !MOG_DAMAGEPOPUP::EXP_GOLD_POPUP_MAP
      return false if !$game_system.damage_popup_map
      return false if !$game_party.members[0]
      return true
  end
  
 #--------------------------------------------------------------------------
 # ● Gain Item
 #--------------------------------------------------------------------------
 alias mog_damage_popup_gain_item gain_item
 def gain_item(item, amount, include_equip = false)
     mog_damage_popup_gain_item(item, amount, include_equip)
     execute_item_popup(item) if can_damage_popup_item?(item) 
 end
  
 #--------------------------------------------------------------------------
 # ● Can Damage Poupup Item 
 #--------------------------------------------------------------------------
 def can_damage_popup_item?(item)
     return false if item == nil
     return false if !MOG_DAMAGEPOPUP::ITEM_POPUP_MAP
     return false if !$game_system.damage_popup_map
     return false if SceneManager.scene_is?(Scene_Battle)
     return false if !$game_party.members[0]
     return false if $game_temp.dmg_battle_mode
     return true     
 end
 
 #--------------------------------------------------------------------------
 # ● Execute Item Popup
 #--------------------------------------------------------------------------
 def execute_item_popup(item)
     it = $data_items[item.id] if item.is_a?(RPG::Item)
     it = $data_weapons[item.id] if item.is_a?(RPG::Weapon)
     it = $data_armors[item.id] if item.is_a?(RPG::Armor)   
     $game_party.members[0].damage.push([it.name.to_s,"Item",false,it.icon_index])
 end
 
end

#==============================================================================
# ■ Game Interpreter
#==============================================================================
class Game_Interpreter

 #--------------------------------------------------------------------------
 # ● Damage Popup Map
 #--------------------------------------------------------------------------
  def damage_popup_map(value)
      $game_system.damage_popup_map = value
  end    
  
  #--------------------------------------------------------------------------
  # ● Damage Popup
  #--------------------------------------------------------------------------
  def damage_popup(target_id, value,type = "")
      return if !$game_system.damage_popup_map
      target = set_target_dmg(target_id) rescue nil
      target.damage.push([value,type]) if target
  end
  
  #--------------------------------------------------------------------------
  # ● Set Target Dmg
  #--------------------------------------------------------------------------
  def set_target_dmg(target)
      return $game_player.battler if target == 0
      return $game_player.followers.battler[(target_id + 1).abs] if target < 0
      $game_map.events.values.each do |event|
      return event.battler if event.id == target_id and event.battler
      return event if event.id == target_id
      end
  end
  
  #--------------------------------------------------------------------------
  # * Change MP
  #--------------------------------------------------------------------------
  alias mog_damage_popup_command_312 command_312
  def command_312
      value = operate_value(@params[2], @params[3], @params[4])
      iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.damage.push([-value,"MP"])
      end    
      mog_damage_popup_command_312
  end  
  
end

#==============================================================================
# ■ Game Actor
#==============================================================================
class Game_Actor < Game_Battler
  include MOG_DAMAGEPOPUP
  #--------------------------------------------------------------------------
  # ● Level UP
  #--------------------------------------------------------------------------         
   alias mog_damage_pop_level_up level_up
   def level_up
       mog_damage_pop_level_up
       execute_level_popup
   end

  #--------------------------------------------------------------------------
  # ● Execute Level Popup
  #--------------------------------------------------------------------------         
   def execute_level_popup
       if (SceneManager.scene_is?(Scene_Battle) and LEVEL_POPUP_BATTLE) or
          (SceneManager.scene_is?(Scene_Map) and LEVEL_POPUP_MAP)
          @damage.push(["Level UP","Level_UP"]) unless @skip_dmg_popup
          @skip_dmg_popup = true
       end     
   end
     
  #--------------------------------------------------------------------------
  # ● Change Exp
  #--------------------------------------------------------------------------         
  alias mog_damage_popup_change_exp change_exp
  def change_exp(exp, show)
      n_exp = self.exp
      mog_damage_popup_change_exp(exp, show)
      c_exp = n_exp - self.exp
      @damage.push([c_exp.abs,"Exp"]) if can_popup_exp?(exp)
  end   
   
  #--------------------------------------------------------------------------
  # ● Can Popup EXP
  #--------------------------------------------------------------------------         
  def can_popup_exp?(exp)
      return false if !EXP_GOLD_POPUP_MAP 
      return false if exp <= 0
      return false if self.skip_dmg_popup
      return false if self.max_level?
      return true
  end
  
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Invoke Counter Attack
  #--------------------------------------------------------------------------        
  alias mog_damage_popup_invoke_counter_attack invoke_counter_attack
  def invoke_counter_attack(target, item)
      mog_damage_popup_invoke_counter_attack(target, item)
      target.damage.push(["Counter","Counter"]) 
  end  
  
  #--------------------------------------------------------------------------
  # ● Invoke Counter Attack
  #--------------------------------------------------------------------------        
  alias mog_damage_popup_invoke_magic_reflection invoke_magic_reflection
  def invoke_magic_reflection(target, item)
      mog_damage_popup_invoke_magic_reflection(target, item)
      target.damage.push(["Reflection","Reflection"])
  end  
  
end

#==============================================================================
# ■ Cache
#==============================================================================
module Cache

  #--------------------------------------------------------------------------
  # * Damage
  #--------------------------------------------------------------------------
  def self.damage(filename)
      load_bitmap("Graphics/Damage/", filename)
  end

end

#==============================================================================
# ■ Game Temp
#==============================================================================
class Game_Temp
  
  attr_accessor :pre_cache_damage
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias mog_damage_pop_initialize initialize
  def initialize
      mog_damage_pop_initialize
      pre_cache_damage_temp
  end
  
  #--------------------------------------------------------------------------
  # ● Pre Cache Damage Temp
  #--------------------------------------------------------------------------   
  def pre_cache_damage_temp
      return if @pre_cache_damage != nil 
      @pre_cache_damage = []
      @pre_cache_damage.push(Cache.damage("HP_Number"))     #00
      @pre_cache_damage.push(Cache.damage("MP"))            #01
      @pre_cache_damage.push(Cache.damage("TP"))            #02
      @pre_cache_damage.push(Cache.damage("Missed"))        #03
      @pre_cache_damage.push(Cache.damage("Evaded"))        #04
      @pre_cache_damage.push(Cache.damage("Critical"))      #05
      @pre_cache_damage.push(Cache.damage("Exp"))           #06
      @pre_cache_damage.push(Cache.damage("Gold"))          #07
      @pre_cache_damage.push(Cache.damage("Level UP"))      #08
      @pre_cache_damage.push(Cache.damage("Counter"))       #09
      @pre_cache_damage.push(Cache.damage("Reflection"))    #10
      @pre_cache_damage.push(Cache.damage("MP_Number"))     #11
      @pre_cache_damage.push(Cache.damage("TP_Number"))     #12
      @pre_cache_damage.push(Cache.damage("EG_Number"))     #13
      @pre_cache_damage.push(Cache.system("Iconset"))       #14
      @pre_cache_damage.push(Cache.damage("Blocked"))       #15
      @pre_cache_damage.push(Cache.damage("AutoRevive"))    #16
      @pre_cache_damage.push(Cache.damage("Fail"))          #17
      @pre_cache_damage.push(Cache.damage("Nothing"))       #18
      @pre_cache_damage.push(Cache.damage("D20"))           #19
      @pre_cache_damage.push(Cache.damage("Knock_Down"))    #20
      @pre_cache_damage.push(Cache.damage("Knock_Back"))    #21
      @pre_cache_damage.push(Cache.damage("Immune"))        #22
      @pre_cache_damage.push(Cache.damage("Interrupted"))   #23
      
  end
  
end

#==============================================================================
# ■ Sprite Base
#==============================================================================
class Sprite_Base < Sprite

  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias mog_damage_popup_sprite_initialize initialize
  def initialize(viewport = nil)
      mog_damage_popup_sprite_initialize(viewport)
      damage_popup_setup
  end

  #--------------------------------------------------------------------------
  # ● Damage Popup Setup
  #--------------------------------------------------------------------------  
  def damage_popup_setup
      $game_temp.pre_cache_damage_temp ; @damage_sprites = []
      $game_system.damage_popup_clear
  end

  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------  
  alias mog_damage_popup_sprite_dispose dispose
  def dispose      
      mog_damage_popup_sprite_dispose
      dispose_damage_sprites
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Damage Sprites
  #--------------------------------------------------------------------------    
  def dispose_damage_sprites
      return if @damage_sprites == nil
      @damage_sprites.each {|sprite| sprite.dispose_damage }
  end  
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_damage_popup_sprite_update update
  def update
      mog_damage_popup_sprite_update
      update_damage_popup
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Damage Popup
  #--------------------------------------------------------------------------   
  def update_damage_popup
      return if @damage_sprites == nil
      create_damage_sprite if can_create_damage?
      update_damage_sprite if !@damage_sprites.empty?
  end  
  
  #--------------------------------------------------------------------------
  # ● Can Create Damage?
  #--------------------------------------------------------------------------     
  def can_create_damage?      
#      @dmg_popup = false
#      @popup_ary = []
      return false if $game_message.visible
      
      if @battler 
        
         if @battler.dmg_popup
           @battler.dmg_popup = false
           for i in @battler.popup_ary
             @battler.damage.push(i)
           end
           @battler.popup_ary = []
           @battler.damage.uniq!
           #puts "#{@battler.name}'s Dmg ary:#{@battler.damage.size}"
           return true
         end
         
         return false if @battler.damage == nil
         return false if @battler.damage.empty?
         if $game_temp.battle_end and @battler.is_a?(Game_Actor)
            return false if $game_message.visible
            return false if $imported[:mog_battler_result] and $game_temp.result
         end
      elsif @character
         return false if !$game_system.damage_popup_map
         if @character.battler
            return false if @character.battler.damage == nil
            return false if @character.battler.damage.empty?
         else
            return false if @character.damage == nil
            return false if @character.damage.empty?            
         end  
       end
       
       return false if @battler == nil and @character == nil
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Create Damage Sprite
  #--------------------------------------------------------------------------     
  def create_damage_sprite
    
      target = @battler ? @battler : @character
      
      screen_x_available = target.screen_x rescue nil
      return if screen_x_available == nil
      sx = target.screen_x != nil ? target.screen_x : self.x
      sy = target.screen_y != nil ? target.screen_y : self.y
      @damage_sprites = [] if @damage_sprites == nil  
      target = @character.battler if @character and @character.battler
      target.damage.each_with_index do |i, index|
      @damage_sprites.push(Damage_Sprite.new(nil,sx,sy,i,index,@damage_sprites.size,self)) end
      if SceneManager.scene_is?(Scene_Battle)
      @damage_sprites.each_with_index do |i, index| i.set_duration(index) end
      end
      target.damage.clear ; target.skip_dmg_popup = false
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Damage Sprite
  #--------------------------------------------------------------------------     
  def update_damage_sprite
      clear = true
      @damage_sprites.each_with_index do |sprite, i|
          sprite.update_damage(@damage_sprites.size,i,@battler)
          sprite.dispose_damage if sprite.duration <= 0
          clear = false if sprite.duration > 0
      end   
      @damage_sprites.clear if clear
  end  
  
end

#==============================================================================
# ■ Damage Sprite
#==============================================================================
class Damage_Sprite < Sprite
   include MOG_DAMAGEPOPUP
   attr_accessor :duration
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------       
  def initialize(viewport = nil , x,y, value ,index,index_max,target)
      super(viewport)
      dispose_damage ; setup_base(value,x,y,index,index_max,target) ; create_sprites
  end    
     
  #--------------------------------------------------------------------------
  # ● Setup Base
  #--------------------------------------------------------------------------       
  def setup_base(value,x,y,index,index_max,target)
      @target = target ; y2 = 0
      if @target.bitmap != nil ; y2 = SceneManager.scene_is?(Scene_Battle) ? @target.bitmap.height / 2 : 0 ; end
      @animation_type = 0 ; @index = index ; @index_max = index_max + 1
      @image = $game_temp.pre_cache_damage ; self.z = index + DAMAGE_Z
      @cw = @image[0].width / 10 ; @ch = @image[0].height / 2 ; @cw2 = 0
      @x = x ; @y = y - y2 ; @value = value[0] ; @type = value[1] ; @ch2 = 0
      @critical = (value[2] and @value.to_i >= 0) ? true : false; self.opacity = 0
      @state_index = value[3] ; @oxy = [0,0,0,0] ; @org_xy = [0,0] ; @spxy = [0,0]
      @duration = 92 ; @org_oxy = [0,0,0,0] 
      self.visible = false ;set_initial_position(index,nil)
  end
  
  #--------------------------------------------------------------------------
  # ● Set Duration
  #--------------------------------------------------------------------------       
  def set_duration(index,pre_index = nil)
      return if @duration != 0
      @duration = 82 + (2 * index) if @animation_type == 0
  end 
  
  #--------------------------------------------------------------------------
  # ● Set Initial Position
  #--------------------------------------------------------------------------       
  def set_initial_position(index,old_duration)
      @org_xy = [@x,@y] 
      self.zoom_y = self.zoom_x
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Damage
  #--------------------------------------------------------------------------       
  def dispose_damage
      (self.bitmap.dispose ; self.bitmap = nil) if self.bitmap 
      (@sup_sprite.bitmap.dispose ; @sup_sprite.dispose) if @sup_sprite  
      @duration = -1
  end
  
  #--------------------------------------------------------------------------
  # ● Create Sprites
  #--------------------------------------------------------------------------       
  def create_sprites
      
      if @value.is_a?(Numeric)
         create_number
       elsif ["Blocked","Interrupted","Immune","Missed","Evaded","Level UP","Counter","Reflection","AutoRevive","Fail","Nothing","Knock_Back","Knock_Down"].include?(@value.to_s) 
         create_miss
       else 
         create_string
      end      
      set_damage_position
  end
  
  #--------------------------------------------------------------------------
  # ● Set Damage Position
  #--------------------------------------------------------------------------       
  def set_damage_position
      return if self.bitmap == nil
      self.ox = (self.bitmap.width - @cw2) / 2 
      self.oy = self.bitmap.height / 2 ; self.x = @x ; self.y = @y
      @org_oxy[0] = self.ox
      @org_oxy[1] = self.oy
      set_animation_type
      if @sup_sprite 
         @sup_sprite.ox = self.bitmap.width / 2 ;
         @sup_sprite.oy = self.bitmap.height / 2 
         @org_oxy[2] = @sup_sprite.ox
         @org_oxy[3] = @sup_sprite.oy
         if @critical
            @sup_sprite.x = @x - (@sup_sprite.bitmap.width / 2) + ((@cw / 2) * @number_value.size)
            @sup_sprite.y = self.y
         end   
         update_sup_position(@index_max - @index)
      end
  end    
  
  #--------------------------------------------------------------------------
  # ● Set Damage Position
  #--------------------------------------------------------------------------       
  def set_animation_type
      s = rand(2) ; s2 = (rand(10) * 0.1).round(2) 
      @oxy[2] = s == 1 ? s2 : -s2
  end
  
  #--------------------------------------------------------------------------
  # ● Create Number
  #--------------------------------------------------------------------------       
  def create_number
      case @type
      when "MP"
      number_image = @image[11] ;h = @value >= 0 ? 0 : @ch ; create_sup_sprite
      when "TP"
      number_image = @image[12] ;h = @value >= 0 ? 0 : @ch ; create_sup_sprite
      when "D20"
      number_image = @image[12] ;h = @value >= 0 ? 0 : @ch ; create_sup_sprite
      when "Exp"
      number_image = @image[13] ;h = 0 ; create_sup_sprite
      when "Gold"
      number_image = @image[13] ;h = @ch ; create_sup_sprite            
      else
      number_image = @image[0] ; h = @value >= 0 ? 0 : @ch 
      end
      @number_value = @value.abs.truncate.to_s.split(//)
      self.bitmap = Bitmap.new(@cw * @number_value.size, @ch)
      for r in 0...@number_value.size        
          number_value_abs = @number_value[r].to_i 
          src_rect = Rect.new(@cw * number_value_abs, h, @cw, @ch)
          self.bitmap.blt(@cw *  r, 0, number_image, src_rect)
      end    
      create_sup_sprite if @critical
  end
  
  #--------------------------------------------------------------------------
  # ● Create Sup Sprite
  #--------------------------------------------------------------------------       
  def create_sup_sprite
      return if @sup_sprite != nil
      @sup_sprite = Sprite.new ; @sup_sprite.visible = false ; fy = 0 ; sp = [0,0]
      if @type == "MP" ; @sup_sprite.bitmap = @image[1].dup
      elsif @type == "TP" ; @sup_sprite.bitmap = @image[2].dup
      elsif @critical
         @sup_sprite.bitmap = @image[5].dup
         @cw2 = 0 ; @ch2 = @sup_sprite.bitmap.height  
         return
      elsif @type == "Exp" 
         @sup_sprite.bitmap = @image[6].dup ; fy = @ch ; sp[1] = 1.0
      elsif @type == "D20" 
         @sup_sprite.bitmap = @image[19].dup ;
      elsif @type == "Gold"
         @sup_sprite.bitmap = @image[7].dup ; fy = (@ch * 2) ; sp[1] = 0.5
     end  
     fy = 0 if !SceneManager.scene_is?(Scene_Battle)
     @y += fy ; @org_xy[1] += 0
     @cw2 = @sup_sprite.bitmap.width + @cw
     @spxy = [sp[0],sp[1]]
  end

  #--------------------------------------------------------------------------
  # ● Update Sup Position
  #--------------------------------------------------------------------------       
  def update_sup_position(dif_y)
      @sup_sprite.x = self.x - @cw unless @critical
      @sup_sprite.y = @critical ? self.y - @ch2 : self.y
      @sup_sprite.opacity = self.opacity ; @sup_sprite.angle = self.angle
      @sup_sprite.zoom_x = self.zoom_x ; @sup_sprite.zoom_y = self.zoom_y
      @sup_sprite.z = self.z ; @sup_sprite.viewport = self.viewport
      @sup_sprite.visible = self.visible
  end  
  
  #--------------------------------------------------------------------------
  # ● Create Miss
  #--------------------------------------------------------------------------       
  def create_miss
      self.bitmap = @image[3].dup if @value == "Missed" 
      self.bitmap = @image[4].dup if @value == "Evaded"
      self.bitmap = @image[8].dup if @value == "Level UP"
      self.bitmap = @image[9].dup if @value == "Counter"
      self.bitmap = @image[10].dup if @value == "Reflection"
      self.bitmap = @image[15].dup if @value == "Blocked"
      self.bitmap = @image[16].dup if @value == "AutoRevive"
      self.bitmap = @image[17].dup if @value == "Fail"
      self.bitmap = @image[18].dup if @value == "Nothing"
      self.bitmap = @image[20].dup if @value == "Knock_Down"
      self.bitmap = @image[21].dup if @value == "Knock_Back"
      self.bitmap = @image[22].dup if @value == "Immune"
      self.bitmap = @image[23].dup if @value == "Interrupted"
      
  end
  
  #--------------------------------------------------------------------------
  # ● Create Spring
  #--------------------------------------------------------------------------               
  def create_string 
      string_size = @value.to_s.split(//) ; fsize = FONT_SIZE > 10 ? FONT_SIZE : 10
      @stg_size = string_size.size > 0 ? ((1 + string_size.size ) * ((fsize / 2) - 2)) : 32      
      self.bitmap = Bitmap.new(@stg_size,32)
      self.bitmap.font.color = FONT_COLOR
      self.bitmap.font.size = fsize ; self.bitmap.font.bold = FONT_BOLD
      self.bitmap.font.italic = FONT_ITALIC
      if @type == "Item"
         self.bitmap.font.color = FONT_COLOR_ITEM
      elsif @type == "States Plus"
         self.bitmap.font.color = FONT_COLOR_STATUS_PLUS
      elsif @type == "States Minus"
         self.bitmap.font.color = FONT_COLOR_STATUS_MINUS
      end      
      self.bitmap.draw_text(0, 0, self.bitmap.width, self.bitmap.height, @value.to_s,0)
      draw_states if @state_index != nil
  end
  
  #--------------------------------------------------------------------------
  # ● Draw States
  #--------------------------------------------------------------------------               
  def draw_states
      @sup_sprite = Sprite.new ; @sup_sprite.bitmap = Bitmap.new(24,24)
      rect = Rect.new(@state_index % 16 * 24, @state_index / 16 * 24, 24, 24)
      @image[14] = Cache.system("Iconset") if @image[14]== nil or @image[14].disposed?
      @sup_sprite.bitmap.blt(0, 0, @image[14].dup, rect) rescue nil
      (@org_xy[1] += (@ch + 5) ; @y += (@ch + 5)) unless !SceneManager.is_a?(Scene_Battle)
      @cw2 = @sup_sprite.bitmap.width + @cw / 2 ; @sup_sprite.visible = false
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Damage
  #--------------------------------------------------------------------------               
  def update_damage(index_max,index,battler)
      @index_max = index_max ; @index = index
      return if self.bitmap == nil or self.bitmap.disposed?
      @duration -= 1
      self.visible = @duration > 90 ? false : true
      return if !self.visible
      dif_y = (@index_max - @index)
      update_animation(dif_y)
      update_sprite_position(dif_y,battler)
      update_sup_position(dif_y) if @sup_sprite
      dispose_damage if @duration <= 0
  end
  
  #--------------------------------------------------------------------------
  # ● Update Sprite Position
  #--------------------------------------------------------------------------               
  def update_sprite_position(dif_y,battler)
      execute_move(0,self,@org_xy[0] + @oxy[0])
      execute_move(1,self,@org_xy[1] + @oxy[1] - (dif_y * Y_SPACE))
      self.zoom_y = self.zoom_x
      update_battle_camera if oxy_camera?(battler)
  end    
  
  #--------------------------------------------------------------------------
  # ● Update Battle Camera
  #--------------------------------------------------------------------------               
  def update_battle_camera
      self.ox = $game_temp.viewport_oxy[0] + @org_oxy[0]
      self.oy = $game_temp.viewport_oxy[1] + @org_oxy[1]
      @sup_sprite.ox = $game_temp.viewport_oxy[0] + @org_oxy[2] if @sup_sprite != nil
      @sup_sprite.oy = $game_temp.viewport_oxy[1] + @org_oxy[3] if @sup_sprite != nil
  end  
  
  #--------------------------------------------------------------------------
  # ● OXY_CAMERA
  #--------------------------------------------------------------------------               
  def oxy_camera?(battler) 
      return false if $imported[:mog_battle_camera] == nil
      if battler.is_a?(Game_Actor)
         return false if $imported[:mog_battle_hud_ex] and SceneManager.face_battler?
      end
      return true
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Move
  #--------------------------------------------------------------------------      
  def execute_move(type,sprite,np)
      cp = type == 0 ? sprite.x : sprite.y
      sp = 1 + ((cp - np).abs / 10)
      sp = 1 if @duration < 60
      if cp > np ;    cp -= sp ; cp = np if cp < np
      elsif cp < np ; cp += sp ; cp = np if cp > np
      end     
      sprite.x = cp if type == 0 ; sprite.y = cp if type == 1
  end   
  
  #--------------------------------------------------------------------------
  # ● Update Animation
  #--------------------------------------------------------------------------               
  def update_animation(dif_y)
     @oxy[1] -= 1
     case @duration
     when 60..90 ; self.opacity += 15
     when 30..60 ; self.opacity = 255
     when 0..30  ; self.opacity -= 9
     end
  end
 
end

#==============================================================================
# ■ Sprite Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  
  #--------------------------------------------------------------------------
  # ● Update Collapse
  #--------------------------------------------------------------------------  
  alias mog_damage_pop_update_collapse update_collapse
  def update_collapse
      mog_damage_pop_update_collapse
      execute_exp_pop
  end
  
  #--------------------------------------------------------------------------
  # ● Update Instant Collapse
  #--------------------------------------------------------------------------  
  alias mog_damage_pop_update_instant_collapse update_instant_collapse
  def update_instant_collapse
      mog_damage_pop_update_instant_collapse 
      execute_exp_pop
  end    
  
  #--------------------------------------------------------------------------
  # ● Update Boss Collapse
  #--------------------------------------------------------------------------  
  alias mog_damage_pop_update_boss_collapse update_boss_collapse
  def update_boss_collapse
      mog_damage_pop_update_boss_collapse
      execute_exp_pop
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Exp Pop
  #--------------------------------------------------------------------------  
  def execute_exp_pop
      return if !MOG_DAMAGEPOPUP::EXP_GOLD_POPUP_BATTLE or @dam_exp != nil
      return if @battler == nil or @battler.is_a?(Game_Actor)
      @dam_exp = true
      if $imported[:mog_active_bonus_gauge] != nil
         real_exp = $game_troop.bonus_exp? ? @battler.exp * 2 : @battler.exp
         real_gold = $game_troop.bonus_gold? ? @battler.gold * 2 : @battler.gold
      else
         real_exp = @battler.exp ;  real_gold = @battler.gold
      end
      @battler.damage.push([real_exp,"Exp"]) if @battler.exp > 0
      @battler.damage.push([real_gold,"Gold"]) if @battler.gold > 0
  end    
  
end