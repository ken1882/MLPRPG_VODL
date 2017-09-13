#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================
# tag: AI
class Game_Follower < Game_Character
  #----------------------------------------------------------------------------
  def attack
    @actor.process_tool_action(primary_weapon)
  end
  #----------------------------------------------------------------------------
end
