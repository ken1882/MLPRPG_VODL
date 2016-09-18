#==============================================================================
# TSBS Addon - Battler Summon
# Version : 1.0 (Beta)
# Language : English
# Requires : Theolized SBS version 1.4
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact :
#------------------------------------------------------------------------------
# *> http://www.rpgmakerid.com
# *> http://www.rpgmakervxace.net
# *> http://www.theolized.com
#==============================================================================
($imported ||= {})[:TSBS_BattlerSummon] = true
#==============================================================================
# Change Logs:
# -----------------------------------------------------------------------------
# 2014.09.29 - Finished stable version 1.0
# 2014.09.05 - Finished initial version 0.8
#==============================================================================
%Q{

  ==================
  || Introduction ||
  ------------------
  This script addon adds new command sequence for TSBS where you could add /
  call another battler to do an action. And when the action is finished, it
  vanish afterwards
  
  In other case, you could use this to clone an actor where it's more like to
  summon him/herself and acts like a clone.
  
  ================
  || How to use ||
  ----------------
  Put this script below TSBS
  To use summon in TSBS sequence, use this format
  
  Format :
  [:summon, id, :pos, [x,y,h], skill, "action", anim_start, anim_end, (flip)]
  
  Where the parameters are :
  - id          > is an Actor / Enemy ID to be summoned. Use :clone if you want
                  to clone itself.
  
  - pos         > Relative battler position. Use :self if you want the summoned
                  battler to be appeared relative from self. Use :target if
                  you want it relative to target. And :none if you want it free.
                  
  - [x,y,h]     > It's X,Y axis and height position. Height is the distance
                  between the battler and its shadow. H can be omitted. The
                  default value is same as the battler summoner
                  
  - skill       > Is a skill 'carried' in the battler in order to deal damage.
                  Use -1 if you want the 'carried' skill is same as the original
                  summoner.
                  
  - "action"    > Action key that will be used.
  
  - anim_start  > Animation played during the start
  
  - anim_end    > Animation played during the end
  
  - flip        > Will the battler flipped? Set to true if yes, and you could
                  omitted this parameter if you want. The default value is same
                  as the original battler
                  
  Call example :
  [:summon, :clone, :self, [-75, 0], -1, "Summon_Grenade", 38, 38],
  [:summon, :clone, :target, [-105, 0], -1, "Summon_Grenade", 38, 38, true],
  
  ===================
  || Terms of use ||
  -------------------
  Credit me, TheoAllen. You are free to edit this script by your own. As long
  as you don't claim it yours. For commercial purpose, don't forget to give me
  a free copy of the game.  
  
}
#==============================================================================
# There's no configuration. Do not touch anything below this line unless you're
# pretty confident. I'm not responsible.
#==============================================================================
module TSBS
  SUMMON_COMMAND    = :summon # Command call
  SUMMON_CLONE_SELF = :clone  # Clone self
  SUMMON_POS_SELF   = :self   # Relative to self
  SUMMON_POS_TARG   = :target # Relative to target
  SUMMON_POS_NONE   = :none   # No reference
