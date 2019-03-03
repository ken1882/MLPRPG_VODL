#===============================================================================
# * Basic Object
#===============================================================================
class Object
  #------------------------------------------------------------------------
  InhertID = 0
  alias :ruby_class :class # Alias for class prevent misuse of Game_Actor
  #------------------------------------------------------------------------
  attr_reader :active
  #------------------------------------------------------------------------
  alias init_rbobj initialize
  def initialize(*args)
    activate
    init_rbobj(*args)
  end
  #------------------------------------------------------------------------
  def eigenclass
    class << self
      self
    end
  end
  #------------------------------------------------------------------------
  def deactivate
    @active = false
  end
  #------------------------------------------------------------------------
  def activate
    @active = true
  end
  #------------------------------------------------------------------------
  def active?
    @active || false
  end
  #------------------------------------------------------------------------
  # * Set hashid
  #------------------------------------------------------------------------
  def hash_self
    PONY.hashid_table[@hashid] = self
    return @hashid
  end
  #------------------------------------------------------------------------
  def hashid
    hash_self if @hashid.nil?
    return @hashid
  end
  #------------------------------------------------------------------------
  def to_bool
    return true
  end
  #------------------------------------------------------------------------
  # * Synchronize instance variables with newer verison of object
  #------------------------------------------------------------------------
  def sync_new_data(newone)
    return unless newone.ruby_class == self.ruby_class
    
    vars    = self.instance_variables
    newvars = newone.instance_variables
    
    # Create instance of new variable
    newvars.each do |varname|
      next if vars.include?(varname)
      ivar = newone.instance_variable_get(varname)
      debug_print("New instance variable for #{self}: #{varname} = #{ivar ? ivar : 'nil'}")
      self.instance_variable_set(varname, ivar)
    end
    
  end
end
#===============================================================================
# * True/Flase/Nil class
#===============================================================================
class TrueClass
  def to_i
    return 1
  end
end

class FalseClass
  def to_i
    return 0
  end
end

class NilClass
  #----------------------------------------------------------------------------
  # *) Convert to boolean
  #----------------------------------------------------------------------------
  def to_bool
    false
  end
end