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
    # <saving throw adjust: (+/-x) * 8>
    # <saving throw adjust: 0, 0, 0, 0, 0, 0>
    # -> mhp, mmp, str, con, int, wis, dex, cha; first 2 should remain 0
    #-------------------------------------------------------------------------
    SAVING_THROW_ADJUST  = /<(?:SAVING_THROW_ADJUST|saving throw adjust):[ ](.+)>/i
    #-------------------------------------------------------------------------
    # <dc adjust: +/-x * 8>
    #-------------------------------------------------------------------------
    DC_ADJUST  = /<(?:DC_ADJUST|dc adjust):[ ](.+)>/i
    #-------------------------------------------------------------------------
    # <param adjust: +/-x * 8>
    #-------------------------------------------------------------------------
    Param_Adjust = /<(?:PARAM_ADJUST|param adjust):[ ](.+)>/i
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
    # <taem id: x>
    #-------------------------------------------------------------------------
    TeamID = /<(?:TEAM_ID|team id):[ ](\d+)>/i
    #-------------------------------------------------------------------------
    # <load image: x>   <load name: x>
    #-------------------------------------------------------------------------
    MapLoad_Image = /<(?:LOAD_IMAGE|load image):[ ](.+?)>/
    MapLoad_Name  = /<(?:LOAD_NAME|load name):[ ](.+?)>/
    #-------------------------------------------------------------------------
    # <load image: x>   <load name: x>
    #-------------------------------------------------------------------------
    MapBattleBGM = /<(?:BATTLE_BGM|battle bgm):[ ](.+?),[ ](\d+),[ ](\d+)>/i
    #-------------------------------------------------------------------------
  end
  
  # tag: event config
  module REGEX::NPCEvent
    Enemy           = /<(?:enemy):[ ](\d+)>/i
    StaticObject    = /<static object>/i
    ConfigON        = /(?:config)/i
    ConfigOFF       = /<(?:\/config)>/i
  end
  
  # See "tag: charparam" for details
  module REGEX::Character
    DefaultWeapon     = /(?:Default Weapon =)[ ](\d+)/i           # Weapon id when no weapon is equipped
    SecondaryWeapon   = /(?:Secondary Weapon =)[ ](\d+)/i         # Secondary Weapon id
    SecondaryArmor    = /(?:Secondary Armor =)[ ](\d+)/i          # Secondary Weapon in data_armors id
    TeamID            = /(?:Team ID =)[ ](\d+)/i                  # Team ID
    DeathSwitchSelf   = /(?:Death Self Switch =)[ ](.+?)/i        # Self Switch trigger when dead
    DeathSwitchGlobal = /(?:Death Global Switch =)[ ](\d+)/i      # Game_Switch trigger when dead
    DeathVarSelf      = /(?:Death Self Variable =)[ ](\d+), [ ](\d+)/i
    DeathVarGlobal    = /(?:Death Global Variable =)[ ](\d+), [ ](\d+)/i
    
    DefaultAmmo       = /(?:Default Ammo =)[ ](\d+)/i
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
    KOSound           = /(?:Knockdown Sound =)[ ](.+)/i           # Sound when KO
    CastGraphic       = /(?:Casting Graphic =)[ ](.+)/i
    CastIndex         = /(?:Casting Index =)[ ](\d+)/i
    CastPattern       = /(?:Casting pattern =)[ ](\d+)/i
    IconIndex         = /(?:Icon Index =)[ ](\d+)/i
    
    WeaponLvProtect   = /(?:Weapon Level Prof =)[ ](\d+)/i  # Immune weapon attacks bwlown N level
    CastingAnimation  = /(?:Casting Animation =)[ ](\d+)/i
    
    FaceName          = /(?:Face Name =)[ ](.+)/i   # Face file name
    FaceIndex         = /(?:Face Index=)[ ](\d+)/i  # Face index
    
    Body_Size         = /(?:Body Size =)[ ](\d+)/i  # Size of body to determine character sight visible 
  end
  
  #tag: event config
  module REGEX::Event
    Terminated        = /<(?:terminated)>/i                    # Finalize event
    Frozen            = /<(?:frozen)>/i
    Condition         = /<(?:condition:)[ ](.+)>/i
  end
  
  module REGEX::Map
    LightEffect       = /<(?:Fog Opacity:)[ ](\d+)>/i
  end
  
  
  # See "tag: equiparam" for details
  module REGEX::Equipment
    UserGraphic       = /(?:User Graphic =)[ ](.+)/i           # Sprite display on user
    ToolGraphic       = /(?:Tool Graphic =)[ ](.+)/i           # Tool sprite
    WeaponEffect      = /(?:Weapon effect skill =)[ ](\d+)/i   # Skill effect apply on hit
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
    ToolAnimation     = /(?:Tool Animation =)[ ](\d+)/i        # Animation display on tool/project on collide
    ToolAnimMoment    = /(?:Tool Animation Moment =)[ ](\d+)/i # Start moment of tool's animation
    ToolSpecial       = /(?:Tool Special =)[ ](\d+),[ ](\d*)/i # Tool Special, see the list below
    ToolScope         = /(?:Tool Scope =)[ ](\d+)/i            # Tool target scope, same as skill/item one
    ToolScopeDir      = /(?:Tool Scope Dir =)[ ](\d+)/i        # see tag 4 details
    ToolScopeAngle    = /(?:Tool Scope Angle =)[ ](\d+)/i      # c tag 4 details
    ToolInvokeSkill   = /(?:Tool Invoke Skill =)[ ](\d+)/i     # Skill id invoked upon the tool used
    ToolSE            = /(?:Tool SE =)[ ](.+),[ ](\d+)/i                # Sound Effect when tool is used
    ToolItemCost      = /(?:Tool Item Cost =)[ ](\d+)/i        # Item  id needed for using this tool
    ToolItemCostType  = /(?:Tool Wtype Cost =)[ ](\d+)/i       # Wtype id needed for using this tool
    ToolThrough       = /(?:Tool Through =)[ ](\d+)/i          # Tool go through obstacle?(0/1 = false/true)
    ToolPriority      = /(?:Tool Priority =)[ ](\d+)/i         # (Chatacter)Display Priority Type
    ToolHitShake      = /(?:Tool Hit Shake =)[ ](\d+)/i        # Level of screen shake upon tool hitting
    ToolType          = /(?:Tool Type =)[ ](\d+)/i             # Tool Type, 0 = missile, 1 = bomb
    ToolCombo         = /(?:Tool Combo =)[ ](\d+)/i            # Next Weapon Id use after player contiune to
                                                               #   using this tool (default: in 20 frames)
    
    DamageSavingThrow = /(?:Saving Throw =)[ ](.+),[ ](.+)/i   # Saving Throw when hitted
    ToolRanged        = /<(?:ranged)>/i
    ApplyAction       = /(?:Apply Action =)[ ](\d+)/i          # Apply given action sequence id when item is used
  end
  
  # tag: leveling
  # last work: add leveling tag to skills
  module REGEX::Leveling
    Leveling       = /<(?:leveling)>/i     # Just a leveling flag <leveling>
    
    # Select feats when level up, learned feat won't show up again unless
    # it has double proficient
    # Pattern: <selectable: skillid0, skillid1, skillid2...>
    # Example: <selectable: 10,11,12>
    Selectable     = /<(?:selectable:)[ ](.+)>/i  
    
    # DND Class Settings
    LoadStart      = /<(?:DND)>/i
    LoadEnd        = /<\/(?:DND)>/i
    Race           = /(?:race:)[ ](\d+)/i        # Race, next is race id in data_classes
    Subrace        = /(?:subrace:)[ ](\d+)/i
    Class          = /(?:class:)[ ](\d+)/i
    DualClass      = /(?:dualClass:)[ ](\d+)/i
    ClassParent    = /(?:parent:)[ ](\d+)/i  # parent class for advanced class
    HP             = /(?:HP:)[ ](\d+)/i      # init hp/hit dide
    EP             = /(?:EP:)[ ](\d+)/i      # init ep(plus for race)
    Requirement    = /(?:REQ:)[ ](.+)/i      # Score ability needed to choose
    Strength       = /(?:STR:)[ ](\d+)/i     # Score ability - str
    Constitution   = /(?:CON:)[ ](\d+)/i     # Score ability - con
    Intelligence   = /(?:INT:)[ ](\d+)/i     # Score ability - int
    Wisdom         = /(?:WIS:)[ ](\d+)/i     # Score ability - wis
    Dexterity      = /(?:DEX:)[ ](\d+)/i     # Score ability - dex
    Charisma       = /(?:CHA:)[ ](\d+)/i     # Score ability - cha
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
