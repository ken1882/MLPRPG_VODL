
#=======================================================================
# Game System
#=======================================================================

class Game_System
  attr_accessor :time_stop
  
  alias initialize_COMP initialize
  def initialize
    @time_stop = false
    initialize_COMP
  end
  
  def time_stopped?
    return @time_stop
  end
  
  def show_roll_result?
    return $game_switches[15]
  end
  
  def hide_all_windows?
    return $game_switches[16]
  end
  
  def make_rand
    Random.new_seed
    return Random.new
  end
  
  def create_clock
    scene = SceneManager.scene
    return if !scene.is_a?(Scene_Map)
    scene.create_all_windows
  end
  
end


#=======================================================================
# Game Actor
#=======================================================================
class Game_Actor < Game_Battler
 
  attr_accessor :p_str                # strength in DnD
  attr_accessor :p_dex                # dexterity in DnD
  attr_accessor :p_con                # constitution in DnD
  attr_accessor :p_int                # intelligence in DnD
  attr_accessor :p_wis                # wisdom in DnD
  attr_accessor :p_cha                # charisma in DnD
  
  attr_accessor :real_str                # strength in DnD
  attr_accessor :real_dex                # dexterity in DnD
  attr_accessor :real_con                # constitution in DnD
  attr_accessor :real_int                # intelligence in DnD
  attr_accessor :real_wis                # wisdom in DnD
  attr_accessor :real_cha                # charisma in DnD
  

  attr_accessor :str_ath

  attr_accessor :dex_acr
  attr_accessor :dex_sle
  attr_accessor :dex_ste
  
  attr_accessor :int_arc
  attr_accessor :int_his
  attr_accessor :int_inv
  attr_accessor :int_nat
  attr_accessor :int_rel

  attr_accessor :wis_ani
  attr_accessor :wis_ins
  attr_accessor :wis_med
  attr_accessor :wis_per
  attr_accessor :wis_sur
  
  attr_accessor :cha_dec
  attr_accessor :cha_int
  attr_accessor :cha_perfor
  attr_accessor :cha_persua

  attr_accessor :lskill               # dnd 5e life skills

  #--------------------------------------------------------------------------
  # ● alias method initialize
  #-------------------------------------------------------------------------- 
  alias initialize_dnd initialize
  def initialize(actor_id)
    initialize_dnd(actor_id)
    load_dnd_info
    
    actor.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::SUBS::SAVING_THROW_ADJUST
        @saving_throw_adjust[$1.to_i] = $2.to_i
        p sprintf("[D20 System]:%s's saving throw[%d] adjust:%d",actor.name,$1.to_i,@saving_throw_adjust[$1.to_i])
      end
    } # self.note.split
  end
  
  #--------------------------------------------------------------------------
  # ● Load D&D parameters
  #-------------------------------------------------------------------------- 
  def load_dnd_info
    @p_str = self.actor.p_str.nil? ? 0 : self.actor.p_str
    @p_dex = self.actor.p_dex.nil? ? 0 : self.actor.p_dex
    @p_con = self.actor.p_con.nil? ? 0 : self.actor.p_con
    @p_int = self.actor.p_int.nil? ? 0 : self.actor.p_int
    @p_wis = self.actor.p_wis.nil? ? 0 : self.actor.p_wis
    @p_cha = self.actor.p_cha.nil? ? 0 : self.actor.p_cha
    
    @armor_class = self.actor.armor_class.nil? ? 10 : self.actor.armor_class
    @thac0 = self.actor.thac0.nil? ? 0 : self.actor.thac0
    
    @real_str = @p_str
    @real_dex = @p_dex
    @real_con = @p_con
    @real_int = @p_int
    @real_wis = @p_wis
    @real_cha = @p_cha
    
    
    @lskill = []
    
    @str_ath = @p_str - 10
    
    @dex_acr = @p_dex - 10
    @dex_sle = @p_dex - 10
    @dex_ste = @p_dex - 10
      
    @int_arc = @p_int - 10
    @int_his = @p_int - 10
    @int_inv = @p_int - 10
    @int_nat = @p_int - 10
    @int_rel = @p_int - 10
      
    @wis_ani = @p_wis - 10
    @wis_ins = @p_wis - 10
    @wis_med = @p_wis - 10
    @wis_per = @p_wis - 10
    @wis_sur = @p_wis - 10
      
    @cha_dec = @p_cha - 10
    @cha_int = @p_cha - 10
    @cha_perfor = @p_cha - 10
    @cha_persua = @p_cha - 10
    
  end
  #-----------------------------------------------------------
  # Calc life skill bonus
  #-----------------------------------------------------------
  def calc_score_ability_skill
    
    self.str_ath = (@p_str - 10) / 2
    
    self.dex_acr = (@p_dex - 10) / 2 
    self.dex_sle = (@p_dex - 10) / 2
    self.dex_ste = (@p_dex - 10) / 2
      
    self.int_arc = (@p_int - 10) / 2
    self.int_his = (@p_int - 10) / 2
    self.int_inv = (@p_int - 10) / 2
    self.int_nat = (@p_int - 10) / 2
    self.int_rel = (@p_int - 10) / 2
      
    self.wis_ani = (@p_wis - 10) / 2
    self.wis_ins = (@p_wis - 10) / 2
    self.wis_med = (@p_wis - 10) / 2
    self.wis_per = (@p_wis - 10) / 2
    self.wis_sur = (@p_wis - 10) / 2
      
    self.cha_dec = (@p_cha - 10) / 2
    self.cha_int = (@p_cha - 10) / 2
    self.cha_perfor = (@p_cha - 10) / 2
    self.cha_persua = (@p_cha - 10) / 2
    
  end
  #-----------------------------------------------------------
  # Link life skill function to array
  #-----------------------------------------------------------
  def str_ath;    @lskill[0]; end
  
  def dex_acr;    @lskill[1]; end
  def dex_sle;    @lskill[2]; end
  def dex_ste;    @lskill[3]; end
    
  def int_arc;    @lskill[4]; end
  def int_his;    @lskill[5]; end
  def int_inv;    @lskill[6]; end
  def int_nat;    @lskill[7]; end
  def int_rel;    @lskill[8]; end
      
  def wis_ani;    @lskill[9]; end
  def wis_ins;    @lskill[10]; end
  def wis_med;    @lskill[11]; end
  def wis_per;    @lskill[12]; end
  def wis_sur;    @lskill[13]; end
      
  def cha_dec;    @lskill[14]; end
  def cha_int;    @lskill[15]; end
  def cha_perfor; @lskill[16]; end
	def cha_persua; @lskill[17]; end
  #-----------------------------------------------------------
  # Link life skill assign function to array assignment
  #-----------------------------------------------------------
    
  def str_ath=(value);  @lskill[0]= value; end
  
  def dex_acr=(value);  @lskill[1]= value; end
  def dex_sle=(value);  @lskill[2]= value; end
  def dex_ste=(value);  @lskill[3]= value; end
    
  def int_arc=(value);  @lskill[4]= value; end
  def int_his=(value);  @lskill[5]= value; end
  def int_inv=(value);  @lskill[6]= value; end
  def int_nat=(value);  @lskill[7]= value; end
  def int_rel=(value);  @lskill[8]= value; end
      
  def wis_ani=(value);  @lskill[9]= value; end
  def wis_ins=(value);  @lskill[10]= value; end
  def wis_med=(value);  @lskill[11]= value; end
  def wis_per=(value);  @lskill[12]= value; end
  def wis_sur=(value);  @lskill[13]= value; end
      
  def cha_dec=(value);  @lskill[14]= value; end
  def cha_int=(value);  @lskill[15]= value; end
  def cha_perfor=(value); @lskill[16]= value; end
	def cha_persua=(value); @lskill[17]= value; end
  #-----------
