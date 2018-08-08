#==============================================================================
# ** Window_TitleCommand
#------------------------------------------------------------------------------
#  This window is for selecting New Game/Continue on the title screen.
#==============================================================================
class Window_TitleCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Overwrite: Change order and new commands
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::continue, :start_game, continue_enabled, nil, Vocab::continue)
    add_command(Vocab::new_game, :start_game, true, nil, Vocab::StartGame)
    add_command(Vocab::Option,   :option,     true, nil, Vocab::Option)
    add_command(Vocab::Credits,  :credits,    true, nil, Vocab::Credits)
    add_command(Vocab::shutdown, :shutdown,   true, nil, Vocab::ShutDown)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Continue
  #--------------------------------------------------------------------------
  def continue_enabled
    return !DataManager.lastest_savefile.nil?
  end
  #--------------------------------------------------------------------------
end
