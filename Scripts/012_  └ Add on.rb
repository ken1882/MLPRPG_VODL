#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================
module SceneManager
  #----------------------------------------------------------------------------
  # * all battlers
  #----------------------------------------------------------------------------
  def self.all_battlers
    return unless self.scene.is_a?(Scene_Map)
    
    battlers = self.party_battlers + self.enemy_battlers
    return battlers
  end
  #----------------------------------------------------------------------------
  # *) party battlers
  #----------------------------------------------------------------------------
  def self.party_battlers
    
    battlers = [$game_player]
    $game_player.followers.each do |follower|
      next if follower.actor.nil?
      battlers.push(follower)
    end
    
    return battlers
  end
  #----------------------------------------------------------------------------
  # *)  Friendly AI battlers
  #----------------------------------------------------------------------------
  def self.allied_battlers
  end
  #----------------------------------------------------------------------------
  # *)  Hostile AI
  #----------------------------------------------------------------------------
  def self.enemy_battlers
    $game_map.event_enemies
  end
  #----------------------------------------------------------------------------
  # *)  Disply texts on info box
  #----------------------------------------------------------------------------
  def self.display_info(text = nil)
    scene = self.scene
    return unless scene.is_a?(Scene_Map) && !text.nil?
    scene.display_info(text)
  end
  #----------------------------------------------------------------------------
end
