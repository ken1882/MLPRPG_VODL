#==============================================================================
# ** RPG::Item
#==============================================================================
class RPG::Item < RPG::UsableItem
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = Vocab.GetDictPath(:item)
    DataManager.ensure_file_exist(path)
    filename = path + self.id_for_filename
    filename = Dir.glob(filename + '*').at(0)
    info = ""
    return self.description unless (filename && File.exist?(filename))
    File.open(filename, 'r') do |file|
      while(line = file.gets)
        info += line
      end
    end
    return info.size >= description.size ? info : description
  end
  #---------------------------------------------------------------------------
  def is_item?; true; end
  #---------------------------------------------------------------------------
end