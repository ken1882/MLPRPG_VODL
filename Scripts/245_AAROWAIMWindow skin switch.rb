=begin
--------------------------------------------------------------------------------
TITLE: Scene Themes + Direct Message Window Skin Specification (Message Skins)
ORIGINAL BY: Aarowaim
MODDED BY: Aarowaim - Version 1.1
DESCRIPTION:
  A script that makes altering skins easy. Defines default windowskin and allows
  scenes to use their own windowskins. Also includes an escape sequence code to 
  change window skins for message boxes. I fondly call it a 'note-tag', despite 
  being the incorrect terminology. Scroll WAY down to see the code that made my 
  epic note-tag possible.
  
V 1.1:
  -fixed isues with windows that accompany the message window not changing 
   skins
   -and changing skin back to default when option is selected
  
TERMS OF USE:
  ...There are none. Well, actually, as long as you don't take credit for this, 
     you don't need to give credit to me. If you make an edit to this and want
     to take credit, just include the 'ORIGINAL BY: Aarowaim' and fill in the
     'MODDED BY:' line with 'your name - version'. 
     
     Oh yeah! Enjoy it. It took at least 10 hours of continuous coding to get it 
     working... I'm glad it was a day off from school ^_^.
--------------------------------------------------------------------------------
INSTRUCTIONS:
  Place all windowskins you are using within the system folder.
  
  Change the variable value to match the windowskin you would like to use.
  Remember to enclose in quotation marks. E.g, "Skill_Skin"
  
  Place the names of each windowskin you are using inside the Windows table. 
  
  
  Change USE_SCENE_SKIN to FALSE to disable scene themes in favour of defining
  windowskins from their respective Window classes. NOTE: You can still use
  $DEFAULT_WINDOWSKIN.
  
TROUBLESHOOTING:
  - Make sure that this script is above the others in the editor; it redefines
    many different scenes. If you do this, other scripts can overwrite this one 
    if it does anything they don't like. If they prevent scene themes from 
    working, refer to protip 1.
      
  - Surround the name of your file, without the '.png' ending, in quotation 
    marks when putting a value into a variable.
    
  - MAKE SURE TO PLACE THIS SCRIPT ABOVE YOUR BATTLE SYSTEMS!
    This ensures that battle scripts will overwrite methods used in this script 
    if they need to, ensuring that your battle script will work perfectly fine.
      
  - If the previous troubleshooting tip didn't work, try changing 
    $USE_BATTLE_SKIN to false.
      
PROTIPS:
  These tips are only for those who are modifying my script.
  - Place window.scene_swap(skin) after every new window is created to make 
    custom scenes compatible. Make sure that you are running .scene_swap on a 
    window, otherwise, you will get a NoMethod error. see protip 3 to locate 
    examples of how I used scene_swap.
    
  - By preventing changes when USE_SCENE_SKIN is FALSE, it is easy to prevent
    scene_swap from applying changes to the windows each scene calls. By doing 
    this, each windowskin is determined by the window, not the scene. When
    USE_SCENE_SKIN is TRUE, the windowskins defined by the window itself are
    ignored in favour of making all the windows match.
    
  - A '#' at the end of a line indicates a change to the method I copied. Use 
    these to dissect how I applied the code.
    
  - If you have adjusted your custom scenes to use this script's method, you
    are pro enough to ignore the first troubleshooting message
    *gives cool shades to you* ^_^
    
  - This script also come with a special note-tag that took 6 hours of work to
    debug T.T; nonetheless, here is the code.
    When eventing, place '\ws[skin]' at the beginning of a message. 
    Replace 'skin' with the name of the skin you want to use. This allows you
    to make a specific message use a different skin, and the skin will revert
    to default afterwards. Have fun... it took a lot of effort to get it to work
    at all (I learnt a lot about Regexp >.<; ).
--------------------------------------------------------------------------------
  
