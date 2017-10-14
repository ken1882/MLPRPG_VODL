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
    return if battler.nil? || battler == self
    popup_info('Move')
    battler.remove_state(4)
    battler.result.removed_states.delete(4)
    $game_player.followers.move if self.is_a?(Game_Follower)
  end
  #----------------------------------------------------------------------------
  def command_gather
    return ; # tag: queued
    @movement_command = 2
    self.move_to_position($game_player.x, $game_player.y, goal:$game_player)
    $game_player.followers.move if self.is_a?(Game_Follower)
  end
  #----------------------------------------------------------------------------  
  def command_hold
    return if battler.nil? || battler == self
    @movement_command = 3 
    clear_pathfinding_moves
    popup_info('Hold in Position')
    battler.add_state(4)
    $game_player.followers.move if self.is_a?(Game_Follower)
  end
  #----------------------------------------------------------------------------
  def command_following?;   return  @movement_command == 1; end
  def command_gathering?;   return  @movement_command == 2; end
  def command_holding?  ;   return  @movement_command == 3; end
  #----------------------------------------------------------------------------
  # *) update follower movement
  #----------------------------------------------------------------------------
  def update_follower_movement
    process_pathfinding_movement
    return if command_holding? || command_gathering?
    # tag: unfinished
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
