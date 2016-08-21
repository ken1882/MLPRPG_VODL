=begin
EST - AUTO TEXT COLOR PLUS
v.1.2
Author: Estriole

Changelog
 v1.0 2013.08.27    - Initial Release
 v1.1 2013.08.28    - Combine with regexp to recognize 'short' word.
                      now it won't color damage if you put mag in the config.
                      if there's bug report to me. since it's really hard dealing with regexp
 v1.2 2013.08.28    - Regexp sure is confusing. but manage to improve the regexp.
                      now it should accept any character beside a-z and 0-9 and _ (underscore).
                      and it just by removing one symbol from regexp that i have tried before and fail.

Introduction
  This script created because i got tired adding \c[4]Nobita\c[0] in the show
message box. so this script make it automatic. each time i wrote Nobita it will
change the color to what i set in the module. useful to color actor names or
places or important things. i also add capitalization correction too. so if you
write nobita. it could fixed to Nobita(what you set in the config) if you want.
both auto color and auto caps correct can be binded to switch too if you don't
want to always using it.

Feature
- auto change color text you defined in the module
- auto correct capitalization to what you defined in the module
- have switch function for both feature (set it to 0 to make it always active).

Author Note
Yes... I made doraemon games.

Feature

=end
module ESTRIOLE
  module AUTOCOLOR
    #PUT THE STRING YOU WANT TO AUTO COLOR BELOW. USEFUL FOR NAMES
    #FORMAT:   "STRING" => COLOR_ID,
    AUTO_SETTING = { #DO NOT TOUCH THIS LINE
    "HP" => 18,
    "hp" => 18,
    "Hp" => 18,
    "MP" => 9,
    "mp" => 9,
    "Mp" => 9,
    "EP" => 9,
    "ep" => 9,
    "Ep" => 9,
    #-------------------
    
    "Fire"      =>    18,
    "Friendly"  =>    18,
    #"fire"      =>    18,
    "Ice"       =>    23,
    #"ice"       =>    23,
    "Thunder"   =>    31,
    #"thunder"   =>    31,
    "Lighting"  =>    31,
    #"lighting"  =>    31,
    "Water"     =>    12,
    #"water"     =>    12,
    "Earth"     =>    20,
    #"earth"     =>    20,
    "Wind"      =>    29,
    #"wind"      =>    29,
    "Celestial" =>    6,
    #"celestial" =>    6,
    "Lunarian"  =>    30,
    #"lunarian"  =>    30,
    "Physical"  =>    7,
    #"physical"  =>    7,
    "Slash"     =>    7,
    #"slash"     =>    7,
    "Piercing"  =>    7,
    #"piercing"  =>    7,
    "Smash"     =>    7,
    #"smash"     =>    7,
    "Dragon"    =>    10,
    #"dragon"    =>    10,
    "Drought"   =>    14,
    #"drought"   =>    14,
    "Chaos"     =>    15,
    #"chaos"     =>    15,
    "Magical"   =>    26,
    #"magical"   =>    26,
    "Magic"     =>    26,
    #"magic"     =>    26,
    "Acid"      =>    11,
    #"acid"      =>    11,
    "Poison"    =>    11,
    #"poison"    =>    11,
    #-------------------
    "Strength"  =>    2,
    "ATK"       =>    2,
    "STR"       =>    2,
    "Defence" =>    5,
    "DEF"       =>    5,
    "CON"       =>    5,
    "Specialty" =>    30,
    "MAT"       =>    30,
    "INT"       =>    30,
    "Resistant" =>    31,
    "MDF"       =>    31,
    "WIS"       =>    31,
    "Agility"   =>    24,
    "AGI"       =>    24,
    "DEX"       =>    24,
    "Luck"      =>    17,
    "LUK"       =>    17,
    "CHA"       =>    17,
    #---------------------------------------
    "Saving Throw"    =>    1,
    "Saving Throws"    =>    1,
    #"saving throw"    =>    1,
    "Physical Damage" =>    7,
    "P.DMG"           =>    7,
    "Magical Damage"  =>    26,
    "M.DMG"           =>    26,
    "Roll:"           =>    6,
    "DC"              =>    18,
    "Roll Dice"       =>    27,
    #----------------- end
    }#DO NOT TOUCH THIS LINE
    
    #return to this color after the text finished. # default 0
    RETURN_COLOR = 0
    
    #switch to activate the auto color. if switch off then don't autocolor
    #set it to 0. if you want to use switch (will always on)
    AUTO_COLOR_SWITCH = 20
    
    #switch to activate the auto capitalization correction. (will use what you define
    #in AUTOSETTING #if switch off then don't auto capitalization correction.
    #set it to 0. if you want to use switch (will always on)
    CORRECT_CAP_SWITCH = 0
    
    START_AUTO_COLOR = true
    START_CORRECT_CAP = true
  end
end

class Game_Switches
  include ESTRIOLE::AUTOCOLOR
  alias est_autocolor_switch_initialize initialize
  def initialize
    est_autocolor_switch_initialize
    @data[AUTO_COLOR_SWITCH] = START_AUTO_COLOR if AUTO_COLOR_SWITCH != 0
    @data[CORRECT_CAP_SWITCH] = START_CORRECT_CAP if CORRECT_CAP_SWITCH != 0
  end
end


class Window_Base < Window
  include ESTRIOLE::AUTOCOLOR
  alias est_auto_text_color_convert_escape_character convert_escape_characters
  def convert_escape_characters(*args, &block)
    result = est_auto_text_color_convert_escape_character(*args, &block)    
    return result if AUTO_COLOR_SWITCH != 0 && !$game_switches[AUTO_COLOR_SWITCH]
    AUTO_SETTING.each_key {|key|
    return_color = RETURN_COLOR
    color        = AUTO_SETTING[key]
    if CORRECT_CAP_SWITCH!= 0 && !$game_switches[CORRECT_CAP_SWITCH]
    result.gsub!(/(?<![\w])#{key}(?![\w])/i) {"\eC[#{color}]#{$&}\eC[#{return_color}]"}
    else
    result.gsub!(/(?<![\w])#{key}(?![\w])/i) {"\eC[#{color}]#{key}\eC[#{return_color}]"}
    end
    }
    result    
  end
end