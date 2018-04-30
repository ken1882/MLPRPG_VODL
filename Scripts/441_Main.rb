#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  This processing is executed after module and class definition is finished.
#==============================================================================
unless $ENCRYPT
  
setup_font
Graphics.resize_screen(640 ,480)
puts "[Debug]: Screen resized"
def report_exception(error)
  scripts_name = load_data('Data/Scripts.rvdata2')
  scripts_name.collect! {|script|  script[1]  }
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
begin
  rgss_main do
    begin
      Graphics.frame_rate = 60
      Cache.init
      Mouse.init
      Mouse.cursor.visible = false
      #PONY.InitOpenAL
      PONY.InitObjSpace
      $assist.eval
      SceneManager.run
    end
  end
rescue SystemExit
  exit
rescue Exception => error
  flag_error error
ensure
  PONY.CloseOpenAL
end # begin
end # unless $ENCRYPT