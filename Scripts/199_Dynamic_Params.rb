#============================================================================
# DYNAMIC FEATURES
# v1.00 by Shaz
#----------------------------------------------------------------------------
# This script allows you to add and delete features for Actors, Classes,
# Weapons, Armors and States, dynamically, without requiring custom states
# set up for the sole purpose of granting or changing features.
# Skills and Items also have features due to inheritance, but they're not
# used by Ace, so while the script will allow you to set them up, there's
# really not much of a point in doing it.
#----------------------------------------------------------------------------
# To Install:
# Copy and paste into a new slot in materials, below all other scripts
#----------------------------------------------------------------------------
# To Use:
# Enter one of the following as a Call Script event command
#
# add_feature(class, id, feature_code, data_id[, value])
# remove_feature(class, id, feature_code, data_id[, value])
# get_feature(class, id, feature_code, data_id)
#
# Parameters:
# class - this is a symbol, and should be one of :actor, :class, :skill, :item,
#         :weapon, :armor, :state
# id    - this is the id of the object you want to change (an actor id, or a
#         weapon id, for example)
# feature_code - this is a code to indicate what feature to change.  It is a
#                symbol, and should be one of :element_rate, :debuff_rate,
#                :state_rate, :state_resist, :param, :xparam, :sparam,
#                :atk_element, :atk_state, :atk_speed, :atk_times, :stype_add,
#                :stype_seal, :skill_add, :skill_seal, :equip_wtype,
#                :equip_atype, :equip_fix, :equip_seal, :slot_type,
#                :action_plus, :special_flag, :collapse_type, :party_ability
# data_id - this id refers to the drop-down list when adding features.  When
#           adjusting something represented in the database (actors, weapons,
#           etc, including elements and types in the Terms tab), it is the id
#           of that item.  When it is not something in the database (like the
#           selections on the Other tab in features), it is the number of the
#           item in the drop-down list, starting at 0 for the top item (so the
#           Party Ability for Gold Double has a data id of 4)
# value - this is only necessary for features where you set a numeric value.
#         Percentages should be sent as a decimal (so 75% is 0.75, not 75).
#         This is optional for the remove_feature call, and when left out, ANY
#         features for that code and data id will be removed.
#
# get_feature will return nil if a value is not found for that feature.
#----------------------------------------------------------------------------
# Terms:
# Use in free and commercial games
# Credit Shaz
#===========================================================================

module DataManager
  class << self; 
    alias shaz_dynamic_features_create_game_objects create_game_objects
    alias shaz_dynamic_features_make_save_contents make_save_contents
    alias shaz_dynamic_features_extract_save_contents extract_save_contents
  end
  #--------------------------------------------------------------------------
  # * Create Game Objects
  #--------------------------------------------------------------------------
  def self.create_game_objects
    shaz_dynamic_features_create_game_objects
    $game_features      = {}
  end
  #--------------------------------------------------------------------------
  # * Create Save Contents
  #--------------------------------------------------------------------------
  def self.make_save_contents
    contents = shaz_dynamic_features_make_save_contents
    contents[:features]      = $game_features ? $game_features : {}
    contents
  end
  #--------------------------------------------------------------------------
  # * Extract Save Contents
  #--------------------------------------------------------------------------
  def self.extract_save_contents(contents)
    shaz_dynamic_features_extract_save_contents(contents)
    $game_features      = contents[:features] ? contents[:features] : {}
  end
end

class RPG::BaseItem
  @@feature_code = {
    :element_rate  => 11,              # Element Rate
    :debuff_rate   => 12,              # Debuff Rate
    :state_rate    => 13,              # State Rate
    :state_resist  => 14,              # State Resist
    :param         => 21,              # Parameter
    :xparam        => 22,              # Ex-Parameter
    :sparam        => 23,              # Sp-Parameter
    :atk_element   => 31,              # Atk Element
    :atk_state     => 32,              # Atk State
    :atk_speed     => 33,              # Atk Speed
    :atk_times     => 34,              # Atk Times+
    :stype_add     => 41,              # Add Skill Type
    :stype_seal    => 42,              # Disable Skill Type
    :skill_add     => 43,              # Add Skill
    :skill_seal    => 44,              # Disable Skill
    :equip_wtype   => 51,              # Equip Weapon
    :equip_atype   => 52,              # Equip Armor
    :equip_fix     => 53,              # Lock Equip
    :equip_seal    => 54,              # Seal Equip
    :slot_type     => 55,              # Slot Type
    :action_plus   => 61,              # Action Times+
    :special_flag  => 62,              # Special Flag
    :collapse_type => 63,              # Collapse Effect
    :party_ability => 64,              # Party Ability
    #-------------------------------------------------------
    
  }
  
  def features
    if $game_features && $game_features[class_symbol] && 
        $game_features[class_symbol][@id]
      $game_features[class_symbol][@id]
    else
      @features
    end
  end
  
  def clone_features
    $game_features = {} if !$game_features
    $game_features[class_symbol] = {} if !$game_features[class_symbol]
    $game_features[class_symbol][@id] = @features.dup if 
      !$game_features[class_symbol][@id]
  end
  
  def add_feature(code, data_id, value)
    clone_features
    $game_features[class_symbol][@id].push(RPG::BaseItem::Feature.new(
      @@feature_code[code], data_id, value))
  end
  
  def remove_feature(code, data_id, value)
    clone_features
    i = $game_features[class_symbol][@id].length - 1
    while i >= 0
      f = $game_features[class_symbol][@id][i]
      $game_features[class_symbol][@id].delete_at(i) if 
        f.code == @@feature_code[code] && f.data_id == data_id && 
          (f.value == value || value.nil?)
      i -= 1
    end
  end
  
  def get_feature(code, data_id)
    features.each { |feature|
      return feature.value if feature.code == @@feature_code[code] && 
        feature.data_id == data_id
    }
    return nil
  end
  
  def class_symbol
    case self.class.to_s
      when /Actor/i;  :actor
      when /Class/i;  :class
      when /Skill/i;  :skill
      when /Item/i;   :item
      when /Weapon/i; :weapon
      when /Armor/i;  :armor
      when /State/i;  :state
    end
  end
end

class Game_Interpreter
  def get_class_object(cls, id)
    obj = nil
    case cls
      when :actor;  obj = $data_actors[id]
      when :class;  obj = $data_classes[id]
      when :skill;  obj = $data_skills[id]
      when :item;   obj = $data_items[id]
      when :weapon; obj = $data_weapons[id]
      when :armor;  obj = $data_armors[id]
      when :state;  obj = $data_states[id]
    end
    obj
  end
    
  def add_feature(cls, id, feature_code, data_id, value = 0)
    get_class_object(cls, id).add_feature(feature_code, data_id, value)
  end
  
  def remove_feature(cls, id, feature_code, data_id, value = nil)
    get_class_object(cls, id).remove_feature(feature_code, data_id, value)
  end
  
  def get_feature(cls, id, feature_code, data_id)
    get_class_object(cls, id).get_feature(feature_code, data_id)
  end
end