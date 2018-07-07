#==============================================================================
# ** Game_CommonEvent
#------------------------------------------------------------------------------
#  This class handles common events. It includes functionality for execution of
# parallel process events. It's used within the Game_Map class ($game_map).
#==============================================================================
class Game_CommonEvent
  #--------------------------------------------------------------------------
  # * Initialize.                                                       [REP]
  #--------------------------------------------------------------------------
  def initialize(common_event_id)
    @event = $data_common_events[common_event_id]
    refresh 
    if @event.parallel? || @event.autorun?
      trigger = $game_map.effectus_etriggers[:"switch_#{@event.switch_id}"]
      trigger << self unless trigger.include?(self)
    end
  end
  
end
