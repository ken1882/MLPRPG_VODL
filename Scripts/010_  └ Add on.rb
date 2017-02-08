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
  # * Create Filename
  #     index : File Index
  #--------------------------------------------------------------------------
  def self.make_filename(index)
    self.ensure_file_exist("Save/")
    sprintf("Save/Save%02d.rvdata2", index + 1)
  end
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def self.save_file_exists?
    self.ensure_file_exist("Save/")
    !Dir.glob('Save/Save*.rvdata2').empty?
  end
end
