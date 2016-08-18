=begin
CSCA Infinite Balloons
version: 1.0.0 (Released: October 7, 2012)
Created by: Casper Gaming (http://www.caspergaming.com/)

Compatibility:
Made for RPGVXAce
IMPORTANT: ALL CSCA Scripts should be compatible with each other unless
otherwise noted.

FFEATURES:
Unlimited Balloons!

SETUP
Plug and Play. To show a custom balloon, make this script call:
csca_balloon(event, ballon, "filename"[, wait])

event is the event ID you want the balloon to appear above.
balloon is the balloon id you want to show(the first row is 1, etc.)
"filename" is the filename in Graphics/System that contains the custom balloon.
wait is optional, if true pauses event commands until balloon is done.

example: csca_balloon(1,1,"BalloonExample",true)

CREDIT:
Free to use in noncommercial games if credit is given to:
Casper Gaming (http://www.caspergaming.com/)

To use in a commercial game, please purchase a license here:
http://www.caspergaming.com/licenses.html

TERMS:
http://www.caspergaming.com/terms_of_use.html
=end
#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
# Adds extra balloon icon support.
# Aliases: initialize
#==============================================================================
class Game_CharacterBase
  attr_accessor :csca_balloon_file
  attr_accessor :csca_balloon_id
  #--------------------------------------------------------------------------#
  # Alias Method; Initialize                                                 #
  #--------------------------------------------------------------------------#
  alias :csca_balloon_init :initialize
  def initialize
    @csca_balloon_file = "Balloon"
    @csca_balloon_id = 0
    csca_balloon_init
  end
end
#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
# Adds command for playing additional balloons.
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------#
  # Show Extra Balloon Icons                                                 #
  #--------------------------------------------------------------------------#
  def csca_balloon(event, balloon, file, wait = false)
    character = get_character(event)
    if character
      character.csca_balloon_id = balloon
      character.csca_balloon_file = file
      Fiber.yield while character.csca_balloon_id > 0 if wait
    end
  end
end
#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
# Able to play balloons from multiple files.
# Aliases: setup_new_effect, end_balloon
#==============================================================================
class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------#
  # Alias Method; Setup new Effect                                           #
  #--------------------------------------------------------------------------#
  alias :csca_balloon_setup :setup_new_effect
  def setup_new_effect
    csca_balloon_setup
    if !@balloon_sprite && @character.csca_balloon_id > 0
      @balloon_id = @character.csca_balloon_id
      csca_start_balloon(@character.csca_balloon_file)
    end
  end
  #--------------------------------------------------------------------------#
  # Start CSCA Balloon                                                       #
  #--------------------------------------------------------------------------#
  def csca_start_balloon(file)
    dispose_balloon
    @balloon_duration = 8 * balloon_speed + balloon_wait
    @balloon_sprite = ::Sprite.new(viewport)
    @balloon_sprite.bitmap = Cache.system(file)
    @balloon_sprite.ox = 16
    @balloon_sprite.oy = 32
    update_balloon
  end
  #--------------------------------------------------------------------------#
  # Alias Method; End Balloon Icon                                           #
  #--------------------------------------------------------------------------#
  alias :csca_end_balloon :end_balloon
  def end_balloon
    csca_end_balloon
    @character.csca_balloon_id = 0
  end
end

#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
# Adds extra balloon icon support.
# Aliases: initialize
#==============================================================================
class Game_BattlerBase
  attr_accessor :csca_balloon_file
  attr_accessor :csca_balloon_id
  #--------------------------------------------------------------------------#
  # Alias Method; Initialize                                                 #
  #--------------------------------------------------------------------------#
  alias :csca_balloon_init :initialize
  def initialize
    @csca_balloon_file = "Balloon"
    @csca_balloon_id = 0
    csca_balloon_init
  end
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
# Able to play balloons from multiple files.
# Aliases: setup_new_effect, end_balloon
#==============================================================================
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------#
  # Alias Method; Setup new Effect                                           #
  #--------------------------------------------------------------------------#
  alias :csca_balloon_setup :setup_new_effect
  def setup_new_effect
    csca_balloon_setup
    if !@balloon_sprite && @battler.csca_balloon_id > 0 && @battler.alive? && @battler.visible
      @balloon_id = @battler.csca_balloon_id
      csca_start_balloon(@battler.csca_balloon_file)
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Free Balloon Icon
  #--------------------------------------------------------------------------
  def dispose_balloon
    if @balloon_sprite
      @balloon_sprite.dispose
      @balloon_sprite = nil
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Balloon Icon
  #--------------------------------------------------------------------------
  def update_balloon
    if @balloon_duration > 0
      @balloon_duration -= 1
      if @balloon_duration > 0
        @balloon_sprite.x = x
        @balloon_sprite.y = y - height
        @balloon_sprite.z = z + 200
        sx = balloon_frame_index * 32
        sy = (@balloon_id - 1) * 32
        @balloon_sprite.src_rect.set(sx, sy, 32, 32)
      else
        end_balloon
      end
    end
  end
  #--------------------------------------------------------------------------
  # * End Balloon Icon
  #--------------------------------------------------------------------------
  def end_balloon
    dispose_balloon
    @battler.balloon_id = 0
  end
  #--------------------------------------------------------------------------
  # * Balloon Icon Display Speed
  #--------------------------------------------------------------------------
  def balloon_speed
    return 15
  end
  
  #--------------------------------------------------------------------------
  # * Wait Time for Last Frame of Balloon
  #--------------------------------------------------------------------------
  def balloon_wait
    return 20
  end
  
  #--------------------------------------------------------------------------
  # * Frame Number of Balloon Icon
  #--------------------------------------------------------------------------
  def balloon_frame_index
    return 7 - [(@balloon_duration - balloon_wait) / balloon_speed, 0].max
  end
  
  #--------------------------------------------------------------------------#
  # Start CSCA Balloon                                                       #
  #--------------------------------------------------------------------------#
  def csca_start_balloon(file)
    dispose_balloon
    @balloon_duration = 8 * balloon_speed + balloon_wait
    @balloon_sprite = ::Sprite.new(viewport)
    @balloon_sprite.bitmap = Cache.system(file)
    @balloon_sprite.ox = 16
    @balloon_sprite.oy = 32
    update_balloon
  end
  #--------------------------------------------------------------------------#
  # Alias Method; End Balloon Icon                                           #
  #--------------------------------------------------------------------------#
  alias :csca_end_balloon :end_balloon
  def end_balloon
    csca_end_balloon
    @battler.csca_balloon_id = 0
  end
end