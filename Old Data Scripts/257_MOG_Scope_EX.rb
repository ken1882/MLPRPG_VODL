#==============================================================================
# +++ MOG - Scope EX (v2.1) +++
#==============================================================================
# By Moghunter 
# https://atelierrgss.wordpress.com/
#==============================================================================
# Adiciona a característica de área de impacto da ação baseado na posição
# e o tamanho do sprite do alvo.
# Por exemplo, uma habilidade de explosão vai acertar apenas os inimigos que
# estiverem em volta do alvo inicial.
# O script adiciona também a função de incluir todos os alvos da tela, aliados 
# e inimigos juntos.
#==============================================================================
# Adicione a Tag abaixo na caixa de comentários de notas para definir a área de
# impacto da habilidade.
# 
# <Scope Range = X1 - X2 - Y1 - Y2>
#
#            Y1
#            
#       X1        X2
#            
#            Y2
#
# Ex ->      <Scope Range = (100 - 32 - 64 - 32>
# 
#==============================================================================
# Incluir todos os alvos da tela. (Inimigos e Aliados)
#==============================================================================
#
# <All Targets>
#
#==============================================================================
# Ativar apenas uma animação para todos os alvos.
#==============================================================================
#
# <Unique Animation>
#
#==============================================================================

#==============================================================================
# Histórico
#==============================================================================
# v2.1 - Opção de ativar ou não o sprite do scope no modo "todos os alvos".
# v2.0 - Opção de apresentar a área.
#      - Melhoria no código
#==============================================================================

$imported = {} if $imported.nil?
$imported[:mog_scope_ex] = true

module MOG_SCOPE_EX
  #============================================================================
  # Definição do modo que vai ser calculado a área do alvo.
  # 
  # 0 - Baseado apenas na posição X e Y. (ignorando o tamanho do sprite)
  # 1 - Baseado na posição X e Y + o tamanho do sprite do alvo.
  #     (Alvos grandes tem maior area de impacto)
  #
  #============================================================================
  SCOPE_TYPE = 1
  #============================================================================
  # Definição da porcentágem total do tamanho sprite, para ser efetuado o 
  # calculo. (Apenas se o valor do SCOPE_TYPE estiver no 1)
  # Por exemplo, definindo o valor de 100% o sistema vai considerar 100% do
  # tamanho do sprite para fazer o calculo.
  #============================================================================
  # SPRITE_SIZE_RANGE = [WIDTH %, HEIGHT %]  
  #============================================================================
  SPRITE_SIZE_RANGE = [50,70]  
  #============================================================================
  # Ativar o sprite apresentando a área.
  #============================================================================
  SPRITE_SCOPE = true
  #============================================================================
  # Definição da posição Z
  #============================================================================
  SPRITE_SCOPE_Z = 90
  #============================================================================
  # Definição da cor quando o alvo é o aliado.
  #============================================================================
  ALLY_SCOPE_COLOR = [50,50,255]
  #============================================================================
  # Definição da cor quando o alvo é o inimigo.
  #============================================================================
  ENEMY_SCOPE_COLOR = [255,100,100]
  #============================================================================
  # Definição da opacidade.
  #============================================================================
  SPRITE_SCOPE_OPACITY = 155
  #============================================================================
  # Ativar o efeito Blink
  #============================================================================
  SPRITE_SCOPE_BLINK_EFFECT = true
  #============================================================================
  # Ativar o sprite do scope no modo todos os alvos.
  #============================================================================
  SPRITE_ALL_TARGETS_SCOPE = false
end

#==============================================================================
# ■ Game Battler
#==============================================================================
class Game_Temp
  
  attr_accessor :scope_ex_data
  attr_accessor :scope_ex_targets
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #-------------------------------------------------------------------------- 
  alias mog_scope_ex_temp_initialize initialize
  def initialize
      clear_scope_ex
      mog_scope_ex_temp_initialize
  end
  
  #--------------------------------------------------------------------------
  # ● Clear Scope Ex
  #-------------------------------------------------------------------------- 
  def clear_scope_ex
      @scope_ex_targets = nil
      @scope_ex_data = [nil,nil,[],[],nil,false,nil]
  end
  
