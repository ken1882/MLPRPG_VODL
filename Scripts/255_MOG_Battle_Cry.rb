#==============================================================================
# +++ MOG - Battle Cry (V1.4) +++ 
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Sistema de execução de multiplas vozes aleatórias durante a batalha.
# O sistema funciona tanto para inimigos como para os personagens.
#==============================================================================
# ● Histórico (Version History)
#==============================================================================
# v1.4 - Melhoria na compatibilidade.
#==============================================================================
$imported = {} if $imported.nil?
$imported[:mog_battle_cry] = true

module MOG_BATTLE_CRY
  
  # Não modifique essa parte.
  # ☢CAUTION!!☢ Don't Touch.^_^
  ACTOR_SKILL = []
  ACTOR_ITEM = []
  ACTOR_GENERAL_ACTION = []
  ACTOR_DAMAGE = []
  ACTOR_RECOVER = []
  ACTOR_DEFEATED = []
  ACTOR_BATTLE_START = []  
  ACTOR_BATTLE_END = []
  ACTOR_BATTLE_ESCAPE = []
  ACTOR_TURN_ACTIVE = []
  ACTOR_LEVEL_UP = []  
  ENEMY_SKILL = []
  ENEMY_GENERAL_ACTION = []
  ENEMY_DAMAGE = []
  ENEMY_RECOVER = []
  ENEMY_DEFEATED = []
  
  # ----------------------------------------------------------------------------
  # Definição do volume da voz.
  VOLUME = 130 
  
  # Exemplo de configuração geral, o modo de configurar é igual para todas as 
  # ações do battler.
  #
  # ACTOR_SKILL[ A ] = {  B=>["C","C","C"],
  #
  # A - ID do battler. 
  # B - ID da skill. (Caso necessário)
  # C - Nome do arquivo de som.
  
  
  #----------------------------------------------------------------------------
  # BATTLE START
  #----------------------------------------------------------------------------  
  ACTOR_BATTLE_START[1] = ["V_ACT1_START_1","V_ACT1_START_2"]
  ACTOR_BATTLE_START[2] = ["V_ACT2_START_1","V_ACT2_START_2","V_ACT2_START_3"]
#  ACTOR_BATTLE_START[3] = ["V_ACT3_START_1","V_ACT3_START_2"]
  ACTOR_BATTLE_START[4] = ["V_ACT4_START_1","V_ACT4_START_2","V_ACT4_START_3"]
  ACTOR_BATTLE_START[5] = ["V_ACT5_START_1","V_ACT5_START_2","V_ACT5_START_3"]
  ACTOR_BATTLE_START[6] = ["V_ACT6_START_1","V_ACT6_START_2","V_ACT6_START_3"]
  ACTOR_BATTLE_START[7] = ["V_ACT7_START_1","V_ACT7_START_2","V_ACT7_START_3"]
  
  

  #----------------------------------------------------------------------------
  # BATTLE END
  #----------------------------------------------------------------------------    
  ACTOR_BATTLE_END[1] = ["V_ACT1_WIN_1","V_ACT1_WIN_2"]
  ACTOR_BATTLE_END[2] = ["V_ACT2_WIN_1","V_ACT2_WIN_2","V_ACT2_WIN_3"]
#  ACTOR_BATTLE_END[3] = ["V_ACT3_WIN_1","V_ACT3_WIN_2","V_ACT3_WIN_3"]
  ACTOR_BATTLE_END[4] = ["V_ACT4_WIN_1","V_ACT4_WIN_2","V_ACT4_WIN_3"]
  ACTOR_BATTLE_END[5] = ["V_ACT5_WIN_1","V_ACT5_WIN_2","V_ACT5_WIN_3"]
  ACTOR_BATTLE_END[6] = ["V_ACT6_WIN_1","V_ACT6_WIN_2"]
  ACTOR_BATTLE_END[7] = ["V_ACT7_WIN_1","V_ACT7_WIN_2"]


  #----------------------------------------------------------------------------
  # ACTOR TURN ACTIVE
  #----------------------------------------------------------------------------
  # Funciona apenas com script MOG AT SYSTEM.
  #----------------------------------------------------------------------------
  ACTOR_TURN_ACTIVE[1] = ["V_ACT1_TURN_1","V_ACT1_TURN_2","V_ACT1_TURN_3"]
  ACTOR_TURN_ACTIVE[2] = ["V_ACT2_TURN_1","V_ACT2_TURN_2","V_ACT2_TURN_3"]
