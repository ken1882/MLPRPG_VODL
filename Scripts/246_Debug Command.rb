
class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :console_list            # Inputed console list
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_console initialize
  def initialize
    @console_list = []
    initialize_console
  end
  #--------------------------------------------------------------------------
  # * Push new console command to record list
  #--------------------------------------------------------------------------
  def push_console(text)
    
    @console_list.unshift(text)
    @console_list.uniq!
    @console_list.pop if @console_list.size >= 10
  end
  #=================================================
  # *) General console setting
  #=================================================
  def console(command = "")
    
    identified = false
    allow_eval_code = false
    if command.include?("RPG::Global")
      command = command.split(">>")
      prefix = "$"
      identified = true
    elsif command.include?("PONY::Eval")
      command = command.split(">>")
      prefix = ""
      identified = true
      allow_eval_code = true
    else
      command = command.split(":")
      prefix = "$game_console."
      identified = true
    end
    
    execute_command = command[1]
    
    if execute_command.nil? || !identified
      info = "No command input!"
    elsif execute_command.include?("$") && !allow_eval_code
      info = "Invailed command!"
    else
      executable = false
      for method in $game_console.methods
        executable = true if command[1].split('(').at(0) == method.to_s
      end
      
      if executable && !allow_eval_code
        values = command[1].tr('()','')
        executable = values.split(',').size < 3
      end
      
      if executable || allow_eval_code
        execute_command = prefix + execute_command
        info = "success! #{execute_command}"
        begin
          eval(execute_command)
        rescue Exception => e
          info = e
        end
      else
        info = "Invailed command!"
      end
    end
    
    info = info.to_s
    info = info.match("success") ? "Info: " + info : "Error: " + info
    SceneManager.display_info(info)
  end
  
end
class Debug_Functions
  #----------------------------------------------------------------------------
  def AddBits(amount = 0, useless = 0)
    $game_party.gain_gold(amount)
  end
  #----------------------------------------------------------------------------
  def SetCurrentXP(value = 100, useless = 0)
    $game_party.members.each do |battler|
      battler.change_exp(value,true)
    end
  end
  #----------------------------------------------------------------------------
  def MakeItem(id = 1,amount = 1)
    $game_party.gain_item($data_items[id],amount, false, Vocab::Coinbase, "Console: MakeItem")
  end
  #----------------------------------------------------------------------------
  def MakeWeapon(id = 1,amount = 1)
    $game_party.gain_item($data_weapons[id],amount, false, Vocab::Coinbase, "Console: MakeWeapon")
  end
  #----------------------------------------------------------------------------
  def MakeArmor(id = 1,amount = 1)
    $game_party.gain_item($data_armors[id],amount, false, Vocab::Coinbase, "Console: MakeArmor")
  end
  #----------------------------------------------------------------------------
  def RecoverAll
    $game_party.members.each do |battler|
      battler.recover_all
    end
    #YES.recover_stamina
  end
  #----------------------------------------------------------------------------
  def SaveFile
    SceneManager.call(Scene_Save)
  end
  #----------------------------------------------------------------------------
  def LoadFile
    SceneManager.call(Scene_Load)
  end
  #----------------------------------------------------------------------------
  def Show_Current_Position
    SceneManager.display_info("Player Position:(#{$game_player.x},#{$game_player.y})")
  end
  #----------------------------------------------------------------------------
  def Move(dir)
    case dir
    when 2; $game_player.move_down
    when 4; $game_player.move_left
    when 6; $game_player.move_right
    when 8; $game_player.move_up
    else SceneManager.display_info("Invailed Command!")
    end
  end
  #----------------------------------------------------------------------------
  def Teleport(map_id = 5 ,x = 7,y = 7)
    $game_player.reserve_transfer(map_id, x, y,)
  end
  #----------------------------------------------------------------------------
  def Show_Balloon(id = 1)
    $game_player.csca_balloon_id = id
  end
  #----------------------------------------------------------------------------
  def Eval_from_file
    file = File.new("Eval.txt",'r')
    while (line = file.gets)
      eval(line)
    end
    file.close
  end
  #----------------------------------------------------------------------------
end
