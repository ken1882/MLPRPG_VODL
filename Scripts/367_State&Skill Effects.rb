#==============================================================================
# ** State & Skill Effects
#------------------------------------------------------------------------------
#  Code eval for skill and states
#==============================================================================
# Special Thanks: TheoAllen
# Basic template of this script is form his TSBS scripts, aka
# Theolized Sideview Battle System
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
#tag: state
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :eval_effects
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_battler_stat initialize
  def initialize
    @eval_effects          = {}
    @eval_effects[:erase]  = []
    @eval_effects[:timeup] = []
    @eval_effects[:react]  = []
    @eval_effects[:shock]  = []
    @eval_effects[:begin]  = []
    @eval_effects[:while]  = []
    init_battler_stat
  end
  #--------------------------------------------------------------------------
  # * Alias: Processing at End of Turn
  #--------------------------------------------------------------------------
  alias on_turn_end_gb on_turn_end
  def on_turn_end
     @states.each do |id|
       on_state_begin(id)
     end
    on_turn_end_gb
  end
  #--------------------------------------------------------------------------
  # * Occur when state applied, including stacked
  #--------------------------------------------------------------------------
  def on_state_apply(state_id)
    reset_effect_param_cache
  end
  #--------------------------------------------------------------------------
  # * Occur when state removed
  #--------------------------------------------------------------------------
  def on_state_erase(state_id)
    reset_effect_param_cache
  end
  #--------------------------------------------------------------------------
  # * Occur when state timer hits 0
  #--------------------------------------------------------------------------
  def on_state_timeup(state_id)
  end
  #--------------------------------------------------------------------------
  # * Occur before taking damage
  #--------------------------------------------------------------------------
  def on_state_react(state_id, attacker = nil, item = nil, value = 0)
  end
  #--------------------------------------------------------------------------
  # * Occur after taking damage
  #--------------------------------------------------------------------------
  def on_state_shock(state_id, attacker = nil, item = nil, value = 0)
  end
  #--------------------------------------------------------------------------
  # * Occur at begin/end of each turn/second
  #--------------------------------------------------------------------------
  def on_state_begin(state_id)
  end
  #--------------------------------------------------------------------------
  # * Occur when performing action
  #--------------------------------------------------------------------------
  def on_state_while(state_id, item = nil)
  end
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def reset_effect_param_cache
  end
  
