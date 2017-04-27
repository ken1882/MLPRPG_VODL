module Input
  
  class << self; alias dir4_wasd dir4; end
  def self.dir4
    return 2 if (Input.press?(Input::Y))
    return 4 if (Input.press?(Input::X))
    return 6 if (Input.press?(Input::Z))
    return 8 if (Input.press?(Input::R))
    return dir4_wasd
  end
  
  def self.dir8
    return 1 if (press?(:DOWN) || press?(:kS)) && (press?(:LEFT)  || press?(:kA))
    return 3 if (press?(:DOWN) || press?(:kS)) && (press?(:RIGHT) || press?(:kD))
    return 7 if (press?(:UP)   || press?(:kW)) && (press?(:LEFT)  || press?(:kA))
    return 9 if (press?(:UP)   || press?(:kW)) && (press?(:RIGHT) || press?(:kD))
    return dir4
  end
end
