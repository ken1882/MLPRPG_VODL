#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================
module Vocab
  # tag: translate
  
  # BlockChain Node Name
  Player         = "Player"
  Coinbase       = "Equestria"
  
  # Tactic processing
  Pause           = "paused"
  Unpause         = "unpaused"
  
  # Title Screen
  NewGame         = "Start a new story"
  LoadGame        = "Continue your journey"
  ShutDown        = "Crashing back to your OS"
  
  # Connections
  Connection      = "Obtaining data from internet, your game may be no respond for about one miniute, please wait..."
  
  # Exit Confirm Info
  ExitConfirm     = "  Do you really want to leave? Ponies will miss you..."
  
  None            = "<none>"
  
end
#==============================================================================
# ** Vocab::SaveLoad
#------------------------------------------------------------------------------
#   Message in SnL load screen
#==============================================================================
module Vocab::SaveLoad
  
  ACTION_LOAD   = "讀檔"           # Text used for loading games.
  ACTION_SAVE   = "存檔"           # Text used for saving games.
  ACTION_DELETE = "刪除"         # Text used for deleting games.
    
  # These text settings adjust what displays in the help window.
  SELECT_HELP = "請選擇檔案欄位"
  LOAD_HELP   = "讀取已儲存的遊戲進度"
  SAVE_HELP   = "儲存當前遊戲進度"
  DELETE_HELP = "刪除該存檔"
    
  EMPTY_TEXT = "~沒有檔案~"      # Text used when no save data is present.
  PLAYTIME   = "遊戲時間"          # Text used for total playtime.
  TOTAL_SAVE = "儲存次數: "     # Text used to indicate total saves.
  TOTAL_GOLD = "擁有貨幣: "      # Text used to indicate total gold.
  LOCATION   = "地點: "        # Text used to indicate current location.
  
end
#==============================================================================
# ** Vocab::Equipment
#------------------------------------------------------------------------------
#   Vocab that related to equipments and params
#==============================================================================
module Vocab::Equipment
  
  Weapon    = "武器"
  Shield    = "盾牌"
  Head      = "頭部"
  Body      = "身體"
  Accessory = "飾品"
  Cloak     = "斗篷"
  Necklace  = "項鍊"
  Boots     = "靴子"
  Rune      = "符文"
  Gem       = "寶石"
  Ammo      = "彈藥"
  
  WeaponDMG = "武器傷害"
  AmmoDMG   = "彈藥傷害"
  Speed     = "速度"
  
  Thac0     = "Attack Bonus"
  AC        = "Armor Class"
  Damage    = "Damage"
  Range     = "Range"
  
  Remove    = "<Remove Equip>"
  Empty     = "<Empty>"
end
#==============================================================================
# ** Vocab::System
#------------------------------------------------------------------------------
#   System option vocabs
#==============================================================================
module Vocab::System
  
  WarCry        = "啟用戰鬥語音"
  WarCryDec     = "開關進入戰鬥時的開場白以及戰鬥時的部分語音效果"
  Difficulty    = "戰鬥難度"
  DifficultyDec = "改變戰鬥難度, 生命/傷害變化: 簡單: 0.5x/0.8x, 普通: 1x/1x\n" + 
                  "困難:1.5x/1.2x, 專家: 2x/1.5x"
                  
  BGM           = "BGM音量"
  BGMDec        = "調整背景音樂的音量, 可滑鼠拖曳數量條來改變"
  BGS           = "BGS音量"
  BGSDec        = "調整背景聲音的音量, 可滑鼠拖曳數量條來改變"
  SE            = "SE音量"
  SEDec         = "調整聲音特效的音量, 可滑鼠拖曳數量條來改變"
  
  ToTitle       = "回到標題"
  ToTitleDec    = "離開當前遊戲並回到標題畫面, 不要忘記存檔喔~"
  
  ShutDown      = "離開遊戲"
  ShutDownDec   = "離開遊戲, 不要忘記存檔喔~"
  
  UnsavedInfo   = "未儲存的進度將會遺失，確認繼續嗎?"
  
end
#==============================================================================
# ** Vocab::Errno
#------------------------------------------------------------------------------
#   Message displayed when an error occurred
#==============================================================================
module Vocab::Errno
  
  LoadErr         = "讀取檔案時發生錯誤! 請將 %s\n寄送給開發人員"
  SaveErr         = "存檔時發生錯誤:\n%s, 請將 %s 寄送給開發人員並稍後再試"
  Exception       = "遊戲運行時發生錯誤! 請將檔案\"ErrorLog.txt\"寄送給開發人員以處理錯誤.\n"
  GiftCodeFailed  = "禮物碼驗證失敗: %s"
  ProgramMissing  = "遺失程式: "
  
  APIErr          = "呼叫API過程中發生錯誤:\n%s"
  
  APISymbol_Table = {
    true               => "成功!",
    :json_failed       => "組態檔建立失敗",
    :connection_failed => "網際網路連線失敗",
    :invalid_code      => "您的代碼已經被使用過或無效",
    :close_failed      => "網路閘道關閉失敗",
    :decrypt_failed    => "檔案解密失敗",
    false              => "痾...我也不知道, 請聯絡開發人員!",
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
  Tactic          = "Tacitc"
  
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
  
  DecMove     = "Move to a position or attack an enemy"
  DecMHing    = "Press to toggle between hold/moving"
  DecReaction = "Toggle between combat reactions"
  DecFollow   = "Follow a character"
  DecGuard    = "Protect a character"
  DecPatrol   = "Guard an area"
  
  Targeting   = 'Enemy targeting'
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
    :allies_alive           => "Team member alive:",
    :allies_dead            => "Team member knocked out:",
    :surrounded_by_enemies  => "Surrounded by X enemies:",
    
    :attack_mainhoof        => "Main-hoof attack",
    :attack_offhoof         => "Off-hoof attack",
    :target_none            => "Set target to none",
    :hp_most_power          => "Use hp potion: most powerful",
    :hp_least_power         => "Use hp potion: least powerful",
    :ep_most_power          => "Use ep potion: most powerful",
    :ep_least_power         => "Use ep potion: least powerful",
  }
  
end
