# Wrap some code with this to get useful traces when it fails.

def run_with_backtrace_handler
  begin
    yield
  rescue SystemExit
    raise "system exit"
  rescue Exception => error
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
    print error_line, ": ", error.message, " (#{error.class})", backtrace.join("\n\tfrom "), "\n"
    raise  error.class, "Error ocurred, check the debug console for more information.", [error.backtrace.first]
  end
end