end

#==============================================================================
# ■ Game Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  attr_accessor :sprite_size
  attr_accessor :primary_target
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  alias mog_scope_ex_initialize initialize
  def initialize
      @sprite_size = [0,0,true]
      mog_scope_ex_initialize
  end

end

#==============================================================================
# ■ Sprite Battler
#==============================================================================
class Sprite_Battler < Sprite_Base

  #--------------------------------------------------------------------------
  # ● Init Visible
  #-------------------------------------------------------------------------- 
  alias mog_scope_ex_init_visibility init_visibility
  def init_visibility
      @battler.sprite_size = [bitmap.width,bitmap.height,true]
      mog_scope_ex_init_visibility
  end
  
end

#==============================================================================
# ■ Scene Battle
#==============================================================================
class Scene_Battle < Scene_Base

  #--------------------------------------------------------------------------
  # ● Show Normal Animation
  #-------------------------------------------------------------------------- 
  alias mog_scope_ex_show_normal_animation show_normal_animation
  def show_normal_animation(targets, animation_id, mirror = false)
      if !@subject.primary_target.nil? and !@subject.primary_target.dead?
          p_targets = []
          item = @subject.current_action.item rescue nil
          if !item.nil? and item.note =~ /<Unique Animation>/
             p_targets.push(@subject.primary_target) 
          else
             targets.each do |t| ; p_targets.push(t) if $game_temp.scope_ex_data[6] == t ; end
             targets.each do |t| ; p_targets.push(t) if $game_temp.scope_ex_data[6] != t ; end
          end
          targets = p_targets ; @subject.primary_target = nil
      end  
      mog_scope_ex_show_normal_animation(targets, animation_id, mirror)
  end  

end

