#==============================================================================
# 
# ▼ Blocking v1.10
# -- Last Updated: 2012.10.18
# -- Level: Average
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["MOTO-Blocking"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.10.19 - Fixed critical bug, typos, updated and renamed script.
# 2012.10.18 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Gives you additional defensive options to apply to your weapons and armor.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <block physical>
# This weapon can be used to block attacks with the physical type.
#
# <block magical>
# This weapon can be used to block attacks with the magical type.
#
# <block critical>
# This weapon can be used to block critical attacks; must be used with one of
# the above tags as well.
#
# <block element +x: x%>
# <block element -1: x%>
# Indicates what kind of elements this weapon can block.  You can set up many
# different elements, and each can be given its own percentage.  Use -1 for
# normal attacks, and +0 for attacks with the None type.
#
# <block text: x>
# Allows you to set up custom messages to display when a weapon successfully
# blocks an attack.  Otherwise it will use the default message defined below.
#
# <block adjust: +/-x>
# <block adjust: +/-x%>
# This tag affects the block rate of all items you have equipped.
#
# <unblockable>
# Allows you to designate this weapon's attacks as unblockable.
# 
# -----------------------------------------------------------------------------
# Armor Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <block physical>
# This armor can be used to block attacks with the physical type.
#
# <block magical>
# This armor can be used to block attacks with the magical type.
#
# <block critical>
# This armor can be used to block critical attacks; must be used with one of
# the above tags as well.
#
# <block element x: x%>
# Indicates what kind of elements this armor can block.  You can set up many
# different elements, and each can be given its own percentage.  Use -1 for
# normal attacks, and 0 for attacks with the None type.
#
# <block text: x>
# Allows you to set up custom messages to display when your armor successfully
# blocks an attack.  Otherwise it will use the default message defined below.
#
# <block adjust: +/-x>
# <block adjust: +/-x%>
# This tag affects the block rate of all items you have equipped.
#
# <saving throw adjust x: +/-x>
#
# <missile block rate: +/-x>
#
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <unblockable>
# Allows you to designate this skill's attacks as unblockable.
# <block adjust: +/-x>
# Increase/Decrease this character's result block rate
# <normal attack>
# like the name said  
# <missile>
# is missile attack
#
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the item notebox in the database.
# -----------------------------------------------------------------------------
# <unblockable>
# Allows you to designate this items's attacks as unblockable.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the state notebox in the database.
# -----------------------------------------------------------------------------
# <missile block rate: +/-x>
# <block adjust: +/-x>
# Increase/Decrease this character's result block rate
#
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module MOTO
  module SPECDEF
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default Block Text -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # If a weapon or armor is not designated a message to display when used for
    # blocking, this is displayed instead.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_BLOCK_TEXT  = "%2$s absorbed the blow!"
    DEFAULT_BLOCK_SOUND = "Sword05.mp3"
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default Block Rate -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # If a weapon or armor is not designated a rate at which to block attacks,
    # this percentage will be used.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_BLOCK_RATE     = 0.10
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default Block Elements -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # All items that block will receive these elements.  You can overwrite
    # these values via notetags as well.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_BLOCK_ELEMENTS = {
      -1   =>  10    # 10% chance to block normal attacks
    } # <- Don't remove this

    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Guard Block Boost -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Increases your chance to block by this percentage while guarding.  This
    # is an multiplicative increase, 25% + 25% is a 31% chance.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    GUARD_BLOCK_BOOST   = 0.25
  end # BLOCK
end # MOTO

#==============================================================================
# ▼ I will not help you troubleshoot if you change anything below; I will
# incorporate fixes if your find something that is broken.
#==============================================================================

module MOTO
  module REGEXP
  module BASEITEM
      
      DOES_BLOCK_ATTACK = /<(?:BLOCKABLE|blockable)>/i
      DOES_BLOCK_PHYS  = /<(?:BLOCK_PHYSICAL|block physical)>/i
      DOES_BLOCK_MAG   = /<(?:BLOCK_MAGICAL|block magical)>/i
      DOES_BLOCK_ELEM  = /<(?:BLOCK_ELEMENT|block element)[ ]([\+\-]\d+):[ ](\d+)([%％])>/i
      DOES_BLOCK_CRIT  = /<(?:BLOCK_CRITICAL|block critical)>/i
      BLOCK_TEXT       = /<(?:BLOCK_TEXT|block text):[ ](.*)>/i
      BLOCK_SOUND      = /<(?:BLOCK_SOUND|block sound):[ ](.*)>/i
      BLOCK_ADJUST_SET = /<(?:BLOCK_ADJUST|block adjust):[ ]([\+\-]\d+)>/i
      BLOCK_ADJUST_PER = /<(?:BLOCK_ADJUST|block adjust):[ ]([\+\-]\d+)([%％])>/i
      UNBLOCKABLE      = /<?:UNBLOCKABLE|unblockable>/i
      IS_NORMAL_ATTACK = /<(?:NORMAL_ATTACK|normal attack)>/i
      IS_MISSILE = /<(?:MISSILE|missile)>/i
      MISSILE_BLOCK_RATE = /<(?:MISSILE_BLOCK_RATE|missile block rate):[ ]([\+\-]\d+)>/i
      THAC0 = /<(?:THAC0|thac0):[ ]([\+\-]\d+)>/i
      ARMOR_CLASS = /<(?:AC|ac):[ ]([\+\-]\d+)>/i
  end # BASEITEM
  end # REGEXP