VARIABLES (that are intended for customization):
  All variables intended for customization are in uppercase. All variables that 
  shouldn't be changed without scripting knowledge are in lowercase. 
  Place your windowskins in $WINDOWSKINS with a comma after each one 
  (except the last). 
  
  Place $WINDOWSKINS[x] in each variable, with x being the number of the window
  skin. Note that it counts up from 0, so the first skin will be $WINDOWSKINS[0],
  the second one $WINDOWSKINS[1] and so on.
  
  $DEFAULT_WINDOWSKIN
    All windows will use this skin unless specified by a scene variable.
                       >>>----> Scene Variables <----<<<
  These variables change the windowskin used for a scene. This allows a themed 
  scene. You can specify a windowskin to use ONLY on menus, or any other scene 
  using these. You can also use the value $DEFAULT_WINDOWSKIN to keep the same 
  them as is normally used.
  
  $USE_SCENE_SKIN
    TRUE means that you would like to specify themes for each scene. If you use
    FALSE, themed scenes will not have their own skin, regardless of the changes 
    you make to the following variables.
    
  $USE_BATTLE_SKIN
    Indicates whether to change the theme of a battle scene. changing this to
    FALSE will prevent a majority of script incompatibilities you may encounter.
    This is mostly because the most common type of script that affects scenes is
    a battle script.
  
  $TITLE_SKIN
    The skin you would like to use for the title and game-over options. Also 
    affects name input menu. There is very little information in these scenes, 
    so they can afford to be stylish. They are the first few scenes a new player
    might see, and when they aren't, they are always the last things. 
    Use this to give an atmosphere to your game.
  
  $DEFAULT_MESSAGE_SKIN
    Use to define the default skin used whenever a message pops up. 
    You can specify a different windowskin for specific messages by using the 
    'note-tag' defined within the last protip.
    e.g, someone speaking.
    
  $DEFAULT_MENU_SKIN
    Defines what skin to use when a scene fails to specify what windowskin to 
    use. By setting it to $DEFAULT_WINDOWSKIN, we ensure that it will match what
    other people's custom scenes use (unless they specified a windowskin)
  
  $PAUSE_MENU_SKIN
    The skin used for the menu created when you press cancel (Esc) on the world 
    map. 
  
  $ITEM_MENU_SKIN
    The skin used when browsing the party's items (from pause menu).
    
  $SKILL_MENU_SKIN
    The skin used when browsing party's skills (from pause menu).
    
  $EQUIP_MENU_SKIN
    The skin used in the equipment menu (from the pause menu).
  
  $STATUS_MENU_SKIN
    Skin used when checking a party member's details (from pause menu).
    
  $DATA_MENU_SKIN
    Used for the load/save file menus.
    
  $SHOP_MENU_SKIN
    Used for shops.
    
  $DEBUG_SKIN
    Used for debug screen. Because this is a utility, and the player will never 
    have access, go ahead and use your favourite windowskin. Choose a windowskin
    that is legible if you want to see text displayed here.
    
  $BATTLE_SKIN
    The skin to use for your battle system.
    
METHODS DEFINED (for coders/pros):
  Window_Base.scene_swap(skin)
    - Checks if scene skins (themes) are allowed and if so, applies the 
      windowskin specified with skin. Most windowskins used for themes are 
      defined by the global variables contained in the Skin_Swap class.
      This method does the majority of windowskin changing as of version 1.0.
      (I used to use: 
                     if $USE_SCENE_SKIN == TRUE
                       Window.windowskin = Cache.system($variable)
                     end
       for EVERY window in EVERY scene. You can imagine why I made a method.)
      
  Window_Base.scene_swap(skin, opacity)
    - Exactly the same as above, but also allows opacity to be defined.
    
  Window_Base.skin_swap(skin)
    - The same as scene_swap, but not affected by the $USE_SCENE_SKIN variable.
      Good for things you don't want disabled, such as my note-tag.
      
