#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================
class Spriteset_Map
  
  def find_sprite(name, store = false)
    instance_variables.each do |varname|
      
      return instance_variable_get(varname) if varname == name
    end
  end
  
end
