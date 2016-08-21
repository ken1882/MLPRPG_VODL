#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic States Package - Punishment v1.01
# -- Last Updated: 2011.12.15
# -- Level: Lunatic
# -- Requires: YEA - Lunatic States v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LSP-Punishment"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.31 - Bug Fixed: Error with battle popups not showing.
# 2011.12.15 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic States Package Effects with punishment themed
# effects. Included in it are effects that make battlers undead (take damage
# whenever they are healed), make battlers whenever they execute physical or
# magical attacks, make battlers take damage based on the original caster of
# the state's stats, and an effect that heals the original caster of the state
# whenever the battler takes HP or MP damage.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic States. Then, proceed to use the
# proper effects notetags to apply the proper LSP Punishment item desired.
# Look within the script for more instructions on how to use each effect.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires YEA - Lunatic States v1.00+ to work. It must be placed
# under YEA - Lunatic States v1.00+ in the script listing.
# 
#==============================================================================

if $imported["YEA-LunaticStates"]
class Game_BattlerBase
  

  
  
  #--------------------------------------------------------------------------
  # ● Lunatic States Package Effects - Punishment
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of punishment. These effects
  # punish users for doing various aspects that may benefit them by harming
  # them in different ways.
  #--------------------------------------------------------------------------
  alias lunatic_state_extension_lsp1 lunatic_state_extension
  def lunatic_state_extension(effect, state, user, state_origin, log_window, attacker = nil)
    return if $current_user.nil?
    
    case effect.upcase
    #----------------------------------------------------------------------
    # Punish Effect No.1: Undead HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any HP healing done to become
    # reversed and deal HP damage to the healed target.
    # 
    # Recommended notetag:
    #   <react effect: undead hp>
    #----------------------------------------------------------------------
    when /UNDEAD HP/i
      return unless @result.hp_damage < 0
      @result.hp_damage *= -1
      @result.hp_drain *= -1
      
    #----------------------------------------------------------------------
    # Punish Effect No.2: Undead MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any MP healing done to become
    # reversed and deal MP damage to the healed target.
    # 
    # Recommended notetag:
    #   <react effect: undead mp>
    #----------------------------------------------------------------------
    when /UNDEAD MP/i
      return unless @result.mp_damage < 0
      @result.mp_damage *= -1
      @result.mp_drain *= -1
      
    #----------------------------------------------------------------------
    # Punish Effect No.3: Physical Backfire
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with while effect. Whenever the affected battler uses a
    # physical attack, that battler will take HP damage equal to its own
    # stats after finishing the current action. Battler cannot die from
    # this effect.
    # 
    # Recommended notetag:
    #   <while effect: physical backfire stat x%>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the stat multiplier to affect damage dealt.
    #----------------------------------------------------------------------
    when /PHYSICAL BACKFIRE[ ](.*)[ ](\d+)([%％])/i
      return if user.current_action.nil?
      return unless user.current_action.item.physical?
      case $1.upcase
      when "MAXHP"; dmg = user.mhp
      when "MAXMP"; dmg = user.mmp
      when "ATK";   dmg = user.atk
      when "DEF";   dmg = user.def
      when "MAT";   dmg = user.mat
      when "MDF";   dmg = user.mdf
      when "AGI";   dmg = user.agi
      when "LUK";   dmg = user.luk
      else; return
      end
      dmg = (dmg * $2.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], dmg.group)
        user.create_popup(text, "HP_DMG")
      end
      user.perform_damage_effect
      user.hp = [user.hp - dmg, 1].max
      
    #----------------------------------------------------------------------
    # Punish Effect No.4: Magical Backfire
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with while effect. Whenever the affected battler uses a
    # magical attack, that battler will take HP damage equal to its own
    # stats after finishing the current action. Battler cannot die from
    # this effect.
    # 
    # Recommended notetag:
    #   <while effect: magical backfire stat x%>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the stat multiplier to affect damage dealt.
    #----------------------------------------------------------------------
    when /MAGICAL BACKFIRE[ ](.*)[ ](\d+)([%％])/i
      return if user.current_action.nil?
      return unless user.current_action.item.magical?
      case $1.upcase
      when "MAXHP"; dmg = user.mhp
      when "MAXMP"; dmg = user.mmp
      when "ATK";   dmg = user.atk
      when "DEF";   dmg = user.def
      when "MAT";   dmg = user.mat
      when "MDF";   dmg = user.mdf
      when "AGI";   dmg = user.agi
      when "LUK";   dmg = user.luk
      else; return
      end
      dmg = (dmg * $2.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], dmg.group)
        user.create_popup(text, "HP_DMG")
      end
      user.perform_damage_effect
      user.hp = [user.hp - dmg, 1].max
      
    #----------------------------------------------------------------------
    # Punish Effect No.5: Stat Slip Damage
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with close effect. At the end of the turn, the affected
    # battler will take HP slip damage based on the stat of the of one who
    # casted the status effect onto the battler. Battler cannot die from
    # this effect.
    # 
    # Recommended notetag:
    #   <close effect: stat slip damage x%>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the stat multiplier to affect damage dealt.
    #----------------------------------------------------------------------
    when /(.*)[ ]SLIP DAMAGE[ ](\d+)([%％])/i
      case $1.upcase
      when "MAXHP"; dmg = state_origin.mhp
      when "MAXMP"; dmg = state_origin.mmp
      when "ATK";   dmg = state_origin.atk
      when "DEF";   dmg = state_origin.def
      when "MAT";   dmg = state_origin.mat
      when "MDF";   dmg = state_origin.mdf
      when "AGI";   dmg = state_origin.agi
      when "LUK";   dmg = state_origin.luk
      else; return
      end
      dmg = (dmg * $2.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], dmg.group)
        user.create_popup(text, "HP_DMG")
      end
      user.perform_damage_effect
      user.hp = [user.hp - dmg, 1].max
      
    #----------------------------------------------------------------------
    # Punish Effect No.6: Stat Slip Heal
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with close effect. At the end of the turn, the affected
    # battler will heal HP  based on the stat of the of one who casted the
    # status effect onto the battler.
    # 
    # Recommended notetag:
    #   <close effect: stat slip heal x%>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the stat multiplier to affect damage dealt.
    #----------------------------------------------------------------------
    when /(.*)[ ]SLIP HEAL[ ](\d+)([%％])/i
      case $1.upcase
      when "MAXHP"; dmg = state_origin.mhp
      when "MAXMP"; dmg = state_origin.mmp
      when "ATK";   dmg = state_origin.atk
      when "DEF";   dmg = state_origin.def
      when "MAT";   dmg = state_origin.mat
      when "MDF";   dmg = state_origin.mdf
      when "AGI";   dmg = state_origin.agi
      when "LUK";   dmg = state_origin.luk
      else; return
      end
      dmg = (dmg * $2.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_heal], dmg.group)
        user.create_popup(text, "HP_HEAL")
      end
      user.perform_damage_effect
      user.hp += dmg
      
    #----------------------------------------------------------------------
    # Punish Effect No.7: Drain HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with shock effect. Whenever user takes HP damage, the
    # original caster of the state will heal HP based on HP damage dealt.
    # 
    # Recommended notetag:
    #   <shock effect: drain hp x%>
    #----------------------------------------------------------------------
    when /DRAIN HP[ ](\d+)([%％])/i
      return unless @result.hp_damage > 0
      dmg = (@result.hp_damage * $1.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        Sound.play_recovery
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_heal], dmg.group)
        user.create_popup(text, "HP_HEAL")
      end
      state_origin.hp += dmg
      
    #----------------------------------------------------------------------
    # Punish Effect No.8: Drain MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with shock effect. Whenever user takes MP damage, the
    # original caster of the state will heal MP based on MP damage dealt.
    # 
    # Recommended notetag:
    #   <shock effect: drain mp x%>
    #----------------------------------------------------------------------
    when /DRAIN MP[ ](\d+)([%％])/i
      return unless @result.mp_damage > 0
      dmg = (@result.mp_damage * $1.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        Sound.play_recovery
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:mp_heal], dmg.group)
        user.create_popup(text, "MP_HEAL")
      end
      state_origin.mp += dmg
    #----------------------------------------------------------------------
    # tag: state
    #----------------------------------------------------------------------
    
    #======================================================================
    # ● Carapace
    #======================================================================
    when /SET_UP_CARAPACE/i
      @carapace_immune_times = 3
    when /REMOVE_CARAPACE/i
      @carapace_immune_times = 0
    when /CARAPACE/i
        return unless @result.hp_damage > 1
        
        if @carapace_immune_times > 0
          @carapace_immune_times -= 1
          @damage.push(["Immune","Immune"])
          @result.hp_damage = 0
          @result.hp_drain = 0
          return
        end
        
        proof = saving_throw("con") * 0.01
        @result.hp_damage = (@result.hp_damage * (1 - proof)).to_i
        @result.hp_drain = (@result.hp_drain * (1 - proof)).to_i
    #======================================================================
    # ● Air of Insolence
    #======================================================================
    when /AIR_OF_INSOLENCE/i
        if user.difficulty_class("str") >= attacker.saving_throw("wis")
          attacker.add_state(5) unless attacker.actor?
        end
    #======================================================================
    # ● Bleed
    #======================================================================
    when /BLEED/i
        return if attacker.nil?
        
        bleed_value = 5
        if !attacker.p_str.nil?
          bleed_value += [attacker.atk / 100 ,attacker.p_str/3].max
        else
          bleed_value += attacker.atk / 100
        end
        
        bleed_value *= 0.01
        @result.hp_damage = (@result.hp_damage * (1+bleed_value)).to_i
    #======================================================================
    # ● Death Mark
    #======================================================================
    when /DEATH_MARK/i
        return if attacker.nil?
        @result.hp_damage = (@result.hp_damage * 1.15).to_i
    #======================================================================
    # ● Damage Reduce
    #  <react effect: damage reduce x%>
    #======================================================================
    when /DAMAGE REDUCE[ ](\d+)([%％])/i
        return unless @result.hp_damage > 0
        modifier = $1.to_i * 0.01
        @result.hp_damage = (@result.hp_damage * (1 - modifier)).to_i
    #======================================================================
    # ● Mirror Image
    #======================================================================
    when /MIRROR_IMAGE/i
        return unless @result.hp_damage > 0
        
        if rand() >= 0.2
          @result.missed = true
          @result.hp_damage = 0
          @result.hp_drain = 0
          @result.mp_damage = 0
          @result.mp_drain = 0
          Audio.se_play("Audio/SE/Miss",100,100)
        end
        
        if rand() >= 0.1 && self.id == 13 && self.actor?
          @result.missed = true
          @result.hp_damage = 0
          @result.hp_drain = 0
          @result.mp_damage = 0
          @result.mp_drain = 0
          Audio.se_play("Audio/SE/Miss",100,100)
        end
    #======================================================================
    # ● Spell Shield
    #======================================================================
    when /SPELL_SHIELD/i
        return if $current_damage_type != 2 || @result.hp_damage == 0
        
        @result.mp_damage += (@result.hp_damage * 0.8).to_i
        @result.hp_damage = 0
        
        @multi_animation_id.push(352)
        
        self.remove_state(266) if @result.mp_damage >= @mp
    #======================================================================
    # ● Anti Magic
    #======================================================================
    when /ANTI_MAGIC/i
      #puts "Current damage type: #{$current_damage_type}"
      return if $current_damage_type != 2
      @result.hp_damage = 0
      @result.mp_damage = 0
      @result.hp_drain = 0
      @result.mp_drain = 0
      @multi_animation_id.push(352)
    #======================================================================
    # ● fulminant_venom
    #======================================================================
    when /VENOM_BOMB/i
      
      hp_dmg = [@result.hp_damage,@result.hp_drain].max
      
      if hp_dmg >= @hp
        for poison in @poison_damage
          if poison[0] == 660
            @hp = hp_dmg + 1
            break
          end
        end
      end
    #======================================================================
    # ● fulminant_venom remove
    #======================================================================
    when /REMOVE_VENOM_BOMB/i
      
      for poison in @poison_damage
        puts "#{poison}"
        if poison[0] == 660
          @poison_damage.delete(poison)
          break
        end
      end
    #======================================================================
    # ● Virulent Venom
    #======================================================================
    when /VIRULENT_BOMB/i
      
      if $current_user.skill_learned?(663)
        self.reset_state_counts(269,4)
      end
      
      self.poison_damage.push([660,$current_user.mat * 0.3,$current_user])
    #======================================================================
    # ● Dead Animatied
    #======================================================================
    when /DEAD_ANIMATED/i
      @flip = true
      @invert_target = true
      #--------------------------
      # Advanced Reanimation 
      if $current_user.state?(268)
        Audio.se_play("Audio/SE/Magic3",100,100)
        self.add_state(276)
        self.hp = self.mhp
        self.mp = self.mmp
      end
      
    #======================================================================
    # ● Dead Animatied remove
    #======================================================================
    when /DEAD_ANIMATED_REMOVE/i
      @flip = false
      @invert_target = false
      
      self.remove_state(276)
    #======================================================================
    # ● Force_Field
    #======================================================================
    when /FORCE_FIELD/i
      @damage.push(["Immune","Immune"])
      @result.hp_damage = 0
      @result.hp_drain = 0
      @result.mp_damage = 0
      @result.mp_drain = 0
    #======================================================================
    # ● telekinetic force
    #======================================================================
    when /TELEKINETIC_FORCE/i
      hit_feature = RPG::BaseItem::Feature.new(22,0,Math.sqrt($current_user.mat) * 0.001)
      cri_feature = RPG::BaseItem::Feature.new(22,2,Math.sqrt($current_user.mat) * 0.005)
      
      $data_states[273].features = []
      $data_states[273].features.push(hit_feature)
      $data_states[273].features.push(cri_feature)
    #======================================================================
    # ● crushing_prison
    #======================================================================
    when /CRUSHING_PRISON/i
      if self.state?(272)
        self.force_perform_skills.push(670)
        Audio.se_play("Audio/SE/Magic3",100,100)
        scene = get_scene
        self.remove_state(272)
        scene.execute_dead_skill if scene.is_a?(Scene_Battle)
        self.remove_state(274)
        $shockwave_used = true
      else
        @poison_damage.push([668,[$current_user.mat - self.mdf * 0.8,$current_user.mat * 0.1].max,$current_user])
      end
    #======================================================================
    # ● remove crushing prison
    #======================================================================
    when /REMOVE274/i      
      for poison in @poison_damage
        if poison[0] == 668
          @poison_damage.delete(poison)
          break
        end
      end
    #======================================================================
    # ● Shockwave
    #======================================================================
    when /SHOCKWAVE/i
      return unless self.state?(274)
      Audio.se_play("Audio/SE/Magic3",100,100)
      self.force_perform_skills.push(670)
      scene = get_scene
      self.remove_state(274)
      self.remove_state(272)
      scene.execute_dead_skill if scene.is_a?(Scene_Battle)
      $shockwave_used = true
    #======================================================================
    # ● Check chagne state to Storm of the Century
    #======================================================================
    when /STORM_CENTURY/i
      return unless state?(268) && state?(211) && state?(213)
      Audio.se_play("Audio/SE/Magic3",100,100)
      remove_state(211)
      remove_state(213)
      add_state(275)
    #======================================================================
    # ● Melf's Acid Arrow
    #======================================================================
    when /MELFS_ACID/i
      return if $current_user.nil?
      dur = $current_user.level
      dur = 9 if dur.nil?
      dur = (dur/9).to_i
      
      @poison_damage.push([410,$current_user.mat * 0.2,$current_user])
      self.reset_state_counts(105,dur)
    #======================================================================
    # ● Melf's Acid Arrow Remove
    #======================================================================
    when /MELFS_ACID_REMOVE/i
      
      for poison in @poison_damage
        @poison_damage.delete(poison) if poison[0] == 410
      end
    
    #----------------------------------------------------------------------
    # Stop editting past this point.
    #----------------------------------------------------------------------
    else
      so = state_origin
      lw = log_window
      lunatic_state_extension_lsp1(effect, state, user, so, lw,attacker)
    end
  end
  
end # Game_BattlerBase
end # $imported["YEA-LunaticStates"]

#==============================================================================
# 
# ▼ End of LSP
# 
#==============================================================================