=end 
class Skin_Swap
  # Main settings
  $WINDOWSKINS = [
  "Window", #use $WINDOWSKINS[0] in variable
  "Window", # use $WINDOWSKINS[1]
  "Window", # use [2]
  "Window _MenuCommand", # use [3]
  "Window_spellbook",        # 4
  "Window_infos",            # 5 
  "Window_itemmoreinfo",     # 6
  "Rainbow dash5",           # 7
  ]
  $DEFAULT_WINDOWSKIN = "Window"
  $USE_SCENE_SKIN = TRUE
  $USE_BATTLE_SKIN = TRUE
  
  # Variables that may be interfered with by other scripts that define 
  # windowskins.
  $TITLE_SKIN = $WINDOWSKINS[1]
  $DEFAULT_MESSAGE_SKIN = $WINDOWSKINS[0]
  $DEFAULT_MENU_SKIN    = $WINDOWSKINS[0]
  $PAUSE_MENU_SKIN      = $WINDOWSKINS[3]
  $ITEM_MENU_SKIN       = $WINDOWSKINS[0]
  $SKILL_MENU_SKIN      = $WINDOWSKINS[0]
  $EQUIP_MENU_SKIN      = $WINDOWSKINS[0]
  $STATUS_MENU_SKIN     = $WINDOWSKINS[0]
  $DATA_MENU_SKIN       = $WINDOWSKINS[0]
  $SHOP_MENU_SKIN       = $WINDOWSKINS[0]
  $DEBUG_SKIN           = $WINDOWSKINS[0]
  $BATTLE_SKIN          = $WINDOWSKINS[0]
  $SPELLBOOK_SKIN       = $WINDOWSKINS[4]
  $MAP_INFO_SKIN        = $WINDOWSKINS[5]
  $ITEM_INFO_SKIN       = $WINDOWSKINS[6]
end
#DON'T FOOL AROUND BELOW UNLESS YOU KNOW WHAT YOU'RE DOING! I DIDN'T 
#DEACTIVATE ERROR MINES. ONE WRONG STEP AND KABOOM!, ALL YOUR HARD WORK IS 
#DESTROYED... temporarily.
#If you know what your doing, then I am just telling you that this code is not 
#fool-proof and doesn't prevent errors when other scripts overwrite existing 
#scenes. See pro-tip 1 if you would like to make your custom scenes work.
class Window_Base < Window
  
  def scene_swap(skin = $DEFAULT_WINDOWSKIN)                                   #
    if $USE_SCENE_SKIN == TRUE                                                 #
      self.windowskin = Cache.system(skin)                                     #
    end                                                                        #
  end                                                                          #
    
  def scene_swap(skin, opacity = 255)                                          #
    if $USE_SCENE_SKIN == TRUE                                                 #
      self.windowskin = Cache.system(skin)                                     #
      self.opacity = opacity                                                   #
    end                                                                        #
  end                                                                          #
  
  def skin_swap(skin)                                                          #
    self.windowskin = Cache.system(skin)                                       #
  end                                                                          #
  
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system($DEFAULT_WINDOWSKIN)                        #
    update_padding
    update_tone
    create_contents
    @opening = @closing = false
  end
end
class Window_Selectable < Window_Base
  
  def scene_swap(skin = $DEFAULT_WINDOWSKIN)                                   #
    if $USE_SCENE_SKIN == TRUE                                                 #
      self.windowskin = Cache.system(skin)                                     #
    end                                                                        #
  end                                                                          #
    
  def scene_swap(skin, opacity = 255)                                          #
    if $USE_SCENE_SKIN == TRUE                                                 #
      self.windowskin = Cache.system(skin)                                     #
      self.opacity = opacity                                                   #
    end                                                                        #
  end                                                                          #
  
  def skin_swap(skin)                                                          #
    self.windowskin = Cache.system(skin)                                       #
  end                                                                          #
  
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #-------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system($DEFAULT_WINDOWSKIN)                        #
    @index = -1
    @handler = {}
    @cursor_fix = false
    @cursor_all = false
    update_padding
    deactivate
  end
  
end
class Scene_Title < Scene_Base
  def start
    super
    SceneManager.clear
    Graphics.freeze
    create_background
    create_foreground
    create_command_window
    @command_window.scene_swap($TITLE_SKIN)                                    #
    play_title_music
  end
end
class Scene_Map < Scene_Base
  def start
    super
    SceneManager.clear
    $game_player.straighten
    $game_map.refresh
    $game_message.visible = false
    create_spriteset
    create_all_windows
    @message_window.scene_swap($DEFAULT_MESSAGE_SKIN)                          #
    @menu_calling = false
  end
end
class Scene_MenuBase < Scene_Base
  def create_help_window
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
    @help_window.scene_swap($DEFAULT_MENU_SKIN)                                #
  end
