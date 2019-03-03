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
  Option          = "Option"
  Credits         = "Credits"
  StartGame       = "Start"
  
  # Connections
  Connection      = "Connecting...Your game will have no response for few minutes, please wait..."
  
  # Exit Info
  ExitConfirm     = "Do you really want to leave? Ponies will miss you..."
  
  None            = "<None>"  
  Type            = "Type"
  
  Quest           = "Quest Journal"
  QuestUpdated    = "Your journal has been updated: %s"
  QuestHint       = "Use Up/Down to negative the information"
  
  LevelUp         = "Level Up"
  Skilltree       = "Skill Tree"
  Upgradeable     = "You can level-up now!"
  
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
  
  MoreInfo        = "Info"
  
  # path to database vocabulary dictionary
  DictPath        = "History/en_us"
  CategoryPath = {
    :weapon     => "/Weapons",
    :item       => "/Items",
    :armor      => "/Armors",
    :skill      => "/Skills",
    :actor      => "/Actors",
    :class      => "/Classes",
    :term       => "/Terms",
    :state      => "/States",
  }
  
  Offline = "Unable connect to internet, some features won't be available," +
            " such as Gamejolt achievement." + " If you have connected, " +
            "please re-launch the game."
            
  OfflineMode = "This feature is unavailable in offline mode. You cannot " +
                "access it until connected to internet and re-launch the game"
  #----------------------------------------------------------------------------
  VODL      = "Vengeance of Dark Lord"
  VODLHelp  = "Play the main story, help Equestria fight against the invasion " +
              "of King Sombra!"
              
  Tutorial  = "Tutorial"
  TutorialHelp = "Help you understand core features of the game and learn how " +
                 "to play & use them."
  #----------------------------------------------------------------------------
  # * Return dictionary file of language
  #----------------------------------------------------------------------------
  def self.GetDictPath(category)
    return DictPath + CategoryPath[category] + '/'
  end
  #----------------------------------------------------------------------------
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
  
  Slot      = "File %s"
  ASaveSlot = "AutoSave%s"
  QSaveSlot = "QuickSave%s"
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
  
  Language    = "Language"
  LanguageDec = "Change game language"
  
  WarCry          = "Way cry"
  WarCryDec       = "Character voices when enter the battle and other actions"
  Difficulty      = "Combat Difficulty"
  DifficultyName  = ["Novice", "Normal", "Hard", "Expert"]
  DifficultyDec   = "Change the combat difficulty, Hp/Damage multipler: Easy: 0.5x/0.8x, \n" + 
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
  Delete        = "Do you really wanna delete this file?"
  
  AutoSave          = "Auto-Save"
  AutoSaveDec       = "Auto save file if it's allowed. Save location is at the buttom\n" +
                      "of the files."
  AutoSaveCombat    = "Boss fight"
  AutoSaveCombatDec = "Auto-Save file before boss fight"
  AutoSaveStep      = "Steps"
  AutoSaveStepDec   = "Auto-save after you walked a certain steps, 0 = inactive"
  
  Restart = "Options will be applied after restart the game"