end
#==============================================================================
# * TSBS_BattlerSummon module
# These are collection of battler summon functions
#==============================================================================
module TSBS_BattlerSummon
  attr_accessor :anim_end
  attr_accessor :start_x
  attr_accessor :start_y
  #----------------------------------------------------------------------------
  # * This is the summoned object
  #----------------------------------------------------------------------------
  def summoned_object?
    return true
  end
  #----------------------------------------------------------------------------
  # * Clear TSBS
  #----------------------------------------------------------------------------
  def clear_tsbs
    super
    @start_x = 0
    @start_y = 0
  end
  #----------------------------------------------------------------------------
  # * Overwrite fiber object
  #----------------------------------------------------------------------------
  def fiber_obj
    @local_fiber
  end
  #----------------------------------------------------------------------------
  # * Overwrite fiber object
  #----------------------------------------------------------------------------
  def insert_fiber(fiber)
    @local_fiber = fiber
  end
  #----------------------------------------------------------------------------
  # * Skill sequence
  #----------------------------------------------------------------------------
  def skill_key
    @custom_action
  end
  #----------------------------------------------------------------------------
  # * Reference the param to actor param
  #----------------------------------------------------------------------------
  def param(param_id)
    return @battler_ref.param(param_id) if @battler_ref
    return super
  end
  #----------------------------------------------------------------------------
  # * Feature Objects
  #----------------------------------------------------------------------------
  def feature_objects
    return @battler_ref.feature_objects if @battler_ref
    return super
  end
  #----------------------------------------------------------------------------
  # * Start action!
  #----------------------------------------------------------------------------
  def start_action(x, y, h, item, target, targets, area, action, anim_start,
      anim_end, flip)
    @start_x = x
    @start_y = y
    @area_flag = area
    @custom_action = action
    @anim_end = anim_end
    self.animation_id = anim_start
    self.item_in_use = copy(item)
    self.target = target
    self.target_array = targets
    @start_h = h
    @flip = flip
    on_battle_start
  end
  #----------------------------------------------------------------------------
  # * On battle start
  #----------------------------------------------------------------------------
  def on_battle_start
    super
    @ori_x = @start_x
    @ori_y = @start_y
    goto(@ori_x, @ori_y, 1, 0, @start_h)
    update_move
    get_spriteset.add_summoned_battler(self)
    self.battle_phase = :skill
  end
  #----------------------------------------------------------------------------
  # * Summoned actor is an immortal object <(")
  #----------------------------------------------------------------------------
  def add_state(state_id)
    return if state_id == death_state_id
    super
  end
  #----------------------------------------------------------------------------
  # * No sequence loop
  #----------------------------------------------------------------------------
  def loop?
    return false
  end
  #----------------------------------------------------------------------------
  # * Overwrite get sprite
  #----------------------------------------------------------------------------
  def sprite
    get_spriteset.summoned_battler.find {|spr| spr.battler == self }
  end
end

#==============================================================================
# * Compatibility Flag
#==============================================================================
if $imported[:TSBS]
#==============================================================================
# * Game_Battler
#==============================================================================

class Game_Battler
  #----------------------------------------------------------------------------
  # * Is the battler summoned object?
  #----------------------------------------------------------------------------
  def summoned_object?
    return false
  end
  #----------------------------------------------------------------------------
  # * Summoned object can not be encountered
  #----------------------------------------------------------------------------
  alias tsbs_actor_summon_item_cnt item_cnt
  def item_cnt(user, item)
    return 0 if user.summoned_object?
    tsbs_actor_summon_item_cnt(user, item)
  end
  #----------------------------------------------------------------------------
  # * Custom sequence handler for this addon
  #----------------------------------------------------------------------------
  alias tsbs_actor_summon_handler custom_sequence_handler
  def custom_sequence_handler
    tsbs_actor_summon_handler
    setup_actor_summon if @acts[0] == SUMMON_COMMAND
  end
  #----------------------------------------------------------------------------
  # * Setup actor summon ~
  # [:summon, id, :pos, [x,y,h], skill, "Action", anim_start, anim_end, (flip)]
  #----------------------------------------------------------------------------
  def setup_actor_summon
    return TSBS.error(@acts[0], 7, @used_sequence) if @acts.size < 8
    if @acts[1] == SUMMON_CLONE_SELF && actor?
      id = self.id
    elsif @acts[1] == SUMMON_CLONE_SELF && enemy?
      id = self.enemy_id
    else
      id = @acts[1]
    end
    ref = @acts[2]
    xpos = @acts[3][0]
    ypos = @acts[3][1]
    hpos = @acts[3][2] || height
    item = (@acts[4] == -1 ? copy(item_in_use) : copy($data_skills[@acts[4]]))
    actkey = @acts[5]
    anim_start = @acts[6] || 0
    anim_end = @acts[7] || 0
    case ref
    when SUMMON_POS_SELF
      xpos += self.x
      ypos += self.y
    when SUMMON_POS_TARG
      if area_flag
        size = target_array.size
        xpos += target_array.inject(0) {|r,batt| r + batt.x}/size
        ypos += target_array.inject(0) {|r,batt| r + batt.y}/size
      else
        xpos += target.x
        ypos += target.y
      end
    end
    flip = (@acts[8].nil? ? self.flip : @acts[8])
    params = [xpos, ypos, hpos, item, target, target_array, area_flag, actkey, 
      anim_start, anim_end, flip]
    if actor?
      Game_ActorSummon.new(id).start_action(*params)
    else
      ref = (id == self.enemy_id ? self : nil)
      Game_EnemySummon.new(id, ref).start_action(*params)
    end
  end
  
