#==============================================================================
# 
# ▼ Yanfly Engine Ace - System Options v1.00
# -- Last Updated: 2012.01.01
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-SystemOptions"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.01 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script replaces the "Game End" option in the Main Menu with a "System"
# menu where the player can adjust various settings in the game. Of them, the
# player can change the window colour, the volume for BGM, BGS, SFX, set
# automatic dashing, message text to display instantly, and speed up battles by
# hiding battle animations.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# $game_system.volume_change(:bgm, x)
# $game_system.volume_change(:bgs, x)
# $game_system.volume_change(:sfx, x)
# Unlike the previous Yanfly Engines, this version does not bind volume to a
# variable. Use the script call to change the bgm, bgs, or sfx sound rate by
# x increment. Use a negative value to lower the volume.
# 
# $game_system.set_autodash(true)
# $game_system.set_autodash(false)
# Turns autodash on (true) or off (false).
# 
# $game_system.set_instantmsg(true)
# $game_system.set_instantmsg(false)
# Turns instant messages on (true) or off (false).
# 
# $game_system.set_animations(true)
# $game_system.set_animations(false)
# Turns battle animations on (true) or off (false).
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module SYSTEM
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Setting -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are the general settings that govern the System settings. This will
    # change the "Game End" vocab, and disable or enable autodash, instant
    # messages, or animations by default.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMAND_NAME = "System"      # Command name used to replace Game End.
    DEFAULT_AUTODASH   = false    # Enable automatic dashing by default?
    DEFAULT_INSTANTMSG = false   # Enable instant message text by default?
    DEFAULT_ANIMATIONS = true    # Enable battle animations by default?
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Command Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the commands shown in the command list. Add, remove
    # or rearrange the commands as you see fit. Here's a list of which commands
    # do what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :blank           Inserts an empty blank space.
    # 
    # :window_red      Changes the red tone for all windows.
    # :window_grn      Changes the green tone for all windows.
    # :window_blu      Changes the blue tone for all windows.
    # 
    # :volume_bgm      Changes the BGM volume used.
    # :volume_bgs      Changes the BGS volume used.
    # :volume_sfx      Changes the SFX volume used.
    # 
    # :autodash        Sets the player to automatically dash.
    # :instantmsg      Sets message text to appear instantly.
    # :animations      Enables battle animations or disables them.
    # 
    # :to_title        Returns to the title screen.
    # :shutdown        Shuts down the game.
    # 
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMANDS =[
      #:window_red,   # Changes the red tone for all windows.
      #:window_grn,   # Changes the green tone for all windows.
      #:window_blu,   # Changes the blue tone for all windows.
      :volume_bgm,   # Changes the BGM volume used.
      :volume_bgs,   # Changes the BGS volume used.
      :volume_sfx,   # Changes the SFX volume used.
      :blank,
      :autodash,     # Sets the player to automatically dash.
     # :instantmsg,   # Sets message text to appear instantly.
      #:animations,   # Enables battle animations or disables them.
      :blank,
     :switch_1,     # auto save
     :variable_3, #location
     :variable_1, #step
     :switch_4, #b4 combat
     :switch_5, #switch map
     :blank,
     
     #:switch_2,     # A*/BFS
     #:switch_3,     # double A*?
     :switch_6,   #battle state window
     #:variable_4, #max battle member
     :variable_5, # combat difficulty
     #:variable_6, # battle speed
      
     :switch_8, # show d20 result
     :switch_9, # light effects
     #:variable_2, # A* method
      :blank,
      
     # :switch_7,
      
      :blank,
      :to_title,     # Returns to the title screen.
      :shutdown,     # Shuts down the game.
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Custom Switches -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If you want your game to have system options other than just the ones
    # listed above, you can insert custom switches here to produce such an
    # effect. Adjust the settings here as you see fit.
    #--------------------------------------------------------------------------
    CUSTOM_SWITCHES ={
    # -------------------------------------------------------------------------
    # :switch    => [Switch, Name, Off Text, On Text, 
    #                Help Window Description
    #               ], # Do not remove this.
    # -------------------------------------------------------------------------
      :switch_1  => [ 4, "Auto Save", "OFF", "ON",
                     "Auto save file if it's allowed. Save location is at the buttom\n" +
                     "of the files."
                    ],
    # -------------------------------------------------------------------------
      :switch_2  => [ 5, "搜尋演算法", "A*", "BFS",
                    "A*:速度較BFS快,但路徑不保證為最短
                    " +
                     "BFS:保證路徑最短,但相當費時"
                    ],
    # -------------------------------------------------------------------------
      :switch_3  => [ 6, "雙倍A*", "OFF", "ON",
                    "大幅提高A*準確度,但是時間約為原本的兩倍"
                    ],
    # -------------------------------------------------------------------------
      :switch_4  => [ 7, "Auto-save before combat", "OFF", "ON",
                    "Auto-save file before into a combat scene"
                    ],
    # -------------------------------------------------------------------------
      :switch_5  => [ 8, "Auto-save after changed map", "OFF", "ON",
                    "Auto-save after you entered a different map"
                    ],
    # -------------------------------------------------------------------------
      :switch_6  => [ 14,"Combat party status window", "Simple", "Fancy",
                    "Change party member's status UI in combat. But fancy one eats \nmore system resources so beware if your computer can handle this!"
                    ],
    # -------------------------------------------------------------------------
      :switch_7  => [ 12, "啟用戰鬥語音", "ON", "OFF",
                    "開關進入戰鬥時的開場白以及戰鬥時的部分語音效果"
                    ],
    # -------------------------------------------------------------------------
      :switch_8  => [ 15, "Show Dice Roll Result", "Hide", "Show",
                    "Hide/Show d20 roll result on battle log. Such as roll a saving throw, \ndetermine some skill's damage or even detect secret door."
                    ],
    # -------------------------------------------------------------------------
      :switch_9  => [ 21, "Lights Effects", "Disable", "Enable",
                    "Enable Light effect in normal situation? Please notice When you're\n" +
                    "in a dark cave or other similar place the light effects will still go on."
                    ],
    
                    
    # -------------------------------------------------------------------------
    } # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Custom Variables -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If you want your game to have system options other than just the ones
    # listed above, you can insert custom variables here to produce such an
    # effect. Adjust the settings here as you see fit.
    #--------------------------------------------------------------------------
    CUSTOM_VARIABLES ={
    # -------------------------------------------------------------------------
    # :variable   => [Switch, Name, Colour1, Colour2, Min, Max,
    #                 Help Window Description,init value
    #                ], # Do not remove this.
    # -------------------------------------------------------------------------
      :variable_1 => [ 16, "Auto-save steps" ,9, 1, 0, 1000,
                      "Auto-save after you walked a certain steps, 0 = inactive"
                     ],
    # -------------------------------------------------------------------------
      :variable_2 => [ 17, "A* priority algorithm", 10, 2, 0,3,
                      "The path finding algorithm's calculate method you wish to use"
                     ],
    # -------------------------------------------------------------------------
      #:variable_3 => [ 18, "Auto-save location", 11,3 , 1,50,
      #                "When auto-save, the number of file you'd like to save to"
      #               ],
    # ------------------------------------------------------------------------- 
      :variable_4 => [ 30, "Max battle members", 30,31 , 1,6,
                      "More ponies join the battle require more system resource. \nBeware if your computer can handle this!"
                     ],
    # ------------------------------------------------------------------------- 
      :variable_5 => [ 33, "Combat Difficulty", 30,31 , 1,4,
                      "Change enemy's HP/Stat value. Easy: 0.5x/0.8x;  Normal:1x/ \n" +
                      "1x;  Hard:1.5x/1.2x;  Expert:2x/1.5x."
                     ],
    # ------------------------------------------------------------------------- 
      :variable_6 => [ 34, "ATB Speed", 1,9 , 1,10,
                      "Change ATB Speed, higher value will makes the battle's\n" +
                      "process faster."
                     ],
                     
    # -------------------------------------------------------------------------
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Vocab Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This hash adjusts the vocab used for both the commands and the help
    # description that appears above the command window. Note that for the
    # command help descriptions, you may use text codes. Use \n to linebreak.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMAND_VOCAB ={
    # -------------------------------------------------------------------------
    # :command    => [Command Name, Option1, Option2
    #                 Help Window Description,
    #                ], # Do not remove this.
    # -------------------------------------------------------------------------
      :blank      => ["", "None", "None",
                      ""
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :window_red => ["Window Red", "None", "None",
                      "Change the red colour tone for windows.\n" +
                      "Hold SHIFT to change increment by 10."
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :window_grn => ["Window Green", "None", "None",
                      "Change the green colour tone for windows.\n" +
                      "Hold SHIFT to change increment by 10."
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :window_blu => ["Window Blue", "None", "None",
                      "Change the blue colour tone for windows.\n" +
                      "Hold SHIFT to change increment by 10."
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
#      :volume_bgm => ["BGM Volume", 12, 4, # Options 1 & 2 are Gauge Colours.
 #                     "Change the volume used for background music.\n" +
 #                     "Hold SHIFT to change increment by 10."
 #                    ], # Do not remove this.
    # -------------------------------------------------------------------------
      :volume_bgm => ["BGM Volume", 12, 4, # Options 1 & 2 are Gauge Colours.
                      "Adjust the volume of background music.\n" +
                      "Hold SHIFT to change increment by 10."
                     ], # Do not remove this.
                     
    # -------------------------------------------------------------------------
      :volume_bgs => ["BGS Volume", 13, 5, # Options 1 & 2 are Gauge Colours.
                      "Adjust the volume of backgrounf sound.\n" +
                      "Hold SHIFT to change increment by 10."
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :volume_sfx => ["SE Volume", 14, 6, # Options 1 & 2 are Gauge Colours.
                      "Adjust the volume of sound effect.\n" +
                      "Hold SHIFT to change increment by 10."
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :autodash   => ["Auto-Dash", "Off", "On",
                      "Walk/Run when you are NOT holding shift"
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :instantmsg => ["Instant Text", "Normal", "Instant",
                      "Set message text to appear one-by-one or instantly."
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :animations => ["Battle Animations", "Hide", "Show",
                      "Hide animations during battle to speed up battles?"
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :to_title   => ["Back to title", "None", "None",
                      "End the current game and back to title screen, don't forget to SAVE!"
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :shutdown   => ["Exit", "None", "None",
                      "Shut down the game, don't forget to SAVE!"
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
    } # Do not remove this.
    
  end # SYSTEM
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab
  
  #--------------------------------------------------------------------------
  # overwrite method: self.game_end
  #--------------------------------------------------------------------------
  def self.game_end
    return YEA::SYSTEM::COMMAND_NAME
  end
  
end # Vocab

#==============================================================================
# ■ RPG::BGM
#==============================================================================

class RPG::BGM < RPG::AudioFile
  
  #--------------------------------------------------------------------------
  # overwrite method: play
  #--------------------------------------------------------------------------
  def play(pos = 0)
    if @name.empty?
      Audio.bgm_stop
      @@last = RPG::BGM.new
    else
      volume = @volume
      volume *= $game_system.volume(:bgm) * 0.01 unless $game_system.nil?
      Audio.bgm_play('Audio/BGM/' + @name, volume, @pitch, pos)
      @@last = self.clone
    end
  end
  
end # RPG::BGM

#==============================================================================
# ■ RPG::ME
#==============================================================================

class RPG::ME < RPG::AudioFile
  
  #--------------------------------------------------------------------------
  # overwrite method: play
  #--------------------------------------------------------------------------
  def play
    if @name.empty?
      Audio.me_stop
    else
      volume = @volume
      volume *= $game_system.volume(:bgm) * 0.01 unless $game_system.nil?
      Audio.me_play('Audio/ME/' + @name, volume, @pitch)
    end
  end
  
end # RPG::ME

#==============================================================================
# ■ RPG::BGS
#==============================================================================

class RPG::BGS < RPG::AudioFile
  
  #--------------------------------------------------------------------------
  # overwrite method: play
  #--------------------------------------------------------------------------
  def play(pos = 0)
    if @name.empty?
      Audio.bgs_stop
      @@last = RPG::BGS.new
    else
      volume = @volume
      volume *= $game_system.volume(:bgs) * 0.01 unless $game_system.nil?
      Audio.bgs_play('Audio/BGS/' + @name, volume, @pitch, pos)
      @@last = self.clone
    end
  end
  
end # RPG::BGS

#==============================================================================
# ■ RPG::SE
#==============================================================================

class RPG::SE < RPG::AudioFile
  
  #--------------------------------------------------------------------------
  # overwrite method: play
  #--------------------------------------------------------------------------
  def play
    unless @name.empty?
      volume = @volume
      volume *= $game_system.volume(:sfx) * 0.01 unless $game_system.nil?
      Audio.se_play('Audio/SE/' + @name, volume, @pitch)
    end
  end
  
end # RPG::SE

#==============================================================================
# ■ Game_System
#==============================================================================

class Game_System
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_system_initialize_so initialize
  def initialize
    game_system_initialize_so
    init_volume_control
    init_autodash
    init_instantmsg
    init_animations
  end
  
  #--------------------------------------------------------------------------
  # new method: init_volume_control
  #--------------------------------------------------------------------------
  def init_volume_control
    @volume = {}
    @volume[:bgm] = 100
    @volume[:bgs] = 100
    @volume[:sfx] = 100
  end
  
  #--------------------------------------------------------------------------
  # new method: volume
  #--------------------------------------------------------------------------
  def volume(type)
    init_volume_control if @volume.nil?
    return [[@volume[type], 0].max, 100].min
  end
  
  #--------------------------------------------------------------------------
  # new method: volume_change
  #--------------------------------------------------------------------------
  def volume_change(type, increment)
    init_volume_control if @volume.nil?
    @volume[type] += increment
    @volume[type] = [[@volume[type], 0].max, 100].min
  end
  
  #--------------------------------------------------------------------------
  # new method: init_autodash
  #--------------------------------------------------------------------------
  def init_autodash
    @autodash = YEA::SYSTEM::DEFAULT_AUTODASH
  end
  
  #--------------------------------------------------------------------------
  # new method: autodash?
  #--------------------------------------------------------------------------
  def autodash?
    init_autodash if @autodash.nil?
    return @autodash
  end
  
  #--------------------------------------------------------------------------
  # new method: set_autodash
  #--------------------------------------------------------------------------
  def set_autodash(value)
    @autodash = value
  end
  
  #--------------------------------------------------------------------------
  # new method: init_instantmsg
  #--------------------------------------------------------------------------
  def init_instantmsg
    @instantmsg = YEA::SYSTEM::DEFAULT_INSTANTMSG
  end
  
  #--------------------------------------------------------------------------
  # new method: instantmsg?
  #--------------------------------------------------------------------------
  def instantmsg?
    init_instantmsg if @instantmsg.nil?
    return @instantmsg
  end
  
  #--------------------------------------------------------------------------
  # new method: set_instantmsg
  #--------------------------------------------------------------------------
  def set_instantmsg(value)
    @instantmsg = value
  end
  
  #--------------------------------------------------------------------------
  # new method: init_animations
  #--------------------------------------------------------------------------
  def init_animations
    @animations = YEA::SYSTEM::DEFAULT_ANIMATIONS
  end
  
  #--------------------------------------------------------------------------
  # new method: animations?
  #--------------------------------------------------------------------------
  def animations?
    init_animations if @animations.nil?
    return @animations
  end
  
  #--------------------------------------------------------------------------
  # new method: set_animations
  #--------------------------------------------------------------------------
  def set_animations(value)
    @animations = value
  end
  
end # Game_System

#==============================================================================
# ■ Game_Player
#==============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # alias method: dash?
  #--------------------------------------------------------------------------
  alias game_player_dash_so dash?
  def dash?
    if $game_system.autodash?
      return false if @move_route_forcing
      return false if $game_map.disable_dash?
      return false if vehicle
      return !Input.press?(:A)
    else
      return game_player_dash_so
    end
  end
  
end # Game_Player

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: show_fast?
  #--------------------------------------------------------------------------
  alias scene_battle_show_fast_so show_fast?
  def show_fast?
    return true unless $game_system.animations?
    return scene_battle_show_fast_so
  end
  
  #--------------------------------------------------------------------------
  # alias method: show_normal_animation
  #--------------------------------------------------------------------------
  alias scene_battle_show_normal_animation_so show_normal_animation
  def show_normal_animation(targets, animation_id, mirror = false)
    return unless $game_system.animations?
    scene_battle_show_normal_animation_so(targets, animation_id, mirror)
  end
  
end # Scene_Battle

#==============================================================================
# ■ Window_Message
#==============================================================================

class Window_Message < Window_Base
  
  #--------------------------------------------------------------------------
  # alias method: clear_flags
  #--------------------------------------------------------------------------
  alias window_message_clear_flags_so clear_flags
  def clear_flags
    window_message_clear_flags_so
    @show_fast = true if $game_system.instantmsg?
  end
  
end # Window_Message

#==============================================================================
# ■ Window_SystemOptions
#==============================================================================

class Window_SystemOptions < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(help_window)
    @help_window = help_window
    super(0, @help_window.height)
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - @help_window.height; end
  
  #--------------------------------------------------------------------------
  # update_help
  #--------------------------------------------------------------------------
  def update_help
    if current_symbol == :custom_switch || current_symbol == :custom_variable
      text = @help_descriptions[current_ext]
    else
      text = @help_descriptions[current_symbol]
    end
    text = "" if text.nil?
    @help_window.set_text(text)
  end
  
  #--------------------------------------------------------------------------
  # ok_enabled?
  #--------------------------------------------------------------------------
  def ok_enabled?
    return true if [:to_title, :shutdown].include?(current_symbol)
    return false
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
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
      when :to_title, :shutdown
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      else
        process_custom_switch(command)
        process_custom_variable(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # process_custom_switch
  #--------------------------------------------------------------------------
  def process_custom_switch(command)
    return unless YEA::SYSTEM::CUSTOM_SWITCHES.include?(command)
    name = YEA::SYSTEM::CUSTOM_SWITCHES[command][1]
    add_command(name, :custom_switch, true, command)
    @help_descriptions[command] = YEA::SYSTEM::CUSTOM_SWITCHES[command][4]
  end
  
  #--------------------------------------------------------------------------
  # process_custom_variable
  #--------------------------------------------------------------------------
  def process_custom_variable(command)
    return unless YEA::SYSTEM::CUSTOM_VARIABLES.include?(command)
    name = YEA::SYSTEM::CUSTOM_VARIABLES[command][1]
    add_command(name, :custom_variable, true, command)
    @help_descriptions[command] = YEA::SYSTEM::CUSTOM_VARIABLES[command][6]
    
    #precent overflow
    
  end
  
  #--------------------------------------------------------------------------
  # draw_item
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
    when :custom_switch
      draw_custom_switch(rect, index, @list[index][:ext])
    when :custom_variable
      draw_custom_variable(rect, index, @list[index][:ext])
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_window_tone
  #--------------------------------------------------------------------------
  def draw_window_tone(rect, index, symbol)
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    #---
    dx = contents.width / 2
    tone = $game_system.window_tone
    
    case symbol
    when :window_red
      rate = (tone.red + 255.0) / 510.0
      colour1 = Color.new(128, 0, 0)
      colour2 = Color.new(255, 0, 0)
      value = tone.red.to_i
    when :window_grn
      rate = (tone.green + 255.0) / 510.0
      colour1 = Color.new(0, 128, 0)
      colour2 = Color.new(0, 255, 0)
      value = tone.green.to_i
    when :window_blu
      rate = (tone.blue + 255.0) / 510.0
      colour1 = Color.new(0, 0, 128)
      colour2 = Color.new(0, 0, 255)
      value = tone.blue.to_i
    end
    draw_gauge(dx, rect.y, contents.width - dx - 48, rate, colour1, colour2)
    draw_text(dx, rect.y, contents.width - dx - 48, line_height, value, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_volume
  #--------------------------------------------------------------------------
  def draw_volume(rect, index, symbol)
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    #---
    dx = contents.width / 2
    case symbol
    when :volume_bgm
      rate = $game_system.volume(:bgm)
    when :volume_bgs
      rate = $game_system.volume(:bgs)
    when :volume_sfx
      rate = $game_system.volume(:sfx)
    end
    colour1 = text_color(YEA::SYSTEM::COMMAND_VOCAB[symbol][1])
    colour2 = text_color(YEA::SYSTEM::COMMAND_VOCAB[symbol][2])
    value = sprintf("%d%%", rate)
    rate *= 0.01
    draw_gauge(dx, rect.y, contents.width - dx - 48, rate, colour1, colour2)
    draw_text(dx, rect.y, contents.width - dx - 48, line_height, value, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_toggle
  #--------------------------------------------------------------------------
  def draw_toggle(rect, index, symbol)
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    #---
    dx = contents.width / 2
    case symbol
    when :autodash
      enabled = $game_system.autodash?
    when :instantmsg
      enabled = $game_system.instantmsg?
    when :animations
      enabled = $game_system.animations?
    end
    dx = contents.width/2
    change_color(normal_color, !enabled)
    option1 = YEA::SYSTEM::COMMAND_VOCAB[symbol][1]
    draw_text(dx, rect.y, contents.width/4, line_height, option1, 1)
    dx += contents.width/4
    change_color(normal_color, enabled)
    option2 = YEA::SYSTEM::COMMAND_VOCAB[symbol][2]
    draw_text(dx, rect.y, contents.width/4, line_height, option2, 1)
  end
  
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def draw_custom_switch(rect, index, ext)
    if YEA::SYSTEM::CUSTOM_SWITCHES[ext][0] == 14
      $game_switches[14] = $battle_party_status_UI
      #puts "#{$game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]]} , #{$battle_party_status_UI}"
    elsif YEA::SYSTEM::CUSTOM_SWITCHES[ext][0] == 21
      $game_switches[21] = $light_effects || $light_effects_forced
    end
    
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    #---
    dx = contents.width / 2
    enabled = $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]]
    dx = contents.width/2
    change_color(normal_color, !enabled)
    option1 = YEA::SYSTEM::CUSTOM_SWITCHES[ext][2]
    draw_text(dx, rect.y, contents.width/4, line_height, option1, 1)
    dx += contents.width/4
    change_color(normal_color, enabled)
    option2 = YEA::SYSTEM::CUSTOM_SWITCHES[ext][3]
    draw_text(dx, rect.y, contents.width/4, line_height, option2, 1)
    
  end
  
  #--------------------------------------------------------------------------
  # draw_custom_variable
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
    
    type = ""
    case id
    when 17
      case value
      when 0
        type = "Fast"
      when 1
        type = "X axis priority"
      when 2
        type = "Y axis priority"
      when 3
        type = "Maze"
      end
    when 33
      case value
        when 1
          type = "Novice"
        when 2
          type = "Normal"
        when 3
          type = "Advanced"
        when 4
          type = "Expert"
      end
    when 34
      $game_system.battle_speed = value
    end
    
    show_text = type.size > 1 ? type : value
    draw_text(dx, rect.y, contents.width - dx - 48, line_height,show_text, 2)
    #prevent overflow
    $game_variables[id] = minimum if value < minimum
    $game_variables[id] = maximum if value > maximum
  end
  
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    cursor_change(:right)
    super(wrap)
  end
  
  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    cursor_change(:left)
    super(wrap)
  end
  
  #--------------------------------------------------------------------------
  # cursor_change
  #--------------------------------------------------------------------------
  def cursor_change(direction)
    case current_symbol
    when :window_red, :window_blu, :window_grn
      change_window_tone(direction)
    when :volume_bgm, :volume_bgs, :volume_sfx
      change_volume(direction)
    when :autodash, :instantmsg, :animations
      change_toggle(direction)
    when :custom_switch
      change_custom_switch(direction)
    when :custom_variable
      change_custom_variables(direction)
    end
  end
  
  #--------------------------------------------------------------------------
  # change_window_tone
  #--------------------------------------------------------------------------
  def change_window_tone(direction)
    Sound.play_cursor
    value = direction == :left ? -1 : 1
    value *= 10 if Input.press?(:A)
    tone = $game_system.window_tone.clone
    case current_symbol
    when :window_red; tone.red += value
    when :window_grn; tone.green += value
    when :window_blu; tone.blue += value
    end
    $game_system.window_tone = tone
    draw_item(index)
  end
  
  #--------------------------------------------------------------------------
  # change_window_tone
  #--------------------------------------------------------------------------
  def change_volume(direction)
    Sound.play_cursor
    value = direction == :left ? -1 : 1
    value *= 10 if Input.press?(:A)
    case current_symbol
    when :volume_bgm
      $game_system.volume_change(:bgm, value)
      RPG::BGM::last.play
    when :volume_bgs
      $game_system.volume_change(:bgs, value)
      RPG::BGS::last.play
    when :volume_sfx
      $game_system.volume_change(:sfx, value)
    end
    draw_item(index)
  end
  
  #--------------------------------------------------------------------------
  # change_toggle
  #--------------------------------------------------------------------------
  def change_toggle(direction)
    value = direction == :left ? false : true
    case current_symbol
    when :autodash
      current_case = $game_system.autodash?
      $game_system.set_autodash(value)
    when :instantmsg
      current_case = $game_system.instantmsg?
      $game_system.set_instantmsg(value)
    when :animations
      current_case = $game_system.animations?
      $game_system.set_animations(value)
    end
    Sound.play_cursor if value != current_case
    draw_item(index)
  end
  #--------------------------------------------------------------------------
  # check if allow to change_custom_switch
  #--------------------------------------------------------------------------
  def allow_to_change_switch?(id)
    if id == 21
      if $light_effects_forced
        msgbox("The Light Effects is forced to turn on currently,\n" + "so you can't disable it right now.")
        return false
      end
    end
    
    return true
  end
  #--------------------------------------------------------------------------
  # change_custom_switch
  #--------------------------------------------------------------------------
  def change_custom_switch(direction)
    
    value = direction == :left ? false : true
    ext = current_ext
    current_case = $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]]
    current_id = YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]
    
    return unless allow_to_change_switch?(current_id)
    
    $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]] = value
    
    $battle_party_status_UI = $game_switches[14]
    $light_effects          = $game_switches[21]
    
    if current_id == 14 || current_id == 21
      
      file = File.new("Game.ini", "r")
      parameter_index = []
      
      while (line = file.gets)
        parameter_index.push(line)
      end
      
      status = ''
      info   = ''
      
      if current_id == 14
        obj = "BattleStatusUI"
        status = $battle_party_status_UI == true ? '1' : '0'
        info = $battle_party_status_UI ? "Fancy" : "Simple" 
      elsif current_id == 21
        obj = "LightEffects"
        status = $light_effects == true ? '1' : '0'
        info = $light_effects ? "Light Effects ON" : "Light Effects OFF"
      end
      
      file.close
      for i in 0...parameter_index.size
        if parameter_index[i].include?(obj)
          for j in 0...parameter_index[i].size
            if parameter_index[i][j] == '1' || parameter_index[i][j] == '0'
              parameter_index[i][j] = status
              msgbox("Current setting: #{info}\nYou gotta close and re-open the game to apply this change")
            end
          end
        end
      end
      
      file = File.new("Game.ini", "w")
        for str in parameter_index
          file.write(str)
          puts "#{str}"
        end
      file.close
      
    end
    
    Sound.play_cursor if value != current_case
    draw_item(index)
  end
  
  #--------------------------------------------------------------------------
  # change_custom_variables
  #--------------------------------------------------------------------------
  def change_custom_variables(direction)
    Sound.play_cursor
    value = direction == :left ? -1 : 1
    value *= 10 if Input.press?(:A)
    ext = current_ext
    var = YEA::SYSTEM::CUSTOM_VARIABLES[ext][0]
    minimum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][4]
    maximum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][5]
    $game_variables[var] += value
    $game_variables[var] = [[$game_variables[var], minimum].max, maximum].min
    draw_item(index)
  end
  
end # Window_SystemOptions

#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # overwrite method: command_game_end
  #--------------------------------------------------------------------------
  def command_game_end
    SceneManager.call(Scene_System)
  end
  
end # Scene_Menu

#==============================================================================
# ■ Scene_System
#==============================================================================

class Scene_System < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
  end
  
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_SystemOptions.new(@help_window)
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:to_title, method(:command_to_title))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
  end
  
  #--------------------------------------------------------------------------
  # command_to_title
  #--------------------------------------------------------------------------
  def command_to_title
    fadeout_all
    SceneManager.goto(Scene_Title)
  end
  
  #--------------------------------------------------------------------------
  # command_shutdown
  #--------------------------------------------------------------------------
  def command_shutdown
    fadeout_all
    SceneManager.exit
  end
  
end # Scene_System

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================