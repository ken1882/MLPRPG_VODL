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
    create_index_window
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_LevelUpCommands.new(@actor)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.y = @help_window.height
    @command_window.set_handler(:levelup,   method(:command_levelup))
    @command_window.set_handler(:cancel,    method(:return_scene))
    @command_window.set_handler(:skilltree, method(:command_skilltree))
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    y = @help_window.height
    @status_window = Window_SkillStatus.new(@command_window.width, y)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  def create_index_window
    cy = @status_window.y + @status_window.height
    cw = Graphics.width
    ch = Graphics.height - cy
    @index_window = Window_LevelUpIndex.new(0, cy, cw, ch, @actor)
  end
  #--------------------------------------------------------------------------
  def command_levelup
    
  end
  #--------------------------------------------------------------------------
  def command_skilltree
  end
end
