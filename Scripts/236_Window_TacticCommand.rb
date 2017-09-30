#==============================================================================
# ** Window_TacticCommand
#------------------------------------------------------------------------------
#   After a battler is selected in tactic mode, this window will display the 
# commands for controlable battler.
#==============================================================================
class Window_TacticCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  Command_Move        = "Move to"
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
    @last_index = 0
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
    add_command(Command_Move, :move, tactic_command_enabled?, nil, "Move to a position or attack an enemy")
    add_command(get_moving_name, :hold, tactic_command_enabled?, nil, "Press to toggle between hold/moving")
    add_command(get_reaction_name, :reaction, tactic_command_enabled?, nil, "Toggle between combat reactions")
    # unfinished
    add_command(Command_Follow, :follow, false, nil, "Follow a character")
    # unfinished
    add_command(Command_Guard, :guard, false, nil, "Protect a character")
    # unfinished
    add_command(Command_Patrol, :patrol, false, nil, "Guard an area")
  end
  #--------------------------------------------------------------------------
  def tactic_command_enabled?
    return false if battler.is_a?(Game_Player)
    return false if battler == $game_party.leader
    return true
  end
  #--------------------------------------------------------------------------
  def get_moving_name
    return "Hold/Move" if !@battler || !@battler.movement_command
    return ":Hold"     if @battler.command_holding?
    return ":Move"
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
    @battler     = nil
    @@last_index = 0
    hide
    deactivate
  end
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    @last_index = index
    super(symbol)
  end
  #--------------------------------------------------------------------------
  def show
    super
    select(@last_index)
  end
  #--------------------------------------------------------------------------
  def hide
    unselect
    super
  end
  
end
