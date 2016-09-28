#==============================================================================
# ** Audio
#------------------------------------------------------------------------------
#  This module handles and plays sound effects.
#==============================================================================
$imported = {} if $imported.nil?
module Audio
  #--------------------------------------------------------------------------
  # alias method: se_play
  #--------------------------------------------------------------------------
  class << self; alias se_play_dnd se_play; end
  def self.se_play(filename, volume = 100, pitch = 100)
    if $imported["YEA-SystemOptions"]
      system_volume = $game_system.get_volume_setting
      volume = system_volume[:sfx]
    end
    se_play_dnd(filename, volume, pitch)
  end
  #----------------------------------
end
