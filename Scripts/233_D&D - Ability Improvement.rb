#==============================================================================#
#                              V's Level Up Stats                              #
#                                 Version  1.5                                 #
#                                Written By:  V                                #
#                Gutted, Modified, and Repurposed by: Kyutaru                  #
#                      Last Edited:  January 29, 2014                          #
#==============================================================================#
#------------------------------------------------------------------------------#
# ** Disclaimer                                                                #
#------------------------------------------------------------------------------#
#                                                                              #
# This script was commissioned by JJR for his doings, I release all copyrights #
# to him regarding this script. My only terms are that I am listed as writer   #
# of this script if a game is ever produced using this script.(Demo's Included)#
# I also ask that I am notified upon release of said game/demo.                #
#                                                                              #
# Greetings users, Kyutaru here, I've modified this script to remove most of   #
# the overwrite methods and global variables which I thought were a waste and  #
# I adapted it to this version of D&D's stat system.  Feats will also be used  #
# and purchased using the same points as attributes in accordance with the new #
# rules.  Attributes cost 1 pt each while Feats cost 2 pts each.  Feats will   #
# come in a future version as they require a lot of hardcoding rule changes.   #
#------------------------------------------------------------------------------#
# ** How To Use                                                                #
#------------------------------------------------------------------------------#
# * All images must be imported to the Graphics/Pictures resource folder       #
# * If you wish to use your own images the names must be filled in below,      #
#   the dimensions can vary within reason.                                     #
# * The dimensions for the graphics I used and their var names are as follows: #
#     Level_Up_Background = 544 x 544                                          #
#     Level_Up_Title = 454 x 76                                                #
#     All Buttons = 16 x 16                                                    #
#==============================================================================#
module V_Level_Up_Stats
  #============================================================================
  #  Images
  #============================================================================
    # Background
    Level_Up_Background = "StarlitSky"
    # Title
    Level_Up_Title = "Level Up Title"
    Level_Up_Title_x = 30
    Level_Up_Title_y = 60
    # Hints
    Level_Up_Hint = "Level Up Hint"
    Level_Up_Hint_x = 35
    Level_Up_Hint_y = 140
    # Buttons
    Minus_Button = "Minus"
    Plus_Button = "Plus"
    # Selector
    Icon = 1140
    Icon_x = 9
    Icon_y = -8
       
  #============================================================================
  #  Additional Options
  #============================================================================
    # Menu Command Options
    Use_Menu_Command = false
    Level_Up_Command_Title = "Level Up"
    # Point Setup
    Initial_Points = 0
    Points_Per_Level = 0.75
    Stat_Cap = 20
    Level_Up_Hint_Vocab = "Max Base Stat = 20"
    Level_Up_Points_Vocab = "Ability Points"
    Accept_Button = "Accept"
