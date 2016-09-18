#==============================================================================
# +++ MOG - Simple Diagonal Movement (v1.0) +++
#==============================================================================
# By Moghunter
# http://www.atelier-rgss.com
#==============================================================================
# Sistema simples de movimento na diagonal.
#==============================================================================

#==============================================================================
# ■ Diagonal Movement
#==============================================================================
class Game_Player < Game_Character  
  
  #--------------------------------------------------------------------------
  # ● Move By Input
  #--------------------------------------------------------------------------    
  def move_by_input
      return unless movable?
      return if $game_map.interpreter.running?
      case Input.dir8
           when 2,4,6,8;   move_straight(Input.dir4)                 
           when 1 
               move_diagonal(4, 2)
               unless moving?
                   move_straight(4)
                   move_straight(2)                 
               end  
           when 3
                move_diagonal(6, 2)
                unless moving?
                   move_straight(6)
                   move_straight(2)
                end
           when 7
                 move_diagonal(4, 8)
                 unless moving?
                    move_straight(4)
                    move_straight(8)
                end
           when 9  
                 move_diagonal(6, 8)
                 unless moving?
                    move_straight(6)
                    move_straight(8)
                end
      end    
  end
  
end

$mog_rgss3_simple_diagonal_movement = true