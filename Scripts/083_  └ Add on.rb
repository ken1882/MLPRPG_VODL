#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :eval_passed
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     depth : nest depth
  #--------------------------------------------------------------------------
  alias initialize_comp initialize
  def initialize(depth = 0)
    initialize_comp(depth)
    @eval_passed = true
  end
  #--------------------------------------------------------------------------
  # * Script
  #--------------------------------------------------------------------------
  def command_355
    script = @list[@index].parameters[0] + "\n"
    while next_event_code == 655
      @index += 1
      script += @list[@index].parameters[0] + "\n"
    end
    @eval_passed = false
    
    begin
      eval(script)
    rescue Exception => e
      e = e.to_s
      SceneManager.display_info("Error: " + e)
      SceneManager.scene.raise_overlay_window(:popinfo, "An error occurred while eval in Interpreter!\n")
    end
    
    @eval_passed = true
  end
  
end
