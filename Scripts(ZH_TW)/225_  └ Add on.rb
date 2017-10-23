#==============================================================================
# ** Window_TitleCommand
#------------------------------------------------------------------------------
#  This window is for selecting New Game/Continue on the title screen.
#==============================================================================
class Window_TitleCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::new_game, :new_game, true, nil, "開新遊戲")
    add_command(Vocab::continue, :continue, continue_enabled, nil, "讀取存檔")
    add_command(Vocab::shutdown, :shutdown, true, nil, "關閉遊戲")
  end
end
