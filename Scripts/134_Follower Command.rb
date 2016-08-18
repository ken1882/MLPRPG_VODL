#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================

class Game_Follower < Game_Character
  attr_accessor :command
  
  def assign_command(cmd = "none")
    command = cmd
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

    if Input.trigger?(:kG)
      $game_player.followers.each do |follower|
        follower.command = "gather"
      end
      $game_map.interpreter.gab("Gather around!",0,0)
    #-----------------------------------------------------
    elsif Input.trigger?(:kF)
      $game_player.followers.each do |follower|
        follower.command = "follow"
      end
      $game_map.interpreter.gab("Follow up!",0,0)
    #-----------------------------------------------------
    elsif Input.trigger?(:kH)
      $game_player.followers.each do |follower|
        follower.command = "hold"
      end
      $game_map.interpreter.gab("Hold in position!",0,0)
    #-----------------------------------------------------
    end
    
  end
  
end # Scene_Map