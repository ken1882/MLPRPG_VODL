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
  @garbage  = {}
  @height   = 0
  #--------------------------------------------------------------------------
  # * Block Chain Initialize
  #--------------------------------------------------------------------------
  def self.init_chain
  	self.init_nodes
    self.init_item_garbage_collector
  end
  #--------------------------------------------------------------------------
  # * Block Chain Nodes Initialization
  #--------------------------------------------------------------------------
  def self.init_nodes
    areas = PONY::CHAIN::Nodes
    areas.size.times do |i|
      @nodes.push( PonyNode.new(areas[i], i <= 12) )
    end
    self.depoly_first_contract
  end
  #--------------------------------------------------------------------------
  # * Init garbage collector for items
  #--------------------------------------------------------------------------
  def self.init_item_garbage_collector
    item_pool = $data_items + $data_weapons + $data_armors
    item_pool.compact.each do |item|
      @garbage[item.hashid] = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Depoly first dispute
  #--------------------------------------------------------------------------
  def self.depoly_first_contract
    @nodes.each do |node|
      amount = PONY::CHAIN::Dispute_Weight[node.id] * PONY::CHAIN::TotalBalance
      trans = Game_Transaction.new(0, amount.to_i, "Hasbro", node.name, "Initial Dispute")
      self.push_transaction(trans, true)
    end
    self.mining(true)
  end
  # Block Height & difficulty target
  def self.height; return @height; end
  def self.target; return (PONY::CHAIN::Difficulty + (self.height / 42)); end
  def self.difficulty; return self.target; end
  #--------------------------------------------------------------------------
  # * Load BC information
  #--------------------------------------------------------------------------
  def self.load_chain_data(header)
    true
  end
  #--------------------------------------------------------------------------
  # * Save Chain
  #--------------------------------------------------------------------------
  def self.chain_nodes
    return @nodes
  end
  #--------------------------------------------------------------------------
  # * Push new transaction
  #--------------------------------------------------------------------------
  def self.push_transaction(trans, gensis = false)
    @nodes.each do |node|
      node.commit_transaction(trans, self.difficulty, gensis)
    end
  end
  #--------------------------------------------------------------------------
  # * Start process mining
  #--------------------------------------------------------------------------
  def self.mining(archive = false)
    winner = nil
    cnt = 0
    while !winner
      @nodes.each do |node|
        result = node.mining
        PONY::ERRNO.raise(:nil_block, :exit) if result == :nil_block
        winner = node.clone if result
      end
    end
    sum = self.account_balance
    puts "Total Sum: #{sum}"
    PONY::ERRNO.raise(:bits_incorrect, :exit) if sum != PONY::CHAIN::TotalBalance
    self.sync_node(winner) if self.nonce_legal?(winner)
    self.settlement if archive
  end
  #--------------------------------------------------------------------------
  # * Account
  #--------------------------------------------------------------------------
  def self.accounts(accname, reg = false)
    @accounts.each do |name, acc|
      return acc if accname == name
    end
    acc = PonyAccount.new(accname)
    @accounts[acc.id] = acc
    return reg ? acc : nil 
  end
  #--------------------------------------------------------------------------
  # * Query account or total balance
  #--------------------------------------------------------------------------
  def self.account_balance(accid = nil, currency_type = 0)
    accid = PONY.MD5(accid).to_i(16) if accid && accid.is_a?(String)
    result_pool = {}
    @nodes.compact.each do |node|
      result = node.account_balance(accid, currency_type)
      result_pool[result] = Array.new() unless result_pool[result].is_a?(Array)
      result_pool[result].push(node.clone)
    end
    self.determine_result(result_pool)
  end
  #--------------------------------------------------------------------------
  # * Query item amount in player's saddlebag
  #--------------------------------------------------------------------------
  def self.item_amount(accid = PONY::CHAIN::Nodes[1], item_hashid)
    accid = PONY.MD5(accid).to_i(16) if accid.is_a?(String)
    result_pool = {}
    @nodes.each do |node|
      n = node.item_amount(accid, item_hashid)
      result_pool[n] = Array.new() unless result_pool[result].is_a?(Array)
      result_pool[n].push(node.clone)
    end
    determine_result(result_pool)
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
    return re
  end
  #--------------------------------------------------------------------------
  # * Recover nodes
  #--------------------------------------------------------------------------
  def self.recover_nodes
    pool = {}
    @nodes.each do |node|
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
  # * Archive all current working block and start a new one
  #--------------------------------------------------------------------------
  def self.settlement
    self.recover_nodes
    @height += 1
    @nodes.each do |node|
      node.archive_lastblock
    end
  end
  #--------------------------------------------------------------------------
  # * Use consumable item
  def self.use_item(item, amount = 1); @garbage[item.hashid] += amount; end
  #--------------------------------------------------------------------------
  # * Show History
  def self.show_history
    self.recover_nodes
    @nodes[0].show_history
  end
  
end
