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
  #--------------------------------------------------------------------------
  # * Block Chain Initialize
  #--------------------------------------------------------------------------
  def self.init_chain
  	self.init_nodes
    self.init_balances
  end
  #--------------------------------------------------------------------------
  # * Block Chain Nodes Initialization
  #--------------------------------------------------------------------------
  def self.init_nodes
    areas = PONY::Nodes
    areas.size.times do |i|
      @nodes.push( PonyNode.new(areas[i], i <= 12) )
    end
  end
  #--------------------------------------------------------------------------
  # * Block Chain Nodes Balance Initialization
  #--------------------------------------------------------------------------
  def self.init_nodes
    @nodes.each do |node|
      amount = PONY::CHAIN::Dispute_Weight[node.id] * PONY::CHAIN::TotalBalance
      trans = Game_Transaction.new(0, amount, "Hasbro", node.name, "Initial Dispute")
      self.create_genesis_block(trans, true)
    end
  end
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
    trans = transaccount(trans)
    @nodes.each do |node|
      node.commit_transaction(trans, PONY::CHAIN::Difficulty, gensis)
    end
  end
  #--------------------------------------------------------------------------
  # * Change trader's name from String to PonyAccount
  #--------------------------------------------------------------------------
  def self.transaccount(trans)
    source_available = false
    recipient_available = false
    @accounts.each do |name, acc|
      if trans.source == name
        source_available = true
        trans.transaccount(true, acc)
      elsif trans.recipient == name
        recipient_available = true
        trans.transaccount(false, acc)
      end
    end
    trans.transaccount(true, PonyAccount.new(trans.source))     unless source_available
    trans.transaccount(false, PonyAccount.new(trans.recipient)) unless recipient_available
    return trans
  end
  #--------------------------------------------------------------------------
  # * Start process mining
  #--------------------------------------------------------------------------
  def self.mining
    @nodes.each do |node|
      @node.mining
    end
  end
  
  def self.test
    nonce = (rand() * (10 ** 9)).to_i
    Boolean(PONY.Mining(nonce, PONY::CHAIN::Difficulty))
  end
  
end