end

#=======================================================================
# *)Game BattlerBase
#=======================================================================

class Game_BattlerBase
  
  attr_accessor :dmg_popup            #force damage popup
  attr_accessor :popup_ary            #list add to damage popup
  attr_accessor :block_rate           #block damage's rate
  attr_accessor :combat_flag          #flag for combat
  attr_accessor :time_stop            #time stop flag
  attr_accessor :saving_throw_adjust  #saving throw adjusts
  attr_accessor :saving_rolled        #rolled saving throw
  
  attr_accessor :p_penetration              # physical armor penestration
  attr_accessor :m_penetration              # magical armor penestration
  attr_accessor :armor_class              # Armor Class
  attr_accessor :thac0                    # To Hit Armor Class Zero
  
  attr_accessor :carapace_immune_times    # skill's ability
  attr_accessor :action_moved             # stack fatigue
  attr_accessor :unlimited_chain_skill    # keep chaining skill until out of EP
  attr_accessor :auto_chain_skill         # auto press random chain skill button
  attr_accessor :skill_performed          # calculate skill used in a turn
  attr_accessor :discrete                 # ATB speed discrete
  attr_accessor :saving_throw_rolled      # rolled saving throw
  attr_accessor :atb_dropped_times        # Knock Down/Back times
  
  
  attr_accessor :crafting_level
  attr_accessor :begin_atb             # begin AT value
  
  attr_accessor :path_finding         # check A* path finding is in process
  attr_accessor :priority             # priority of targeted
  attr_accessor :damage_taken
  attr_accessor :anti_magic
  attr_accessor :force_perform_skills 
  attr_accessor :poison_damage
  attr_accessor :dead_drained
  
  alias init_custom initialize
  def initialize
    
    @dmg_popup = false
    @popup_ary = []
    @combat_flag = []
    @block_rate = 0
    @time_stop = false
    @saving_throw_adjust = [0,0,0,0,0,0,0,0]
    @saving_rolled = []
    @atb_dropped_times = [0,0]
    
    
    @p_penetration = 0
    @m_penetration = 0
    @armor_class   = 10
    @thac0         = 0
    
    @anti_magic = false
    @path_finding = false
    @priority = 1
    
    @carapace_immune_times = 0
    @action_moved = 0
    @unlimited_chain_skill = false
    @auto_chain_skill = false
    @skill_performed = []
    
    @discrete = 1
    @saving_throw_rolled = []
    @begin_atb = 0
    
    @crafting_level = 1
    @damage_taken = false
    @force_perform_skills = []
    @poison_damage = []
    @dead_drained = false
    
    init_custom
  end
  #--------------------------------------------------------------------------
  # ● Purify All
  #-------------------------------------------------------------------------- 
  def purify_all
    @states = []
    @state_turns = {}
    @state_steps = {}
    @hp = mhp
    @mp = mmp
  end
  
  #--------------------------------------------------------------------------
  # ● Save Dead
  #-------------------------------------------------------------------------- 
  def save_dead
    if state?(death_state_id)
      @hp = 1
      remove_state(death_state_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● Recouunt ATB Drop Times
  #-------------------------------------------------------------------------
  def reset_atb_drops
    atb_dropped_times = [0,0]
  end
  
  #--------------------------------------------------------------------------
  # ● Knock Down / back
  #-------------------------------------------------------------------------- 
  def knock_down
    return if atb_dropped_times[0] > 1
    
    immune_states = []
    for state in immune_states
      return if self.state?(state)
    end
    atb_dropped_times[0] += 1
    
    casting_interrupt
    self.atb = 0
    self.damage.push(["Knock_Down","Knock_Down"])
  end
  
  def knock_back
    return if atb_dropped_times[1] > 3
    
    immune_states = [245]
    for state in immune_states
      return if self.state?(state)
    end
    
    atb_dropped_times[1] += 1
    casting_interrupt
    self.atb *= 3 /5
    self.damage.push(["Knock_Back","Knock_Back"])
  end
  
  #--------------------------------------------------------------------------
  # ● Posioned?
  #--------------------------------------------------------------------------   
  def poisoned?
    
    for state in self.states
      return true if state.is_poison?
    end
    
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Debuffed?
  #--------------------------------------------------------------------------   
  def debuffed?
    for state in self.states
      return true if state.is_debuff?
    end
    
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● Dispel Magic
  #--------------------------------------------------------------------------   
  def dispel_magic
    animated = false
    for state in self.states
      next if state.nil?
      animated = true if state.id == 271
      
      remove_state(state.id) if state.is_magic?
    end
    die if animated
  end
  #--------------------------------------------------------------------------
  # ● Anti Magic?
  #--------------------------------------------------------------------------   
  def anti_magic?
    
    result = false
    source = 0
    
     if @anti_magic
       result = true; source = 1
     end
     
    if self.mrf > 0.5
      result = true; source = 2 
    end
    
    anti_magic_state = [266,267]
    
    for id in anti_magic_state
      if self.state?(id)
        source = id
        result = true
        break
      end
  
    end
    
    #puts "#{self.name} anti magic!(#{source})" if result == true
    return result
  end
  #--------------------------------------------------------------------------
  # ● Bleed
  #--------------------------------------------------------------------------   
  def bleed
    self.add_state(226)
  end
  
  #--------------------------------------------------------------------------
  # ● clear combat flags
  #--------------------------------------------------------------------------   
  def clear_combat_flag
    @combat_flag = []
  end
  
  #--------------------------------------------------------------------------
  # * Alias methid: state resist?
  #--------------------------------------------------------------------------
  alias state_resist_mag state_resist?
  def state_resist?(state_id)
    
    state = $data_states[state_id]
                    # anti magic ward
    return true if self.state?(267) && state.is_magic?
    state_resist_mag(state_id)
  end
  #--------------------------------------------------------------------------
  # ● real_def
  #--------------------------------------------------------------------------   
  def real_def(attacker)
    return attacker.nil? ? self.mdf : [0,self.mdf - attacker.p_penetration].max
  end
  
  #--------------------------------------------------------------------------
  # ● real_mdf
  #--------------------------------------------------------------------------   
  def real_mdf(attacker)
    return attacker.nil? ? self.mdf : [0,self.mdf - attacker.m_penetration].max
  end
  
  
  #--------------------------------------------------------------------------
  # ● Easier method for check skilll learned
  #--------------------------------------------------------------------------   
  def skill_learned?(id)
    if self.actor?
      return self.skills.include?($data_skills[id])
    else
      return self.skills.include?(id)
    end
    
  end
  #--------------------------------------------------------------------------
  # ● Determind DC
  #-------------------------------------------------------------------------- 
  def difficulty_class(type = "normal",bonus = 0,show_msg = true)
     
     if type == "normal"
      
      lv = self.level.to_i
      lv = 0 if lv.nil?
      v2 = self.luk / 80 + self.agi / 100 + (self.atk + self.def + self.mat + self.mdf) / 500
      
      v = [lv / 20 , v2].max
      
      if lv >= 100
        v += lv - 99
      end
      
    elsif type == "str"
      v1 = @real_str ? (@real_str - 9) : 0
      v2 = self.atk / 100
      v = [v1,v2].max
      
    elsif type == "dex"
      v1 = @real_dex ? (@real_dex - 9)  : 0
      v2 = self.agi / 40
      v = [v1,v2].max
      
    elsif type == "con"
      v1 = @real_con ? (@real_con - 9)  : 0
      v2 = self.def / 100
      v = [v1,v2].max
      
    elsif type == "int"
      v1 = @real_int ? (@real_int - 9)  : 0
      v2 = self.mat / 100
      #puts "Spell difficulty class base: #{v1},#{v2}"
      v = [v1,v2].max
      
    elsif type == "wis"
      v1 = @real_wis ? (@real_wis - 9)  : 0
      v2 = self.mdf / 100
      v = [v1,v2].max
      
    elsif type == "cha"
      v = @real_cha ? (@real_cha - 9 ) *2 : 0
    end
    
    v += bonus
    v += 10
    
    if ($game_system.show_roll_result? || $force_show_roll_result) && show_msg 
      $game_message.battle_log_add("-------- DC --------")
      $game_message.battle_log_add(sprintf("%s's DC(%s) = %d",self.name,type,v))
      p sprintf("%s's DC(%s) = %d",self.name,type,v)
    end
    
    return v
  end
  
  def get_roll_type_id(type)
    type = type.upcase
    
    if type == "STR"
      return 1
    elsif type == "DEX"
      return 2
    elsif type == "OCN"
      return 3
    elsif type == "INT"
      return 4
    elsif type == "WIS"
      return 5
    elsif type == "CHA"
      return 6
    else
      return 0
    end  
  end
  
  #--------------------------------------------------------------------------
  # ● d20 Saving Throw
  #--------------------------------------------------------------------------   
  def saving_throw(type = "normal",bonus = 0,show_msg = true)
    
    #===============================================
    # Calc bonus
    #===============================================
    if type == "normal"
      
      lv = self.level.to_i
      lv = 0 if lv.nil?
      v2 = self.luk / 80 + self.agi / 100 + (self.atk + self.def + self.mat + self.mdf) / 500
      
      v = [lv / 20 , v2].max
      
      if lv >= 100
        v += lv - 99
      end
      
      v += self.saving_throw_adjust[0]
      
      if self.actor?
        for equip in equips
          next if equip.nil?
          v += equip.saving_throw_adjust[0] 
        end
      end
      
    elsif type == "str"
      v1 = @real_str ? (@real_str - 9)  : 0
      v2 = self.atk / 100
      v = [v1,v2].max
      v += self.saving_throw_adjust[1]
      
      if self.actor?
        for equip in equips
          next if equip.nil?
          v += equip.saving_throw_adjust[1] 
        end
      end
      
    elsif type == "dex"
      v1 = @real_dex ? (@real_dex - 9) : 0
      v2 = self.agi / 40
      v = [v1,v2].max
      v += self.saving_throw_adjust[2] 
      
      if self.actor?
        for equip in equips
          next if equip.nil?
          v += equip.saving_throw_adjust[2]
        end
      end
      
    elsif type == "con"
      v1 = @real_con ? (@real_con - 9)  : 0
      v2 = self.def / 100
      v = [v1,v2].max
      
      v += self.saving_throw_adjust[3]
      
      if self.actor?
        for equip in equips
          next if equip.nil?
          v += equip.saving_throw_adjust[3]
        end
      end
      
    elsif type == "int"
      v1 = @real_int ? (@real_int - 9) : 0
      v2 = self.mat / 100
      v = [v1,v2].max
      
      v += self.saving_throw_adjust[4]
      
      if self.actor?
        for equip in equips
          next if equip.nil?
          v += equip.saving_throw_adjust[4]
        end
      end
      
    elsif type == "wis"
      v1 = @real_wis ? (@real_wis - 9)  : 0
      v2 = self.mdf / 100
      v = [v1,v2].max
      
      v += self.saving_throw_adjust[5]
      
      if self.actor?
        for equip in equips
          next if equip.nil?
          v += equip.saving_throw_adjust[5]
        end
      end
      
    elsif type == "cha"
      v1 = @real_cha ? (@real_cha - 9 ) : 0
      v2 = self.luk / 80
      v = [v1,v2].max
      
      v += self.saving_throw_adjust[6]
      
      if self.actor?
        for equip in equips
          next if equip.nil?
          v += equip.saving_throw_adjust[6]
        end
      end
      
    end
    #===============================================
    # Calc State and Skill Bonus
    #===============================================
    for skill in $data_notetagged_items
      next if skill.nil? || !skill.is_a?(RPG::Skill)
      next unless self.skills.include?(skill)
      
      type_id = get_roll_type_id(type)
      v += skill.saving_throw_adjust[type_id]
    end
    
    for state in $data_notetagged_items
      next if state.nil? || !state.is_a?(RPG::State)
      next unless self.state?(state.id)
      
      type_id = get_roll_type_id(type)
      #puts "#{state.name}:"
      #puts "Saving Throw Type: #{type}(#{type_id}) > #{state.saving_throw_adjust}"
      #puts "#{state.saving_throw_adjust[type_id]}"
      #puts "-------------------------------------------"
      v += state.saving_throw_adjust[type_id]
    end
    #===============================================
    # Calc Result
    #===============================================
    v += bonus
    v += rand(20) + 1
    #===============================================
    # Output result to battle log
    #===============================================
    if ($game_system.show_roll_result? || $force_show_roll_result) && show_msg
      $game_message.battle_log_add("--------- Roll Dice ---------")
      $game_message.battle_log_add(sprintf("Roll: %s adjusts + d20(%s) = %d",self.name,type,v))
      p sprintf("%s adjusts + d20(%s) = %d",self.name,type,v)
    end
    
    return v
  end
  #--------------------------------------------------------------------------
  # ● Time stopped?
  #--------------------------------------------------------------------------   
  def time_stopped?
    @time_stop
  end
  #--------------------------------------------------------------------------
  # ● Apply Random State
  #--------------------------------------------------------------------------   
  def apply_random_state(user = nil)
    
    
    unless user.nil? && user.level.nil?
      lv = user.level.to_i
      modifier = (self.saving_throw - user.difficulty_class * 0.6) * 0.01
      
      result_state_id = [3] # Blind
      success_rate = [0.5]
      
      result_state_id.push(2) if lv >= 10 # Poison
      success_rate.push(0.5) if lv >= 10
      
      result_state_id.push(8) if lv >= 20 # Stun
      success_rate.push(0.4) if lv >= 20
      
      result_state_id.push(7) if lv >= 30 # Paralyis
      success_rate.push(0.6) if lv >= 30
      
      result_state_id.push(26) if lv >= 40 # Derp
      success_rate.push(0.5) if lv >= 40
      
      result_state_id.push(60) if lv >= 50 # Confused
      success_rate.push(0.5) if lv >= 50
      
      result_state_id.push(53) if lv >= 65 # Frozen
      success_rate.push(0.5) if lv >= 65
      
      result_state_id.push(1) if lv >= 80 # K.O.
      success_rate.push(0.45) if lv >= 80
      
      result_state_id.push(99) if lv >= 90 # Petrification
      success_rate.push(0.4) if lv >= 90
      #----------------------------------------------------
      for i in 0...result_state_id.size
        if rand() - modifier < success_rate[i]
          self.add_state(result_state_id[i])
        end
      end
      
    else
      effects = [
        "self.knock_down",
        "self.knock_back",
        "self.add_state(1)",
        "self.add_state(2)",
        "self.add_state(3)",
        "self.add_state(5)",
        "self.add_state(6)",
        "self.add_state(7)",
        "self.add_state(8)",
        "self.add_state(26)",
        "self.add_state(60)",
        "self.add_state(53)",
        "self.add_state(99)",
        "self.add_state(226)",
      ]
      range = effects.size - 1
      eval(rand(range))
    end
    
  end
  
  
end #Game Battler
#===========================================================================
# ● Game Message
#===========================================================================
class Game_Message
  #--------------------------------------------------------------------------
  # ● Add text to battle log
  #--------------------------------------------------------------------------
  def battle_log_add(text)
    text.to_s
    scene = SceneManager.scene
    return if !scene.is_a?(Scene_Battle)
    scene.log_window.add_text(text)
  end
  
  def battle_log_clear
    scene = SceneManager.scene
    return if !scene.is_a?(Scene_Battle)
    scene.log_window.clear_texts
  end
    
end


class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● Check if all petrified
  #--------------------------------------------------------------------------   
  def all_petrified?

    for battler in $game_party.alive_members
      return false unless battler.state?(99) || battler.state?(271)
    end
    
    return true
  end
end

class Game_Troop < Game_Unit
  
  attr_accessor :available_items
  attr_accessor :item_require
  attr_accessor :item_target
  #--------------------------------------------------------------------------   
  #   Initialize
  #--------------------------------------------------------------------------   
  alias item_init initialize
  def initialize
    
    @available_items = {0 => 1}
    @item_require = 0
    @item_target = nil
    
    item_init
  end
  
  #--------------------------------------------------------------------------
  # ● Check if all petrified
  #--------------------------------------------------------------------------   
  def all_petrified?

    for battler in $game_troop.alive_members
      return false unless battler.state?(99) || battler.state?(271)
    end
    
    return true
  end
  #--------------------------------------------------------------------------
  # ● Apply combat Difficulty
  #--------------------------------------------------------------------------   
  alias on_battle_start_diff on_battle_start
  def on_battle_start
    on_battle_start_diff
    
    case $game_variables[33]
    when 1
      diff_id = 254
    when 3
      diff_id = 255
    when 4
      diff_id = 256
    else
      diff_id = 0
    end
    
    combat_DC_info = sprintf("Combat Difficulty: %s",diff_id == 0 ? "Normal" : $data_states[diff_id].name)
    
    $game_message.battle_log_add(combat_DC_info)
    $game_message.battle_log_add("------------------------------------------")
    puts "--------------------------------------------------"
    puts "Combat Difficulty: #{$data_states[diff_id].name}" if diff_id != 0
    puts "--------------------------------------------------"
    for enemy in members
      enemy.add_state(diff_id) if diff_id != 0
      enemy.hp = enemy.mhp
      enemy.check_boss_hp_after
    end
  end
  #--------------------------------------------------------------------------
  # ● Reduce item in enemy's saddlebag 
  #-------------------------------------------------------------------------- 
  def reduce_item(item_id)
    return if item_id == 0
    @available_items[item_id] -= 1
    @available_items.delete(item_id) if @available_items[item_id] == 0
  end
end

class Game_Interpreter
  
  def get_self_variables
    return $game_map.events[@event_id].self_var
  end
    
  def assign_self_variables(var)
    $game_map.events[@event_id].self_var = var
  end
  
end



#==============================================================================
# ** Scene_Shop
#------------------------------------------------------------------------------
#  This class performs shop screen processing.
#==============================================================================
class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------
  #   Overwrite method: selling_price
  #--------------------------------------------------------
  def selling_price
    @item.note =~ /<cheap_sell>/ ? @item.price / 20 : @item.price / 2
  end
end


#==============================================================================
# ** Window_ShopSell
#------------------------------------------------------------------------------
#  This window displays a list of items in possession for selling on the shop
# screen.
#==============================================================================

class Window_ShopSell < Window_ItemList
  #--------------------------------------------------------
  #   Overwrite method: enable?
  #--------------------------------------------------------
  def enable?(item)
    return if item.nil?
    unsellable = item.note =~ /<unsellable>/ ? true : false
    item && item.price > 0 && !unsellable
  end
end

#==============================================================================
#
# ** Game_Enemy
#
#==============================================================================

class Game_Enemy < Game_Battler
  attr_accessor :p_str                # strength in DnD
  attr_accessor :p_dex                # dexterity in DnD
  attr_accessor :p_con                # constitution in DnD
  attr_accessor :p_int                # intelligence in DnD
  attr_accessor :p_wis                # wisdom in DnD
  attr_accessor :p_cha                # charisma in DnD
  
  
  attr_accessor :real_str                # strength in DnD
  attr_accessor :real_dex                # dexterity in DnD
  attr_accessor :real_con                # constitution in DnD
  attr_accessor :real_int                # intelligence in DnD
  attr_accessor :real_wis                # wisdom in DnD
  attr_accessor :real_cha                # charisma in DnD
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  alias dnd_initialize initialize
  def initialize(index, enemy_id)
    
    dnd_initialize(index, enemy_id)
    load_dnd_info
    
    enemy.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::SUBS::SAVING_THROW_ADJUST
        @saving_throw_adjust[$1.to_i] = $2.to_i
        p sprintf("[D20 System]:%s's saving throw[%d] adjust:%d",enemy.name,$1.to_i,@saving_throw_adjust[$1.to_i])
      end
    } # self.note.split
    #-------------
    get_learned_skills
  end  
  
  #--------------------------------------------------------------------------
  # ● Load D&D parameters
  # tag:thac0
  #-------------------------------------------------------------------------- 
  def load_dnd_info
    @p_str = self.enemy.p_str.nil? ? 14 : self.enemy.p_str
    @p_dex = self.enemy.p_dex.nil? ? 14 : self.enemy.p_dex
    @p_con = self.enemy.p_con.nil? ? 14 : self.enemy.p_con
    @p_int = self.enemy.p_int.nil? ? 14 : self.enemy.p_int
    @p_wis = self.enemy.p_wis.nil? ? 14 : self.enemy.p_wis
    @p_cha = self.enemy.p_cha.nil? ? 14 : self.enemy.p_cha
    
    @armor_class = self.enemy.armor_class.nil? ? (10 + self.def/50) : self.enemy.armor_class
    @thac0 = self.enemy.thac0.nil? ? (self.atk/40) : self.enemy.thac0
    
    @real_str = @p_str
    @real_dex = @p_dex
    @real_con = @p_con
    @real_int = @p_int
    @real_wis = @p_wis
    @real_cha = @p_cha
  end
    
  #-----------------------------------------------------------
  # *) is_boss?
  #-----------------------------------------------------------
  def is_boss?
    return @class == "Boss"
  end
  #-----------------------------------------------------------
  # *) is_elite?
  #-----------------------------------------------------------
  def is_elite?
    return @class == "Elite"
  end
  #-----------------------------------------------------------
  # *) is_minon?
  #-----------------------------------------------------------
  def is_minon?
    return @class == "Minon"
  end
  
  
  #--------------------------------------------------------------------------
  # * Create Battle Action
  #--------------------------------------------------------------------------
  def get_learned_skills
    
    actions = Array.new(make_action_times) { Game_Action.new(self) }
    
    for action in enemy.actions
      @skills.push(action.skill_id)
    end
    
  end
  #=========================================================================
  #
  # *) Enemy AI action determind
  #
  #=========================================================================
  #--------------------------------------------------------------------------
  # * Using magic attack?
  #--------------------------------------------------------------------------
  def using_magic_attack?
    
    limit = $game_party.alive_members.size / 2
    ignore = 0
    for battler in $game_party.alive_members
      ignore += 1 if battler.anti_magic?
    end
    
    return ignore < limit
  end
  
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Map
  def over_edge?(x,y)
    x < 0 || y < 0 || x >= width || y >= height
  end
  
end

#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================

class Game_CharacterBase
  
  attr_accessor :process_moving
  
  alias initialize_dash initialize
  def initialize
    @process_moving = false
    initialize_dash
  end
  
end