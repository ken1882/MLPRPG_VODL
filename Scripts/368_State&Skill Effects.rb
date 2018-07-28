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
  #--------------------------------------------------------------------------
  def current_action_targets
    return unless @map_char
    return @map_char.current_action.subject
  end
  #--------------------------------------------------------------------------
  def execute_sequence
    puts "#{name}: execute sequence"
    while @sequence_index < @action_sequence.size
      puts "Update sequence: #{@sequence_index}"
      @acts = @action_sequence[@sequence_index]
      execute_act
      @sequence_index += 1
      #Fiber.yield # consider uncomment this line
    end
    clear_sequence
  end
  #--------------------------------------------------------------------------
  def execute_act
    case @acts[0]
    when SEQUENCE_POSE;               setup_pose
    when SEQUENCE_MOVE;               setup_move
    when SEQUENCE_SLIDE;              setup_slide
    when SEQUENCE_RESET;              setup_reset
    when SEQUENCE_MOVE_TO_TARGET;     setup_move_to_target
    when SEQUENCE_SCRIPT;             setup_eval_script
    when SEQUENCE_WAIT;               @acts[1].times { method_wait }
    when SEQUENCE_DAMAGE;             setup_damage
    when SEQUENCE_CAST;               setup_cast
    when SEQUENCE_VISIBLE;            @visible = @acts[1]
    when SEQUENCE_SHOW_ANIMATION;     setup_anim
    when SEQUENCE_AFTERIMAGE;         @afterimage = @acts[1]
    when SEQUENCE_FLIP;               setup_flip
    when SEQUENCE_ACTION;             setup_action
    when SEQUENCE_PROJECTILE_SETUP;   setup_projectile
    when SEQUENCE_PROJECTILE;         show_projectile
    when SEQUENCE_LOCK_Z;             @lock_z = @acts[1]
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
    when SEQUENCE_BLEND;              @blend = @acts[1]
    when SEQUENCE_FOCUS;              setup_focus
    when SEQUENCE_UNFOCUS;            setup_unfocus
    when SEQUENCE_TARGET_LOCK_Z;      setup_target_z
    #-----
    when SEQUENCE_ANIMTOP;            setup_anim_top
    when SEQUENCE_FREEZE;             #$game_temp.global_freeze = @acts[1]
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
    when SEQUENCE_COMMON_EVENT;       setup_common_event
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
    when SEQUENCE_TARGET_FOCUS;       @focus_target = @acts[1]
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
    when SEQUENCE_ICONFILE;           @icon_file = @acts[1] || ''
    when SEQUENCE_IGNOREFLIP;         @ignore_flip_point = default_true
    else
      # reserved
    end
  end
  #---------------------------------------------------------------------------
  def default_true
    return (@acts[1] || true)
  end
  #---------------------------------------------------------------------------
  def target_valid?(ta = current_target)
    return ta && ta.valid_battler? && ta.alive?
  end
  #---------------------------------------------------------------------------
  # * New method : Method for wait [:wait,]
  #---------------------------------------------------------------------------
  def method_wait
    puts "method wait"
    Fiber.yield
    @anim_cell = @autopose.shift unless @autopose.empty?
  end
  #---------------------------------------------------------------------------
  # New method : Setup pose [:pose,]
  #---------------------------------------------------------------------------
  def setup_pose
    return unless PONY::ERRNO.check_sequence(current_act)
    @battler_index = @acts[1]
    @anim_cell     = @acts[2]
    if @anim_cell.is_a?(Array)
      row = (@anim_cell[0] - 1) * MaxRow
      col = @anim_cell[1] - 1
      @anim_cell = row + col
    end
    @icon_key = @acts[4] if @acts[4]  # Icon call
    @icon_key = @acts[5] if @acts[5] && flip  # Icon call
  end
  #---------------------------------------------------------------------------
  # New method : Setup movement [:move,]
  #---------------------------------------------------------------------------
  def setup_move
    return unless PONY::ERRNO.check_sequence(current_act)
    stop_all_movements
    mx = @map_char.real_x + @acts[1]
    my = @map_char.real_y + @acts[2]
    goto(mx, my, @acts[3], @acts[4], @acts[5] || 0)
  end
  #--------------------------------------------------------------------------
  # New method : Setup slide [:slide,]
  #--------------------------------------------------------------------------
  def setup_slide
    return unless PONY::ERRNO.check_sequence(current_act)
    stop_all_movements
    xpos = (flip && !@ignore_flip_point ? -@acts[1] : @acts[1])
    ypos = @acts[2]
    slide(xpos, ypos, @acts[3], @acts[4], @acts[5] || 0)
    @acts[4].times do
      method_wait
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup reset [:goto_oripost,]
  #--------------------------------------------------------------------------
  def setup_reset
    stop_all_movements
    goto(@ori_x, @ori_y, @acts[1], @acts[2])
  end
  #--------------------------------------------------------------------------
  # New method : Setup move to target [:move_to_target,]
  #--------------------------------------------------------------------------
  def setup_move_to_target
    return unless PONY::ERRNO.check_sequence(current_act)
    stop_all_movements
    xpos = target.x + (flip ? -@acts[1] : @acts[1])
    ypos = target.y + @acts[2]
    goto(xpos, ypos, @acts[3], @acts[4], @acts[5] || 0)
  end
  #--------------------------------------------------------------------------
  # New method : Setup eval script [:script,]
  #--------------------------------------------------------------------------
  def setup_eval_script
    begin
      eval(@acts[1])
    rescue StandardError => err
      PONY::ERRNO.sequence_error(:eval, err)
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup damage [:target_damage,]
  #--------------------------------------------------------------------------
  def setup_damage
    return unless PONY::ERRNO::check_sequence(current_act)
    target = current_action_targets
    item = @acts[1].is_a?(Numeric) ? $data_skills[@acts[1]] : @acts[1]
    temp_action = Game_Action.new(self, target, item)
    temp_aciton.reassign_item(temp_action.get_symbol_item)
    return if item.nil? || item.is_a?(Symbol)
    BattleManager.invoke_action(temp_action)
  end
  #--------------------------------------------------------------------------
  # New method : Setup cast [:cast,]
  #--------------------------------------------------------------------------
  def setup_cast
    return unless PONY::ERRNO::check_sequence(current_act)
    @map_char.start_animation(@acts[1])
  end
  # --------------------------------------------------------------------------
  # New method : Setup animation [:show_anim,]
  # --------------------------------------------------------------------------
  def setup_anim
    return unless PONY::ERRNO::check_sequence(current_act)
    anid = @acts[1]
    
    if @acts[2]
      if target_valid?
        current_target.map_char.start_animation(anid)
      else
        @map_char.start_animation(anid)
      end
    else
      current_action_targets.each do |target|
        next unless target_valid?(target)
        target.map_char.start_animation(anid)
      end
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup battler flip [:flip,]
  # -------------------------------------------------------------------------
  def setup_flip
    return unless PONY::ERRNO::check_sequence(current_act)
    if @acts[1] == :toggle
      @flip = !@flip 
    elsif @acts[1] == :ori
      @flip = default_flip
    else
      @flip = @acts[1]
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup actions [:action,]
  # -------------------------------------------------------------------------
  def setup_action
    return unless PONY::ERRNO::check_sequence(current_act)
    new_sequence = @action_sequence[@sequence_index+1...@action_sequence.size]
    @sequence_index = 0
    new_sequence = DND::SkillSequence::ACTS[@acts[1]] + new_sequence
    execute_sequence
  end
  # --------------------------------------------------------------------------
  # New method : Setup projectile [:proj_setup,]
  # --------------------------------------------------------------------------
  def setup_projectile
    return unless PONY::ERRNO::check_sequence(current_act)
    skill_id = @acts[1]
    source   = @acts[2]
    target   = @acts[3]
    Game_Action.new(source, target, $data_skills[skill_id])
  end
  #--------------------------------------------------------------------------
  # New method : Setup weapon icon [:icon,]
  # -------------------------------------------------------------------------
  def setup_icon
    return unless PONY::ERRNO::check_sequence(current_act)
    @icon_key = @acts[1]
    @icon_key = @acts[2] if @acts[2] && flip
  end
  #--------------------------------------------------------------------------
  # New method : Setup sound [:sound,]
  #--------------------------------------------------------------------------
  def setup_sound
    return unless PONY::ERRNO::check_sequence(current_act)
    name  = @acts[1]
    vol   = @acts[2] || 100
    pitch = @acts[3] || 100
    RPG::SE.new(name,vol,pitch).play
  end
  #--------------------------------------------------------------------------
  # New method : Setup conditional branch [:if,]
  # -------------------------------------------------------------------------
  def setup_branch
    return unless PONY::ERRNO::check_sequence(current_act)
    act_true = @acts[2]
    act_false = @acts[3]
    bool = false
    
    begin # Test the script call condition
      bool = eval(@acts[1])
    rescue StandardError => err
      PONY::ERRNO.sequence_error(:eval, err)
    end
    act_result = (bool ? act_true : (!act_false.nil? ? act_false: nil))
    if act_result
      is_array = act_result.is_a?(Array)
      if is_array && act_result[0].is_a?(Array)
        act_result.each do |action|
          next unless action.is_a?(Array)
          @acts = action
          execute_act
        end
      elsif is_array
        @acts = act_result
        execute_act
      else
        @acts = [:action, act_result]
        execute_act
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # New method [:timed_hit,]
  #--------------------------------------------------------------------------
  def setup_timed_hit
    return unless PONY::ERRNO::check_sequence(current_act)
    # perhaps not needed
  end
  #--------------------------------------------------------------------------
  # New method [:setup_screen,]
  #--------------------------------------------------------------------------
  def setup_screen
    return unless PONY::ERRNO::check_sequence(current_act)
    screen = $game_map.screen
    argse = @acts.size - 1
    case @acts[1]
    when Screen_Tone
      return PONY::ERRNO.sequence_error(:args, "Screen_Tone", 3, argse) if @acts.size < 4
      tone = @acts[2]
      duration = @acts[3]
      screen.start_tone_change(tone, duration)
    when Screen_Shake
      return PONY::ERRNO.sequence_error(:args, "Screen_Shake", 4, argse) if @acts.size < 5
      power = @acts[2]
      speed = @acts[3]
      duration = @acts[4]
      screen.start_shake(power, speed, duration)
    when Screen_Flash
      return PONY::ERRNO.sequence_error(:args, "Screen_Flash", 3, argse) if @acts.size < 4
      color = @acts[2]
      duration = @acts[3]
      screen.start_flash(color, duration)
    when Screen_Normalize
      return PONY::ERRNO.sequence_error(:args, "Screen_Normalize", 2, argse) if @acts.size < 3
      tone = Tone.new
      duration = @acts[2]
      screen.start_tone_change(tone, duration)
    end
  end
  #--------------------------------------------------------------------------
  # New method Setup add state [:add_state,]
  #--------------------------------------------------------------------------
  def setup_add_state
    return unless PONY::ERRNO::check_sequence(current_act)
    
    current_action_targets.each do |target|
      state_id = @acts[1]
      chance   = @acts[2] || 100
      chance   = chance / 100.0 if c.integer?
      chance  *= target.state_rate(state_id) unless @acts[3]
      target.add_state(state_id, self) if rand < chance
    end
  end
  #--------------------------------------------------------------------------
  # New method Setup remove state [:rem_state,]
  #--------------------------------------------------------------------------
  def setup_rem_state
    return unless PONY::ERRNO::check_sequence(current_act)
    current_action_targets.each do |target|
      state_id = @acts[1]
      chance   = @acts[2] || 100
      chance   = chance / 100.0 if c.integer?
      target.remove_state(state_id)   if rand < chance
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup change target [:change_target,]
  #--------------------------------------------------------------------------
  def setup_change_target
    return unless PONY::ERRNO::check_sequence(current_act)
    setup_target(@acts[1])
  end
  #--------------------------------------------------------------------------
  # New method : Setup target movement [:target_move,]
  #--------------------------------------------------------------------------
  def setup_target_move
    return unless PONY::ERRNO::check_sequence(current_act)
    args = [@acts[1], @acts[2], @acts[3], @acts[4], @acts[5] || 0]
    current_action_targets.each do |target|
      target.goto(*args)
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup target slide [:target_slide,]
  #--------------------------------------------------------------------------
  def setup_target_slide
    return unless PONY::ERRNO::check_sequence(current_act)
    args = [@acts[1], @acts[2], @acts[3], @acts[4], @acts[5] || 0]
    current_action_targets.each do |target|
      target.slide(*args)
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup target reset [:target_reset]
  #--------------------------------------------------------------------------
  def setup_target_reset
    return unless PONY::ERRNO::check_sequence(current_act)
    current_action_targets.each do |target|
      target.reset_pos(@acts[1], @acts[2])
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup target lock Z [:target_lock_z,]
  #--------------------------------------------------------------------------
  def setup_target_z
    return unless PONY::ERRNO::check_sequence(current_act)
    current_action_targets.each do |target|
      target.lock_z = @acts[1]
    end
  end
  #--------------------------------------------------------------------------
  # New method : Setup anim top [:anim_top]
  #--------------------------------------------------------------------------
  def setup_anim_top
    # not sure if needed
    $game_temp.anim_top = (@acts[1] == true || @acts[1].nil? ? 1 : 0)
  end
  #--------------------------------------------------------------------------
  # New method : Setup anim bottom [:anim_bottom]
  #--------------------------------------------------------------------------
  def setup_anim_bottom
    # not sure if needed
    $game_temp.anim_top = (@acts[1] == true || @acts[1].nil? ? -1 : 0)
  end
  #--------------------------------------------------------------------------
  # New method : Setup anim follow [:anim_follow]
  #--------------------------------------------------------------------------
  def setup_anim_follow
    # not sure if needed
    $game_temp.anim_follow = default_true
  end
  #--------------------------------------------------------------------------
  # New method : Cutin Start [:cutin_start,]
  #--------------------------------------------------------------------------
  def setup_cutin
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_cutin_fade
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_cutin_slide
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  # New method : Setup Targets flip [:target_flip,]
  #--------------------------------------------------------------------------
  def setup_targets_flip
    return unless PONY::ERRNO::check_sequence(current_act)
    current_actions_targets.each do |target|
      target.flip = @acts[1]
    end
  end
  #--------------------------------------------------------------------------
  def setup_add_plane
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_del_plane
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_balloon_icon
    return unless PONY::ERRNO::check_sequence(current_act)
    @balloon_id    = @acts[1]
    @balloon_speed = @acts[2] || BALLOON_SPEED
    @balloon_wait  = @acts[3] || BALLOON_WAIT
  end
  #--------------------------------------------------------------------------
  def setup_log_message
    return unless PONY::ERRNO::check_sequence(current_act)
    SceneManager.display_info(@acts[1])
  end
  #--------------------------------------------------------------------------
  # New method : Setup Afterimage Information [:aft_info,]
  #--------------------------------------------------------------------------
  def setup_aftinfo
    @afrate = @acts[1] || 3
    @afopac = @acts[2] || 20
  end
  #--------------------------------------------------------------------------
  # New method : Smooth Moving [:sm_move,]
  #--------------------------------------------------------------------------
  def setup_smooth_move
    tx = @acts[1] || x
    ty = @acts[2] || y
    dur = @acts[3] || 25
    rev = @acts[4]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  #--------------------------------------------------------------------------
  # New method : Smooth Sliding [:sm_slide,]
  #--------------------------------------------------------------------------
  def setup_smooth_slide
    tx = @acts[1] + x || 0
    ty = @acts[2] + y || 0
    dur = @acts[3] || 25
    rev = @acts[4]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  #--------------------------------------------------------------------------
  # New method : Smooth Move to target [:sm_target,]
  #--------------------------------------------------------------------------
  def setup_smooth_move_target
    targets = current_action_targets
    size = targets.size
    xpos = targets.inject(0){|r, battler| r + battler.map_char.x} / size
    ypos = targets.inject(0){|r, battler| r + battler.map_char.y} / size
    xpos += @acts[1]
    xpos *= -1 if flip && !@ignore_flip_point
    rev = @acts[3].nil? ? true : (@acts[3] || false)
    smooth_move(xpos, ypos + @acts[2], @acts[3])
  end
  #--------------------------------------------------------------------------
  # New method : Smooth return [:sm_return,]
  #--------------------------------------------------------------------------
  def setup_smooth_return
    tx = @ori_x
    ty = @ori_y
    dur = @act[1] || 25
    rev = @acts[2]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  #--------------------------------------------------------------------------
  # New method : Setup loop [:loop,]
  #--------------------------------------------------------------------------
  def setup_loop
    return unless PONY::ERRNO::check_sequence(current_act)
    count      = @acts[1]
    action_key = @acts[2]
    is_string  = action_key.is_a?(String)
    count.times do
      if is_string
        @acts = [:action, action_key]
        execute_sequence
        break if @break_sequence
      else
        begin
          action_key.each do |action|
            @acts = action
            execute_sequence
            break if @break_sequence
          end
        rescue
          ErrorSound.play
          text = "Wrong [:loop] parameter!"
          msgbox text
          exit
        end
      end # if is_string
      break if @break_sequence
    end # count.times
  end
  #--------------------------------------------------------------------------
  # New method : Setup 'while' mode loop [:while]
  #--------------------------------------------------------------------------
  def setup_while
    return unless PONY::ERRNO::check_sequence(current_act)
    cond = @acts[1]
    action_key = @acts[2]
    actions = (action_key.class == String ? TSBS::AnimLoop[action_key] : action_key)
    if actions.nil?
      show_action_error(action_key)
    end
    begin
      while eval(cond)
        exe_act = actions.clone
        until exe_act.empty? || @break_sequence
          @acts = exe_act.shift
          execute_sequence
        end
      end
    rescue StandardError => err
      display_error("[#{SEQUENCE_WHILE},]",err)
    end
  end
  #--------------------------------------------------------------------------
  def setup_force_act
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_switch_case
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  # New method : Setup Instant Reset [:instant_reset,]
  #--------------------------------------------------------------------------
  def setup_instant_reset
    reset_pos(1)  # Reset position
    update_move   # Update move as well
  end
  #--------------------------------------------------------------------------
  def setup_change_skill
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_check_collapse
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  # New method : Setup check collapse [:slow_motion,]
  #-------------------------------------------------------------------------- 
  def setup_slow_motion
    return unless PONY::ERRNO::check_sequence(current_act)
    $game_temp.slowmotion_frame = @acts[1]
    $game_temp.slowmotion_rate  = @acts[2]
  end
  #--------------------------------------------------------------------------
  # New method : Setup timestop [:timestop,]
  #--------------------------------------------------------------------------
  def setup_timestop
    return unless PONY::ERRNO::check_sequence(current_act)
    @acts[1].times { SceneManager.update_basic }
  end
  #--------------------------------------------------------------------------
  def setup_proj_scale
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_common_event
    return unless PONY::ERRNO::check_sequence(current_act)
    unless @acts[1].is_a?(Numeric)
      return raise(TypeError, "Expect Fixnum, Received #{@acts[1].ruby_class}")
    end
    $game_temp.reserve_common_event(@acts[1])
  end
  #--------------------------------------------------------------------------
  def setup_transition
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_backdrop
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_backdrop_transition
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_screen_fadeout
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_screen_fadein
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_check_cover
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_rotation
    return unless PONY::ERRNO::check_sequence(current_act)
    @angle = @acts[1]
    change_angle(@acts[2], @acts[3])
  end
  #--------------------------------------------------------------------------
  def setup_fadein
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_fadeout
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_immortaling
    return unless PONY::ERRNO::check_sequence(current_act)
    #reserved
  end
  #--------------------------------------------------------------------------
  def setup_end_action
    clear_sequence
  end
  #--------------------------------------------------------------------------
  def setup_autopose
    return unless PONY::ERRNO::check_sequence(current_act)
    @battler_index = @acts[1]
    initial_cell = (@acts[2] - 1) * MaxRow
    @autopose.clear
    MaxCol.times do |i|
      @autopose += Array.new(@acts[3]) { initial_cell + i}
    end
  end
  #---------------------------------------------------------------------------
  def stop_all_movements
    @move_obj.clear_move_info
    @shadow_point.clear_move_info
    end_smooth_slide
    @shadow_point.end_smooth_slide
  end
end
