#==============================================================================
# +++ MOG - Debug Mode + Ver 1.7 (For Scripters) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# O script aumenta a produtividade do programador ao diminuir o tempo
# que ele precisa para fazer algumas configurações corriqueiras no Rpgmaker 
# seja via evento ou no banco de dados para testar o seu script.
#==============================================================================
# NOTA - Coloque este script abaixo de todos os outros scripts, com excessão
# do script MAIN.
#==============================================================================

#===============================================================================
if false # Set false/true to disable or enable this script
#===============================================================================
module MOG_DEBUG_MODE_P
  
#===============================================================================
# TEST SPEED
#===============================================================================  
  #Desabilitar as transições.
  DISABLE_TRANSITIONS = true
  
  #Pular a tela de titulo
  SKIP_SCENE_TITLE = true  
  
  #Definição da velocidade do jogo.
  LIMIT_OF_FRAMES = 60
  
  #Definição do tamanho da tela.
  SCREEN_SIZE = [544,416]
#===============================================================================
# GAME PARTY 
#===============================================================================  
  #Itens e Dinheiro 
  START_ALL_WEAPONS = true
  START_ALL_ARMORS = true
  START_ALL_ITEMS = true
  GOLD_AMOUNT = 9999999
  #Os personagens começam com todas as habilidades. 
  MEMBERS_LEARN_ALL_SKILLS = false
  #Definição do level inicial dos personagens. 
  #Defina " nil " se desejar desativar essa opção.
  MEMBERS_INITIAL_LEVEL = nil# 99
  
#===============================================================================
# BATTLE SYSTEM
#===============================================================================
  #Ativar o efeito de batalha.
  ENABLE_BATTLE_EFFECTS = false
  
  #Inicio automático da batalha ao começar o jogo, coloque a ID da batalha
  #para ativa-la ou coloque nil para desativa-la.
  AUTO_BATTLE_TEST_ID = nil# (Troop ID)
  
  #Definição em porcentagem.(%)
  START_ALL_MEMBERS_HP = 100 # Zero = Instant Game Over
  START_ALL_MEMBERS_MP = 100
  START_ALL_MEMBERS_TP = 100
  START_ALL_ENEMIES_HP = 100 # Zero = Instant Victory
  START_ALL_ENEMIES_MP = 100  
  
  #Personagens não recebem dano. (Excessão danos através de itens)
  MEMBERS_IMMORTALS = false
  #Inimigos não recebem dano. (Excessão danos através de itens)
  ENEMIES_IMMORTALS = false
  #Define um valor fixo de dano. (Deixe DAMAGE_FIX = nil para desativa-la)
  DAMAGE_FIX = nil
end 

$imported = {} if $imported.nil?
$imported[:mog_debug_mode_plus] = true

#===============================================================================
# ■ SceneManager
#===============================================================================
class << SceneManager
  include MOG_DEBUG_MODE_P
  #--------------------------------------------------------------------------
  # * Execute
  #--------------------------------------------------------------------------
  alias mog_debug_run run
  def run
      Graphics.resize_screen(SCREEN_SIZE[0],SCREEN_SIZE[1])
      mog_debug_run
  end 
    
end

#===============================================================================
# ■ Game Temp
#===============================================================================
class Game_Temp
  
  attr_accessor :auto_battle_start
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------          
  alias mog_east_test_initialize initialize
  def initialize
      @auto_battle_start = true
      mog_east_test_initialize
  end  
  
 #--------------------------------------------------------------------------
 # ● Show frames
 #--------------------------------------------------------------------------     
  def show_frames
      $showm = Win32API.new 'user32', 'keybd_event', %w(l l l l), ''
      $showm.call(0x71,0,0,0)
      sleep(0.1)
      $showm.call(0x71,0,2,0)    
  end  

end  
  
