#-------------------------------------------------------------------------------
# * Basic Marshal class
#-------------------------------------------------------------------------------
class << Marshal
  alias_method(:load_source, :load)
  def load(file, proc = nil)
    load_source(file, proc)
  rescue TypeError
    if file.kind_of?(File)
      file.rewind 
      file.read
    else
      file
    end
  end
end unless Marshal.respond_to?(:load_source)