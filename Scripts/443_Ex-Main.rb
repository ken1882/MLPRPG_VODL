# tag: test
TEST = 0
if TEST == 1
module SceneManager
  #--------------------------------------------------------------------------
  # * Get First Scene Class
  #--------------------------------------------------------------------------
  def self.first_scene_class
    focus_game_window
    Scene_Test
  end
end
end
#==============================================================================
# *) New global class
#==============================================================================
$rgss   = self
$assist = RubyVM::InstructionSequence.compile("$thassist=Thread.new{Thread_Assist.assist_main}.run")
$mutex  = Mutex.new
def say(str)
  puts ("Global: #{str}")
end
class Per
  def initialize(str = "Hi")
    @str = str
    say
  end
  
  def say
    puts "#{@str}"
    Kernel.send(:say, @str)
  end
  
end
$per = Per.new
