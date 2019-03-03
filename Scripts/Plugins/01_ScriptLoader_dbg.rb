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
