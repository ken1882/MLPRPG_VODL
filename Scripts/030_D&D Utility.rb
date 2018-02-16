#===============================================================================
# * Module DND::Utility
#-------------------------------------------------------------------------------
#   Utility functions
#===============================================================================
module DND
  module Utility
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
      if     string == :str then _id = 2
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
