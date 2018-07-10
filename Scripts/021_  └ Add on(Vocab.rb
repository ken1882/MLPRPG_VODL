if CurrentLanguage == :zh_tw
#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================
# tag: translate
module Vocab
  
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
  LoadMessage     = "要讀取哪個檔案呢?"
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
  Type            = "類別"
  
  # Quest stuff
  Quest           = "任務日誌"
  QuestUpdated    = "任務日誌已更新: %s"
  
  # Game hint
  InitLoadingMsg  = "為了確保最佳的遊戲體驗, 請關閉占用系統資源的軟體及視窗.\n 例如Flash, Youtube或其他遊戲等"
  Unavailable     = "尚未開發完成, 敬請期待"
  
  # Transfer Info
  TransferGather  = "您必須集合隊伍才能繼續前進"
  TransferCombat  = "戰鬥中無法脫出"
  
  # Menu Stuff
  SaveDec         = "儲存遊戲進度或讀取先前的檔案"
  SystemDec       = "更改參數選項或離開遊戲"
  
  CritialMiss     = "%s - 嚴重失誤"
  CritialHit      = "%s - 致命一擊"
  AttackImmune    = "%s: %s 免疫我的傷害"
  Ineffective     = "%s - 武器無效"
  
  MoreInfo        = "詳細資料"
  
  # path to database dict
  DictPath        = "History/zh_tw"
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
  
  Slot      = "存檔 %s"
  ASaveSlot = "自動存檔 %s"
  QSaveSlot = "快速存檔 %s"
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
  Gem       = "寶石"
  
  WeaponDMG = "武器傷害"
  AmmoDMG   = "彈藥傷害"
  Speed     = "速度"
  
  Thac0     = "攻擊骰加成"
  AC        = "護甲等級"
  Damage    = "傷害"
  Range     = "距離"
  SType     = "類型"
  Cost      = "能量消耗"
  Cooldown  = "冷卻時間"
  Save      = "豁免率檢定"
  
  Remove    = "<卸下裝備>"
  Empty     = "<無>"
  None      = "<無>"
  Type      = "類別"
  
  Melee     = "物理"
  Magic     = "魔法"
  Ranged    = "遠程"
  
  CastingTime = "詠唱時間"
  SavingThrow = "豁免率檢定"
  
  SavingName = {
    :halfdmg  => "1/2",
    :nullify  => "通過則無效(Neg.)",
    :none     => "無",
    nil       => "無",
  }
  
end
#==============================================================================
# ** Vocab::System
#------------------------------------------------------------------------------
#   System option vocabs
#==============================================================================
module Vocab::System
  
  Language    = "語言"
  LanguageDec = "更改遊戲語言"
  
  WarCry          = "啟用戰鬥語音"
  WarCryDec       = "開關進入戰鬥時的開場白以及戰鬥時的部分語音效果"
  Difficulty      = "戰鬥難度"
  DifficultyName  = ["簡單", "普通", "困難", "專家"]
  DifficultyDec   = "改變戰鬥難度, 生命/傷害變化: 簡單: 0.5x/0.8x, 普通: 1x/1x\n" + 
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
  
  Delete        = "確認刪除?"
  Overwrite     = "選擇的檔案將被覆蓋, 確認繼續?"
  
  AutoSave          = "自動存檔"
  AutoSaveDec       = "達成特定條件且允許存檔時將自動存檔\n" +
                      "存檔欄位位於檔案列最下方"
  AutoSaveCombat    = "頭目戰"
  AutoSaveCombatDec = "頭目戰前自動存檔"
  AutoSaveStep      = "步數"
  AutoSaveStepDec   = "每走N步後自動存檔, 0 = 關閉此功能"
  
  Restart = "新設定將在遊戲重啟後生效"
end
#==============================================================================
# ** Vocab::Errno
#------------------------------------------------------------------------------
#   Message displayed when an error occurred
#==============================================================================
module Vocab::Errno
  
  LoadErr         = "讀取檔案時發生錯誤! 請將 %s\n寄送給開發團隊"
  SaveErr         = "存檔時發生錯誤:\n%s, 請將 %s 寄送給開發團隊並稍後再試"
  
  Exception       = "遊戲運行時發生錯誤! 請將檔案\"ErrorLog.txt\"寄送給開發團隊以處理錯誤.\n"
  ScriptErr       = "事件腳本運行時期錯誤!: %s\n請寄送 %s 給開發人員"
  
  GiftCodeFailed  = "禮物碼驗證失敗: %s"
  ProgramMissing  = "遺失程式: "
  
  PluginInitErr   = "無法初始化擴充腳本: #{PluginManager::LoaderFile}"
  PluginLoadErr   = "部分擴充腳本無法讀取, 請將'PluginErr.txt'寄送至開發團隊以解決問題"
  
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
  
  RunTimeErr  = "遊戲執行時發生錯誤: %s %s"
  
  RESymbol_Table = {
    :bits_incorrect   => "貨幣數量與區塊量不一致",
    :fileid_overflow  => "檔案ID溢位",
    :item_unconsumed  => "消耗品使用時期錯誤",
    :int_overflow     => "整數溢位",
    :datatype_error   => "資料型別錯誤:\n",
    :nil_block        => "無效的區塊鏈礦工",
    :chain_broken     => "區塊鏈:\n",
    :illegel_value    => "非法數值:\n",
    :checksum_failed  => "檔案驗證和失敗",
    :file_missing     => "遺失檔案:\n",
    :tactic_sym_missing => "無效的戰術指令符號:\n",
    :secure_hash_failed => "安全性雜湊驗證失敗:\n",
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
  IntNat    = "自然"
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
  
  GoldGain    = "隊伍%s金錢: %s%s"
  ItemGain    = "隊伍%s物品(x%s)"
  EXPGain     = "隊伍獲得經驗值: %d"
  BCGain      = "隊伍獲得挖礦獎勵: %s"
  
  Limited     = "(已達上限)"
  WordGain    = "獲得"
  WordLost    = "失去"
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
  
  HelpMove    = "選擇一點移動到該位置，或一敵人以進行攻擊"
  HelpSel     = "請選擇一位置"
  
  DecMove     = "移動到一定點或攻擊敵人"
  DecMHing    = "按鍵切換是否移動"
  DecReaction = "按鍵切換戰鬥反應模式"
  DecFollow   = "跟隨目標"
  DecGuard    = "保護目標"
  DecPatrol   = "巡邏區域"
  
  Targeting   = '視野內敵方單位'
  Fighting    = '主要目標條件'
  Self        = '自身條件'
  Item        = '物品'
  Skill       = '技能'
  General     = '一般'
  EdCondition = '更改條件'
  EdAction    = '更改動作'
  Delete      = "刪除"
  
  Hints = [
    "※此功能只有在隊伍AI啟用時才有效果，在地圖場景中按下\\c[23]C(預設)即可切換開/關。",
    "關於各指令的詳細功能請參閱玩家手冊",
    "--------------------------------------------------------------------------",
    "每個角色都可以設置最大20個的戰術指令，並且皆須指明條件與動作才會生效。",
    "如果該指令ID為\\c[18]紅色\\c[0], 代表該指令無效; \\c[29]綠色\\c[0]則是代表有效的指令。",
    "你可以按下\\c[23]CTRL\\c[0]來啟用/停用該指令，若指令ID為\\c[15]黑色\\c[0]則代表該指令為停用狀態。",
    "無效或停用的指令不會進行條檢查。\\c[10]但是動作'跳到戰術'如果跳到一個被停用的指令，",
    "\\c[10]該指令依然會進行檢查。",
    "",
    "指令動作執行的優先順序等同它的ID，意即如果有多個指令條件吻合，ID較高的指令",
    "將優先被執行；但AI會優先執行當下使用後對目標(包含敵我雙方)有效果的動作。",
    "",
    "若要改變指令的順序，按下\\c[23]SHIFT\\c[0]並將該指令移至你想要的位置即可。",
    "完成後，按下\\c[23]shift/ok\\c[0]即可離開該指令的編輯模式",
  ]
  
  Help = "霧煞煞? 按下F4取得幫助"
  SwapHelp = "移動游標即可變更順序"
  
  Name_Table  = {
    :attack_mainhoof      => "使用主武器",
    :attack_offhoof       => "使用副武器",
    :add_command          => "新增戰術",
    :target_none          => "放棄當前目標",
    :hp_most_power        => "使用生命藥水: 最強效",
    :hp_least_power       => "使用生命藥水: 最弱效",
    :ep_most_power        => "使用能量藥水: 最強效",
    :ep_least_power       => "使用能量藥水: 最弱效",
    :set_target           => "設為主要攻擊目標",
    :jump_to              => "跳到戰術: ",
    :move_away            => "遠離目標",
    :move_close           => "接近目標",
    :player               => "玩家當前操作角色",
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
    :clustered              => "X名敵方聚集:",
    :hp_lower               => "生命少於:",
    :hp_higher              => "生命多於:",
    :target_range           => "與自身的距離:",
    :target_atk_type        => "攻擊型態:",
    
    :ep_lower               => "能量少於:",
    :being_attacked_by_type => "被某攻擊所傷:",
    
    :enemies_alive          => "X名敵方存活:",
    :allies_alive           => "存活隊員數量:",
    :allies_dead            => "死亡隊員數量:",
    :surrounded_by_enemies  => "被X名敵方包圍:",
    :using_attack_type      => "主武器攻擊類型:",
    
    :attack_mainhoof        => "使用主武器攻擊",
    :attack_offhoof         => "使用副武器攻擊",
    :target_none            => "放棄當前目標",
    :hp_most_power          => "使用生命藥水: 最強效",
    :hp_least_power         => "使用生命藥水: 最弱效",
    :ep_most_power          => "使用能量藥水: 最強效",
    :ep_least_power         => "使用能量藥水: 最弱效",
    
    :set_target             => "設為主要攻擊目標",
    :jump_to                => "跳到戰術: ",
    :move_away              => "遠離目標",
    :move_close             => "接近目標",
    
    :enemies      => "所有敵人:",
    :targeting    => "所有敵人:",
    :target       => "主要目標:",
    :fighting     => "主要目標:",
    :self         => "自己:",
    :new_command  => "<新增戰術>",
    
    :short      => "短程",
    :medium     => "中程",
    :long       => "長程",
    
    :critter    => "弱雞",
    :minion     => "嘍囉",
    :elite      => "菁英",
    :captain    => "領班",
    :chief      => "首領",
    
    :melee      => "物理攻擊",
    :ranged     => "遠程攻擊",
    :magic      => "魔法攻擊或詠唱",
    
    :player     => "玩家當前操作角色",
  }
  
  InputHelp = {
    :attacking_ally => "請選擇一名隊伍成員",
    :target_of_ally => "請選擇一名隊伍成員",
    :has_state    => "請選擇一個狀態",
    :rank         => "請選擇一個等級",
    :hp_lower     => "請輸入百分比, 按下Enter鍵完成, ESC取消",
    :hp_higher    => "請輸入百分比, 按下Enter鍵完成, ESC取消",
    :ep_lower     => "請輸入百分比, 按下Enter鍵完成, ESC取消",
    :target_range => "請選擇一個距離",
    :target_atk_type  => "請選擇一個類型",
    :being_attacked_by_type => "請選擇一個類型",
    :using_attack_type      => "請選擇一個類型",
    :clustered              => "請輸入數量, 條件門檻為大於等於這個數字",
    :enemies_alive          => "請輸入數量, 條件門檻為大於等於這個數字",
    :allies_alive           => "請輸入數量, 條件門檻為大於等於這個數字",
    :allies_dead            => "請輸入數量, 條件門檻為大於等於這個數字",
    :surrounded_by_enemies  => "請輸入數量, 條件門檻為大於等於這個數字",
  }
  
  ArgDec_Table = {
    :has_state    => "%s",
    :rank         => "%s",
    :hp_lower     => "%d\%",
    :hp_higher    => "%d\%",
    :ep_lower     => "%d\%",
    :target_range => "在 %s 時",
    :target_atk_type  => "%s",
    :being_attacked_by_type => "%s",
    :using_attack_type      => "%s",
    :clustered              => "%d名或更多",
    :enemies_alive          => ">= %d",
    :allies_alive           => ">= %d",
    :allies_dead            => ">= %d",
    :surrounded_by_enemies  => ">= %d",
    :player     => "當前操縱角色",
  }
  
end
#==============================================================================
# ** Vocab::Skillbar
#------------------------------------------------------------------------------
#   Text info in skillbar
#==============================================================================
module Vocab::Skillbar
  
  Follower    = "開關隊伍成員AI"
  AllSkill    = "所有技能"
  Vancian     = "萬西安"
  AllItem     = "所有物品"
  PrevPage    = "上一頁"
  NextPage    = "下一頁"
  Cancel      = "取消"
  None        = "<無>"
  
  Use         = "使用"
  Hotkey      = "熱鍵"
  Info        = "詳細資料"
  MouseEdit   = "現在您可以使用滑鼠拖曳編輯熱鍵欄"
  
  SelHelp     = "請用滑鼠點擊熱鍵欄位或按下對應按鍵來設定"
  SelSucc     = "您已經將%s指定在熱鍵%s上"
end
#==============================================================================
# ** Vocab::Rescue
#------------------------------------------------------------------------------
#   Text info of the rescues
#==============================================================================
module Vocab::Rescue
  Luna    = "\\af[9]\\n<Luna>汝該慶幸本宮隨之在後.."
end
end # Current Language
