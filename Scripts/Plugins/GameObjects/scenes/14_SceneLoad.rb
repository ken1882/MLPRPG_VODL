#==============================================================================
# ** Scene_Load
#------------------------------------------------------------------------------
#  This class performs load screen processing. 
#==============================================================================
class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Get File Index to Select First
  #--------------------------------------------------------------------------
  def first_savefile_index
    DataManager.latest_savefile_index($game_system.game_mode)
  end
end
