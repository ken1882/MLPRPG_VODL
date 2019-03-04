#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================
module Vocab::YEA
  ICON_HASH = {
    # Matching Text   => Icon ID,
      "New story"            => 125,    # Title scene.
      "Continue story"       => 126,    # Title scene.
      "Leave"                => 127,    # Title scene. Game End scene.
      
      "Battle"        => 386,     # Battle scene.
      "Gallop"        => 328,     # Battle scene.
      "Strike"        => 116,     # Battle scene.
      "Guard"         => 506,     # Battle scene.
      "Relic"         => 9299,
      "Relics"        => 9299,
      "Skill"         => 8175,    # Skill scene. Battle scene.
      "Skills"        => 8175,
      "Ability"       => 106,     # Skill scene. Battle scene.
      "Spells"        => 106,     # Skill scene. Battle scene.
      "Passive"       => 3193,
      "Friendship"    => 8056,
      "Learn Skills"  => 2437,
      "Songs"         => 6470,
      "Pet"           => 3316,
      "Talent"        => 10662,
      "Bio"           => 233,
      "Brew"          => 3814,
      "Science"       => 8249,
      "Summon"        => 3761,
      "Parameters"    => 228,
      "Quest"         => 1334,
      "Overview"      => 1354,
      "Saddlebag"     => 1528,     # Menu scene. Item scene. Battle scene.
      "Items"         => 1528,     # Menu scene. Item scene. Battle scene.
      "Talk"          => 4,
      "Actions"       => 143,
      "Cook"          => 2580,
      "Crafting"       => 125,
      "Skills"        => 104,      # Menu scene.
      "Log"           => 2441,
      "Books"         => 2384,
      "History"       => 2435,
      "Execute"       => 125,
      "Run"           => 172,
      "Gear"          => 524,      # Menu scene.
      "Stats"         => 1204,     # Menu scene.
      "Party"         =>  11,      # Menu scene.
      "Special"       => 775,
      "Save"          => 10675,      # Menu scene.
      "Load"          => 10674,
      "Delete"        => 10676,
      "System"        => 2144,
      "End"           => 1020,      # Menu scene.
      "Craft"         => 2059,  
      "Weapons"       => 386,      # Item scene.
      "Armors"        => 436,      # Item scene.
      "Key Items"     => 243,      # Item scene.
      "Special Items" => 243,      # Item scene.
      "Special Item"  => 243,      # Item scene.
      "To Title"      => 224,      # Game End scene.
      "Cancel"        => 119,      # Game End scene.
      "Spellbook"     => 4052,
      "Vancian"       => 10044,
      "Vancians"      => 10044,
      "Vancian Spell" => 10044,
      "Encyclopedia"  => 3734,
      "Codex"         => 2399, 
      "Bestiary"      => 3343,
      "Music Room"    => 118,
      "Talent Tree"   => 117,
      "Equip"         => 3786,
      "Add Point"     => 6476,
      "Special stuff" => 1646,
      "Buy"           => 555,
      "Sell"          => 554,
      "Properties"    => 2375,
      "General"       => 556,
      "Healings"      => 3958,
      "Ingredient"    => 200,
      "All"            => 1140,
      "Hidden Weapons" => 159,
      "Music Sheet"    => 118,
      "Book"           => 2384,
      "Scroll"         => 3733,
      "Save/Load"      => 2431,
      "Dismantle"      => 8175,
      "Gamejolt"       => 570,
      "Life Skills"    => 8075,
      "Equip Skill"    => 117,
      "Level Up"       => 8182,
      "Move to"        => 572,
      "Follow"         => 1117,
      "Patrol"         => 1114,
      "Hold/Move"      => 9301,
      ":Hold"          => 9301,
      ":Move"          => 2255,
      ":No Attack"     => 1141,
      ":Passive"       => 13,
      ":Stand Ground"  => 7346,
      ":Defensive"     => 139,
      ":Aggressive"    => 131,
      ":Striking"      => 116,
      "Tactics"        => 2103,
      "Protect"        => 506,
      "Skill Tree"     => 108,
    }
    #--------------------------------------------------------------------------
  end
  
#==============================================================================
# ** Vocab::YEA::Item
#==============================================================================
module Vocab
  module YEA::ITEM
    #--------------------------------------------------------------------------
    ITEM_TYPES = {
      :all          => "All",
      :healings     => "Healings",
      :book         => "Book",
      :scroll       => "Scroll",
      :hdweapons    => "Hidden Weapons",
      :special      => "Special",
      :ingredient   => "Ingredient",
      :music_sheet  => "Music Sheet",
      :misc         => "Misc",
    }
    #--------------------------------------------------------------------------
    WEAPON_TYPES = {
      :all      => "All",
    }
    #--------------------------------------------------------------------------  
    ARMOUR_TYPES = {
      :all      => "All",
    }
    #--------------------------------------------------------------------------
    VOCAB_STATUS = {
      :empty      => "---",          # Text used when nothing is shown.
      :hp_recover => "HP Heal",      # Text used for HP Recovery.
      :mp_recover => "MP Heal",      # Text used for MP Recovery.
      :tp_recover => "TP Heal",      # Text used for TP Recovery.
      :tp_gain    => "TP Gain",      # Text used for TP Gain.
      :applies    => "Applies",      # Text used for applied states and buffs.
      :removes    => "Removes",      # Text used for removed states and buffs.
    } # Do not remove this.
    #--------------------------------------------------------------------------
  end
end
