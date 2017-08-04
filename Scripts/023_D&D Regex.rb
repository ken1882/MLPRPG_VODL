module DND
  
  module REGEX
    #-------------------------------------------------------------------------
    # <thac0: +/-x>
    #-------------------------------------------------------------------------
    THAC0 = /<(?:THAC0|thac0):[ ]([\+\-]\d+)>/i
    #-------------------------------------------------------------------------
    # <ac: +/-x>
    #-------------------------------------------------------------------------
    ARMOR_CLASS = /<(?:AC|ac):[ ]([\+\-]\d+)>/i
    #-------------------------------------------------------------------------
    # <saving throw adjust x: +/-x>
    #-------------------------------------------------------------------------
    SAVING_THROW_ADJUST  = /<(?:SAVING_THROW_ADJUST|saving throw adjust)[ ](\d+):[ ]([\+\-]\d+)>/i
    #-------------------------------------------------------------------------
    # <dc adjust x: +/-x>
    #-------------------------------------------------------------------------
    DC_ADJUST  = /<(?:DC_ADJUST|dc adjust)[ ](\d+):[ ]([\+\-]\d+)>/i
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
    #-------------------------------------------------------------------------
    # <physical>
    #-------------------------------------------------------------------------
    IS_PHYSICAL = /<(?:PHYSICAL|physical)>/i
    #-------------------------------------------------------------------------
    # <magical>
    #-------------------------------------------------------------------------
    IS_MAGICAL = /<(?:MAGICAL|magical)>/i
    #-------------------------------------------------------------------------
    # <block by event>
    #-------------------------------------------------------------------------
    PROJ_BLOCK_BY_EVENT = /<(?:BLOCK BY EVENT|block by event)>/i
    #-------------------------------------------------------------------------
    # <damage ndx + q, element, modifier>
    #-------------------------------------------------------------------------
    DAMAGE = /<(?:DAMAGE|damage)[ ](.+)[ ]([\+\-]\d+),[ ](.+),[ ](.+)>/i
    #-------------------------------------------------------------------------
    # <item max: x>
    #-------------------------------------------------------------------------
    ITEM_MAX = /<(?:ITEM_MAX|item max):[ ](\d+)>/i
    #-------------------------------------------------------------------------
    # <physical damage modify: +/-x>
    #-------------------------------------------------------------------------
    PHY_DMG_MOD = /<(?:PHYSICAL_DAMAGE_MODIFY|physical damage modify):[ ]([\+\-]\d+)>/i
    #-------------------------------------------------------------------------
    # <magical damage modify: +/-x>
    #-------------------------------------------------------------------------
    MAG_DMG_MOD = /<(?:MAGICAL_DAMAGE_MODIFY|magical damage modify):[ ]([\+\-]\d+)>/i
    #-------------------------------------------------------------------------
    # <taem id: x>
    #-------------------------------------------------------------------------
    TeamID = /<(?:TEAM_ID|team id):[ ](\d+)>/i
    #-------------------------------------------------------------------------
    # <load image: x>   <load name: x>
    #-------------------------------------------------------------------------
    MapLoad_Image = /<(?:LOAD_IMAGE|load image):[ ](.+?)>/
    MapLoad_Name  = /<(?:LOAD_NAME|load name):[ ](.+?)>/
    #-------------------------------------------------------------------------
  end
  
  # tag: event config
  module REGEX::NPCEvent
    Enemy     = /<(?:enemy):[ ](\d+)>/i
    Static    = /<(?:static)>/i
    ConfigON  = /(?:config)/i
    ConfigOFF = /<(?:\/config)>/i
  end
  
  # See "tag: charparam" for details
  module REGEX::Character
    DefaultWeapon     = /(?:Default Weapon =)[ ](\d+)/i           # Weapon id when no weapon is equipped
    TeamID            = /(?:Team ID =)[ ](\d+)/i                  # Team ID
    DeathSwitchSelf   = /(?:Death Self Switch =)[ ](.+?)/i        # Self Switch trigger when dead
    DeathSwitchGlobal = /(?:Death Global Switch =)[ ](\d+)/i      # Game_Switch trigger when dead
    DeathVarSelf      = /(?:Death Self Variable =)[ ](\d+), [ ](\d+)/i
    DeathVarGlobal    = /(?:Death Global Variable =)[ ](\d+), [ ](\d+)/i
    # Variable change when dead, $2 = number, $3 = value
    
    DeathAnimation    = /(?:Death Animation =)[ ](\d+)/i          # Animation display when dead
    VisibleSight      = /(?:Visible Sight =)[ ](\d+)/i            # Sight range when not blinded
    BlindSight        = /(?:Blind Sight =)[ ](\d+)/i               # Sight range whem blinded
    Infravision       = /(?:Infravision =)[ ](\d+)/i              # As it says
    MoveLimit         = /(?:Move Limit =)[ ](\d+)/i               # Move Limit
    AggressiveLevel   = /(?:Aggressive Level =)[ ](\d+)/i         # 0~5, see tag for details
    
    KOGraphic         = /(?:Knockdown Graphic =)[ ](.+)/i         # KO Graphic Filename
    KOIndex           = /(?:Knockdown Index =)[ ](\d+)/i          # KO Graphic Index
    KOPattern         = /(?:Knockdown pattern =)[ ](\d+)/i        # KO Graphics Pattern
    KODirection       = /(?:Knockdown Direction =)[ ](\d+)/i      # KO Character Direction
    
    FaceName          = /(?:Face Name =)[ ](.+)/i   # Face file name
    FaceIndex         = /(?:Face Index=)[ ](\d+)/i  # Face index
  end
  
  #atag: event config
  module REGEX::Event
    Terminated        = /<(?:terminated)>/i                    # Finalize event
    Frozen            = /<(?:no update)>/i
  end
  
  # See "tag: equiparam" for details
  module REGEX::Equipment
    UserGraphic       = /(?:User Graphic =)[ ](.+)/i           # Sprite display on user
    ToolGraphic       = /(?:Tool Graphic =)[ ](.+)/i           # Tool sprite
    ToolIndex         = /(?:Tool Index =)[ ](\d+)/i            # Index of Graphic
    CoolDown          = /(?:Tool Cooldown =)[ ](\d+)/i         # CoolDownTime(CDT)
    ToolDistance      = /(?:Tool Distance =)[ ](\d+)/i         # Effective Range (for missiles)
    ToolEffectDelay   = /(?:Tool Effect Delay =)[ ](\d+)/i     # Delay until effect occur
    ToolDestroyDelay  = /(?:Tool Destroy Delay =)[ ](\d+)/i    # Tool Sprite dispose delay timeing
    ToolSpeed         = /(?:Tool Speed =)[ ](.+)/i             # Tool Move Speed
    ToolCastime       = /(?:Tool Cast Time =)[ ](\d+)/i        # Cast needed time until done
    ToolCastAnimation = /(?:Tool Cast Animation =)[ ](\d+)/i   # Casting animation
    ToolBlowPower     = /(?:Tool Blow Power =)[ ](\d+)/i       # Knockback power
    ToolPiercing      = /(?:Tool Piercing =)[ ](\d+)/i         # Piercing number
    ToolAnimMoment    = /(?:Tool Animation Moment =)[ ](\d+)/i # Start moment of tool's animation
    ToolSpecial       = /(?:Tool Special =)[ ](\d+),[ ](\d*)/i # Tool Special, see the list below
    ToolScope         = /(?:Tool Scope =)[ ](\d+)/i            # Tool target scope, same as skill/item one
    ToolInvokeSkill   = /(?:Tool Invoke Skill =)[ ](\d+)/i     # Skill id invoked upon the tool used
    ToolSE            = /(?:Tool SE =)[ ](.+)/i                # Sound Effect when tool is used
    ToolItemCost      = /(?:Tool Item Cost =)[ ](\d+)/i        # Item  id needed for using this tool
    ToolItemCostType  = /(?:Tool Wtype Cost =)[ ](\d+)/i       # Wtype id needed for using this tool
    ToolThrough       = /(?:Tool Through =)[ ](\d+)/i          # Tool go through obstacle?(0/1 = false/true)
    ToolPriority      = /(?:Tool Priority =)[ ](\d+)/i         # (Chatacter)Display Priority Type
    ToolHitShake      = /(?:Tool Hit Shake =)[ ](\d+)/i        # Level of screen shake upon tool hitting
    ToolType          = /(?:Tool Type =)[ ](\d+)/i             # Tool Type, 0 = missile, 1 = bomb
    ToolCombo         = /(?:Tool Combo =)[ ](\d+)/i            # Next Weapon Id use after player contiune to
                                                               #   using this tool (default: in 20 frames)
  end
  
  module COLOR
    HPHeal            = Color.new( 15, 140,  10)
    EPHeal            = Color.new(140, 230, 110)
    HPDamage          = Color.new(250,  45,  45)
    EPDamage          = Color.new(175,  55, 140)
    
    Black             = Color.new(  0,   0,   0)
    White             = Color.new(255, 255, 255)
    Red               = Color.new(255,   0,   0)
    Blue              = Color.new(  0,   0, 255)
    Green             = Color.new(  0, 255,   0)
    Yellow            = Color.new(255, 255,   0)
    Purple            = Color.new(128,   0, 255)
    Orange            = Color.new(255, 128,   0)
    Brown             = Color.new(128,  64,   0)
    Pink              = Color.new(255, 128, 255)
    Tan               = Color.new(200, 200, 110)
    
    HitPoint          = Green
    EnergyPoint       = Color.new(100, 200, 255)
  end
  
  module BattlerSetting
    
    RegenerateTime    = 30
    
    PhaseIdle         = 0
    PhaseCombat       = 1
    
    DefaultWeapon     = 0
    TeamID            = 1
    DeathSwitchSelf   = nil
    DeathSwitchGlobal = 0
    DeathVarSelf      = nil
    DeathVarGlobal    = [0, 0]
    VisibleSight      = 8
    BlindSight        = 0
    DeathAnimation    = 114
    Infravision       = false
    MoveLimit         = 30
    AggressiveLevel   = 4
  end
  
