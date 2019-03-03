#==============================================================================
# ■ Numeric
#==============================================================================
class Numeric
  #----------------------------------------------------------------------------
  # *) Convert to boolean
  #----------------------------------------------------------------------------
  def to_bool
    return self != 0 # self == 0 ? false : true
  end
  #----------------------------------------------------------------------------
  # *) Convert to radians
  #----------------------------------------------------------------------------
  def to_rad
    self * Math::PI / 180
  end
end
#===============================================================================
# * Basic Fixnum class
#===============================================================================
class Fixnum
=begin
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
=end
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