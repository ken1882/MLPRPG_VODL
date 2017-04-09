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
end
