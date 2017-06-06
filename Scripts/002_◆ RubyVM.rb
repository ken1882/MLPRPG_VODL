
class RubyVM::InstructionSequence
  
  alias init_yarv initialize
  def initialize(*args)
    msgbox caller
    init_yarv
  end
  
end
