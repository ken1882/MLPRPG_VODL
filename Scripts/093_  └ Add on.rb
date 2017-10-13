#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :phase
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_gafo_opt initialize
  def initialize(member_index, preceding_character)
    @phase = DND::BattlerSetting::PhaseIdle
    init_gafo_opt(member_index, preceding_character)
    @combat_mode_timer = 0
    @through = false
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Frame Update
  #--------------------------------------------------------------------------
  def update
    # opacity sync to $game_player is removed
    @move_speed     = $game_player.real_move_speed
    @transparent    = $game_player.transparent
    @walk_anime     = $game_player.walk_anime
    #@step_anime     = $game_player.step_anime
    @direction_fix  = $game_player.direction_fix
    @blend_type     = $game_player.blend_type
    update_movement
    @combat_mode_timer -= 1 if @combat_mode_timer > 0
    update_combat_mode if $game_player.followers.combat_mode?
    super
  end
  #--------------------------------------------------------------------------
  # * Combat mode on
  #--------------------------------------------------------------------------
  def process_combat_phase
    set_target(find_nearest_enemy) unless aggressive_level < 2
  end
  #--------------------------------------------------------------------------
  # * Combat mode off
  #--------------------------------------------------------------------------
  def retreat_combat
    set_target(nil)
    chase_preceding_character
  end
  #---------------------------------------------------------------------------
  def update_movement
    process_pathfinding_movement
  end
  #--------------------------------------------------------------------------
  def body_size
    return 1 * @zoom_x
  end
  #--------------------------------------------------------------------------
  def hashid
    return actor.hashid if actor
    return PONY.Sha256(self.inspect)
  end
  #--------------------------------------------------------------------------
  def primary_weapon
    return nil if !actor
    return actor.equips[0]
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Determine Visibility
  #--------------------------------------------------------------------------
  def visible?
    super && actor && $game_player.followers.visible
  end
  #----------------------------------------------------------------------------
  # * Die when hitpoint drop to zero
  #----------------------------------------------------------------------------
  def kill
    process_actor_death
    super
  end
  #----------------------------------------------------------------------------
  def dead?
    return true if actor.nil?
    return actor.dead?
  end
  #--------------------------------------------------------------------------
  def aggressive_level
    return 0 if actor.nil?
    return actor.aggressive_level
  end
  #--------------------------------------------------------------------------
  # * Determine if Movement is Possible
  #--------------------------------------------------------------------------
  def movable?
    return false if actor && !actor.movable?
    return super
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Game_Enemy
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, *args) if actor.nil?
    actor.method(symbol).call(*args)
  end
  #----------------------------------------------------------------------------
  # * Allow character move freely between characters?
  #----------------------------------------------------------------------------
  def allow_loose_moving?
    return false
  end
  #--------------------------------------------------------------------------
  def team_id
    return @team_id.nil? ? @team_id = 0 : @team_id
  end
  #--------------------------------------------------------------------------
  def update_combat_mode
    return if $game_message.busy?
    return if $game_system.story_mode?
    return if aggressive_level < 2 || @combat_mode_timer > 0
    @combat_mode_timer = 30
    process_combat_phase if @current_target.nil?
  end
  #----------------------------------------------------------------------------
  # * Use item
  #----------------------------------------------------------------------------
  def use_tool(item, target = nil)
    super
    SceneManager.spriteset.hud_sprite[actor.index].draw_action(@next_action)
  end
  #----------------------------------------------------------------------------
  def setup_light(light_id)
    $game_map.lantern.change_owner($game_player)
    $game_map.lantern.set_graphic(Light_Core::Effects[light_id])
    $game_map.lantern.set_opacity(180,30)
    $game_map.lantern.show
  end
  #----------------------------------------------------------------------------
  def dispose_light
    $game_map.lantern.hide
  end
  #--------------------------------------------------------------------------
  def casting_index
    actor.actor.casting_index rescue super
  end
  #--------------------------------------------------------------------------
  def casting_animation 
    actor.actor.casting_animation rescue super
  end
  #--------------------------------------------------------------------------
  def get_ammo_item(item)
    if item.is_a?(RPG::Weapon) && item.tool_itemcost_type > 0
      return actor.current_ammo
    elsif (item.tool_itemcost || 0) > 0
      return $data_items[item.tool_itemcost]
    end
  end
  #--------------------------------------------------------------------------
end
