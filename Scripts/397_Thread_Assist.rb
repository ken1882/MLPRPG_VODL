#==============================================================================
# ** Theread Assist
#------------------------------------------------------------------------------
#  This defined the method for assist thread
#==============================================================================
#tag: 3( Thread Assist
module Thread_Assist
  #----------------------------------------------------------------------------
  # * Constants
  #----------------------------------------------------------------------------
  Uwait = 0.03 # Time wait until next update
  @work      = 0
  @work_args = []
  # >> Work type definiation
  WorkTable = {
    :BCmine    => 1,
    :BCquery   => 2,
    :SoundPlay => 3,
  }
  #----------------------------------------------------------------------------
  module_function
  #----------------------------------------------------------------------------
  # * Assign work
  #----------------------------------------------------------------------------
  def assign_work(*args)
    return unless @work == 0
    type = args[0]
    puts "[Thread]: Work assigned: #{type}"
    @work = WorkTable[type]
    args.shift rescue []
    @work_args = args
  end
  #----------------------------------------------------------------------------
  # * Main entry access
  #----------------------------------------------------------------------------
  def assist_main
    @work = 0
    begin
      loop do
        update_assist
        sleep(Uwait)
      end
    rescue Exception => e
      PONY::ERRNO.mutex_error e
    end
  end
  #----------------------------------------------------------------------------
  # * Check wether need to pause
  #----------------------------------------------------------------------------
  def pause?
    return true if Graphics.transitioning?
    return true if BattleManager.in_battle?
    return false
  end
  #----------------------------------------------------------------------------
  # * Main update process
  #----------------------------------------------------------------------------
  def update_assist
    return if @work == 0
    case @work
    when WorkTable[:BCmine] && !BlockChain.locked?
      puts "[Thread]: Assist mining"
      $mutex.synchronize{BlockChain.mining(true)}
    when WorkTable[:SoundPlay]
      $mutex.synchronize{PONY.PlayAudio('sound.wav',8,0,0,0,0,0)}
    end
    @work = 0
  end
  #----------------------------------------------------------------------------
  def work?(symbol)
    @work == WorkTable[symbol]
  end
  #----------------------------------------------------------------------------
  def yield
    @work = 0
    File.open("test.txt", 'a'){|file| file.write("Kill Thread: #{$thassist}\n")}
    Thread.kill($thassist)
    puts "[Thread]: #{Time.now} #{$thassist.stop?}"
  end
end
