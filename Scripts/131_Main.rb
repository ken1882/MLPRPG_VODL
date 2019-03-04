#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  This processing is executed after module and class definition is finished.
#==============================================================================
begin
  rgss_main do
    begin
      SceneManager.run
    end
  end
rescue SystemExit
  exit
rescue Exception => e
  report_exception e
  flag_error e
ensure
  PONY.CloseOpenAL
end # begin
