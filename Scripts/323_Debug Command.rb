
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
          puts "Eval: #{execute_command}"
          eval(execute_command)
        rescue Exception => e
          info = e
          puts e.backtrace
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
#===============================================================================
# * Game_Console
#===============================================================================
class Game_Console
  #----------------------------------------------------------------------------
  def AddBits(amount, useless = 0)
    bits = $game_party.gold # tag: queued >> security PONY.DecInt($game_party.gold(true))
    amount = [[amount, 1000000 - bits].min, 0].max
    if bits >= 1000000
      SceneManager.display_info("You can only AddBits when you have less than 1M Bits.")
      return
    end
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
  
  alias CreateItem MakeItem;
  alias AddItem    MakeItem;
  #----------------------------------------------------------------------------
  def MakeWeapon(id = 1,amount = 1)
    $game_party.gain_item($data_weapons[id],amount, false, Vocab::Coinbase, "Console: MakeWeapon")
  end
  
  alias CreateWeapon MakeWeapon;
  #----------------------------------------------------------------------------
  def MakeArmor(id = 1,amount = 1)
    $game_party.gain_item($data_armors[id],amount, false, Vocab::Coinbase, "Console: MakeArmor")
  end
  
  alias CreateArmor MakeArmor;
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
  def Move(dir)
    case dir
    when 2; $game_player.move_poll += [[2,true]]
    when 4; $game_player.move_poll += [[4,true]]
    when 6; $game_player.move_poll += [[6,true]]
    when 8; $game_player.move_poll += [[8,true]]
    else SceneManager.display_info("Invailed Command!")
    end
  end
  #----------------------------------------------------------------------------
  def Teleport(map_id = 27 ,x = 4,y = 3)
    params = [0, map_id, x, y, 2, 2]
    $game_map.interpreter.command_201(params)
    $game_temp.loading_destroy_delay = false
    SceneManager.destroy_loading_screen
  end
  #----------------------------------------------------------------------------
  def ShowBallon(id = 1)
    $game_player.csca_balloon_id = id
  end
  #----------------------------------------------------------------------------
  def EvalFile
    file = File.new("Eval.txt",'r')
    while (line = file.gets)
      eval(line)
    end
    file.close
  end
  #----------------------------------------------------------------------------
  def ShowObjectCollection(cls = nil)
    objects = cls ? ObjectSpace.each_object(cls) : ObjectSpace.each_object
    filename = "objrecord_substring.txt"
    File.open(filename, 'w') do |file|
      objects.each do |obj|
        next if obj.is_a?(String)
        file.write("#{obj.class} #{obj} #{obj.inspect}" + 10.chr) rescue " (UTF-16 text) "
      end
    end
    SceneManager.display_info("Objects have been output to #{filename}")
  end
  #----------------------------------------------------------------------------
  def Performance
    ch_sp  = "Character Sprites: #{SceneManager.spriteset.character_sprites.size}"
    ev_num = "Events Avaliable: #{$game_map.events.size}" 
    fps    = "Frame Count: #{Graphics.frame_count}"
    infos = [ch_sp, ev_num, fps]
    for info in infos
      SceneManager.display_info(info)
    end
  end
  #----------------------------------------------------------------------------
  def PickupAllDrops
    $game_map.item_drops[$game_map.map_id].each do |loot|
      loot.process_pickup
    end
  end
  #----------------------------------------------------------------------------
  def SuperDuperKillingParty
    $game_map.enemies.each{|e| e.die} until $game_map.enemies.size == 0
  end
  #----------------------------------------------------------------------------
end
