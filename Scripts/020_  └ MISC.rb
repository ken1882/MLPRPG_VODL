if CurrentLanguage == :zh_tw
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
      "攻擊"          => 116,     # Battle scene.
      "防禦"          => 506,     # Battle scene.
      "聖物"          => 9299,
      "技能"          => 8175,    # Skill scene. Battle scene.
      "法術"          => 106,     # Skill scene. Battle scene.
      "被動"          => 3193,
      "Learn Skills"  => 2437,
      "Songs"         => 6470,
      "Pet"           => 3316,
      "Talent"        => 10662,
      "Bio"           => 233,
      "Brew"          => 3814,
      "Science"       => 8249,
      "Summon"        => 3761,
      "屬性能力"      => 228,
      "能力點"        => 228,
      "任務日誌"      => 1334,
      "Overview"      => 1354,
      "鞍袋(物品欄)"  => 1528,     # Menu scene. Item scene. Battle scene.
      "物品"          => 1528,     # Menu scene. Item scene. Battle scene.
      "Talk"          => 4,
      "Actions"       => 143,
      "Cook"          => 2580,
      "Crafting"      => 125,
      "Skills"        => 104,      # Menu scene.
      "Log"           => 2441,
      "書籍"          => 2384,
      "歷史"          => 2435,
      "Execute"       => 125,
      "Run"           => 172,
      "裝備"          => 524,      # Menu scene.
      "狀態"          => 1204,     # Menu scene.
      "隊伍"          =>  11,      # Menu scene.
      "Special"       => 775,
      "存檔"          => 10675,      # Menu scene.
      "讀檔"          => 10674,
      "Delete"        => 10676,
      "刪除"          => 10676,
      "System"        => 2144,
      "End"           => 1020,      # Menu scene.
      "Craft"         => 2059,  
      "武器"          => 386,      # Item scene.
      "裝甲"          => 436,      # Item scene.
      "關鍵物品"      => 243,      # Item scene.
      "回到標題"      => 224,      # Game End scene.
      "取消"          => 119,      # Game End scene.
      "魔法書"        => 4052,
      "萬西安法術"    => 10044,
      "萬西安"        => 10044,
      "Encyclopedia"  => 3734,
      "文獻"          => 2399, 
      "圖鑑"          => 3343,
      "Music Room"    => 118,
      "技能"          => 117,
      "裝備"          => 3786,
      "Add Point"     => 6476,
      "特殊物品"      => 1646,
      "購買"          => 555,
      "售出"          => 554,
      "屬性"          => 2375,
      "概覽"          => 556,
      "一般"          => 556,
      "醫療"          => 3958,
      "材料"          => 200,
      "全部"          => 1140,
      "暗器"          => 159,
      "樂譜"          => 118,
      "書籍"          => 2384,
      "卷軸"          => 3733,
      "存檔/讀檔"     => 2431,
      "Dismantle"     => 8175,
      "Gamejolt"      => 570,
      "Life Skills"   => 8075,
      "Equip Skill"   => 117,
      "升級"          => 990,
      "移動到"        => 572,
      "跟隨"          => 1117,
      "巡邏"          => 1114,
      "移動/停止"     => 9301,
      ":停止"         => 9301,
      ":移動"         => 2255,
      ":不攻擊"       => 1141,
      ":被動"         => 13,
      ":堅守"         => 7346,
      ":防衛"         => 139,
      ":主動"         => 131,
      ":突襲"         => 116,
      "戰術"          => 2103,
      "保護"          => 506,
      
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
      :all          => "全部",
      :healings     => "醫療",
      :book         => "書籍",
      :scroll       => "卷軸",
      :hdweapons    => "暗器",
      :special      => "特殊物品",
      :ingredient   => "素材",
      :music_sheet  => "樂譜",
      :misc         => "其他",
    }
    #--------------------------------------------------------------------------
    WEAPON_TYPES = {
      :all      => "全部",
    }
    #--------------------------------------------------------------------------  
    ARMOUR_TYPES = {
      :all      => "全部",
    }
    #--------------------------------------------------------------------------
    VOCAB_STATUS = {
      :empty      => "---",          # Text used when nothing is shown.
      :hp_recover => "恢復生命",      # Text used for HP Recovery.
      :mp_recover => "恢復能量",      # Text used for MP Recovery.
      :tp_recover => "恢復TP",      # Text used for TP Recovery.
      :tp_gain    => "獲得TP",      # Text used for TP Gain.
      :applies    => "狀態追加",      # Text used for applied states and buffs.
      :removes    => "狀態解除",      # Text used for removed states and buffs.
    } # Do not remove this.
    #--------------------------------------------------------------------------
  end
end
end # Current Language
