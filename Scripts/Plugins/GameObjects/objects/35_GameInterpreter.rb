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
  # * Open Menu Screen
  #--------------------------------------------------------------------------
  alias command_351_imagemenu command_351
  def command_351
    Window_MenuImageCommand::init_command_position
    command_351_imagemenu
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
      info = sprintf(Vocab::Errno::ScriptErr, e, errfilename)
      SceneManager.display_info("Error: " + e.to_s)
      SceneManager.scene.raise_overlay_window(:popinfo, info)
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
      SceneManager.display_info(Vocab::TransferCombat)
      @transfer_cd = 120
      4.times{$game_player.move_straight(10 - $game_player.direction)}
      return
    elsif !$game_party.gathered?
      Audio.se_play("Audio/SE/hint_transfer_gather", 100, 100)
      SceneManager.display_info(Vocab::TransferGather)
      @transfer_cd = 120
      4.times{$game_player.move_straight(10 - $game_player.direction)}
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
  #--------------------------------------------------------------------------
  # * Overwrite: Change State
  #--------------------------------------------------------------------------
  def command_313
    iterate_actor_var(@params[0], @params[1]) do |actor|
      already_dead = actor.dead?
      if @params[2] == 0
        actor.add_state(@params[3], actor) # changed here
      else
        actor.remove_state(@params[3])
      end
      actor.perform_collapse_effect if actor.dead? && !already_dead
    end
    $game_party.clear_results
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Change Enemy State
  #--------------------------------------------------------------------------
  def command_333
    iterate_enemy_index(@params[0]) do |enemy|
      already_dead = enemy.dead?
      if @params[1] == 0
        enemy.add_state(@params[2], enemy) # changed here
      else
        enemy.remove_state(@params[2])
      end
      enemy.perform_collapse_effect if enemy.dead? && !already_dead
    end
  end
  #--------------------------------------------------------------------------
  # * Set Move Route
  #--------------------------------------------------------------------------
  def command_205
    $game_map.effectus_trigger_refresh if $game_map.effectus_need_refresh
    $game_map.refresh if $game_map.need_refresh
    character = get_character(@params[0])
    if character
      character.force_move_route(@params[1])
      Fiber.yield while character.move_route_forcing if @params[1].wait
    end
  end
  #--------------------------------------------------------------------------
  # * Change Actor Graphic
  #--------------------------------------------------------------------------
  def command_322
    actor = $game_actors[@params[0]]
    if actor
      actor.set_graphic(@params[1], @params[2], @params[3], @params[4])
    end
    $game_player.refresh
    return unless SceneManager.scene.is_a?(Scene_Map)
    SceneManager.scene.spriteset.effectus_vanilla_update_sprites
  end
  
end
