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
  Command_Move        = "移動到"
  Command_Follow      = "跟隨"
  Command_Guard       = "保護"
  Command_Patrol      = "巡邏"
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
    add_command(Command_Move, :move, tactic_command_enabled?, nil, "移動到一定點或攻擊敵人")
    add_command(get_moving_name, :hold, tactic_command_enabled?, nil, "按鍵切換是否移動")
    add_command(get_reaction_name, :reaction, tactic_command_enabled?, nil, "按鍵切換戰鬥反應模式")
    # unfinished
    add_command(Command_Follow, :follow, false, nil, "跟隨目標")
    # unfinished
    add_command(Command_Guard, :guard, false, nil, "保護目標")
    # unfinished
    add_command(Command_Patrol, :patrol, false, nil, "巡邏區域")
  end
  #--------------------------------------------------------------------------
  def tactic_command_enabled?
    return false if @battler.nil? || @battler.dead?
    return false if @battler.is_a?(Game_Player)
    return false if @battler == $game_party.leader
    return true
  end
  #--------------------------------------------------------------------------
  def get_moving_name
    return "移動/停止" if !@battler || !@battler.movement_command
    return ":停止"     if @battler.command_holding?
    return ":移動"
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