end
#==============================================================================
# ** Vocab::Errno
#------------------------------------------------------------------------------
#   Message displayed when an error occurred
#==============================================================================
CurrentLanguage = :en_us
module Vocab::Errno
  
  LoadErr         = "An error occurred while loading the file, please submit %s\n to the developers"
  SaveErr         = "An error occurred while saving the file:\n%s, please submit %s to the developers and try again later"
  
  Exception       = "An error occurred during the gameplay, please submit \"ErrorLog.txt\" to the developers in order to resolve the problem.\n"
  ScriptErr       = "An error occurred while executing the event script: %s\nplease submit %s to the developers"
  
  GiftCodeFailed  = "Gift code verify failed: %s"
  ProgramMissing  = "Program missing: "
  
  PluginInitErr   = "Failed to initialize plugins: #{}" #tag: todo
  PluginLoadErr   = "Failed to load some plugins, please send 'PluginErr.txt' to developer to resolve this bug."
  
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
    :config_error       => "Script configuration error:\n",
    :gib_nil_handler    => "InteractiveButton nil handler called\n",
  }
  
  SequenceArgError = "%s has at least %d args, received %d\n"
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
  
  Targeting   = 'Visible Enemies'
  Fighting    = 'Target fighting'
  Self        = 'Self'
  Item        = 'Items'
  Skill       = 'Skills'
  General     = 'General'
  EdCondition = 'Edit condition'
  EdAction    = 'Edit Action'
  Delete      = "Delete"
  
  Hints = [
    "Notice: Bot tactic will only works when the party AI is enabled [press 'C'",
    "(default) in map scene to toggle it].",
    "You can see the detailed information of all commands available in Player's",
    "handbook",
    "--------------------------------------------------------------------------",
    "You can add up to 20 commands for each character, and the command will",
    "works if and only if both condition and action is assigned.",
    "If the command id is \\c[18]Red\\c[0], it's an invalid command, and \\c[29]Green\\c[0] is a valid one.",
    "You can toggle enable/disable the command by press \\c[23]CTRL\\c[0], if the command",
    "is disabled, the id color will be \\c[15]Black.",
    "Conditions won't be checked if the command is invalid or disabled, but \\c[10]the",
    "\\c[10]command accessed by 'Jump to Tactic' is not affected by disabling it.",
    "",
    "The priority of the command is from lower to higher according to its id.",
    "So if multiple command condition is meet, the one with higher id will be",
    "executed first; meanwhile AI will always prefer taking the action which",
    "could causing effects to the target(including parties) instantly.",
    "",
    "To change the priority(id) of the command, press \\c[23]SHIFT\\c[0] then negative it",
    "with cursor to the position you want; once you done, press \\c[23]shift/ok\\c[0] to",
    "exit editing.",
    "",
  ]
  
  Help     = "No idea what's this? Press F4 for help"
  SwapHelp = "Negative the cursor to swap order"
  
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
    :jump_to              => "Jump to tactic:",
    :move_away            => "Move away from target",
    :move_close           => "Move close to target",
    :player               => "Player",
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
    :target_range           => "At range:",
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
    :move_away            => "Move away from target",
    :move_close           => "Move close to target",
    
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
    :captain    => "Captain",
    :chief      => "Chief",
    
    :melee      => "Melee",
    :ranged     => "Ranged",
    :magic      => "Magic/Casting",
    
    :player => "Player"
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
    :jump_to                => "Select the id of the command..."
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
    :short      => "Short",
    :medium     => "Medium",
    :long       => "Long",
    :player     => "Player",
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
# ** Vocab::Debug
#------------------------------------------------------------------------------
#   Texts for Debug window
#==============================================================================
module Vocab::Debug
  
  Hint    = "Press Q/E(Pageup/Pagedown) to change category"
  
  Switch   = "This is list of available switches\n" + Hint
  Variable = "This is list of available variables\n" + Hint
  Sprite   = "This is list of undisposed bitmaps from last scene\n" + Hint
  
  SwitchHelp   = "C (Enter) : ON / OFF"
  VariableHelp = "← (Left)    :  -1\n"  + "→ (Right)   :  +1\n" +
                 "L (Pageup)   : -10\n" + "R (Pagedown) : +10"
                 
  SpriteHelp   = "Using WASD/↑←↓→ to negative the graph"
  
end
#==============================================================================
# ** Vocab::Leveling
#------------------------------------------------------------------------------
#   Text info about level up
#==============================================================================
module Vocab::Leveling
  
  Helps = {
    :level_up   => "Level up!",
    :unique     => "Unique skills of this character",
    :race       => "Race skills",
    :class      => "Class skills",
    :dualclass  => "Dual-class skills",
    :skilltree  => "Open the skill tree and manage available skills",
    :level_up_main => "Advance your main class to next level",
    :level_up_dual => "Advance your dual-class to next level",
    :set_dualclass => "Start a dual-class",
  }
  
  DualClass  = "Dual-Class"
  SelectFeat = "New class feature available!"
  Confirm_Dualclass  = "Are you sure about becoming a %s?"
  Confirm_LearnSkill = "Do you really want to learn %s?"
end
#==============================================================================
# ** Vocab::BlockChain
#------------------------------------------------------------------------------
#   Texts about block chain stuff
#==============================================================================
module Vocab::BlockChain
  Info = {
    :split_line => "-----------------------------",
    :transinfo  => "\\c[1]Info:\\c[0] %s",
    :payment    => "Payment is from \\c[1]%s \\c[0]to\\c[1] %s",
    :currency   => "%s amount:\\c[6] %d",
    :goods      => "Item: %s x%d",
    :nogoods    => "No item was traded",
  }
  DropLoot = "Received via dropped loot"
  LargeHistory = "You're going to view a large transaction history." +
                 " This will take a while to display all item. Continue anyway?"
end
#==============================================================================
# ** Vocab::Rescue
#------------------------------------------------------------------------------
#   Text info of the rescues
#==============================================================================
module Vocab::Rescue
  Luna    = "\\af[9]\\n<Luna>Thou shall glad I followed you.."
end
