=begin
#===============================================================================
 Title: Instance Items
 Author: Hime
 Date: Jan 29, 2015
 URL: http://himeworks.com/2014/01/07/instance-items/
--------------------------------------------------------------------------------
 ** Change log 
 Jan 29, 2015
   - requests for weapons, armors, or items will return a clone of the original
     arrays in case you try to operate on it
 Dec 1, 2014
   - moved instance database reloading into "load_game_without_rescue" instead
     of "load_game"
 Aug 30, 2014
   - fixed issue where removing items, including equips, crashed
 May 4, 2014
   - rather than reloading template database completely, simply drop the
     instance objects
 Mar 21, 2014
   - fixed issue where conditional branch for equip checking doesn't work
 Jan 23, 2014
   - added support for refreshing note, description, and icon index
 Jan 16, 2014
   - added support for refreshing price and features
 Jan 14, 2014
   - added support for "refreshing" names and params
 Jan 12, 2014
   - disabling instance mode properly works for equips
   - fixed issue with equipping
 Jan 9, 2014
   - instance counts do not explicitly "gain/lose" a template item
   - fixed issue where changing equips forcibly was not working correctly
   - fixed issue with battle test when item instances were enabled
 Jan 7, 2014
   - added several setup methods to the Instance Manager
 Dec 10, 2013
   - compatibility with Core Equip Slots
   - Initial release
--------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in non-commercial projects
 * Contact me for commercial use
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Credits to Hime Works in your project
 * Preserve this header
--------------------------------------------------------------------------------
 ** Description
 
 This script introduces the concept of "instance items". In order to understand
 what an instance item is, you need to first understand what a "template item"
 is.
 
 All of your database items, weapons, and armors are called "template items".
 That is, they serve as templates for in-game items.
 
 An instance item is simply an instance of a template. For example, you design
 weapon ID 1 in your database and call it a "Short Sword". This is a template
 of a Short Sword; everytime you receive a Short Sword in-game, you receive
 a unique "instance" of this template. Two Short Swords in your inventory are
 treated as two individual entities that have nothing to do with each other
 besides both being based on the Short Sword template.
 
 It is important to note that this script simply provides instance item
 functionality. Additional add-ons are required to provide various features
 such as equip levels, equip affixes, and so on.
 
--------------------------------------------------------------------------------
 ** Installation
 
 In the script editor, place this script below Materials and above Main
 
 You should place this below any equip-related scripts, such as my
 Core Equip Slots or Yanfly's Ace Equip Engine.

--------------------------------------------------------------------------------
 ** Usage 
 
 This script is plug and play.
 
 -- Instance Mode --
 
 You can determine what type of objects allow instances or not in the
 configuration by changing its "instance mode". For example, you can disable
 instances for items so that they stack as normal.
 
 These are the default values I have picked:
 
   Items   - false
   Weapons - true
   Armors  - true
   
 Currently, if instance mode is ON for that category of items, all items will
 be treated as instances.
   
 -- Event Changes --
 
 The following event commands behave differently if instance mode is on.
 When I say "item" I refer to weapons, armors, and items.
 
 - When you gain an item using events, new instances will be added to the
 inventory.
 
 - When you lose an item using events, it follows "template discard" rules.
 For example, if your event says to "lose 1 short sword", then the engine will
 simply look for ANY instance item that is based on the short sword. The same
 applies to equips if you include equips.
 
 - When you use the "change equipment" event command, the engine looks for the
 first instance of the specified equip.
 
