#===============================================================================
# Script: Instance Equip Leveling Base 0 Ver. 1.05
# Author: Selchar
# Credit: Tsukihime
# Required: Tsukihime's Item Instance
#===============================================================================
=begin
This script provides common methods required for Equipment Levels.  It does
nothing on it's own and requires another script to initiate the leveling
process.  Feel free to look at what is provided.  For scripters, to change
an equip's level in whatever script you may make, simply call the equip's
level_up/down method.

This Base has your equip's levels start at 0.

#-------------------------------------------------------------------------------
# Weapon/Armor Notetag
#-------------------------------------------------------------------------------
<can level>
Sets where a piece of equipment can level or not.  See Default_Can_Level below.

<max level: x>
Where x is how high you wish for weapon to be able to get to.

<static level param: x>
Where param is the name of a parameter, from mhp/mmp/atk/def/mat/mdf/agi/luk
and x is an integer indicating how much said param will change at level up.

<mult level param: x>
Where param is the same as above, and x is a decimal number that will be used
to determine how much said param changes.  Default setting is down  below.

<static level price: x>
Same as <static level param: x> except for price

<mult level price: x>
Same as <mult level param: x> except for price
=end
module TH_Instance
  module Equip
    #Set this to the default maximum level of your choice.
    Default_Max_Level = 5
    
    #Change this to how you wish for your weapon's level to be shown.
    #'+' will show it as 'Name+1', while 'LV ' will show as 'Name LV 1'
    Level_Prefix = ' +%s'
    
    #Default Multipler bonus
    Default_Mult_Bonus = 1.03
    #Mult bonus for price
    Default_Mult_Price = 1.05
    
    #Determines the default availability of an equip's ability to level.
    #The <can level> notetag will always do the opposite
    Default_Can_Level = true
    
#===============================================================================
# Rest of the Script
#===============================================================================
    def self.static_lvl_stat_regex(param_id)
      /<static[-_ ]?level[-_ ]?#{Selchar::Param[param_id]}:\s*(.*)\s*>/i
    end
    def self.mult_lvl_stat_regex(param_id)
      /<mult[-_ ]?level[-_ ]?#{Selchar::Param[param_id]}:\s*(.*)\s*>/i
    end
    Price_Static_Regex = /<static[-_ ]?level[-_ ]?price:\s*(.*)\s*>/i
    Price_Mult_Regex = /<mult[-_ ]?level[-_ ]?price:\s*(.*)\s*>/i
  end
end
#===============================================================================
# Rest of the Script
#===============================================================================
module Selchar
  Param = ['mhp','mmp','atk','def','mat','mdf','agi','luk','mtp']
end
$imported = {} if $imported.nil?
$imported[:Sel_Equip_Leveling_Base] = true
unless $imported["TH_InstanceItems"]
  msgbox("Tsukihime's Instance not detected, exiting")
  exit
end
unless $imported["YEA-ExtraParamFormulas"]
  msgbox("YANFLY Xparams not detected , exiting")
  exit
end
#===============================================================================
# Special equip name
#===============================================================================
def get_special_equip_name (level)
    unique_name_table = [
        "left_blank","Dark "    ,"Chaos "   ,"Lawless "   ,"Void "   ,"Secret ",
        "Fallen "   ,"Phantom " ,"Vengence ","Avenging "  ,"Gorlic"  ,"Smash ",
        "Fade "     ,"Everlasting ","Enternal ","Rampaging ","Mystical ","Unique ",
        "Shiny "    ,"Unforgiving ","Fabled ",
    ]
    Random.new_seed
    prng = Random.new
    if @special == 0 then
      @special = prng.rand(1..unique_name_table.size - 1)
      return unique_name_table[@special]
    else
      return unique_name_table[@special]
    end
end
#===============================================================================
# Equip Methods
#===============================================================================
class RPG::EquipItem
  attr_accessor :level
  def level
    @level ||= 0
  end
  
  #Call this to increase an equip's level
  def level_up
    return unless can_level
    return if @level == @max_level
    @level += 1
    if @special == nil then
      @special = 0
    end
    level_update
  end
  #Call this to decrease an equip's level
  def level_down
    return if @level.zero?
    @level -= 1
    level_update
  end
  #Unnecessary?
  def level_update
    refresh
  end
