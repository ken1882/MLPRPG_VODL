#===============================================================================
# * Basic String class
#===============================================================================
class String  
  #----------------------------------------------------------------------------
  # *) Delete a char at certain position
  #----------------------------------------------------------------------------
  def delete_at(*args)
    self.slice!(*args)
  end
  #----------------------------------------------------------------------------
  # * Delete extra empty chars via Win32API
  #----------------------------------------------------------------------------
  def purify
    #self.gsub!("\u0000", '').delete!('\\0').squeeze!('\\').tr!('\\','/').delete_at(length-1)
    self.gsub!(/(?:\u0000)(.+)/,'')
    self.gsub!('\\n', 10.chr)
    self
  end
  #----------------------------------------------------------------------------
  # * Alias for fix encoding issue
  #----------------------------------------------------------------------------
  alias :gsub_enc! :gsub!
  def gsub!(*args)
    begin
      gsub_enc!(*args)
    rescue => exception
      args = change_encoding($default_encoding, *args)
      gsub_enc!(*args)
    end # begin
  end
  #----------------------------------------------------------------------------
  alias :gsub_enc :gsub
  def gsub(*args)
    begin
      gsub_enc(*args)
    rescue => exception
      args = change_encoding($default_encoding, *args)
      gsub_enc(*args)
    end # begin
  end
  #----------------------------------------------------------------------------
  alias :tr_enc :tr
  def tr(*args)
    begin
      tr_enc(*args)
    rescue => exception
      args = change_encoding($default_encoding, *args)
      tr_enc(*args)
    end # begin
  end
  #----------------------------------------------------------------------------
end