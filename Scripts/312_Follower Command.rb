if PONY::ENABLE_FOLLOWER
#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
class Game_Character
  attr_accessor :movement_command
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  alias init_public_members_dnd init_public_members
  def init_public_members
    init_public_members_dnd
    @movement_command = 1
  end
  #----------------------------------------------------------------------------
  def command_follow
    @movement_command = 1
    return if actor.nil?
    self.pop_damage('Move') if @hint_cooldown == 0
    self.actor.remove_state(4)
    @hint_cooldown = 30
    $game_player.followers.move
  end
  
  def command_gather
    @movement_command = 2
    self.move_to_position($game_player.x, $game_player.y)
    $game_player.followers.move
  end
    
  def command_hold
    return if actor.nil?
    @movement_command = 3 
    @pathfinding_moves.clear
    self.pop_damage('Hold in Position')
    self.actor.add_state(4)
    $game_player.followers.move
  end
  #----------------------------------------------------------------------------
  def command_following?;   return  @movement_command == 1; end
  def command_gathering?;   return  @movement_command == 2; end
  def command_holding?  ;   return  @movement_command == 3; end
  #----------------------------------------------------------------------------
  # *) alias: update follower movement
  #----------------------------------------------------------------------------
  alias update_follower_movement_dnd update_follower_movement
  def update_follower_movement
    process_pathfinding_movement
    return if command_holding? || command_gathering?
    update_follower_movement_dnd
  end
  #----------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  This is a wrapper for a follower array. This class is used internally for
# the Game_Player class. 
#==============================================================================
class Game_Followers
  
  attr_accessor :movement_command
  #----------------------------------------------------------------------------
  alias initialize_addon initialize
  def initialize(leader)
    initialize_addon(leader)
    @movement_command = 1
  end
  #----------------------------------------------------------------------------
  def enable_followers
    $game_temp.reserve_common_event(27)
    @data.each do |follower|
      follower.moveto($game_player.x,$game_player.y)
    end
    
  end
  #----------------------------------------------------------------------------
  def disable_followers
    visible = false
  end
  #----------------------------------------------------------------------------
end
#jump to => tag: follower
#==============================================================================
# ■ Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: update_scene
  #--------------------------------------------------------------------------
  alias scene_map_update_scene_cmd update_scene
  def update_scene
    scene_map_update_scene_cmd
    process_follower_command unless scene_changing?
  end
  
  #--------------------------------------------------------------------------
  # new method: process_follower_command
  #--------------------------------------------------------------------------
  def process_follower_command
    return if @button_cooldown > 0
    if Input.press?(:kCTRL)
      if Input.press?(:kF)
        $game_player.followers.each do |follower|
          follower.command_follow
        end
        $game_player.followers.movement_command = 1
        #$game_player.followers.enable_followers
        $game_map.interpreter.gab("Follow up!",0,0)
        @button_cooldown = 10
      #-----------------------------------------------------
      elsif Input.trigger?(:kG)
        $game_player.followers.each do |follower|
          follower.command_gather
        end
        $game_map.interpreter.gab("Gather around!",0,0)
        $game_player.followers.movement_command = 2
        @button_cooldown = 10
      #-----------------------------------------------------
      elsif Input.trigger?(:kH)
        $game_player.followers.each do |follower|
          follower.command_hold
        end
        $game_player.followers.movement_command = 3
        $game_map.interpreter.gab("Hold in position!",0,0)
        @button_cooldown = 10
      #-----------------------------------------------------
      end
    end
    
  end
  
end # Scene_Map  
end # PONY