end
#==============================================================================
# ** DND::SkillSequence
#------------------------------------------------------------------------------
#  Sequence of action origin code
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Credit: Reference template original from TheoAllen's
# Theolized Sideview Battle System (TSBS)
#==============================================================================
#tag: skill
module DND::SkillSequence
  SEQUENCE_POSE             = :pose           # set pose
  SEQUENCE_MOVE             = :move           # trigger move     
  SEQUENCE_SLIDE            = :slide          # trigger slide
  SEQUENCE_RESET            = :goto_oripost   # trigger back to original post
  SEQUENCE_MOVE_TO_TARGET   = :move_to_target # trigger move to target
  SEQUENCE_SCRIPT           = :script         # call script function
  SEQUENCE_WAIT             = :wait           # wait for x frames
  SEQUENCE_DAMAGE           = :target_damage  # Apply skill/item to target
  SEQUENCE_SHOW_ANIMATION   = :show_anim      # Show animation on target
  SEQUENCE_CAST             = :cast           # Show animation on self
  SEQUENCE_VISIBLE          = :visible        # Toggle visibility
  SEQUENCE_AFTERIMAGE       = :afterimage     # Toggle afterimage effect
  SEQUENCE_FLIP             = :flip           # Toggle flip / mirror sprite
  SEQUENCE_ACTION           = :action         # Call predefined action
  SEQUENCE_PROJECTILE       = :projectile     # Show projectile
  SEQUENCE_PROJECTILE_SETUP = :proj_setup     # Setup projectile
  SEQUENCE_LOCK_Z           = :lock_z         # Lock shadow (and Z)
  SEQUENCE_ICON             = :icon           # Show icon
  SEQUENCE_SOUND            = :sound          # Play SE
  SEQUENCE_IF               = :if             # Set Branched condition
  SEQUENCE_TIMED_HIT        = :timed_hit      # Trigger timed hit function
  SEQUENCE_SCREEN           = :screen         # Setup screen
  SEQUENCE_ADD_STATE        = :add_state      # Add state
  SEQUENCE_REM_STATE        = :rem_state      # Remove state
  SEQUENCE_CHANGE_TARGET    = :change_target  # Change current target
  SEQUENCE_TARGET_MOVE      = :target_move    # Force move target
  SEQUENCE_TARGET_SLIDE     = :target_slide   # Force slide target
  SEQUENCE_TARGET_RESET     = :target_reset   # Force target to return
  SEQUENCE_BLEND            = :blend          # Setup battler blending
  SEQUENCE_FOCUS            = :focus          # Setup focus effect
  SEQUENCE_UNFOCUS          = :unfocus        # Remove focus effect
  SEQUENCE_TARGET_LOCK_Z    = :target_lock_z  # Lock target shadow (and Z)
  # ---------------------------------------------------------------------------
  SEQUENCE_ANIMTOP          = :anim_top     # Flag animation in always on top  
  SEQUENCE_FREEZE           = :freeze       # Freeze the screen (not tested) 
  SEQUENCE_CSTART           = :cutin_start  # Start cutin graphic)
  SEQUENCE_CFADE            = :cutin_fade   # Fade cutin graphic
  SEQUENCE_CMOVE            = :cutin_slide  # Slide cutin graphic
  SEQUENCE_TARGET_FLIP      = :target_flip  # Flip target
  SEQUENCE_PLANE_ADD        = :plane_add    # Show looping image
  SEQUENCE_PLANE_DEL        = :plane_del    # Delete looping image
  SEQUENCE_BOOMERANG        = :boomerang    # Flag projectile as boomerang
  SEQUENCE_PROJ_AFTERIMAGE  = :proj_afimage # Set afterimage for projectile
  SEQUENCE_BALLOON          = :balloon      # Show balloon icon
  # ---------------------------------------------------------------------------
  SEQUENCE_LOGWINDOW        = :log        # Display battle log
  SEQUENCE_LOGCLEAR         = :log_clear  # Clear battle log
  SEQUENCE_AFTINFO          = :aft_info   # Change afterimage
  SEQUENCE_SMMOVE           = :sm_move    # Smooth move
  SEQUENCE_SMSLIDE          = :sm_slide   # Smooth slide
  SEQUENCE_SMTARGET         = :sm_target  # Smooth move to target
  SEQUENCE_SMRETURN         = :sm_return  # Smooth return
  # ---------------------------------------------------------------------------
  SEQUENCE_LOOP             = :loop         # Loop in n times
  SEQUENCE_WHILE            = :while        # While loop
  SEQUENCE_COLLAPSE         = :collapse     # Perform collapse effect  
  SEQUENCE_FORCED           = :forced       # Force change action key to target
  SEQUENCE_ANIMBOTTOM       = :anim_bottom    # Play anim behind battler
  SEQUENCE_CASE             = :case           # Case switch
  SEQUENCE_INSTANT_RESET    = :instant_reset  # Instant reset
  SEQUENCE_ANIMFOLLOW       = :anim_follow    # Animation follow the battler
  SEQUENCE_CHANGE_SKILL     = :change_skill   # Change carried skill
  #---------------------------------------------------------------------------
  SEQUENCE_CHECKCOLLAPSE    = :check_collapse # Check collapse for target
  SEQUENCE_RESETCOUNTER     = :reset_counter  # Reset damage counter
  SEQUENCE_FORCEHIT         = :force_hit      # Toggle force to always hit
  SEQUENCE_SLOWMOTION       = :slow_motion    # Slow Motion effect
  SEQUENCE_TIMESTOP         = :timestop       # Timestop effect
  #---------------------------------------------------------------------------
  SEQUENCE_ONEANIM          = :one_anim       # One Anim Flag
  SEQUENCE_PROJ_SCALE       = :proj_scale     # Scale damage for projectile
  SEQUENCE_COMMON_EVENT     = :com_event      # Call common event
  SEQUENCE_GRAPHICS_FREEZE  = :scr_freeze     # Freeze the graphic
  SEQUENCE_GRAPHICS_TRANS   = :scr_trans      # Transition
  #---------------------------------------------------------------------------
  SEQUENCE_FORCEDODGE       = :force_evade    # Force target to evade
  SEQUENCE_FORCEREFLECT     = :force_reflect  # Force target to reflect magic
  SEQUENCE_FORCECOUNTER     = :force_counter  # Force target to counter
  SEQUENCE_FORCECRITICAL    = :force_critical # Force criticaly hit to target
  SEQUENCE_FORCEMISS        = :force_miss     # Force miss target
  SEQUENCE_BACKDROP         = :backdrop       # Change Battleback
  SEQUENCE_BACKTRANS        = :back_trans     # Backdrop Change transition
  SEQUENCE_REVERT_BACKDROP  = :reset_backdrop # Reset battleback
  SEQUENCE_TARGET_FOCUS     = :target_focus   # Custom target focus
  SEQUENCE_SCREEN_FADEOUT   = :scr_fadeout    # Fadeout screen
  SEQUENCE_SCREEN_FADEIN    = :scr_fadein     # Fadein screen
  SEQUENCE_CHECK_COVER      = :check_cover    # Check battler cover
  SEQUENCE_STOP_MOVEMENT    = :stop_move      # Stop all movement
  SEQUENCE_ROTATION         = :rotate         # Rotate battler
  SEQUENCE_FADEIN           = :fadein         # Self fadein
  SEQUENCE_FADEOUT          = :fadeout        # Self fadeout
  SEQUENCE_IMMORTALING      = :immortal       # Immortal flag
  SEQUENCE_END_ACTION       = :end_action     # Force end action
  SEQUENCE_SHADOW_VISIBLE   = :shadow         # Shadow visibility
  SEQUENCE_AUTOPOSE         = :autopose       # Automatic pose
  SEQUENCE_ICONFILE         = :icon_file      # Set icon file
  SEQUENCE_IGNOREFLIP       = :ignore_flip    # Ignore flip reverse point
  # ---------------------------------------------------------------------------
  
  # Screen sub-modes
  Screen_Tone       = :tone       # Set screen tone
  Screen_Shake      = :shake      # Set screen shake
  Screen_Flash      = :flash      # Set screen flash
  Screen_Normalize  = :normalize  # Normalize screen
  
  # Projectile setup
  PROJ_START          = :start      # Initial starting (head, mid, feet)
  PROJ_END            = :end        # Initial end position (head, mid, feet)
  PROJ_STARTPOS       = :start_pos  # Relative starting coordinate 
  PROJ_ENDPOS         = :end_pos    # Relative end position
  PROJ_REVERSE        = :reverse    # Reverse flag
  PROJ_POSITION_HEAD  = :head       # Position : head
  PROJ_POSITION_MID   = :middle     # Position : middle
  PROJ_POSITION_FEET  = :feet       # Position : feet
  PROJ_POSITION_NONE  = :none       # Position : none
  PROJ_POSITION_SELF  = :self       # Position : self (put only in PROJ_END)
  PROJ_POSITION_LAST_TARGET = :last_target
  PROJ_DAMAGE_EXE     = :damage     # Damage execution after hit
  PROJ_ANIMSTART      = :anim_start # Custom animation on start
  PROJ_ANIMEND        = :anim_end   # Custom animation on start
  PROJ_ANIMPOS        = :anim_pos   # Animation position
  PROJ_ANIMDEFAULT    = :default    # Default animation
  PROJ_ANIMHIT        = :anim_hit   # Play animation only if hit
  PROJ_SCALE          = :scale      # Damage Scale
  PROJ_PIERCE         = :pierce     # Piercing flag
  PROJ_BOOMERANG      = :boomerang  # Boomerang flag
  PROJ_AFTERIMAGE     = :aftimg     # Afterimage flag
  PROJ_AFTOPAC        = :aft_opac   # Afterimage opacity easing
  PROJ_AFTRATE        = :aft_rate   # Afterimage clone rate
  PROJ_ANGLE          = :angle      # Starting angle
  PROJ_WAITCOUNT      = :wait       # Wait frame before throws
  PROJ_CHANGE         = :change     # Change flag
  PROJ_FLASH_REF      = :flash      # Animation flash references
  PROJ_RESET          = :reset      # Reset command
  #=====================================================================
  # Damage setup for projectile
  # [-1: Damage on start][0: No damage][1: Damage on end] 
  
  PROJECTILE_DEFAULT = {
    PROJ_START      => PROJ_POSITION_MID,
    PROJ_END        => PROJ_POSITION_MID,
    PROJ_STARTPOS   => [0,0,0],
    PROJ_ENDPOS     => [0,0,0],
    PROJ_REVERSE    => false,
    PROJ_SCALE      => 1.0, 
    PROJ_DAMAGE_EXE => 1,     
    PROJ_PIERCE     => false,
    PROJ_BOOMERANG  => false,
    PROJ_AFTERIMAGE => false, 
    PROJ_AFTOPAC    => 17,   
    PROJ_AFTRATE    => 1, 
    PROJ_ANIMSTART  => nil,
    PROJ_ANIMEND    => nil,
    PROJ_ANIMPOS    => 0,
    PROJ_ANIMHIT    => false,
    PROJ_ANGLE      => 0.0,
    PROJ_WAITCOUNT  => 0,
    PROJ_FLASH_REF  => [false, false],
  }
  #=====================================================================
  
