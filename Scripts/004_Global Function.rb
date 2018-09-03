#--------------------------------------------------------------------------
# * Print error informations
#--------------------------------------------------------------------------
def report_exception(error)
  scripts_name = $RGSS_SCRIPTS.collect{|script|  script[1]  }
  backtrace = []
  error.backtrace.each_with_index {|line,i|
    if line =~ /{(.*)}(.*)/
      backtrace << (scripts_name[$1.to_i] + $2)
    elsif line.start_with?(':1:')
      break
    else
      backtrace << line
    end
  }
  error_line = backtrace.first
  backtrace[0] = ''
  err_class = " (#{error.class})"
  back_trace_txt = backtrace.join("\n\tfrom ")
  error_txt = sprintf("%s %s %s %s %s %s",error_line, ": ", error.message, err_class, back_trace_txt, "\n" )
  print error_txt
  return error_txt
end
#--------------------------------------------------------------------------
# * Raise errors that not occurred in Main Thread
#--------------------------------------------------------------------------
def flag_error(error)
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
  raise error.class, error.message, [error.backtrace.first]
end
#--------------------------------------------------------------------------
def sprite_valid?(sprite)
  return sprite && !sprite.disposed? rescue false
end
#--------------------------------------------------------------------------