--------------------------------------------------------------------------------
 ** Developers
 
 This script serves as a framework for all instance items. Currently, it only
 supports item, weapon, and armor instances.
 
 The goal is to allow developers to write their own scripts that require
 "unique" items very easily without having to worry about how to actually
 implement it.
 
 This script is designed so that you only need to focus on two things
 
 1. The RPG module, which contains the template weapons, armors, and items.
 2. the InstanceManager module, which handles everything related to instances.
 
 A simple script would first load note-tags from the RPG objects and store them
 with the templates. For example, suppose we want to give all instance weapons
 a random attack bonus. We start by defining the max possible bonus a weapon
 could receive.
 
   class RPG::Weapon < RPG::EquipItem
     def attack_bonus
       50
     end
   end
   
 Now, we make it so that whenever an instance weapon is created, a random bonus
 will be applied to its attack. The InstanceManager provides several "setup"
 methods available for you, depending on what kind of object you're working
 with:
 
   setup_equip_instance(obj)  - use this for any equips (weapons or armors)
   setup_weapon_instance(obj) - use this only for weapons
   setup_armor_instance(obj)  - use this only for armors
   setup_item_instance(obj)   - use this only for items
   
 Since our example is applying a random flat bonus to an instance weapon, we
 would alias the weapon setup method.
 
   module InstanceManager
     class << self
       alias :th_random_weapon_bonus_setup_weapon_instance :setup_weapon_instance
     end
     
     def self.setup_weapon_instance(obj)
       template_obj = get_template(obj)
       th_random_weapon_bonus_setup_weapon_instance(obj)
       obj.params[2] += rand(template_obj.attack_bonus)
     end
   end
   
 Note the use of the `get_template` method in the setup. `obj` is an instance
 weapon that we are creating.Our data is stored with the template weapon, so we
 need to get it first before we can use it. After you have your template, you
 can easily get the data you need to apply to your instance object.

 And that's it! Your instance weapon now has a random attack bonus. You can
 verify this by adding the same weapon to your inventory multiple times and
 checking their parameters in the equip menu.
 
 This is a very simple example, but its goal is to demonstrate how to modify
 your instance objects. The rest of the game will just see it as another item
 or equip.
 
 -- Shared Data Compatibility --
 
 Because many scripts may modify item information, it is important to write
 compatible code.
 
 All RPG items, weapons, and armors support a `refresh` method that will
 re-compute a number of variables such as the name or parameters.
 
 For example, to modify the name of an object, you should alias the 
 `make_name` method, which takes a name and returns a new name.
 
 The order in which the modifications are applied is important, and therefore
 you should make it clear what order users should place your script in.
 
#===============================================================================
=end
$imported = {} if $imported.nil?
$imported["TH_InstanceItems"] = true
#===============================================================================
# ** Configuration
#===============================================================================
module TH
  module Instance_Items
    
    # Enables instance mode for each type of object. When instance mode is
    # enabled, all objects of that type will be treated as instances
    Enable_Items = false
    Enable_Weapons = true
    Enable_Armors = true
  end
end
#===============================================================================
# ** Rest of script
#===============================================================================

#-------------------------------------------------------------------------------
# This module manages all instance and template items.
#-------------------------------------------------------------------------------
module InstanceManager
  
  class << self
    attr_accessor :weapons
    attr_accessor :armors
    attr_accessor :items
    attr_reader :template_counts
  end
  
  def self.setup
    @template_counts = {}
    @template_counts[:weapon] = $data_weapons.size
    @template_counts[:armor] = $data_armors.size
    @template_counts[:item] = $data_items.size
  end
  
  #-----------------------------------------------------------------------------
  # Stores the instance objects for game saving purpose
  #-----------------------------------------------------------------------------
  def self.create_game_objects
    @weapons = {}
    @armors = {}
    @items = {}
  end
  
  #-----------------------------------------------------------------------------
  # Full copy of the template object so we don't have any reference issues
  #-----------------------------------------------------------------------------
  def self.make_full_copy(obj)
    return Marshal.load(Marshal.dump(obj))
  end
  
  def self.instance_enabled?(obj)
    return TH::Instance_Items::Enable_Items if obj.is_a?(RPG::Item)
    return TH::Instance_Items::Enable_Weapons if obj.is_a?(RPG::Weapon)
    return TH::Instance_Items::Enable_Armors if obj.is_a?(RPG::Armor)
    return false
  end
  
  def self.is_template?(obj)
    return obj.id >= @template_counts[:item] if obj.is_a?(RPG::Item)
    return obj.id >= @template_counts[:weapon] if obj.is_a?(RPG::Weapon)
    return obj.id >= @template_counts[:armor] if obj.is_a?(RPG::Armor)
  end
  
  #-----------------------------------------------------------------------------
  # create an instance from the template. Basically just a full copy.
  #-----------------------------------------------------------------------------
  def self.make_instance(obj)
    new_obj = make_full_copy(obj)
    new_obj.template_id = new_obj.id
    return new_obj
  end
  
  #-----------------------------------------------------------------------------
  # Return the database table that the obj belongs in
  #-----------------------------------------------------------------------------
  def self.get_tables(obj)
    return @items, $data_items if obj.is_a?(RPG::Item)
    return @weapons, $data_weapons if obj.is_a?(RPG::Weapon)
    return @armors, $data_armors if obj.is_a?(RPG::Armor)
  end
  
  def self.get_template(obj)
    return $data_items[obj.template_id] if obj.is_a?(RPG::Item)
    return $data_weapons[obj.template_id] if obj.is_a?(RPG::Weapon)
    return $data_armors[obj.template_id] if obj.is_a?(RPG::Armor)
  end
  
  #-----------------------------------------------------------------------------
  # Returns an instance of the object, assuming it is a valid object, it
  # supports instances, and it's not a template
  #-----------------------------------------------------------------------------
  def self.get_instance(obj)
    return obj if obj.nil? || !instance_enabled?(obj) || !obj.is_template?
    new_obj = make_instance(obj)
    container, table = get_tables(obj)
    id = table.size
    
    new_obj.id = id
    # Setup the instance object as required
    setup_instance(new_obj)
    
    # Add to database and container
    container[id] = new_obj
    table[id] = new_obj
    return new_obj
  end
  
  #-----------------------------------------------------------------------------
  # Set up our new instance object. This is meant to be aliased
  #-----------------------------------------------------------------------------
  def self.setup_instance(obj)
    setup_equip_instance(obj) if obj.is_a?(RPG::EquipItem)
    setup_item_instance(obj) if obj.is_a?(RPG::Item)
  end

  #-----------------------------------------------------------------------------
  # Apply any equip-specific logic. This is meant to be aliased.
  # Note the same object is passed to the appropriate setup method depending
  # on whether it's a weapon or armor, so be careful not to apply the same
  # changes multiple times.
  #-----------------------------------------------------------------------------
  def self.setup_equip_instance(obj)
    setup_weapon_instance(obj) if obj.is_a?(RPG::Weapon)
    setup_armor_instance(obj) if obj.is_a?(RPG::Armor)
  end
  
  #-----------------------------------------------------------------------------
  # Apply any weapon-specific logic. This is meant to be aliased.
  #-----------------------------------------------------------------------------
  def self.setup_weapon_instance(obj)
  end
  
  #-----------------------------------------------------------------------------
  # Apply any armor-specific logic. This is meant to be aliased.
  #-----------------------------------------------------------------------------
  def self.setup_armor_instance(obj)
  end
  
  #-----------------------------------------------------------------------------
  # Apply any item-specific logic. This is meant to be aliased.
  #-----------------------------------------------------------------------------
  def self.setup_item_instance(obj)
  end
