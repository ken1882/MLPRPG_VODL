#==============================================================================
# ** PONY::ERRNO
#------------------------------------------------------------------------------
#  Friendship is magic. Error is tragic.
#==============================================================================
module PONY::ERRNO
  #--------------------------------------------------------------------------
  # * ERRNO COLLECTION
  #--------------------------------------------------------------------------
  # tag: translate
  
  ERR_Prefix = "進行遊戲時發生錯誤: "
  
  ERR_INFO = {
    :bits_incorrect   => "貨幣數量與區塊鏈同步失敗",
    :fileid_overflow  => "物件ID轉換成檔案時溢位",
    :item_unconsumed  => "消耗品使用時期錯誤",
    :int_overflow     => "整數溢位",
    :datatype_error   => "資料型別錯誤:\n",
    :nil_block        => "區塊鏈沒有礦工:",
    :chain_broken     => "區塊鏈錯誤:\n",
    :illegel_value    => "偵測到非法數值:\n",
    :checksum_failed  => "檔案驗證和失敗",
    :file_missing     => "遺失檔案:\n",
  }
  #--------------------------------------------------------------------------
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
    puts SPLIT_LINE
    caller.each{|i| puts i}
    @raised = true
    Audio.se_play("Audio/SE/Pinkie_Pie_Sad_Trombone",100,100)
    prefix = "進行遊戲時發生錯誤: "
    info   = ERR_INFO[@sym] ? ERR_INFO[@sym] : ""
    info   = info + ' ' + @extra_info
    puts SPLIT_LINE
    puts "An Error occurred!: #{@sym}"
    puts "#{@extra_info}"
    puts SPLIT_LINE
    SceneManager.scene.raise_overlay_window(:popinfo ,prefix + info, @cmd, @args, true)
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
  
end
