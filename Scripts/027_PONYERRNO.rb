#==============================================================================
# ** PONY::ERRNO
#------------------------------------------------------------------------------
#  Friendship is magic. Error is tragic.
#==============================================================================
module PONY::ERRNO
  #--------------------------------------------------------------------------
  # * ERRNO COLLECTION
  #--------------------------------------------------------------------------
  ERR_INFO = {
    :bits_incorrect   => "Bits amount asynchronous with Block Chain",
    :fileid_overflow  => "Object id overflow while convert to savefile format",
    :item_unconsumed  => "Consumable Item can't be consumed",
    :int_overflow     => "Integer Overflow",
    :datatype_error   => "Data Type Error:\n",
    :nil_block        => "Block nil miner",
    :chain_broken     => "Block Chain Error:\n",
    :illegel_value    => "Illegel value:\n",
    :checksum_failed  => "File CheckSum failure",
    :file_missing     => "File missing:\n",
  }
  
  @raised = false
  #--------------------------------------------------------------------------
  # * Raise Error Overlay
  #--------------------------------------------------------------------------
  def self.raise(symbol, cmd = nil, args = nil, extra_info = "")
    return if @raised
    puts SPLIT_LINE
    caller.each{|i| puts i}
    @raised = true
    Audio.se_play("Audio/SE/Pinkie_Pie_Sad_Trombone",100,100)
    prefix = "  An Error has occurred during gameplay: "
    info   = ERR_INFO[symbol] + ' ' + extra_info
    puts SPLIT_LINE
    puts "An Error occurred!: #{symbol}"
    puts "#{extra_info}"
    puts SPLIT_LINE
    SceneManager.scene.raise_overlay_window(:popinfo ,prefix + info, cmd, args, true)
  end
  
  def self.close_errno_window
    @raised = false
  end
  
  def self.mutex_error(e)
    @error = e
  end
  
  def self.error_occurred?
    @error
  end
  
end
