#==============================================================================
# ** Game_Unit
#------------------------------------------------------------------------------
#  This class handles units. It's used as a superclass of the Game_Party and
# and Game_Troop classes.
#==============================================================================
class Game_Unit
  
  def in_battle
    return SceneManager.scene_is?(Scene_Map)
  end
  
end
