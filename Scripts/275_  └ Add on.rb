#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs the title screen processing.
#==============================================================================
class Scene_Title < Scene_Base
  #-------------------------------------------------------------------------
  alias post_start_msg post_start
  def post_start
    post_start_msg
    display_init_message
  end
  #-------------------------------------------------------------------------
  def display_init_message
    if !$plugin_loaded
      info = Vocab::Errno::PluginInitErr
    elsif PluginManager.load_error.size > 1
      info = Vocab::Errno::PluginLoadErr
      File.open("PluginErr.txt", "w") do |file|
        info.each do |err|
          file.write(err + SPLIT_LINE + 10.chr)
        end
      end
    else
      info = nil
    end
    return if info.nil?
    
    raise_overlay_window(:popinfo, info)
    loop do
      update_basic
       @@overlay_windows[:popinfo].update
      break unless @@overlay_windows[:popinfo].visible?
    end
  end
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