#  ACTOR_TURN_ACTIVE[3] = ["V_ACT3_TURN_1","V_ACT3_TURN_2","V_ACT3_TURN_3"]
  ACTOR_TURN_ACTIVE[4] = ["V_ACT4_TURN_1","V_ACT4_TURN_2","V_ACT4_TURN_3"]  
  ACTOR_TURN_ACTIVE[5] = ["V_ACT5_TURN_1","V_ACT5_TURN_2","V_ACT5_TURN_3","V_ACT5_TURN_4"]  
  ACTOR_TURN_ACTIVE[6] = ["V_ACT6_TURN_1","V_ACT6_TURN_2","V_ACT6_TURN_3"]  
  ACTOR_TURN_ACTIVE[7] = ["V_ACT7_TURN_1","V_ACT7_TURN_2","V_ACT7_TURN_3"]  
=begin      
  #----------------------------------------------------------------------------
  # BATTLE ESCAPE
  #----------------------------------------------------------------------------      
  ACTOR_BATTLE_ESCAPE[1] = ["V_ACT1_SKILL_9"]
  ACTOR_BATTLE_ESCAPE[2] = ["V_ACT2_SKILL_4"]
  ACTOR_BATTLE_ESCAPE[3] = ["V_ACT3_SKILL_4"]
  ACTOR_BATTLE_ESCAPE[4] = ["V_ACT4_SKILL_7"]
  
  #----------------------------------------------------------------------------
  # ACTOR LEVEL UP
  #----------------------------------------------------------------------------  
  ACTOR_LEVEL_UP[1] = ["V_ACT1_TURN_1"] 
  ACTOR_LEVEL_UP[2] = ["V_ACT2_TURN_1"] 
  ACTOR_LEVEL_UP[3] = ["V_ACT3_TURN_1"] 
  ACTOR_LEVEL_UP[4] = ["V_ACT4_TURN_1"] 
  
  #----------------------------------------------------------------------------
  # ACTOR SKILL
  #----------------------------------------------------------------------------
  ACTOR_SKILL[1] = { 
  1=>["V_ACT1_ATTACK_1","V_ACT1_ATTACK_2","V_ACT1_ATTACK_3"],
  2=>["V_ACT1_WIN_1","V_ACT1_WIN_2"]
  }  
  
  ACTOR_SKILL[2] = {
  1=>["V_ACT2_ATTACK_1","V_ACT2_ATTACK_2","V_ACT2_ATTACK_3"],
  2=>["V_ACT2_WIN_1","V_ACT2_WIN_2","V_ACT2_WIN_3"],
  26=>["V_ACT2_SKILL_6","V_ACT2_SKILL_7","V_ACT2_SKILL_8"],
  29=>["V_ACT2_SKILL_6","V_ACT2_SKILL_7","V_ACT2_SKILL_8"],
  32=>["V_ACT2_SKILL_6","V_ACT2_SKILL_7","V_ACT2_SKILL_8"],
  33=>["V_ACT2_SKILL_6","V_ACT2_SKILL_7","V_ACT2_SKILL_8"],
  }
  
  ACTOR_SKILL[3] = {
  1=>["V_ACT3_ATTACK_1","V_ACT3_ATTACK_2","V_ACT3_ATTACK_3"],
  2=>["V_ACT3_SKILL_4"],
  26=>["V_ACT3_SKILL_3","V_ACT3_SKILL_6","V_ACT3_SKILL_7"],
  76=>["V_ACT3_SKILL_3","V_ACT3_SKILL_6","V_ACT3_SKILL_7"],
  77=>["V_ACT3_SKILL_3","V_ACT3_SKILL_6","V_ACT3_SKILL_7"],
  78=>["V_ACT3_SKILL_3","V_ACT3_SKILL_6","V_ACT3_SKILL_7"]
  }
  
  ACTOR_SKILL[4] = {
  1=>["V_ACT4_ATTACK_1","V_ACT4_ATTACK_2","V_ACT4_ATTACK_3"],
  2=>["V_ACT4_SKILL_3","V_ACT4_SKILL_8"],
  51=>["V_ACT4_SKILL_1","V_ACT4_SKILL_4","V_ACT4_SKILL_6","V_ACT4_SKILL_9"],
  53=>["V_ACT4_SKILL_1","V_ACT4_SKILL_4","V_ACT4_SKILL_6","V_ACT4_SKILL_9"],
  61=>["V_ACT4_SKILL_1","V_ACT4_SKILL_4","V_ACT4_SKILL_6","V_ACT4_SKILL_9"],
  66=>["V_ACT4_SKILL_1","V_ACT4_SKILL_4","V_ACT4_SKILL_6","V_ACT4_SKILL_9"],
  74=>["V_ACT4_SKILL_1","V_ACT4_SKILL_4","V_ACT4_SKILL_6","V_ACT4_SKILL_9"]
  }
  
  #----------------------------------------------------------------------------
  # ACTOR ITEM
  #----------------------------------------------------------------------------
  ACTOR_ITEM[1] = { 
  1=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"], 2=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"],
  3=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"], 4=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"],
  5=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"], 6=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"],
  7=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"], 8=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"],
  17=>["V_ACT1_SKILL_6","V_ACT1_SKILL_7"]
  }  
  
  ACTOR_ITEM[2] = {
  1=>["V_ACT2_RECOVER_2"],  2=>["V_ACT2_RECOVER_2"],  3=>["V_ACT2_RECOVER_2"],
  4=>["V_ACT2_RECOVER_2"],  5=>["V_ACT2_RECOVER_2"],  6=>["V_ACT2_RECOVER_2"],
  7=>["V_ACT2_RECOVER_2"],  8=>["V_ACT2_RECOVER_2"],  17=>["V_ACT2_RECOVER_2"] 
  }
  
  ACTOR_ITEM[3] = {
  1=>["V_ACT3_WIN_2"],  2=>["V_ACT3_WIN_2"],  3=>["V_ACT3_WIN_2"],
  4=>["V_ACT3_WIN_2"],  5=>["V_ACT3_WIN_2"],  6=>["V_ACT3_WIN_2"],
  7=>["V_ACT3_WIN_2"],  8=>["V_ACT3_WIN_2"],  17=>["V_ACT3_WIN_2"]
  }  
    
  ACTOR_ITEM[4] = {
  1=>["V_ACT4_START_3"],  2=>["V_ACT4_START_3"],  3=>["V_ACT4_START_3"],
  4=>["V_ACT4_START_3"],  5=>["V_ACT4_START_3"],  6=>["V_ACT4_START_3"],
  7=>["V_ACT4_START_3"],  8=>["V_ACT4_START_3"],  17=>["V_ACT4_START_3"]
  }  
