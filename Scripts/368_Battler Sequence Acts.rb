# =============================================================================
# Seperated from:
# Theolized Sideview Battle System (TSBS)
# Version : 1.4ob1 (Open Beta)
# Language : English
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact :
#------------------------------------------------------------------------------
# *> http://www.rpgmakerid.com
# *> http://www.rpgmakervxace.net
# *> http://theolized.blogspot.com
# =============================================================================
# Last updated : 2014.10.28
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5b
# >> Basic Functions 
# >> Movement
# >> Core Result
# >> Core Fade
# >> Clone Image
# >> Rotate Image
# >> Smooth Movement
# -----------------------------------------------------------------------------
# This section is mainly aimed for scripters. There's nothing to do unless
# you know what you're doing. I told ya. It's for your own good 
# =============================================================================
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
class Game_Battler < Game_BattlerBase
  # --------------------------------------------------------------------------
  # Basic modules
  # --------------------------------------------------------------------------
  include THEO::Movement  # Import basic module for battler movements
  include TSBS            # Import constantas
  include Smooth_Slide    # Import smooth sliding module
  include Theo::Rotation  # Import rotation function
  # --------------------------------------------------------------------------
  # New public attributes
  # --------------------------------------------------------------------------
  attr_accessor :animation_array    # Store animation sequence
  attr_accessor :battler_index      # Store battler filename index
  attr_accessor :anim_index         # Pointer for animation array
  attr_accessor :anim_cell          # Battler image index
  attr_accessor :item_in_use        # Currently used item
  attr_accessor :visible            # Visible flag
  attr_accessor :flip               # Mirror flag
  attr_accessor :area_flag          # Area damage flag
  attr_accessor :afterimage         # Afterimage flag
  attr_accessor :refresh_opacity    # Refresh opacity flag
  attr_accessor :icon_key           # Store icon key
  attr_accessor :lock_z             # Lock Z flag
  attr_accessor :balloon_id         # Balloon ID for battler
  attr_accessor :anim_guard         # Anim Guard ID
  attr_accessor :anim_guard_mirror  # Mirror Flag
  attr_accessor :afopac             # Afterimage opacity fade speed
  attr_accessor :afrate             # Afterimage show rate
  attr_accessor :forced_act         # Force action
  attr_accessor :force_hit          # Force always hit flag
  # --------- Update V1.4 --------- #
  attr_accessor :force_evade        # Force evade flag
  attr_accessor :force_reflect      # Force reflect
  attr_accessor :force_counter      # Force counter
  attr_accessor :force_critical     # Force critical hit
  attr_accessor :force_miss         # Force miss
  attr_accessor :balloon_speed      # Balloon speed
  attr_accessor :balloon_wait       # Balloon wait
  attr_accessor :cover_battler      # Substitue / cover battler
  attr_accessor :covering           # Covering flag
  attr_accessor :angle              # Angle rotation
  attr_accessor :immortal           # Immortal flag
  attr_accessor :break_action       # Break action
  #=====================================================================
  #
  # tag: customed
  # New public attributes (access only)
  #
  #=====================================================================
  attr_reader :target         # Current target
  attr_accessor :last_target
  attr_reader :target_array   # Overall target
  attr_reader :battle_phase   # Battle Phase
  attr_reader :blend          # Blend
  attr_reader :shadow_point   # Shadow Point
  attr_reader :acts           # Used action
  attr_reader :user           # self
  #--------------------------------------------------------------------------
  attr_reader :sequence_index
  attr_reader :action_sequence
  attr_reader :move_obj, :fiber
  # --------------------------------------------------------------------------
  # Alias method : initialize
  # --------------------------------------------------------------------------
  alias theo_tsbs_batt_init initialize
  def initialize(*args)
    @sequence_index = 0
    @fiber = nil
    @user = self
    @shadow_point = Screen_Point.new
    theo_tsbs_batt_init(*args)
    set_obj(self)
    clear_tsbs
  end
  # --------------------------------------------------------------------------
  # New method : Icon File
  # --------------------------------------------------------------------------
  def icon_file(index = 0)
    return @icon_file unless @icon_file.empty?
    return weapons[index].icon_file if weapons[index]
    return ''
  end
  # --------------------------------------------------------------------------
  # New method : Default Flip
  # --------------------------------------------------------------------------
  def default_flip
    return false
  end
  # --------------------------------------------------------------------------
  # New method : Custom Flip
  # --------------------------------------------------------------------------
  def custom_flip?
    return data_battler.custom_flip?
  end
  # --------------------------------------------------------------------------
  # New method : Final Flip result
  # --------------------------------------------------------------------------
  def battler_flip
    (custom_flip? ? false : @flip)
  end
  # --------------------------------------------------------------------------
  # New method : finish
  # --------------------------------------------------------------------------
  def finish
    @finish || @break_sequence
  end
  # --------------------------------------------------------------------------
  # New method : sprite
  # --------------------------------------------------------------------------
  unless method_defined?(:sprite)
  def sprite
    SceneManager.spriteset.battler_sprite_table[hashid]
  end
  end
  # --------------------------------------------------------------------------
  # New method : Reset to original position
  # --------------------------------------------------------------------------
  def reset_pos(dur = 30, jump = 0)
    goto(@ori_x, @ori_y, dur, jump)
  end
  # --------------------------------------------------------------------------
  # New method : Relative X position from center (used for camera)
  # --------------------------------------------------------------------------
  def rel_x
    return x - Graphics.width/2
  end
  # --------------------------------------------------------------------------
  # New method: Relative Y position from center (used for camera)
  # --------------------------------------------------------------------------
  def rel_y
    return y - Graphics.height/2
  end
  # --------------------------------------------------------------------------
  # New method: Distance between the shadow and the battler
  # --------------------------------------------------------------------------
  def height
    return @shadow_point.y - self.y
  end
  # --------------------------------------------------------------------------
  # New method : Clear TSBS infos
  # --------------------------------------------------------------------------
  def clear_tsbs
    @animation_array = []
    @finish = false
    @anim_index = 0
    @anim_cell = 0
    @battler_index = 1
    @battle_phase = nil
    @target = nil
    @ori_target = nil # Store original target. Do not change!
    @target_array = []
    @ori_targets = [] # Store original target array. Do not change!
    @item_in_use = nil  
    @visible = true
    @flip = default_flip
    @area_flag = false
    @afterimage = false
    @proj_icon = 0
    @refresh_opacity = false
    @lock_z = false
    @icon_key = ""
    @acts = []
    @blend = 0
    @used_sequence = "" # Record the used  for error handling
    @sequence_stack = []  # Used sequence stack trace for error handling
    @balloon_id = 0
    @balloon_speed = BALLOON_SPEED
    @balloon_wait = BALLOON_WAIT
    @anim_guard = 0
    @anim_guard_mirror =  false
    @forced_act = ""
    @proj_setup = copy(PROJECTILE_DEFAULT)
    @focus_target = 0
    @covering = false
    @shadow_point.x = @shadow_point.y = 0
    @angle = 0.0
    @immortal = false
    @break_sequence = false
    @autopose = []
    @icon_file = ''
    reset_force_result
    reset_aftinfo
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Goto (basic module)
  # --------------------------------------------------------------------------
  def goto(x, y, dur, jump, height = 0)
    super(x, y, dur, jump)
    height = [height, 0].max
    y = @shadow_point.y if @lock_z
    @shadow_point.goto(x, y + height, dur, 0)
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Slide (basic module)
  # --------------------------------------------------------------------------
  def slide(x, y, dur, jump, height = 0)
    slide_x = self.x + x
    slide_y = self.y + y
    goto(slide_x, slide_y, dur, jump, height) unless moving?
  end
  #---------------------------------------------------------------------------
  # Overwrite method : Smooth move (basic module)
  #---------------------------------------------------------------------------
  def smooth_move(x, y, dur, reverse = false)
    super(x,y,dur,reverse)
    @shadow_point.smooth_move(x,y,dur,reverse)
  end
  # --------------------------------------------------------------------------
  # New method : Battler update
  # --------------------------------------------------------------------------
  def update
    update_move           # Update movements (Basic Modules)
    update_smove          # Update smooth movement (Basic Modules)
    update_rotation       # Update rotation
    @shadow_point.update_move
    update_sequence
  end
  #--------------------------------------------------------------------------
  def update_shadow_point
    return unless @shadow_point
    @shadow_point.x = x
    @shadow_point.y = y
  end
  #--------------------------------------------------------------------------
  def update_sequence
    @fiber.resume if @fiber
  end
  #--------------------------------------------------------------------------
  def clear_sequence
    @fiber = nil
    @sequence_index = 0
    @proj_setup = []
    @action_sequence = nil
    @break_sequence = true
    @map_char.finalize_acting if @map_char
  end
  #--------------------------------------------------------------------------
  def setup_action_sequence(sequence)
    @action_sequence = sequence
    @sequence_index = 0
    @break_sequence = false
    @fiber = Fiber.new{execute_sequence}
  end
  #--------------------------------------------------------------------------
  def current_act
    @acts
  end
  #--------------------------------------------------------------------------
  def execute_sequence
    # defined in later script
  end
  #--------------------------------------------------------------------------
  def save_fiber
    @fiber_saved = !@fiber.nil?
    @fiber = nil
  end
  #--------------------------------------------------------------------------
  def restore_fiber
    return unless @fiber_saved
    @fiber = Fiber.new{execute_sequence}
    @fiber_saved = false
  end
  # --------------------------------------------------------------------------
  # New method : Refers to battler database
  # --------------------------------------------------------------------------
  def data_battler
    return nil
  end
  # --------------------------------------------------------------------------
  # New method : Determine if battler is in critical condition
  # --------------------------------------------------------------------------
  def critical?
    hp_rate <= Critical_Rate
  end
  # --------------------------------------------------------------------------
  # New method : Idle sequence key
  # --------------------------------------------------------------------------
  # Idle key sequence contains several sequence keys. Include dead sequence,
  # state sequence, critical sequence,and normal sequence. Dead key sequence
  # has the top priority over others. Just look at the below
  # --------------------------------------------------------------------------
  def idle_key
    return data_battler.dead_key if !@immortal && dead? && actor?    
    return state_sequence if state_sequence
    return data_battler.critical_key if critical? && 
      !data_battler.critical_key.empty?
    return data_battler.idle_key
  end
  # --------------------------------------------------------------------------
  # New method : Skill sequence key
  # Must be called when item_in_use isn't nil
  # --------------------------------------------------------------------------
  def skill_key
    return item_in_use.seq_key[rand(item_in_use.seq_key.size)]
  end
  # --------------------------------------------------------------------------
  # New method : Return sequence key
  # Must be called when item_in_use isn't nil
  # --------------------------------------------------------------------------
  def return_key
    return "Knock_Back" if item_in_use.nil?
    return item_in_use.return_key if !item_in_use.return_key.empty?
    return data_battler.return_key
  end
  # --------------------------------------------------------------------------
  # New method : Preparation key
  # Must be called when item_in_use isn't nil
  # --------------------------------------------------------------------------
  def prepare_key
    return item_in_use.prepare_key
  end
  # --------------------------------------------------------------------------
  # Miscellaneous keys
  # --------------------------------------------------------------------------
  def escape_key;   data_battler.escape_key;    end
  def victory_key;  data_battler.victory_key;   end
  def hurt_key;     data_battler.hurt_key;      end
  def evade_key;    data_battler.evade_key;     end
  def intro_key;    data_battler.intro_key;     end
  def counter_key;  data_battler.counter_key;   end
  def collapse_key; data_battler.collapse_key;  end
  def covered_key;  evade_key;                  end
  def aim_target_key;  aim_target_key;          end
  # --------------------------------------------------------------------------
  # New method : Start
  # --------------------------------------------------------------------------
  def tsbs_battler_start
    reset_force_result
    reset_aftinfo
    @proj_setup = copy(PROJECTILE_DEFAULT)
    @focus_target = 0
    @autopose = []
    @icon_file = ''
    @ignore_flip_point = false
  end
  # --------------------------------------------------------------------------
  # New method : Reset force result
  # --------------------------------------------------------------------------
  def reset_force_result
    @force_hit = false
    @force_evade = false
    @force_reflect = false
    @force_counter = false
    @force_critical = false
    @force_miss = false
  end
  # --------------------------------------------------------------------------
  # New method : Reset afterimage info
  # --------------------------------------------------------------------------
  def reset_aftinfo
    @afopac = AFTIMG_OPACITY_EASE
    @afrate = AFTIMG_IMAGE_RATE
  end  
  #--------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  def save_battler_fibers
    all_battlers.each do |battler|
      battler.save_fiber
    end
    debug_print("Fiber saved")
  end
  #--------------------------------------------------------------------------
  def restore_battler_fibers
    all_battlers.each do |battler|
      battler.restore_fiber
    end
    debug_print("Fiber restored")
  end
  #--------------------------------------------------------------------------
end
