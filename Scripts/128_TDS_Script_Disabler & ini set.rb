#==============================================================================
# ** TDS_Script_Disabler
#    Ver: 1.2
#------------------------------------------------------------------------------
#  * Description:
#  This Script allows you to disable a group of scripts.
#------------------------------------------------------------------------------
#  * Features: 
#  Disable scripts.
#------------------------------------------------------------------------------
#  * Instructions:
#
#  To disable a group of scripts make 2 new blank scripts and in their name
#  add this:
#
#  <Disabled_Scripts>
#
#  </Disabled_Scripts>
#
#  Any scripts put between these 2 new scripts will be disabled at the start
#  of the game.
#------------------------------------------------------------------------------
#  * Notes:
#  The script names are the names on the left side box not inside the script
#  itself.
#
#  There is no limit to the amount of scripts groups you can disable.
#------------------------------------------------------------------------------
# WARNING:
#
# Do not release, distribute or change my work without my expressed written 
# consent, doing so violates the terms of use of this work.
#
# If you really want to share my work please just post a link to the original
# site.
#
# * Not Knowing English or understanding these terms will not excuse you in any
#   way from the consequenses.
#==============================================================================
# * Import to Global Hash *
#==============================================================================
($imported ||= {})[:TDS_Script_Disabler] = true
  #================================================
  #   Settings
  #================================================
  $battle_party_status_UI = false
  $force_show_roll_result = false
  $light_effects          = false
  $debug_mode             = false
  
  
  file = File.new("Game.ini", "r")
  parameter_index = []
  
  while (line = file.gets)
    parameter_index.push(line)
  end
  file.close
  
  for str in parameter_index
    #================================================
    #   FancyBattle party UI
    #================================================
    if str.include?("BattleStatusUI=1")
      $battle_party_status_UI = true
      info = "[System]:Fancy combat status UI actived"
      puts "#{info}"
    #================================================
    #   Force show roll result
    #================================================
    elsif str.include?("ShowRollResult=1")
      $force_show_roll_result = true
    #================================================
    #   Enable debug console
    #================================================
    elsif str.include?("DebugMode=1")
      $debug_mode = true
    #================================================
    #   Auto/Quick Save last location
    #================================================
    elsif str.include?("LastAutoSaveLoc")
      info = str.split('=')
      $last_autosave_loc = info[1].to_i
      puts "Last AutoSave Loc: #{$last_autosave_loc}"
    elsif str.include?("LastQuickSaveLoc")
      info = str.split('=')
      $last_quicksave_loc = info[1].to_i
      puts "Last QuickSave Loc: #{$last_quicksave_loc}"
    #================================================
    #   Light Effects
    #================================================
    elsif str.include?("LightEffects=1")
      $light_effects = true
      info = "[System]:Light Effects Enabled"
      puts "#{info}"
    #================================================
    #   Debug Mode
    #================================================
    elsif str.include?("DebugMode=1")
      $debug_mode = true
      info = "[System]:Debug Mode Enabled"
      puts "#{info}"
    #================================================
    #   Volume
    #================================================
    elsif str.include?("Volume")
      str = str.split('=').at(1)
      str = str.tr('[]','')
      $sound_volume = str.split(',')
      for i in 0...$sound_volume.size do $sound_volume[i] = $sound_volume[i].to_i end
      info = sprintf("[System]:Volume detected: %d %d %d",$sound_volume[0],$sound_volume[1],$sound_volume[2])
      puts "#{info}"
    #-----------------------------------------------
    end
  end
  
  #================================================
  # Game World Settings
  #================================================
  file = File.new("001_Configs.rvdata2")
  puts "--------------------------------------------------"
  puts "             Load game world setting"
  puts "--------------------------------------------------"
  
  #================================================
  # encode : n*4 + 1 ; decode: (n-1) / 4
  #================================================
  if file
    $pre_output_debug_infos = []
    
    infos = []
    str = ""
    i = 0
    
    line = file.gets
    
    if line.nil?
      msgbox("Config Error!")
      SceneManager.exit
    end
    if line.size < 50
      msgbox("Config Error!")
      SceneManager.exit
    end
    
    while i < line.size
      code = 0
      mul = 100
      if line[i] == '0' # end fo line
        i += 1
        infos.push(str)
        str = ""
      end
      i += 1
      break if i > line.size
      for j in 0...3
        char = line[i+j].to_i
        code += char * mul
        mul /= 10
      end
      code = (code-1) /4
      str += (code.chr)
      i += 3
    end
    
    for i in infos
      puts "#{i}"
      $pre_output_debug_infos.push(i)
    end
    
    file.close
  end
  
  puts "--------------------------------------------------"
  
  
#================================================
# Script Disable
#================================================
# Delete Activd Flag
delete_active =  false
# Output Active Flag
output_script = true
# Go through Scripts
file = File.new("Scripts.txt", "w")
Dir.mkdir("Scripts/") unless File.exist?("Scripts/")
permutation_order = 0
$RGSS_SCRIPTS.each_with_index {|data, i|
  file.write($RGSS_SCRIPTS[i][1] + "\n")
  # Activate or Deactivate Delete Active Flag
  if data.at(1) =~ /<Disabled_Scripts>/i
    delete_active = true
  elsif data.at(1) =~ /<\/Disabled_Scripts>/i
    delete_active = false
  end
  
  # Clear Text in Scripts data
  if delete_active 
    next if $RGSS_SCRIPTS[i][1] == "MOG_Battle_Hud_EX" && $battle_party_status_UI
    $RGSS_SCRIPTS.at(i)[2] = $RGSS_SCRIPTS.at(i)[3] = ""
  end
  
  if output_script
    permutation_order += 1
    string_order = permutation_order.to_s
    
    case string_order.size
    when 1
      string_order = "00" + string_order
    when 2
      string_order = "0" + string_order
    end
    
    file_name = string_order + "_" + $RGSS_SCRIPTS[i][1] + ".rb"
    file_name = string_order + "-----------------------------" if $RGSS_SCRIPTS[i][1].size < 1
    file_name = "Scripts/" + file_name.tr('<>|/','')
    script_file = File.new(file_name,"w")
    codes = $RGSS_SCRIPTS.at(i)[3]
    codes.split(/[\r\n]+/).each { |line|
     script_file.write(line)
     script_file.write("\n")
    }
    script_file.close
  end
}
file.close
  
#==============================================================================
# *) New global class
#==============================================================================
$game_console = Debug_Functions.new
$game_config = Game_Config.new
#==============================================================================
# *) New global variable
#==============================================================================
$disable_loading_screen     = false
$light_effects_forced       = false
#------------------------------------------------------------------------------
