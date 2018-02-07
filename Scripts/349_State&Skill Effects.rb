#==============================================================================
# ** State & Skill Effects
#------------------------------------------------------------------------------
#  Code eval for skill and states
#==============================================================================
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
#tag: state
class Game_Battler < Game_BattlerBase
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
  end
  #--------------------------------------------------------------------------
  # * Occur when state removed
  #--------------------------------------------------------------------------
  def on_state_erase(state_id)
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
  #--------------------------------------------------------------------------
  # tag: quque: skill sequence
  
  #--------------------------------------------------------------------------
end
