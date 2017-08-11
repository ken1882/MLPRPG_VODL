#==============================================================================
# ** Game_BaseItem
#------------------------------------------------------------------------------
#  This class uniformly handles skills, items, weapons, and armor. References
# to the database object itself are not retained to enable inclusion in save
# data.
#==============================================================================
class Game_BaseItem
  
  def effects
    object.effects rescue []
  end
  
  def nil?
    return super || is_nil?
  end
  
  alias :is_a_obj? :is_a?
  def is_a?(cls)
    return is_a_obj?(cls) || object.is_a?(cls)
  end
  
  def hashid
    return object.hashid
  end
  
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Actor
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    return object.method(symbol).call(*args) if object.methods.include?(symbol)
    if object.instance_variables.include?(symbol)
      return object.instance_variable_get(symbol)
    end
    super(symbol, args)
  end
  
end
