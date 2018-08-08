#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles system data. It saves the disable state of saving and 
# menus. Instances of this class are referenced by $game_system.
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :skillbar
  attr_accessor :autotarget, :autotarget_aoe
  attr_accessor :loading_pressure
  attr_accessor :time_stopper, :timestop_duration
  attr_reader   :game_mode
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_system_opt initialize
  def initialize
    @skillbar       = nil
    @autotarget     = true
    @autotarget_aoe = true
    @time_stopper   = nil
    @game_mode      = :main
    @loading_pressure = 0
    @timestop_duration = 0
    initialize_system_opt
  end  
  #--------------------------------------------------------------------------
  # * show roll result?
  #--------------------------------------------------------------------------
  def show_roll_result?
    return $game_switches[15]
  end
  #--------------------------------------------------------------------------
  # * hide huds?
  #--------------------------------------------------------------------------
  def hide_huds?
    re = $game_switches.nil? ? true : $game_switches[16]
    return re || story_mode?
  end
  #--------------------------------------------------------------------------
  def story_mode?
    re = $game_switches.nil? ? true : $game_switches[12]
    return re || $game_message.busy?
  end
  #--------------------------------------------------------------------------
  def hide_huds; $game_switches[16] = true; end
  def show_huds; $game_switches[16] = false; end
  #--------------------------------------------------------------------------
  # * return a rand class value
  #--------------------------------------------------------------------------
  def make_rand
    Random.new_seed
    return Random.new
  end
  #--------------------------------------------------------------------------
  def load_process
    @loading_pressure += 1
  end
  #--------------------------------------------------------------------------
  def load_complete
    @loading_pressure = 0
  end
  #--------------------------------------------------------------------------
  def load_complete?; return @loading_pressure == 0; end
  #--------------------------------------------------------------------------
  def cache_loading
  end
  #--------------------------------------------------------------------------
  alias on_after_load_dnd on_after_load
  def on_after_load
    on_after_load_dnd
    BattleManager.setup
    $game_map.on_after_load
  end
  #--------------------------------------------------------------------------
  def allow_gameover?
    return $game_switches[3]
  end
  #--------------------------------------------------------------------------
  def time_stop(caster, duration)
    @ori_tone = $game_map.screen.tone
    tone = Tone.new(32,32,32,160)
    $game_map.screen.start_tone_change(tone, 0)
    @timestop_duration = duration * 60
    @time_stopper = caster
    debug_print "Time stop: #{caster.name} #{duration}"
    SceneManager.create_override_sprite(caster)
    SceneManager.stop_time
  end
  #--------------------------------------------------------------------------
  def resume_time
    SceneManager.dispose_override_sprite(@time_stopper)
    @time_stopper = nil
    debug_print "Time resume"
    SceneManager.resume_time
    $game_map.screen.start_tone_change(@ori_tone, 0)
  end
  #--------------------------------------------------------------------------
  def game_mode=(mode)
    @game_mode = mode
  end
  #--------------------------------------------------------------------------
end
