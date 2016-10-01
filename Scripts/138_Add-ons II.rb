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
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    set_direction(8) if ladder? && !self.is_a?(Projectile)
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
  # * Get Move Speed (Account for Dash)
  # tag: modified
  #--------------------------------------------------------------------------
  def real_move_speed
    return @move_speed + (dash? ? 1 + ($game_variables[11]/100) + @dash_speed_bonus : 0)
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
#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Update During Autonomous Movement
  #--------------------------------------------------------------------------
  def update_self_movement
    if near_the_screen? && @stop_count > stop_count_threshold && @pathfinding_moves.empty?
      case @move_type
      when 1;  move_type_random
      when 2;  move_type_toward_player
      when 3;  move_type_custom
      end
    elsif !@pathfinding_moves.empty?
      process_pathfinding_movement
    end
  end
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
