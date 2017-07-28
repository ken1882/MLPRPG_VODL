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
    $event = $game_map.events[@event_id]
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
  #--------------------------------------------------------------------------
  # * Overwrite: Shop Processing
  #--------------------------------------------------------------------------
  def command_302
    return if $game_party.in_combat?
    puts "Interpreter: Event Id: #{@event_id}"
    goods = [@params]
    while next_event_code == 605
      @index += 1
      goods.push(@list[@index].parameters)
    end
    SceneManager.call(Scene_Shop)
    SceneManager.scene.prepare(goods, @params[4])
    Fiber.yield
  end
  #--------------------------------------------------------------------------
  # * Transfer Player
  #--------------------------------------------------------------------------
  def command_201
    return if $game_party.in_combat?
    Fiber.yield while $game_player.transfer? || $game_message.visible
    @params[5] = 2 if @params[5] == 0
    
    if @params[0] == 0                      # Direct designation
      map_id = @params[1]
      x = @params[2]
      y = @params[3]
    else                                    # Designation with variables
      map_id = $game_variables[@params[1]]
      x = $game_variables[@params[2]]
      y = $game_variables[@params[3]]
    end
    
    $game_player.reserve_transfer(map_id, x, y, @params[4])
    $game_temp.fade_type = @params[5]
    $game_temp.loading_destroy_delay = true
    Fiber.yield while $game_player.transfer? || SceneManager.loading?
    SceneManager.destroy_loading_screen
    $game_temp.loading_destroy_delay = false
  end
  #--------------------------------------------------------------------------
  # * Execute
  #--------------------------------------------------------------------------
  def run
    wait_for_message
    while @list[@index] do
      execute_command
      @index += 1
    end
    @fiber = nil
    Fiber.yield
  end
 #--------------------------------------------------------------------------
  # * Get Target of Screen Command
  #--------------------------------------------------------------------------
  def screen
    return $game_map.screen
  end
end
