#==============================================================================
# ** FileManager
#------------------------------------------------------------------------------
#  This module is using to change the configs in Game.ini, e.g. sound volume or
#  other settings.
#==============================================================================
module FileManager
  #--------------------------------------------------------------------------
  # * Text wrap for window contents
  #--------------------------------------------------------------------------
  def self.textwrap(full_text, line_width)
    text_width = Font.default_size / 2
    text_limit = line_width / text_width
    line_count = (full_text.size + text_limit - 1) / text_limit
    clone_text  = []
    wraped_text = []
    full_text.each_char { |ch| clone_text.push(ch)}
    while clone_text.size > 0
      text = ""
      clone_text.each do |ch|
        text += ch
        break if text.size >= text_limit
      end
      clone_text = clone_text.drop(text.size)
      text = ensure_lines_connected(text, clone_text)
      wraped_text.push(text)
    end
    
    return wraped_text
  end
  #--------------------------------------------------------------------------
  # *  If line ended in the mid of word, add '-' connect two lines.
  #--------------------------------------------------------------------------
  def self.ensure_lines_connected(text, clone_text)
    return text if !clone_text[0] || !text[-1]
    return text if !clone_text[0].match(/^[[:alpha:]]$/)
    return text if !text[-1].match(/^[[:alpha:]]$/)
    return text + '-'
  end
  #--------------------------------------------------------------------------
  # * Modify Game.ini index
  #--------------------------------------------------------------------------
  def self.change_ini(obj, splits, goal, message = nil)
    file = File.new("Game.ini", "r")
    parameter_index = []
    
    while (line = file.gets)
      parameter_index.push(line)
    end
    file.close
      
    for i in 0...parameter_index.size
      if parameter_index[i].include?(obj)
        str = parameter_index[i].split(splits).at(0)
        str += splits + goal + 10.chr
        parameter_index[i] = str
        msgbox(message) if message
      end
    end
    
    puts "---------------[Game.ini]---------------"
    file = File.new("Game.ini", "w")
    for str in parameter_index
      file.write(str)
      puts "#{str}"
    end
    file.close
    puts "----------------------------------------"
  end # def change ini
