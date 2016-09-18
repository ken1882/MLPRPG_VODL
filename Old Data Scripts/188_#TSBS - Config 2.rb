# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.4ob1 (Open Beta)
# Language : English
# Some translation by : CielScarlet
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact :
#------------------------------------------------------------------------------
# *> http://www.rpgmakerid.com
# *> http://www.rpgmakervxace.net
# *> http://theolized.blogspot.com
#==============================================================================
# Last updated : 2014.10.21
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5b
# >> Basic Functions 
# >> Movement    
# >> Core Result
# >> Core Fade
# >> Clone Image
# >> Rotate Image
# >> Smooth Movement
# =============================================================================
# Terms of Use :
# -----------------------------------------------------------------------------
# Credit me, TheoAllen. You are free to edit this script by your own. As long
# as you don't claim it yours. For commercial purpose, don't forget to give me
# a free copy of the game.
# =============================================================================
module TSBS  # <-- don't touch
# =============================================================================
#                             SHOW ACTOR ICON
# =============================================================================
%Q{

  First Part : Showing Icon
  
  This is where you define icon-icon that will be displayed when performed
  action sequence during battle. Such as an actor swing his/her weapon. You
  may add it as many as you want as long as you follow this format
  
  "key" => [origin, x, y, z, start, end, dur, index, (flip?, sx, sy, dur)]]
  
  Explanation :
  - "key"  >> Text key that will be used to call. Every icon sequence must have
              unique text key.
  - origin >> Center point of icon. There're 5 kind of center point. There're
              [0: Center] [1:Top-Left] [2: Top-Right] [3:Bottom-Left]
              [4: Bottom-Right]
  - x      >> Distance X from battler
  - y      >> Distance Y from battler
  - z      >> Is icon above battler? (true/false)
  - start  >> Starting angle of icon
  - end    >> Target angle of icon rotation
  - dur    >> The rotate duration in frame (60 frame = 1 second)
  - index  >> Icon index. Write -1 if you want to display actor weapon icon.
              and -2 if you want to display the second weapon. 
              
              You can also fill it up by text/string that will be evaluated as
              script. The return must be integer though. For example
              "actor.weapons[0].icon_index"
  - flip?  >> Will be icon flipped? Fill with true / false. You can ommit 
              though. The default value is false
              
   OPTIONAL :
  - flip?  >> Will icon flipped? Put true or false. You may omit this
  - sx     >> X axis movement from original X axis
  - sy     >> Y axis movement from original Y axis
  - dur    >> Travel duration
              
  Note :
  The usage of icon itself will be revealed in action sequence on the third
  part of these settings
  
}
# -----------------------------------------------------------------------------
# Here, where you define icon sequence that will be displayed
# -----------------------------------------------------------------------------
  Icons = {
  # "Key"   => [origin, x,    y,      z, start, end, dur, index],
    "Swing" => [4,     -5,  -12,   true,   -60,  70,   6,    -3],
    "Clear" => [4,      0,    0,  false,     0,   0,   0,     0],
    
  # Add more by yourself
  
  } # <-- don't touch !
# =============================================================================
#                             DEFAULT SEQUENCES
# =============================================================================
%Q{

  Second Part : Default sequence
  
  Here where you define the default sequence for each battler movement. It's
  very useful if you're too lazy to put <sideview> tag in actor notebox and
  its attributes (like I did)
  
  Example :
  If you already define the Default_Idle = "IDLE"
  Then you're not require to put this tag in actor notebox
  
  <sideview>
  idle : IDLE
  </sideview>
  
  It because every battler will be using same sequence. To be noted that you
  have to have a same battler format. I mean, if battler_1 and the first row
  is used for idle, then the rest of your battler should do the same
  
  Those sequence keys can be looked after this part

}
# -----------------------------------------------------------------------------
# Here, where you set the default setting of sequence for each action
# -----------------------------------------------------------------------------
  Default_Idle      = "K-idle"    # Idle sequence key
  Default_Critical  = "K-pinch"   # Critical sequence key
  Default_Evade_A   = "K-evade"   # Evade sequence key for actor
  Default_Evade_E   = "E-evade"   # Evade sequence key for enemy
  Default_Hurt      = "K-hurt"    # Hit sequence key
  Default_Return    = "RESET"     # Return sequence key
  Default_Dead      = "K-dead"    # Dead sequence key
  Default_Victory   = "K-victory" # Victory sequence key
  
  Aim_Target        = "Aim_Target"
  
  Default_Escape    = "ESCAPE"    # Escape sequence key
  Default_Intro     = ""            # Intro sequence key
  Default_ACounter  = "Sol_Counter" # Counter attack for actor
  Default_ECounter  = "ECounter"    # Counter attack for enemy
  Default_SkillSequence = ["ATTACK"] # Default sequence for skill
  Default_ItemSequence  = ["K-Item"] # Default sequence for item