end

module RPG
  
  class BaseItem
    
    # List of all attributes that are shared instance variable
    _instance_attr = [:name, :params, :price, :features, :note, :icon_index,
                      :description]
    
    #---------------------------------------------------------------------------
    # Define methods for all shared variables
    #---------------------------------------------------------------------------
    _instance_refresh = "def refresh"
    _instance_attr.each do |ivar|
      _instance_refresh << ";refresh_#{ivar}"
      
      eval(
        "def refresh_#{ivar}
          var = InstanceManager.get_template(self).#{ivar}
          @#{ivar} = make_#{ivar}(InstanceManager.make_full_copy(var))
        end
        
        def make_#{ivar}(#{ivar})
          #{ivar}
        end
        "
      )
    end
    _instance_refresh << ";end"
    eval(_instance_refresh)

  end
  
  class Item < UsableItem
    attr_accessor :template_id
    
    def is_template?
      return self.template_id == self.id
    end
    
    def template_id
      @template_id = @id unless @template_id
      return @template_id
    end
  end
  
  class EquipItem < BaseItem    
    attr_accessor :template_id
    
    def is_template?
      self.template_id == self.id
    end
    
    def template_id
      @template_id = @id unless @template_id
      return @template_id
    end
  end
end

module DataManager
  
  class << self
    alias :th_instance_items_load_game_without_rescue :load_game_without_rescue
    alias :th_instance_items_create_game_objects :create_game_objects
    alias :th_instance_items_make_save_contents :make_save_contents
    alias :th_instance_items_extract_save_contents :extract_save_contents
  end
  
  def self.create_game_objects
    th_instance_items_create_game_objects
    InstanceManager.create_game_objects
    load_instance_database
  end
  
  def self.make_save_contents
    contents = th_instance_items_make_save_contents
    contents[:instance_weapons] = InstanceManager.weapons
    contents[:instance_armors] = InstanceManager.armors
    contents[:instance_items] = InstanceManager.items
    contents
  end
  
  def self.extract_save_contents(contents)
    th_instance_items_extract_save_contents(contents)
    InstanceManager.weapons = contents[:instance_weapons] || []
    InstanceManager.armors = contents[:instance_armors] || []
    InstanceManager.items = contents[:instance_items] || []
  end
  
  def self.load_game_without_rescue(index)
    res = th_instance_items_load_game_without_rescue(index)
    reload_instance_database
    return res
  end
  
  #-----------------------------------------------------------------------------
  # Merges the instance items into the database
  #-----------------------------------------------------------------------------
  def self.load_instance_database
    InstanceManager.setup
    merge_array_data($data_weapons, InstanceManager.weapons)
    merge_array_data($data_armors, InstanceManager.armors)
    merge_array_data($data_items, InstanceManager.items)
  end
  
  def self.reload_instance_database
    $data_weapons = $data_weapons[0..InstanceManager.template_counts[:weapon]]
    $data_armors = $data_armors[0..InstanceManager.template_counts[:armor]]
    $data_items = $data_items[0..InstanceManager.template_counts[:item]]
    load_instance_database
  end
  
  def self.merge_array_data(arr, hash)
    hash.each {|i, val|
      arr[i] = val
    }
  end
