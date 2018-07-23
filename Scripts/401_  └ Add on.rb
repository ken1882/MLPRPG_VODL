#==============================================================================
# ■ Window_SystemOptions
#==============================================================================
class Window_SystemOptions < Window_Command
  #--------------------------------------------------------------------------
  # * Check if allow to change_custom_switch
  #--------------------------------------------------------------------------
  def allow_to_change_switch?(id)
    case id
    when 0;
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Overwrite: change_custom_switch
  #--------------------------------------------------------------------------
  def change_custom_switch(direction)
    value = direction == :left ? false : true
    ext = current_ext
    current_case = $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]]
    current_id = YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]
    
    return unless allow_to_change_switch?(current_id)
    
    if direction == :xor
      $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]] ^= 1
    else
      $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]] = value
    end
    
    on_switch_change(current_id, $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]])
    Sound.play_cursor if value != current_case
    draw_item(index)
  end
  #--------------------------------------------------------------------------
  def on_switch_change(id, stat)
    case id
    when 0;
    end
  end
  #--------------------------------------------------------------------------
  # Overwrite: draw_custom_variable
  #--------------------------------------------------------------------------
  def draw_custom_variable(rect, index, ext)
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    #---
    dx = contents.width / 2
    id = YEA::SYSTEM::CUSTOM_VARIABLES[ext][0]
    value = $game_variables[id]
    colour1 = text_color(YEA::SYSTEM::CUSTOM_VARIABLES[ext][2])
    colour2 = text_color(YEA::SYSTEM::CUSTOM_VARIABLES[ext][3])
    minimum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][4]
    maximum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][5]
    rate = (value - minimum).to_f / [(maximum - minimum).to_f, 0.01].max
    dx = contents.width/2
    draw_gauge(dx, rect.y, contents.width - dx - 48, rate, colour1, colour2)
    
    show_text = get_setting_type_text(id, value)
    show_text = value if !show_text
    draw_text(dx, rect.y, contents.width - dx - 48, line_height,show_text, 2)
    # prevent overflow
    $game_variables[id] = minimum if value < minimum
    $game_variables[id] = maximum if value > maximum
  end
  #--------------------------------------------------------------------------
  def get_setting_type_text(id, value)
    case id
    when 33 # Combat difficulty
      return Vocab::System::DifficultyName[0] if value == 0
      return Vocab::System::DifficultyName[1] if value == 1
      return Vocab::System::DifficultyName[2] if value == 2
      return Vocab::System::DifficultyName[3] if value == 3
    end
  end
  #--------------------------------------------------------------------------
  # Alias: ok_enabled?
  #--------------------------------------------------------------------------
  alias :language_ok_enabled? :ok_enabled?
  def ok_enabled?
    return true if [:language].include?(current_symbol)
    return language_ok_enabled?
  end
  #--------------------------------------------------------------------------
  # Overwrite: make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    @help_descriptions = {}
    for command in YEA::SYSTEM::COMMANDS
      case command
      when :blank
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :window_red, :window_grn, :window_blu
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :volume_bgm, :volume_bgs, :volume_sfx
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :autodash, :instantmsg, :animations
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :to_title, :shutdown, :language
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      else
        process_custom_switch(command)
        process_custom_variable(command)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Overwrite: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    reset_font_settings
    rect = item_rect(index)
    contents.clear_rect(rect)
    case @list[index][:symbol]
    when :window_red, :window_grn, :window_blu
      draw_window_tone(rect, index, @list[index][:symbol])
    when :volume_bgm, :volume_bgs, :volume_sfx
      draw_volume(rect, index, @list[index][:symbol])
    when :autodash, :instantmsg, :animations
      draw_toggle(rect, index, @list[index][:symbol])
    when :to_title, :shutdown
      draw_text(item_rect_for_text(index), command_name(index), 1)
    when :language
      draw_language_setting(index)
    when :custom_switch
      draw_custom_switch(rect, index, @list[index][:ext])
    when :custom_variable
      draw_custom_variable(rect, index, @list[index][:ext])
    end
  end
  #--------------------------------------------------------------------------
  def draw_language_setting(index)
    rect = item_rect(index)
    name = command_name(index)
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    dx   = contents.width / 2
    option = $supported_languages[$game_console.get_language_setting]
    draw_text(dx, rect.y, contents.width/4, line_height, option, 1)
  end
  #--------------------------------------------------------------------------
  def create_overlay_window
    info = Vocab::System::UnsavedInfo
    @overlay_window = Window_Confirm.new(160, 180, info)
  end
  #--------------------------------------------------------------------------
  def call_ok_handler
    if current_symbol == :to_title || current_symbol == :shutdown
      raise_overlay(nil, :call_handler, current_symbol)
    else
      super
    end
  end
  #--------------------------------------------------------------------------
end
#==============================================================================
# ■ Scene_System
#==============================================================================
class Scene_System < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Alias: start
  #--------------------------------------------------------------------------
  alias start_lanwin start
  def start
    start_lanwin
    create_language_window
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Cache.background("canterlot_library")
  end
  #--------------------------------------------------------------------------
  # Alias: create_command_window
  #--------------------------------------------------------------------------
  alias create_command_lan_window create_command_window
  def create_command_window
    create_command_lan_window
    @command_window.set_handler(:language, method(:command_language))
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
    @language_window.z = @command_window.z + 1
    @language_window.refresh
    @language_window.hide
  end
  #--------------------------------------------------------------------------
  def command_language
    @language_window.show
    @language_window.activate
    cur_index = $game_console.get_language_setting
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
    data = @command_window.list
    data.each_index{|i| language_index = i if data[i][:symbol] == :language}
    @command_window.draw_item(language_index) if language_index > 0
  end
  #--------------------------------------------------------------------------
  def on_language_cancel
    @language_window.hide
    @command_window.activate
  end
  #--------------------------------------------------------------------------
end
