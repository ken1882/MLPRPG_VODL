#==============================================================================
# ** Window_GameMode
#------------------------------------------------------------------------------
#  For selecting game mode in title screen, mostly are main/DLC/tutorial
#==============================================================================
class Window_GameMode < Window_ImageCommand
  #------------------------------------------------------------------------------
  GameMode = Struct.new(:symbol, :name, :image, :enabled, :help)
  #------------------------------------------------------------------------------
  Modes = [
    GameMode.new(:main, Vocab::VODL, "Mode_VODL", true, nil),
    GameMode.new(:tutorial, Vocab::Tutorial, "Mode_Tutorial", true, nil),
  ]
  #------------------------------------------------------------------------------
  def window_height
    Graphics.height
  end
  #------------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #------------------------------------------------------------------------------
  def item_height
    return 128
  end
  #------------------------------------------------------------------------------
  def item_width
    Graphics.width
  end
  #------------------------------------------------------------------------------
  def make_command_list
    for mode in Modes
      add_command(mode.name, mode.symbol, mode.image, mode.enabled, nil, mode.help)
    end
  end
  #------------------------------------------------------------------------------
end # last work: title scene game mode stuff
