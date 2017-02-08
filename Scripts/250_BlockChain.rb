#==============================================================================
# ** BlockChain
#------------------------------------------------------------------------------
#  Block Chain module for process transactions, ultra secure!
#==============================================================================
$imported = {} if $imported.nil?
module BlockChain
  #--------------------------------------------------------------------------
  # * DLLs
  #--------------------------------------------------------------------------
  Sha256 = Win32API.new("lib/Sha256.dll","Sha256",'p','p')
  MD5    = Win32API.new("lib/MD5.dll", "MDA5",'p','p')
  Mining = Win32API.new("lib/POW.dll","Mine_Block",['L','L'],'L')
  Verify = Win32API.new("lib/POW.dll","Verify_Result",['L','L'],'p')
  #--------------------------------------------------------------------------
  # * Instance vars
  #--------------------------------------------------------------------------
  @nodes  = []
  #--------------------------------------------------------------------------
  # * Block Chain Initialize
  #--------------------------------------------------------------------------
  def self.init_chain(slot)
  	self.init_nodes
    self.load_chain_data(slot)
  end
  
  def self.init_nodes
    cities = PONY::Nodes
    cnt = 0
    cities.each do |name|
      @nodes.push( PonyNode.new(name, cnt <= 12) )
      cnt += 1
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Create genesis block
  #--------------------------------------------------------------------------
  def self.create_genesis_block
  	zerohash = Sha256.call(0)
  	@blcoks.push(Block.new(zerohash, nil, 0, $POW_target, account_record, info, genesis = false))
  end
  #--------------------------------------------------------------------------
  # * Load BC information
  #--------------------------------------------------------------------------
  def load_chain_data(slot)
    DataManager.ensure_file_exist("Save/Chain/")
    
  end
  #--------------------------------------------------------------------------
  # * Push new transaction
  #--------------------------------------------------------------------------
  def push_transaction
  end
  
end