end
class Scene_Menu < Scene_MenuBase
  def start
    super
    create_command_window
    create_gold_window
    create_status_window
    if $USE_SCENE_SKIN == TRUE                                                 #
      @command_window.scene_swap($PAUSE_MENU_SKIN)                             #
      @gold_window.scene_swap($PAUSE_MENU_SKIN)                                #
      @status_window.scene_swap($PAUSE_MENU_SKIN)                              #
    end                                                                        #
  end
end
class Scene_ItemBase < Scene_MenuBase
  def start
    super
    create_actor_window
    @actor_window.scene_swap($DEFAULT_MENU_SKIN)                               #
  end
end
class Scene_Item < Scene_ItemBase
  def start
    super
    create_help_window
    create_category_window
    create_item_window
    @help_window.scene_swap($ITEM_MENU_SKIN)                                   #
    @category_window.scene_swap($ITEM_MENU_SKIN)                               #
    @item_window.scene_swap($ITEM_MENU_SKIN)                                   #
  end
end
class Scene_Skill < Scene_ItemBase
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_item_window
    @help_window.scene_swap($SKILL_MENU_SKIN)                                  #
    @command_window.scene_swap($SKILL_MENU_SKIN)                               #
    @status_window.scene_swap($SKILL_MENU_SKIN)                                #
    @item_window.scene_swap($SKILL_MENU_SKIN)                                  #
  end
end
class Scene_Equip < Scene_MenuBase
  def start
    super
    create_help_window
    create_status_window
    create_command_window
    create_slot_window
    create_item_window
    @help_window.scene_swap($EQUIP_MENU_SKIN)                                  #
    @status_window.scene_swap($EQUIP_MENU_SKIN)                                #
    @command_window.scene_swap($EQUIP_MENU_SKIN)                               #
    @slot_window.scene_swap($EQUIP_MENU_SKIN)                                  #
    @item_window.scene_swap($EQUIP_MENU_SKIN)                                  #
  end
end
class Scene_Status < Scene_MenuBase
  def start
    super
    @status_window = Window_Status.new(@actor)
    @status_window.set_handler(:cancel,   method(:return_scene))
    @status_window.set_handler(:pagedown, method(:next_actor))
    @status_window.set_handler(:pageup,   method(:prev_actor))
    @status_window.scene_swap($STATUS_MENU_SKIN)                               #
  end
end
class Scene_File < Scene_MenuBase
  def start
    super
    create_help_window
    create_savefile_viewport
    create_savefile_windows
    @help_window.scene_swap($DATA_MENU_SKIN)                                   #
    @savefile_windows.each { |win| win.scene_swap($DATA_MENU_SKIN) }           #
    init_selection
  end
end
class Scene_End < Scene_MenuBase
  def start
    super
    create_command_window
    @command_window.scene_swap($TITLE_SKIN)                                    #
  end
end
class Scene_Shop < Scene_MenuBase
  def start
    super
    create_help_window
    create_gold_window
    create_command_window
    create_dummy_window
    create_number_window
    create_status_window
    create_buy_window
    create_category_window
    create_sell_window
    @help_window.scene_swap($SHOP_MENU_SKIN)                                   #
    @gold_window.scene_swap($SHOP_MENU_SKIN)                                   #
    @command_window.scene_swap($SHOP_MENU_SKIN)                                #
    @dummy_window.scene_swap($SHOP_MENU_SKIN)                                  #
    @number_window.scene_swap($SHOP_MENU_SKIN)                                 #
    @status_window.scene_swap($SHOP_MENU_SKIN)                                 #
    @buy_window.scene_swap($SHOP_MENU_SKIN)                                    #
    @category_window.scene_swap($SHOP_MENU_SKIN)                               #
    @sell_window.scene_swap($SHOP_MENU_SKIN)                                   #
  end
end
class Scene_Name < Scene_MenuBase
  def start
    super
    @actor = $game_actors[@actor_id]
    @edit_window = Window_NameEdit.new(@actor, @max_char)
    @input_window = Window_NameInput.new(@edit_window)
    @input_window.set_handler(:ok, method(:on_input_ok))
    @edit_window.scene_swap($TITLE_SKIN)                                       #
    @input_window.scene_swap($TITLE_SKIN)                                      #
  end
