#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs the title screen processing.
#==============================================================================
class Scene_Title < Scene_Base
  include PONY::GameMode
  #--------------------------------------------------------------------------
  # * Start Processing
  # Related script => tag: title_start
  #--------------------------------------------------------------------------
  alias start_gamemode start
  def start
    start_gamemode
    create_help_window
    create_mode_window
    create_option_window
    create_language_window
    create_progress_window
    # function calls supposed to add in MOG's animtaed title script
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
    # todo: fix message
    return 
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
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
    @help_window.z = PONY::SpriteDepth::Table[:override]
    @help_window.hide
  end
  #-------------------------------------------------------------------------
  def create_mode_window
    @mode_window = Window_GameMode.new(-12, @help_window.height - 2)
    @mode_window.set_z(PONY::SpriteDepth::Table[:override])
    @mode_window.help_window = @help_window
    @mode_window.set_handler(:ok, method(:on_mode_ok))
    @mode_window.set_handler(:cancel, method(:on_mode_cancel))
    @mode_window.hide
    @mode_window.deactivate
  end
  #-------------------------------------------------------------------------
  def create_option_window
    @option_window = Window_SystemOptions.new(@help_window)
    @option_window.set_handler(:cancel, method(:on_option_cancel))
    @option_window.set_handler(:language, method(:command_language))
    @option_window.z = PONY::SpriteDepth::Table[:override]
    @option_window.unselect
    @option_window.hide
    @option_window.deactivate
  end
  #-------------------------------------------------------------------------
  # * Overwrite: Re-arrange command order
  #-------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_TitleCommand.new
    @command_window.set_handler(:continue,   method(:command_continue))
    @command_window.set_handler(:start_game, method(:command_start_game))
    @command_window.set_handler(:option,     method(:command_option))
    @command_window.set_handler(:credits,     method(:command_credits))
    @command_window.set_handler(:shutdown,   method(:command_shutdown))
  end
  #---------------------------------------------------------------------------
  def create_progress_window
    @progress_window = Window_ProgressSelection.new(0, 0)
    @progress_window.set_handler(:new_game, method(:on_start_ok))
    @progress_window.set_handler(:load_game, method(:command_load))
    @progress_window.set_handler(:cancel, method(:on_progress_cancel))
    @progress_window.set_z(PONY::SpriteDepth::Table[:override] + 2)
    @progress_window.unselect
    @progress_window.hide
    @progress_window.deactivate
  end
  #--------------------------------------------------------------------------
  def create_language_window
    ww = 400 # window width
    wh = 320 # height
    cx = Graphics.center_width(ww)
    cy = Graphics.center_height(wh)
    @language_window = Window_LanguageList.new(cx, cy, ww, wh)
    @language_window.set_handler(:ok, method(:on_language_ok))
    @language_window.set_handler(:cancel, method(:on_language_cancel))
    @language_window.z = @option_window.z + 1
    @language_window.refresh
    @language_window.hide
  end
  #--------------------------------------------------------------------------
  def command_language
    @language_window.show
    @language_window.activate
    cur_index = GameManager.get_language_setting
    cur_index = ($supported_languages.keys.find_index(cur_index) || 0)
    @language_window.select(cur_index)
  end
  #--------------------------------------------------------------------------
  def on_language_ok
    symbol = @language_window.item
    raise_overlay_window(:popinfo, Vocab::System::Restart)
    on_language_cancel
    FileManager.write_ini('Option', 'Language', symbol.to_s)
    language_index = -1
    data = @option_window.list
    data.each_index{|i| language_index = i if data[i][:symbol] == :language}
    @option_window.draw_item(language_index) if language_index > 0
  end
  #--------------------------------------------------------------------------
  def on_language_cancel
    @language_window.hide
    @language_window.deactivate
    @option_window.activate
  end
  #--------------------------------------------------------------------------
  def command_continue
    file = DataManager.latest_savefile
    if file.nil?
      return @command_window.activate
    end
    result = DataManager.load_game(file.index, file.mode)
    if result == true
      on_load_success
    else
      @@overlay_windows[:popinfo].assign_last_window(@command_window)
      case result
      when :chainfile_missing
        PONY::ERRNO.raise(:file_missing, nil, nil, "#{DataManager.make_chainfilename(@file_window.index)}")
      when :checksum_missing
        PONY::ERRNO.raise(:file_missing, nil, nil, "#{DataManager.make_hashfilename(@file_window.index)}")
      when :checksum_failed
        PONY::ERRNO.raise(:checksum_failed)
      when :bits_incorrect
        # nothing, already showed the info
      else
        info = " The version of selected file is not compatible with current game version"
        @@overlay_windows[:popinfo].raise_overlay(info)
      end
    end
    close_command_window
  end
  #--------------------------------------------------------------------------
  def on_option_cancel
    @option_window.close
    @option_window.unselect
    @option_window.deactivate
    @help_window.close
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  def command_start_game
    @help_window.back_opacity = 0xff
    @help_window.swap_skin(WindowSkin::Luna)
    @help_window.open
    @command_window.deactivate
    @mode_window.activate
    @mode_window.select(0)
    @mode_window.open
  end
  #--------------------------------------------------------------------------
  def command_option
    @help_window.back_opacity = 0xc0
    @help_window.swap_skin(WindowSkin::Normal)
    @command_window.deactivate
    @help_window.open
    @option_window.open
    @option_window.activate
    @option_window.select(0)
  end
  #--------------------------------------------------------------------------
  def command_credits
    fadeout_all(1000)
    $game_temp.loading_destroy_delay = true
    init_gamemode(:credits)
    close_command_window
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
  end
  #--------------------------------------------------------------------------
  def command_load
    close_command_window
    SceneManager.call(Scene_Load)
  end
  #-------------------------------------------------------------------------
  def on_start_ok
    fadeout_all(1000)
    $game_temp.loading_destroy_delay = true
    init_gamemode(@mode_window.current_data[:symbol])
    close_command_window
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
  end
  #--------------------------------------------------------------------------
  def on_mode_ok
    $game_system.game_mode = @mode_window.current_item[:symbol]
    debug_print("Game mode selected: #{$game_system.game_mode}")
    @mode_window.cursor_sprite.x = 0
    @mode_window.cursor_sprite.y = 0
    @mode_window.cursor_sprite.z = @progress_window.z + 1
    @progress_window.open
    @progress_window.activate
    @progress_window.select(0)
    @help_window.clear
  end
  #--------------------------------------------------------------------------
  def on_progress_cancel
    @progress_window.deactivate
    @progress_window.close
    @progress_window.unselect
    @mode_window.cursor_sprite.z = @mode_window.z + 1
    @mode_window.update_cursor(true)
    @mode_window.activate
    @mode_window.update_help
  end
  #--------------------------------------------------------------------------
  def on_mode_cancel
    @mode_window.deactivate
    @mode_window.unselect
    @mode_window.close
    @help_window.close
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # new method: on_load_success
  #--------------------------------------------------------------------------
  def on_load_success
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end#--------------------------------------------------------------------------
end
