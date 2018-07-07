#===============================================================================
# * Module DND::Utility
#-------------------------------------------------------------------------------
#   Utility functions
#===============================================================================
module DND
  module Utility
    #--------------------------------------------------------------------------
    # * Constants (Features)
    #--------------------------------------------------------------------------
    FEATURE_ELEMENT_RATE  = 11              # Element Rate
    FEATURE_DEBUFF_RATE   = 12              # Debuff Rate
    FEATURE_STATE_RATE    = 13              # State Rate
    FEATURE_STATE_RESIST  = 14              # State Resist
    FEATURE_PARAM         = 21              # Parameter
    FEATURE_XPARAM        = 22              # Ex-Parameter
    FEATURE_SPARAM        = 23              # Sp-Parameter
    FEATURE_ATK_ELEMENT   = 31              # Atk Element
    FEATURE_ATK_STATE     = 32              # Atk State
    FEATURE_ATK_SPEED     = 33              # Atk Speed
    FEATURE_ATK_TIMES     = 34              # Atk Times+
    FEATURE_STYPE_ADD     = 41              # Add Skill Type
    FEATURE_STYPE_SEAL    = 42              # Disable Skill Type
    FEATURE_SKILL_ADD     = 43              # Add Skill
    FEATURE_SKILL_SEAL    = 44              # Disable Skill
    FEATURE_EQUIP_WTYPE   = 51              # Equip Weapon
    FEATURE_EQUIP_ATYPE   = 52              # Equip Armor
    FEATURE_EQUIP_FIX     = 53              # Lock Equip
    FEATURE_EQUIP_SEAL    = 54              # Seal Equip
    FEATURE_SLOT_TYPE     = 55              # Slot Type
    FEATURE_ACTION_PLUS   = 61              # Action Times+
    FEATURE_SPECIAL_FLAG  = 62              # Special Flag
    FEATURE_COLLAPSE_TYPE = 63              # Collapse Effect
    FEATURE_PARTY_ABILITY = 64              # Party Ability
    #--------------------------------------------------------------------------
    # * Constants (Feature Flags)
    #--------------------------------------------------------------------------
    FLAG_ID_AUTO_BATTLE   = 0               # auto battle
    FLAG_ID_GUARD         = 1               # guard
    FLAG_ID_SUBSTITUTE    = 2               # substitute
    FLAG_ID_PRESERVE_TP   = 3               # preserve TP
    #--------------------------------------------------------------------------
    # * Constants (Starting Number of Buff/Debuff Icons)
    #--------------------------------------------------------------------------
    ICON_BUFF_START       = 64              # buff (16 icons)
    ICON_DEBUFF_START     = 80              # debuff (16 icons)
    #--------------------------------------------------------------------------
    # * (X/S)Param ID
    #--------------------------------------------------------------------------
    PARAM_MHP             = 0               # maximum hit point
    PARAM_MMP = PARAM_MEP = 1               # maximum MP/EP
    PARAM_STR = PARAM_ATK = 2               # Strength/Attack
    PARAM_CON = PARAM_DEF = 3               # Constitution/Defense
    PARAM_INT = PARAM_MAT = 4               # Intelligence/Magic Attack
    PARAM_WIS = PARAM_MDF = 5               # Wisdom/Magic Defense
    PARAM_DEX = PARAM_AGI = 6               # Dexterity/Agility
    PARAM_CHA = PARAM_LUK = 7               # Charisma/Luck
    #--------------------------------------------------------------------------
    XPARAM_HIT = XPARAM_THAC0 = 0           # Hit rate/To Hit Armor Class 0
    XPARAM_EVA = XPARAM_AC    = 1           # Evasion/Armor Class
    XPARAM_CRI                = 2           # Critical Rate
    XPARAM_CEV                = 3           # Critical Evasion Rate
    XPARAM_MEV                = 4           # Magic Evasion Rate
    XPARAM_MRF                = 5           # Magic Reflection Rate
    XPARAM_CNT                = 9           # Counter Attack Rate
    XPARAM_HRH                = 7           # HP Regeneration Rate
    XPARAM_MRG                = 8           # MP Regeneration Rate
    XPARAM_TRG                = 9           # TP Regeneration Rate
    #--------------------------------------------------------------------------
    SPARAM_TGR                = 0            # Target Rate
    SPARAM_GRD                = 1            # Guard Rate
    SPARAM_REC                = 2            # Recovery Rate
    SPARAM_PHA = SPARAM_CTR   = 3            # Pharmacology/Cast Time Reduction Rate
    SPARAM_MCR                = 4            # MP Cost Rate
    SPARAM_TCR = SPARAM_CSR   = 5            # TP Charge Rate/Casting Speed Rate
    SPARAM_PDR                = 6            # Physical Damage Rate
    SPARAM_MDR                = 7            # Magical Damamge Rate
    SPARAM_FDR                = 8            # Floor Damage Rate
    SPARAM_EXR                = 9            # Experience Rate
    #--------------------------------------------------------------------------
    def get_element_id(string)
      return string if string.is_a?(Numeric)
      string = string.upcase
      for i in 0...$data_system.elements.size
        return i if string == $data_system.elements[i].upcase
      end
      return 0
    end
    #--------------------------------------------------------------------------
    def get_param_id(string)
      return string if string.is_a?(Numeric)
      string = string.downcase.to_sym
      _id = 0
      if     string == :hp  then _id = 0
      elsif  string == :ep  then _id = 1
      elsif  string == :str then _id = 2
      elsif  string == :con then _id = 3
      elsif  string == :int then _id = 4
      elsif  string == :wis then _id = 5
      elsif  string == :dex then _id = 6
      elsif  string == :cha then _id = 7
      end
      return _id
    end
    #--------------------------------------------------------------------------
    def get_saving_name(saves)
      return Vocab::Equipment::None if saves.nil?
      return Vocab::Equipment::SavingName[saves.first]
    end
    #--------------------------------------------------------------------------
    def get_wtype_name(id)
      return Vocab::DND::WEAPON_TYPE_NAME[id]
    end
    #--------------------------------------------------------------------------
    def get_element_name(id)
      return Vocab::DND::ELEMENT_NAME[id]
    end
    #--------------------------------------------------------------------------
    def get_param_name(id)
      return (Vocab::DND::PARAM_NAME[id] || "")
    end
    #--------------------------------------------------------------------------
  end
end
