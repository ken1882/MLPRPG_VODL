#===============================================================================
# * Falcao Pearl ABS script shelf # 9
#
# Pearl Antilag v 1.1
# This is just an add on for the Pearl ABS system, it run as standalone mode too
#
# This script reduce the lag coused by tons of events on a map, this script
# ignores parallel process events, and autorun events triggers
#
# Website: http://falcaorgss.wordpress.com/
# Foro: www.makerpalace.com
#===============================================================================
module PearlAntilag
  
  # How many tiles outside the screen the script going to tolerate
  OutRange = 2
  
  # if you want to disable the script for an especific evet, tag <global> in the
  # event name box
  
end
class Game_Map
  attr_reader :max_width, :max_height
  alias falcaopearl_antilag_initialize initialize
  def initialize
    set_max_screen
    falcaopearl_antilag_initialize
  end
  
  def set_max_screen
    @max_width  = (Graphics.width / 32).truncate
    @max_height = (Graphics.height / 32).truncate
  end
end
class << Graphics
  alias falcaopearl_antilag_g resize_screen
  def resize_screen(w, h)
    falcaopearl_antilag_g(w, h)
    $game_map.set_max_screen unless $game_map.nil?
  end
end
class Game_Event < Game_Character
  attr_accessor :allow_update
  alias falcaopearl_antilag_ini initialize
  def initialize(map_id, event)
    falcaopearl_antilag_ini(map_id, event)
    @ignore_antilag = event.name.include?('<global>')
    @parallel_mode = @trigger == 3 || @trigger == 4 || @ignore_antilag
    @allow_update = true
    update_on_screen_event
  end
  
  alias falcaopearl_antilag_page setup_page_settings
  def setup_page_settings
    falcaopearl_antilag_page
    @parallel_mode = @trigger == 3 || @trigger == 4 || @ignore_antilag
  end
  
  def update_on_screen_event
    @allow_update = false unless @parallel_mode
    max_w = $game_map.max_width ; max_h = $game_map.max_height
    out = PearlAntilag::OutRange
    sx = (screen_x / 32).to_i
    sy = (screen_y / 32).to_i
    if sx.between?(0 - out, max_w + out) and sy.between?(0 - out, max_h + out)
      @allow_update = true
    end
  end
  
  alias falcaopearl_antilag_up update
  def update
    unless @parallel_mode
      update_on_screen_event
      return unless @allow_update
    end
    falcaopearl_antilag_up
  end
end
class Sprite_Character < Sprite_Base
  alias falcaopearl_antilag_update update
  def update
    if @character.is_a?(Game_Event) #and !@character.parallel_mode
      unless @character.allow_update
        end_animation if @character.animation_id > 0
        end_balloon if @character.balloon_id > 0
        self.x = @character.screen_x
        self.y = @character.screen_y
        self.z = @character.screen_z
        return
      end
    end
    falcaopearl_antilag_update
  end
end