end # MOTO



#==========================================================================
# ■ RPG::BaseItem
#==========================================================================

class RPG::BaseItem
  
  #------------------------------------------------------------------------
  # public instance variables
  #------------------------------------------------------------------------
  attr_accessor :unblockable
  attr_accessor :block_adjust
  attr_accessor :is_normal_attack
  attr_accessor :is_missile
  attr_accessor :missile_block_rate
  attr_accessor :block_adjust_set
  attr_accessor :thac0
  #------------------------------------------------------------------------
  # common cache: load_notetags_specdef
  # tag: state
  #------------------------------------------------------------------------  
  def load_notetags_specdef
    @unblockable = false
    @block_adjust = 0 
    @thac0        = 0
    @is_normal_attack = false
    notetagged_items = false
    
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when MOTO::REGEXP::BASEITEM::UNBLOCKABLE
        @unblockable = true
      when MOTO::REGEXP::BASEITEM::BLOCK_ADJUST_SET
        $data_notetagged_items.push(self)
        @block_adjust_set = $1.to_i
        p sprintf("[Attack Block]:%s's normal block attack: %d",self.name,self.block_adjust_set)
      when MOTO::REGEXP::BASEITEM::IS_NORMAL_ATTACK
        @is_normal_attack = true
      when MOTO::REGEXP::BASEITEM::IS_MISSILE
        @is_missile = true
        p sprintf("[Attack Block]:%s is missile attack",self.name)
      when MOTO::REGEXP::BASEITEM::MISSILE_BLOCK_RATE
        $data_notetagged_items.push(self)
        @missile_block_rate = $1.to_i
        p sprintf("[Attack Block]:%s missile block rate: %d",self.name,self.missile_block_rate)
      when MOTO::REGEXP::BASEITEM::THAC0
        $data_notetagged_items.push(self)
        @thac0 = $1.to_i
        p sprintf("[Attack Block]:%s THAC adjust: %d",self.name,self.thac0)      
      end
    } # self.note.split
  end
end # RPG::BaseItem


#==============================================================================
# ■ RPG::EquipItem
#==============================================================================

class RPG::EquipItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :does_block
  attr_accessor :does_block_crit
  attr_accessor :does_block_phys
  attr_accessor :does_block_mag
  attr_accessor :does_block_elem
  attr_accessor :block_text
  attr_accessor :block_sound
  attr_accessor :block_adjust_set
  attr_accessor :block_adjust_per
  attr_accessor :missile_block_rate
  attr_accessor :thac0
  #--------------------------------------------------------------------------
  # common cache: load_notetags_specdef
  #--------------------------------------------------------------------------
  def load_notetags_specdef
    @does_block       = false
    @does_block_phys  = false
    @does_block_mag   = false
    @does_block_crit  = false
    @does_block_elem  = MOTO::SPECDEF::DEFAULT_BLOCK_ELEMENTS 
    @block_text       = MOTO::SPECDEF::DEFAULT_BLOCK_TEXT
    @block_rate       = MOTO::SPECDEF::DEFAULT_BLOCK_RATE * 100
    @block_sound      = MOTO::SPECDEF::DEFAULT_BLOCK_SOUND
    @block_adjust_set = 0
    @block_adjust_per = 1
    @unblockable = false
    @missile_block_rate = 0
    @thac0            = 0
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when MOTO::REGEXP::BASEITEM::DOES_BLOCK_ATTACK
        #p sprintf("Id:%s (%s) can block",self.id,self.name)
        @does_block = true
      when MOTO::REGEXP::BASEITEM::DOES_BLOCK_PHYS
        #p sprintf("Id:%s (%s) can block physis",self.id,self.name)
        @does_block_phys = true
      when MOTO::REGEXP::BASEITEM::DOES_BLOCK_MAG
        #p sprintf("Id:%s (%s) can block magic",self.id,self.name)
        @does_block_mag  = true
      when MOTO::REGEXP::BASEITEM::DOES_BLOCK_ELEM
        @does_block_elem[$1.to_i] = $2.to_i
      when MOTO::REGEXP::BASEITEM::DOES_BLOCK_CRIT
        @does_block_crit  = true
      when MOTO::REGEXP::BASEITEM::BLOCK_TEXT
        @block_text       = $1.to_s
      when MOTO::REGEXP::BASEITEM::BLOCK_SOUND
        @block_sound      = $1.to_s
      when MOTO::REGEXP::BASEITEM::BLOCK_ADJUST_SET
        @block_adjust_set = $1.to_i
        p sprintf("[Attack Block]:%s normal block rate: %d",self.name,self.block_adjust_set)
      when MOTO::REGEXP::BASEITEM::BLOCK_ADJUST_PER
        @block_adjust_per = $1.to_i * 0.01 + 1
      when MOTO::REGEXP::BASEITEM::UNBLOCKABLE
        @unblockable = true
      when MOTO::REGEXP::BASEITEM::MISSILE_BLOCK_RATE
        @missile_block_rate = $1.to_i
        p sprintf("[Attack Block]:%s missile block rate: %d",self.name,self.missile_block_rate)
      when MOTO::REGEXP::BASEITEM::THAC0
        @thac0 = $1.to_i
        p sprintf("[Attack Block]:%s THAC adjust: %d",self.name,self.thac0) 
      end
    } # self.note.split
  end
  
