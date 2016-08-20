module DND
  
  module SUBS
    
    DND_PARAMETER_ON = /<(?:DND_PARAMETERS|dnd paramters)>/i
    STR  = /(?:STR|str):[ ](\d+)/i
    DEX = /(?:DEX|dex):[ ](\d+)/i
    CON = /(?:CON|con):[ ](\d+)/i
    INT = /(?:INT|int):[ ](\d+)/i
    WIS = /(?:WIS|wis):[ ](\d+)/i
    CHA = /(?:CHA|cha):[ ](\d+)/i
    DND_PARAMETER_OFF = /<\/(?:DND_PARAMETERS|dnd parameters)>/i
  end

end
#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class << self; alias load_database_dnd_parameter load_database; end
  def self.load_database
    $dnd_info = []
    load_database_dnd_parameter
    load_notetags_dnd_parameter
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_dnd
  #--------------------------------------------------------------------------
  def self.load_notetags_dnd_parameter
    groups = [$data_actors,$data_enemies]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_dnd_parameter
      end
    end
  end
  
end # DataManager

#==============================================================================
#
# ■ RPG::BaseItem
#
#==============================================================================

class RPG::BaseItem
  
  attr_accessor :dnd_paramter_on
  
  attr_accessor :p_str                # strength in DnD
  attr_accessor :p_dex                # dexterity in DnD
  attr_accessor :p_con                # constitution in DnD
  attr_accessor :p_int                # intelligence in DnD
  attr_accessor :p_wis                # wisdom in DnD
  attr_accessor :p_cha                # charisma in DnD
  
  
  attr_accessor :real_str                # strength in DnD
  attr_accessor :real_dex                # dexterity in DnD
  attr_accessor :real_con                # constitution in DnD
  attr_accessor :real_int                # intelligence in DnD
  attr_accessor :real_wis                # wisdom in DnD
  attr_accessor :real_cha                # charisma in DnD
  
  attr_accessor :armor_class
  attr_accessor :thac0                  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_dnd
  #--------------------------------------------------------------------------
  
  def load_notetags_dnd_parameter
    
    return unless self.is_a?(RPG::Actor) || self.is_a?(RPG::Enemy)
    
    @dnd_paramter_on = false
    
    self.note.split(/[\r\n]+/).each { |line|
        case line
        when DND::SUBS::DND_PARAMETER_ON
          @dnd_paramter_on = true
        when DND::SUBS::DND_PARAMETER_OFF
          @dnd_paramter_on = false
        when DND::SUBS::STR
          @p_str = $1.to_i if @dnd_paramter_on
          @real_str = $1.to_i if @dnd_paramter_on
        when DND::SUBS::DEX
          @p_dex = $1.to_i if @dnd_paramter_on
          @real_dex = $1.to_i if @dnd_paramter_on
        when DND::SUBS::CON
          @p_con = $1.to_i if @dnd_paramter_on
          @real_con = $1.to_i if @dnd_paramter_on
        when DND::SUBS::INT
          @p_int = $1.to_i if @dnd_paramter_on
          @real_int = $1.to_i if @dnd_paramter_on
        when DND::SUBS::WIS
          @p_wis = $1.to_i if @dnd_paramter_on
          @real_wis = $1.to_i if @dnd_paramter_on
        when DND::SUBS::CHA
          @p_cha = $1.to_i if @dnd_paramter_on
          @real_cha = $1.to_i if @dnd_paramter_on
        when MOTO::REGEXP::BASEITEM::THAC0
          @thac0 = $1.to_i
        when MOTO::REGEXP::BASEITEM::ARMOR_CLASS
          @armor_class = $1.to_i
        end
    } # self.note.split
    #---
    if @p_str
      
      info = sprintf("
      
      ┌────────────────────┐
      │ Character Name: %15s%9c
      │ Str: %d%33c
      │ Dex: %d%33c
      │ Con: %d%33c
      │ Int: %d%33c
      │ Wis: %d%33c
      │ Cha: %d%33c
      └────────────────────┘
      
      ",self.name,'│',@p_str,'│',@p_dex,'│',@p_con,'│',@p_int,'│',@p_wis,'│',@p_cha,'│')
      #puts "#{info}"
      info = [self.name,@p_str,@p_dex,@p_con,@p_int,@p_wis,@p_cha]
      
    end
  end #load_notetags_dnd
  
end # RPG::BaseItem

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
    @last_skill = Game_BaseItem.new
  end
  #--------------------------------------------------------------------------
  # * Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_base(param_id)
    self.class.params[param_id, @level]
  end
  #--------------------------------------------------------------------------
  # * Get Added Value of Parameter
  #--------------------------------------------------------------------------
  def param_plus(param_id)
    equips.compact.inject(super) {|r, item| r += item.params[param_id] }
  end
end

