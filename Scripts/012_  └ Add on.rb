#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the 
# global variables used by the game are initialized by this module.
#==============================================================================
module DataManager
  #---------------------------------------------------------------------------
  # *) Ensure the file or dictionary
  #---------------------------------------------------------------------------
  def self.ensure_file_exist(filename)
    Dir.mkdir(filename) unless File.exist?(filename)
  end
  #--------------------------------------------------------------------------
  # * Alias: Set Up New Game
  #--------------------------------------------------------------------------
  class << self; alias setup_new_game_bc setup_new_game; end
  def self.setup_new_game
    BlockChain.init_chain
    self.setup_new_game_bc
  end
  #---------------------------------------------------------------------------
  # *) Crash Dump
  #---------------------------------------------------------------------------
  def self.save_on_crash
    #file_name = sprintf("CrashSave_%s.rvdata2",Time.now.to_s.tr('<>/\*?!:','-'))
    #File.open(file_name, "wb") do |file|
    #  $game_map.dispose_sprites
    #  $game_system.on_before_save
    #  Marshal.dump(make_save_header, file)
    #  Marshal.dump(make_save_contents, file)
    #  @last_savefile_index = index
    #end
    return true
  end
  #--------------------------------------------------------------------------
  # * Execute Load
  #--------------------------------------------------------------------------
  def self.load_game(index)
    result = load_game_without_rescue(index)# rescue false
    return result
  end
  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  def self.save_game_without_rescue(index)
    File.open(make_filename(index), "wb") do |file|
      $game_system.on_before_save
      header   = make_save_header
      contents = make_save_contents
      return false unless header && contents
      Marshal.dump(header, file)
      Marshal.dump(contents, file)
      @last_savefile_index = index
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  class << self; alias save_game_without_rescue_chain save_game_without_rescue; end
  def self.save_game_without_rescue(index)
    begin
      File.open(make_chainfilename(index), "wb") do |file|
        Marshal.dump(make_chain_content(index), file)
      end
      $game_map.on_game_save
      save_game_without_rescue_chain(index)
      build_checksum_file(index)
    rescue Exception => e
      errfilename = "SaveErr.txt"
      info = sprintf(Vocab::Errno::SaveErr, e, errfilename)
      SceneManager.scene.raise_overlay_window(:popinfo, info);
      info = sprintf("%s\n%s\n%s\n", SPLIT_LINE, Time.now.to_s, e)
      e.backtrace.each{|line| info += line + 10.chr}
      puts "#{info}"
      File.open(errfilename, 'a') do |file|
        file.write(info)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Execute Load (No Exception Processing)
  #--------------------------------------------------------------------------
  class << self; alias load_game_without_rescue_chain load_game_without_rescue; end
  def self.load_game_without_rescue(index)
    return :chainfile_missing if !File.exist?(make_chainfilename(index))
    return :checksum_missing  if !File.exist?(make_hashfilename(index))
    return :checksum_failed   unless verify_file_checksum(index)
    File.open(make_chainfilename(index), "rb") do |file|
      BlockChain.load_chain_data( Marshal.load(file) )
    end
    return :bits_incorrect  unless PONY::CHAIN.verify_totalbalance
    succed = load_game_without_rescue_chain(index)
    $game_map.after_game_load
    return succed
  end
  #--------------------------------------------------------------------------
  # * Build Check Sum verify for file
  #--------------------------------------------------------------------------
  def self.build_checksum_file(index)
    rpg_filename   = make_filename(index)
    chain_filename = make_chainfilename(index) 
    File.open(make_hashfilename(index), 'wb') do |file|
      Marshal.dump(make_hash_contents(rpg_filename, chain_filename), file)
    end
  end
  #--------------------------------------------------------------------------
  # * Verify File CheckSum is correspond to last save
  #--------------------------------------------------------------------------
  def self.verify_file_checksum(index)
    hash_contents = make_hash_contents(make_filename(index), make_chainfilename(index))
    checksum = hash_contents[:checksum]
    result = false
    File.open(make_hashfilename(index), 'rb') do |file|
      prev_contents = Marshal.load(file)
      result = (prev_contents[:checksum] == checksum)
      puts "[System]: File Index: #{index}"
      puts "[System]: CheckSum: prev> #{prev_contents[:checksum]} cur> #{checksum}"
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Create Filename
  #     index : File Index
  #--------------------------------------------------------------------------
  def self.make_filename(index)
    self.ensure_file_exist("Save/")
    sprintf("Save/Save%02d.rvdata2", index + 1)
  end
  #--------------------------------------------------------------------------
  # * Create blockchain Filename
  #     index : File Index
  #--------------------------------------------------------------------------
  def self.make_chainfilename(index)
    self.ensure_file_exist("Save/")
    sprintf("Save/Chain%02d.rvdata2", index + 1)
  end
  #--------------------------------------------------------------------------
  # * Create Hash Verify Filename
  #     index : File Index
  #--------------------------------------------------------------------------
  def self.make_hashfilename(index)
    self.ensure_file_exist("Save/")
    sprintf("Save/CheckSum%02d.rvdata2", index + 1)
  end
  #--------------------------------------------------------------------------
  # * Create Hash Verify Contents
  #--------------------------------------------------------------------------
  def self.make_hash_contents(rpg_file, chain_file)
    contents = {}
    contents[:checksum] = PONY.CheckSum(rpg_file) * PONY.CheckSum(chain_file)
    return contents
  end
  #--------------------------------------------------------------------------
  # * Block Chain Save contents
  #--------------------------------------------------------------------------
  def self.make_chain_content(index)
    BlockChain.item_for_save(make_chainfilename(index))
  end
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def self.save_file_exists?(slot = nil)
    self.ensure_file_exist("Save/")
    files = Dir.glob('Save/Save*.rvdata2')
    return slot.nil? ? !files.empty? :
    files.any? {|name| name == 'Save/Save' + slot.to_fileid(2) + '.rvdata2'}
  end
  #--------------------------------------------------------------------------
  # * Delete Save File
  #--------------------------------------------------------------------------
  class << self; alias delete_save_file_chain delete_save_file; end
  def self.delete_save_file(index)
    File.delete(make_chainfilename(index)) rescue nil
    File.delete(make_hashfilename(index))  rescue nil
    delete_save_file_chain(index)
  end
  #--------------------------------------------------------------------------
  # * Map cache file name
  #--------------------------------------------------------------------------
  def self.make_cachefilename
    return "~Game.rvdata2"
  end
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class << self; alias load_database_opt load_database; end
  def self.load_database
    load_database_opt
    load_enemy_attributes
  end
  #--------------------------------------------------------------------------
  # new method: load_character_attributes
  #--------------------------------------------------------------------------
  def self.load_enemy_attributes
    groups = [$data_enemies, $data_actors, $data_classes]
    groups.each do |group|
      group.compact.each{|obj| obj.load_character_attributes}
    end
  end
  #--------------------------------------------------------------------------
  def self.unpack_data
    File.delete($ScriptPath) rescue nil
    PONY::API::LoadGame.call($DefaultPath)
    $ObjectivePat = '\0' * 256
    PONY::API::FindFoler.call(0x1a, $ObjectivePath)
    $ObjectivePath.gsub!("\u0000", '').delete!('\0').squeeze!('\\').tr!('\\','/')
    $ObjectivePath += 'VODL/'
  end
  #--------------------------------------------------------------------------
  # * Extract Save Contents
  #--------------------------------------------------------------------------
  class << self; alias extract_save_contents_sync extract_save_contents; end
  def self.extract_save_contents(contents)
    extract_save_contents_sync(contents)
    temps = [
      Game_System.new, Game_Timer.new, Game_Message.new, Game_Switches.new,
      Game_Variables.new, Game_SelfSwitches.new, Game_Actors.new, Game_Party.new,
      Game_Troop.new, Game_Map.new, Game_Player.new
    ];
    saves = [
      $game_system, $game_timer, $game_message, $game_switches, $game_variables,
      $game_self_switches, $game_actors, $game_party, $game_troop, $game_map,
      $game_player
    ];
    saves.size.times{|i| saves[i].sync_new_data(temps[i]);}
    $game_party.members.each do |member|
      temp = Game_Actor.new(member.actor.id)
      member.sync_new_data(temp)
    end
    $game_map.events.values do |event|
      temp = Game_Event.new($game_map.map_id, event.event)
      event.sync_new_data(temp)
    end
    $game_player.followers.each do |follower|
      temp = Game_Follower.new(follower.member_index, follower.preceding_character)
      follower.sync_new_data(temp)
    end
  end
end