#==============================================================================
# ■ Game Action
#==============================================================================
class Game_Action
  include MOG_SCOPE_EX
  
  #--------------------------------------------------------------------------
  # ● Make Targets
  #--------------------------------------------------------------------------
  def make_targets
      if $imported[:mog_battler_motion] != nil and $imported[:mog_sprite_actor] != nil
         return @subject.pre_target if @subject != nil and @subject.pre_target != nil
      end
      if !forcing && subject.confusion?
         confusion_target
      elsif item.for_opponent?
         targets_for_opponents
      elsif item.for_friend?
         targets_for_friends
      else
        []
      end
  end  
  
  #--------------------------------------------------------------------------
  # ● Confusion Target
  #--------------------------------------------------------------------------
  def confusion_target
      case subject.confusion_level
      when 1 ; new_targets = make_new_targets([opponents_unit.random_target],0)
      when 2
          if rand(2) == 0
            new_targets = make_new_targets([opponents_unit.random_target],0) 
          else
            new_targets = make_new_targets([friends_unit.random_target],1)
          end
      else
           new_targets = make_new_targets([friends_unit.random_target],1)  
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Targets for Opponents
  #--------------------------------------------------------------------------
  def targets_for_opponents
      if item.for_random?
         org_target = Array.new(item.number_of_targets) { opponents_unit.random_target }
         new_targets = make_new_targets(org_target,0)
      elsif item.for_one?
         num = 1 + (attack? ? subject.atk_times_add.to_i : 0)
         if @target_index < 0
            org_target = [opponents_unit.random_target] * num
            new_targets = make_new_targets(org_target,0)
            
         else
            org_target = [opponents_unit.smooth_target(@target_index)] * num
            new_targets = make_new_targets(org_target,0)
          end
       else
          return (opponents_unit.alive_members + friends_unit.alive_members) if all_targets
          return opponents_unit.alive_members
      end
  end
  
  #--------------------------------------------------------------------------
  # ● All Targets
  #-------------------------------------------------------------------------- 
  def all_targets
      return true if @item.object.note =~ /<All Targets>/
      return false
  end
  
  #--------------------------------------------------------------------------
  # ● Targets for Allies
  #--------------------------------------------------------------------------
  def targets_for_friends
    if item.for_user?
       new_targets = make_new_targets([subject],1)      
    elsif item.for_dead_friend?
        if item.for_one?
           org_target = [friends_unit.smooth_dead_target(@target_index)]
           new_targets = make_new_targets(org_target,2)   
        else
           org_target = friends_unit.dead_members
           new_targets = make_new_targets(org_target,2)           
        end
    elsif item.for_friend?
         if item.for_one?
            org_target = [friends_unit.smooth_target(@target_index)]
            new_targets = make_new_targets(org_target,1)    
         else
            return (opponents_unit.alive_members + friends_unit.alive_members) if all_targets
            return friends_unit.alive_members
         end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Make New Targets
  #--------------------------------------------------------------------------
  def make_new_targets(target,type = 0)
      targets = [] ; @subject.primary_target = nil
      if all_targets
        members = (opponents_unit.alive_members + friends_unit.alive_members) if type <= 1
        members = friends_unit.dead_members if type == 2      
      else
        members = opponents_unit.alive_members if type == 0
        members = friends_unit.alive_members if type == 1
        members = friends_unit.dead_members if type == 2
      end
      for t in target
          for m in members
              targets.push(m) if t == m
              next if t == m
             (targets.push(m); m.sprite_size[2] = false) if scope_range?(t,m)             
          end
      end
      return targets
  end
  
  #--------------------------------------------------------------------------
  # ● Scope Range
  #--------------------------------------------------------------------------
  def scope_range?(user,target)
      @subject.primary_target = user
      t_r2 = [user.screen_x, user.screen_y] rescue nil
      t_r3 = [target.screen_x, target.screen_y] rescue nil
      return false if t_r2 == nil or t_r3 == nil
      s_r = [0,0,0,0] ; s_p = [0,0]
      s_r = [$1.to_i.abs,$2.to_i.abs,$3.to_i.abs,$4.to_i.abs] if @item.object.note =~ /<Scope Range = (\d+) - (\d+) - (\d+) - (\d+)>/
      return false if s_r == [0,0,0,0]
      if SCOPE_TYPE > 0
         s_p = [target.sprite_size[0] / 2, target.sprite_size[1]]
         s_p[0] = s_p[0] * SPRITE_SIZE_RANGE[0] / 100 
         s_p[1] = s_p[1] * SPRITE_SIZE_RANGE[1] / 100
      end
      return false if !t_r3[0].between?(t_r2[0] - (s_r[0] + s_p[0]), t_r2[0] + (s_r[1] + s_p[0]))
      return false if !t_r3[1].between?(t_r2[1] - s_r[2], t_r2[1] + s_r[3] + s_p[1])
      return true
  end  
  
end

#==============================================================================
# ■ Window_BattleActor
#==============================================================================
class Window_BattleActor < Window_BattleStatus
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_scope_ex_actor_update update
  def update
      mog_scope_ex_actor_update
      update_scex_target_actor if update_scex_target_actor?
  end
  
  #--------------------------------------------------------------------------
  # ● Update Scex Target Actor
  #--------------------------------------------------------------------------  
  def update_scex_target_actor?
      if $imported[:mog_atb_system]
         return false if $game_temp.battle_end
         return false if BattleManager.actor.nil?
      end   
      return self.active
  end
  
  #--------------------------------------------------------------------------
  # ● Update Scex Target Actor
  #--------------------------------------------------------------------------  
  def update_scex_target_actor
      $game_temp.scope_ex_data[0] = $game_party.members[self.index]
  end

end

#==============================================================================
# ■ Window_BattleEnemy
#==============================================================================
class Window_BattleEnemy < Window_Selectable

  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_scope_ex_enemy_update update
  def update
      mog_scope_ex_enemy_update
      update_scex_target_enemy if update_scex_target_enemy?
  end
  
  #--------------------------------------------------------------------------
  # ● Update Scex Target Enemy
  #--------------------------------------------------------------------------  
  def update_scex_target_enemy?
      if $imported[:mog_atb_system]
         return false if $game_temp.battle_end
         return false if BattleManager.actor.nil?
      end   
      return self.active
  end
  
  #--------------------------------------------------------------------------
  # ● Update Scex Target Enemy
  #--------------------------------------------------------------------------  
  def update_scex_target_enemy
      if $Battle_Last_Target == $Battle_Current_Target
        $game_temp.scope_ex_data[0] = $Battle_Last_Target
        return 
      end
      
      data = $game_troop.alive_members
      data.sort! { |a,b| a.screen_x <=> b.screen_x }
      
      for enemy_info in data
        if enemy_info == $Battle_Current_Target
         $game_temp.scope_ex_data[0] = enemy_info
         $Battle_Last_Target = $Battle_Current_Target
         info = sprintf("[System::Battle]:Current Target: %s (%s)",$Battle_Current_Target,$Battle_Current_Target.name)
         #puts "#{info}"
        end
      end
  end     
      