end
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#
#                                                                              #
#                            End Customizable Area.                            #
#                                                                              #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                              #
#         DO NOT EDIT PAST THIS POINT UNLESS YOU KNOW WHAT YOUR DOING.         #
#                                                                              #
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#
class Window_Level_Up_Stats < Window_Base
  #--------------------------------------------------------------------------
  # * Includes Module's Variables With Class
  #--------------------------------------------------------------------------
  include V_Level_Up_Stats
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h, actor)
    super(x, y, w, h)
    @minus_button = []
    @plus_button = []
    refresh(actor, 1, 6)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(actor, cur_x, cur_y)
    contents.clear
    draw_current_actor_graphic(actor)
    draw_current_actor_name(actor)
    draw_current_actor_class(actor)
    draw_available_text(actor)
    draw_lvupp_vocab(actor)
    draw_available_lv_up_points(actor)
    draw_lv_up_stats(actor)
    draw_lv_up_stat_buttons
    draw_lv_up_accept_buttons
    create_lvup_icon(cur_x, cur_y)
  end
  #--------------------------------------------------------------------------
  # * Draw Current Actor Graphic
  #--------------------------------------------------------------------------
  def draw_current_actor_graphic(actor)
    x = 90
    y = 220
    draw_actor_graphic(actor, x, y)
  end
  #--------------------------------------------------------------------------
  # * Draw Current Actor Name
  #--------------------------------------------------------------------------
  def draw_current_actor_name(actor)
    x = -180
    y = 30
    w = 544
    h = 416
    draw_text(x, y, w, h, actor.name, 1)
  end
  #--------------------------------------------------------------------------
  # * Draw Current Actor Name
  #--------------------------------------------------------------------------
  def draw_current_actor_class(actor)
    x = -180
    y = 30
    w = 544
    h = 416
    make_font_smaller
    draw_text(x, y + 15, w, h, actor.class.name, 1)
    make_font_bigger
  end
  #--------------------------------------------------------------------------
  # * Draw Available Text
  #--------------------------------------------------------------------------
  def draw_available_text(actor)
    x = -180
    y = 75
    w = 544
    h = 416
    #make_font_smaller
    draw_text(x, y, w, h, Level_Up_Hint_Vocab, 1)
    make_font_bigger
  end
  #--------------------------------------------------------------------------
  # * Draw Points Vocab
  #--------------------------------------------------------------------------
  def draw_lvupp_vocab(actor)
    x = -180
    y = 95
    w = 544
    h = 416
    make_font_smaller
    draw_text(x, y, w, h, Level_Up_Points_Vocab, 1)
    make_font_bigger
  end
  #--------------------------------------------------------------------------
  # * Draw Available Level Up Points
  #--------------------------------------------------------------------------
  def draw_available_lv_up_points(actor)
    x = -180
    y = 115
    w = 544
    h = 416
    temp_atk = actor.temp_param[0]
    temp_def = actor.temp_param[1]
    temp_mat = actor.temp_param[2]
    temp_mdf = actor.temp_param[3]
    temp_agi = actor.temp_param[4]
    temp_luk = actor.temp_param[5]
    temp_used_points = temp_atk+temp_def+temp_mat+temp_mdf+temp_agi+temp_luk
    points = actor.lvupp - temp_used_points
    draw_text(x, y, w, h, points.to_i , 1)
  end
  #--------------------------------------------------------------------------
  # * Creates the Accept Button
  #--------------------------------------------------------------------------
  def draw_lv_up_accept_buttons
    x = 330
    y = 350
    draw_text_ex(x, y, Accept_Button)
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + 120, y, 36, line_height, (actor.param(2) + actor.temp_param[0]), 2) if param_id == 2
    draw_text(x + 120, y, 36, line_height, (actor.param(3) + actor.temp_param[1]), 2) if param_id == 3
    draw_text(x + 120, y, 36, line_height, (actor.param(4) + actor.temp_param[2]), 2) if param_id == 4
    draw_text(x + 120, y, 36, line_height, (actor.param(5) + actor.temp_param[3]), 2) if param_id == 5
    draw_text(x + 120, y, 36, line_height, (actor.param(6) + actor.temp_param[4]), 2) if param_id == 6
    draw_text(x + 120, y, 36, line_height, (actor.param(7) + actor.temp_param[5]), 2) if param_id == 7
  end
  #--------------------------------------------------------------------------
  # * Draw Level Up Stats
  #--------------------------------------------------------------------------
  def draw_lv_up_stats(actor)
    line_height = 25
    x = 220
    y = 145
    make_font_smaller
    6.times {|i| draw_actor_param(actor, x, y + line_height * (i+2), i+2) }
    make_font_bigger
  end
  #--------------------------------------------------------------------------
  # * Draw Level Up Stat Buttons
  #--------------------------------------------------------------------------
  def draw_lv_up_stat_buttons
    i = 1
    x = 300
    y = 131
    pad = 5
    6.times {
    draw_minus_button(i, x, y + pad)
    draw_plus_button(i, x, y + pad)
    i += 1
    }
  end
  #--------------------------------------------------------------------------
  # * Draws the Minus Button
  #--------------------------------------------------------------------------
  def draw_minus_button(i, x, y)
    line_height = 25
    @minus_button[i] = Sprite.new
    @minus_button[i].bitmap = Cache.picture(Minus_Button)
    @minus_button[i].x = x + 100
    @minus_button[i].y = y + line_height * (i+2)
    @minus_button[i].z = 20
  end
  #--------------------------------------------------------------------------
  # * Draws the Plus Button
  #--------------------------------------------------------------------------
  def draw_plus_button(i, x, y)
    line_height = 25
    @plus_button[i] = Sprite.new
    @plus_button[i].bitmap = Cache.picture(Plus_Button)
    @plus_button[i].x = x + 125
    @plus_button[i].y = y + line_height * (i+2)
    @plus_button[i].z = 20
  end
  #--------------------------------------------------------------------------
  # * Creates the Selection Icon
  #--------------------------------------------------------------------------
  def create_lvup_icon(cur_x, cur_y)
    ix = Icon_x
    iy = Icon_y
    if cur_y == 6
      x = 300
      y = 350
    else
      x = 375 + ix if cur_x == 0 && cur_y != 6
      x = 400 + ix if cur_x == 1 && cur_y != 6
      y = 203 + iy if cur_y == 0
      y = 228 + iy if cur_y == 1
      y = 253 + iy if cur_y == 2
      y = 278 + iy if cur_y == 3
      y = 303 + iy if cur_y == 4
      y = 328 + iy if cur_y == 5
    end
    draw_icon(Icon, x, y)
  end
  #--------------------------------------------------------------------------
  # * Add the Temp Stats to Actors Added Stats
  #--------------------------------------------------------------------------
  def add_stats(actor)
    temp_atk = actor.temp_param[0]
    temp_def = actor.temp_param[1]
    temp_mat = actor.temp_param[2]
    temp_mdf = actor.temp_param[3]
    temp_agi = actor.temp_param[4]
    temp_luk = actor.temp_param[5]
    temp_used_points = temp_atk+temp_def+temp_mat+temp_mdf+temp_agi+temp_luk
    points = actor.lvupp - temp_used_points
    6.times {|i| actor.added_param[i+2] += actor.temp_param[i]} unless actor == nil
    6.times {|i| $game_party.members[0].added_param[i+2] += actor.temp_param[i]} if actor == nil
    reset_temp_stats(actor)
  end
  #--------------------------------------------------------------------------
  # * Resets the Temp Stats to 0
  #--------------------------------------------------------------------------
  def reset_temp_stats(actor)
    temp_atk = actor.temp_param[0]
    temp_def = actor.temp_param[1]
    temp_mat = actor.temp_param[2]
    temp_mdf = actor.temp_param[3]
    temp_agi = actor.temp_param[4]
    temp_luk = actor.temp_param[5]
    temp_used_points = temp_atk+temp_def+temp_mat+temp_mdf+temp_agi+temp_luk
    6.times {|i| actor.temp_param[i] = 0 }
  end
  #--------------------------------------------------------------------------
  # * Dispose Level Up Stat Buttons
  #--------------------------------------------------------------------------
  def dispose_lv_up_stat_buttons
    i = 1
    6.times {
    @minus_button[i].dispose
    @minus_button[i].bitmap.dispose
    @plus_button[i].dispose
    @plus_button[i].bitmap.dispose
    i += 1
    }
  end
