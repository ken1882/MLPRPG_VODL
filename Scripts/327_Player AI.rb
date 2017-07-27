#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. It includes event starting determinants and
# map scrolling functions. The instance of this class is referenced by
# $game_player.
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Processing of Movement via Input from Directional Buttons
  #--------------------------------------------------------------------------
  alias move_by_input_dnd move_by_input
  def move_by_input
    return if $tactic_enabled || $game_party.leader.state?(2)
    move_by_input_dnd
  end
  #--------------------------------------------------------------------------
  # Alias: update
  #--------------------------------------------------------------------------
  alias update_dndAI update
  def update
    update_dndAI
    process_party_movement
    return unless $game_party.leader.state?(2)
    return if $game_party.leader.equips[0].nil?
    self.update_followers_attack
    self.update_follower_movement
  end
  #-------------------------------------------------------------------------
  def process_party_movement
    process_pathfinding_movement
    trigger_target_event if @target_event
    
  end
  #-------------------------------------------------------------------------
  def trigger_target_event
    if distance_to(@target_event.x, @target_event.y) <= 1
      @target_event.start 
      @target_event = nil
    end
  end
  #-------------------------------------------------------------------------
end
