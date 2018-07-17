#==============================================================================
# ** Scene_LevelUp
#------------------------------------------------------------------------------
#  Handles all advancing stuff when leveling
#==============================================================================
# tag: last work: leveling
class Scene_LevelUp < Scene_MenuBase
  #--------------------------------------------------------------------------
  BackgroundFilename = "Tree_of_Harmony"
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_index_window
    create_index_help_window
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
  def create_index_help_window
    @index_help = Window_Help.new(11, @index_window.width / 2)
    @index_help.x, @index_help.y = @index_help.width, @index_window.y
    @index_help.swap_skin(WindowSkin::Luna)
    @index_help.hide
    @index_window.help_window = @index_help
    @index_window.refresh
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
    @index_window.set_handler(:on_levelup_finish, method(:levelup_ok))
    @index_window.set_handler(:cancel, method(:on_index_cancel))
    @index_window.set_handler(:on_feat_ok, method(:on_index_cancel))
  end
  #--------------------------------------------------------------------------
  def command_levelup
    @index_window.set_category(:levelup)
    @index_window.select(0)
    @index_help.show
  end
  #--------------------------------------------------------------------------
  def on_index_cancel
    @index_window.set_category(:main)
    @index_window.deactivate
    @index_window.unselect
    @index_help.hide
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  def command_skilltree
    @command_window.activate  # undefined
  end
  #--------------------------------------------------------------------------
  def levelup_ok
    [@command_window, @status_window].each{|w| w.refresh}
    
    if @actor.queued_levelings.empty?
      on_index_cancel
    else
      @actor.queued_levelings.each do |sid|
        info = Vocab::Leveling::SelectFeat + ' ' + $data_skills[sid].description
        @help_window.set_text(info)
        @index_window.make_feat_commands(sid)
        @index_window.set_category(:select_feat)
      end
      @actor.queued_levelings.clear
    end
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Cache.background(BackgroundFilename)
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
  #--------------------------------------------------------------------------
end # last work: leveling >> add tags to each skill and score ability improve
