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
  
  #---------------------------------------------------------------------------
  # *) Crash Dump
  #---------------------------------------------------------------------------
  def self.save_on_crash
    file_name = sprintf("CrashSace_%s.rvdata2",Time.now.to_s.tr('<>/\*?!:','-'))
    File.open(file_name, "wb") do |file|
      $game_map.dispose_sprites
      $game_system.on_before_save
      Marshal.dump(make_save_header, file)
      Marshal.dump(make_save_contents, file)
      @last_savefile_index = index
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  class << self; alias save_game_without_rescue_chain save_game_without_rescue; end
  def self.save_game_without_rescue(index)
    File.open(make_chainfilename(index), "wb") do |file|
      Marshal.dump(make_chain_header, file)
    end
    save_game_without_rescue_chain(index)
  end
  #--------------------------------------------------------------------------
  # * Execute Load (No Exception Processing)
  #--------------------------------------------------------------------------
  class << self; alias load_game_without_rescue_chain load_game_without_rescue; end
  def self.load_game_without_rescue(index)
    File.open(make_chainfilename(index), "rb") do |file|
      BlockChain.load_chain_data( Marshal.load(file) )
    end
    load_game_without_rescue_chain(index)
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
  # * Create Save Header
  #--------------------------------------------------------------------------
  def self.make_chain_header
    header = {}
    header[:nodes] = BlockChain.chain_nodes
    header
  end
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def self.save_file_exists?
    self.ensure_file_exist("Save/")
    !Dir.glob('Save/Save*.rvdata2').empty?
  end
end
