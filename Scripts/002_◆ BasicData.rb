#===============================================================================
# * Basic Object
#===============================================================================
class Object
  #------------------------------------------------------------------------
  attr_reader :active
  #------------------------------------------------------------------------
  alias init_rbobj initialize
  def initialize(*args)
    activate
    init_rbobj(*args)
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
    
    # Exception handle due to class method is used for database
    if newone.is_a?(Game_Actor)
      return unless self.is_a?(Game_Actor)
    else
      return unless newone.class == self.class
    end
    
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
# * True/Flase class
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
#==============================================================================
# ■ Numeric
#==============================================================================
class Numeric
  
end
#===============================================================================
# * Basic Fixnum class
#===============================================================================
class Fixnum
  #----------------------------------------------------------------------------
  alias plus +
  def +(*args)
    plus(*args)
  end
  #----------------------------------------------------------------------------
  alias minus -
  def -(*args)
    minus(*args)
  end
  #----------------------------------------------------------------------------
  alias bigger >
  def >(*args)
    bigger(*args)
  end
  #----------------------------------------------------------------------------
  alias ebigger >=
  def >=(*args)
    ebigger(*args)
  end
  #----------------------------------------------------------------------------
  alias smaller <
  def <(*args)
    smaller(*args)
  end
  #----------------------------------------------------------------------------
  alias esmaller <=
  def <=(*args)
    esmaller(*args)
  end
  #----------------------------------------------------------------------------
  alias :divid :/
  def /(*args)
    divid(*args)
  end
  #----------------------------------------------------------------------------
  # *) Convert to radians
  #----------------------------------------------------------------------------
  def to_rad
    self * Math::PI / 180
  end
  #----------------------------------------------------------------------------
  # *) Convert to boolean
  #----------------------------------------------------------------------------
  def to_bool
    self == 0 ? false : true
  end
  #----------------------------------------------------------------------------
  # *) String for filename
  #----------------------------------------------------------------------------
  def to_fileid(deg)
    n = self
    cnt = 0
    while n > 0
      n /= 10
      cnt += 1
    end
    cnt = [cnt, 1].max
    PONY::ERRNO.raise(:fileid_overflow, :exit) if cnt > deg
    return ('0' * (deg - cnt)) + self.to_s
  end
  #----------------------------------------------------------------------------
  # * To second in frame
  #----------------------------------------------------------------------------
  def to_sec
    return (self / Graphics.frame_rate).to_i + 1
  end
  #----------------------------------------------------------------------------
  def set_bit(index, n)
    n = n.to_i rescue nil
    if n.nil?
      PONY::ERRNO.raise(:datatype_error, nil, nil, "Nil bit given")
      return
    elsif n != 1 && n != 0
      puts "n: #{n}"
      PONY::ERRNO.raise(:datatype_error, nil, nil, "Bit operation excess 0/1")
      return
    end
    
    return self |  (1 << index) if n == 1
    return self & ~(1 << index)
  end
  alias setbit set_bit
  alias sb set_bit
  #----------------------------------------------------------------------------
end
class NilClass
  #----------------------------------------------------------------------------
  # *) Convert to boolean
  #----------------------------------------------------------------------------
  def to_bool
    false
  end
end
#===============================================================================
# * Basic String class
#===============================================================================
class String  
  #----------------------------------------------------------------------------
  # *) Delete a char at certain position
  #----------------------------------------------------------------------------
  def delete_at(*args)
    self.slice!(*args)
  end
  #----------------------------------------------------------------------------
  # * Delete extra empty chars via Win32API
  #----------------------------------------------------------------------------
  def purify
    self.gsub!("\u0000", '').delete!('\0').squeeze!('\\').tr!('\\','/').delete_at(length-1)
    self
  end
end
#===============================================================================
# * Array
#===============================================================================
class Array
  
  def swap_at(loc_a, loc_b)
    self[loc_a], self[loc_b] = self[loc_b], self[loc_a]
  end
  
  def x
    self[0]
  end
  
  def y
    self[1]
  end
  
  def z
    self[2]
  end
  
end
#===============================================================================
# Module Math
#===============================================================================
module Math
  #-----------------------------------------------------------------------------
  # * Module variables
  #-----------------------------------------------------------------------------
  @rotation_cache = {}
  #-----------------------------------------------------------------------------
  # * Get rotated position
  #-----------------------------------------------------------------------------
  def self.rotation_matrix(x, y, angle, flip = false)
    key  = (x * 10000 + y * 360 + angle)
    key *= flip ? -1 : 1
    if !@rotation_cache[key]
      rx = x * Math.cos(angle.to_rad) - y * Math.sin(angle.to_rad)
      ry = x * Math.sin(angle.to_rad) + y * Math.cos(angle.to_rad)
      ry *= -1 if flip
      @rotation_cache[key] = [rx.round(6), ry.round(6)]
    end
    return @rotation_cache[key]
  end
  #-----------------------------------------------------------------------------
  def self.slope(x1, y1, x2, y2)
    return nil if x2 == x1
    return (y2 - y1).to_f / (x2 - x1)
  end
  #-----------------------------------------------------------------------------
  # *) in arc:
  #
  # x1, y1: target coord
  # x2, y2: source coord
  # angle1, angle2: left's and right's Generalized Angle
  # distance: effective distance
  #-----------------------------------------------------------------------------
  def self.in_arc?(x1, y1, x2, y2, angle1, angle2, distance, original_dir)
    return false if self.hypot( x2 - x1, y2 - y1 ) > distance
    move_x = $game_map.width / 2
    move_y = $game_map.height / 2
    
    x1 = x1 - move_x
    y1 = move_y - y1
    x2 = x2 - move_x
    y2 = move_y - y2
    
    left_x    = x2 + self.rotation_matrix(1,0, angle1).at(0)
    left_y    = y2 + self.rotation_matrix(1,0, angle1).at(1)
    right_x   = x2 + self.rotation_matrix(1,0, angle2).at(0)
    right_y   = y2 + self.rotation_matrix(1,0, angle2).at(1)
    m1 = slope(x2, y2, left_x, left_y)
    m2 = slope(x2, y2, right_x, right_y)
    on_m1_right = on_m2_left = true
    
    offset1 = (left_y - m1 * left_x)
    offset2 = (right_y - m2 * right_x)
    delta   = m2 - m1
    delta_x = offset1 - offset2
    cx = delta_x.to_f / delta
    
    if m1.nil?
      on_m1_right = (angle1 == 90 ? x1 >= x2 : x1 <= x2)
    else
      if [4,7,8,9].include?(original_dir)
        on_m1_right = y1 >= m1 * x1 + offset1
      else
        on_m1_right = y1 <= m1 * x1 + offset1
      end
    end
    
    if m2.nil?
      on_m2_left = (angle2 == 270 ? x1 >= x2 : x1 <=x2)
    else
      if [4,1,2,3].include?(original_dir)
        on_m2_left = y1 <= m2 * x1 + offset2
      else
        on_m2_left = y1 >= m2 * x1 + offset2
      end
    end
    return on_m1_right && on_m2_left
  end
end
#===============================================================================
# * Mutex
#===============================================================================
class Mutex
  #----------------------------------------------------------------------------
  def synchronize
    self.lock
    begin
      puts "[Thread]: Yield Block"
      yield
    ensure
      self.unlock rescue nil
      puts "[Thread]: Block completed"
    end
  end
end