# =============================================================================
#                             ACTION SEQUENCES
# =============================================================================
%Q{

  Third part : Action Sequences
 
  Here u can define battler movement for actor and enemy.
  Get ready because there will be a mass instructions from here. so far there 
  are 34 modes you can use for sequence. Here is the list :
  
  Initial release v1.0
  
  1)  :pose             >> To change pose
  2)  :move             >> To move into defined coordinates
  3)  :slide            >> To slide from current coordinates
  4)  :goto_oripost     >> To back into origin position
  5)  :move_to_target   >> To move into target
  6)  :script           >> To run a script
  7)  :wait             >> Wait before next sequence
  8)  :target_damage    >> Deal damage on target
  9)  :show_anim        >> show animation on target
  10) :cast             >> show aninmation on user
  11) :visible          >> set up visibility
  12) :afterimage       >> to turn afterimage on/off
  13) :flip             >> flip battler
  14) :action           >> call pre-defined action sequence
  15) :projectile       >> throw a projectile
  16) :proj_setup       >> set up projectile
  17) :user_damage      >> damage on user
  18) :lock_z           >> lock z coordinates. Lock shadow as well
  19) :icon             >> show an icon
  20) :sound            >> play a SE
  21) :if               >> for branch condition
  22) :timed_hit        >> timed hit function <beta>
  23) :screen           >> modify screen
  24) :add_state        >> add state on target
  25) :rem_state        >> remove state on target
  26) :change_target    >> change target
  27) :show_pic         >> show a picture <not-tested>
  28) :target_move      >> move target into defined coordinates
  29) :target_slide     >> slide target from their position
  30) :target_reset     >> reset target to origin position
  31) :blend            >> change blend type of user
  32) :focus            >> hid any non target battlers
  33) :unfocus          >> show all hidden battler 
  34) :target_lock_z    >> to lock z coordinate of target. Also lock its shadow
  
  Update v1.1
  35) :anim_top         >> to play animation always in front of screen
  36) :freeze           >> to freeze all non active movement <not-tested>
  37) :cutin_start      >> to show cutin picture
  38) :cutin_fade       >> to give fadein/fadeout effect on cutin
  39) :cuitn_slide      >> to slide cutin picture
  40) :target_flip      >> to flip target
  41) :plane_add        >> to add looping picture
  42) :plane_del        >> to remove looping picture
  43) :boomerang        >> to add boomerang effect on projectile
  44) :proj_afimage     >> to give an afterimage effect on projectile
  45) :balloon          >> to show an balloon icon on battler
  
  Update v1.2
  46) :log              >> To give a text on battle log
  47) :log_clear        >> To clear battle log message
  48) :aft_info         >> To set up afterimage effect
  49) :sm_move          >> Smooth move to specific coordinate
  50) :sm_slide         >> Smooth slide from current position
  51) :sm_target        >> Smooth move to target
  52) :sm_return        >> Smooth move back to original position
  
  Update v1.3
  53) :loop             >> Call action sequence in n times
  54) :while            >> Call action sequence while the condition is true
  55) :collapse         >> Call default collapse effect
  56) :forced           >> Force target to change action key
  57) :anim_bottom      >> Play animation behind battler
  58) :case             >> Branched action condition more than 2
  59) :instant_reset    >> Instantly reset battler position
  60) :anim_follow      >> Make animation follow battler
  61) :change_skill     >> Change carried skill for easier use
  
  Update v1.3b
  62) :check_collapse   >> To perform collapse effect to target if dead
  63) :reset_counter    >> To reset damage counter
  64) :force_hit        >> To make next damage will be always hit
  65) :slow_motion      >> To make slow motion effect
  66) :timestop         >> To freeze the screen for certain frames

  Update v1.3c
  67) :one_anim         >> One animation display for area attack
  68) :proj_scale       >> Scale the damage for projectile
  69) :com_event        >> Call common event during action sequence
  70) :scr_freeze       >> Freeze screen from update
  71) :scr_trans        >> Perform screen transition
  
  Update v1.4
  72) :force_evade      >> Force target to evade
  73) :force_reflect    >> Force target to reflect magic
  74) :force_counter    >> Force target to counter
  75) :force_critical   >> Force criticaly hit to target
  76) :force_miss       >> Force miss target
  77) :backdrop         >> Change Battlebacks
  78) :back_trans       >> Backdrop Change transition
  79) :reset_backdrop   >> Reset battleback
  80) :target_focus     >> Custom target focus
  81) :scr_fadeout      >> Fadeout screen
  82) :scr_fadein       >> Fadein screen
  83) :check_cover      >> Check battler cover
  84) :stop_move        >> Stop movement for self if moving
  85) :rotate           >> Rotate battler
  86) :fadein           >> Self fadein
  87) :fadeout          >> Self fadeout
  88) :immortal         >> Immortal flag
  89) :end_action       >> Force end action
  90) :shadow           >> Shadow visibility
  91) :autopose         >> Make an automatic pose
  92) :icon_file        >> Call icon from specific graphic
  
  ===========================================================================
  *) create an action sequence
  ---------------------------------------------------------------------------
  to add new action sequence, do it by this format :
 
  "Action Key" => [
  [loop?, Afterimage?, Flip?], <-- replace with true / false (needed)
  [:mode, param1, param2], <-- don't forget comma!
  [:mode, param1, param2],
  [:mode, param1, param2],
  ....
 
  ], <-- comma too!
 
  Note :
  > loop?
    will the sequence looping? use true for idle, dead, or
    victory pose. Not effect on skill or else.
   
  > Afterimage?
    use afterimage on the sequence?
    when true the skill will use afterimage.
   
  > Flip?
    Will the battler flipped ? when true battler will be flipped. when false, 
    battler won't be flipped.
    
    When nil / empty, battler will adjust itself to flip value from previous 
    action sequence. Only apply for skill sequence though
    
    When nil / empty for non-skill action sequence, battler will adjust itself
    to original value (actor won't be flipped. Enemy is depends on how do you
    set them up. Do you put <flip> tag or not)
   
  > :mode
    Sequence mode which I already wrote above
   
  > param1, param2
    parameter of each mode. each mode has different parameters
    make sure you read it carefully.
    
  ===========================================================================
  1)  :pose   | Change battler pose
  ---------------------------------------------------------------------------
  Format --> [:pose, number, cell, wait, (icon)],
 
  Note :
  This mode to change pose of battler from first cell into other cell
 
  Parameters :
  number  >> Is a number from the picture name. Like Ralph_1, Ralph_2
  cell    >> is a cell frame from spriteset. Example if you use
             3 x 4  spriteset, then from top left is 0 until 11 in bottom right
             If you use a very long spriteset, 
             you can input with "cell(row, column)"
             (without quotation of kors)
  wait    >> Wait before next sequence in frames
  icon    >> Icon key write between quotes ("example"). Icon here
             is used to call icon sequence from first part.
             if you dont want to show any, you can leave it empty
             
  Example :
  [:pose, 1, 1, 25],
  [:pose, 1, cell(1,2), 25],
  [:pose, 1, 1, 25, "Swing"],
  
  ===========================================================================
  2)  :move   | Move to a specified coordinates
  ---------------------------------------------------------------------------
  Format --> [:move, x, y, dur, jump, (height)],
 
  Note :
  This mode to move battler into a specified coordinates
 
  Parameters :
  x       >> X axis destination
  y       >> Y axis destination
  dur     >> duration in frames smaller number, faster movement
  jump    >> Jump. Higher number higher jump
  height  >> height location. Related with shadow placement (optional)
 
  Example :
  [:move, 150, 235, 60, 20],
  
  ===========================================================================
  3)  :slide   | Slide few pixel aside
  ---------------------------------------------------------------------------
  Format --> [:slide, x, y, dur, jump, (height)],
 
  Note :
  This mode to slide battler few pixel from origin coordinates based on what
  have you input into.
 
  Parameters :
  x     >> X axis displacement
  y     >> Y axis displacement
  dur   >> duration in frames smaller number, faster movement
  jump  >> Jump. Higher number higher jump
  height  >> height location. Related with shadow placement (optional)
 
  Example :
  [:slide, -100, 0, 25, 0],
  
  Note :
  If battler is flipped, then X coordinate will be flipped as well. In other
  word, regulary minus value of x means to be left. If battler flipped, then
  it means to be right (uh, I hope u understand what I'm trying to say)
  
  ===========================================================================
  4)  :goto_oripost  | Back to origin position
  ---------------------------------------------------------------------------
  Format --> [:goto_oripost, dur, jump],
 
  Note :
  This mode to revert battler to origin position
 
  Parameter
  dur   >> duration in frames smaller number, faster movement
  jump  >> Jump. Higher number higher jump
 
  Example :
  [:goto_oripost, 10, 20],
  
  ===========================================================================
  5)  :move_to_target  | Relative move to target
  ---------------------------------------------------------------------------
  Format --> [:move_to_target, x, y, dur, jump, (height)],
 
  Note :
  This mode to move battler to their target
 
  Parameters :
  x       >> X axis relative to target
  y       >> Y axis relative to target
  dur     >> duration in frames smaller number, faster movement
  jump    >> Jump. Higher number higher jump
  height  >> height location. Related with shadow placement (optional)
 
  Example :
  [:move_to_target, 130, 0, 25, 0],
  
  Note 1:
  If battler is flipped, then X coordinate will be flipped as well. In other
  word, minus value of x means to be left. If battler flipped, then it means to
  be right (uh, I hope u understand what I'm trying to say)
  
  Note 2:
  If the target is area attack, then the action battler will move to the center
  of the targets
  
  ===========================================================================
  6)  :script   | Run a script call
  ---------------------------------------------------------------------------
  Format --> [:script, "script call"]
 
  Note :
  "script call" Is a content for a script call. Write it between quotes
 
  example :
  [:script, "$game_switches[1] = true"],
  
  ===========================================================================
  7)  :wait   | Waiting time in frames
  ---------------------------------------------------------------------------
  Format --> [:wait, frame],
 
  Note :
  Frame is a number used for waiting time in Frames. To be note that 60 
  frames is equal as 1 second
 
  Example :
  [:wait, 60],
  
  ===========================================================================
  8)  :target_damage   | Apply skill/item on target
  ---------------------------------------------------------------------------
  Format --> [:target_damage, (option)],
 
  Note :
  Option is a command to modify skill/item which will be used.
  There is 3 option you can use. You can leave it empty if you don't need
  it.
 
  - Formula
  Define skill with new formula. Formula must be write between quotes ("")
 
  - Skill ID
  You can change skill by using option.
 
  - Damage Rate
  You can change damage rate of the skill. Which will be double, 
  or half by inputing fraction number / float on option
 
  Example :
  [:target_damage],                            << Default
  [:target_damage, "a.atk * 10 - b.def * 5"],  << Custom formula
  [:target_damage, 10],                        << Apply other skill
  [:target_damage, 1.5],                       << Damage scale
  
  ===========================================================================
  9)  :show_anim   | Run animation on target
  ---------------------------------------------------------------------------
  Format --> [:show_anim, (anim_id), (flip?), (ignore anim guard?)],
 
  Note :
  - Anim_id is an optional option. You can define certain sequence will play
  which animation. Ignore this, then sequence will play default
  animation on skill / weapon you have set in database
 
  - Flip. Will the animation gonna be flipped? Ignore this if not needed
 
  - Ignore anim guard is to ignore animation guard animation from target 
 
  Example :
  [:show_anim],
  [:show_anim, 25],  << Play animation ID 25
  [:show_anim,116,false,true],
  
  ===========================================================================
  10) :cast   | Run animation on user
  ---------------------------------------------------------------------------
  Format --> [:cast, (anim_id), (flip)]
 
  Note :
  Like show anim. But the target is user. if anim_id is commited or nil, it
  is same as skill animation in database
  
  Flip is to flip animation which gonna be played. Default is same as battler
  flip value
 
  example :
  [:cast],  << Run animation from used skill / item
  [:cast, 25],  << Run animation ID 25 from database
  [:cast, 25, true],  << Run animation ID 25 from database and flip the anim
  
  ===========================================================================
  11) :visible   | Set up battler visibility
  ---------------------------------------------------------------------------
  Format --> [:visible, true/false],
 
  Note :
  Parameter of visibility mode is only 1. And it is enough by inputing true
  or false. When true, battler will be shown. False, battler will be hiden
 
  Example :
  [:visible, true],
  [:visible, false],
  
  ===========================================================================
  12) :afterimage   | Turn on afterimage effect
  ---------------------------------------------------------------------------
  Format --> [:afterimage, true/false],
 
  Note :
  Parameter mode of afterimage like on visible mode. Only applied by true or
  false
 
  Example :
  [:afterimage, true],
  [:afterimage, false],
  
  ===========================================================================
  13) :flip   | Flip battler sprite horizontaly
  ---------------------------------------------------------------------------
  Format --> [:flip, (option)],
 
  Note :
  There are 3 options to flip battler sprite. Those are:
  >> true     - to Flip
  >> false    - to not Flip or return it to original
  >> :toggle  - To flip sprite based on last condition
 
  Note :
  [:flip, true],
  [:flip, false],
  [:flip, :toggle],
  
  ===========================================================================
  14) :action   | Call a pre-defined action
  ---------------------------------------------------------------------------
  Format --> [:action, "key"],
 
  Note :
  Action mode is to combine action sequence. So you can just make a template
  and you can combine it with others just by calling it.
 
  Key is a sequence key of the sequence which will be combined
  
  example :
  [:action, "Magic Cast"],
  [:action, "Firebolt"],
  
  ===========================================================================
  15) :projectile   | Throw a projectile
  ---------------------------------------------------------------------------
  Format --> [:projectile, anim_id, dur, jump, (icon), (angle_speed)],
 
  Note :
  Like a target damage mode. But in projectile form. when projectile reach the
  target, then target will be damaged.
 
  The parameters are :
  anim_id     >> Animation id which will be display on projectile.
  dur         >> Duration in frames.
  jump        >> Jump.
  icon        >> Icon ID, or string/text which will be defined as a script
  angle_speed >> Rotation speed of an icon
 
  Note :
  [:projectile, 110, 10, 0, 0, 0],
  [:projectile, 0, 10, 20, 188, 0],
  [:projectile, 0, 10, 0, 147, 90],
  [:projectile, 0, 20, 10, "item_in_use.icon_index", 90],
  
  ===========================================================================
  16) :proj_setup   | set up projectile
  ---------------------------------------------------------------------------
  Format --> [:proj_setup, start, end],
 
  Note :
  This mode to set up projectile. Recommended to call this before :projectile
  to set up a projectile whch will be thrown
 
  Start >> Projectile origin location from user
  End   >> projectile destination (target)
 
  Input start and end with these formula
  :head   >> Target on upper part (head)
  :middle >> Target on mid part (body)
  :feet   >> Target on feet part (feet)
 
  example :
  [:proj_setup, :middle, :feet],
  
  ########################### Update Version 1.4 ##############################
  
  Format -> [:proj_setup, {}],
  
  In newest version, you have more options to use this command. However, it's
  still valid if you want to use the old model configuration like the one above.
  How to use this command in newer version is to use this following format.
  
  [:proj_setup, {:option => value, :option2 => value}],
  [:projectile, ....],
  
  Or something like this
  
  [:proj_setup, {
    :option1 => value,
    :option2 => value,
    :option3 => value,
  }],
  [:projectile, ....],
  
  Where those options are :
  
  #############################################################################
  PLACEMENT SETTINGS :
  >> :start       | Start point position of the projectile
  >> :end         | End point position of the projectile
  >> :start_pos   | Relative position from start point
  >> :end_pos     | Relative position from end point
  ----------------------------------------------------------------------------
  Note for start/end point :
  To set the start/end point of the projectile, you need to select the value
  from these given options :
  
  :head   => Top of the sprite (head)
  :middle => Middle of the sprite (body)
  :feet   => Bottom of the sprite (feet)
  :none   => No reference. You need to specify yourself
  :self   => End point reference same as start point. This :self is used 
             together with :end_pos. Also this value only valid for :end
  Example :
  [:proj_setup, {:start => :middle, :end => :head}],
  
  Note for relative point setup :
  Relative point is displacement from the original point. For example, you want
  the projectile start point is in front of the battler
  
  Parameter format
  :start_pos  => [x, y],
  :end_pos    => [x, y],
  
  Example
  [:proj_setup,{
    :start => :middle,
    :start_pos => [-25, 0],
  }],
  
  [:proj_setup,{
    :start => :middle,
    :end => :self,
    :end_pos => [0, -100],
  }],
  
  ----------------------------------------------------------------------------
  >> :reverse     | Reverse start/end point
  ----------------------------------------------------------------------------
  Note :
  This option is to reverse the projectile start/end point where the projectile
  launched from the target to subject. You only need to put this option to true
  
  Example :
  [:proj_setup,{
    :reverse => true,
  }],
  
  #############################################################################
  ANIMATION SETTINGS :
  >> :anim_start  | Play animation on start point
  >> :anim_end    | Play animation on end point
  ----------------------------------------------------------------------------
  Note :
  This option is to allow you to play animation on projectile start/end
  
  Example :
  [:proj_setup, {
    :anim_start => 10,
    :anim_end => 11,
  }],
  
  Using the setting above, when the projectile created, it will play animation
  ID 10 and when it reached its target, it will play animation ID 11. If you
  want the animation ID is same as the skill, use :default
  
  Example :
  [:proj_setup, {
    :anim_start => 10,
    :anim_end => :default,
  }],
  
  ----------------------------------------------------------------------------
  >> :anim_pos    | Projectile animation position
  ----------------------------------------------------------------------------
  Note :
  If you use the projectile graphic is from the animation database, you could
  set whether the animation will be displayed always on top, or relative where
  if any other battler has larger Y position will be displayed over the 
  animation. Put the value between [-1: Behind],[0:n Normal],[1: Always on top]
  
  Example :
  [:proj_setup, {
    :anim_pos => 1,
  }],
  
  ----------------------------------------------------------------------------
  >> :anim_hit    | Play animation only when hit
  ----------------------------------------------------------------------------
  Note :
  This option is to make the animation only played when the target succesfully
  get hit by the projectile. To use this option, put the value to true
  
  Example :
  [:proj_setup, {
    :anim_hit => true,
  }],
  
  ----------------------------------------------------------------------------
  >> :flash       | Flash reference
  ----------------------------------------------------------------------------
  Note :
  This option is to support the :anim_start and :anim_end. If you're using
  "flash target" in animation database, the flashing sprite will be redirected
  to the subject who throw the projectile and/or the target
  
  Format --> :flash => [subj, target] 
  Change it to true or false
  
  Example :
  [:proj_setup, {
    :anim_start => 10,
    :anim_end => 11,
    :flash => [true, true],
  }],
  
  #############################################################################
  MOVEMENT SETTINGS :
  >> :pierce      | Keep the movement after hit
  >> :boomerang   | Boomerang. Return to subject after hit the target
  >> :wait        | Wait before launched within the given time duration
  ----------------------------------------------------------------------------
  Note :
  As I described above. :pierce will make the projectile keep moving after
  hitting the target. While :boomerang will make the projectile return to the
  subject. And wait is to make the projectile wait within the given frame 
  before launched
  
  Examples :
  [:proj_setup,{
    :pierce => true,
    :wait => 25,
  }],
  
  [:proj_setup,{
    :boomerang => true,
    :wait => 25,
  }],
  
  #############################################################################
  EFFECT SETTINGS :
  >> :aftimg      | Toggle on afterimage
  >> :aft_opac    | Opacity easing per frame
  >> :aft_rate    | Afterimage clone ratio
  ----------------------------------------------------------------------------
  Note :
  - Those three settings are for set the afterimage effect. :aftimg is the
    afterimage toggler. If you put it to true, projectile will dislay the
    afterimage effect.
  - While :aft_opac is for the speed of opacity easing for each afterimage
    graphics per frame. If you put 25, then the opacity of each afterimage will
    be reduced by 25 / frame
  - While :aft_rate is the clone ratio. The smaller value, the thicker it will
    be. The minimul value is 1.
  - As a side note. Afterimage can only be seen if you use icon as the 
    projectile image. Not the animation.
  
  Example :
  [:proj_setup, {
    :aftimg => true,
    :aft_opac => 19,
    :aft_rate => 1,
  }],
  
  ----------------------------------------------------------------------------
  >> :angle       | Starting angle
  ----------------------------------------------------------------------------
  Note :
  This option is for the starting angle of the projectile if you want to use
  projectile from icon. For example, the starting angle is 90 degree
  
  Example :
  [:proj_setup, {
    :angle => 90,
  }],
  
  #############################################################################
  DAMAGE SETTINGS :
  >> :damage      | Damage execution
  >> :scale       | Damage scale
  ----------------------------------------------------------------------------
  Note :
  - The :damage setting is to set the damage execution behaviour. Put the value
    between -1, 0, or 1 within these rules
  
    >> -1: Damage will be executed when projectile started to move
    >>  0: Target receive no damage / no damage will be executed
    >>  1: Damage execution on end (default)
    
  - The :scale setting is for projectile damage scale just like [:target_damage]
    command. You have to put the float number like 0.5
    
  Example :
  [:proj_setup, {
    :damage => -1,
    :scale => 0.5,
  }],
  
  #############################################################################
  MODIFICATION :
  >> :change      | Change flag
  ----------------------------------------------------------------------------
  Note :
  Actually everytime you setup the projectile, the setup will be reseted back 
  and previous setup is not valid anymore.
  
  Example :
  [:proj_setup, {
    :start_pos => [-25, 0],
    :anim_start => 10,
  }],
  [:projectile, ...],
  [:proj_setup, {:start_pos => [0, -25]}],
  [:projectile, ....],
  
  The second projectile wont have :anim_start 10 since it reseted back each
  time you call :proj_setup.
  
  How to overcome this problem, you could use :change option like this
  [:proj_setup, {
    :start_pos => [-25, 0],
    :anim_start => 10,
  }],
  [:projectile, ...],
  [:proj_setup, {
    :start_pos => [0, -25],
    :change => true,
  }],
  [:projectile, ....],  
  
  ===========================================================================
  17) :user_damage   | Damage on user -(SCRAPPED!)
  In version 1.4 or more this function is no longer avalaible
  ---------------------------------------------------------------------------
  
  Instead, you could use this
  [:change_target, 11],
  [:target_damage],  
  
  ===========================================================================
  18) :lock_z   | Lock Z coordinates. Lock shadow as well
  ---------------------------------------------------------------------------
  Format --> [:lock_z, true/false],
 
  Note :
  Z coordinates is a coordinates to define which sprite is nearest to player's
  screen. In TSBS Z coordinates are dynamic. Sprite with most y coordinates 
  (most bottom) also got the highest Z coordinates value.
 
  If a sprite move to upper part in screen, Then z coordinates can be dropped. 
  To prevent it, you can lock z coordinates with certain conditions
 
  Z coordinates affecting battler shadow. If you lock it, then battler's shadow 
  also won't move
 
  Example :
  [:lock_z, true],
  [:lock_z, false],
  
  ===========================================================================
  19) :icon   | Show an icon
  ---------------------------------------------------------------------------
  Format --> [:icon, "key"],
 
  Note :
  like a :pose command. just this one independent not affected by :pose mode
 
  Example :
  [:icon, "Swing"],
  
  ===========================================================================
  20) :sound  | Play a Sound effect
  ---------------------------------------------------------------------------
  Format --> [:sound, name, vol, pitch],
 
  Note :
  This mode to play a sound effect
 
  Parameters :
  name  >> Name of SE which present on folder Audio/SE
  vol   >> Volume SE which will be played
  pitch >> Pitch SE which will be played
 
  Example :
  [:sound, "absorb", 100, 100],
  
  ===========================================================================
  21) :if | Branched condition
  ---------------------------------------------------------------------------
  Format --> [:if, script, act_true, (act_false)],
  
  Note :
  To make a branched sequence. Wrong script call will throw an error. So be
  careful, kay?
  
  Parameters :
  script    >> Is a String / Text will be evaluated as script. 
  Act_true  >> Action key will be called if the condition is true
  Act_false >> Action key will be called if the condition is false. Can be
               ommited if not necessary
  
  Example :
  [:if, "$game_switches[1]", "Suppa-Attack"],
  [:if, "$game_switches[1]", "Suppa-Attack","Normal-Attack"],
  
  --------------------
  Alternative :
  --------------------
  If you don't want to make a new action sequence only for single sequence, you
  could directly put a new array inside branched condition
  
  
  Example :
  [:if, "$game_switches[1]", [:target_damage]],
  [:if, "$game_switches[1]", [:target_damage], [:user_damage]],
  
  --------------------
  Another alternative :
  --------------------
  If you don't want to make a new action sequence only for branched sequence,
  you could put new sequence directly on the branch without making new action
  key sequence.
  
  
  Example, taken from Soleil normal attack (sample game):
  [:if,"target.result.hit?",
    [ 
    [:target_slide, -5, 0, 3, 0],
    [:slide,-5, 0, 3, 0],
    ],
  ], 
  
  ===========================================================================
  22) :timed_hit  | Built-in timed hit function
  ---------------------------------------------------------------------------
  Format --> [:timed_hit, count],
 
  Note :
  Inspired from Eremidia: Dungeon!. Timed hit is a function when player hit a
  certain button in a correct timing, then player will get a reward.
  Like a skill damage become double.
 
  This mode must be followed by [:if] where parameter is
  [:if, "@timed_hit", "Suppa-Attack"],
 
  Parameters :
  Count is a timing chance for player to hit confirm / C in frames.
  (And only confirm button)
 
  Example :
  [:timed_hit, 60],
  [:wait, 60],  <-- You could change it to :pose
  [:if, "@timed_hit", "Suppa-Attack"],
 
  ########################### Update Versi 1.4 ##############################
  
  In updated version 1.4 now you could make the timed hit function uses 
  different buttons. You also could check if the player press :SHIFT, :C or
  any other buttons by using this way
  
  [:timed_hit, 60, :SHIFT] <-- One button
  [:timed_hit, 60, [:SHIFT, :C, :B]] <-- Many buttons
  
  By using conditional branch, all you need to do is to put check condition like
  "@timed_hit == :SHIFT". It's recommended to use :case command if you're using
  many buttons
  
  [:case, {
    "@timed_hit == :SHIFT" => "Do Something",
    "@timed_hit == :Z" => "Do Something",
  }],
  
  Nb : Command :case explanation is provided on other part
  
  You could aslo specify the animation that will be played on battler when the
  player successfuly press the button in right timing by putting the third
  parameter as animation ID
  
  Exmaple :
  [:timed_hit, 10, :C, 10],
  
  Animation ID 10 will be played if the player press the button in right timing
  
  ===========================================================================
  23) :screen | modify screen
  ---------------------------------------------------------------------------
  Format --> [:screen, submode, param1, param1],
 
  Note :
  This mode to modify screen. there are submode in :screen mode. those are :
 
  :tone       >> like a tint screen on event
  :shake      >> like a shake screen on event
  :flash      >> like a flash screen on event
  :normalize  >> Revert tint to original
 
  --------------------------------------------------
  Parameter (:tone)
  Format --> [:screen, :tone, tone, dur],
  - Tone  >> Tone.new(red, green, blue, gray)
  - dur   >> Duration of tone changes in frames
 
  Example :
  [:screen, :tone, Tone.new(120, 90, 0, 0), 60]
 
  --------------------------------------------------
  Parameter (:shake)
  Format --> [:screen, :shake, power, speed, dur],
  - power >> Shake strength
  - shake >> Shake speed
  - dur   >> Duration of shake in frames
 
  Example :
  [:screen, :shake, 5, 10, 60],
 
  --------------------------------------------------
  Parameter (:flash)
  Format --> [:screen, :flash, color, dur],
  - color >> Color.new(red, green, blue, alpha)
  - dur   >> Duration of flash in frames
 
  Example :
  [:screen, :flash, Color.new(255,255,255,128), 60],
 
  --------------------------------------------------
  Parameter (:normalize)
  Format --> [:screen, :normalize, dur],
  - dur   >> to revert screen into original
 
  example :
  [:screen, :normalize, 60],
  
  ===========================================================================
  24) :add_state  | Add state on target
  ---------------------------------------------------------------------------
  Format --> [:add_state, state_id, (chance), (ignore_rate?)],
  
  Note :
  Like the name. This mode to apply state based on chance on target.
  
  Parameters :
  state_id  >> State id from database
  chance    >> Chance / opportunity. write between 1 ~ 100 or 0.0 ~ 1.0. The
               default value is 100 if ommited
  ignore_rate >> To ignore state rate features from database. Pick between true
                 or false. The default is false if ommited
  Example :
  [:add_state, 10],
  [:add_state, 10, 50],
  [:add_state, 10, 50, true],
  
  ===========================================================================
  25) :rem_state  | Remove state on target
  ---------------------------------------------------------------------------
  Format --> [:rem_state, state_id, (chance)],
  
  Note :
  Like the name. This mode to remove state based on chance on target.
 
  Parameter :
  state_id  >> State id from database
  chance    >> Chance / opportunity. write between 1-100. or 0.0 ~ 1.0. The
               default value is 100 if ommited
 
  Example :
  [:rem_state, 10],
  [:rem_state, 10, 50],
  
  ===========================================================================
  26) :change_target  | Change target *u don't say*
  ---------------------------------------------------------------------------
  Format --> [:change_target, option],
 
  Note :
  This mode to change target in the mid of action sequence. 
  there are 11 mode here. there are :
 
  0   >> Revert to original target (target from database)
  1   >> Target all (allies + enemies)
  2   >> Target all (allies + enemies) except user
  3   >> All enemies
  4   >> All enemies except current target
  5   >> All allies
  6   >> All allies except user
  7   >> Next random enemy
  8   >> Next random ally
  9   >> Absolute random target for enemies
  10  >> Absolute random target for allies
  11  >> Self
 
  Example :
  [:change_target, 0],
  [:change_target, 1],
  [:change_target, 2],
  [:change_target, 3],
  [:change_target, 4],
  [:change_target, 5],
  [:change_target, 6],
  [:change_target, 7],
  [:change_target, 8],
  [:change_target, 9,  3],  <-- 3 absolute random target for enemies
  [:change_target, 10, 3],  <-- 3 absolute random target for allies
  [:change_target, 11],
 
  Note :
  Absolute target is a fixed target. Target won't get hit twice like default
  random target in database does. However, absolute target doesn't affected
  by TGR. So all battlers are threated equally
  
  ===========================================================================
  27) :show_pic
  ---------------------------------------------------------------------------
  
  Scrapped this function n version 1.4
  Well, use common event to display the pic instead ~
  
  ===========================================================================
  28) :target_move  | Move target in certain coordinates
  ---------------------------------------------------------------------------
  Format --> [:target_move, x, y, dur, jump, (height)],
 
  Note  :
  This mode to move target into certain coordinates. Like a move mode but the
  subject is the current target
 
  Parameter :
  x       >> X axis destination
  y       >> Y axis destination
  dur     >> Duration in frames. Smaller number, faster movement
  jump    >> Jump. Higher number, higher height as well
  height  >> height location. Related with shadow placement (optional)
 
  Example :
  [:target_move, 200,50,25,0],
  
  ===========================================================================
  29) :target_slide | slide targets from their coordinates
  ---------------------------------------------------------------------------
  Format --> [:target_side, x, y, dur, jump, (height)],
 
  Note :
  This mode is to slide target. Like slide mode but the subject is the current
  target
 
  Parameter :
  x       >> X axis displacement
  y       >> Y axis displacement
  dur     >> Duration in frames
  jump    >> Jump
  height  >> height location. Related with shadow placement (optional)
 
  example :
  [:target_slide, 200,50,25,0],
  
  ===========================================================================
  30) :target_reset  | Return target to their origin location
  ---------------------------------------------------------------------------
  Format --> [:target_reset, dur, jump]
 
  Note :
  Like goto_oripost. But for a target
 
  Parameter :
  dur   >> Duration in frames
  jump  >> Jump
 
  Example :
  [:target_reset, 5, 0],
  
  ===========================================================================
  31) :blend  | To change blend type of battler
  ---------------------------------------------------------------------------
  Format --> [:blend, type]
 
  Note :
  To change blend type of battler
 
  Type with these option
  0 >> Normal
  1 >> Addition (bright)
  2 >> Substract (dark)
 
  Example :
  [:blend, 0],
  [:blend, 1],
  [:blend, 2],
  
  ===========================================================================
  32) :focus  | To hid battlers which are not target
  ---------------------------------------------------------------------------
  Format --> [:focus, dur, (color)],
 
  Note :
  this mode is to hide target which are not target and user. So the action only 
  focus on subject and their target

  Parameter :
  dur   >> fadeout duration in frames
  color >> Color.new(red, green, blue, alpha)
 
  Example :
  [:focus, 30],
  [:focus, 30, Color.new(0,0,0,128)],
  
  ===========================================================================
  33) :unfocus  | To show all battler
  ---------------------------------------------------------------------------
  Format --> [:unfocus, dur],
  
  Note :
  Like focus. But this mode to cancel focus effect. 
  Must be called after using focus effect
 
  Parameter :
  dur >> Fadein duration in frames
 
  Example :
  [:unfocus, 30],
  
  ===========================================================================
  34) :target_lock_z  | Temporary lock Z coordinates of target
  ---------------------------------------------------------------------------
  Format --> [:target_lock_z, true/false]
 
  Note :
  Like :lock_z but only applied on target
 
  Example :
  [:target_lock_z, true],
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.1
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================
  35) :anim_top   | To play animation always in front of screen
  ---------------------------------------------------------------------------
  Format --> [:anim_top, (true/false)]
 
  Note :
  Flag to make animation played in front of screen. Put it before :cast or 
  :show_anim and set it to false afterward
 
  Example :
  [:anim_top],
  [:cast],
  [:anim_top, false],
 
  [:anim_top],
  [:show_anim],
  [:anim_top, false],

  ===========================================================================
  36) :freeze | To freeze all movement but the active ones <not-tested>
  ---------------------------------------------------------------------------
  Format --> [:freeze, true/false]
  
  Note :
  To stop all update movement but the battler in action. 
  Don't forget to set it to false after the skill is over
 
  Example :
  [:freeze, true],
  [:freeze, false],
 
  Note :
  Note yet tried, there might be a glitch or such
  
  ===========================================================================
  37) :cutin_start | To show a cutin picture
  ---------------------------------------------------------------------------
  Format --> [:cutin_start, file, x, y, opacity]
  
  Note :
  To show actor's cutin picture. But can be used to show a pic. 
  Because I make it to show cutin pic to start with, then i name it 
  :cutin_start
 
  Parameters :
  file    >> File picture name, must be in Graphics/picture
  x       >> X start position
  y       >> Y start position
  opacity >> start opacity (input between 0 - 255)
 
  Example :
  [:cutin_start,"sol-cutin-nobg",100,0,0],
 
  Note :
  Only 1 picture can be shown
  
  ===========================================================================
  38) :cutin_fade | To give a fadein/fadeout effect on cutin
  ---------------------------------------------------------------------------
  Format --> [:cutin_fade, opacity, durasi]
 
  Note :
  To change opacity of cutin image to a certain value in given time duration
 
  Parameters :
  opacity >> Opacity target
  durasi  >> Change duration in frames (60 = 1 detik)
 
  Example :
  [:cutin_fade, 255, 15],
  
  ===========================================================================
  39) :cutin_slide | To slide cutin image
  ---------------------------------------------------------------------------
  Format --> [:cutin_slide, x, y, durasi]
  
  Note :
  To slide cutin image to specific coordinate displacement in given time
  duration
  
  Parameters :
  x       >> X slide value
  y       >> Y slide value
  durasi  >> Duration in frames (60 = 1 second)
  
  Example :
  [:cutin_slide, -100, 0, 30]
  
  ===========================================================================
  40) :target_flip | Flip target
  ---------------------------------------------------------------------------
  Format --> [:target_flip, true/false]
 
  Note :
  Simply to flip target
 
  Example :
  [:target_flip, true]
  [:target_flip, false]
  
  ===========================================================================
  41) :plane_add | Add looping image
  ---------------------------------------------------------------------------
  Format --> [:plane_add, file, speed_x, speed_y, (above), (dur)]
  
  Note :
  This mode to add looping effect like Fog, parallax or any similiar things.
 
  Parameter :
  file    >> Picture name must be put in Graphics/picture
  speed_x >> Scrolling speed to horizontal direction
  speed_y >> Scrolling speed to vertical direction
  above   >> Above battler? Define with true/false
  dur     >> Duration of poping picture opacity from 0 until 255 in frames. 
             Can be ignored, 2 by default
 
  Example :
  [:plane_add,"cutin-bg",35,0,false,15],
 
  Note :
  Only 1 looping picture avalaible at this time
  
  ===========================================================================
  42) :plane_del | Delete / remove looping image
  ---------------------------------------------------------------------------
  Format --> [:plane_del, durasi]
 
  Note :
  This mode to delete a looping image which called by :plane_add with a 
  duration in frames.
 
  Example :
  [:plane_del, 30],
  
  ===========================================================================
  43) :boomerang | Give boomerang effect on projectile
  ---------------------------------------------------------------------------
  Format --> [:boomerang]
 
  Note :
  Flag to define projectile which will be back to user / caster after used. 
  Use before :projectile 
 
  Example :
  [:boomerang],
  [:projectile,0,8,15,154,20],
  
  ===========================================================================
  44) :proj_afimage | Give afterimage effects on projectile
  ---------------------------------------------------------------------------
  Format --> [:proj_afimage]
 
  Note :
  Flag to set the next projectile will be thrown with afterimage effects.
  use it before :projectile
  
  Example :
  [:proj_afimage],
  [:projectile,0,8,15,154,20],
 
  If used together with :boomerang
  [:boomerang],
  [:proj_afimage],
  [:projectile,0,8,15,154,20],
  
  ===========================================================================
  45) :balloon | To show ballon icon on battler
  ---------------------------------------------------------------------------
  Format --> [:balloon, id]
 
  Note :
  Show balloon on battler
 
  Example :
  [:balloon, 1]
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.2
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================
  46) :log | To display text in battle log
  ---------------------------------------------------------------------------
  Format --> [:log, "Text"]
  
  Note :
  This sequence mode is to display text in battle log. Use "<name>" to display
  subject/battler's name
  
  Example :
  [:log, "<name> disappears!"],
  
  ===========================================================================
  47) :log_clear | To clear battle log message
  ---------------------------------------------------------------------------
  Format --> [:log_clear]
  
  Note :
  To clear battle log message. Doesn't need parameter
  
  Example :
  [:log_clear],
  
  ===========================================================================
  48) :aft_info | To set up afterimage effects
  ---------------------------------------------------------------------------
  Format --> [:aft_info, rate, fade_speed]
  
  Note  :
  It's to change afterimage effect. Such as getting thicker or change
  afterimage fading speed
  
  Parameters :
  - rate  >> Afterimage thinkness. Lower value means thicker. The minimum value
             is 1. Default value is 3.
  - fade  >> Fadeout speed of afterimage. Lower value, lower fadeout as well.
             The default value is 20.
  
  Example :
  [:aft_info, 1,10],
  
  (P.S: :aft_info stands for "afterimage information")
  
  ===========================================================================
  49) :sm_move | Smoot slide to specific coordinate
  ---------------------------------------------------------------------------
  Format --> [:sm_move, x, y, dur, (rev)]
  
  Note  :
  Same as :move. But it supports acceleration to make it seems smooth. Doesn't
  support jumping though
  
  Parameters :
  x   >> X coordinate destination
  y   >> Y coordinate destination
  dur >> Travel duration in frames
  rev >> Reverse. If you set it true, sprite will be move at maximum speed. 
         While false, sprite will be move start from 0 velocity. Default value
         is true
         
  Example :
  [:sm_move, 100,50,45],
  [:sm_move, 100,50,45,true],
  
  ===========================================================================
  50) :sm_slide | Smooth slide from current position
  ---------------------------------------------------------------------------
  Format --> [:sm_slide, x, y, dur, (rev)]
  
  Note  :
  Same as :slide. But it supports acceleration to make it seems smooth. Doesn't
  support jumping though
  
  Parameters :
  x   >> X displacement from origin coordinate
  y   >> Y displacement from origin coordinate
  dur >> Travel duration in frames
  rev >> Reverse. If you set it true, sprite will be move at maximum speed. 
         While false, sprite will be move start from 0 velocity. Default value
         is true
         
  Example :
  [:sm_slide, 100,50,45],
  [:sm_slide, 100,50,45,true],
  
  ===========================================================================
  51) :sm_target | Smooth move to target
  ---------------------------------------------------------------------------
  Format --> [:sm_target, x, y, dur, (rev)]
  
  Note  :
  Same as :move_to_target. But it supports acceleration to make it seems 
  smooth. Doesn't support jumping though
  
  Parameters :
  x   >> X displacement from target
  y   >> Y displacement from target
  dur >> Travel duration in frames
  rev >> Reverse. If you set it true, sprite will be move at maximum speed. 
         While false, sprite will be move start from 0 velocity. Default value
         is true
  
  Example :
  [:sm_target, 100,0,45],
  [:sm_target, 100,0,45,true],
  
  Note 1:
  If battler is flipped, then X coordinate will be flipped as well. In other
  word, minus value of x means to be left. If battler flipped, then it means to
  be right (uh, I hope u understand what I'm trying to say)
  
  Note 2:
  If the target is area attack, then the action battler will move to the center
  of the targets
  
  ===========================================================================
  52) :sm_return | Smooth move back to original position
  ---------------------------------------------------------------------------
  Format --> [:sm_return, dur, (rev)]
  
  Note  :
  Same as :goto_oripost. But it supports acceleration to make it seems smooth. 
  Doesn't support jumping though
  
  Parameter :
  dur >> Travel duration in frames
  rev >> Reverse. If you set it true, sprite will be move at maximum speed. 
         While false, sprite will be move start from 0 velocity. Default value
         is true
  
  Example :
  [:sm_return,30],
  [:sm_return,30,true],       

  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.3
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================  
  53) :loop | Call action key in n times
  ---------------------------------------------------------------------------
  Format --> [:loop, times, "Key"]
  
  Note  :
  Same as [:action,]. But instead of copying, you can do it in singe line.
  
  Parameters :
  times >> How many times action key will be called
  Key   >> Action Key will be called
  
  Example :
  [:loop, 3, "CastPose"],
  
  ===========================================================================  
  54) :while | Call action sequence while the condition is true
  ---------------------------------------------------------------------------
  Format --> [:while, cond, "key"]
  
  Note  :
  Similar as looping. But the action key will be repeated while the condition
  is return true
  
  Parameter :
  cond >> Kondisi salah benar dalam script
  key  >> Action key yang akan dipanggil
  
  Example :
  [:while, "$game_variables[1] < 10", "Sol_Strike"]
  
  ===========================================================================  
  55) :collapse | Call default collapse effect
  ---------------------------------------------------------------------------
  Format --> [:collapse]
  
  Note  :
  It's to display collapse effect manually if you plan to use custom collapse
  sequence. And please use ONLY for custom collapse effect
  
  Example :
  [:collapse],
  
  ===========================================================================  
  56) :forced | Force target to switch action key
  ---------------------------------------------------------------------------
  Format --> [:forced, "key"]
  
  Note  :
  Force target to switch action key. If it used within counterattack, you
  could make it as knockback effect and combo breaker if the attacker use
  multiple hit attack
  
  Parameters :
  key >> Action Key will be used to target
  
  Example :
  [:forced, "KnockBack"],
  
  ===========================================================================  
  57) :anim_bottom | Play animation behind battler
  ---------------------------------------------------------------------------
  Format --> [:anim_bottom]
  
  Note  :
  Same as [:anim_top]. But it will make the next animation will be played
  behind the battler. Call right before [:cast] or [:show_anim] and set it to
  false afterward
  
  Examples :
  [:anim_bottom],
  [:cast, 69],
  [:anim_bottom, false],
  
  [:anim_bottom],
  [:show_anim],
  [:anim_bottom, false],
  
  ===========================================================================  
  58) :case | Branched action conditions more than 2
  ---------------------------------------------------------------------------
  Format --> [:case, hash]
  
  Note  :
  Used to make branched condition more than 2. It comes in handy rather than 
  use nested if ([:if] inside [:if])
  
  Parameter :
  Hash >> Make a list of branched condition within this format
          {
            "Condition 1" => "ActionKey1",
            "Condition 2" => "ActionKey2",
            "Condition 3" => "ActionKey3",
          }
          
  Example :
  [:case, {
    "$game_variables[1] == 1" => "Action1",
    "$game_variables[1] == 2" => "Action2",
    "$game_variables[1] == 3" => "Action3",
    "$game_variables[1] == 4" => "Action4",
    "$game_variables[1] == 5" => "Action5",
  }],
  
  --------------------
  Alternative :
  --------------------
  If you don't want to make a new action sequence only for single sequence, you
  could directly put a new array inside branched condition.
  
  Example :
    [:case,{
    "state?(44)" => [:add_state,45],
    "state?(43)" => [:add_state,44],
    "state?(42)" => [:add_state,43],
    "true" => [:add_state,42],
  }],
  
  --------------------
  Another alternative :
  --------------------
  If you don't want to make a new action sequence only for branched sequence,
  you could put new sequence directly on the branch without making new action
  key sequence.
  
  Example :
  [:case,{
    "state?(44)" => [
      [:show_anim, 1],
      [:target_damage, 1],
    ],
    
    "state?(43)" => [
      [:show_anim, 1],
      [:target_damage, 1],
    ],
    
    "state?(42)" => [
      [:show_anim, 1],
      [:target_damage, 1],
    ],
    
    "true" => [
      [:show_anim, 1],
      [:target_damage, 1],
    ],
  }],
  
  Another note :
  If there are more than one condition which are true, then the top condition
  will be used.
  
  ===========================================================================  
  59) :instant_reset | Instantly reset battler position
  ---------------------------------------------------------------------------
  Format --> [:instant_reset]
  
  Note  :
  Just to instantly reset battler position (doesn't require wait to perform)
  
  Example :
  [:instant_reset],

  ===========================================================================  
  60) :anim_follow | Make animation follow battler
  ---------------------------------------------------------------------------
  Format --> [:anim_follow]
  
  Note :
  Like [:anim_top]. But it will make the next animation to follow the battler
  where it goes. Call right before [:cast] or [:show_anim] and set it to false
  afterward
  
  Example :
  [:anim_follow],
  [:cast, 69],
  [:anim_follow, false],
  
  [:anim_follow],
  [:show_anim],
  [:anim_follow, false],
  
  Won't works for screen animation

  ===========================================================================  
  61) :change_skill | Change carried skill for easier use
  ---------------------------------------------------------------------------
  Format --> [:change_skill, id]
  
  Note :
  More like [:target_damage, id]. But it doesn't deal damage. Instead, it will
  change carried skill from battler. i.e, you could rescale it the damage
  output or even change the attack formula.
  
  Example :
  [:change_skill, 13],
  [:target_damage, 0.5],
  [:wait, 15],
  [:target_damage, 1.5],
  [:wait, 15],
  [:target_damage, 0.5],
  [:wait, 15],
  
  Damage output rescale from different skill id couldn't be done by regular 
  [:target_damage]. By calling this skill, now you could
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.3b
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================  
  62) :check_collapse | To perform collapse effect to target if dead
  ---------------------------------------------------------------------------
  Format --> [:check_collapse]
  
  Note :
  Used to perform collapse to target if target is dead. In other words,
  collapse sequence will be played during action sequence. Collapse effect won't
  be played if target still alive
  
  Example :
  [:target_damage],
  [:check_collapse],
  
  ===========================================================================  
  63) :reset_counter | To reset damage counter
  ---------------------------------------------------------------------------
  Format --> [:reset_counter]
  
  Note :
  Used to reset damage counter. If the damage counter display the total hit as
  5, by calling this command, then the damage counter will be resetted back
  to 1
  
  Example :
  [:reset_counter],
  
  ===========================================================================  
  64) :force_hit | To make next damage will be always hit
  ---------------------------------------------------------------------------
  Format --> [:force_hit]
  
  Note :
  Used to make attack by the next [:target_damage] will be always hit. Call
  before the [:target_damage] is executed
  
  Example :
  [:force_hit],
  [:show_anim],
  [:target_damage],
  
  Important note :
  I might change usage of this command in later version. It might be completely
  different. Make sure keep eye on this command in later version if you want to
  use.
  
  Follow-up note version 1.4 :
  Happy news! I didn't change the command.
  
  ===========================================================================
  65) :slow_motion | To make slow motion effect
  ---------------------------------------------------------------------------
  Format --> [:slow_motion, frame, rate]
  
  Note :
  This command used to make slow motion effect.
  
  Parameters :
  Frame >> How long (in frame) slow motion will take effect?
  Rate  >> Slowdown rate. The default FPS is 60. If you put the value as 2,
           then the FPS would be dropped to 30. If you put higher value, the
           FPS would be dropped to 20, 15, 10 ...
  
  Example : 
  [:slow_motion, 30, 2],
  
  P.S :
  The reason why I didn't use Graphics.frame_rate instead is because it makes
  the game.exe screen less responsive
  
  ===========================================================================
  66) :timestop | To freeze the screen for certain frames
  ---------------------------------------------------------------------------
  Format --> [:timestop, frame]
  
  Note :
  This command is used to stop the screen for a brief time (in frames)
  
  Example :
  [:timestop, 60],
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.3c
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  ===========================================================================  
  67) :one_anim | One animation display for area attack
  ---------------------------------------------------------------------------
  Format --> [:one_anim],
  
  Note :
  It's animation flag. The next animation will be played only one if the
  current target is area target. The animation will be played in the middle
  of all targets. Put this command on before [:show_anim]. Can be used to
  projectile as well
  
  Example :
  [:one_anim],
  [:show_anim],
  
  ===========================================================================  
  68) :proj_scale | Scale the damage for projectile
  ---------------------------------------------------------------------------
  Format --> [:proj_scale, (scale / formula)],
  
  Note :
  This command is to rescale damage from projectile attack. Unlike other flag 
  which only take effect only once. This command it will take effect until you 
  explicitly remove it.
  
  You could fill it by scale like [proj_scale, 1.0], or damage formula like
  [proj_scale, "a.atk * 4 - b.def * 2"],
  
  Example :
  [:projectile, ...], # <-- this won't take the effect
  [:proj_scale, 0.5], # <-- scale damage to 50%
  [:projectile, ...], # <-- this will take the effect
  [:projectile, ...], # <-- this will take the effect
  [:proj_scale, 1.0], # <-- scale damage back to 100%
  
  ===========================================================================
  69) :com_event | Call common event during action sequence
  ---------------------------------------------------------------------------
  Format --> [:com_event, id],
  
  Note :
  This command is to call common event during action sequence. Common event
  will running while action sequence is being performed.
  
  Example :
  [:com_event, 1], # <-- this will run common event number 1
  
  ~~~~~~~~~~~~~~~~~~~
  To prevent action sequence is being continued, you could use [:while] command
  and "event_running?" as the script call check.
  
  Example :
  [:com_event, 1],
  [:while, "event_running?", "K-Idle"],
  
  While common event is running, then the sprite will perform "K-Idle" in 
  looping until the common event end.
  
  ===========================================================================  
  70) :scr_freeze | Freeze screen from update
  ---------------------------------------------------------------------------
  Format --> [:scr_freeze],
  
  Note :
  To freeze screen from update. Unlike [:freeze], this one is completely freeze
  the game screen. It must be called before you call the screen transition
  
  Example :
  [:scr_freeze], # <-- remember. It doesn't have any parameter like true/false
  
  ===========================================================================  
  71) :scr_trans | Perform screen transition
  ---------------------------------------------------------------------------
  Format --> [:scr_trans, "file", dur, (vague)],
  
  Note :
  Used to make screen transition after screen is frozen. [:scr_freeze] need to
  be called before use this command.
  
  Parameters :
  "file" >> Filename of transition picture located in Graphics/pictures
  dur    >> Transition duration in frame (60 frame = 1 second)
  vague  >> Ambiguity value. Greater value greater ambiguity. Can be omitted.
            The default value is 40
  
  Example :
  [:scr_freeze],
  [:plane_add, "magic_square01", 0, 0, false, 1],
  [:focus, 1, Color.new(0,0,0,0)],
  [:scr_trans, "Circle", 60],
  
  [:scr_freeze],
  [:plane_add, "magic_square01", 0, 0, false, 1],
  [:focus, 1, Color.new(0,0,0,0)],
  [:scr_trans, "Circle", 60, 120],

  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.4
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================  
  72) :force_evade      | To make target always evade
  73) :force_reflect    | To make target reflect magic
  74) :force_counter    | To make target always counterattack
  75) :force_critical   | To make an attack always critical hit
  76) :force_miss       | To make an attack always miss to target
  ---------------------------------------------------------------------------
  Format --> [:force_x, (true/false)],
  
  Note :
  These are "force serials" just like [:force_hit]. Put this command right 
  before [:target_damage]. For example if you put [:force_evade] then the
  target will always evade your attack. Don't forget to set to false afterward
  
  Example :
  [:if, "@timed_hit", [:force_evade]],
  
  ===========================================================================  
  77) :backdrop         | To change battle backdrops temporary
  78) :back_trans       | To set the transition of battle backdrops
  79) :reset_backdrop   | To revert back the battle backdrops
  ---------------------------------------------------------------------------
  Format --> [:backdrop, "Name1", "Name2"],
  
  Note :
  The :backdrop command is to change battlebacks. Where the 'name1' represent
  as battleback1 and so goes with 'name2'
  
  Example :
  [:backdrop, "Lava2", "Lava"],
  
  ------------------------------
  Format --> [:back_trans, {}],
  
  Note :
  This command is to setup the transition when you want to change the battle
  backdrops by using [:backdrop] command. The kind of settings is similar to
  the new [:proj_setup] with these parameters
  
  :switch   => Want to use transition? (true/false)
  :duration => Duration
  :name     => Transition file which exited on Graphics/system
  :vague    => Vague value. Larger value tend to more blurry (max. 255)
  
  Example :
  [:back_trans, {:name => "Whirlwind", :duration => 60, :vague => 180}],
  
  ------------------------------
  Format --> [:reset_backdrop]
  
  Note :
  To revert back the battlebacks to original after changed by [:backdrop]
  This command require no parameter.
  
  ===========================================================================
  80) :target_focus     | Custom target focus
  ---------------------------------------------------------------------------
  Format --> [:target_focus, (option)]
  
  Note :
  This command give you more option to set which battler will be stay on screen
  when performing [:focus] command. Put this command right before [:focus]
  
  Command ini adalah untuk memberikan opsi battler yang mana saja yang akan
  tetap ditampilkan saat command [:focus] dipanggil. Taruh command ini sebelum
  [:focus].
  
  Parameter :
  Choose between these numbers
  0 > Current target(s)
  1 > All enemies
  2 > All allies
  3 > All enemies and allies
  
  Example :
  [:target_focus, 1],
  [:focus, ...],
  
  ===========================================================================
  81) :scr_fadeout      | Fadeout screen
  82) :scr_fadein       | Fadein screen
  ---------------------------------------------------------------------------
  Format --> [:scr_fadeout, duration],
  Format --> [:scr_fadein, duration],
  
  Note :
  These command above is to make screen fadeout or fadein just like in event.
  Duration is a time duration for fade effect in frame
  
  Example :
  [:scr_fadeout, 30],
  
  ===========================================================================
  83) :check_cover  | To check if there is another battler subtituted the target
  ---------------------------------------------------------------------------
  Format --> [:check_cover],
  
  Note :
  This command is to check if the current target has substitute battler just to
  avoid some weird action sequence. Put this command before [:target_damage]
  is called or right before the projectile reach the target.
  
  Example :
  [:check_cover],
  [:wait, 10],
  [:target_damage],
  [:show_anim],
  
  ===========================================================================
  84) :stop_move        | To stop movement (if moving)
  ---------------------------------------------------------------------------
  Format --> [:stop_move],
  
  Note :
  This command is simply to stop the subject from moving
  
  Example :
  [:slide, -100, 0, 40, 10],
  [:wait, 20],
  [:stop_move],
  
  ===========================================================================
  85) :rotate           | Simply rotate the subject battler
  ---------------------------------------------------------------------------
  Format --> [:rotate, start, end, duration],
  
  Note :
  Simply rotate the subject battler
  
  Parameters
  > start     : Starting angle
  > end       : Target angle
  > duration  : Rotate duration
  
  Contoh :
  [:rotate, 0, 360, 45],
  [:rotate, 0, 360 * 4, 90], (four times spin)
  
  ===========================================================================
  86) :fadein           | To make the battler fadein
  87) :fadeout          | To make the battler fadeout
  ---------------------------------------------------------------------------
  Format --> [:fadein, duration],
  Format --> [:fadeout, duration],
  
  Note :
  These commands are to make the battler fadeout/fadein within the given time
  duration. It's recommended if you call [:fadeout] you also need to call
  [:fadein] or your battler will be fble all time
  
  Example :
  [:fadeout, 30],
  [:wait, 30],
  [:fadein, 30],
  
  ===========================================================================
  88) :immortal         | Flag the battler as immortal temporary
  ---------------------------------------------------------------------------
  Format --> [:immortal],
  
  Note :
  This command is to flag the target(s) battler as immortal. The target(s) won't
  inflicted by death state until collapse check is performed. Put this command
  before [:target_damage].
  
  You don't need to use this command if you set the AutoImmortal on config 1
  to true
  
  Example :
  [:immortal],
  [:show_anim],
  [:target_damage],
  [:wait, 45],
  [:check_collapse],
  
  ===========================================================================
  89) :end_action       | To force end / break action sequence
  ---------------------------------------------------------------------------
  Format --> [:end_action],
  
  Note :
  This command is to force the battler to end its skill sequence even it's
  still in the middle of performing action sequence
  
  ===========================================================================
  90) :shadow           | To make the shadow visible or not
  ---------------------------------------------------------------------------
  Format --> [:shadow, true / false]
  
  Note :
  This command is to make ALL the battler shadow to visible or invisible
  
  Example :
  [:shadow, true],
  [:shadow, false],

  ===========================================================================
  91) :autopose         | To make an automatic pose
  ---------------------------------------------------------------------------
  Format --> [:autopose, number, frame, wait]
  
  Note :
  This command is just to simplify of making sequence. Just like a function
  "Play all animation in row x". This command still need :wait command to
  gets its job done.
  
  Parameters :
  number  >> Is a number from the picture name. Like Ralph_1, Ralph_2
  row     >> Which row do you want to animate?
  wait    >> Delay in frame for each animation
  
  Example :
  [:autopose, 1, 1, 15],
  [:wait, 15 * 3],
  
  ===========================================================================
  92) :icon_file        | To call icon from specific graphic
  ---------------------------------------------------------------------------
  Format --> [:icon_file, file],
  
  Note :
  This command is to show icon from the graphic that existed on Graphics/system.
  If you call this command before you show the icon, then when the icon is
  shown, it will use the graphic from the filename you specified instead of
  the weapon icon itself
  
  Example :
  [:icon_file, 'Sword'],
}