=end  
  #----------------------------------------------------------------------------
  # ACTOR GENERAL ACTION *( STANDARD / FOR ALL SKILLS / ITEMS)
  #----------------------------------------------------------------------------  
  # Definição das vozes para habilidades não especificas. Essas vozes serão
  # ativadas em todas habilidades que não estejam definidas na função ACTOR SKILL.
  # Naturalmente se não desejar essa função basta não definir nada.
   #----------------------------------------------------------------------------  
#  ACTOR_GENERAL_ACTION[1] = ["V_ACT1_ATTACK_1","V_ACT1_ATTACK_2","V_ACT1_ATTACK_3"]
#  ACTOR_GENERAL_ACTION[2] = ["V_ACT2_ATTACK_1","V_ACT2_ATTACK_2","V_ACT2_ATTACK_3"]
#  ACTOR_GENERAL_ACTION[3] = ["V_ACT3_ATTACK_1","V_ACT3_ATTACK_2","V_ACT3_ATTACK_3"]
#  ACTOR_GENERAL_ACTION[4] = ["V_ACT4_ATTACK_1","V_ACT4_ATTACK_2","V_ACT4_ATTACK_3"]
  
  #----------------------------------------------------------------------------
  # ACTOR DAMAGE
  #----------------------------------------------------------------------------
