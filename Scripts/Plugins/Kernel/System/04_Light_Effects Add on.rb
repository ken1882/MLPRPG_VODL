#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================
class Game_Event < Game_Character
  
  #--------------------------------------------------------
  # *) setup light
  #--------------------------------------------------------
  def setup_light(dispose)
    
    unless @light.nil?
      $game_map.light_sources.delete(self)
      @light.dispose
      @light = nil
    end
    
    if !dispose && !@list.nil?
      for command in @list
        if command.code == 108 && command.parameters[0].include?("[light")
          command.parameters[0].scan(/\[light ([0.0-9.9]+)\]/)
          effect = Light_Core::Effects[$1.to_i]
          @light = Light_SSource.new(self,effect[0],effect[1],effect[2],effect[3])
          $game_map.light_sources << self
          return
        end # command.code == 108
      end # for command in @list)
    end # unless dispose
    
  end # def setup_light
  
  
  #------------------
end
class Block_Surface
  
  def dispose
    valid = bitmap && !bitmap.disposed? rescue false
    return unless valid
    bitmap.dispose
  end
  
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
end