end
#===============================================================================
# Module Math
#===============================================================================
module Math
  
  def self.rotation_matrix(x, y, angle, flip = false)
    rx = x * Math.cos(angle.to_rad) - y * Math.sin(angle.to_rad)
    ry = x * Math.sin(angle.to_rad) + y * Math.cos(angle.to_rad)
    ry *= -1 if flip
    return [rx.round(6), ry.round(6)]
  end
  
  def self.slope(x1, y1, x2, y2)
    return nil if x2 == x1
    return (y2 - y1) / (x2 - x1)
  end
  
  #-----------------------------------------------------------------------------
  # *) in arc:
  #
  # x1, y1: target coord
  # x2, y2: source coord
  # angle1, angle2: left's and right's Generalized Angle
  # distance: effective distance
  #-----------------------------------------------------------------------------
  def self.in_arc?(x1, y1, x2, y2, angle1, angle2, distance)
    return false if self.hypot( x2 - x1, y2 - y1 ) > distance
    move_x = $game_map.width / 2
    move_y = $game_map.height / 2
    
    x1 = x1 - move_x
    y1 = move_y - y1
    x2 = x2 = move_x
    y2 = move_y - y2
    
    left_x   = x2 + self.rotation_matrix(1,0, angle1).at(0)
    left_y   = y2 + self.rotation_matrix(1,0, angle1).at(1)
    right_x  = x2 + self.rotation_matrix(1,0, angle2).at(0)
    right_y  = y2 + self.rotation_matrix(1,0, angle2).at(1)
    
    m1 = slope(x2, y2, left_x, left_y)
    m2 = slope(x2, y2, right_x, right_y)
    on_m1_right  = m1.nil? ? (angle1 == 90  ? x1 >= x2 : x1 <=x2) : (m1 > 0 ? m1 * x1 - y1 + (y2 - m1 * x2) <= 0 : m1 * x1 - y1 + (y2 - m1 * x2) >= 0)
    on_m2_left   = m2.nil? ? (angle2 == 270 ? x1 >= x2 : x1 <=x2) : (m2 < 0 ? m2 * x1 - y1 + (y2 - m2 * x2) >= 0 : m2 * x1 - y1 + (y2 - m2 * x2) <= 0)
    
    return on_m1_right && on_m2_left
  end
