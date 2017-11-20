#==============================================================================
# ** Dungeons and Dragons
#------------------------------------------------------------------------------
#  Config: Item and features sets
#==============================================================================
#tag: config
module DND
  
  # tag: translate
  
  PARAM_NAME = [
    "None",
    "None",
    "Str",
    "Con",
    "Int",
    "Wis",
    "Dex",
    "Cha",
  ]
  
  WEAPON_TYPE_NAME = [
    "",
    "Hoof Axe",
    "Horseshoe",
    "Polearm",
    "1H Sword",
    "2H Sword",
    "Bow",
    "Crossbow",
    "Hammer",
    "Mace",
    "Firearm",
    "Arrow",
    "Bolt",
    "Bullet",
    "Mage Staff"
  ]
  
  ARMOR_TYPE_NAME = [
  "",
  "Light Armor",
  "Medium Armor",
  "Heavy Armor",
  "Clothing",
  "Shield",
  "Great Shield",
  "Hooves",
  "Belt",
  "Necklace",
  "Cloak",
  "Ring",
  "Greave",
  "Rune",
  "Gem",
  ]
  
  SKILL_TYPE_NAME = [
  "",
  "Skill",
  "Spell",
  "Vancian",
  "Passive",
  ]
  
  ELEMENT_NAME = [
  "",
  "Bludgeoning",
  "Piercing",
  "Slashing",
  "Acid",
  "Cold",
  "Fire",
  "Force",
  "Lightning",
  "Necrotic",
  "Poison",
  "Psychic",
  "Radiant",
  "Thunder",
  ]
  
  Rank  = [
    :critter,
    :minion,
    :elite,
    :boss,
    :chief,
  ]
  
  AttackType = [
    :melee,
    :magic,
    :ranged,
  ]
  
  RaceName  = [
    "Earth Pony",
    "Unicorn",
    "Pegasus",
    "Alicorn",
    "Crystal Pony",
    "Shadow Pony",
    "Seapony",
    "Zebra",
    "Donkey",
    "Changeling",
    "Buffalo",
    "Diamond Dog",
    "Griffon",
    "Minotaur",
    "Yak",
    "Deer",
    "Dragon",
    "Hippogriff",
    "Woodlands",
    "Mountains",
    "Deserts",
    "Oceans",
    "Swamps",
    "Negative Planes",
    "Mythicals",
    "Insects",
    "Skeleton",
  ]
  
  ItemParamDec = {
    :weapon => [:wtype, :speed, :range, :damage],
    :armor  => [:atype, :ac],
    :skill  => [:stype, :cost, :casting, :range, :cooldown, :save, :damage],
    :item   => [:cooldown, :range, :save, :damage],
  }
  
  module ClassID
    Barbarian   = [1, 15, 16]
    Bard        = [2, 17, 18]
    Cleric      = [3, 19, 20, 21, 22, 23, 24, 25, 26, 27]
    Druid       = [4, 28, 29, 30, 31, 32, 33, 34, 35, 36]
    Fighter     = [5, 37, 38, 39]
    Monk        = [6, 40, 41, 42]
    Paladin     = [7, 43, 44, 45]
    Ranger      = [8, 46, 47]
    Rogue       = [9, 48, 49, 50]
    Sorcerer    = [10, 51, 52, 53, 54]
    Warlock     = [11, 55, 56, 57]
    Wizard      = [12, 58, 59, 60, 61, 62, 63, 64, 65]
    
    PrimaryPathes =[
      Barbarian, Bard, Cleric, Druid, Fighter, Monk, Paladin, Ranger, Rogue,
      Sorcerer, Warlock, Wizard,
    ]
    
  end
end
