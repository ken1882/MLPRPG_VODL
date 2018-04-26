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
