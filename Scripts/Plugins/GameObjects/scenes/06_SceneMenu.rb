#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  This class performs the menu screen processing.
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_gold_window
    create_status_window
    create_foreground
    puts "Assign blockchian mining work"
    Thread_Assist.assign_work(:BCmine) # tag: 3
    $game_party.sync_blockchain
    if $USE_SCENE_SKIN == TRUE                                                 
      @command_window.scene_swap($PAUSE_MENU_SKIN)                             
      @gold_window.scene_swap($PAUSE_MENU_SKIN)                                
      @status_window.scene_swap($PAUSE_MENU_SKIN)                              
    end
    $game_map.cache_crash_backup
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_foreground
    puts "Assign blockchian mining work"
    Thread_Assist.assign_work(:BCmine) # tag: 3
    $game_party.sync_blockchain
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_ImageMenuStatus.new(0 ,@command_window.height)
  end
  #--------------------------------------------------------------------------
  # * Create Foreground
  #--------------------------------------------------------------------------
  def create_foreground
    @foreground_sprite = Sprite.new
    @foreground_sprite.bitmap = Cache.UI("Menu_SplitLine")
    @foreground_sprite.y = @command_window.height - 4
    @foreground_sprite.z = PONY::SpriteDepth.layers(1)
  end
  #--------------------------------------------------------------------------
  def dispose_foreground
    return if @foreground_sprite.nil?
    @foreground_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Gold Window
  #--------------------------------------------------------------------------
  def create_gold_window
    @gold_window = Window_Gold.new(0)
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = (@command_window.height - @gold_window.height) / 2
  end
  #--------------------------------------------------------------------------
  # * Overwrute: Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MenuImageCommand.new
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:skill,     method(:command_personal))
    @command_window.set_handler(:equip,     method(:command_personal))
    @command_window.set_handler(:status,    method(:command_personal))
    @command_window.set_handler(:formation, method(:command_formation))
    @command_window.set_handler(:save,      method(:command_save))
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
    @command_window.set_handler(:quest,    method(:command_quest))
    @command_window.set_handler(:levelup,  method(:command_personal))
  end
  #--------------------------------------------------------------------------
  def command_quest  
    SceneManager.call(Scene_Quest)
  end
  #--------------------------------------------------------------------------
  # * [OK] Personal Command
  #--------------------------------------------------------------------------
  alias ok_personal_ok_dnd on_personal_ok
  def on_personal_ok
    case @command_window.current_symbol
    when :levelup
      SceneManager.call(Scene_LevelUp)
    else
      ok_personal_ok_dnd
    end
  end
  #--------------------------------------------------------------------------
end
