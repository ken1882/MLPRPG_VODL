#================================================
#   Settings
#================================================
$battle_party_status_UI = false
$force_show_roll_result = false
$light_effects          = false
$debug_mode             = false
$POW_target             = 100
#================================================
# * Script Processions
#================================================
script_disable_flag = false
output_script       = true
Dir.mkdir("Scripts/") unless File.exist?("Scripts/")
permutation_order = 0
$RGSS_SCRIPTS.each_with_index {|data, i|
  
  script_disable_flag = true  if data.at(1) =~ /<Disabled_Scripts>/i
  script_disable_flag = false if data.at(1) =~ /<\/Disabled_Scripts>/i
  
  $RGSS_SCRIPTS.at(i)[2] = $RGSS_SCRIPTS.at(i)[3] = '' if script_disable_flag 
  
  if output_script
    string_order = permutation_order.to_fileid(3).to_s
    
    file_name = string_order + "_" + $RGSS_SCRIPTS[i][1] + ".rb"
    file_name = string_order + "-----------------------------" if $RGSS_SCRIPTS[i][1].size < 1
    file_name = "Scripts/" + file_name.tr(':<>|/','')
    
    script_file = File.new(file_name, 'w')
    codes = $RGSS_SCRIPTS.at(i)[3]
    codes.split(/[\r\n]+/).each { |line|
     script_file.write(line)
     script_file.write("\n")
    }
    script_file.close
    permutation_order += 1
  end
}
#==============================================================================
# *) New global class
#==============================================================================
$game_console = Game_Console.new
#==============================================================================
# *) New global variable
#==============================================================================
$disable_loading_screen     = false
$light_effects_forced       = false
#------------------------------------------------------------------------------
