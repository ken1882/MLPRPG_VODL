#================================================
# * New Global variables
#================================================
$supported_languages = {
  :en_us => "English(US)",
  :zh_tw => "繁體中文",
}
$sound_volume = []                 # for Yanfly's system option
$game_console = Game_Console.new   # Don't change or move this line
CurrentLanguage = $game_console.get_language_setting
puts "Language: #{CurrentLanguage}"
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
# *) New global methods
#==============================================================================
def debug_mode?
  return $game_console.debug_mode if $game_console
  return true
end
#--------------------------------------------------------------------------
def setup_font
  
  if CurrentLanguage == :zh_tw
    Font.default_name = "NotoSansCJKtc-Regular"
  else
    Font.default_name = "Celestia Medium Redux"
  end
  puts "[Debug]: Setup Font #{Font.default_name}"
  Font.default_size = 24
  
end
#==============================================================================
# *) Default mehtod changes
#==============================================================================
#--------------------------------------------------------------------------
# * Alias: load_data
#--------------------------------------------------------------------------
alias load_data_pony load_data
def load_data(filename)
  SceneManager.update_loading
  load_data_pony(filename)
end
#--------------------------------------------------------------------------
# * Print debug info
#--------------------------------------------------------------------------
def debug_print(*args)
  return unless debug_mode?
  info = ""
  args.each do |line|
    info += line.to_s + ' '
  end
  puts "[Debug]: #{info}"
end
alias debug_printf debug_print
#--------------------------------------------------------------------------
alias puts_debug puts
def puts(*args)
  return unless debug_mode?
  args[0] = "<#{Time.now}> " + args[0] if args[0] =~ /\[(.*)\]/i
  puts_debug(*args)
end
#===============================================================================
# * Overwrite the exit method to program-friendly
#===============================================================================
def exit(stat = true)
  $exited = true
  SceneManager.scene.fadeout_all rescue nil
  Cache.release
  SceneManager.exit
end