#  ACTOR_DAMAGE[1] = ["V_ACT1_DAMAGE_1","V_ACT1_DAMAGE_2"]
#  ACTOR_DAMAGE[2] = ["V_ACT2_DAMAGE_1","V_ACT2_DAMAGE_2","V_ACT2_DAMAGE_3"]
#  ACTOR_DAMAGE[3] = ["V_ACT3_DAMAGE_1","V_ACT3_DAMAGE_2","V_ACT3_DAMAGE_3"]
#  ACTOR_DAMAGE[4] = ["V_ACT4_DAMAGE_1","V_ACT4_DAMAGE_2","V_ACT4_DAMAGE_3"]
    
  #----------------------------------------------------------------------------
  # ACTOR RECOVER
  #----------------------------------------------------------------------------
#  ACTOR_RECOVER[1] = ["V_ACT1_RECOVER_1","V_ACT1_RECOVER_2"]
#  ACTOR_RECOVER[2] = ["V_ACT2_RECOVER_1","V_ACT2_RECOVER_2"]
#  ACTOR_RECOVER[3] = ["V_ACT3_RECOVER_1","V_ACT3_RECOVER_2"]
#  ACTOR_RECOVER[4] = ["V_ACT4_RECOVER_1","V_ACT4_RECOVER_2"]

  #----------------------------------------------------------------------------
  # ACTOR DEFEATED
  #----------------------------------------------------------------------------
  ACTOR_DEFEATED[1] = ["V_ACT1_DEFEAT_1"]
  ACTOR_DEFEATED[2] = ["V_ACT2_DEFEAT_1"]
#  ACTOR_DEFEATED[3] = ["V_ACT3_DEFEAT_1"]
  ACTOR_DEFEATED[4] = ["V_ACT4_DEFEAT_1","V_ACT4_DEFEAT_2"]  
  ACTOR_DEFEATED[5] = ["V_ACT5_DEFEAT_1"]
  ACTOR_DEFEATED[6] = ["V_ACT6_DEFEAT_1"]
  ACTOR_DEFEATED[7] = ["V_ACT7_DEFEAT_1"]

  #----------------------------------------------------------------------------
  # ENEMY SKILL
  #----------------------------------------------------------------------------
#  ENEMY_SKILL[7] = {
#  135=>["V_ENE1_SKILL_3"]
#  }    
#  ENEMY_SKILL[9] = {
#  137=>["Cel_Attack_01","Cel_Attack_02","Cel_Attack_03","Cel_Attack_04"]
#  }      
  
  
  #----------------------------------------------------------------------------
  # ENEMY GENERAL SKILLS
  #----------------------------------------------------------------------------  
#  ENEMY_GENERAL_ACTION[7] = ["V_ENE1_ATTACK_1","V_ENE1_ATTACK_2","V_ENE1_ATTACK_3"]
#  ENEMY_GENERAL_ACTION[11] = ["Reimu_A1","Reimu_A2"]
#  ENEMY_GENERAL_ACTION[12] = ["Satori_A1","Satori_A2"]
  
  #----------------------------------------------------------------------------
  # ENEMY DAMAGE
  #----------------------------------------------------------------------------
#  ENEMY_DAMAGE[7] = ["V_ENE1_DAMAGE_1","V_ENE1_DAMAGE_2","V_ENE1_DAMAGE_3"]
#  ENEMY_DAMAGE[11] = ["Reimu_D1","Reimu_D2"]
#  ENEMY_DAMAGE[9] = ["Cel_Damage1","Cel_Damage2"]
#  ENEMY_DAMAGE[12] = ["Satori_D1","Satori_D2"]
  
  #----------------------------------------------------------------------------
  # ENEMY RECOVER
  #----------------------------------------------------------------------------
#  ENEMY_RECOVER[7] = []
  
  #----------------------------------------------------------------------------
  # ENEMY DEFEATED
  #----------------------------------------------------------------------------
#  ENEMY_DEFEATED[7] =  ["V_ENE1_DEFEAT_1"]
#  ENEMY_DEFEATED[11] =  ["Reimu_DF"]
#  ENEMY_DEFEATED[12] =  ["Satori_DF"]
  
end

