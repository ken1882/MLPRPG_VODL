#==============================================================================
# ** BlockChain
#------------------------------------------------------------------------------
#  Block Chain module for process transactions, ultra secure!
#==============================================================================
$imported = {} if $imported.nil?
module BlockChain
  #--------------------------------------------------------------------------
  # * Instance vars
  #--------------------------------------------------------------------------
  @nodes    = []
  @accounts = {}
  @trans_megadata  = []
  @height   = 0
  @capacity = 0
  @checksum = 0x0
  @locked   = false
  #--------------------------------------------------------------------------
  # * Block Chain Initialize
  #--------------------------------------------------------------------------
  def self.init_chain
  	self.init_nodes if node_empty?
    self.depoly_first_contract
  end
  #--------------------------------------------------------------------------
  def self.clear
    @nodes    = []
    @accounts = {}
    @trans_megadata  = []
    @height   = 0
    @capacity = 0
    @checksum = 0x0
  end
  #--------------------------------------------------------------------------
  # * Block Chain Nodes Initialization
  #--------------------------------------------------------------------------
  def self.init_nodes
    areas = PONY::CHAIN::Nodes
    areas.size.times do |i|
      @nodes.push( PonyNode.new(areas[i], true) )
    end
  end
  #--------------------------------------------------------------------------
  # * Depoly first dispute
  #--------------------------------------------------------------------------
  def self.depoly_first_contract
    acc = PonyAccount.new("Hasbro", PONY::CHAIN::TotalBalance)
    @accounts["Hasbro"] = acc
    @nodes.each do |node|
      amount = PONY::CHAIN::Dispute_Weight[node.id] * PONY::CHAIN::TotalBalance
      trans = Game_Transaction.new(0, amount.to_i, "Hasbro", node.name, nil, nil, "Initial Dispute")
      self.push_transaction(trans, true)
    end
  end
  # Block Height & difficulty target
  def self.height; return @height; end
  def self.target; return (PONY::CHAIN::Difficulty + (self.height / 42)); end
  def self.difficulty; return self.target; end
  #--------------------------------------------------------------------------
  # * Load BC information
  #--------------------------------------------------------------------------
  def self.load_chain_data(contents)
    @nodes    = contents[:nodes]
    @accounts = contents[:accounts]
    @trans_megadata  = contents[:megadata]
    @height   = contents[:height]
    @capacity = contents[:capacity]
    @checksum = contents[:checksum]
    self.recover_nodes
    return true
  end
  #--------------------------------------------------------------------------
  # * Save Chain
  #--------------------------------------------------------------------------
  def self.item_for_save(filename)
    contents = {}
    contents[:nodes]    = @nodes
    contents[:accounts] = @accounts
    contents[:megadata]  = @trans_megadata
    contents[:height]   = @height
    contents[:capacity] = @capacity
    contents[:player_balance] = self.account_balance(Vocab::Player)
    return contents
  end
  #--------------------------------------------------------------------------
  # * Load Header
  #--------------------------------------------------------------------------
  def self.load_file_header(filename)
    File.open(filename, 'rb') do |file|
      return Marshal.load(file)
    end
  end
  #--------------------------------------------------------------------------
  # * Push new transaction
  #--------------------------------------------------------------------------
  def self.push_transaction(trans, gensis = false)
    @capacity += 1
    @nodes.each do |node|
      node.commit_transaction(trans, self.difficulty, gensis)
    end
    self.mining if @capacity >= 100
  end
  #--------------------------------------------------------------------------
  # * Start process mining
  #--------------------------------------------------------------------------
  def self.mining(async = false)
    puts "[BlockChain]: Start Mining, lock: #{@locked}, caller: #{[caller[0], caller[1]]}"
    return if node_empty? || @locked
    begin
      @locked = true unless async
      winner  = nil
      Thread_Assist.yield if !async && Thread_Assist.work?(:BCmine)
      while !winner
        no_record_cnt = 0
        @nodes.each do |node|
          if async
            t = Thread_Assist.pause? ? 1 : Thread_Assist::Uwait
            sleep(t)
          end
          SceneManager.update_loading
          result = node.mining
          no_record_cnt += 1                   if result == :no_record
          PONY::ERRNO.raise(:nil_block, :exit) if result == :nil_block
          winner = node.clone                  if result == true
        end
        
        if no_record_cnt > @nodes.size / 2
          puts "[BlockChain]: No transaction to mine" 
        elsif winner
          puts "[BlockChain]: #{winner.name} has mined the block"
        end
        
        return if no_record_cnt > @nodes.size / 2
      end
      puts "[BlockChain]: Block Mined"
      self.settlement(winner) if self.nonce_legal?(winner)
    ensure
      @locked = false
    end
  end
  #--------------------------------------------------------------------------
  # * Archive all current working block and start a new one
  #--------------------------------------------------------------------------
  def self.settlement(winner)
    puts '[BlockChain]: Settle currnet blocks'
    self.dispute_player_reward(winner) if winner.name == Vocab::Player
    self.sync_node(winner)
    @height += 1
    @nodes.each do |node|
      node.archive_lastblock
    end
    self.maintain
    @capacity = 0
  end
  #--------------------------------------------------------------------------
  def self.dispute_player_reward(winner)
    amount = winner.reward
    return if amount > 0x8000
    $game_party.mining_reward(amount)
    info = sprintf(Vocab::Party::BCGain, amount)
    SceneManager.display_info(info)
    puts "Player has mined reward: #{amount}"
  end
  #--------------------------------------------------------------------------
  # * Account
  #--------------------------------------------------------------------------
  def self.accounts(accname, reg = false)
    @accounts.each do |name, acc|
      return acc if accname == name || accname == acc.id
    end
    return unless accname.is_a?(String)
    acc = PonyAccount.new(accname)
    @accounts[acc.id] = acc
    return reg ? acc : nil 
  end
  #--------------------------------------------------------------------------
  # * Query account or total balance
  #--------------------------------------------------------------------------
  def self.account_balance(accid = nil, currency_type = 0, async = false)
    accid = PONY.MD5(accid).to_i(16) if accid && accid.is_a?(String)
    result_pool = {}
    candidates = [accid]
    if accid.nil? # Return total balance if nil id given
      @accounts.each do |accname, acc|
        candidates.push(acc.id)
      end
    end
    $mutex.synchronize{
    @nodes.compact.each do |node|
      result = 0
      candidates.compact.each do |accid|
        result += node.account_balance(accid, currency_type, async)
        result += self.accounts(accid).balance
      end
      if result < 0
        info = "Negative account balance for #{accounts(accid).name}"
        PONY::ERRNO.raise(:illegel_value, :exit, nil, info)
      end
      result_pool[result] = Array.new() unless result_pool[result].is_a?(Array)
      result_pool[result].push(node.clone)
    end
    } # mutex
    self.determine_result(result_pool)
  end
  #--------------------------------------------------------------------------
  # * Query specified item amount
  #--------------------------------------------------------------------------
  def self.item_amount(accid, item, async = false)
    accid = PONY.MD5(accid).to_i(16) if accid.is_a?(String)
    result_pool = {}
    $mutex.synchronize{
    @nodes.each do |node|
      result = node.item_amount(accid, item.hashid, async) + self.accounts(accid).item_amount(item.hashid)
      if result < 0
        info = "Negative item amount for #{item.name}(#{accounts(accid).name})"
        PONY::ERRNO.raise(:illegel_value, :exit, nil, info)
      end
      result_pool[result] = Array.new() unless result_pool[result].is_a?(Array)
      result_pool[result].push(node.clone)
    end
    } # $mutex
    return determine_result(result_pool) || 0
  end
  #--------------------------------------------------------------------------
  # * Query all item amount
  #--------------------------------------------------------------------------
  def self.all_items(accid, async = false)
    self.recover_nodes
    accid = PONY.MD5(accid).to_i(16) if accid.is_a?(String)
    items = nil
    $mutex.synchronize{
    items = @nodes[0].all_items(accid, async)
    [:item, :weapon, :armor].each do |type|
      items[type].each {|id, amount|
        items[type][id] += self.accounts(accid).item_amount(id)
      }
    end
    } # mutex
    return items
  end
  #--------------------------------------------------------------------------
  # * Query all data
  #--------------------------------------------------------------------------
  def self.all_data(accid, async = false)
    return if node_empty?
    self.recover_nodes
    accid = PONY.MD5(accid).to_i(16) if accid.is_a?(String)
    data  = nil
    data  = @nodes[0].all_data(accid, async)
    data[:gold] += self.accounts(accid).balance
    [:item, :weapon, :armor].each do |type|
      data[type].each {|id, amount|
        data[type][id] += self.accounts(accid).item_amount(id)
        item = PONY.hashid_table[id]
        if data[type][id] < 0
          info = "Negative item amount for #{item.name}(#{accounts(accid).name})"
          PONY::ERRNO.raise(:illegel_value, :exit, nil, info)
        end
      }
    end
    return data
  end
  #--------------------------------------------------------------------------
  # * Determind return value & sync
  #--------------------------------------------------------------------------
  def self.determine_result(pool)
    pool[0]  = Array.new() unless pool[0].is_a?(Array)
    superior = 0
    pool.each do |amount, node|
      superior = amount if pool[amount].size > pool[superior].size
    end
    winner = pool[superior].at(0)
    pool[superior].each do |node|
      winner = node if node.length > winner.length
    end
    self.sync_node(winner)
    return superior
  end
  #--------------------------------------------------------------------------
  # * Verify nonce correct b4 sync
  #--------------------------------------------------------------------------
  def self.nonce_legal?(master_node)
    err = 0
    nonce = master_node.last_block.nonce
    @nodes.each do |node|
      err += 1 unless node.verify_nonce(nonce)
    end
    re = err < (@nodes.size / 2)
    master_node.drop_block unless re
    self.recover_nodes     unless re
    puts "[BlockChain]: Nonce Legal: #{re}"
    return re
  end
  #--------------------------------------------------------------------------
  # * Recover nodes
  #--------------------------------------------------------------------------
  def self.recover_nodes
    pool = {}
    @nodes.each do |node|
      node.recover if !node.trans_legal?
      pool[node.length] = Array.new() unless pool[node.length].is_a?(Array)
      pool[node.length].push(node)
    end
    winner = []
    pool.each do |key, ar|
      winner = pool[key] if pool[key].size > winner.size
    end
    self.sync_node(winner.at(0))
  end
  #--------------------------------------------------------------------------
  # * All nodes sync to mater node
  #--------------------------------------------------------------------------
  def self.sync_node(master_node)
    @nodes.each {|node| node.sync(master_node)}
  end
  #--------------------------------------------------------------------------
  # * Show History
  def self.show_history
    self.recover_nodes
    @nodes[0].show_history
  end
  #--------------------------------------------------------------------------
  # * Maintain blocks size is in limit
  #--------------------------------------------------------------------------
  def self.maintain
    self.recover_nodes
    outdated = @nodes[0].maintain
    return if outdated.nil?
    puts "[BlockChain]: Merge outdated block: #{outdated.hashid}"
    self.merge_block(outdated)
    self.sync_node(@nodes[0])
  end
  #--------------------------------------------------------------------------
  # * Merge block info to account, ensure calc speed is acceptable
  #--------------------------------------------------------------------------
  def self.merge_block(block)
    @accounts.each{|accid, acc| acc.merge_block(block)}
  end
  #--------------------------------------------------------------------------
  # * Node loaded?
  def self.node_empty?; return @nodes.empty?; end
  #--------------------------------------------------------------------------
  # * Make A Bits only transaction
  #--------------------------------------------------------------------------
  def self.bits_transaction(amount, source, receiver, info = '')
    trans = Game_Transaction.new(0, amount.to_i, source, receiver, nil, nil, info)
    self.push_transaction(trans)
  end
  #--------------------------------------------------------------------------
  # * Make A Item only transaction
  #--------------------------------------------------------------------------
  def self.item_transaction(item,amount, source, receiver, info = '')
    trans = Game_Transaction.new(0, 0, source, receiver, item, amount, info)
    self.push_transaction(trans)
  end
  #--------------------------------------------------------------------------
  # * Make Standard Trade
  #--------------------------------------------------------------------------
  def self.new_transaction(amount, item, item_amount, source, receiver, info = '')
    trans = Game_Transaction.new(0, amount.to_i, source, receiver, item, item_amount, info)
    self.push_transaction(trans)
  end
  #--------------------------------------------------------------------------
  # * Record transaction detail
  #--------------------------------------------------------------------------
  def self.record_transaction(trans)
    @trans_megadata.push(trans)
  end
  # Nodes in Chain
  def self.chain_nodes; return @nodes; end
  def self.locked?; return @locked; end
end
