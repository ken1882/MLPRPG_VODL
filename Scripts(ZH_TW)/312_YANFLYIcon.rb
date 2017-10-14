#==============================================================================
# 
# ▼ Yanfly Engine Ace - Command Window Icons v1.00
# -- Last Updated: 2011.12.11
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================
$imported = {} if $imported.nil?
$imported["YEA-CommandWindowIcons"] = true
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.11 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Here's a script that allows you to allocate icons to each of your commands
# provided that the text for the command matches the icon in the script. There
# are, however, some scripts that this won't be compatible with and it's due
# to them using unique way of drawing out their commands. This script does not
# maintain compatibility for those specific scripts.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Go to the module and match the text under ICON_HASH with a proper Icon ID.
# You can find an icon's ID by opening up the icon select window in the RPG
# Maker VX Ace database and look in the lower left corner.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================
module YEA
  module COMMAND_WINDOW_ICONS
    # tag: icon
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Icon Hash -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This hash controls all of the icon data for what's used with each text
    # item. Any text items without icons won't display icons. The text has to
    # match with the hash (case sensitive) to display icons.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ICON_HASH ={
    # Matching Text   => Icon ID,
      "New story"            => 125,    # Title scene.
      "Continue story"       => 126,    # Title scene.
      "Leave"                => 127,    # Title scene. Game End scene.
      
      "Battle"        => 386,     # Battle scene.
      "Gallop"        => 328,     # Battle scene.
      "攻擊"        => 116,     # Battle scene.
      "防禦"         => 506,     # Battle scene.
      "聖物"         => 9299,
      "技能"         => 8175,    # Skill scene. Battle scene.
      "法術"       => 106,     # Skill scene. Battle scene.
      "被動"       => 3193,
      "Learn Skills"  => 2437,
      "Songs"         => 6470,
      "Pet"           => 3316,
      "Talent"           => 10662,
      "Bio"           => 233,
      "Brew"          => 3814,
      "Science"       => 8249,
      "Summon"        => 3761,
      "屬性能力"    => 228,
      "能力點"    => 228,
      "任務日誌"           => 1334,
      "Overview"      => 1354,
      "鞍袋(物品欄)"          => 1528,     # Menu scene. Item scene. Battle scene.
      "Talk"          => 4,
      "Actions"       => 143,
      "Cook"          => 2580,
      "Crafting"          => 125,
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
      "存檔"          => 10675,      # Menu scene.
      "讀檔"          => 10674,
      "Delete"        => 10676,
      "System"        => 2144,
      "End"           => 1020,      # Menu scene.
      "Craft"         => 2059,  
      "武器"       => 386,      # Item scene.
      "裝甲"        => 436,      # Item scene.
      "關鍵物品"     => 243,      # Item scene.
      "回到標題"      => 224,      # Game End scene.
      "取消"        => 119,      # Game End scene.
      "魔法書"     => 4052,
      "萬西安法術"       => 10044,
      "Encyclopedia"  => 3734,
      "文獻"         => 2399, 
      "圖鑑"      => 3343,
      "Music Room"    => 118,
      "技能術"   => 117,
      "裝備"         => 3786,
      "Add Point"     => 6476,
      "特殊物品" => 1646,
      "購買"           => 555,
      "售出"          => 554,
      "屬性"    => 2375,
      "概覽"       => 556,
      "醫療"      => 3958,
      "材料"    => 200,
      "全部"            => 1140,
      "暗器" => 159,
      "Music Sheet"    => 118,
      "書籍"           => 2384,
      "卷軸"         => 3733,
      "存檔/讀檔"      => 2431,
      "Dismantle"      => 8175,
      "Gamejolt"       => 570,
      "Life Skills"    => 8075,
      "Equip Skill"    => 117,
      "升級"       => 990,
      "移動到"        => 572,
      "跟隨"         => 1117,
      "巡邏"         => 1114,
      "移動/停止"      => 9301,
      ":停止"          => 9301,
      ":移動"          => 2255,
      ":不攻擊"     => 1141,
      ":被動"       => 13,
      ":堅守"  => 7346,
      ":防衛"     => 139,
      ":主動"    => 131,
      ":突襲"      => 116,
      "戰術"        => 2103,
      
    } # Do not remove this.
    
  end # COMMAND_WINDOW_ICONS
end # YEA
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================
#==============================================================================
# ■ Window_Command
#==============================================================================
class Window_Command < Window_Selectable
  
  #--------------------------------------------------------------------------
  # new method: use_icon?
  #--------------------------------------------------------------------------
  def use_icon?(text)
    return YEA::COMMAND_WINDOW_ICONS::ICON_HASH.include?(text)
  end
  
  #--------------------------------------------------------------------------
  # new method: command_icon
  #--------------------------------------------------------------------------
  def command_icon(text)
    return YEA::COMMAND_WINDOW_ICONS::ICON_HASH[text]
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  # tag: modified - ICON
  #--------------------------------------------------------------------------
  def draw_item(index)
    super(index, @list[index][:help])
    enabled = command_enabled?(index)
    change_color(normal_color, enabled)
    rect = item_rect_for_text(index)
    text = command_name(index)
    if use_icon?(text)
      draw_icon_text(rect.clone, text, alignment, enabled)
    else
      draw_text(rect, text, alignment)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_icon_text
  #--------------------------------------------------------------------------
  def draw_icon_text(rect, text, alignment, enabled)
    cw = text_size(text).width
    icon = command_icon(text)
    draw_icon(icon, rect.x, rect.y, enabled)
    rect.x += 24
    rect.width -= 24
    draw_text(rect, text, alignment)
  end
  
end # Window_Command
#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