end

class Game_Interpreter
  
  alias :th_instance_items_command_111 :command_111
  def command_111
    result = false
    case @params[0]
    when 4
      actor = $game_actors[@params[1]]
      if actor
        case @params[2]
        when 0  # in party
          result = ($game_party.members.include?(actor))
        when 1  # name
          result = (actor.name == @params[3])
        when 2  # Class
          result = (actor.class_id == @params[3])
        when 3  # Skills
          result = (actor.skill_learn?($data_skills[@params[3]]))
        when 4  # Weapons
          result = (actor.instance_weapons_include?(@params[3]))
        when 5  # Armors
          result = (actor.instance_armors_include?(@params[3]))
        when 6  # States
          result = (actor.state?(@params[3]))
        end
      end
    end
    @branch[@indent] = result

    # none of them passed, so let's check the other conditions
    th_instance_items_command_111 if !result
  end
end

class Game_Actor < Game_Battler
  
  alias :th_instance_items_init_equips :init_equips
  def init_equips(equips)
    @equips = Array.new(equip_slots.size) { Game_BaseItem.new }
    instance_equips = check_instance_equips(equips)
    th_instance_items_init_equips(instance_equips)
  end
  
  #-----------------------------------------------------------------------------
  # Replace all initial equips with instances
  #-----------------------------------------------------------------------------
  def check_instance_equips(equips)
    new_equips = []
    equips.each_with_index do |item_id, i|
      etype_id = index_to_etype_id(i)
      slot_id = empty_slot(etype_id)
      if etype_id == 0
        equip = $data_weapons[item_id]
      else
        equip = $data_armors[item_id]
      end
      new_equips << InstanceManager.get_instance(equip)
    end
    return new_equips.collect {|obj| obj ? obj.id : 0}
  end
  
  alias :th_instance_items_change_equip :change_equip
  def change_equip(slot_id, item)
    new_item = item
    if item && InstanceManager.instance_enabled?(item) && $game_party.has_item?(item) && item.is_template?
      new_item = $game_party.find_instance_item(item)
    end
    th_instance_items_change_equip(slot_id, new_item)
  end
  
  alias :th_instance_items_trade_item_with_party :trade_item_with_party
  def trade_item_with_party(new_item, old_item)    
    if new_item && InstanceManager.instance_enabled?(new_item) && $game_party.has_item?(new_item) && new_item.is_template?
      new_item = $game_party.find_instance_item(new_item)
    end
    th_instance_items_trade_item_with_party(new_item, old_item)
  end
  
  #-----------------------------------------------------------------------------
  # New.
  #-----------------------------------------------------------------------------
  def instance_weapons_include?(id)
    weapons.any? {|obj| obj.template_id == id } 
  end

  #-----------------------------------------------------------------------------
  # New.
  #-----------------------------------------------------------------------------
  def instance_armors_include?(id)
    armors.any? {|obj| obj.template_id == id } 
  end
end

