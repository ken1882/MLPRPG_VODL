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
      update_hash
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
    attr_reader :prev_transsum
    attr_reader :magic_num
    attr_reader :value
  	#--------------------------------------------------------------------------
    # * Block Initialization
    #--------------------------------------------------------------------------
    def initialize(parent, _height, difficulty, genesis = false)
      @magic_num = rand() * (10 ** 9)
      @parent_hash = parent
      @height = _height
      @record = []
      @difficulty = difficulty
      @header = Block_Header.new(parent, @height, difficulty, genesis)
      @prev_transsum = 0
      @value = 0
      update_hash
      verify_genesis
    end
    #--------------------------------------------------------------------------
    def verify_genesis
      if genesis? && @parent_hash
        info = "Child genesis block"
        PONY::ERRNO.raise(:chain_broken, :exit, nil, info)
      elsif !genesis? && !@parent_hash
        info = "Chain broken"
        PONY::ERRNO.raise(:chain_broken, :exit, nil, info)
      end
    end
    #--------------------------------------------------------------------------
    # * Block Mining
    #--------------------------------------------------------------------------
    def mining
      return :no_record unless @record.size > 0
      @header.update_nonce
      update_hash(true)
      succ = PONY.Mining(nonce, @difficulty).to_bool
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
      @value += trans.value
      BlockChain.record_transaction(trans)
      update_hash
    end
    #--------------------------------------------------------------------------
    # * Query account balance
    #--------------------------------------------------------------------------
    def account_balance(accid, currency_id, async)
      sum = 0
      record.each do |trans|
        next unless trans.type == currency_id
        sleep(Thread_Assist::Uwait) if async
        sum += trans.value if trans.recipient == accid
        sum -= trans.value if trans.source    == accid
      end
      return sum
    end
    #--------------------------------------------------------------------------
    # * Query item amount in player's saddlebag
    #--------------------------------------------------------------------------
    def item_amount(accid, item_hashid, async)
      sum = 0
      record.each do |trans|
        next unless trans.goods && trans.goods.hashid == item_hashid
        sleep(Thread_Assist::Uwait) if async
        # recipient is the one who receive the money, sell the good, so good
        # amount is decreased, and vice versa
        sum -= trans.good_amount if trans.recipient == accid
        sum += trans.good_amount if trans.source    == accid
      end
      return sum
    end
    #--------------------------------------------------------------------------
    def all_items(items, accid, async)
      record.each do |trans|
        next unless trans.goods
        sleep(Thread_Assist::Uwait) if async
        item     = trans.goods
        itemname = trans.goods.name rescue nil
        type = :item   if item.is_a?(RPG::Item)
        type = :weapon if item.is_a?(RPG::Weapon)
        type = :armor  if item.is_a?(RPG::Armor)
        if !type
          info = "Invalid item transaction: #{itemname} for #{item.class}"
          PONY::ERRNO.raise(:datatype_error, :exit, nil, info)
        end
        items[type][item.hashid] -= trans.good_amount if trans.recipient == accid
        items[type][item.hashid] += trans.good_amount if trans.source    == accid
      end
      return items
    end
    #--------------------------------------------------------------------------
    def all_data(data, accid, async)
      record.each do |trans|
        sleep(Thread_Assist::Uwait) if async
        item     = trans.goods
        itemname = trans.goods.name rescue nil
        type = :item   if item.is_a?(RPG::Item)
        type = :weapon if item.is_a?(RPG::Weapon)
        type = :armor  if item.is_a?(RPG::Armor)
        if !type
          info = "Invalid item transaction: #{itemname} for #{item.class}"
          PONY::ERRNO.raise(:datatype_error, :exit, nil, info)
        end
        data[:gold] += trans.value if trans.recipient == accid
        data[:gold] -= trans.value if trans.source    == accid
        data[type][item.hashid] -= trans.good_amount if trans.recipient == accid
        data[type][item.hashid] += trans.good_amount if trans.source    == accid
      end
      return data
    end
    #--------------------------------------------------------------------------
    # * Merge transaction
    #--------------------------------------------------------------------------
    def merge_transaction(trans)
      succ = false
      @record.each do |oldtrans|
        succ = !oldtrans.merge(trans).nil?
        break if succ
      end
      PONY::ERRNO.raise(:checksum_failed, :exit) if succ == :checksum_failed
      return succ
    end
    #--------------------------------------------------------------------------
    # * Sync data
    #--------------------------------------------------------------------------
    def sync_data(block)
      @difficulty    = block.difficulty
      @parent_hash   = block.parent_hash
      @prev_transsum = block.prev_transsum
      @height        = block.height
      @magic_num     = block.magic_num
      @header        = block.header.dup
      @value         = block.value
      sync_record(block.record)
      update_hash
    end
    
    def sync_record(record)
      @record.clear
      n = record.size
      for i in 0...n do 
        record[i].dup_currency
        @record.push(record[i].dup) 
      end
    end
    #--------------------------------------------------------------------------
    # * Block build time
    def date; @header.timestamp.to_i; end
    #--------------------------------------------------------------------------
    def genesis?; @header.genesis; end
    #--------------------------------------------------------------------------
    # * Nonce
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
    attr_reader :balance
    attr_reader :item_amount
  	#--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(name, balance = 0)
      @name = name
      @id = PONY.MD5(name).to_i(16)
      @balance = balance
      @item_amount = {}
    end
    #--------------------------------------------------------------------------
    # * Redefine equal
    #--------------------------------------------------------------------------
    def ==(obj)
      return obj == @name if obj.is_a?(String)
      return obj == @id   unless obj.is_a?(String)
    end
    #--------------------------------------------------------------------------
    # * Redefine equal
    #--------------------------------------------------------------------------
    def merge_block(block)
      block.record.each do |trans|
        @balance -= trans.value if trans.source.id    == @id
        @balance += trans.value if trans.recipient.id == @id
        next unless trans.goods
        good_hash = trans.goods.hashid
        @item_amount[good_hash] = 0 if @item_amount[good_hash].nil?
        @item_amount[good_hash] += trans.good_amount if trans.source.id    == @id
        @item_amount[good_hash] -= trans.good_amount if trans.recipient.id == @id
      end
    end
    
    def account_balance; return @balance; end
    def item_amount(hashid); return @item_amount[hashid] || 0; end
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
    attr_reader :capacity
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
      @capacity = 0
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
      @blocks[@last_block.hashid].freeze
      @last_block = new_block
      update_block(@last_block)
    end
    #--------------------------------------------------------------------------
    # * Prepare commit new work
    #--------------------------------------------------------------------------
    def commit_transaction(trans, difficulty, genesis = false)
      @last_block = Block.new(nil, 0, difficulty, genesis) if genesis && !@last_block
      self.push_block(@last_block)                         if genesis && !@last_block
      # Delete last block because the hashid will change later
      @blocks.delete(@last_block.hashid) 
      @last_block.push_transaction(trans)
      update_block(@last_block)
      @capacity += 1
    end
    #--------------------------------------------------------------------------
    # * Block Mining
    #--------------------------------------------------------------------------
    def mining
      return unless @enabled
      return :nil_blcok unless @last_block
      @blocks.delete(@last_block.hashid)
      re = @last_block.mining
      update_block(@last_block.clone)
      return re
    end
    #--------------------------------------------------------------------------
    # * Mining Reward
    #--------------------------------------------------------------------------
    def reward
      value = (@last_block.value * PONY::CHAIN::Transaction_Fee)
      value = (@last_block.record.size * PONY::CHAIN::Transaction_Fee) if value == 0
      value
    end
    #--------------------------------------------------------------------------
    # * Sync to succed mined block
    #--------------------------------------------------------------------------
    def sync(node)
      return if node.id == self.id
      @last_block.sync_data(node.last_block.dup)
      @capacity = node.capacity
      @blocks.clear
      node.blocks.each do |hashid, block|
        bc = Block.new(@last_block.hashid, BlockChain.height, BlockChain.difficulty)
        bc.sync_data(block.dup)
        @blocks[bc.hashid] = bc.clone
      end
      
      @corrupted  = false
    end
    #--------------------------------------------------------------------------
    # * Verify nonce
    #--------------------------------------------------------------------------
    def verify_nonce(nonce)
      return (PONY.Mining(nonce, @last_block.difficulty).to_bool & trans_legal?)
    end
    #--------------------------------------------------------------------------
    # * Query item amount in player's saddlebag
    #--------------------------------------------------------------------------
    def item_amount(accid, item_hashid, async)
      sum = 0
      cur_key = @last_block.hashid
      while @blocks[cur_key]
        @blocks[cur_key].verify_genesis
        sleep(Thread_Assist::Uwait) if async
        sum    += @blocks[cur_key].item_amount(accid, item_hashid, async)
        cur_key = @blocks[cur_key].parent_hash
      end
      return sum
    end
    #--------------------------------------------------------------------------
    def all_items(accid, async)
      items = {}
      items[:item]   = {}
      items[:weapon] = {}
      items[:armor]  = {}
      cur_key = @last_block.hashid
      while @blocks[cur_key]
        @blocks[cur_key].verify_genesis
        sleep(Thread_Assist::Uwait) if async
        items = @blocks[cur_key].all_items(items, accid, async)
        cur_key = @blocks[cur_key].parent_hash
      end
      ensure_goods_legal(items)
      return items
    end
    #--------------------------------------------------------------------------
    def all_data(accid, async)
      data = {}
      data[:gold]   = 0
      data[:item]   = {}
      data[:weapon] = {}
      data[:armor]  = {}
      cur_key = @last_block.hashid
      while @blocks[cur_key]
        @blocks[cur_key].verify_genesis
        sleep(Thread_Assist::Uwait) if async
        data = @blocks[cur_key].all_data(data, accid, async)
        cur_key = @blocks[cur_key].parent_hash
      end
      return data
    end
    #--------------------------------------------------------------------------
    # * Query account or total balance
    #--------------------------------------------------------------------------
    def account_balance(accid, currency_id, async)
      sum = 0
      cur_key = @last_block.hashid
      while @blocks[cur_key]
        @blocks[cur_key].verify_genesis
        sleep(Thread_Assist::Uwait) if async
        sum    += @blocks[cur_key].account_balance(accid, currency_id, async)
        cur_key = @blocks[cur_key].parent_hash
      end
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
    #--------------------------------------------------------------------------
    def show_history
      cur_key = @last_block.hashid
      while @blocks[cur_key] && cur_key
        puts "key: #{cur_key}"
        records = @blocks[cur_key].record
        cur_key = @blocks[cur_key].parent_hash
        records.reverse.each do |trans|
          next if trans.info.size < 1
          puts SPLIT_LINE
          puts "Info: #{trans.info} | from: #{trans.source.name} | to: #{trans.recipient.name}"
          puts "Bits Amount: #{trans.value}"
          puts "Item: #{trans.goods.name} x#{trans.good_amount}" if trans.goods
        end
      end
      puts SPLIT_LINE
    end
    #--------------------------------------------------------------------------
    # * Maintain Query Speed is under control
    #--------------------------------------------------------------------------
    def maintain
      return unless overload?
      outdated = @last_block
      @blocks.each do |hashid, block|
        outdated = block.clone if !block.genesis && block.date < outdated.date
      end
      @blocks.delete(outdated)
      @capacity -= outdated.record.size
      return outdated
    end
    
    # Verify if all transactions is still legal
    def trans_legal?
      cur_key = @last_block.hashid
      while @blocks[cur_key] && cur_key
        records = @blocks[cur_key].record
        cur_key = @blocks[cur_key].parent_hash
        return false if records.any? {|trans| !trans.trans_legal?}
      end
      return true
    end
    
    # Recover nodes to previous state
    def recover
      cur_key = @last_block.hashid
      while @blocks[cur_key] && cur_key
        records = @blocks[cur_key].record
        cur_key = @blocks[cur_key].parent_hash
        records.each {|i| i.recover}
      end
    end
    
    def overload?; @capacity > 3000; end
    def drop_block; @corrupted = true; end
    def length; @corrupted ? -1 : (@blocks.size + @last_block.record.size); end
    #--------------------------------------------------------------------------
  end # PonyNode
end # Module:BlockChain
