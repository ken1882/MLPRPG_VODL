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
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
class Game_Battler < Game_BattlerBase
  # tag: last work: skill sequence
  include DND::SkillSequence
  #--------------------------------------------------------------------------
  MaxRow = 4
  MaxCol = 3
  #--------------------------------------------------------------------------
  def execute_sequence
    while @index < @sequence.size
      @acts = current_act
      execute_act
      @index += 1
    end
    clear_sequence
  end
  #--------------------------------------------------------------------------
  def execute_act
    case current_act[0]
    when SEQUENCE_POSE;               setup_pose
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
  def setup_pose
    return PONY::ERRNO.sequence_error(:args, @acts[0], 3, @acts.size) if @acts.size < 4
    @battler_index = @acts[1]
    @anim_cell     = @acts[2]
    if @anim_cell.is_a?(Array)
      row = (@anim_cell[0] - 1) * MaxRow
      col = @anim_cell[1] - 1
      @anim_cell = row + col
    end
    @icon_key = @acts[4] if @acts[4]  # Icon call
    @icon_key = @acts[5] if @acts[5] && flip  # Icon call
    @acts[3].times do                 # Wait time
      method_wait
    end
  end
  #---------------------------------------------------------------------------
  def setup_move
    return PONY::ERRNO.sequence_error(:args, @acts[0], 4, @acts.size) if @acts.size < 5
    stop_all_movements
    goto(@acts[1], @acts[2], @acts[3], @acts[4], @acts[5] || 0)
  end
  #--------------------------------------------------------------------------
  def setup_slide
    return PONY::ERRNO.sequence_error(:args, @acts[0], 4, @acts.size) if @acts.size < 5
    stop_all_movements
    xpos = (flip && !@ignore_flip_point ? -@acts[1] : @acts[1])
    ypos = @acts[2]
    slide(xpos, ypos, @acts[3], @acts[4], @acts[5] || 0)
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
  def stop_all_movements
    @move_obj.clear_move_info
    @shadow_point.clear_move_info
    end_smooth_slide
    @shadow_point.end_smooth_slide
  end
end
