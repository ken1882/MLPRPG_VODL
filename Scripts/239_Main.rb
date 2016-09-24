#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  This processing is executed after module and class definition is finished.
#==============================================================================
Font.default_name = "Celestia Medium Redux"
Font.default_size = 24
Graphics.resize_screen(640, 480)
rgss_main { SceneManager.run }