end

#==============================================================================
# ■ Sprite Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_scope_ex_sbattler_update update
  def update
      mog_scope_ex_sbattler_update
      $game_temp.scope_ex_data[1] = self if update_scope_ex_target?
  end
  
  #--------------------------------------------------------------------------
  # ● Update Scope EX Target
  #--------------------------------------------------------------------------  
  def update_scope_ex_target?
      return false if @battler.nil? or $game_temp.scope_ex_data[0].nil?
      return false if @battler != $game_temp.scope_ex_data[0]
      return false if $imported[:mog_sprite_actor] and !@battler.bact_sprite_visiblle
      #puts "#{@battler.name}/#{$game_temp.scope_ex_data[0].name}"
      #@battler = $Battle_Current_Target
      #$game_temp.scope_ex_data[0] = $Battle_Current_Target
      return true
  end
  
end

#==============================================================================
# ■ Window Selectable
#==============================================================================
class Window_Selectable < Window_Base  

  #--------------------------------------------------------------------------
  # ● Process OK
  #-------------------------------------------------------------------------
  alias mog_scope_ex_process_ok process_ok
  def process_ok
      mog_scope_ex_process_ok
      process_scope_ex if process_scope_ex?
  end
  
  #--------------------------------------------------------------------------
  # ● Process Scope EX?
  #-------------------------------------------------------------------------
  def process_scope_ex?
      return false if !SceneManager.scene_is?(Scene_Battle)
      return false if BattleManager.actor.nil?
      return false if !current_item_enabled?
      return true if self.is_a?(Window_BattleSkill)
      return true if self.is_a?(Window_BattleItem)
      return true if self.is_a?(Window_ActorCommand) and self.index == 0
      return false
  end

  #--------------------------------------------------------------------------
  # ● Process Scope EX
  #-------------------------------------------------------------------------
  def process_scope_ex   
      item = @data[index] rescue nil      
      item = $data_skills[BattleManager.actor.attack_skill_id] rescue nil if self.is_a?(Window_ActorCommand)
      $game_temp.scope_ex_data[4] = nil ; $game_temp.scope_ex_data[5] = false 
      return if item == nil
      $game_temp.scope_ex_data[4] = item ; $game_temp.scope_ex_data[5] = true      
      
      if item.note=~ /<Scope Range = (\d+) - (\d+) - (\d+) - (\d+)>/
         $game_temp.scope_ex_data[2] = [$1.to_i.abs,$2.to_i.abs,$3.to_i.abs,$4.to_i.abs]
         $game_temp.scope_ex_data[3] = [($1.to_i.abs + $2.to_i.abs).abs, ($3.to_i.abs + $4.to_i.abs)] 
      elsif MOG_SCOPE_EX::SPRITE_ALL_TARGETS_SCOPE and [2,6,8].include?(item.scope)
         $game_temp.scope_ex_data[2] = [Graphics.width,0,Graphics.height,0]
         $game_temp.scope_ex_data[3] = [Graphics.width * 2, Graphics.height * 2]
      else  
         $game_temp.scope_ex_data[2] = [] ; $game_temp.scope_ex_data[3] = []
         $game_temp.scope_ex_data[4] = nil ; $game_temp.scope_ex_data[5] = true
      end
  end  

end

