#--------------------------------------------------------------------------
# * Print error informations
#--------------------------------------------------------------------------
def report_exception(error)
  scripts_name = $RGSS_SCRIPTS.collect{|script|  script[1]  }
  backtrace = []

  # Flag to find the error location in externel files
  translate_flag = false
  if $LoaderMethodNames
    translate_flag = $LoaderMethodNames.any?{|method_name|
      error.backtrace.any?{|line| line.include?(method_name)}
    }
  end
  
  error.backtrace.each_with_index {|line,i|
    if line =~ /{(.*)}(.*)/
      backtrace << (scripts_name[$1.to_i] + $2)
    elsif line.start_with?(':1:')
      break
    else
      backtrace << (translate_flag ? translate_debug_message(line) : line)
    end
    translate_flag = false if $LoaderMethodNames.any?{|name| line.include?(name)}
  }
  
  error_line = backtrace.first
  backtrace[0] = ''
  err_class = " (#{error.class})"
  back_trace_txt = backtrace.join("\n\tfrom ")
  $error_tracer_header = backtrace[0]
  error_txt = sprintf("%s %s %s %s %s %s",error_line, ": ", error.message, err_class, back_trace_txt, "\n" )
  print error_txt
  return error_txt
end
#--------------------------------------------------------------------------
# * Raise errors that not occurred in Main Thread
#--------------------------------------------------------------------------
def flag_error(error)
  caller.each{|i| puts i}
  if !$error_activated
    error_txt = report_exception(error)
    Audio.se_play('Audio/SE/Buzzer1',80,100)
    info = Vocab::Errno::Exception
    print info
    msgbox(info)
    filename = "ErrorLog.txt"
    File.open(filename, 'w+') {|f| f.write(error_txt + "\n") }
  end
  
  $error_activated = true
  raise error.class, error.message, [$error_tracer_header]
end
#--------------------------------------------------------------------------
# * Find the error source
#--------------------------------------------------------------------------
def translate_debug_message(line)
  return line unless Plugins
  return line unless (line =~ /:(\d+):/)
  line_number = $1.to_i
  info = Plugins.find_file_by_line(line_number)
  line_number = line_number - info[4] + 1
  return sprintf("%s:%s:%s", info[1], line_number, line.split(':').last)
end
#--------------------------------------------------------------------------
def sprite_valid?(sprite)
  return sprite && !sprite.disposed? rescue false
end
#--------------------------------------------------------------------------
def debug_mode?
  return GameManager.debug_mode?
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
def setup_font
  
  if CurrentLanguage == :zh_tw
    Font.default_name = "NotoSansCJKtc-Regular"
  else
    Font.default_name = "Celestia Medium Redux"
  end
  puts "[Debug]: Setup Font #{Font.default_name}"
  Font.default_size = 24
  
end
#--------------------------------------------------------------------------
# * Alias: load_data
#--------------------------------------------------------------------------
alias load_data_pony load_data
def load_data(filename)
  SceneManager.update_loading
  load_data_pony(filename)
end
#--------------------------------------------------------------------------
alias puts_debug puts
def puts(*args)
  return unless debug_mode?
  args[0] = "<#{Time.now}> " + args[0] if args[0] =~ /\[(.*)\]/i
  puts_debug(*args)
end
#--------------------------------------------------------------------------
# * Overwrite the exit method to program-friendly
#--------------------------------------------------------------------------
def exit(stat = true)
  $exited = true
  SceneManager.scene.fadeout_all rescue nil
  Cache.release
  SceneManager.exit
end
#--------------------------------------------------------------------------
def sec_to_frame(t)
  return (t * Graphics.frame_rate).to_i
end
#--------------------------------------------------------------------------