class Game_Party < Game_Unit
  
  alias :th_instance_items_init_all_items :init_all_items
  def init_all_items
    th_instance_items_init_all_items
    @item_list = []
    @weapon_list = []
    @armor_list = []
  end
  
  #-----------------------------------------------------------------------------
  # Overwrite. We already keep a list of weapons
  #-----------------------------------------------------------------------------
  alias :th_instance_items_weapons :weapons
  def weapons
    TH::Instance_Items::Enable_Weapons ? @weapon_list.clone : th_instance_items_weapons
  end
  
  #-----------------------------------------------------------------------------
  # Overwrite.
  #-----------------------------------------------------------------------------
  alias :th_instance_items_items :items
  def items
    TH::Instance_Items::Enable_Items ? @item_list.clone : th_instance_items_items
  end

  #-----------------------------------------------------------------------------
  # Overwrite.
  #-----------------------------------------------------------------------------
  alias :th_instance_items_armors :armors
  def armors
    TH::Instance_Items::Enable_Armors ? @armor_list.clone : th_instance_items_armors
  end
  
  #-----------------------------------------------------------------------------
  # Returns true if the item type supports instances
  #-----------------------------------------------------------------------------
  def instance_enabled?(item)
    return InstanceManager.instance_enabled?(item)
  end
  
  #-----------------------------------------------------------------------------
  # Returns an instance for the given item. If it is already an instance, then
  # we just return that. If it's a template, we create a new instance.
  #-----------------------------------------------------------------------------
  def get_instance(item)
    return InstanceManager.get_instance(item)
  end
  
  #-----------------------------------------------------------------------------
  # Returns the template for the given item
  #-----------------------------------------------------------------------------
  def get_template(item)
    return InstanceManager.get_template(item)
  end
  
  #-----------------------------------------------------------------------------
  # The gain item method performs various checks on the item that you want to
  # add to the inventory. Namely, it checks whether it is a template item or
  # an instance item, updates the item counts, and so on.
  #-----------------------------------------------------------------------------
  alias :th_instance_items_gain_item :gain_item
  def gain_item(item, amount, include_equip = false)
    # special check for normal items
    if !instance_enabled?(item)
      th_instance_items_gain_item(item, amount, include_equip)
    else
      if item
        if amount > 0
          amount.times do |i|
            new_item = get_instance(item)
            add_instance_item(new_item)
          end
        else
          amount.abs.times do |i|
            item_template = get_template(item)
            if item.is_template?
              # remove using template rules. If an item was lost, then decrease
              # template count by 1.
              lose_template_item(item, include_equip)
            else
              # remove the instance item, and decrease template count by 1
              lose_instance_item(item)
            end
          end
        end
      else
        th_instance_items_gain_item(item, amount, include_equip)
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # New. Returns the appropriate container list
  #-----------------------------------------------------------------------------
  def item_container_list(item)
    return @item_list if item.is_a?(RPG::Item)
    return @weapon_list if item.is_a?(RPG::Weapon)
    return @armor_list if item.is_a?(RPG::Armor)
  end
  
  #-----------------------------------------------------------------------------
  # New. Adds the instance item to the appropriate list
  #-----------------------------------------------------------------------------
  def add_instance_item(item)
    container = item_container(item.class)
    container[item.template_id] ||= 0
    container[item.template_id] += 1
    container[item.id] = 1
    container_list = item_container_list(item)
    container_list.push(item)
  end
  
  #-----------------------------------------------------------------------------
  # New. Returns an instance item that matches the template. If it doesn't
  # exist, returns nil
  #-----------------------------------------------------------------------------
  def find_instance_item(template_item)
    container_list = item_container_list(template_item)
    return container_list.find {|obj| obj.template_id == template_item.template_id }
  end
  
  #-----------------------------------------------------------------------------
  # New. Lose an instance item. Simply delete it from the appropriate container
  # list
  #-----------------------------------------------------------------------------
  def lose_instance_item(item)
    container = item_container(item.class)
    container[item.template_id] ||= 0
    container[item.template_id] -= 1
    container[item.id] = 0
    container_list = item_container_list(item)
    container_list.delete(item)
  end
  
  #-----------------------------------------------------------------------------
  # New. Lose a template item. This looks for a
  #-----------------------------------------------------------------------------
  def lose_template_item(item, include_equip)
    container_list = item_container_list(item)
    item_lost = container_list.find {|obj| obj.template_id == item.template_id }
    if item_lost
      container = item_container(item.class)
      container[item.template_id] ||= 0
      container[item.template_id] -= 1
      container_list.delete(item_lost)
    elsif include_equip
      discard_members_template_equip(item, 1)
    end
    return item_lost
  end

  #-----------------------------------------------------------------------------
  # New. Same as discarding equips, except we follow template discard rules
  #-----------------------------------------------------------------------------
  def discard_members_template_equip(item, amount)
    n = amount
    members.each do |actor|
      item = actor.equips.find {|obj| obj && obj.template_id == item.template_id }
      while n > 0 && item
        actor.discard_equip(item)
        n -= 1
      end
    end
  end
end

class Window_ItemList < Window_Selectable
  
  alias :th_instance_items_draw_item_number :draw_item_number
  def draw_item_number(rect, item)
    th_instance_items_draw_item_number(rect, item) if item.is_template?     
  end
end

#===============================================================================
# Compatibility with Core Equip Slots
#===============================================================================
if $imported["TH_CoreEquipSlots"]
  class Game_Actor < Game_Battler
    
    def init_equips(equips)
      @equips = Array.new(initial_slots.size) {|i| Game_EquipSlot.new(initial_slots[i]) }
      instance_equips = check_instance_equips(equips)
      th_instance_items_init_equips(instance_equips)
    end
  end
end