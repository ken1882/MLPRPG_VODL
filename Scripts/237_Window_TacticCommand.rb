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
  Command_Move        = "Move"
  Command_Follow      = "Hold/Follow"
  Command_Guard       = "Guard"
  Command_Patrol      = "Patrol"
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x,y)
    @battler = nil
    hide
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Command_Move, :move)
    add_command(Command_Follow, :follow)
    add_command(get_reaction_name, :reaction)
    add_command(Command_Guard, :guard, false)
    add_command(Command_Patrol, :patrol, false)
  end
  #--------------------------------------------------------------------------
  # * Get current battler's aggressive level
  #--------------------------------------------------------------------------
  def get_reaction_name
    return "" unless @battler
    return "" unless @battler.aggressive_level
    return ":" + $data_states[PONY::StateID[:aggressive_level][@battler.aggressive_level]].name
  end
  
end
