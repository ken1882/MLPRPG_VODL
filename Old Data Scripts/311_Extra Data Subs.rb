
module DND
  module SUBS
      #-------------------------------------------------------------------------
      # <saving throw adjust x: +/-x>
      #-------------------------------------------------------------------------
      SAVING_THROW_ADJUST  = /<(?:SAVING_THROW_ADJUST|saving throw adjust)[ ](\d+):[ ]([\+\-]\d+)>/i
      #-------------------------------------------------------------------------
      # <poison>
      #-------------------------------------------------------------------------
      POISON = /<(?:POISON|poison)>/i
      #-------------------------------------------------------------------------
      # <debuff>
      #-------------------------------------------------------------------------
      DEBUFF = /<(?:DEBUFF|debuff)>/i
      #-------------------------------------------------------------------------
      # <magic>
      #-------------------------------------------------------------------------
      MAGIC_EFFECT = /<(?:MAGIC|magic)>/i
      
      #-------------------------------------------------
  end # SUBS
end # DND



#==========================================================================
# ■ RPG::BaseItem
#==========================================================================

class RPG::BaseItem
  
  #------------------------------------------------------------------------
  # public instance variables
  #------------------------------------------------------------------------
  attr_accessor :saving_throw_adjust
  attr_accessor :property
  #------------------------------------------------------------------------
  # common cache: load_notetags_dndsubs
  #------------------------------------------------------------------------  
  def load_notetags_dndsubs

    @saving_throw_adjust = [0,0,0,0,0,0,0,0]
    @property = []
    
    if self.is_spell?
      @property.push(0)
      p sprintf("%10s: %30s%6s %5s",self.class,self.name,'(' + self.id.to_s + ')',"is a magic stuff") if self.name.size > 1
    end
    
    self.note.split(/[\r\n]+/).each { |line|
      _property = ""
      
      case line
      when DND::SUBS::SAVING_THROW_ADJUST
        @saving_throw_adjust[$1.to_i] = $2.to_i
        p sprintf("[Attack Block]:%s's saving throw[%d] adjust:%d",self.name,$1.to_i,@saving_throw_adjust[$1.to_i])
      when DND::SUBS::POISON && self.is_a?(RPG::State)
        @property.push(2)
        _property = "is a poison"
      when DND::SUBS::DEBUFF
        @property.push(1) if self.is_a?(RPG::State)
        _property = "is a debuff"
      when DND::SUBS::MAGIC_EFFECT
        @property.push(0)
        _property = "is a magic stuff"
      end
      
      p sprintf("%10s: %30s%6s %5s",self.class,self.name,'(' + self.id.to_s + ')',_property) if _property.size > 1
    } # self.note.split
  end
  #------------------------------------------------------------------------
  # is_magic?
  #------------------------------------------------------------------------
  def is_magic?
    @property.include?(0)
  end
  #------------------------------------------------------------------------
  # is_debuff?
  #------------------------------------------------------------------------
  def is_debuff?
    @property.include?(1)
  end
  #------------------------------------------------------------------------
  # is_poison?
  #------------------------------------------------------------------------
  def is_poison?
    @property.include?(2)
  end
  #------------------------------------------------------------------------
  # is a spell?
  #------------------------------------------------------------------------
  def is_spell?
    return false if nil?
    return false if !self.is_a?(RPG::Skill)
    return true if is_magic?
    return true if 400 < self.id && self.id < 500
  end
  
  
end # RPG::BaseItem


#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_dndsubs load_database; end
  def self.load_database
    $data_notetagged_items = []
    load_database_dndsubs
    load_notetags_dndsubs
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_war
  #--------------------------------------------------------------------------
  def self.load_notetags_dndsubs
    groups = [$data_weapons, $data_armors,$data_skills,$data_states]
    
    p sprintf("[Attack Block]:load note tags")
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_dndsubs
      end
    end
  end
  
end # DataManager
