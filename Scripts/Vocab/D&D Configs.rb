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
  
  Race  = [
    "Earth Pony",
    "Unicorn",
    "Pegasus",
    "Dragon",
    "Woodlands",
    "Deer",
    "Manticore",
    
  ]
  
  ItemParamDec = {
    :weapon => [:wtype, :speed, :range, :damage],
    :armor  => [:atype, :ac],
    :skill  => [:stype, :cost, :range, :cooldown, :save, :damage],
    :item   => [:cooldown, :range, :save, :damage],
  }
  
end