end # Window_Level_Up_Stats
class Scene_Level_Up_Stats < Scene_Base
  #--------------------------------------------------------------------------
  # * Includes Module's Variables With Class
  #--------------------------------------------------------------------------
  include V_Level_Up_Stats
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    actors = $game_party.members
    @feat_actor = actors[0]
    @cursor_x = 1
    @cursor_y = 6
    actors.each_index do |i|
      if actors[i].lvupp > 0
        @feat_actor = actors[i]
        break
      end
    end
    create_lvup_bg
    create_lvup_title
    create_lvup_hint
    create_stat_window
  end
  #--------------------------------------------------------------------------
  # * Creates the Level Up Stats Background
  #--------------------------------------------------------------------------
  def create_lvup_bg
    @lvup_bg = Sprite.new
    @lvup_bg.bitmap = Cache.picture(Level_Up_Background)
    @lvup_bg.x = 0
    @lvup_bg.y = 0
    @lvup_bg.z = 1
    @lvup_bg.zoom_x = 1.2
    @lvup_bg.zoom_y = (Graphics.height / 418)
  end
  #--------------------------------------------------------------------------
  # * Creates the Stat Window
  #--------------------------------------------------------------------------
  def create_stat_window
    @lvup_window = Window_Level_Up_Stats.new(0, 0, Graphics.width, Graphics.height, @feat_actor)
    @lvup_window.back_opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Creates the Level Up Title Picture
  #--------------------------------------------------------------------------
  def create_lvup_title
    @lvup_title = Sprite.new
    @lvup_title.bitmap = Cache.picture(Level_Up_Title)
    @lvup_title.x = Level_Up_Title_x
    @lvup_title.y = Level_Up_Title_y
    @lvup_title.z = 4
  end
  #--------------------------------------------------------------------------
  # * Creates the Level Up Title Picture
  #--------------------------------------------------------------------------
  def create_lvup_hint
    @lvup_hint = Sprite.new
    @lvup_hint.bitmap = Cache.picture(Level_Up_Hint)
    @lvup_hint.x = Level_Up_Hint_x
    @lvup_hint.y = Level_Up_Hint_y
    @lvup_hint.z = 4
  end
  #--------------------------------------------------------------------------
  # * Disposes the Level Up Background
  #--------------------------------------------------------------------------
  def dispose_lvup_graphics
    @lvup_bg.dispose
    @lvup_bg.bitmap.dispose
    @lvup_title.dispose
    @lvup_title.bitmap.dispose
    @lvup_hint.dispose
    @lvup_hint.bitmap.dispose    
  end
  #--------------------------------------------------------------------------
  # * Process the Inputs for the Stat selection
  #--------------------------------------------------------------------------
  def process_stat_input
    actors = $game_party
    if Input.trigger?(:LEFT) && @cursor_x == 0
      @cursor_x = 1
      Sound.play_cursor
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
    elsif Input.trigger?(:LEFT) && @cursor_x == 1
      @cursor_x = 0
      Sound.play_cursor
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
    elsif Input.trigger?(:RIGHT) && @cursor_x == 0
      @cursor_x = 1
      Sound.play_cursor
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
    elsif Input.trigger?(:RIGHT) && @cursor_x == 1
      @cursor_x = 0
      Sound.play_cursor
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
    elsif Input.trigger?(:UP) && @cursor_y > 0
      @cursor_y -= 1
      Sound.play_cursor
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
    elsif Input.trigger?(:UP) && @cursor_y == 0
      @cursor_y = 6
      Sound.play_cursor
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
    elsif Input.trigger?(:DOWN) && @cursor_y < 6
      @cursor_y += 1
      Sound.play_cursor
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
    elsif Input.trigger?(:DOWN) && @cursor_y == 6
      @cursor_y = 0
      Sound.play_cursor
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
    elsif Input.trigger?(:A)
      @lvup_window.reset_temp_stats(@feat_actor)
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
      Sound.play_cursor
    elsif Input.trigger?(:L)
      $game_party.menu_actor_prev
      @feat_actor = $game_party.menu_actor
      @lvup_window.reset_temp_stats(@feat_actor)
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
      Sound.play_cursor unless $game_party.members.size == 1
      Sound.play_buzzer if $game_party.members.size == 1
    elsif Input.trigger?(:R)
      $game_party.menu_actor_next
      @feat_actor = $game_party.menu_actor
      @lvup_window.reset_temp_stats(@feat_actor)
      @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
      Sound.play_cursor unless $game_party.members.size == 1
      Sound.play_buzzer if $game_party.members.size == 1
    elsif Input.trigger?(:B)
      Sound.play_cancel
      @lvup_window.dispose
      dispose_lvup_graphics
      @lvup_window.dispose_lv_up_stat_buttons
      @lvup_window.reset_temp_stats(@feat_actor)
      return_scene
    elsif Input.trigger?(:C)
      process_ok unless @cursor_y == 6
      process_accept if @cursor_y == 6
    end
  end
  #--------------------------------------------------------------------------
  # * OK Accept
  #--------------------------------------------------------------------------
  def process_accept
    temp_atk = @feat_actor.temp_param[0]
    temp_def = @feat_actor.temp_param[1]
    temp_mat = @feat_actor.temp_param[2]
    temp_mdf = @feat_actor.temp_param[3]
    temp_agi = @feat_actor.temp_param[4]
    temp_luk = @feat_actor.temp_param[5]
    temp_used_points = temp_atk+temp_def+temp_mat+temp_mdf+temp_agi+temp_luk
    points = @feat_actor.lvupp - temp_used_points
    return_scene
    @lvup_window.add_stats(@feat_actor)
    @feat_actor.lvupp -= temp_used_points
    @lvup_window.reset_temp_stats(@feat_actor)
    @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
  end
  #--------------------------------------------------------------------------
  # * OK Processing
  #--------------------------------------------------------------------------
  def process_ok
    temp_atk = @feat_actor.temp_param[0]
    temp_def = @feat_actor.temp_param[1]
    temp_mat = @feat_actor.temp_param[2]
    temp_mdf = @feat_actor.temp_param[3]
    temp_agi = @feat_actor.temp_param[4]
    temp_luk = @feat_actor.temp_param[5]
    temp_used_points = temp_atk+temp_def+temp_mat+temp_mdf+temp_agi+temp_luk
    points = @feat_actor.lvupp - temp_used_points
    modifier = @feat_actor.temp_param
    case
    when @cursor_x == 0
      if modifier[@cursor_y] == 0
        Sound.play_buzzer
      else
        modifier[@cursor_y] -= 1
        Sound.play_ok
      end
    when @cursor_x == 1