#===============================================================================
# ■ Game Party
#===============================================================================
class Game_Party < Game_Unit
  
  #--------------------------------------------------------------------------
  # ● Force Battle
  #--------------------------------------------------------------------------        
  def force_battle(troop_id, can_escape = true, can_lose = false)
      return if $game_party.in_battle
      if $data_troops[troop_id]
         BattleManager.setup(troop_id, can_escape, can_lose)
         $game_player.make_encounter_count
         SceneManager.call(Scene_Battle)
      end
  end  
  
  #--------------------------------------------------------------------------
  # ● Gain All Itens
  #--------------------------------------------------------------------------      
  def gain_all_items
      $data_items.each {|item| gain_item(item, 99) } 
  end  
    
  #--------------------------------------------------------------------------
  # ● Gain All Weapons
  #--------------------------------------------------------------------------      
  def gain_all_weapons
      $data_weapons.each {|item| gain_item(item, 99) }
  end
    
  #--------------------------------------------------------------------------
  # ● Gain All Armors
  #--------------------------------------------------------------------------      
  def gain_all_armors
      $data_armors.each {|item| gain_item(item, 99) }
  end
  
  #--------------------------------------------------------------------------
  # ● Gain Everthing
  #--------------------------------------------------------------------------      
  def gain_everything
      gain_gold(999999999)
      gain_all_weapons
      gain_all_armors
      gain_all_items
  end 
  
end

#==============================================================================
# ■ Game Actor
#==============================================================================
class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # ● Force Learn All Skills
  #--------------------------------------------------------------------------                          
  def force_learn_all_skills
      for i in 0..$data_skills.size
          learn_skill(i) 
      end  
  end
    
end

#==============================================================================
# ■ Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  include MOG_DEBUG_MODE_P
  
  #--------------------------------------------------------------------------
  # ● Start
  #--------------------------------------------------------------------------                          
  if AUTO_BATTLE_TEST_ID != nil and AUTO_BATTLE_TEST_ID.is_a?(Numeric)
  alias mog_easy_test_battle_test_start start
  def start
      mog_easy_test_battle_test_start
      if $game_temp.auto_battle_start
         $game_temp.auto_battle_start = false
         $game_party.force_battle(AUTO_BATTLE_TEST_ID) rescue nil
      end   
  end
  end

end

if $TEST
  
if MOG_DEBUG_MODE_P::ENABLE_BATTLE_EFFECTS
  
#==============================================================================
# ■ Game Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  include  MOG_DEBUG_MODE_P
  
  #--------------------------------------------------------------------------
  # ● Make Damage Value
  #--------------------------------------------------------------------------                        
  alias mog_easy_test_make_damage_value make_damage_value
  def make_damage_value(user, item)
      mog_easy_test_make_damage_value(user, item)
      if DAMAGE_FIX != nil and DAMAGE_FIX.is_a?(Numeric)
         @result.make_damage(DAMAGE_FIX.to_i, item)
      end
  end  
  
  #--------------------------------------------------------------------------
  # ● Item Apply
  #--------------------------------------------------------------------------                      
  alias mog_easy_test_item_apply item_apply
  def item_apply(user, item)
      if self.is_a?(Game_Enemy) and ENEMIES_IMMORTALS        
         return 
      elsif self.is_a?(Game_Actor) and MEMBERS_IMMORTALS
         return
      end  
      mog_easy_test_item_apply(user, item)
  end
   
end

#===============================================================================
# ■ Scene Battle
#===============================================================================  
class Scene_Battle < Scene_Base
  include MOG_DEBUG_MODE_P
  
  #--------------------------------------------------------------------------
  # ● Start
  #--------------------------------------------------------------------------                    
  alias mog_quick_test_battle_start battle_start
  def battle_start
      mog_quick_test_battle_start
      execute_quick_test_start
  end  
  
  #--------------------------------------------------------------------------
  # ● Execute Quick Test Start
  #--------------------------------------------------------------------------                    
  def execute_quick_test_start
      for i in $game_party.members
          i.hp = i.mhp * START_ALL_MEMBERS_HP / 100
          i.mp = i.mmp * START_ALL_MEMBERS_MP / 100
          i.tp = START_ALL_MEMBERS_TP
      end
      for i in $game_troop.alive_members
          i.hp = i.mhp * START_ALL_ENEMIES_HP / 100
          i.mp = i.mmp * START_ALL_ENEMIES_MP / 100  
      end          
  end
  
end
end

if MOG_DEBUG_MODE_P::LIMIT_OF_FRAMES != 60
#===============================================================================
# ■ Scene Base
#===============================================================================  
class Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------                  
  alias mog_quick_test_update update
  def update
      mog_quick_test_update
      update_quick_test
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Quick Test
  #--------------------------------------------------------------------------                  
  def update_quick_test
      Graphics.frame_rate = MOG_DEBUG_MODE_P::LIMIT_OF_FRAMES
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Fast Test
  #--------------------------------------------------------------------------                  
  def update_fast_test        
  end  
  
end
end