#==============================================================================
# ■ Spriteset Battle
#==============================================================================
class Spriteset_Battle
  
  include MOG_SCOPE_EX
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  alias mog_scope_ex_sprite_initialize initialize
  def initialize
      mog_scope_ex_sprite_initialize
      create_sprite_scope if MOG_SCOPE_EX::SPRITE_SCOPE
  end

  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------  
  alias mog_scope_ex_sprite_dispose dispose
  def dispose
      mog_scope_ex_sprite_dispose
      dispose_sprite_scope
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------  
  alias mog_scope_ex_sprite_update update
  def update
      mog_scope_ex_sprite_update
      update_sprite_scope
  end
  
  #--------------------------------------------------------------------------
  # ● Create Sprite Scope
  #--------------------------------------------------------------------------  
  def create_sprite_scope
      @sprite_scope = Sprite.new ; @sprite_scope.bitmap = Bitmap.new(1,1)
      @sprite_scope.viewport = @viewport1 
      @sprite_scope.z = SPRITE_SCOPE_Z ; @scope_fade = 0
  end    
 
  #--------------------------------------------------------------------------
  # ● Set Scope Color
  #--------------------------------------------------------------------------  
  def set_scope_color(type)
      if type == 0
         return Color.new(ALLY_SCOPE_COLOR[0],ALLY_SCOPE_COLOR[1],ALLY_SCOPE_COLOR[2],SPRITE_SCOPE_OPACITY)
      else
         return Color.new(ENEMY_SCOPE_COLOR[0],ENEMY_SCOPE_COLOR[1],ENEMY_SCOPE_COLOR[2],SPRITE_SCOPE_OPACITY)
      end   
  end

  #--------------------------------------------------------------------------
  # ● Dispose Sprite Scope
  #--------------------------------------------------------------------------  
  def dispose_sprite_scope
      return if @sprite_scope.nil?
      @sprite_scope.bitmap.dispose ; @sprite_scope.dispose
      $game_temp.clear_scope_ex
  end  
  
  #--------------------------------------------------------------------------
  # ● Refresh Scope EX
  #--------------------------------------------------------------------------  
  def refresh_scope_ex
      sx = $game_temp.scope_ex_data[3][0]
      sy = $game_temp.scope_ex_data[3][1]
      @sprite_scope.zoom_x = sx
      @sprite_scope.zoom_y = sy
      if $game_temp.scope_ex_data[4].scope > 6
         @sprite_scope.bitmap.fill_rect(Rect.new(0,0,200,200),set_scope_color(0))
      else
         @sprite_scope.bitmap.fill_rect(Rect.new(0,0,200,200),set_scope_color(1))
      end  
      $game_temp.scope_ex_data[5] = false
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Scope EX
  #--------------------------------------------------------------------------  
  def refresh_scope_ex?
      return false if $game_temp.scope_ex_data[2].empty?
      return false if $game_temp.scope_ex_data[4].nil?
      return $game_temp.scope_ex_data[5]
  end
  
  #--------------------------------------------------------------------------
  # ● Update Sprite Scope
  #--------------------------------------------------------------------------  
  def update_sprite_scope
      return if @sprite_scope.nil?
      @sprite_scope.visible = sprite_scope_visible?
      return if !@sprite_scope.visible
      refresh_scope_ex if refresh_scope_ex?
      @sprite_scope.x = $game_temp.scope_ex_data[1].x - $game_temp.scope_ex_data[2][0]
      @sprite_scope.y = $game_temp.scope_ex_data[1].y - $game_temp.scope_ex_data[2][2]
      update_sprite_scope_fade if SPRITE_SCOPE_BLINK_EFFECT
      $game_temp.scope_ex_data[0] = nil ; $game_temp.scope_ex_data[1] = nil
  end
  
  #--------------------------------------------------------------------------
  # ● Update Sprite Scope
  #--------------------------------------------------------------------------  
  def update_sprite_scope_fade      
      @scope_fade += 1
      case @scope_fade
      when 0..30 ; @sprite_scope.opacity -= 5
      when 31..59 ; @sprite_scope.opacity += 5
      else ; @sprite_scope.opacity = 255 ; @scope_fade = 0      
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Sprite Scope Visible?
  #--------------------------------------------------------------------------  
  def sprite_scope_visible?
      return false if $game_temp.scope_ex_data[1].nil?
      return false if $game_temp.scope_ex_data[2].empty?
      return true
  end
  
end