#===============================================================================
# Renaming/Param/Price Adjusting
#===============================================================================
  def apply_level_suffix(name)
    if level >= 10 then
      #name = get_special_equip_name(@level) + name
    end
    name += TH_Instance::Equip::Level_Prefix % [@level%1000]
  end
  
  alias :sel_equip_levels_make_name :make_name
  def make_name(name)
    name = apply_level_suffix(name) if can_level && level > 0
  end
  
  def apply_level_params(params)  #effect ability of equipment
    @level.times do
      (0..7).each do |i|
          if params[i] < 34 and params[i] > 0 then
            params[i] = (params[i]+1).to_i
          else
            params[i] = (params[i] * instance_mult_lvl_bonus(i)).to_i
          end
          params[i] += instance_static_lvl_bonus(i)
        end
    end
    return params
  end
  alias :sel_equip_levels_make_params :make_params
  def make_params(params)
    params = sel_equip_levels_make_params(params)
    params = apply_level_params(params) if can_level && @level > 0
    params
  end

  alias :sel_equip_levels_make_price :make_price
  def make_price(price)
    price = sel_equip_levels_make_price(price)
    price = apply_level_price(price) if can_level && @level > 0
    price
  end
  
  def apply_level_price(price)
    @level.times do
      price = (price * instance_mult_price_mod).to_i
      price += instance_static_price_mod
    end
    price

  end
#===============================================================================
# Equip Notetag
#===============================================================================
  def max_level
    @note =~ /<max[-_ ]?level:\s*(.*)\s*>/i ? @max_level = $1.to_i : @max_level = TH_Instance::Equip::Default_Max_Level if @max_level.nil?
    @max_level
  end
  
  def can_level
    if @can_level.nil?
      cl = TH_Instance::Equip::Default_Can_Level
      @note =~ /<can[-_ ]?level>/i ? @can_level = !cl : @can_level = cl
    end
    @can_level
  end
  
  def instance_static_lvl_bonus(param_id)
    if @instance_static_lvl_bonus.nil?
      @instance_static_lvl_bonus = []
      (0..8).each do |i|
        if @note =~ TH_Instance::Equip.static_lvl_stat_regex(i)
          @instance_static_lvl_bonus[i] = $1.to_i
        else
          @instance_static_lvl_bonus[i] = 0
        end
      end
    end
    @instance_static_lvl_bonus[param_id]
  end
  
  def instance_mult_lvl_bonus(param_id)
    if @instance_mult_lvl_bonus.nil?
      @instance_mult_lvl_bonus = []
      (0..8).each do |i|
        if @note =~ TH_Instance::Equip.mult_lvl_stat_regex(i)
          @instance_mult_lvl_bonus[i] = $1.to_f
        else
          @instance_mult_lvl_bonus[i] = TH_Instance::Equip::Default_Mult_Bonus
        end
      end
    end
    @instance_mult_lvl_bonus[param_id]
  end
  
  def instance_static_price_mod
    @note =~ TH_Instance::Equip::Price_Static_Regex ? @instance_static_price_mod = $1.to_i : @instance_static_price_mod = 0 if @instance_static_price_mod.nil?
    @instance_static_price_mod
  end
  
  def instance_mult_price_mod
    @note =~ TH_Instance::Equip::Price_Mult_Regex ? @instance_mult_price_mod = $1.to_f : @instance_mult_price_mod = TH_Instance::Equip::Default_Mult_Price if @instance_mult_price_mod.nil?
    @instance_mult_price_mod
  end
end
#===============================================================================
# Instance Manager: setup_instance
#===============================================================================
module InstanceManager
  class << self
    alias :instance_equip_level_setup :setup_equip_instance
  end
  
  def self.setup_equip_instance(obj)
    obj.level = 0
    obj.max_level
    instance_equip_level_setup(obj)
  end
end
#===============================================================================
# End of File
#===============================================================================