end # RPG::EquipItem

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_specdef load_database; end
  def self.load_database
    $data_notetagged_items = []
    load_database_specdef
    load_notetags_specdef
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_war
  #--------------------------------------------------------------------------
  def self.load_notetags_specdef
#    for script in $RGSS_SCRIPTS
#      p sprintf("%s",script.delete_active)
#    end
    groups = [$data_weapons, $data_armors,$data_skills,$data_states]
    
    p sprintf("[Attack Block]:load note tags")
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_specdef
      end
    end
  end
  
end # DataManager

#==========================================================================
# ■ Game_BattlerBase
#==========================================================================

class Game_BattlerBase

  #--------------------------------------------------------------------------
  # new method: does_block?
  #--------------------------------------------------------------------------
  def does_block?(equip, item)
    return false if !equip.does_block
    return false if !equip.does_block_phys && item.physical?
    return false if !equip.does_block_mag  && item.magical?
    return true  if equip.does_block_elem.include?(item.damage.element_id)
    return true  if equip.missile_block_rate
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: adjusted_block_rate
  #--------------------------------------------------------------------------
  def adjusted_block_rate(equip, item)
    element_id = item.damage.element_id
    rate = equip.does_block_elem[element_id] ? equip.does_block_elem[element_id] : 0
    missile_block_rate = 0
    
    if item.is_missile
      #p sprintf("[Attack Block]:%s item is missile attack",item)
      for equip in equips
        next if equip.nil?
        missile_block_rate += equip.missile_block_rate
      end      
    end
    
    if actor? && !equip.nil?
      rate += equip.block_adjust_set
      # ↓ *disabled due to d20 system used*
      #rate *= equip.block_adjust_per
    end
    
    return [missile_block_rate,rate].max
  end
  #--------------------------------------------------------------------------
  # new method: attack roll
  #--------------------------------------------------------------------------
  def attack_roll(item)
    
    bonus = (item.magical? || item.speed > 60) ? 4 : 0
    
    if item.physical?
      if item.is_missile
        return self.difficulty_class('dex',-10,false) + bonus
      else
        return self.difficulty_class('str',-10,false) + bonus
      end
    elsif item.magical?
      return self.difficulty_class('int',-8,false) + bonus
    end
    
    return 20
  end
  #--------------------------------------------------------------------------
  # new method: did block?
  #--------------------------------------------------------------------------
  def did_block?(item, is_crit = false,user)
    return false unless item.for_opponent?
    return false if @base_attack_roll == 20
    return false if item.magical?
    
    @base_attack_roll += user.attack_roll(item).to_i
    
    rate = 0
    result = false
    
    if actor?
      for equip in equips
        next if equip.nil?
        next if is_crit && !equip.does_block_crit
        next if !does_block?(equip, item)
        break if result == true
        
        real_ac = self.armor_class + adjusted_block_rate(equip, item)
        
        result = true if real_ac > @base_attack_roll
      end
    end
    
    if !result
      real_ac = self.armor_class + calc_block_rate(item)
    end
    
    #puts "THAC0:#{@real_thac0} AC:#{real_ac}"
    result = @base_attack_roll + @real_thac0 < real_ac
    
    if real_ac > 0 && ($game_system.show_roll_result? || $force_show_roll_result)
      $game_message.battle_log_add(sprintf("** Block Result: **"))
      $game_message.battle_log_add(sprintf("** %s's %20s",self.name , "AC:" + real_ac.to_s))
      $game_message.battle_log_add(sprintf("** %s's %20s",user.name , "Attack Roll(adjusted):" + (@base_attack_roll + @real_thac0).to_s))
    end
    
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method : calc bonus block rate
  #--------------------------------------------------------------------------
  def calc_block_rate(item)
    block_rate_plus = 0

    for skill in $data_notetagged_items
      next if skill.nil? || !skill.is_a?(RPG::Skill)
      next unless self.skills.include?(skill) && skill_equip_ready?(skill)
      
      bonus = skill.block_adjust_set ? skill.block_adjust_set : 0 rescue nil
      bonus += skill.missile_block_rate if item.is_missile rescue nil
      bonus = 0 if bonus.nil?
      block_rate_plus += bonus
      
    end
    
    for state in self.states
      next if state.nil?
      
      bonus = state.block_adjust_set ? state.block_adjust_set : 0 rescue nil
      if item.is_missile 
        bonus += state.missile_block_rate ? state.missile_block_rate : 0 rescue nil
      end
      bonus = 0 if bonus.nil?
      block_rate_plus += bonus
    end
    
    return block_rate_plus
  end
  #--------------------------------------------------------------------------
  # new method : calc real thac0
  # tag: thac0
  #--------------------------------------------------------------------------
  def calc_real_thac0(item)
    thac0_bonus = item.thac0
    thac0_bonus = 20 if item.is_a?(RPG::Item)
      
    if self.actor?
      for equip in equips
        next if equip.nil?
        thac0_bonus += equip.thac0 rescue nil
      end
    end
    
    for skill in $data_notetagged_items
      next if skill.nil? || !skill.is_a?(RPG::Skill)
      next unless self.skills.include?(skill) && skill_equip_ready?(skill)
      
      bonus = skill.thac0 ? thac0 : 0 rescue nil
      bonus = 0 if bonus.nil?
      thac0_bonus += bonus
    end
    
    for state in self.states
      next if state.nil?
      
      bonus = state.thac0 ? state.thac0 : 0 rescue nil
      bonus = 0 if bonus.nil?
      thac0_bonus += bonus
    end
    
    return thac0_bonus
  end
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias: make_damage_value
  #--------------------------------------------------------------------------
  alias make_damage_value_specdef make_damage_value
  def make_damage_value(user, item)
    did_block = false
    @base_attack_roll = rand(20) + 1
    @base_attack_roll = 14 if !opposite?(user) || (!item.magical? && !item.physical?)
    
    @real_thac0 = user.calc_real_thac0(item) + user.thac0
    
    if movable? && !item.unblockable
      #-----------------------------  --------------------------------
      # determine if blocked attack
      #-------------------------------------------------------------
      did_block = did_block?(item, @result.critical,user)
      
      if did_block != false
        @result.critical = false unless !did_block
        @result.blocked  = true 
        #p sprintf("Character name:%s",self.name)
        
        if !user.actor?
          @dmg_popup = true 
          @popup_ary.push((["Blocked","Blocked"]))
        end
        
        Audio.se_play("Audio/SE/Sword05", 80, 110) 
        #p sprintf("Blocked!")
      end
    end
    
    make_damage_value_specdef(user, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: execute_damage
  #--------------------------------------------------------------------------
  alias execute_damage_specdef execute_damage
  def execute_damage(user)
    @base_attack_roll = 10
    return if @result.blocked && !@result.critical
    execute_damage_specdef(user)
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_ActionResult
#==============================================================================

class Game_ActionResult

  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :blocked
  
  #--------------------------------------------------------------------------
  # alias : clear_hit_flags
  #--------------------------------------------------------------------------
  alias clear_hit_flags_specdef clear_hit_flags
  def clear_hit_flags
    @blocked = false
    clear_hit_flags_specdef
  end
  
  #--------------------------------------------------------------------------
  # new method: block_text
  #--------------------------------------------------------------------------
  def block_text
#    sprintf(@blocked.block_text, @battler.name, @blocked.name)
  end

end # Game_ActionResult

#==============================================================================
# ■ Window_BattleLog
#==============================================================================

class Window_BattleLog < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias : display_hp_damage
  #--------------------------------------------------------------------------
  alias display_hp_damage_specdef display_hp_damage
  def display_hp_damage(target, item)
    return if item && !item.damage.to_hp?
    if target.result.blocked && !target.result.critical
      #Audio.se_play("Audio/SE/Sword05", 80, 110) 
      #add_text(target.result.block_text + item.damage.element_id.to_s)
      wait
    end
    display_hp_damage_specdef(target, item)
  end
end

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================