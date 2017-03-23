module Graphics
  
  class << self; alias transition_dnd transition; end
  def self.transition(duration = 10, filename = "", vague = 40)
    puts SPLIT_LINE
    puts "[Debug] Map Transition"
    BlockChain.mining
    transition_dnd(duration, filename, vague)
  end
  
end
