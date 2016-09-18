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
    return unless $game_party.leader.state?(2)
    return if $game_party.leader.equips[0].nil?
    self.update_followers_attack
    self.update_follower_movement
  end
  
  #-------------------------------------------------------------------------
end
