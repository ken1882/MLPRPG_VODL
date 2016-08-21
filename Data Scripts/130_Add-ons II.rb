#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================

class Scene_Base
  #--------------------------------------------------------------------------
  # * Return to Calling Scene
  #--------------------------------------------------------------------------
  def return_scene
    current_scene = SceneManager.scene
    
    if current_scene.class == Scene_Menu
      $game_player.calc_move_speed_bonus
    end
    
    SceneManager.return
  end
end


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
  # * calc_move_speed_bonus
  #--------------------------------------------------------------------------
  def calc_move_speed_bonus
    
    @dash_speed_bonus = 0
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
    puts "[Character Base] Dash Speed Bonus: #{@dash_speed_bonus}"
  end  
  
  #--------------------------------------------------------------------------
  # * Get Move Speed (Account for Dash)
  # tag: modified
  #--------------------------------------------------------------------------
  def real_move_speed
    return @move_speed + (dash? ? 1 + ($game_variables[11]/100) + @dash_speed_bonus : 0)
  end
  #-----------
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias start_calc_move_speed start
  def start
    start_calc_move_speed
    $game_player.calc_move_speed_bonus
  end
  
end
