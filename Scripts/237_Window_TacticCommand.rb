#==============================================================================
# ** Window_TacticCommand
#------------------------------------------------------------------------------
#   After a battler is selected in tactic mode, this window will display the 
# commands for controlable battler.
#==============================================================================
#tag: 1 ( Window_TacticCommand
class Window_TacticCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  Command_Move        = "Move to"
  Command_Hold        = "Hold/Move"
  Command_Follow      = "Follow"
  Command_Guard       = "Guard"
  Command_Patrol      = "Patrol"
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :battler
  attr_reader   :phase
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    x = Graphics.width - window_width
    super(x,y)
    @battler = nil
    hide
  end
  #--------------------------------------------------------------------------
  def update
    super
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Command_Move, :move, tactic_command_enabled?)
    add_command(Command_Hold, :hold, tactic_command_enabled?)
    add_command(get_reaction_name, :reaction, false)   # last work: toggle change
    add_command(Command_Follow, :follow, false)        # unfinished
    add_command(Command_Guard, :guard, false)          # unfinished
    add_command(Command_Patrol, :patrol, false)        # unfinished
  end
  #--------------------------------------------------------------------------
  def tactic_command_enabled?
    return false if battler.is_a?(Game_Player)
    return false if battler == $game_party.leader
    return true
  end
  #--------------------------------------------------------------------------
  # * Get current battler's aggressive level
  #--------------------------------------------------------------------------
  def get_reaction_name
    return "" unless @battler
    return "" unless @battler.aggressive_level
    return ":" + $data_states[PONY::StateID[:aggressive_level][@battler.aggressive_level]].name
  end
  #--------------------------------------------------------------------------
  def setup_battler(battler)
    @battler = battler
    refresh
    activate
    show
  end
  #--------------------------------------------------------------------------
  def fallback
    @battler = nil
    hide
    deactivate
  end
  #--------------------------------------------------------------------------
  def show
    super
    select(0)
  end
  #--------------------------------------------------------------------------
  def hide
    unselect
    super
  end
  
end
