#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  This processing is executed after module and class definition is finished.
#==============================================================================
unless $ENCRYPT
setup_font
Graphics.resize_screen(640 ,480)
puts "[Debug]: Screen resized"
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
