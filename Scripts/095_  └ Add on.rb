#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  This is a wrapper for a follower array. This class is used internally for
# the Game_Player class. 
#==============================================================================
class Game_Followers
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if gathering?
      move unless moving? || moving?
      @gathering = false if gather?
    end
    each {|follower| follower.update unless follower.nil? || follower.actor.nil?}
  end
  #--------------------------------------------------------------------------
  # * Combat mode on
  #--------------------------------------------------------------------------
  def into_fray
    each {|follower| follower.process_combat_phase}
  end
  #--------------------------------------------------------------------------
  # * Combat mode off
  #--------------------------------------------------------------------------
  def retreat_fray
    each {|follower| follower.retreat_combat}
  end
end
