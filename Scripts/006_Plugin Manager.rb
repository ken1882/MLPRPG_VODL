#==============================================================================
# ** PluginManager
#------------------------------------------------------------------------------
#  This module handle the scripts(plguins) loaded form default archive
#==============================================================================
module PluginManager
  #--------------------------------------------------------------------------
  LoaderFile = "PluginLoader.rvdata2"   # Loading success indicator
  #--------------------------------------------------------------------------
  @error = []
  #--------------------------------------------------------------------------
  module_function
  #--------------------------------------------------------------------------
  # * Load plugin, mostly hot fix patches
  #--------------------------------------------------------------------------
  def load_plugin
    path = "Data/Plugin"
    Dir.mkdir(path) unless File.exist?(path)
    
    archives = Dir.glob(path + "/*.rvdata2")
    loader   = archives.find{|f| f.split(/[\\\/]+/).last.include?(LoaderFile)}
    load_archive(loader)
    
    succed = $plugin_loaded # return true if LoaderFile successfully executed
    puts("Failed to load plugins") unless succed
    
    return unless succed
    
    archives.delete(loader)
    archives.each do |archive|
      load_archive(archive)
    end
    
    files = Dir.glob(path + "/*.rb")
    files.each do |file|
      load_source(file)
    end
    
    p SPLIT_LINE
  end
  #------------------------------------------------------------------------------
  def load_archive(file)
    puts("Loading plugin: #{file}")
    scripts = load_data(file)
    scripts.each do |script|
      puts("\tLoading script: #{script[1]}")
      script[3] = Zlib::Inflate.inflate(script[2])
      load_script(script, file)
    end # each script in rvdata2 script archive
  end
  #------------------------------------------------------------------------------
  def load_source(file)
    puts("Loading source: #{file}")
    script = FileManager.compress_source(file)
    load_script(script, file)
  end
  #------------------------------------------------------------------------------
  def load_script(script, file)
    begin
      $RGSS_SCRIPTS.push(script)
      eval(script[3])
    rescue Exception => e
      puts sprintf("Failed to load: %s::%s\n", file, script[1])
      @error << report_exception(e)
    end
  end
  #------------------------------------------------------------------------------
  def load_error
    return @error
  end
  alias :load_errors :load_error
  #------------------------------------------------------------------------------
end # PluginManager
