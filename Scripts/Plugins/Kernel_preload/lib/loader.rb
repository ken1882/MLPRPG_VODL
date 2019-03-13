begin
  load_script 'rubyctest.so'
rescue Exception => e
  report_exception(e)
  flag_error(e)
end