#==============================================================================
# ** Game_BaseItem
#------------------------------------------------------------------------------
#  This class uniformly handles skills, items, weapons, and armor. References
# to the database object itself are not retained to enable inclusion in save
# data.
#==============================================================================
class Game_BaseItem
  
  def nil?
    return super || is_nil?
  end
  
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Actor
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, args) unless object.methods.include?(symbol)
    super(symbol, args) unless object.instance_variables.inlcude?(symbol)
    @map_char.method(symbol).call(*args)
  end
  
end
