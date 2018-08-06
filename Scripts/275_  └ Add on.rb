#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs the title screen processing.
#==============================================================================
class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias start_gamemode start
  def start
    start_gamemode
    create_mode_menu
    #@mode_menu = 
  end
  #-------------------------------------------------------------------------
  alias post_start_msg post_start
  def post_start
    post_start_msg
    display_plugin_message
    display_connection_message
  end
  #-------------------------------------------------------------------------
  def display_plugin_message
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
  #-------------------------------------------------------------------------
  def display_connection_message
    return if PONY.online?
    info = Vocab::Offline
    raise_overlay_window(:popinfo, info: info, time: sec_to_frame(15))
    loop do
      update_basic
      @@overlay_windows[:popinfo].update
      break unless @@overlay_windows[:popinfo].visible?
    end
  end
  #-------------------------------------------------------------------------
  # * Overwrite: Re-arrange command order
  #-------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_TitleCommand.new
    @command_window.set_handler(:start_game, method(:command_start_game))
    @command_window.set_handler(:option,     method(:command_option))
    @command_window.set_handler(:credit,     method(:command_credit))
    @command_window.set_handler(:shutdown,   method(:command_shutdown))
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
  #--------------------------------------------------------------------------
  def command_start_game
    # last work: title option and other stuff
  end
  #--------------------------------------------------------------------------
  def command_option
    
  end
  #--------------------------------------------------------------------------
  def command_credit
    
  end
  #--------------------------------------------------------------------------
end
