#==============================================================================
# ** BlockChain::Block
#------------------------------------------------------------------------------
#  The Block
#==============================================================================
$imported = {} if $imported.nil?
module BlockChain
  #==============================================================================
  # * Block Header
  #==============================================================================
  class Block_Header
  	#--------------------------------------------------------------------------
    # * Instance Vars
    #--------------------------------------------------------------------------
    attr_reader :previous_blockhash
    attr_reader :timestamp
    attr_reader :difficulty
    attr_reader :nonce
    attr_reader :merkle_roothash
    attr_reader :genesis
  	#--------------------------------------------------------------------------
    # * Block Initialization
    #--------------------------------------------------------------------------
    def initialize(parent_hash, _nonce, target, _genesis)
      @previous_blockhash = parent_hash
      @nonce = _nonce
      @difficulty = target
      @timestamp = Time.now
      @genesis = _genesis
      infos = ["friendship is magic"]
      hash_infos(infos)
    end
    #--------------------------------------------------------------------------
    # * Update invailed nonce
    #--------------------------------------------------------------------------
    def update_nonce
      @nonce = (rand() ** 1000000000).to_i
    end
    #--------------------------------------------------------------------------
    # * Hash Transaction Text
    #--------------------------------------------------------------------------
    def hash_infos(infos)
      infos[0] = PONY.MD5(infos[0])
      infos[0] = PONY.MD5(infos[0] + infos[1]) until dat.size == 1
      @merkle_roothash = dat.at(0).to_i(16)
    end
  end
  #==============================================================================
  # * Block Index
  #==============================================================================
  class Block
  	#--------------------------------------------------------------------------
    # * Instance Vars
    #--------------------------------------------------------------------------
    attr_reader :hashid
    attr_reader :header
    attr_reader :height
    attr_reader :record
    attr_reader :difficulty
  	#--------------------------------------------------------------------------
    # * Block Initialization
    #--------------------------------------------------------------------------
    def initialize(parent, _height, difficulty, genesis = false)
      @hash_id = PONY.Sha256(rand()).to_i(16)
      @transaction_info = info
      @height = _height
      @record = {}
      @difficulty = difficulty
      @header = Block_Header.new(nil, 0, difficulty, info, genesis)
    end
    #--------------------------------------------------------------------------
    # * Block Mining
    #--------------------------------------------------------------------------
    def mining
      return unless @record.size > 0
      PONY.Mining(header.nonce, @difficulty).to_bool
    end
    #--------------------------------------------------------------------------
    # * Push Extra Transaction
    #--------------------------------------------------------------------------
    def push_transaction(trans)
      @record[trans.hashid] = trans
    end
    #--------------------------------------------------------------------------
    # * Block build time
    def date; @header.timestamp.to_i; end
  end
  #==============================================================================
  # * Block Chain Accounts
  #==============================================================================
  class PonyAccount
  	#--------------------------------------------------------------------------
    # * Instance Vars
    #--------------------------------------------------------------------------
    attr_reader :name
    attr_reader :id
  	#--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(name)
      @name = name
      @id = PONY.Sha256(name).to_i(16)
    end
  end # Class:PonyAccount
  #==============================================================================
  # * Block Chain Nodes
  #==============================================================================
  class PonyNode
    #--------------------------------------------------------------------------
    # * Instance Vars
    #--------------------------------------------------------------------------
    attr_reader :name
    attr_reader :id
    attr_reader :blocks
    attr_reader :price_index
    attr_reader :last_block
    attr_reader :enabled
  	#--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(name, enable = false)
      @name = name
      @id   = PONY.MD5(name).to_i(16)
      @price_index = 1
      @enabled = enable
      @last_block = nil
      @blocks  = {}
    end
    #--------------------------------------------------------------------------
    # * Push New Block
    #--------------------------------------------------------------------------
    def push(block)
      @blocks[block.hashid] = block
    end
    #--------------------------------------------------------------------------
    # * Prepare commit new work
    #--------------------------------------------------------------------------
    def commit_transaction(trans, difficulty, genesis = false)
      @last_block = Block.new(nil, 0, difficulty, genesis) if genesis
      @last_block.push_transaction(trans)
    end
    #--------------------------------------------------------------------------
    # * Block Mining
    #--------------------------------------------------------------------------
    def mining
      return unless @enabled
      return :nil_blcok unless @last_block
      @last_block.mining
    end
    #--------------------------------------------------------------------------
    # * verify all balance whether equal to total balance
    #--------------------------------------------------------------------------
    def verify_balance
      sum = 0
      # balala
      return sum == PONY::CHAIN::TotalBalance
    end
    #--------------------------------------------------------------------------
  end # PonyNode
end # Module:BlockChain
