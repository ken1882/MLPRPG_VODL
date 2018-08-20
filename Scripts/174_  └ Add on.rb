#==============================================================================
# ** Window_MenuCommand
#------------------------------------------------------------------------------
#  This command window appears on the menu screen.
#==============================================================================
class Window_MenuCommand < Window_ImageHorzCommand
  MENU_ICON_WIDTH  = 50
  MENU_ICON_HEIGHT = 50
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width - 120 # gold window width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    return 80
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    MENU_ICON_HEIGHT
  end
  #--------------------------------------------------------------------------
  def item_width
    MENU_ICON_WIDTH
  end
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.x += 4
    rect
  end # last work: fix the selection icon rect
  #--------------------------------------------------------------------------
  # * Add Main Commands to List
  #--------------------------------------------------------------------------
  def add_main_commands
    names   = [Vocab::item, Vocab::skill, Vocab::equip, Vocab::status,
               Vocab::LevelUp, Vocab::Quest]
    symbols = [:item, :skill, :equip, :status, :levelup, :quest]
    image   = ["Menu_Bag", "Menu_Skill", "Menu_Gears", "Menu_Status", 
               "Menu_Upgrade", "Menu_Quest"]
             
    names.size.times do |i|
      add_command(names[i], symbols[i], image[i], main_commands_enabled, nil, names[i])
    end
  end
  #--------------------------------------------------------------------------
  # * Add Formation to Command List
  #--------------------------------------------------------------------------
  def add_formation_command
    add_command(Vocab::formation, :formation, "Menu_Party", main_commands_enabled, nil, Vocab::formation)
  end
  #--------------------------------------------------------------------------
  # * For Adding Original Commands
  #--------------------------------------------------------------------------
  def add_original_commands
  end
  #--------------------------------------------------------------------------
  # * Add Save to Command List
  #--------------------------------------------------------------------------
  def add_save_command
    add_command(Vocab::save, :save, "Menu_Save", save_enabled?, nil, Vocab::SaveDec)
  end
  #--------------------------------------------------------------------------
  # * Add Exit Game to Command List
  #--------------------------------------------------------------------------
  def add_game_end_command
    add_command(Vocab::game_end, :game_end, "Menu_System", true, nil, Vocab::SystemDec)
  end
  #--------------------------------------------------------------------------
  def save_enabled?
    return false if @header.nil? && SceneManager.scene_is?(Scene_Load)
    return false if SceneManager.scene_is?(Scene_Load)
    return false if $game_system.save_disabled
    #return false if at_special_slot?
    return false if BattleManager.in_battle?
    return true
  end
  
end