end
#===============================================================================
=begin
	class RPG::UsableItem::Effect
-----------------------------------------------------------------------------------------------------------------------------
|	Effect Name	|		code		|			data_id				|			value(		1		,		2		)		|	
-----------------------------------------------------------------------------------------------------------------------------
	Recover HP			11						unknow									Value (%)		Value(fixnum)
	Recover MP		  12						unknow									Value (%)		Value(fixnum)
	Recover TP	    13						unknow									Value (%)			    nil
	
	Add State			  21					object state id						Success Rate(%)		nil
	Remove State		22					object state id						Success Rate(%)		nil
	
	Buff    				31						Param id								Duration(turn)		nil
	Debuff	  			32						Param id
	
	Remove Buff			33						Param id
	Remove Debuff		34						Param id
	
	
	class RPG::BaseItem::Feature
-----------------------------------------------------------------------------------------------------------------------------
|	Effect Name	|	Attribute Code	|			data_id				|						value							|	
-----------------------------------------------------------------------------------------------------------------------------
Attack Element			31						element id								0.0
Element Rate			  11						element id								Rate(%)
Debuff Rate			  	12						param id									Rate(%)
State Rate			  	13						state id									Rate(%)
Param				      	21						param id									Rate(%)
Ex-Param		  	  	22						xparam id									Rate(%)
Sp-Param			    	23						sparam id									Rate(%)
-----------------------------------------------------------------------------------------------------------------------------
|	 Name		|		Attribute Code		|			
-----------------------------------------------------------------------------------------------------------------------------
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
  mev;  		   	 xparam(4);                # MEV  Magic EVasion rate
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
  mdr;           sparam(7);                # MDR  Magical Damage Rate
  fdr; 					 sparam(8);                # FDR  Floor Damage Rate
  exr; 					 sparam(9);                # EXR  EXperience Rate
  
=end
