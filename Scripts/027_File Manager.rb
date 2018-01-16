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
  def self.textwrap(full_text = "", line_width = 1)
    return [] if full_text.nil?
    raise full_text unless full_text.is_a?(String)
    line_width *= 1.3
    text_width = Font.default_size / 2
    text_limit = line_width / text_width
    line_count = (full_text.size + text_limit - 1) / text_limit
    clone_text  = []
    wraped_text = []
    full_text.each_char { |ch| clone_text.push(ch)}
    while clone_text.size > 0
      text = ""
      clone_text.shift if clone_text[0] == ' '
      n = clone_text.size
      curblen = 0
      for i in 0...n
        ch = clone_text[i]
        text += ch
        curblen += [ch.bytesize, 2].min
        break if ch == 10.chr
        break if curblen >= text_limit
      end
      
      processed  = ensure_lines_connected(text, clone_text.drop(text.size))
      clone_text = clone_text.drop(text.size + processed[0])
      text = processed[1]
      wraped_text.push(text)
    end
    
    return wraped_text
  end
  #--------------------------------------------------------------------------
  # *  If line ended in the mid of word, add '-' connect two lines.
  #--------------------------------------------------------------------------
  def self.ensure_lines_connected(text, clone_text)
    return [0, text] if !clone_text[0] || !text[-1]
    return [0, text] if !clone_text[0].match(/^[[:alpha:]]$/)
    return [0, text] if !text[-1].match(/^[[:alpha:]]$/)
    return [0, text] if text[-1].bytesize > 1
    endl_pos = 0
    surplus = ""
    3.times do |i|
      break if clone_text[i].nil?
      surplus += clone_text[i]
      endl_pos = i if clone_text[i] == ' ' || clone_text[i] == 10.chr
    end
    proc_text = endl_pos > 0 ? text + surplus[0...endl_pos] : text + '-'
    return [endl_pos, proc_text]
  end
  #--------------------------------------------------------------------------
  # * Load Game.ini index
  #--------------------------------------------------------------------------
  def self.load_ini(group, target)
    buffer = '\0' * 256
    PONY::API::GetPPString.call(group, target, '', buffer, 256, ".//Game.ini")
    return buffer.strip
  end
  #--------------------------------------------------------------------------
  # * Modify Game.ini index
  #--------------------------------------------------------------------------
  def self.write_ini(group, target, goal)
    PONY::API::WritePPString.call(group, target, goal, ".//Game.ini")
  end # def change ini
  #--------------------------------------------------------------------------
  # * Replace
  #--------------------------------------------------------------------------
  def self.convert_eval_string(str)
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
  def self.export_all_map_dialog
    path = "Data/Map*.rvdata2"
    files = Dir.glob(path)
    files.each do |filename|
     export_map_dialog(filename)
    end
  end
  #--------------------------------------------------------------------------
  def self.export_map_dialog(map_sym)
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
  def self.continue_message_string?
    return true if next_event_code == 101 && Variable.message_rows > 4
    return next_event_code == 401
  end
  #--------------------------------------------------------------------------
end
