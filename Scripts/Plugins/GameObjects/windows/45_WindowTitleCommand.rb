#==============================================================================
# ** Window_TitleCommand
#------------------------------------------------------------------------------
#  This window is for selecting New Game/Continue on the title screen.
#==============================================================================
class Window_TitleCommand < Window_Command
  #--------------------------------------------------------------------------
  attr_accessor :ready
  #--------------------------------------------------------------------------
  # * Overwrite: Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    update_placement
    select_symbol(:continue) if continue_enabled
    self.openness = 0xff
    self.visible = false
    @ready = false
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Change order and new commands
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::continue, :continue, continue_enabled, nil, Vocab::continue)
    add_command(Vocab::new_game, :start_game, true, nil, Vocab::StartGame)
    add_command(Vocab::Option,   :option,     true, nil, Vocab::Option)
    add_command(Vocab::Credits,  :credits,    true, nil, Vocab::Credits)
    add_command(Vocab::shutdown, :shutdown,   true, nil, Vocab::ShutDown)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Continue
  #--------------------------------------------------------------------------
  def continue_enabled
    return !DataManager.latest_savefile.nil?
  end
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return super && @ready
  end
  #--------------------------------------------------------------------------
end
