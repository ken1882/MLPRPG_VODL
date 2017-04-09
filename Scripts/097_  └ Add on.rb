#==============================================================================
# ** Sprite_Base
#------------------------------------------------------------------------------
#  A sprite class with animation display processing added.
#==============================================================================
class Sprite_Base < Sprite
  
  def dump_data
    data = {}
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      data[varname] = ivar
    end
    return data
  end
  
end
