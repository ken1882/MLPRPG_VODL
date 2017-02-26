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
  # * Set Up New Game
  #--------------------------------------------------------------------------
  class << self; alias setup_new_game_bc setup_new_game; end
  def self.setup_new_game
    BlockChain.init_chain
    self.setup_new_game_bc
    $game_party.gain_item($data_items[1], 1, false, Vocab::Coinbase, "Console: MakeItem")
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
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  class << self; alias save_game_without_rescue_chain save_game_without_rescue; end
  def self.save_game_without_rescue(index)
    File.open(make_chainfilename(index), "wb") do |file|
      Marshal.dump(make_chain_content, file)
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
    PONY::CHAIN.verify_totalbalance
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
  # * Block Chain Save contents
  #--------------------------------------------------------------------------
  def self.make_chain_content
    BlockChain.item_for_save
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
end
