=begin

  mhp; 					 param(0);                 # MHP  Maximum Hit Points
  mmp; 					 param(1);                 # MMP  Maximum Magic Points
  atk; 					 param(2);                 # ATK  ATtacK power
  def;					 param(3);                 # DEFense power
  mat; 					 param(4);                 # MAT  Magic ATtack power
  mdf; 					 param(5);                 # MDF  Magic DeFense power
  agi;  				 param(6);                 # AGI  AGIlity
  luk;  				 param(7);                 # LUK  LUcK
  
  
  hit; 					 xparam(0);                # HIT  HIT rate
  eva; 					 xparam(1);                # EVA  EVAsion rate
  cri; 					 xparam(2);                # CRI  CRItical rate
  cev; 					 xparam(3);                # CEV  Critical EVasion rate
  mev;  		     xparam(4);                # MEV  Magic EVasion rate
  mrf;  				 xparam(5);                # MRF  Magic ReFlection rate
  cnt;  				 xparam(6);                # CNT  CouNTer attack rate
  hrg;  				 xparam(7);                # HRG  Hp ReGeneration rate
  mrg;  				 xparam(8);                # MRG  Mp ReGeneration rate
  trg;  				 xparam(9);                # TRG  Tp ReGeneration rate
  
  
  tgr;  				 sparam(0);                # TGR  TarGet Rate
  grd;  				 sparam(1);                # GRD  GuaRD effect rate
  rec;  				 sparam(2);                # REC  RECovery effect rate
  pha; 					 sparam(3);                # PHA  PHArmacology
  mcr; 					 sparam(4);                # MCR  Mp Cost Rate
  tcr; 					 sparam(5);                # TCR  Tp Charge Rate
  pdr; 					 sparam(6);                # PDR  Physical Damage Rate
  mdr;  		     sparam(7);                # MDR  Magical Damage Rate
  fdr; 					 sparam(8);                # FDR  Floor Damage Rate
  exr; 					 sparam(9);                # EXR  EXperience Rate

=end

module DND
  
  module SUBS
    
    # <param plus[xxx]: +n>
    PARAM_PLUS = /<(?:PARAM_PLUS|param plus)[ ](.+):[ ]([\+\-]\d+)>/i
    
    PARAM_TABLE = {
      "mhp"   =>   0,
      "mmp"   =>   1,
      "atk"   =>   2,
      "def"   =>   3,
      "mat"   =>   4,
      "mdf"   =>   5,
      "agi"   =>   6,
      "luk"   =>   7,
    }
  end
  
end


#==============================================================================
# *) DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_dnd load_database; end
  def self.load_database
    load_database_dnd
    load_notetags_dnd
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_dnd
  #--------------------------------------------------------------------------
  def self.load_notetags_dnd
    groups = [$data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_dnd
      end
    end
  end
  
end # DataManager


#==============================================================================
# *) RPG::State
#==============================================================================

class RPG::State < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :param_plus
  attr_accessor :xparam_plus
  attr_accessor :sparam_plus
  #--------------------------------------------------------------------------
  # common cache: load_notetags_abe
  #--------------------------------------------------------------------------
  def load_notetags_dnd
    
    @param_plus   = []
    @xparam_plus  = []
    @sparam_plus  = []
    
    (0...10).each do |i|
      @param_plus[i]  = 0
      @xparam_plus[i] = 0
      @sparam_plus[i] = 0
    end
    
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when DND::SUBS::PARAM_PLUS
        @param_plus[ get_param_id($1) ] = $2.to_i
      end
    } # self.note.split
    #---
  end
  #--------------------------------------------------------------------------
  # get abbr. param id
  #--------------------------------------------------------------------------
  def get_param_id(name)
    return DND::SUBS::PARAM_TABLE[name].to_i
  end
  
end # RPG::State

#==============================================================================
# ** Game_BattlerBase
#------------------------------------------------------------------------------
#  This base class handles battlers. It mainly contains methods for calculating
# parameters. It is used as a super class of the Game_Battler class.
#==============================================================================

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Overwrite method: param_plus
  #--------------------------------------------------------------------------
  def param_plus(param_id)
    @param_plus[param_id] + state_param_plus(param_id)
  end
  #--------------------------------------------------------------------------
  # * Get current states param plus
  #--------------------------------------------------------------------------
  def state_param_plus(param_id)
    @states.each do |state|
      return $data_states[state].param_plus[param_id]
    end
    return 0
  end
  #-------------
end
