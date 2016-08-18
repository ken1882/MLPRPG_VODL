#===============================================================================
# Script: Instance Equip Leveling by Exp Ver. 1.03
# Author: Selchar
# Credit: Tsukihime
# Required: Tsukihime's Item Instance
# Required: Selchar's Weapon Leveling Base
#===============================================================================
=begin
This script, when paired with the Weapon Leveing Base, allows select equipment to
gain exp and level up after battle.
#-------------------------------------------------------------------------------
# Weapon/Armor Notetag
#-------------------------------------------------------------------------------
<exp curve: x>
<exp curve>
x
</exp curve>

Where x in either notetag is a formula that'll be used to determine an equip's
exp curve.
=end
module TH_Instance
  module Equip
    #Set this to what you want the default exp curve to be.
    Default_Exp_Curve = ' (level+1) * Math.sqrt(@price) * 2 '
    
    #Regex
    Exp_Curve_Regex = /<exp[-_ ]?curve:\s*(.*)\s*>/i
    Ext_Exp_Curve_Regex = /<exp[-_ ]?curve>(.*)<\/exp[-_ ]?curve>/im
  end
end
#===============================================================================
# Rest of the Script
#===============================================================================
$imported = {} if $imported.nil?
$imported[:Sel_Equip_Exp_Leveling] = true
unless $imported["TH_InstanceItems"]
  msgbox("Tsukihime's Instance Items not detected,
exiting")
  exit
end
unless $imported[:Sel_Equip_Leveling_Base]
  msgbox("Selchar's Equip Leveling Base not detected,
Exiting")
  exit
end

class Game_Actor < Game_Battler
  def gain_equip_exp(amount)
    equips.each do |i|
      next unless i
      next unless i.can_level
      next if i.level == i.max_level
      i.exp += amount
      while i.exp >= i.exp_to_level
                  
        i.exp = i.exp_to_level if i.level == (i.max_level-1)
        i.level_up
        i.equip_level_message(self.name, i)
      end
    end
  end
end

module BattleManager
  class << self
    alias :instance_equip_gain_exp :gain_exp
  end
  
  def self.gain_exp
    instance_equip_gain_exp
    $game_party.battle_members.each do |actor|
      actor.gain_equip_exp($game_troop.exp_total) unless actor.death_state?
    end
    wait_for_message
  end
end
#===============================================================================
# Note Tags Equip Info
#===============================================================================
class RPG::EquipItem
  attr_accessor :exp
  def exp_curve
    @note =~ TH_Instance::Equip::Exp_Curve_Regex ? @exp_curve = $1 : @exp_curve = nil if @exp_curve.nil?
    @note =~ TH_Instance::Equip::Ext_Exp_Curve_Regex ? @exp_curve = $1 : @exp_curve = TH_Instance::Equip::Default_Exp_Curve if @exp_curve.nil?
    @exp_curve
  end
  def exp_to_level
    eval(exp_curve)
  end
  def equip_level_message(actor_name, equip_item)
    message = "%s's %s leveled up! \\n" % [actor_name, $game_party.get_template(equip_item).name]
    $game_message.add(message)
  end
end
#===============================================================================
# Instance Manager: setup_instance
#===============================================================================
module InstanceManager
  class << self
    alias :instance_equip_exp_level_setup :setup_equip_instance
  end
  
  def self.setup_equip_instance(obj)
    obj.exp = 0 if obj.can_level
    instance_equip_exp_level_setup(obj)
  end
end
#===============================================================================
# End of File
#===============================================================================
