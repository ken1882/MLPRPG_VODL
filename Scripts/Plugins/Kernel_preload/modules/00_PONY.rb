#==============================================================================
# ** PONY
#------------------------------------------------------------------------------
#  Pone Pone Pone~ Po-Po-Pony should poni pony
#==============================================================================
$imported = {} if $imported.nil?
$imported["COM::DND::BasicModule"] = true
Button_CoolDown = 10
SPLIT_LINE = "-------------------------------------------------"
module PONY
  #----------------------------------
  TOTAL_BIT_VARIABLE_ID   = 31
  TOTAL_XP_VARIABLE_ID    = 32
  
  COMBAT_STOP_FLAG        = 98
  Enable_Loading          = true
  
  TimeCycle               = 60  # Frame
  @hashid_table           = {}
  @inhert_table           = {}
  
  # tag: icon
  #----------------------------------
  IconID = {
    :bit            => 558,
    :chromastal     => 571,
    :mouse_casting  => 386,
    :loot_drop      => 573,
    :aim            => 6140,
    :targeting      => 6140,
    :fighting       => 115,
    :self           => 125,
    :plus           => 1143,
    :minus          => 1145,
    :player         => 556,
    :level_up       => 8182,
  }
  #----------------------------------
  StateID = {
    :aggressive_level => [7,8,9,10,11,12],
    :true_sight       => 13,
    :hold_position    => 4,
    :free_movement    => 24,
    :invisible        => 19,
  }
  #----------------------------------
  LightStateID = {
    14  =>  0, # Light_Core::Effects
  }
  #----------------------------------
  Bitset = Array.new(500){|i| 1 << i}
  #-----------------------------------------------------------------------------
  def self.InitObjSpace
    return ; # Currently not used
    superclasses = Set.new
    ObjectSpace.each_object(Class) do |cls|
      superclasses.merge(cls.ancestors)
    end
    ar = []
    superclasses.each{|i| ar << i}
    bitnum = {}; bitnum.default = 0
    objs = {}
    
    ar.each do |cls|
      n = cls.ancestors.select{|i| i != cls}.size
      cls.const_set(:Ancestor_num, n)
      objs[n] = Array.new if objs[n].nil?
      objs[n] << [ cls, bitnum[n] ]
      bitnum[n] += 1;
    end
    
    objs.each do |n, ary|
      ary.each do |obj|
        n = obj.first::Ancestor_num
        cls = obj.first
        offset = 0
        n.times{|i| offset += bitnum[i]}
        bit = (1 << (obj.last + offset))
        cls.const_set(:InhertID, bit)
      end
    end
    
    ar.each do |cls|
      final_bit = cls::InhertID
      cls.ancestors.each do |anc|
        final_bit |= anc::InhertID
      end
      cls.const_set(:InhertID, final_bit)
    end
    
  end
  #-----------------------------------------------------------------------------
end
