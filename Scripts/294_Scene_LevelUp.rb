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
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_index_window
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_LevelUpCommands.new(0, @help_window.height, @actor)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.set_handler(:levelup,   method(:command_levelup))
    @command_window.set_handler(:cancel,    method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
    set_skilltree_handlers
  end
  #--------------------------------------------------------------------------
  def set_skilltree_handlers
    syms = [:unique, :race, :class, :dualclass]
    syms.each do |sym|
      @command_window.set_handler(sym, method(:command_skilltree))
    end
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
    @command_window.activate  # undefined
  end
  #--------------------------------------------------------------------------
  def command_skilltree
    @command_window.activate  # undefined
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @command_window.actor = @actor
    @status_window.actor = @actor
    @index_window.actor = @actor
    @command_window.activate
  end
end
