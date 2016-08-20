#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Overwrite method: Update Events
  #--------------------------------------------------------------------------
  def update_events
    @events.each_value {|event| 
      event.update if event.page.need_update
    }
    @common_events.each {|event| event.update }
  end

end

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================

class Game_Event < Game_Character
  
  attr_accessor :need_update
  
  #--------------------------------------------------------------------------
  #   Add comment: <no update>
  #   to disable event update
  #--------------------------------------------------------------------------
  
  #--------------------------------------------------------------------------
  # * Event Page Setup
  #--------------------------------------------------------------------------
  alias setup_page_opt setup_page
  def setup_page(new_page)
    setup_page_opt(new_page)
    @need_update = true
    return if @page.nil?
    
    for command in @page.list
      if command.code == 108 && command.parameters[0].include?("<no update>")
        @need_update = false
      end
    end
    
  end
  
  def page
    @page
  end
  
end

#==============================================================================
#
# * Event::Page
#
#==============================================================================
class RPG::Event::Page

end


