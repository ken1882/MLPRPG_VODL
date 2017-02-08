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
    def initialize(parent_hash, _nonce, target, infos, _genesis)
      @previous_blockhash = parent_hash
      @nonce = _nonce
      @difficulty = target
      @timestamp = Time.now
      @genesis = _genesis
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
    attr_reader :records
  	#--------------------------------------------------------------------------
    # * Block Initialization
    #--------------------------------------------------------------------------
    def initialize(hashid, parent, _height, difficulty, record_manager, genesis = false)
      @transaction_info = info
      @height = _height
      @record = record_manager
      @header = Block_Header.new(nil, 0, difficulty, info, genesis)
    end
  end
  #==============================================================================
  # * Transaction Receipt
  #==============================================================================
  class PonyReceipt
  	#--------------------------------------------------------------------------
    # * Instance Vars
    #--------------------------------------------------------------------------
    attr_reader :hashid
    attr_reader :currency_type
    attr_reader :value
    attr_reader :source
    attr_reader :recipient
    attr_reader :transaction_info
    #--------------------------------------------------------------------------
    # * Initialization
    #--------------------------------------------------------------------------
    def initialize(id, type, amount, from, to, info)
      @hashid = id
      @currency_type = type
      @value = amount
      @source = from
      @recipient = to
      @transaction_info = info
    end
  end
  #==============================================================================
  # * Receipt collect pool
  #==============================================================================
  class PonyRecordManager
  	#--------------------------------------------------------------------------
    # * Instance Vars
    #--------------------------------------------------------------------------
    attr_reader :account
    attr_reader :history
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      @account = {}
      @history = {}
    end
    #--------------------------------------------------------------------------
    # * Return recipt hashid
    #--------------------------------------------------------------------------
    def [](id)
      @history[id]
    end
    #--------------------------------------------------------------------------
    # * Iterator
    #--------------------------------------------------------------------------
    def each
      @history.compact.each {|receipt| yield receipt } if block_given?
    end
  end
  #==============================================================================
  # * Block Chain Accounts
  #==============================================================================
  class PonyAccount
  	#--------------------------------------------------------------------------
    # * Instance Vars
    #--------------------------------------------------------------------------
    attr_reader :id
    attr_reader :balance
  	#--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(_id, _balance)
      @id = _id
      @balance = _balance
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
    attr_reader :enabled
  	#--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(name, enable = false)
      @name = name
      @id   = PONY::MD5(name).to_i(16)
      @enabled = enable
      @blocks  = {}
    end
    #--------------------------------------------------------------------------
    # * Push New Block
    #--------------------------------------------------------------------------
    def push(block)
      return unless @enabled
      @blocks.unshift(block)
    end
    
  end
  
end # Module:BlockChain
