#==============================================================================
# ** Scene_LevelUp
#------------------------------------------------------------------------------
#  Handles all advancing stuff when leveling
#==============================================================================
# tag: last work: leveling
class Scene_LevelUp < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start(actor = $game_party.leader)
    super
    @actor = actor
    create_help_window
    create_status_window
    create_command_window
    create_select_window
    create_index_window
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    wy = @help_window.height
    @command_window = Window_Command.new(0, wy)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.set_handler(:levelup,   method(:command_levelup))
    @command_window.set_handler(:scores,    method(:command_score))
    @command_window.set_handler(:skilltree, method(:command_skilltree))
    @command_window.set_handler(:cancel,    method(:return_scene))
  end
  
end
