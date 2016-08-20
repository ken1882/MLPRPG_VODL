#------------------------------------------------------------------------------#
#  Galv's Message Busts
#------------------------------------------------------------------------------#
#  For: RPGMAKER VX ACE
#  Version 1.1
#------------------------------------------------------------------------------#
#  2013-01-13 - version 1.1 - added option to make busts slide onto the screen
#  2012-12-01 - version 1.0 - release
#------------------------------------------------------------------------------#
#  This script automatically displays a message bust instead of a face.
#------------------------------------------------------------------------------#
#  INSTRUCTIONS:
#  Put in script list below Materials and above Main.
#
#  Put bust images in GraphicsGraphics/Pictures/ and name them the same as the face
#  graphic used in the message, plus the position of the face in it.
#  For example:
#  If the message shows "Actor1" face file and uses the first face in that file
#  then you will name the bust image "Actor1-1.png"
#
#  Download the demo if you don't understand
#------------------------------------------------------------------------------#
#  SCRIPT CALL
#------------------------------------------------------------------------------#
#  
#  bust_mirror(x)           # x can be true or false. All messages after this
#                           # call will change until changed again.
#                           # false = on left. true = on right and flipped.
#
#------------------------------------------------------------------------------#

($imported ||= {})["Galvs_Message_Busts"] = true
module Galv_Bust

#------------------------------------------------------------------------------#
#  SCRIPT SETTINGS
#------------------------------------------------------------------------------#

  DISABLE_SWITCH = 999 # Turn swith ON to disable busts and show normal face
  
  BUST_Z = -1          # adds to z value of busts if needed. A negative number
                       # will make the bust appear below the message window.
  
  BUST_Y_OVER = false  # can be true or false
                       # true = busts sit at the bottom of the screen
                       # false = busts sit on top of the message window

  TEXT_X = 0           # Offset text when displaying busts above the message
                       # window. The script automatically offsets the text x 
                       # by the bust image width IF the BUST_Z is 0 or more.

  SLIDE = true         # Slide portrait onto the screen instead of fading in.
  
#------------------------------------------------------------------------------#
#  END SCRIPT SETTINGS
#------------------------------------------------------------------------------#

end


class Game_Interpreter
  
  def bust_mirror(state)
    $game_message.mirror = state
  end

  alias galv_busts_command_101 command_101
  def command_101
    $game_message.bust_name = @params[0]
    $game_message.bust_index = @params[1]
    galv_busts_command_101
  end
end # Game_Interpreter


class Game_Message
  attr_accessor :bust_name
  attr_accessor :bust_index
  attr_accessor :mirror
  
  alias galv_busts_message_initialize initialize
  def initialize
    galv_busts_message_initialize
    @mirror = false
  end

  alias galv_busts_message_clear clear
  def clear
    @bust_name = ""
    @bust_index = 0
    galv_busts_message_clear
  end
end # Game_Message


class Window_Message < Window_Base
  
  alias galv_busts_window_create_back_bitmap create_back_bitmap
  def create_back_bitmap
    @bust = Sprite.new if @bust.nil?
    @bust.visible = true
    @bust.opacity = 0
    @bust.z = z + Galv_Bust::BUST_Z
    galv_busts_window_create_back_bitmap
  end
  
  alias galv_busts_window_dispose dispose
  def dispose
    galv_busts_window_dispose
    dispose_bust
  end
  
  def dispose_bust
    @bust.dispose if !@bust.nil?
    @bust.bitmap.dispose if !@bust.bitmap.nil?
  end
  
  alias galv_busts_window_update_back_sprite update_back_sprite
  def update_back_sprite
    galv_busts_window_update_back_sprite
    update_bust if openness > 0
  end
  
  def update_bust
    if !$game_message.bust_name.empty? && !$game_switches[Galv_Bust::DISABLE_SWITCH]
      @bust.mirror = $game_message.mirror
      @bust.bitmap = Cache.face($game_message.bust_name + "-" + ($game_message.bust_index + 1).to_s)
      if !$game_message.mirror
        if Galv_Bust::SLIDE
          @bust.x = ((openness.to_f / 255) * @bust.width) - @bust.width
        else
          @bust.x = 0
        end
      else
        if Galv_Bust::SLIDE
          @bust.x = Graphics.width - ((openness.to_f / 255) * @bust.width)
        else
          @bust.x = Graphics.width - @bust.bitmap.width
        end
      end
      
      if $game_message.position == 2 && !Galv_Bust::BUST_Y_OVER
        @bust.y = Graphics.height - @bust.bitmap.height - self.height
      else
        @bust.y = Graphics.height - @bust.bitmap.height
      end
    else
      @bust.bitmap = nil
    end
    if $game_switches[Galv_Bust::DISABLE_SWITCH]
      @bust.opacity = 0
    else
      @bust.opacity = openness
      
    end
    @bust.update
  end
  
  def new_line_x
    if $game_switches[Galv_Bust::DISABLE_SWITCH]
      $game_message.face_name.empty? ? 0 : 112
    else
      if @bust.z >= self.z && !$game_message.mirror && $game_message.position == 2
        $game_message.face_name.empty? ? 0 : @bust.bitmap.width + Galv_Bust::TEXT_X
      else
        return 0
      end
    end
  end
  
  def draw_face(face_name, face_index, x, y, enabled = true)
    return if !$game_message.face_name.empty? && !$game_switches[Galv_Bust::DISABLE_SWITCH]
    super
  end

end # Window_Message < Window_Base