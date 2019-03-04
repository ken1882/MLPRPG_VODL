#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the 
# global variables used by the game are initialized by this module.
#==============================================================================
module DataManager
  #---------------------------------------------------------------------------
  # tag: game_mode
  SaveFilePathes = {
    :main     => "Save/main/",
    :tutorial => "Save/tutorial/",
  }
  #---------------------------------------------------------------------------
  FileLocInfo = Struct.new(:mode, :index, :time_stamp)
  #---------------------------------------------------------------------------
  @last_savefile_index = {}
  #--------------------------------------------------------------------------
  # * Overwrite: Initialize Module
  #--------------------------------------------------------------------------
  def self.init
    @last_savefile_index = {}
    SaveFilePathes.keys.each do |mode|
      @last_savefile_index[mode] = 0
    end
    load_database
    create_game_objects
    setup_battle_test if $BTEST
  end
  #---------------------------------------------------------------------------
  # *) Ensure the file or dictionary
  #---------------------------------------------------------------------------
  def self.ensure_file_exist(filename)
    Dir.mkdir(filename) unless File.exist?(filename)
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Set Up New Game
  #--------------------------------------------------------------------------
  def self.setup_new_game(mode)
    map_id = mode.init_map_id.nil? ? $data_system.start_map_id : mode.init_map_id
    sx     = mode.sx.nil? ? $data_system.start_x : mode.sx
    sy     = mode.sy.nil? ? $data_system.start_y : mode.sy
    create_game_objects
    $game_party.setup_starting_members(mode)
    $game_map.setup(map_id)
    $game_player.moveto(sx, sy)
    $game_player.refresh
    Graphics.frame_count = 0
  end
  #--------------------------------------------------------------------------
  # * Alias: Set Up New Game
  #--------------------------------------------------------------------------
  class << self; alias setup_new_game_bc setup_new_game; end
  def self.setup_new_game(mode)
    BlockChain.init_chain
    self.setup_new_game_bc(mode)
  end
  #---------------------------------------------------------------------------
  # *) Crash Dump
  #---------------------------------------------------------------------------
  def self.save_on_crash
    return true
    # dunno whether useful
    file_name = sprintf("CrashSave_%s.rvdata2",Time.now.to_s.tr('<>/\*?!:','-'))
    File.open(file_name, "wb") do |file|
      $game_map.dispose_sprites
      $game_system.on_before_save
      Marshal.dump(make_save_header, file)
      Marshal.dump(make_save_contents, file)
      @last_savefile_index[$game_system.game_mode] = index
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Execute Save
  #--------------------------------------------------------------------------
  def self.save_game(index, game_mode = $game_system.game_mode)
    begin
      save_game_without_rescue(index, game_mode)
    rescue Exception => e
      SceneManager.scene.raise_overlay_window(:popinfo, e)
      delete_save_file(index)
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Execute Load
  #--------------------------------------------------------------------------
  def self.load_game(index, game_mode = $game_system.game_mode)
    result = load_game_without_rescue(index, game_mode) # rescue false
    return result
  end
  #--------------------------------------------------------------------------
  def self.get_gamemode_path(game_mode)
    path = SaveFilePathes[game_mode]
    raise TypeError, "Invalid game mode symbol (#{game_mode})" unless path
    self.ensure_file_exist(path)
    return path
  end
  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  def self.save_game_without_rescue(index, game_mode)
    $game_map.effectus_party_pos.default = nil
    $game_map.effectus_event_pos.default = nil
    $game_map.effectus_etile_pos.default = nil
    $game_map.effectus_etriggers.default = nil
    File.open(make_filename(index, game_mode), "wb") do |file|
      $game_system.on_before_save
      header   = make_save_header
      contents = make_save_contents
      return false unless header && contents
      Marshal.dump(header, file)
      Marshal.dump(contents, file)
      @last_savefile_index[game_mode] = index
    end
    $game_map.effectus_party_pos.default_proc = proc { |h, k| h[k] = [] }
    $game_map.effectus_event_pos.default_proc = proc { |h, k| h[k] = [] }
    $game_map.effectus_etile_pos.default_proc = proc { |h, k| h[k] = [] }
    $game_map.effectus_etriggers.default_proc = proc { |h, k| h[k] = [] }
    return true
  end
  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  class << self; alias save_game_without_rescue_chain save_game_without_rescue; end
  def self.save_game_without_rescue(index, game_mode)
    begin
      File.open(make_chainfilename(index, game_mode), "wb") do |file|
        Marshal.dump(make_chain_content(index, game_mode), file)
      end
      $game_map.on_game_save
      save_game_without_rescue_chain(index, game_mode)
      build_checksum_file(index, game_mode)
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
  def self.load_game_without_rescue(index, game_mode)
    File.open(make_filename(index, game_mode), "rb") do |file|
      begin
        Marshal.load(file)
        extract_save_contents(Marshal.load(file))
        reload_map_if_updated
        @last_savefile_index[game_mode] = index
      rescue Exception => e
        errfilename = "LoadGameErr.txt"
        info = sprintf(Vocab::Errno::LoadErr, e, errfilename)
        SceneManager.scene.raise_overlay_window(:popinfo, info)
        info = sprintf("%s\n%s\n%s\n", SPLIT_LINE, Time.now.to_s, e)
        e.backtrace.each{|line| info += line + 10.chr}
        File.open(errfilename, 'a') do |file|
          file.write(info)
        end
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  class << self; alias load_game_without_rescue_chain load_game_without_rescue; end
  def self.load_game_without_rescue(index, game_mode)
    return :chainfile_missing if !File.exist?(make_chainfilename(index, game_mode))
    return :checksum_missing  if !File.exist?(make_hashfilename(index, game_mode))
    return :checksum_failed   unless verify_file_checksum(index, game_mode)
    File.open(make_chainfilename(index, game_mode), "rb") do |file|
      BlockChain.load_chain_data( Marshal.load(file) )
    end
    return :bits_incorrect  unless PONY::CHAIN.verify_totalbalance
    succed = load_game_without_rescue_chain(index, game_mode)
    $game_map.after_game_load
    return succed
  end
  #--------------------------------------------------------------------------
  # * Build Check Sum verify for file
  #--------------------------------------------------------------------------
  def self.build_checksum_file(index, game_mode)
    rpg_filename   = make_filename(index, game_mode)
    chain_filename = make_chainfilename(index, game_mode) 
    File.open(make_hashfilename(index, game_mode), 'wb') do |file|
      Marshal.dump(make_hash_contents(rpg_filename, chain_filename), file)
    end
  end
  #--------------------------------------------------------------------------
  # * Verify File CheckSum is correspond to last save
  #--------------------------------------------------------------------------
  def self.verify_file_checksum(index, game_mode)
    hash_contents = make_hash_contents(make_filename(index), make_chainfilename(index))
    checksum = hash_contents[:checksum]
    result = false
    File.open(make_hashfilename(index, game_mode), 'rb') do |file|
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
  def self.make_filename(index, game_mode = $game_system.game_mode)
    path = get_gamemode_path(game_mode)
    sprintf(path + "Save%02d.rvdata2", index + 1)
  end
  #--------------------------------------------------------------------------
  # * Create blockchain Filename
  #     index : File Index
  #--------------------------------------------------------------------------
  def self.make_chainfilename(index, game_mode = $game_system.game_mode)
    path = get_gamemode_path(game_mode)
    sprintf(path + "Chain%02d.rvdata2", index + 1)
  end
  #--------------------------------------------------------------------------
  # * Create Hash Verify Filename
  #     index : File Index
  #--------------------------------------------------------------------------
  def self.make_hashfilename(index, game_mode = $game_system.game_mode)
    path = get_gamemode_path(game_mode)
    sprintf(path + "CheckSum%02d.rvdata2", index + 1)
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
  def self.make_chain_content(index, game_mode = $game_system.game_mode)
    BlockChain.item_for_save(make_chainfilename(index, game_mode))
  end
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def self.save_file_exists?(game_mode = $game_system.game_mode, slot = nil)
    path = get_gamemode_path(game_mode)
    files = Dir.glob(path + 'Save*.rvdata2')
    return !files.empty? if slot.nil?
    return files.any? {|name| name == 'Save/Save' + slot.to_fileid(2) + '.rvdata2'}
  end
  #--------------------------------------------------------------------------
  # * Delete Save File
  #--------------------------------------------------------------------------
  class << self; alias delete_save_file_chain delete_save_file; end
  def self.delete_save_file(index, game_mode = $game_system.game_mode)
    File.delete(make_chainfilename(index, game_mode)) rescue nil
    File.delete(make_hashfilename(index, game_mode))  rescue nil
    delete_save_file_chain(index)
  end
  #--------------------------------------------------------------------------
  # * Map cache file name
  #--------------------------------------------------------------------------
  def self.make_cachefilename
    return "~Game.rvdata2"
  end
  #--------------------------------------------------------------------------
  def self.unpack_data
    File.delete($ScriptPath) rescue nil
    PONY::API::LoadGame.call($DefaultPath)
    $ObjectivePath = '\0' * 256
    PONY::API::FindFoler.call(0x1a, $ObjectivePath)
    $ObjectivePath.purify
    $ObjectivePath += '/VODL/'
  end
  #--------------------------------------------------------------------------
  # * Extract Save Contents
  #--------------------------------------------------------------------------
  class << self; alias extract_save_contents_sync extract_save_contents; end
  def self.extract_save_contents(contents)
    extract_save_contents_sync(contents)
    extract_effectus_content
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
  #--------------------------------------------------------------------------
  def self.extract_effectus_content
    return unless $game_map.effectus_party_pos
    $game_map.effectus_party_pos.default_proc = proc { |h, k| h[k] = [] }
    $game_map.effectus_event_pos.default_proc = proc { |h, k| h[k] = [] }
    $game_map.effectus_etile_pos.default_proc = proc { |h, k| h[k] = [] }
    $game_map.effectus_etriggers.default_proc = proc { |h, k| h[k] = [] }
  end
  #--------------------------------------------------------------------------
  # * Get Update Date of Save File
  #--------------------------------------------------------------------------
  def self.savefile_time_stamp(index, game_mode)
    File.mtime(make_filename(index, game_mode)) rescue Time.at(0)
  end
  #--------------------------------------------------------------------------
  # * Get File Index with Latest Update Date
  #--------------------------------------------------------------------------
  def self.latest_savefile_index(game_mode)
    savefile_max.times.max_by {|i| savefile_time_stamp(i, game_mode) }
  end
  #--------------------------------------------------------------------------
  # * Get Index of File Most Recently Accessed
  #--------------------------------------------------------------------------
  def self.last_savefile_index(game_mode = $game_system.game_mode)
    (@last_savefile_index[game_mode] || 0)
  end
  #--------------------------------------------------------------------------
  # * Get mode and index of file most recently accessed
  #--------------------------------------------------------------------------
  def self.latest_savefile
    re = FileLocInfo.new(nil, nil, Time.at(0))
    SaveFilePathes.keys.each do |mode|
      next unless save_file_exists?(mode)
      index = latest_savefile_index(mode)
      cur = FileLocInfo.new(mode, index, savefile_time_stamp(index, mode))
      next if re.time_stamp > cur.time_stamp
      re = cur.dup
    end
    return re.mode.nil? ? nil : re
  end
  #--------------------------------------------------------------------------
end
