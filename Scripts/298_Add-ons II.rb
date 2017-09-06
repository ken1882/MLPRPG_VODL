#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :dash_speed_bonus
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_add_onsII initialize
  def initialize
    initialize_add_onsII
    @dash_speed_bonus = 0
  end
  #--------------------------------------------------------------------------
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    set_direction(8) if ladder? && !self.is_a?(Game_Projectile)
    @stop_count = 0
    update_bush_depth
  end
  #--------------------------------------------------------------------------
  # * hash id
  #--------------------------------------------------------------------------
  def hash_id
    return self.id * 100 + self.character_name.size
  end
  #--------------------------------------------------------------------------
  # * calc_move_speed_bonus
  #--------------------------------------------------------------------------
  def calc_move_speed_bonus
    
    @dash_speed_bonus = 0
    #-------------------------------------------
    # Haste
    #-------------------------------------------
    @dash_speed_bonus += 0.3 if $game_party.leader.state?(283)
    #-------------------------------------------
    # Boots of Speed
    #-------------------------------------------
    for battler in $game_party.members
      for equip in battler.equips
        if equip.is_a?(RPG::Armor)
          
          if equip.name == "Boots of Speed"
            @dash_speed_bonus = [0.5,@dash_speed_bonus].max
          end # equip.name == "Boots of Speed"
          
        end # is_a?(Armor)
      end # for equip
    end # for battler
    
    #----------------------------------------------
  end  
  
  #--------------------------------------------------------------------------
  # * distance_to
  #--------------------------------------------------------------------------
  def distance_to(x1, y1, x2 = @x, y2 = @y)
    return Math.hypot(x1 - x2, y1 - y2)
  end
  
  #--------------------------------------------------------------------------
  # * Check if face toward character
  #--------------------------------------------------------------------------
  def face_toward_character?(character, range = nil)
    cx = @x - character.x
    cy = @y - character.y
    
    if range
      range += 0.3
      return false if Math.hypot(cx,cy) >= range
    end
    
    if cx.abs < cy.abs
      return cx > 0 ? @direction == 4 : @direction == 6
    else
      return cy > 0 ? @direction == 2 : @direction == 8
    end
    
  end
  
  #-----------
end
