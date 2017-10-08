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
  attr_accessor :params
  attr_accessor :transfer_cd
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     depth : nest depth
  #--------------------------------------------------------------------------
  alias initialize_comp initialize
  def initialize(depth = 0)
    initialize_comp(depth)
    @params      = []
    @transfer_cd = 0
    @eval_passed = true
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_dnd update
  def update
    @transfer_cd = 0  if @transfer_cd.nil?
    @transfer_cd -= 1 if @transfer_cd > 0
    update_dnd
  end
  #--------------------------------------------------------------------------
  # * Event Setup
  #--------------------------------------------------------------------------
  alias setup_gmitopt setup
  def setup(list, event_id = 0)
    $event = $game_map.events[event_id]
    setup_gmitopt(list, event_id)
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
      errfilename = "InterpreterErr.txt"
      SceneManager.display_info("Error: " + e.to_s)
      SceneManager.scene.raise_overlay_window(:popinfo, "An error occurred while eval in Interpreter!\nPlease submit #{errfilename} to developer")
      info = sprintf("%s\n%s\n%s\n", SPLIT_LINE, Time.now.to_s, e)
      e.backtrace.each{|line| info += line + 10.chr}
      puts "#{info}"
      File.open(errfilename, 'a') do |file|
        file.write(info)
      end
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
  def command_201(params = nil)
    return if @transfer_cd > 0
    if $game_party.in_combat?
      SceneManager.display_info("You can't change location during the combat")
      @transfer_cd = 120
      $game_player.move_straight(10 - $game_player.direction)
      return
    elsif !$game_party.gathered?
      Audio.se_play("Audio/SE/hint_transfer_gather", 100, 100)
      SceneManager.display_info("you must gather your party before venturing forth")
      @transfer_cd = 120
      $game_player.move_straight(10 - $game_player.direction)
      return
    end
    Fiber.yield while $game_player.transfer? || $game_message.visible
    @params = params unless params.nil?
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
