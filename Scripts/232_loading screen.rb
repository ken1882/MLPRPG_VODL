module LoadingScreens
  module Regex
    LOADING_IMAGE = /<\s*load\s*image\s*(.+?)\s*>/
    DISPLAY_NAME = /<\s*load\s*name\s*(.+?)\s*>/
    MIN_LOAD_TIME = 200
  end
  @messages = []
  def self.get_map_info(map_id)
    map_data = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
    map_info = Struct.new(:image, :name).new(nil, map_data.display_name)
    map_data.note.split(/[\r\n]+/).each { |line|
      case line
        when LoadingScreens::Regex::LOADING_IMAGE
          map_info.image = $1.to_s
        when LoadingScreens::Regex::DISPLAY_NAME
          map_info.name = $1.to_s
      end
    }
    map_info
  end
  def self.make_plane(image, title)
    plane = Plane.new
    bitmap = Bitmap.new("Graphics/Pictures/" + image)
    dest_bitmap = Bitmap.new(Graphics.width, Graphics.height)
    dest_bitmap.stretch_blt(dest_bitmap.rect, bitmap, bitmap.rect)
    bitmap.dispose
    message = @messages.sample
    
    
    line_width = 60
    var_position = 120
    st_a = 0
    st_b = line_width
    while st_a <= message.size
      st_b = [st_b,message.size].min
      show_msg = message[st_a...st_b]
      show_msg += '-' if st_b != message.size && message[st_b].match(/^[[:alpha:]]$/)
      st_a += line_width
      st_b += line_width
      dest_bitmap.draw_text(0, Graphics.height - var_position, Graphics.width, 100, show_msg, 1) if show_msg
      var_position -= 20
    end
    
    
    dest_bitmap.font = Font.new
    dest_bitmap.font.size = 80
    dest_bitmap.draw_text(0, 50, Graphics.width, 130, title, 1)
    plane.bitmap = dest_bitmap
    plane.opacity = 0
    plane.z = 10000000
    plane
  end
  def self.fade_in plane
    if SceneManager.scene_is? Scene_Map
      SceneManager.scene.fade_loop(30) { |v|
        plane.opacity = v
      }
    end
  end
  def self.fade_out plane
    if SceneManager.scene_is? Scene_Map
      SceneManager.scene.fade_loop(30) { |v|
        plane.opacity = 255 - v
      }
    end
  end
  def self.destroy_plane plane
    plane.bitmap.dispose
    plane.dispose
  end
  def self.setup
    begin
      File.open("Data/loading_messages.txt") { |f|
        @messages = f.map { |l| l.strip }
      }
    rescue Errno::ENOENT
      puts "Warning: no loading messages available."
    end
  end
  setup
end
class Game_Interpreter
  # Transfer Player
  alias kb_loading_screen_command_201 command_201
  def command_201
    # These two lines are copied out of the original.
    return if $game_party.in_battle
    
    while $game_player.transfer? || $game_message.visible
      Fiber.yield
    end
    map_id = @params[1]
    map_info = LoadingScreens.get_map_info map_id
    if map_info.image && !$disable_loading_screen
      plane = LoadingScreens.make_plane map_info.image, map_info.name
      Graphics.update
      LoadingScreens.fade_in plane
      @params[5] = 2 # Disable the built-in fade.
      kb_loading_screen_command_201
      load_time_count = 0
      while load_time_count < LoadingScreens::Regex::MIN_LOAD_TIME
        Fiber.yield
        load_time_count += 1
      end
      LoadingScreens.fade_out plane
      LoadingScreens.destroy_plane plane
    else
      kb_loading_screen_command_201
    end
  end
end
