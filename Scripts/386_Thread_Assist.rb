#==============================================================================
# ** Theread Assist
#------------------------------------------------------------------------------
#  This defined the method for assist thread
#==============================================================================
module Thread_Assist
  #----------------------------------------------------------------------------
  # * Constants
  #----------------------------------------------------------------------------
  Uwait = 0.03 # Time wait until next update
  @work      = 0
  @work_args = []
  # >> Work type definiation
  WorkTable = {
    :BCmine   => 1,
    :BCquery  => 2,
  }
  #----------------------------------------------------------------------------
  module_function
  
  #----------------------------------------------------------------------------
  # * Assign work
  #----------------------------------------------------------------------------
  def assign_work(*args)
    type = args[0]
    puts "[Thread]: Work assigned: #{type}"
    @work = WorkTable[type]
    @work_args = args.shift rescue []
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
  # * Main update process
  #----------------------------------------------------------------------------
  def update_assist
    return if @work == 0
    case @work
    when WorkTable[:BCmine]
      puts "[Thread]: Assist mining"
      BlockChain.mining(true)
    end
    @work = 0
  end
  #----------------------------------------------------------------------------
  def work?(symbol)
    @work == WorkTable[symbol]
  end
  #----------------------------------------------------------------------------
  def yield
    puts "Kill Thread: #{$thassist}"
    Thread.kill($thassist)
    $assist.eval
    puts "#{Time.now} #{$thassist.stop?}"
  end
end