end

#==============================================================================
# * Game_ActorSummon < Game_Actor
#==============================================================================

class Game_ActorSummon < Game_Actor
  include TSBS_BattlerSummon
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  def initialize(id)
    @battler_ref = $game_actors[id]
    @anim_end = 0
    super
  end
  #----------------------------------------------------------------------------
  # * Reference the weapons to actor weapons
  #----------------------------------------------------------------------------
  def weapons
    @battler_ref.weapons 
  end
  #----------------------------------------------------------------------------
  # * Reference the armors to actor armors
  #----------------------------------------------------------------------------
  def armors
    @battler_ref.armors 
  end
  #----------------------------------------------------------------------------
  # * Reference the equips to actor equips
  #----------------------------------------------------------------------------
  def equips
    @battler_ref.equips
  end
  
end

#==============================================================================
# * Game_EnemySummon < Game_Enemy
#==============================================================================

class Game_EnemySummon < Game_Enemy
  include TSBS_BattlerSummon
  def initialize(enemy_id, reference)
    @battler_ref = reference
    @anim_end = 0
    super(0, enemy_id)
  end
end

#==============================================================================
# * Sprite_BattlerSummon
#==============================================================================

class Sprite_BattlerSummon < Sprite_Battler
  #----------------------------------------------------------------------------
  # * Update
  #----------------------------------------------------------------------------
  def update
    @battler.update unless @need_dispose
    super
    if @battler.finish && !@need_dispose
      @need_dispose = true
      self.opacity = 0
      start_animation($data_animations[@battler.anim_end], @battler.flip)
    end
    dispose if @need_dispose && !animation? && @afterimages.empty?
  end
  #----------------------------------------------------------------------------
  # * Unique bitmap to prevent blink glitch
  #----------------------------------------------------------------------------
  def bitmap=(bmp)
    bmp = bmp.clone
    super
  end
  #----------------------------------------------------------------------------
  # * Afterimage
  #----------------------------------------------------------------------------
  def afterimage
    super && !@need_dispose
  end
  
end

#==============================================================================
# * Spriteset_Battle
#==============================================================================

class Spriteset_Battle
  attr_reader :summoned_battler
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  alias tsbs_actor_summon_init initialize
  def initialize
    @summoned_battler = []
    tsbs_actor_summon_init
  end
  #----------------------------------------------------------------------------
  # * Add summoned battler
  #----------------------------------------------------------------------------
  def add_summoned_battler(actor)
    @summoned_battler << Sprite_BattlerSummon.new(@viewport1, actor)
  end
  #----------------------------------------------------------------------------
  # * Update
  #----------------------------------------------------------------------------
  alias tsbs_actor_summon_update update
  def update
    tsbs_actor_summon_update
    @summoned_battler.delete_if do |summon|
      summon.update
      summon.disposed?
    end
  end
    
end
#==============================================================================
# * End of compatibility flag
#==============================================================================
end