#===============================================================================
# ■ Battle Cry
#===============================================================================
module BATTLE_CRY
  
  include MOG_BATTLE_CRY
  
  #--------------------------------------------------------------------------
  # ● Execute Battle Cry
  #--------------------------------------------------------------------------      
  def execute_battle_cry(type = 0, skill_id = nil, battler = nil)
      @type = type ; @skill_id = skill_id ; @battler = battler
      case @type
         when 0 # START #
           check_members_alive
           voice_list = ACTOR_BATTLE_START[@battler.id] rescue nil         
         when 1 # END   #
            check_members_alive
            voice_list = ACTOR_BATTLE_END[@battler.id] rescue nil
         when 2 # SKILL #
            if @battler.is_a?(Game_Actor)
               voice = ACTOR_SKILL[@battler.id] rescue nil     
            else  
               voice = ENEMY_SKILL[@battler.enemy_id] rescue nil
            end
            voice_list = voice[@skill_id] rescue nil
            if voice_list == nil # GENERAL ACTION
               if @battler.is_a?(Game_Actor)
                  voice_list = ACTOR_GENERAL_ACTION[@battler.id] rescue nil     
               else  
                  voice_list = ENEMY_GENERAL_ACTION[@battler.enemy_id] rescue nil
               end
            end  
         when 3 # DAMAGE # 
            if @battler.hp > 0
               if @battler.is_a?(Game_Actor)
                  voice_list = ACTOR_DAMAGE[@battler.id] rescue nil     
               else  
                  voice_list = ENEMY_DAMAGE[@battler.enemy_id] rescue nil
               end            
            else # DEFEATED #
               if @battler.is_a?(Game_Actor)
                  voice_list = ACTOR_DEFEATED[@battler.id] rescue nil     
               else  
                  voice_list = ENEMY_DEFEATED[@battler.enemy_id] rescue nil
               end                        
            end
         when 4 # RECOVER # 
              if @battler.is_a?(Game_Actor)
                 voice_list = ACTOR_RECOVER[@battler.id] rescue nil     
              else  
                 voice_list = ENEMY_RECOVER[@battler.enemy_id] rescue nil
              end            
         when 5 # ITEM #
               voice = ACTOR_ITEM[@battler.id] rescue nil     
               voice_list = voice[@skill_id] rescue nil
            if voice_list == nil # GENERAL SKILLS 
               voice_list = ACTOR_GENERAL_ACTION[@battler.id] rescue nil     
            end          
         when 6 # START #
               check_members_alive
               voice_list = ACTOR_BATTLE_ESCAPE[@battler.id] rescue nil
         when 7 # TURN #
               voice_list = ACTOR_TURN_ACTIVE[@battler.id] rescue nil             
      end
      play_battle_cry(voice_list) ; check_battle_addons
  end
  
  #--------------------------------------------------------------------------
  # ● Play Battle Cry
  #--------------------------------------------------------------------------      
  def play_battle_cry(voice_list)
      return if voice_list == nil
      voice_id = voice_list[rand(voice_list.size)]
      Audio.se_play("Audio/SE/" + voice_id.to_s,VOLUME,100) rescue nil      
  end
  
  #--------------------------------------------------------------------------
  # ● Check Members Alive
  #--------------------------------------------------------------------------        
  def check_members_alive
      alive_members = []
      for i in $game_party.battle_members
         alive_members.push(i) if i.hp > 0      
      end   
      members_id = rand(alive_members.size)
      alive_members.each_with_index do |i, index|
          if members_id == index
             @battler = i 
             break
          end          
      end
      @battler = alive_members[members_id]
  end     
  
  #--------------------------------------------------------------------------
  # ● Check Battle Addons
  #--------------------------------------------------------------------------      
  def check_battle_addons
      if $imported[:mog_battle_hud_ex] and SceneManager.face_battler? and
         @battler != nil and @battler.is_a?(Game_Actor)
         if @type == 0 or @type == 1 or @type == 6 
            @battler.face_animation = [50,1,50] unless @battler.low_hp? or @battler.restriction >= 4
         elsif @type == 7
            @battler.face_animation = [50,1,50] unless @battler.low_hp? or @battler.restriction >= 4
         end   
      end  
  end  
  
end

#==============================================================================
# ■ BattleManager
#==============================================================================
class << BattleManager
  include BATTLE_CRY
  
  #--------------------------------------------------------------------------
  # ● Process Victory
  #--------------------------------------------------------------------------    
  alias mog_battle_cry_process_victory process_victory
  def process_victory
      execute_battle_cry(1, nil, nil)          
      mog_battle_cry_process_victory
  end  
  
  #--------------------------------------------------------------------------
  # ● Process Abort
  #--------------------------------------------------------------------------      
  alias mog_battle_cry_process_abort process_abort
  def process_abort
      execute_battle_cry(6, nil, nil)
      mog_battle_cry_process_abort
  end  
  
