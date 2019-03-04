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
    if line =~ /:(\d+):/
      line_number = $1.to_i
    end
    if line =~ /{(.*)}(.*)/
      backtrace << (scripts_name[$1.to_i] + $2)
    elsif line.start_with?(':1:')
      break
    elsif translate_flag || line_number > 2000
      backtrace << translate_debug_message(line)
    else
      backtrace << line
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
  return error_txt.force_encoding($default_encoding)
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
  return line unless (line =~ /:(\d+):/)
  line_number = $1.to_i
  info = Plugins.find_file_by_line(line_number)
  line_number = line_number - info[4] + 1
  return sprintf("%s:%s:%s", info[1], line_number, line.split(':').last)
end
#-------------------------------------------------------------------------------
# * Add tracers for easier debug
#-------------------------------------------------------------------------------
$TracerCode = %{
rescue SystemExit
  exit
rescue Exception => e
  report_exception(e)
  flag_error(e)
end
}
$LoaderMethodNames = ["loader_eval", "rgss_main"]
def loader_eval(*args, &block)
  eval(*args, &block)
end