end
#========================================================================
#
# init settings 
#
#========================================================================
class Game_Config
  attr_accessor :debug_info         
  attr_accessor :flag_output_info   
  attr_accessor :clean_output_data  # clean file every time open the game?
  attr_accessor :configs            # Current applied comfigs
  attr_accessor :shared_items       # Royal Supplies
  #============================================================
  # *)Initalize
  #============================================================
  def initialize
    @debug_info = []
    @flag_output_info = true
    @clean_output_data = true
    @configs = []
    @shared_items = []
    
    init_debug_info
  end
  #============================================================
  #   *)Init debug info & file
  #============================================================
  def init_debug_info
    return if !@flag_output_info
    
    if clean_output_data 
      file = File.new("Debug_Info.dat","w")
      file.write("")
      file.close
    end
    
    file = File.new("Debug_Info.dat","a")
    file.write("\n")
    file.write("=============================================================\n")
    file.write("              Game Launched Time : #{Time.now}\n")
    file.write("=============================================================\n")
    
    if !$pre_output_debug_infos.nil?
      file.write("---------------------------------------------\n")
      file.write("             Load game world setting         \n")
      file.write("---------------------------------------------\n")
      for str in $pre_output_debug_infos
        file.write(str)
        @configs.push(str)
        file.write("\n")
      end
    end
    
    file.close
    output_debug_info("\\\\\\\\\\\\\\\\\\~~!Hello World!~~///////////////")
  end
  #============================================================
  #   *) Output debug information
  #============================================================
  def output_debug_info(str,show_time = true)
    return if !@flag_output_info
    
    file = File.new("Debug_Info.dat","a")
    
    str = str.to_s
    str = sprintf("[%s] | %s\n",Time.now.to_s,str) if show_time
    file.write(str)
    file.write("---------------------------------------------------------------------------------------\n")
    
    file.close
  end
  #============================================================
  #    *)Load Configs
  #============================================================
  def read_configs
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
      @configs = []
      infos = []
      str = ""
      i = 0
      
      line = file.gets
      
      while i < line.size
       code = 0
       mul = 100
       if line[i] == '0' # end of line
         i += 1
         infos.push(str)
         str = ""
       end # end of line
       
       i += 1
       
       break if i > line.size # prevent overflow
       
       for j in 0...3
         char = line[i+j].to_i
         code += char * mul
         mul /= 10
       end #load encoded char
       code = (code-1) /4
       str += (code.chr)
       i += 3
      end # while i < line.size 
      
     for i in infos
       puts "#{i}"
       @configs.push(i)
     end
     
     file.close
   end # if file
  end # def read_configs
  #============================================================
  #   *)Show current applied configs
  #============================================================
  def show_configs
    puts "--------  Read configs  -------"
    for i in 0...@configs.size
      p sprintf("Line %3d: %s\n",i,@configs[i])
    end
    
    puts " ------- End of Configs -------"
  end
  #============================================================
  #   *) Encode config
  #============================================================
  def encode_config(cmd)
    encoded_str = ""
    ascii_str = []
    
    cmd.each_byte do |c|
      ascii_str.push(c)
    end
    
    for ch in ascii_str
      distract = (rand(8) + 1).to_s
      encrypt_ch = (ch * 4 + 1).to_s
      encoded_str += distract + encrypt_ch
    end
    encoded_str += '0'
    
    return encoded_str
  end
  #============================================================
  #   *) REWRITE current applied configs
  #============================================================
  def update_config(type,str = "")
    #---------------------------------
    # Attach or rewrite all configs
    #---------------------------------
    if type.upcase != "W" && type.upcase != "D" || str.size < 5
      msgbox("Config Error:\n" + "Invalied config assignment")
      return
    end
    
    file = File.new("001_Configs.rvdata2","w")
    puts "--------------------------------------------------"
    puts "             Rewrite game world setting"
    puts "--------------------------------------------------"
    
    #------------------------------------------------
    #   Add new config
    #------------------------------------------------
    new_configs = ""
    
    if type.upcase == "W"
      encoded_str = encode_config(str)
      insert_position = @configs.size - 1
      @configs.insert(insert_position,str)
      
      for config in @configs
        new_configs += encode_config(config)
      end
    #------------------------------------------------
    #   Remove config
    #------------------------------------------------
    elsif type.upcase == "D"
      for config in @configs
        next if config.include?(str)
        new_configs += encode_config(config)
      end
    end
    
    file.write(new_configs)
    file.close
  end
  #============================================================
  #   *) load_shared_items
  #============================================================
  def load_shared_items(item_class = RPG::Item)
    
    container = $game_party.item_container(item_class)
    file = File.new("000_MLP_Shared.rvdata2","r")
    counter = 0
    @shared_items = []
    
    while (line = file.gets)
      counter += 1
      if counter == 11
        data = line.split('|')
        data.delete_at(3)
        data.delete_at(0)
        puts "Shared Data Index:\n#{data}"
        puts "----------------------------------------------"
      end
      
    end
    file.close
    
    index = data[0].split(':').at(1)
    if !index.nil?
      index[0] = index[index.length - 1] = ""
      index = index.split(',')
      
      index.each do |item|
        item = item.split("=>")
        id = item[0].to_i
        num = item[1].to_i
        @shared_items.push([id,num])
      end
    end
    
    puts "#{@shared_items}"
  end
  
  #============================================================
  #   *) write_shared_items
  #============================================================
  def update_shared_items(item_class = RPG::Item)
    load_shared_items if @shared_items.size < 1
    
    msgbox("Save the shared data will take about 1~3 minutes\n" +
    "And it will execute updater twice in process,\n" +
    "just press any key to close the updater when it's done ^^\n" +
    "To prevent the error, please don't close the program while its still working."
    )
    
    original_cmd = ["Item:","Recipe:"]
    
    file = File.new("000_MLP_Shared.rvdata2","w")
    file.close()
    
    system('start /wait shared_data_updater.exe 10')
    
    file = File.new("000_MLP_Shared.rvdata2","a")
    #-----output real shared data------------------------
    
    prng = $game_system.make_rand
    str = get_distract_words(prng.rand(5000...8000))
    
    str += '|' + original_cmd[0]
        
    str += "{"
    cnt = 0
    for item in @shared_items
      cnt += 1
      str += sprintf("%d=>%d",item[0],item[1])
      str += ',' if cnt != @shared_items.length
    end
    str += "}"
        
    str += '|' + original_cmd[1] + '|'
    
    str += get_distract_words(prng.rand(5000...8000))
    str += '\n'
    file.write(str)
    file.close
    #------------------------------------------------------
    system('start /wait shared_data_updater.exe 10')
    msgbox("Update Successfully!")
  end
  #============================================================
  #   *) Get shared items
  #============================================================
  def get_shared_items
    for item in @shared_items
      $game_party.gain_item($data_items[item[0]],item[1])
    end
  end
  #============================================================
  #   *) Get bullshits
  #============================================================
  def get_distract_words(len = 1000)
    
    signs = "0Q6WqE7R!T8YwU9I@O0PeL#KrJ$HtG%FyD^SuA&ZiX*CoV(BpN)Ma_s+d}f{g<hj>k?l:m~n`b,v.c/x;z'1[2]3\4=5"
    str = ""
    
    while len > 0
      len -= 1
      prng = $game_system.make_rand
      str += signs[prng.rand(0...signs.length)]
    end
    
    return str
  end
  
end
