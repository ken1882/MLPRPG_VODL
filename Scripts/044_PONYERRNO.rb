#==============================================================================
# ** PONY::ERRNO
#------------------------------------------------------------------------------
#  Friendship is magic. Error is tragic.
#==============================================================================
module PONY::ERRNO
  #--------------------------------------------------------------------------
  # * ERRNO COLLECTION
  #--------------------------------------------------------------------------
  ERR_INFO = Vocab::Errno::RESymbol_Table
  
  @raised = false
  #--------------------------------------------------------------------------
  # * Raise Error Overlay
  #--------------------------------------------------------------------------
  def self.raise(symbol, cmd = nil, args = nil, extra_info = "")
    @sym        = symbol
    @cmd        = cmd
    @args       = args
    @extra_info = extra_info
    @errno      = true
  end
  #--------------------------------------------------------------------------
  def self.raise_errno
    return if @raised
    
    @raised = true
    Audio.se_play("Audio/SE/Pinkie_Pie_Sad_Trombone",100,100)
    sym    = ERR_INFO[@sym] ? ERR_INFO[@sym] : "" 
    info   = sprintf(Vocab::Errno::RunTimeErr, sym, @extra_info)
    puts SPLIT_LINE
    puts "An Error occurred!: #{@sym}"
    puts "#{@extra_info}"
    puts SPLIT_LINE
    SceneManager.scene.raise_overlay_window(:popinfo , info, @cmd, @args, true)
  end
  #--------------------------------------------------------------------------
  def self.close_errno_window
    @raised     = false
    @sym        = nil
    @cmd        = nil
    @args       = nil
    @extra_info = nil
    @errno      = nil
  end
  #--------------------------------------------------------------------------
  def self.mutex_error(e)
    @error = e
  end
  #--------------------------------------------------------------------------
  def self.error_occurred?
    @error
  end
  #--------------------------------------------------------------------------
  def self.errno_occurred?
    @errno
  end
  #--------------------------------------------------------------------------
  def self.sequence_error(type, *args)
    case type
    when :args
      info = Vocab::Errno::SequenceArgError
      raise ArgumentError, sprintf(info, args[0], args[1], args[2])
    end
  end
end