if MOG_DEBUG_MODE_P::DISABLE_TRANSITIONS
  
#===============================================================================
# ■ Scene Base
#===============================================================================  
class Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Transition Speed
  #--------------------------------------------------------------------------                
  def transition_speed
      return 0
  end    
  
end

#===============================================================================
# ■ Scene Battle
#===============================================================================
class Scene_Battle < Scene_Base
 
  #--------------------------------------------------------------------------
  # ● Perform Transition
  #--------------------------------------------------------------------------                
  def perform_transition
      Graphics.transition(0)
  end

  #--------------------------------------------------------------------------
  # ● Perform Transition
  #--------------------------------------------------------------------------              
  def transition_speed
      return 0
  end  
  
end  
  
#===============================================================================
# ■ Scene Title
#===============================================================================
class Scene_Title < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Perform Transition
  #--------------------------------------------------------------------------                
  def perform_transition
      Graphics.transition(0)
  end  
  
  #--------------------------------------------------------------------------
  # ● Perform Transition
  #--------------------------------------------------------------------------              
  def transition_speed
      return 0
  end
end   

#===============================================================================
# ■ Scene Map
#===============================================================================
class Scene_Map < Scene_Base

  #--------------------------------------------------------------------------
  # ● Perform Transition
  #--------------------------------------------------------------------------            
  def perform_transition
      super
  end  
  
  #--------------------------------------------------------------------------
  # ● Transition Speed
  #--------------------------------------------------------------------------            
  def transition_speed
      return 0
  end    
  
  #--------------------------------------------------------------------------
  # ● Perform Battle Transition
  #--------------------------------------------------------------------------          
  def perform_battle_transition
      Graphics.freeze
  end
    
  #--------------------------------------------------------------------------
  # ● Pre Transfer
  #--------------------------------------------------------------------------  
  def pre_transfer
      @map_name_window.close
  end
  
  #--------------------------------------------------------------------------
  # ● Pos Transfer
  #--------------------------------------------------------------------------
  def post_transfer
      @map_name_window.open
  end    
  
end  

if $imported[:mog_transition_ex] != nil
    #===============================================================================
    # ■ Module Transition
    #===============================================================================
    module Module_Transition_EX
      include MOG_TRANSITION_EX
     
      #--------------------------------------------------------------------------
      # ● Initialize
      #--------------------------------------------------------------------------        
      def execute_transition_ex 
      end  
      
    end
end

end

if MOG_DEBUG_MODE_P::SKIP_SCENE_TITLE
#===============================================================================
# ■ Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Start
  #--------------------------------------------------------------------------    
  def start
      super
      SceneManager.clear
      Graphics.freeze
      go_to_map
  end  
  
  #--------------------------------------------------------------------------
  # ● Go_to_Map
  #--------------------------------------------------------------------------    
  def go_to_map
      DataManager.setup_new_game
      $game_map.autoplay
      SceneManager.goto(Scene_Map) 
  end

  #--------------------------------------------------------------------------
  # ● Pos Start
  #--------------------------------------------------------------------------        
  def post_start
  end 
  
  #--------------------------------------------------------------------------
  # ● Pre Terminate
  #--------------------------------------------------------------------------      
  def pre_terminate  
  end
  
  #--------------------------------------------------------------------------
  # ● Terminate
  #--------------------------------------------------------------------------      
  def terminate
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Background
  #--------------------------------------------------------------------------      
  def dispose_background
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Foreground
  #--------------------------------------------------------------------------      
  def dispose_foreground
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Logo
  #--------------------------------------------------------------------------      
  if !$imported[:mog_title_multilogo].nil?
     def execute_tlogo  
     end  
  end
       
end

end

#===============================================================================
# ■ Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  include MOG_DEBUG_MODE_P
  
  #--------------------------------------------------------------------------
  # ● Start
  #--------------------------------------------------------------------------    
  alias mog_gain_everything_start start
  def start
      mog_gain_everything_start
      $game_temp.show_frames
      $game_party.gain_all_weapons if START_ALL_WEAPONS
      $game_party.gain_all_armors if START_ALL_ARMORS 
      $game_party.gain_all_items if START_ALL_ITEMS
      $game_party.gain_gold(GOLD_AMOUNT)
      $game_party.members.each {|actor|
      actor.force_learn_all_skills if MEMBERS_LEARN_ALL_SKILLS
      actor.change_level(MEMBERS_INITIAL_LEVEL, false) rescue nil
      }
  end
    
end

end


end