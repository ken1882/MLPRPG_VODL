#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  This processing is executed after module and class definition is finished.
#==============================================================================
unless $ENCRYPT
puts "[Debug]: Setup Font"
Font.default_name = "Celestia Medium Redux"
#Font.default_name = "dragon_alphabet"
Font.default_size = 24
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
    print "Submit the file \"ErrorLog.txt\" in your project folder to the upper most script creators noted in the message.\n"
    msgbox("An error has occurred during the game.\nPlease submit the file \"ErrorLog.txt\" in your game folder to the developer in order to fix the bug.\n")
    
    filename = "ErrorLog.txt"
    File.open(filename, 'w+') {|f| f.write(error_txt + "\n") }
  end
  
  $error_activated = true
  raise error.class, error.message, [error.backtrace.first]
end
$rgss   = self
$assist = RubyVM::InstructionSequence.compile("Thread.new{Thread_Assist.assist_main}.run")
begin
  rgss_main do
    begin
      Graphics.frame_rate = 60
      Mouse.init
      Mouse.cursor.visible = false
      $assist.eval
      SceneManager.run
    end
  end
rescue SystemExit
  exit
rescue Exception => error
  flag_error error
end # begin
end # unless $ENCRYPT
