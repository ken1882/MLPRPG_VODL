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
    attr_reader :hashid
  	#--------------------------------------------------------------------------
    # * Block Initialization
    #--------------------------------------------------------------------------
    def initialize(parent_hash, height, target, _genesis)
      @previous_blockhash = parent_hash
      @nonce = (rand() * 1000000000).to_i + height
      @difficulty = target
      @timestamp = Time.now
      @genesis = _genesis
      @merkle_roothash = PONY.MD5("friendship is magic").to_i(16)
    end
    #--------------------------------------------------------------------------
    # * Update invailed nonce
    #--------------------------------------------------------------------------
    def update_nonce
      @nonce = (rand() * 1000000000).to_i
      update_hash
    end
    #--------------------------------------------------------------------------
    # * Push Transaction
    #--------------------------------------------------------------------------
    def push_info(info)
      @merkle_roothash = PONY.MD5(@merkle_roothash.to_s + info).to_i(16)
      update_hash
    end
    #--------------------------------------------------------------------------
    # * Update hashid after nonce changed
    #--------------------------------------------------------------------------
    def update_hash
      base = @previous_blockhash ? 0 : @previous_blockhash
      base = @merkle_roothash + @nonce + @difficulty
      @hashid = PONY.Sha256(base.to_s).to_i(16)
    end
    def sign; push_info(PONY.Verify(@nonce, @difficulty)); end
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
    attr_reader :parent_hash
  	#--------------------------------------------------------------------------
    # * Block Initialization
    #--------------------------------------------------------------------------
    def initialize(parent, _height, difficulty, genesis = false)
      PONY::ERRNO.raise(:chain_broken, :exit) if !genesis && !parent
      @magic_num = rand() * (10 ** 9)
      @parent_hash = parent
      @height = _height
      @record = []
      @difficulty = difficulty
      @header = Block_Header.new(parent, @height, difficulty, genesis)
      @prev_transsum = 0
    end
    #--------------------------------------------------------------------------
    # * Block Mining
    #--------------------------------------------------------------------------
    def mining
      return unless @record.size > 0
      @header.update_nonce
      update_hash(true)
      succ = PONY.Mining(@header.nonce, @difficulty).to_bool
      @header.sign if succ
      update_hash  if succ
      return succ
    end
    #--------------------------------------------------------------------------
    # * Update hashid after nonce changed
    #-------------------------------------------------------------------------- 
    def update_hash(header_only = false)
      sum = @header.hashid
      sum += header_only ? @prev_transsum : 0
      if !header_only
        record.each {|trans| sum += trans.hashid}
        @prev_transsum = sum
      end
      @hashid = PONY.Sha256(sum).to_i(16)
    end
    #--------------------------------------------------------------------------
    # * Push Extra Transaction
    #--------------------------------------------------------------------------
    def push_transaction(trans)
      @record.push(trans)
      @header.push_info(trans.info)
      update_hash
    end
    #--------------------------------------------------------------------------
    # * Query account balance
    #--------------------------------------------------------------------------
    def account_balance(accid, currency_id)
      sum = 0
      record.each do |trans|
        next unless trans.type == currency_id
        sum += trans.value if accid.nil? || trans.recipient == accid
        sum -= trans.value if accid      && trans.source    == accid
      end
      return sum
    end
    #--------------------------------------------------------------------------
    # * Query item amount in player's saddlebag
    #--------------------------------------------------------------------------
    def item_amount(accid, item_hashid)
      sum = 0
      record.each do |trans|
        sum += 1 if trans.goods.hashid == item_hashid
      end
    end
    #--------------------------------------------------------------------------
    # * Block build time
    def date; @header.timestamp.to_i; end
    def nonce; @header.nonce; end
    def have_record?; !@record.empty?; end
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
      @id = PONY.MD5(name).to_i(16)
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
    attr_reader :corrupted
  	#--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(name, enable = false)
      @name = name
      @id   = PONY.MD5(name).to_i(16)
      @price_index = 1
      @enabled = enable
      @last_block = nil
      @corrupted = false
      @blocks  = {}
    end
    #--------------------------------------------------------------------------
    # * Update Block
    #--------------------------------------------------------------------------
    def update_block(block)
      @blocks[block.hashid] = block
    end
    #--------------------------------------------------------------------------
    # * Push New Block
    #--------------------------------------------------------------------------
    def new_workblock
      new_block = Block.new(@last_block.hashid, BlockChain.height, BlockChain.difficulty)
      puts "#{@last_block.hashid}"
      @last_block = new_block
      update_block(@last_block.clone)
      puts "#{@last_block.parent_hash}"
    end
    #--------------------------------------------------------------------------
    # * Prepare commit new work
    #--------------------------------------------------------------------------
    def commit_transaction(trans, difficulty, genesis = false)
      @last_block = Block.new(nil, 0, difficulty, genesis) if genesis && !@last_block
      self.push_block(@last_block.clone)                   if genesis && !@last_block
      @last_block.push_transaction(trans)
      update_block(@last_block.clone)
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
    # * Sync to succed mined block
    #--------------------------------------------------------------------------
    def sync(node) #tag: last work: fix bloks hashid missing
      return if node.id == self.id
      @last_block = node.last_block.dup
      @blocks     = node.blocks.dup
      @corrupted  = false
    end
    #--------------------------------------------------------------------------
    # * Verify nonce
    #--------------------------------------------------------------------------
    def verify_nonce(nonce)
      return PONY.Mining(nonce, @last_block.difficulty).to_bool
    end
    #--------------------------------------------------------------------------
    # * Query item amount in player's saddlebag
    #--------------------------------------------------------------------------
    def item_amount(accid, item_hashid)
      @blocks.each do |key, block|
        block.item_amount(accid, item_hashid)
      end
    end
    #--------------------------------------------------------------------------
    # * Query account or total balance
    #--------------------------------------------------------------------------
    def account_balance(accid, currency_id)
      sum = 0
      cur_key = @last_block.hashid
      while @blocks[cur_key]
        sum    += @blocks[cur_key].account_balance(accid, currency_id)
        cur_key = @blocks[cur_key].parent_hash
      end
      PONY::ERRNO.raise(:neg_balance, :exit) if sum < 0
      return sum
    end
    #--------------------------------------------------------------------------
    # * Push New Block
    #--------------------------------------------------------------------------
    def archive_lastblock
      return unless @last_block.have_record?
      new_workblock
    end
    #--------------------------------------------------------------------------
    # * Show History
    def show_history
      cur_key = @last_block.hashid
      @blocks.each {|key,bc| puts "#{key}"}
      puts ""
      while @blocks[cur_key]
        puts "key: #{cur_key}"
        recordcs = @blocks[cur_key].record
        cur_key = @blocks[cur_key].parent_hash
        records.each do |trans|
          puts "#{trans.info} #{trans.source.name} #{trans.recipient.name} #{trans.value}"
        end
        
      end
    end
    
    def drop_block; @corrupted = true; end
    def length; @corrupted ? -1 : (@blocks.size + @last_block.record.size); end
    #--------------------------------------------------------------------------
  end # PonyNode
end # Module:BlockChain
