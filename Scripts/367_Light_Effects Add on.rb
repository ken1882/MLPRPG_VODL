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
    
    if !dispose && !@list.nil? && $light_effects
      for command in @list
        if command.code == 108 && command.parameters[0].include?("[light")
          command.parameters[0].scan(/\[light ([0.0-9.9]+)\]/)
          effect = Light_Core::Effects[$1.to_i]
          @light = Light_SSource.new(self,effect[0],effect[1],effect[2],effect[3])
          $game_map.light_sources << self
          return
        elsif command.code == 108 && command.parameters[0].include?("enable_fog")
          puts "Fog Enabled"
          s = $game_map.effect_surface
          s.change_color(120,0,0,0,150)
        end # command.code == 108
      end # for command in @list
    elsif !$light_effects
      s = $game_map.effect_surface
      s.change_color(255,255,255,0,0)
    end # unless dispose
    
  end # def setup_light
  
  #--------------------------------------------------------
  # *) check if comment is in event page
  #--------------------------------------------------------
  def comment_include?(comment)
    return if comment.nil? || @list.nil?
    comment = comment.to_s
    for command in @list
      if command.code == 108
        return true if command.parameters[0].include?(comment)
      end # if command.code
    end # for command
    return false
  end # def comment
  #------------------
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  #------------------------------------------------------------------------------
  #   alias method: ssetup_events
  #------------------------------------------------------------------------------
  alias setup_events_light setup_events
  def setup_events
    setup_events_light
    $light_effects_forced = false
    @events.each_value { |event|
      $light_effects_forced ||= event.comment_include?("Force enable light effects")
    }
    $light_effects = $light_effects_forced
    puts "Force Enable Light Effects: #{$light_effects_forced}"
  end
end
