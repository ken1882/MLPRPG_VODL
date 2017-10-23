#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================
module Vocab
  # tag: translate
  
  # Shop Screen
  ShopBuy         = "購買"
  ShopSell        = "售出"
  ShopCancel      = "取消"
  Possession      = "擁有"
  # Status Screen
  ExpTotal        = "當前經驗"
  ExpNext         = "下級所需經驗 %s"
  # Save/Load Screen
  SaveMessage     = "要儲存到哪個檔案呢?"
  LoadMessage     = "要讀取到哪個檔案呢?"
  File            = "檔案"
  # Display when there are multiple members
  PartyName       = "%s's 隊伍"
  
  # BlockChain Node Name
  Player         = "Player"
  Coinbase       = "Equestria"
  
  # Tactic processing
  Pause           = "暫停"
  Unpause         = "解除暫停"
  
  # Title Screen
  NewGame         = "開始新的故事"
  LoadGame        = "繼續您的旅程"
  ShutDown        = "崩潰到桌面"
  
  # Connections
  Connection      = "連線中...遊戲程式可能會沒有回應數分鐘, 請耐心等待"
  
  # Exit Info
  ExitConfirm     = "你真的要離開嗎? 小馬們會想念你的..."
  
  None            = "<無>"
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
  Ammo      = "彈藥"
  
  WeaponDMG = "武器傷害"
  AmmoDMG   = "彈藥傷害"
  Speed     = "速度"
  
  Thac0     = "攻擊骰加成"
  AC        = "護甲等級"
  Damage    = "傷害"
  Range     = "距離"
  
  Remove    = "<卸下裝備>"
  Empty     = "<無>"
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
  
  General         = "概覽"
  Property        = "屬性"
  Tactic          = "戰術"
  
  Parameter       = "能力點"
  Experience      = "經驗值"
  Next_Lv_Total   = "下級所需經驗 %s"
  
  StrAth    = "體育"
  DexAcr    = "雜技"
  DexSle    = "巧手"
  DexSte    = "潛行"
  IntArc    = "奧術"
  IntHis    = "歷史"
  IntInv    = "偵查"
  IntNav    = "自然"
  IntRel    = "宗教"
  WisAni    = "動物"
  WisIns    = "洞察"
  WisMed    = "醫學"
  WisPer    = "感知"
  WisSur    = "生存"
  ChaDec    = "詐術"
  ChaInt    = "威嚇"
  ChaPerf   = "表演"
  ChaPers   = "說服"
end
#==============================================================================
# ** Vocab::Party
#------------------------------------------------------------------------------
#   Message displayed on the Scene_Party
#==============================================================================
module Vocab::Party
  Change      = "變更"
  Remove      = "移除"
  Revert      = "復原"
  Finish      = "完成"
  TextEmpty   = "- 空 -"
  TextRemove  = "-移除-"
  TextEquip   = "裝備"
end
#==============================================================================
# ** Vocab::Tactic
#------------------------------------------------------------------------------
#   Message about the tactic processes
#==============================================================================
module Vocab::Tactic
  CmdMove     = "移動到"
  CmdFollow   = "跟隨"
  CmdGuard    = "保護"
  CmdPatrol   = "巡邏"
  CmdMoving   = ":移動"
  CmdHolding  = ":停止"
  CmdMHing    = "移動/停止"
  
  DecMove     = "移動到一定點或攻擊敵人"
  DecMHing    = "按鍵切換是否移動"
  DecReaction = "按鍵切換戰鬥反應模式"
  DecFollow   = "跟隨目標"
  DecGuard    = "保護目標"
  DecPatrol   = "巡邏區域"
  
  Targeting   = '設為目標的條件'
  Fighting    = '戰鬥目標條件'
  Self        = '隊伍/自身條件'
  Item        = '物品'
  Skill       = '技能'
  General     = '一般'
  EdCondition = '更改條件'
  EdAction    = '更改動作'
  Delete      = "刪除"
  
  Name_Table  = {
    :attack_mainhoof      => "使用主武器",
    :attack_offhoof       => "使用副武器",
    :add_command          => "新增戰術",
    :target_none          => "放棄當前目標",
    :hp_most_power        => "使用生命藥水: 最強效",
    :hp_least_power       => "使用生命藥水: 最弱效",
    :ep_most_power        => "使用能量藥水: 最強效",
    :ep_least_power       => "使用能量藥水: 最弱效",
  }
end
#==============================================================================
# ** Vocab::TacticConfig
#------------------------------------------------------------------------------
#   Text info of tactic commands
#==============================================================================
module Vocab::TacticConfig
  
  Name_Table = {
    :lowest_hp              => "最低生命比",
    :highest_hp             => "最高生命比",
    :has_state              => "擁有狀態:",
    :nearest_visible        => "最近可視敵方單位",
    :attacking_ally         => "正在攻擊隊友:",
    :target_of_ally         => "隊友的目標:",
    :rank                   => "等級:",
    
    :any                    => "任何時刻",
    :clustered              => "X名敵方單位聚集成群:",
    :hp_lower               => "生命少於:",
    :hp_higher              => "生命多於:",
    :target_range           => "與目標的距離:",
    :target_atk_type        => "攻擊型態:",
    
    :ep_lower               => "能量少於:",
    :being_attacked_by_type => "被某種攻擊所傷:",
    :allies_alive           => "存活隊員數量:",
    :allies_dead            => "死亡隊員數量:",
    :surrounded_by_enemies  => "被X名敵方單位包圍:",
    
    :attack_mainhoof        => "使用主武器攻擊",
    :attack_offhoof         => "使用副武器攻擊",
    :target_none            => "放棄當前目標",
    :hp_most_power          => "使用生命藥水: 最強效",
    :hp_least_power         => "使用生命藥水: 最弱效",
    :ep_most_power          => "使用能量藥水: 最強效",
    :ep_least_power         => "使用能量藥水: 最弱效",
  }
  
end
