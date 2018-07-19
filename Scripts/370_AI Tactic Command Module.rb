
module TacticCommandModule
  
  @template = {}
  
  Index = {
    :basic => [
      # category    #condition        # args    # action          # args
      [:targeting, :nearest_visible,  [true],      :set_target,      [nil] ],
      [:fighting,  :any,              [true],      :attack_mainhoof, [nil] ],
    ]
  }
  
  def self.load_template(symbol, battler)
    commands = @template[symbol].collect{|command| command.dup}
    commands.each do |command|
      command.battler     = battler
      command.action.user = battler
    end
    return commands
  end
  
  def self.compile_modules
    Index.each do |key, commands|
      result = []
      commands.each do |command|
        cmd = Game_TacticCommand.new(nil, command[2])
        cmd.category         = command[0]
        cmd.condition_symbol = command[1]
        cmd.action = Game_Action.new(nil, nil, command[3])
        result.push(cmd)
      end
      @template[key] = result
    end
  end
  
  compile_modules
end
