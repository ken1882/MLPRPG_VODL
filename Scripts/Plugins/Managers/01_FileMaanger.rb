#==============================================================================
# ** FileManager
#------------------------------------------------------------------------------
#  This module is using to change the configs in Game.ini, e.g. sound volume or
#  other settings.
#==============================================================================
module FileManager
  #---------------------------------------------------------------------------
  PaddingWidth  = 6
  DebugFilePath = "Data/Debug/"
  #---------------------------------------------------------------------------
  module_function
  #---------------------------------------------------------------------------
  # *) Ensure the file or dictionary
  #---------------------------------------------------------------------------
  def ensure_file_exist(filename)
    Dir.mkdir(filename) unless File.exist?(filename)
  end
  #--------------------------------------------------------------------------
  # * Text wrap for window contents
  #--------------------------------------------------------------------------
  def textwrap(full_text, line_width, sample_bitmap = nil)
    return [] if full_text.nil?
    if sample_bitmap.nil?
      using_sample = true
      sample_bitmap = Bitmap.new(1,1)
    else
      using_sample  = false
    end
    raise TypeError unless full_text.is_a?(String)
    wraped_text = []
    cur_width   = PaddingWidth
    line        = ""
    strings     = full_text.gsub('　', ' ').split(/[\r\n ]+/i)
    strs_n      = strings.size
    space_width = sample_bitmap.text_size(' ').width
    minus_width = sample_bitmap.text_size('-').width
    
    # while any string segment unprocessed
    while (str = strings.first)
      next if str.length == 0
      width = sample_bitmap.text_size(str).width
      endl  = false
      # if the segment width larger than display width
      if width + PaddingWidth >= line_width
        line      = ""
        cur_width = minus_width
        strlen    = str.length
        processed = false
        last_i    = 0
        # process each character on by one
        for i in 0...strlen
          width = sample_bitmap.text_size(str[i]).width
          last_i = i
          # unable to display character
          if !processed && cur_width + width >= line_width
            sample_bitmap.dispose if using_sample
            return [full_text]
          elsif cur_width + width < line_width
            cur_width += width
            line += str[i]
            processed = true
          else
            break
          end
        end
        # continue symbol character
        line += '-'
        # replace with left unprocessed string
        strings[0] = str[last_i...strlen]
        endl = true
      # + segment width smaller than line width, continue
      elsif cur_width + width < line_width
        cur_width += width + space_width
        line += strings.shift + ' '
        endl = true if strings.size == 0
      # + segment width over the line width, process end of line
      else
        endl = true
      end
      
      if endl
        wraped_text.push(line)
        line = ""
        cur_width = PaddingWidth
      end
    end
    sample_bitmap.dispose if using_sample
    return wraped_text
  end
  #--------------------------------------------------------------------------
  # * Load Game.ini index
  #--------------------------------------------------------------------------
  def load_ini(group, target, path = ".//Game.ini")
    buffer = '\0' * 256
    PONY::API::GetPPString.call(group, target, '', buffer, 256, path)
    return buffer.strip
  end
  #--------------------------------------------------------------------------
  # * Modify Game.ini index
  #--------------------------------------------------------------------------
  def write_ini(group, target, goal, path = ".//Game.ini")
    PONY::API::WritePPString.call(group, target, goal, path)
  end # def change ini
  #--------------------------------------------------------------------------
  # * Replace
  #--------------------------------------------------------------------------
  def convert_eval_string(str)
    return if str.nil?
    cache = ""
    detect_flag = false
    true_str = ""
    
    for i in 0...str.length
      if str[i] == '%' && str[i+1] == '{'
        detect_flag = true
        next
      end
      
      if detect_flag
        if str[i] == '}'
          cache[0] = ''
          puts "#{cache}"
          true_str += eval(cache).to_s rescue "%{CONVERSION ERROR}"
          cache = ""; detect_flag = false;
        elsif str[i]
          cache += str[i]
        end
      else # if not detecting eval code
        true_str += str[i]
      end # if detect flag on
    end # for i in str
    
    return true_str
  end # def convert
  #--------------------------------------------------------------------------
  def export_all_map_dialog
    path = "Data/Map*.rvdata2"
    files = Dir.glob(path)
    files.each do |filename|
     export_map_dialog(filename)
    end
  end
  #--------------------------------------------------------------------------
  def export_map_dialog(map_sym)
    map_sym =~ /(?:Map)[ ]\d+/i
    if map_sym.is_a?(Numeric)
      map_id = map_sym.to_fileid(3) 
    else
      map_id = map_sym.split("Map")[1].split('.').first
    end
    path = "Data/Dialog/"
    Dir.mkdir(path) unless File.exist?(path)
    path     += map_id
    Dir.mkdir(path) unless File.exist?(path)
    filename = path + "/dialog.txt"
    map  = load_data(sprintf("Data/Map%03d.rvdata2", map_sym)) if map_sym.is_a?(Numeric)
    map  = load_data(map_sym) if map_sym.is_a?(String)
    return unless map.is_a?(RPG::Map)
    output = ""
    map.events.each_value do |event|
      output += sprintf("[%03d] %s\n", event.id, event.name)
      event.pages.each do |page|
        listsize = page.list.size
        index = 0
        while index < listsize
          outputed = false
          if page.list[index].code == 101 || page.list[index].code == 105
            while page.list[index+1].code == 101 && Variable.message_rows > 4 || page.list[index+1].code == 401
              index += 1
              output += page.list[index].parameters[0].to_s + 10.chr
              outputed = true
            end
          end # if page will show text
          index += 1
          output += SPLIT_LINE + 10.chr if outputed
        end # commands in list
      end # pages in event
    end # events in map
    File.open(filename, 'w') do |file|
        file.write(output)
    end
  end
  #--------------------------------------------------------------------------
  def continue_message_string?
    return true if next_event_code == 101 && Variable.message_rows > 4
    return next_event_code == 401
  end
  #--------------------------------------------------------------------------
  def build_debug_file(filename, stat, &block)
    path = "Data/Debug"; ensure_file_exist(path); path += "/" + filename;
    File.open(path, stat) do |file|
      yield file if block_given?
    end
  end
  #--------------------------------------------------------------------------
  def compress_source(file)
    script = []
    script[0] = (file.hash + script.hash).abs
    script[1] = file.split(/[\/\\]+/).last
    script[3] = load_data(file)
    script[2] = Zlib::Deflate.deflate(script[3])
    return script
  end
  #---------------------------------------------------------------------------
  def export_debug_file(filename, index)
    mkdir(DebugFilePath) unless File.exist?(DebugFilePath)
    path = DebugFilePath + filename
    File.open(path, 'w') do |file|
      file.write(index)
    end
    return path
  end
  #---------------------------------------------------------------------------
end
