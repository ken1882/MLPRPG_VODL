#==============================================================================
# ** Window_MenuCommand
#------------------------------------------------------------------------------
#  This command window appears on the menu screen.
#==============================================================================
class Window_MenuCommand < Window_ImageCommand
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width - 120
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    return 80
  end
  #--------------------------------------------------------------------------
  # * Add Main Commands to List
  #--------------------------------------------------------------------------
  def add_main_commands
    add_command(Vocab::item,   "Menu_Bag", :item,   main_commands_enabled, nil, "Item")
    add_command(Vocab::skill,  "Menu_Skill", :skill,  main_commands_enabled, nil, "Skill")
    add_command(Vocab::equip,  "Menu_Gears", :equip,  main_commands_enabled, nil, "Equip")
    add_command(Vocab::status, "Menu_Status", :status, main_commands_enabled, nil, "Status")
  end
  #--------------------------------------------------------------------------
  # * Add Formation to Command List
  #--------------------------------------------------------------------------
  def add_formation_command
    add_command(Vocab::formation, "Menu_Party", :formation, false, nil, "Change formation and squad setup")
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
    add_command(Vocab::save, "Menu_Save", :save, save_enabled, nil, "Save your game progess")
  end
  #--------------------------------------------------------------------------
  # * Add Exit Game to Command List
  #--------------------------------------------------------------------------
  def add_game_end_command
    add_command(Vocab::game_end, "Menu_System", :game_end, true, nil, "Change options or leave current game")
  end
end