end

#==============================================================================
# ■ Game Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  include BATTLE_CRY
  
  #--------------------------------------------------------------------------
  # ● Execute Damage
  #--------------------------------------------------------------------------      
  alias mog_battle_cry_execute_damage execute_damage
  def execute_damage(user)
      mog_battle_cry_execute_damage(user)    
      execute_battle_cry_damage
  end

  #--------------------------------------------------------------------------
  # ● Execute Battle Cry Damage
  #--------------------------------------------------------------------------        
  def execute_battle_cry_damage
      if @result.hp_damage > 0
         execute_battle_cry(3, nil, self)
      elsif @result.hp_damage < 0   
         execute_battle_cry(4, nil, self)
      else
         if @result.hp_damage == 0 
            if @result.mp_damage > 0
               execute_battle_cry(3, nil, self)
            elsif @result.mp_damage < 0
               execute_battle_cry(4, nil, self)
            end   
         end   
      end
  end  
 
  #--------------------------------------------------------------------------
  # ● Item Effect Recover HP
  #--------------------------------------------------------------------------          
  alias mog_battle_cry_item_effect_recover_hp item_effect_recover_hp  
  def item_effect_recover_hp(user, item, effect)
      chp = self.hp
      mog_battle_cry_item_effect_recover_hp(user, item, effect)
      if self.hp > chp
         execute_battle_cry(4, nil, self)
      elsif self.hp < chp
         execute_battle_cry(3, nil, self)
      end  
  end
    
  #--------------------------------------------------------------------------
  # ● Item Effect Reover MP
  #--------------------------------------------------------------------------            
  alias mog_battle_cry_item_effect_recover_mp item_effect_recover_mp
  def item_effect_recover_mp(user, item, effect)
      cmp = self.mp
      mog_battle_cry_item_effect_recover_mp(user, item, effect)
      if self.mp > cmp
         execute_battle_cry(4, nil, self)
      elsif self.mp < cmp
         execute_battle_cry(3, nil, self)
      end        
  end  
  
end

#==============================================================================
# ■ Game Action
#==============================================================================
class Scene_Battle < Scene_Base
 include BATTLE_CRY 
  
  #--------------------------------------------------------------------------
  # ● Show Animations
  #--------------------------------------------------------------------------     
  alias mog_battle_cry_show_animation show_animation
  def show_animation(targets, animation_id)
      battle_cry(targets, animation_id)
      mog_battle_cry_show_animation(targets, animation_id)
  end
  
  #--------------------------------------------------------------------------
  # ● Battle Cry 
  #--------------------------------------------------------------------------     
  def battle_cry(targets, animation_id)
      return if @subject == nil
      return if @subject.current_action == nil
      return if @subject.current_action.item == nil
      if @subject.is_a?(Game_Actor) and @subject.current_action.item.is_a?(RPG::Item)
          execute_battle_cry(5, @subject.current_action.item.id, @subject)
      else    
          execute_battle_cry(2, @subject.current_action.item.id, @subject)
      end    
  end
      
  
  #--------------------------------------------------------------------------
  # ● Process Actor Command
  #--------------------------------------------------------------------------  
  if $imported[:mog_atb_system]
  alias mog_battle_cry_process_actor_command process_actor_command
  def process_actor_command
      mog_battle_cry_process_actor_command
      execute_battle_cry(7, nil, BattleManager.actor) if BattleManager.actor
  end
  end
 
  #--------------------------------------------------------------------------
  # ● Battle Start
  #--------------------------------------------------------------------------  
  alias mog_battle_cry_update_battle update
  def update
      mog_battle_cry_update_battle
      execute_battle_cry_start
  end    
  
  #--------------------------------------------------------------------------
  # ● Execite Battle Cry Start
  #--------------------------------------------------------------------------    
  def execute_battle_cry_start
      return if @battle_cry_start != nil
      @battle_cry_start = true ; execute_battle_cry(0, nil, nil)
  end

end  