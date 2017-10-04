#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  This is a wrapper for a follower array. This class is used internally for
# the Game_Player class. 
#==============================================================================
class Game_Followers
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     leader:  Lead character
  #--------------------------------------------------------------------------
  alias init_dnd initialize
  def initialize(leader)
    @fighting = false
    init_dnd(leader)
  end
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
  def toggle_combat
    @fighting ? retreat_fray : into_fray
    $game_party.skillbar.sprite.refresh
  end
  #--------------------------------------------------------------------------
  # * Combat mode on
  #--------------------------------------------------------------------------
  def into_fray
    @fighting = true
    each {|follower| follower.process_combat_phase}
  end
  #--------------------------------------------------------------------------
  # * Combat mode off
  #--------------------------------------------------------------------------
  def retreat_fray
    @fighting = false
    each {|follower| follower.retreat_combat}
  end
  #--------------------------------------------------------------------------
  def combat_mode?
    @fighting
  end
  
end