# =============================================================================
  AnimLoop = { # <-- Do not touch at all cost!
# -----------------------------------------------------------------------------
# Define you own custom sequences here.
# -----------------------------------------------------------------------------
  "IDLE" => [
  #[Loop, afterimage, flip]
    [true, false],
    [:if, "self.movable?",
      [
        [:pose,     1,   0,   10],
        [:pose,     1,   1,   10],
        [:pose,     1,   2,   10],
        [:pose,     1,   1,   10],
      ],
    ],
  ],
  # ---------------------------------------------------------------------------
  # Enemy idle sequence
  # ---------------------------------------------------------------------------
  "Enemy_IDLE" => [
    [true, false, true],
    [:if, "self.movable?",
      [
        [:pose,     1,   0,   10],
        [:pose,     1,   1,   10],
        [:pose,     1,   2,   10],
        [:pose,     1,   1,   10],
      ],
    ],
  
  ],
  # ---------------------------------------------------------------------------
  # Basic attack sequence
  # ---------------------------------------------------------------------------
  "ATTACK" => [
  [false, false, nil],
  [:move_to_target, 0, 0, 10, 10],
  [:wait, 10],
  [:target_damage],
  [:show_anim],
  [:wait, 25],
  ],
  # ---------------------------------------------------------------------------
  # Move to target
  # ---------------------------------------------------------------------------
  "MOVE_TO_TARGET_FAR" => [
  [:move_to_target, 130, 0, 15, 10],
  [:pose, 1, 9, 7],
  [:pose, 1, 11, 8],
  [:pose, 1, 0, 20],
  ],
  # ---------------------------------------------------------------------------
  # Move to target
  # ---------------------------------------------------------------------------
  "MOVE_TO_TARGET" => [
  [:move_to_target, 50, 0, 15, 10],
  [:pose, 1, 9, 7],
  [:pose, 1, 11, 8],
  [:pose, 1, 0, 20],
  ],
  # ---------------------------------------------------------------------------
  # Skill cast
  # ---------------------------------------------------------------------------
  "SKILL_CAST" => [
  [:cast, 81],
  [:wait, 60],
  ],
  # ---------------------------------------------------------------------------
  # Target damage
  # ---------------------------------------------------------------------------
  "Target Damage" => [
  [:target_damage],
  [:show_anim],
  ],
  # ---------------------------------------------------------------------------
  # Use item sequence
  # ---------------------------------------------------------------------------
  "ITEM_USE" => [
  [false,false,nil],
  [:slide, -50, 0, 10, 10],
  [:wait, 30],
  [:show_anim],
  [:target_damage],
  [:wait, 60],
  ],
  # ---------------------------------------------------------------------------
  # Default reset sequence
  # ---------------------------------------------------------------------------
  "RESET" => [
  [false,false,:ori],
  [:visible, true],
  [:unfocus, 30],
  [:icon, "Clear"],
  [:camera, "Screen"],
  [:if, "@ori_x != x || @ori_y != y", # If location changed?
    [
    [:goto_oripost, 17,10],
    [:pose,1,11,17],
    ],
  ],
  ],
  # ---------------------------------------------------------------------------
  # Default escape sequence
  # ---------------------------------------------------------------------------
  "ESCAPE" => [
  [false,false,false],
  [:slide, 150, 0, 10, 25],
  [:wait, 30],
  ],
  # ---------------------------------------------------------------------------
  # Default guard sequence
  # ---------------------------------------------------------------------------
  "GUARD" => [
  [false,false],
  [:action, "Target Damage"],
  [:wait, 45],
  ],
  # ---------------------------------------------------------------------------
  # Default enemy evade
  # ---------------------------------------------------------------------------
  "E-evade" => [
  [],
  [:ignore_flip],
  [:slide, -50, 0, 14, 20],
  [:wait, 20],
  [:goto_oripost, 7, 0],
  [:wait, 7],
  ],
  #===========================================
  # Counter Attack
  #===========================================
  "Sol_Counter" => [
  [false, false, nil],
  [:move_to_target, 0, 0, 10, 10],
  [:wait, 10],
  [:target_damage],
  [:show_anim],
  [:wait, 25],
  ],
  
  }
  
end