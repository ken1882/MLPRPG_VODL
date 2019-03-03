module Plugins
  # Overwrite: package 
  def self.package
    scripts = $TracerCode ? "begin\n" : ""
    end_line = 0
    
    @@scripts.each do |s|
      begin
        code = File.open(s).read + "\n"
        scripts += code
        line_count = code.count(10.chr)
        end_line += line_count
        start_line = end_line - line_count + 2
        name = '"' + s.split('/')[2..-1].join('/') + '"'
        $RGSS_SCRIPTS.push([$RGSS_SCRIPTS.size, name, '', code, start_line, end_line + 1])
      rescue
        # Do nothing
      end
    end

    begin
      file = File.open("#{root_path}/scripts.rb", 'w')
    rescue
      # We are in encrypted mode, do nothing
    end

    return if file.nil? # If file is nil, it cannot be accessed, which means the game is running with an encrypted archive. If so, we do not write the scripts file.

    # Add debug tracer code
    scripts += $TracerCode

    begin
      file.write(scripts)
    rescue IOError => e
      raise "Could not write scripts file; is the plugins folder writable?"
    ensure
      file.close unless file == nil
    end
    
  end

  def self.find_file_by_line(line)
    $RGSS_SCRIPTS.each do |info|
      next unless info[5]
      return info if info[5] >= line
    end
  end

end