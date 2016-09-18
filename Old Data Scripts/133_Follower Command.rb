#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================

class Game_Follower < Game_Character
  attr_accessor :movement_command
  
  alias initialize_follower_cmd initialize
  def initialize(member_index, preceding_character)
    initialize_follower_cmd(member_index, preceding_character)
    @movement_command = 1
  end
  
  def command_follow;  @movement_command = 1 end
  
  def command_gather;  @movement_command = 2 end
    
  def command_hold  ;  @movement_command = 3 end
  
  
  def command_following?;   return  @movement_command == 1; end
  def command_gathering?;   return  @movement_command == 2; end
  def command_holding?  ;   return  @movement_command == 3; end
  
end


#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  This is a wrapper for a follower array. This class is used internally for
# the Game_Player class. 
#==============================================================================

class Game_Followers
  
  attr_accessor :movement_command
  
  alias initialize_addon initialize
  def initialize(leader)
    initialize_addon(leader)
    @movement_command = 1
  end
  
  def enable_followers
    $game_temp.reserve_common_event(27)
    @data.each do |follower|
      follower.moveto($game_player.x,$game_player.y)
    end
    
  end
  
  def disable_followers
    visible = false
  end
  
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
    
    if Input.trigger?(:kF)
      $game_player.followers.each do |follower|
        follower.command_follow
      end
      $game_player.followers.movement_command = 1
      $game_player.followers.enable_followers
      $game_map.interpreter.gab("Follow up!",0,0)
    #-----------------------------------------------------
    elsif Input.trigger?(:kG)
      $game_player.followers.each do |follower|
        follower.command_gather
      end
      $game_map.interpreter.gab("Gather around!",0,0)
      $game_player.followers.movement_command = 2
      $game_temp.reserve_common_event(26)
    #-----------------------------------------------------
    elsif Input.trigger?(:kH)
      $game_player.followers.each do |follower|
        follower.command_hold
      end
      $game_player.followers.movement_command = 3
      $game_map.interpreter.gab("Hold in position!",0,0)
    #-----------------------------------------------------
    end
    
  end
  
end # Scene_Map