if points<1||(@feat_actor.param_base(@cursor_y+2)+modifier[@cursor_y])==Stat_Cap
        Sound.play_buzzer
      else
        modifier[@cursor_y] += 1
        Sound.play_ok
      end
    end
    @lvup_window.refresh(@feat_actor, @cursor_x, @cursor_y)
  end
  #--------------------------------------------------------------------------
  # * Update Processing
  #--------------------------------------------------------------------------
  def update
    super
    process_stat_input
  end
end # Scene_Level_Up_Stats
class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Includes Module's Variables With Class
  #--------------------------------------------------------------------------
  include V_Level_Up_Stats
  #--------------------------------------------------------------------------
  # * For Creating An Alias
  #--------------------------------------------------------------------------
  alias :aoc13215 :add_original_commands
  #--------------------------------------------------------------------------
  # * For Adding Original Commands
  #--------------------------------------------------------------------------
  def add_original_commands
    aoc13215()
    if Use_Menu_Command
      $game_party.members.each_index do |i|
        if $game_party.members[i].lvupp > 0 || $game_party.members[i].lvupp != nil
          add_command(Level_Up_Command_Title, :level_up_stats)
        end
        break
      end
    end
  end
end # Window_MenuCommand
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Includes Module's Variables With Class
  #--------------------------------------------------------------------------
  include V_Level_Up_Stats
  #--------------------------------------------------------------------------
  # * For Creating An Alias
  #--------------------------------------------------------------------------
  alias :ccw13215 :create_command_window
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    ccw13215()
    if Use_Menu_Command
      @command_window.set_handler(:level_up_stats,    method(:command_level_up_stats))
    end
  end
  #--------------------------------------------------------------------------
  # * [Save] Command
  #--------------------------------------------------------------------------
  def command_level_up_stats
    SceneManager.call(Scene_Level_Up_Stats)
  end
end # Scene_Menu
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Includes Module's Variables With Class
  #--------------------------------------------------------------------------
  include V_Level_Up_Stats
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :lvupp
  attr_accessor :added_param
  attr_accessor :temp_param
  #--------------------------------------------------------------------------
  # * For Creating An Alias
  #--------------------------------------------------------------------------
  alias :old_init787687322 :initialize
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    @lvupp = Initial_Points
    @added_param = [0, 0, 0, 0, 0, 0, 0, 0]
    @temp_param = [0, 0, 0, 0, 0, 0]
    old_init787687322(actor_id)
  end
  #--------------------------------------------------------------------------
  # * For Creating An Alias
  #--------------------------------------------------------------------------
  alias :old_param_base5547 :param_base
  #--------------------------------------------------------------------------
  # * Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_base(param_id)
    old_param_base5547(param_id) + @added_param[param_id]
  end  
  #--------------------------------------------------------------------------
  # * For Creating An Alias
  #--------------------------------------------------------------------------
  alias :old_level_up546345 :level_up
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  def level_up
    old_level_up546345()
    @lvupp += Points_Per_Level
  end
end # Game_Actor
