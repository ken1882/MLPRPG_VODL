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
  next if data[4]

  if output_script
    string_order = permutation_order.to_fileid(3).to_s
    
    file_name = string_order + "_" + data[1] + ".rb"
    file_name = string_order + "-----------------------------" if $RGSS_SCRIPTS[i][1].size < 1
    file_name = "Scripts/" + file_name.tr(':<>|/','')
    
    script_file = File.new(file_name, 'w')
    
    codes = data[3]
    codes.split(/[\r\n]+/).each { |line|
     script_file.write(line)
     script_file.write("\n")
    }
    script_file.close
    permutation_order += 1
  end
  
  $RGSS_SCRIPTS.at(i)[2] = $RGSS_SCRIPTS.at(i)[3] = '' if script_disable_flag 
}

# tag: test
TEST = 0
if TEST == 1
module SceneManager
  #--------------------------------------------------------------------------
  # * Get First Scene Class
  #--------------------------------------------------------------------------
  def self.first_scene_class
    focus_game_window
    Scene_Test
  end
end
end
#==============================================================================
# *) New global class
#==============================================================================
$rgss   = self
$assist = RubyVM::InstructionSequence.compile("$thassist=Thread.new{Thread_Assist.assist_main}.run")
$mutex  = Mutex.new
#==============================================================================
# ** Ex-Main
#==============================================================================
setup_font
Graphics.resize_screen(640 ,480)
puts "[Debug]: Screen resized"
Graphics.frame_rate = 60
GameManager.load_volume
Cache.init
Mouse.init
Mouse.cursor.visible = false
#PONY.InitOpenAL
PONY.InitObjSpace
$assist.eval