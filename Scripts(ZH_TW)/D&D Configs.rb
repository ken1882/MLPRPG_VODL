#==============================================================================
# ** Dungeons and Dragons
#------------------------------------------------------------------------------
#  Config: Item and features sets
#==============================================================================
# tag: config
module DND
  # tag: translate
  
  PARAM_NAME = [
    "無",
    "無",
    "力量",
    "體質",
    "智力",
    "智慧",
    "敏捷",
    "魅力",
  ]
  
  WEAPON_TYPE_NAME = [
    "",
    "蹄斧",
    "馬蹄",
    "棍棒",
    "單蹄劍",
    "雙蹄劍",
    "弓",
    "弩",
    "戰錘",
    "流星錘",
    "熱武器",
    "箭矢",
    "弩矢",
    "子彈",
    "法杖"
  ]
  
  SKILL_TYPE_NAME = [
  "",
  "技能",
  "法術",
  "萬西安",
  "被動",
  ]
  
  ARMOR_TYPE_NAME = [
  "",
  "輕型甲",
  "中型甲",
  "重型甲",
  "衣服",
  "盾牌",
  "大盾",
  "靴子",
  "腰帶",
  "項鍊",
  "斗篷",
  "戒指",
  "護腿",
  "符文",
  "寶石",
  ]
  
  ELEMENT_NAME = [
  "",
  "鈍擊",
  "穿刺",
  "揮砍",
  "強酸",
  "寒冷",
  "火焰",
  "淨力",
  "閃電",
  "壞死",
  "毒",
  "精神",
  "聖",
  "雷電",
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
    "陸馬",
    "獨角獸",
    "天馬",
    "龍",
    "林地生物",
    "鹿",
    "獅蠍獸",
  ]
  
  ItemParamDec = {
    :weapon => [:wtype, :speed, :range, :damage],
    :armor  => [:atype, :ac],
    :skill  => [:stype, :cost, :range, :cooldown, :save, :damage],
    :item   => [:cooldown, :range, :save, :damage],
  }
  
end
