#===============================================================================
# * Mutex
#===============================================================================
class Mutex
  #----------------------------------------------------------------------------
  def synchronize
    self.lock
    begin
      debug_print "[Thread]: Yield Block"
      yield
    ensure
      self.unlock rescue nil
      debug_print "[Thread]: Block completed"
    end
  end
end