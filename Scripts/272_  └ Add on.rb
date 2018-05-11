#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs the title screen processing.
#==============================================================================
class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * [New Game] Command
  #--------------------------------------------------------------------------
  def command_new_game
    fadeout_all(1000)
    $game_temp.loading_destroy_delay = true
    DataManager.setup_new_game
    close_command_window
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
  end
end
