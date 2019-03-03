#==============================================================================
# ** Sound
#------------------------------------------------------------------------------
#  This module plays sound effects. It obtains sound effects specified in the
# database from the global variable $data_system, and plays them.
#==============================================================================
module Sound

  @volume = [100,100,100]

  # Low HP sound
  def self.low_hp
    Audio.se_play('Audio/SE/KindomHeart_LowHP', 100, 100)
  end
  
  # Level up SE
  def self.level_up
    Audio.se_play('Audio/SE/LevelUp', 80, 100)
  end
  
  def self.set_volume(bgm, bgs, se)
    @volume[0] = bgm; @volume[1] = bgs; @volume[2] = se;
  end

  def self.volume; @volume; end
  
end
