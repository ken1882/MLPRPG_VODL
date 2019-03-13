#--------------------------------------------------------------------------
# * Print error informations
#--------------------------------------------------------------------------
def report_exception(error)
  scripts_name = $RGSS_SCRIPTS.collect{|script|  script[1]  }
  backtrace = []

  error.backtrace.each_with_index {|line,i|
    if line =~ /:(\d+):/
      line_number = $1.to_i
    end

    if line =~ /{(.*)}(.*)/
      backtrace << (scripts_name[$1.to_i] + $2)
    elsif line.start_with?(':1:')
      break
    else
      backtrace << translate_debug_message(line)
    end
  }
  
  error_line = backtrace.first
  backtrace[0] = ''
  err_class = " (#{error.class})"
  back_trace_txt = backtrace.join("\n\tfrom ")
  $error_tracer_header = backtrace[0]
  error_txt = sprintf("%s %s %s %s %s %s",error_line, ": ", error.message, err_class, back_trace_txt, "\n" )
  error_txt = error_txt.force_encoding($default_encoding)
  print error_txt rescue nil
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
    info = (Vocab::Errno::Exception rescue "An error occurred during the gameplay, please submit \"ErrorLog.txt\" to the developers in order to resolve the problem.\n")
    info = info.force_encoding($default_encoding)
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
  return line unless (line =~ /:(\d+)/)
  line_number = $1.to_i
  info = Plugins.find_file_by_line(line_number)
  line_number = line_number - info[4] + 1
  msg = line.split(':'+$1.to_s)
  msg = msg.size > 1 ? msg.last : ''
  return sprintf("%s:%s%s", info[1], line_number, msg)
end
#--------------------------------------------------------------------------
def sprite_valid?(sprite)
  return sprite && !sprite.disposed? rescue false
end
#--------------------------------------------------------------------------
def debug_mode?
  return (GameManager.debug_mode? rescue true)
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
  SceneManager.update_loading if defined?(SceneManager.update_loading)
  load_data_pony(filename)
end
#--------------------------------------------------------------------------
alias puts_debug puts
def puts(*args)
  return unless debug_mode?
  args[0] = "<#{Time.now}> " + args[0] if args[0] =~ /\[(.*)\]/i
  begin
    puts_debug(*args)
  rescue Encoding::UndefinedConversionError
    args.each{|ar| ar = ar.to_s.force_encoding($default_encoding)}
    puts_debug(*args)
  end
end
#--------------------------------------------------------------------------
def change_encoding(target_encoding, *args)
  conv_proc = Proc.new{ |arg|
    if arg.is_a?(Regexp) && arg.encoding != target_encoding
      rear = arg.inspect.rindex('/')
      Regexp.new(arg.inspect[1...rear].force_encoding(target_encoding), Regexp::FIXEDENCODING | arg.options)
    elsif arg.is_a?(String) && arg.encoding != target_encoding
      arg.force_encoding(target_encoding)
    else
      arg
    end
  }
  if args.size == 0
    return nil
  elsif args.size == 1
    return conv_proc.call(args[0])
  else
    re_args = []
    args.each{|arg| re_args << conv_proc.call(arg)}
    return re_args
  end
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
