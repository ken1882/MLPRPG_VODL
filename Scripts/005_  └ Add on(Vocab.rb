#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================
# tag: translate
module Vocab
  
  # BlockChain Node Name
  Player         = "Player"
  Coinbase       = "Equestria"
  
  # Tactic processing
  Pause           = "Paused"
  Unpause         = "Unpaused"
  
  # Title Screen
  NewGame         = "Start a new story"
  LoadGame        = "Continue your journey"
  ShutDown        = "Crashing back to your OS"
  
  # Connections
  Connection      = "Connecting...Your game will have no response for few minutes, please wait..."
  
  # Exit Info
  ExitConfirm     = "Are you really want to leave? Ponies will miss you..."
  
  None            = "<None>"  
  Type            = "Type"
  
  Quest           = "Quest Journal"
  QuestUpdated    = "Your journal has been updated: %s"
  
  LevelUp         = "Level Up"
  Skilltree       = "Skill Tree"
  
  InitLoadingMsg  = "To ensure your best gameplay experience, please close the app that will consume your system resource, such as Flash, Youtube and other games."
  Unavailable     = "Not available yet"
  
  TransferGather  = "You must gather your party before venturing forth"
  TransferCombat  = "You can't change location during the combat"
  
  SaveDec         = "Save your game progess"
  SystemDec       = "Change options or leave current game"
  
  CritialMiss     = "%s - critical miss"
  CritialHit      = "%s - critical hit"
  AttackImmune    = "%s: %s immune to my damage"
  Ineffective     = "%s - weapon ineffective"
end
#==============================================================================
# ** Vocab::SaveLoad
#------------------------------------------------------------------------------
#   Message in SnL load screen
#==============================================================================
module Vocab::SaveLoad
  
  ACTION_LOAD   = "Load"           # Text used for loading games.
  ACTION_SAVE   = "Save"           # Text used for saving games.
  ACTION_DELETE = "Delete"         # Text used for deleting games.
    
  # These text settings adjust what displays in the help window.
  SELECT_HELP = "Select a savefile..."
  LOAD_HELP   = "Load saved game progress"
  SAVE_HELP   = "Save current game progress"
  DELETE_HELP = "Delete this savefile"
    
  EMPTY_TEXT = "~No Data~"      # Text used when no save data is present.
  PLAYTIME   = "Play time"          # Text used for total playtime.
  TOTAL_SAVE = "Times saved: "     # Text used to indicate total saves.
  TOTAL_GOLD = "βits: "      # Text used to indicate total gold.
  LOCATION   = "Location: "        # Text used to indicate current location.
  
end
#==============================================================================
# ** Vocab::Equipment
#------------------------------------------------------------------------------
#   Vocab that related to equipments and params
#==============================================================================
module Vocab::Equipment
  
  Weapon    = "Weapon"
  Shield    = "Shield"
  Head      = "Head"
  Body      = "Body"
  Accessory = "Accessory"
  Cloak     = "Cloak"
  Necklace  = "Necklace"
  Boots     = "Boots"
  Rune      = "Rune"
  Gem       = "Gem"
  Ammo      = "Ammo"
  
  WeaponDMG = "Weapon Damage"
  AmmoDMG   = "Ammo Damage"
  Speed     = "Speed"
  
  Thac0     = "Attack Bonus"
  AC        = "Armor Class"
  Damage    = "Damage"
  Range     = "Range"
  SType     = "Skill Type"
  Cost      = "EP Cost"
  Cooldown  = "Cooldown"
  Save      = "Save"
  
  Remove    = "<Remove Equip>"
  Empty     = "<Empty>"
  
  None      = "None"
  Type      = "Type"
  
  Melee     = "Melee"
  Magic     = "Magic"
  Ranged    = "Ranged"
  
  CastingTime = "Casting Time"
  SavingThrow = "Saves"
  
  SavingName = {
    :halfdmg  => "1/2",
    :nullify  => "Neg.",
    :none     => "None",
    nil       => "None",
  }
  
end
#==============================================================================
# ** Vocab::System
#------------------------------------------------------------------------------
#   System option vocabs
#==============================================================================
module Vocab::System
  
  WarCry        = "Way cry"
  WarCryDec     = "Character voices when enter the battle and other actions"
  Difficulty    = "Combat Difficulty"
  DifficultyDec = "Change the combat difficulty, Hp/Damage multipler: Easy: 0.5x/0.8x, \n" + 
                  "Normal: 1x/1x, Hard:1.5x/1.2x, Expert: 2x/1.5x"
                  
  BGM           = "BGM Volume"
  BGMDec        = "Adjust the volume of Background music\n" + "You can drag the meter by mouse to change the value"
  BGS           = "BGS Volume"
  BGSDec        = "Adjust the volume of Background sound\n" + "You can drag the meter by mouse to change the value"
  SE            = "SE Volume"
  SEDec         = "Adjust the volume of SFX\n" + "You can drag the meter by mouse to change the value"
  
  ToTitle       = "Back to Title"
  ToTitleDec    = "Leave current game and back to title screen, please don't forget to save"
  
  ShutDown      = "Shutdown"
  ShutDownDec   = "Close the game, please don't forget to save"
  
  UnsavedInfo   = "Unsaved progress will be lost, continue?"
  
  Overwrite     = "Selected file will be overwritten, continue?"
  Delete        = "Are you reaaly wanna delete this file?"
end
#==============================================================================
# ** Vocab::Errno
#------------------------------------------------------------------------------
#   Message displayed when an error occurred
#==============================================================================
module Vocab::Errno
  
  LoadErr         = "An error occurred while loading the file, please submit %s\n to the developers"
  SaveErr         = "An error occurred while saving the file:\n%s, please submit %s to the developers and try again later"
  
  Exception       = "An error occurred during the gameplay, please submit \"ErrorLog.txt\" to the developers in order to resolve the problem.\n"
  ScriptErr       = "An error occurred while executing the event script: %s\nplease submit %s to the developers"
  
  GiftCodeFailed  = "Gift code verify failed: %s"
  ProgramMissing  = "Program missing: "
  
  
  APIErr          = "An error occurred while calling API:\n%s"
  
  APISymbol_Table = {
    true               => "Success!",
    :json_failed       => "Configuration file build failed",
    :connection_failed => "Internet connection failed",
    :invalid_code      => "Your code has been used or invalid",
    :close_failed      => "Gateway close error",
    :decrypt_failed    => "File decryption failed",
    false              => "Hmm...IDK, please contact the developers!",
  }
  
  RunTimeErr  = "  An Error has occurred during gameplay: %s %s"
  
  RESymbol_Table = {
    :bits_incorrect   => "Bits amount asynchronous with Block Chain",
    :fileid_overflow  => "Object id overflow while convert to savefile format",
    :item_unconsumed  => "Consumable Item can't be consumed",
    :int_overflow     => "Integer Overflow",
    :datatype_error   => "Data Type Error:\n",
    :nil_block        => "Block nil miner",
    :chain_broken     => "Block Chain Error:\n",
    :illegel_value    => "Illegel value:\n",
    :checksum_failed  => "File CheckSum failure",
    :file_missing     => "File missing:\n",
    :tactic_sym_missing => "Tactic command symbol unavailable:\n",
    :secure_hash_failed => "Security hash match failed:\n",
  }
  
end
#==============================================================================
# ** Vocab::Status
#------------------------------------------------------------------------------
#   Message displayed when on the status menu
#==============================================================================
module Vocab::Status
  
  General         = "General"
  Property        = "Properties"
  Tactic          = "Tactics"
  Leveling        = "Level up"
  
  Parameter       = "Parameters"
  Experience      = "Experience"
  Next_Lv_Total   = "Next %s Total EXP"
  
  StrAth    = "Athletics"
  DexAcr    = "Acrobatics"
  DexSle    = "Sleight of Hand"
  DexSte    = "Stealth"
  IntArc    = "Arcana"
  IntHis    = "History"
  IntInv    = "Investigation"
  IntNat    = "Nature"
  IntRel    = "Religion"
  WisAni    = "Animal Handling"
  WisIns    = "Insight"
  WisMed    = "Medicine"
  WisPer    = "Perception"
  WisSur    = "Survival"
  ChaDec    = "Deception"
  ChaInt    = "Intimidation"
  ChaPerf   = "Performance"
  ChaPers   = "Persuasion"
end
#==============================================================================
# ** Vocab::Party
#------------------------------------------------------------------------------
#   Message displayed on the Scene_Party
#==============================================================================
module Vocab::Party
  Change      = "Change"
  Remove      = "Remove"
  Revert      = "Revert"
  Finish      = "Finish"
  TextEmpty   = "-No pony-"
  TextRemove  = "-Remove-"
  TextEquip   = "Gear"
  
  GoldGain    = "Party has %s βits: %s%s"
  ItemGain    = "Party has %s an item(x%s)"
  EXPGain     = "Party has gained xp: %d"
  BCGain      = "Party has gained block chain reward: %s"
  
  Limited     = "(max amount reached)"
  WordGain    = "gained"
  WordLost    = "lost"
end
#==============================================================================
# ** Vocab::Tactic
#------------------------------------------------------------------------------
#   Message about the tactic processes
#==============================================================================
module Vocab::Tactic
  CmdMove     = "Move to"
  CmdFollow   = "Follow"
  CmdGuard    = "Guard"
  CmdPatrol   = "Patrol"
  CmdMoving   = ":Move"
  CmdHolding  = ":Hold"
  CmdMHing    = "Hold/Move"
  
  HelpMove    = "Select a location to move, or an enemy to attack."
  HelpSel     = "Select a location"
  
  DecMove     = "Move to a position or attack an enemy"
  DecMHing    = "Press to toggle between hold/moving"
  DecReaction = "Toggle between combat reactions"
  DecFollow   = "Follow a character"
  DecGuard    = "Protect a character"
  DecPatrol   = "Guard an area"
  
  Targeting   = 'Enemies'
  Fighting    = 'Target fighting'
  Self        = 'Self and party'
  Item        = 'Items'
  Skill       = 'Skills'
  General     = 'General'
  EdCondition = 'Edit condition'
  EdAction    = 'Edit Action'
  Delete      = "Delete"
  
  Name_Table  = {
    :attack_mainhoof      => "Use main-hoof attack",
    :attack_offhoof       => "Use off-hoof attack",
    :add_command          => "Add a new tactic logic",
    :target_none          => "Set target to none",
    :hp_most_power        => "Use Hp potion: most powerful",
    :hp_least_power       => "Use Hp potion: least powerful",
    :ep_most_power        => "Use Ep potion: most powerful",
    :ep_least_power       => "Use Ep potion: least powerful",
    :set_target           => "Set to primary target",
    :jump_to              => "Jump to tactic: ",
  }
end
#==============================================================================
# ** Vocab::TacticConfig
#------------------------------------------------------------------------------
#   Text info of tactic commands
#==============================================================================
module Vocab::TacticConfig
  
  Name_Table = {
    :lowest_hp              => "Lowest HP",
    :highest_hp             => "Highest HP",
    :has_state              => "Has state:",
    :nearest_visible        => "Nearest visible",
    :attacking_ally         => "Attacking ally:",
    :target_of_ally         => "Target of ally:",
    :rank                   => "Rank:",
    
    :any                    => "Any",
    :clustered              => "Clustered:",
    :hp_lower               => "Hp lower than:",
    :hp_higher              => "Hp higher than:",
    :target_range           => "At ragne:",
    :target_atk_type        => "Attack type:",
    
    :ep_lower               => "EP lower than:",
    :being_attacked_by_type => "Hurt by attack type:",
    
    :enemies_alive          => "X Enemies alive:",
    :allies_alive           => "X Team member alive:",
    :allies_dead            => "X Team member K.O.:",
    :surrounded_by_enemies  => "Surrounded by X enemies:",
    :using_attack_type      => "Main-hoof attack type:",
    
    :attack_mainhoof        => "Main-hoof attack",
    :attack_offhoof         => "Off-hoof attack",
    :target_none            => "Set target to none",
    :hp_most_power          => "Use hp potion: most powerful",
    :hp_least_power         => "Use hp potion: least powerful",
    :ep_most_power          => "Use ep potion: most powerful",
    :ep_least_power         => "Use ep potion: least powerful",
    
    :set_target             => "Set to primary target",
    :jump_to                => "Jump to tactic:",
    
    :enemies      => "Enemies:",
    :targeting    => "Enemies:",
    :target       => "Target:",
    :fighting     => "Target:",
    :self         => "Self:",
    :new_command  => "<Add New Tactic>",
    
    :short      => "Short",
    :medium     => "Medium",
    :long       => "Long",
    
    :critter    => "Critter",
    :minion     => "Minion",
    :elite      => "Elite",
    :boss       => "Boss",
    :chief      => "Chief",
    
    :melee      => "Melee",
    :ranged     => "Ranged",
    :magic      => "Magic/Casting",
  }
  
  InputHelp = {
    :attacking_ally => "Select a team member",
    :target_of_ally => "Select a team member",
    :has_state    => "Select a state",
    :rank         => "Select a rank",
    :hp_lower     => "Please enter the percentage, press Enter ot finish, ESC to abort",
    :hp_higher    => "Please enter the percentage, press Enter ot finish, ESC to abort",
    :ep_lower     => "Please enter the percentage, press Enter ot finish, ESC to abort",
    :target_range => "Select a scale",
    :target_atk_type  => "Select a type",
    :being_attacked_by_type => "Select a type",
    :using_attack_type      => "Select a type",
    :clustered              => "Enter a number, operator is greater or equal",
    :enemies_alive          => "Enter a number, operator is greater or equal",
    :allies_alive           => "Enter a number, operator is greater or equal",
    :allies_dead            => "Enter a number, operator is greater or equal",
    :surrounded_by_enemies  => "Enter a number, operator is greater or equal",
  }
  
  ArgDec_Table = {
    :has_state    => "%s",
    :rank         => "%s",
    :hp_lower     => "%d\%",
    :hp_higher    => "%d\%",
    :ep_lower     => "%d\%",
    :target_range => "at %s range",
    :target_atk_type  => "%s",
    :being_attacked_by_type => "%s",
    :using_attack_type      => "%s",
    :clustered              => "%d or more",
    :enemies_alive          => ">= %d",
    :allies_alive           => ">= %d",
    :allies_dead            => ">= %d",
    :surrounded_by_enemies  => ">= %d",
  }
  
end
#==============================================================================
# ** Vocab::Skillbar
#------------------------------------------------------------------------------
#   Text info in skillbar
#==============================================================================
module Vocab::Skillbar
  
  Follower    = "Toggle on/off Follower AI"
  AllSkill    = "All Skills"
  Vancian     = "Vancian"
  AllItem     = "All Items"
  PrevPage    = "Previous page"
  NextPage    = "Next page"
  Cancel      = "Cancel"
  None        = "<Empty>"
  
  Use         = "Use"
  Hotkey      = "Hotkey"
  Info        = "Info"
  MouseEdit   = "Now you can edit your hotkeys with mouse"
  
  SelHelp     = "Please press the hotkey(0~9) or mouse left-clicking on the slot"
  SelSucc     = "You have assigned %s on hotkey '%s'"
end
#==============================================================================
# ** Vocab::Rescue
#------------------------------------------------------------------------------
#   Text info of the rescues
#==============================================================================
module Vocab::Rescue
  Luna    = "\\af[9]\\n<Luna>Thou shall glad I followed you.."
end