end
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
class Game_Battler < Game_BattlerBase
  # tag: last work: skill sequence
  #--------------------------------------------------------------------------
  attr_reader :sequence_index
  attr_reader :action_sequence
  #--------------------------------------------------------------------------
  alias init_sequence initialize
  def initialize
    @sequence_index = 0
    @fiber = nil
    init_sequence
  end
  #--------------------------------------------------------------------------
  def update_sequence
    @fiber.resume if @fiber
  end
  #--------------------------------------------------------------------------
  def clear_sequence
    Fiber.yield if @fiber
    @fiber = nil
    @sequence_index = 0
    @proj_setup = []
  end
  #--------------------------------------------------------------------------
  def setup_sequence(sequence)
    @action_sequence = sequence
    @sequence_index = 0
    
    @fiber = Fiber.new{execute_sequence}
  end
  #--------------------------------------------------------------------------
  def current_act
    @sequece[@index]
  end
  #--------------------------------------------------------------------------
  def execute_sequence
    while @index < @sequence.size
      execute_act
      @index += 1
    end
    clear_sequence
  end
  #--------------------------------------------------------------------------
  def execute_act
    case current_act[0]
    when SEQUENCE_POSE;               setup_pos
    when SEQUENCE_MOVE;               setup_move
    when SEQUENCE_SLIDE;              setup_slide
    when SEQUENCE_RESET;              setup_reset
    when SEQUENCE_MOVE_TO_TARGET;     setup_move_to_target
    when SEQUENCE_SCRIPT;             setup_eval_script
    when SEQUENCE_WAIT;               current_act[1].times { method_wait }
    when SEQUENCE_DAMAGE;             setup_damage
    when SEQUENCE_CAST;               setup_cast
    when SEQUENCE_VISIBLE;            @visible = current_act[1]
    when SEQUENCE_SHOW_ANIMATION;     setup_anim
    when SEQUENCE_AFTERIMAGE;         @afterimage = current_act[1]
    when SEQUENCE_FLIP;               setup_flip
    when SEQUENCE_ACTION;             setup_action
    when SEQUENCE_PROJECTILE_SETUP;   setup_projectile
    when SEQUENCE_PROJECTILE;         show_projectile
    when SEQUENCE_LOCK_Z;             @lock_z = current_act[1]
    when SEQUENCE_ICON;               setup_icon
    when SEQUENCE_SOUND;              setup_sound
    when SEQUENCE_IF;                 setup_branch
    when SEQUENCE_TIMED_HIT;          setup_timed_hit
    when SEQUENCE_SCREEN;             setup_screen
    when SEQUENCE_ADD_STATE;          setup_add_state
    when SEQUENCE_REM_STATE;          setup_rem_state  
    when SEQUENCE_CHANGE_TARGET;      setup_change_target
    when SEQUENCE_TARGET_MOVE;        setup_target_move
    when SEQUENCE_TARGET_SLIDE;       setup_target_slide
    when SEQUENCE_TARGET_RESET;       setup_target_reset
    when SEQUENCE_BLEND;              @blend = current_act[1]
    when SEQUENCE_FOCUS;              setup_focus
    when SEQUENCE_UNFOCUS;            setup_unfocus
    when SEQUENCE_TARGET_LOCK_Z;      setup_target_z
    #-----
    when SEQUENCE_ANIMTOP;            setup_anim_top
    when SEQUENCE_FREEZE;             #$game_temp.global_freeze = current_act[1]
    when SEQUENCE_CSTART;             setup_cutin
    when SEQUENCE_CFADE;              setup_cutin_fade
    when SEQUENCE_CMOVE;              setup_cutin_slide
    when SEQUENCE_TARGET_FLIP;        setup_targets_flip
    when SEQUENCE_PLANE_ADD;          setup_add_plane
    when SEQUENCE_PLANE_DEL;          setup_del_plane
    when SEQUENCE_BOOMERANG;          @proj_setup[PROJ_BOOMERANG] = true
    when SEQUENCE_PROJ_AFTERIMAGE;    @proj_setup[PROJ_AFTERIMAGE] = true
    when SEQUENCE_BALLOON;            setup_balloon_icon
    #-----
    when SEQUENCE_LOGWINDOW;          setup_log_message
    when SEQUENCE_LOGCLEAR;           get_scene.log_window.clear
    when SEQUENCE_AFTINFO;            setup_aftinfo
    when SEQUENCE_SMMOVE;             setup_smooth_move
    when SEQUENCE_SMSLIDE;            setup_smooth_slide
    when SEQUENCE_SMTARGET;           setup_smooth_move_target
    when SEQUENCE_SMRETURN;           setup_smooth_return
    #-----
    when SEQUENCE_LOOP;               setup_loop
    when SEQUENCE_WHILE;              setup_while
    when SEQUENCE_COLLAPSE;           tsbs_perform_collapse_effect
    when SEQUENCE_FORCED;             setup_force_act
    when SEQUENCE_ANIMBOTTOM;         setup_anim_bottom
    when SEQUENCE_CASE;               setup_switch_case
    when SEQUENCE_INSTANT_RESET;      setup_instant_reset
    when SEQUENCE_ANIMFOLLOW;         setup_anim_follow
    when SEQUENCE_CHANGE_SKILL;       setup_change_skill
    when SEQUENCE_CHECKCOLLAPSE;      setup_check_collapse
    when SEQUENCE_RESETCOUNTER;       get_scene.damage.reset_value
    when SEQUENCE_FORCEHIT;           @force_hit = default_true
    when SEQUENCE_SLOWMOTION;         setup_slow_motion
    when SEQUENCE_TIMESTOP;           setup_timestop
    when SEQUENCE_ONEANIM;            $game_temp.one_animation_flag = true
    when SEQUENCE_PROJ_SCALE;         setup_proj_scale
    when SEQUENCE_COMMON_EVENT;       setup_tsbs_common_event
    when SEQUENCE_GRAPHICS_FREEZE;    Graphics.freeze
    when SEQUENCE_GRAPHICS_TRANS;     setup_transition
    #-----
    when SEQUENCE_FORCEDODGE;         @force_evade = default_true
    when SEQUENCE_FORCEREFLECT;       @force_reflect = default_true
    when SEQUENCE_FORCECOUNTER;       @force_counter = default_true
    when SEQUENCE_FORCECRITICAL;      @force_critical = default_true
    when SEQUENCE_FORCEMISS;          @force_miss = default_true
    when SEQUENCE_BACKDROP;           setup_backdrop
    when SEQUENCE_BACKTRANS;          setup_backdrop_transition
    when SEQUENCE_REVERT_BACKDROP;    $game_temp.backdrop.revert;Fiber.yield
    when SEQUENCE_TARGET_FOCUS;       @focus_target = current_act[1]
    when SEQUENCE_SCREEN_FADEOUT;     setup_screen_fadeout
    when SEQUENCE_SCREEN_FADEIN;      setup_screen_fadein
    when SEQUENCE_CHECK_COVER;        setup_check_cover
    when SEQUENCE_STOP_MOVEMENT;      stop_all_movements
    when SEQUENCE_ROTATION;           setup_rotation
    when SEQUENCE_FADEIN;             setup_fadein
    when SEQUENCE_FADEOUT;            setup_fadeout
    when SEQUENCE_IMMORTALING;        setup_immortaling
    when SEQUENCE_END_ACTION;         setup_end_action
    when SEQUENCE_SHADOW_VISIBLE;     $game_temp.shadow_visible = default_true
    when SEQUENCE_AUTOPOSE;           setup_autopose
    when SEQUENCE_ICONFILE;           @icon_file = current_act[1] || ''
    when SEQUENCE_IGNOREFLIP;         @ignore_flip_point = default_true
    else
      # reserved
    end
  end
  #---------------------------------------------------------------------------
  def default_true
    return (current_act[1] || true)
  end
  #---------------------------------------------------------------------------
  # * New method : Method for wait [:wait,]
  #---------------------------------------------------------------------------
  def method_wait
    Fiber.yield
    @anim_cell = @autopose.shift unless @autopose.empty?
  end
  #---------------------------------------------------------------------------
  def setup_pos
    #reserved
  end
  #---------------------------------------------------------------------------
  def setup_move
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_slide
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_reset
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_move_to_target
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_eval_script
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_damage
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_cast
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_anim
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_flip
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_action
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_projectile
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_icon
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_sound
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_branch
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_timed_hit
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_screen
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_add_state
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_rem_state  
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_change_target
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_target_move
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_target_slide
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_target_reset
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_focus
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_unfocus
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_target_z
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_anim_top
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_cutin
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_cutin_fade
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_cutin_slide
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_targets_flip
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_add_plane
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_del_plane
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_balloon_icon
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_log_message
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_aftinfo
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_smooth_move
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_smooth_slide
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_smooth_move_target
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_smooth_return
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_loop
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_while
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_force_act
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_anim_bottom
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_switch_case
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_instant_reset
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_anim_follow
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_change_skill
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_check_collapse
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_slow_motion
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_timestop
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_proj_scale
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_tsbs_common_event
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_transition
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_backdrop
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_backdrop_transition
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_screen_fadeout
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_screen_fadein
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_check_cover
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_rotation
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_fadein
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_fadeout
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_immortaling
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_end_action
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_autopose
    #reserved
  end
  #---------------------------------------------------------------------------
end
