#==============================================================================
# ** BlockChain::Block
#------------------------------------------------------------------------------
#  The Block
#==============================================================================
$imported = {} if $imported.nil?
module BlockChain
  
  class Block_Header
  	#--------------------------------------------------------------------------
    # * Instance Vars
    #--------------------------------------------------------------------------
    attr_reader :previous_blockhash
    attr_reader :timestamp
    attr_reader :difficulty
    attr_reader :nonce
    attr_reader :merkle_roothash
  	#--------------------------------------------------------------------------
    # * Block Initialization
    #--------------------------------------------------------------------------
    def initialize(parent_hash, _nonce, target, infos)
      @previous_blockhash = parent_hash
      @nonce = _nonce
      @difficulty = target
      @timestamp = Time.now
      hash_infos(infos)
    end
    #--------------------------------------------------------------------------
    # * Hash Transaction Text
    #--------------------------------------------------------------------------
    def hash_infos(infos)
      dat = infos.split(' ')
      dat[0] = hash_string(dat[0])
      while dat.size > 1
        dat[0] = hash_string(dat[0] + dat[1])
      end
      @merkle_roothash = dat.at(0)
    end
    #--------------------------------------------------------------------------
    # * Hash String
    #--------------------------------------------------------------------------
    def hash_string(text)
      return BlockChain::Sha256.call(text)
    end
  end
  
  
end