end
class Scene_Debug < Scene_MenuBase
  def start
    super
    create_left_window
    create_right_window
    create_debug_help_window
    @left_window.scene_swap($DEBUG_SKIN)                                       #
    @right_window.scene_swap($DEBUG_SKIN)                                      #
    @debug_help_window.scene_swap($DEBUG_SKIN)                                 #
  end
end
class Scene_Battle < Scene_Base
  def start
    super
    create_spriteset
    create_all_windows
    swap_all_skins                                                             #
    BattleManager.method_wait_for_message = method(:wait_for_message)
  end
  
  def swap_all_skins                                                           #
    if $USE_BATTLE_SKIN == TRUE                                                #
      @message_window.scene_swap($BATTLE_SKIN)                                 #
      @scroll_text_window.scene_swap($BATTLE_SKIN)                             #
      @status_window.scene_swap($BATTLE_SKIN)                                  #
      @party_command_window.scene_swap($BATTLE_SKIN)                           #
      @actor_command_window.scene_swap($BATTLE_SKIN)                           #
      @help_window.scene_swap($BATTLE_SKIN)                                    #
      @skill_window.scene_swap($BATTLE_SKIN)                                   #
      @item_window.scene_swap($BATTLE_SKIN)                                    #
      @actor_window.scene_swap($BATTLE_SKIN)                                   #
      @enemy_window.scene_swap($BATTLE_SKIN)                                   #
    end
  end
end
#NOTE-TAG PROCESSING (the fun part -_-;)
class Window_Message < Window_Base
  
  def obtain_escape_param_string(text)                                         #
    text.slice!(/^\[(\w+)\]/)[/\w+/].to_s rescue 0                             #
  end                                                                          #
  
  def process_escape_character(code, text, pos)
    case code.upcase
    when '$'
      @gold_window.open
    when '.'
      wait(15)
    when '|'
      wait(60)
    when '!'
      input_pause
    when '>'
      @line_show_fast = true
    when '<'
      @line_show_fast = false
    when '^'
      @pause_skip = true
    when 'WS'                                                                  #
      refresh_all_skins(obtain_escape_param_string(text))                         #
    else
      super
    end
  end
  
  def refresh_all_skins(skin)                                                  #
    @gold_window.skin_swap(skin)                                               #
    @choice_window.skin_swap(skin)                                             #
    @number_window.skin_swap(skin)                                             #
    @item_window.skin_swap(skin)                                               #
    self.skin_swap(skin)                                                       #
  end                                                                          #
  
  def create_all_windows
    @gold_window = Window_Gold.new
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = 0
    @gold_window.openness = 0
    @choice_window = Window_ChoiceList.new(self)
    @number_window = Window_NumberInput.new(self)
    @item_window = Window_KeyItem.new(self)
    refresh_all_skins($DEFAULT_MESSAGE_SKIN)                                   #
  end
  
  def fiber_main
    $game_message.visible = true
    update_background
    update_placement
    loop do
      process_all_text if $game_message.has_text?
      process_input
      $game_message.clear
      @gold_window.close
      Fiber.yield
      refresh_all_skins($DEFAULT_MESSAGE_SKIN)                                 #
      break unless text_continue?
    end
    close_and_wait
    $game_message.visible = false
    @fiber = nil
  end
end
# DEFINITIONS
#  Window_Message.refresh_all_skins(skin)
#  - This refreshes all message skins to the skin specified. I have used it to 
#    refresh the skins to the $DEFAULT_WINDOW_SKIN after someone has changed the
#    skin used by messages from default. 
# Window_Message.obtain_escape_param_string(text) 
#  - Allows string input when using escape codes, e.g, \ws[Window_skin_1]
# self.skin_swap(obtain_escape_param_string(text))
#  - I used this code to retreive the window name specified in the escape 
#    sequence/code. By adding this check to the process_escape_characters, I
#    told the engine to make a check for my custom sequence while processing 
#    text. Because the engine processes text after the message box, there may be
#    a millisecond in which the default message skin is visible while it loads
#    a skin for the first time.
