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
    add_command(Vocab::new_game, :new_game, true, nil, Vocab::NewGame)
    add_command(Vocab::continue, :continue, continue_enabled, nil, Vocab::LoadGame)
    add_command(Vocab::shutdown, :shutdown, true, nil, Vocab::ShutDown)
  end
end
