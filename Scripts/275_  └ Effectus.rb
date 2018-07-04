#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables.                                        [NEW]
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  
  if MakerSystems::Effectus::MAP_SCENE_WINDOW_IMPROVEMENTS
    #--------------------------------------------------------------------------
    # * Update.                                                           [REP]
    #--------------------------------------------------------------------------
    def update
      if @message_window
        unless @message_window.fiber
          @message_window.dispose
          @message_window = nil
        end
      else
        if $game_message.busy? && !$game_message.scroll_mode
          create_message_window
        end
      end
      if @scroll_text_window
        unless @scroll_text_window.text
          @scroll_text_window.dispose
          @scroll_text_window = nil
        end
      else
        if $game_message.scroll_mode && $game_message.has_text?
          create_scroll_text_window
        end
      end
      if @map_name_window && @map_name_window.show_count == 0 && 
         @map_name_window.contents_opacity == 0 
        @map_name_window.dispose
        @map_name_window = nil
      end
      super
      $game_map.update(true)
      $game_player.update
      $game_timer.update
      @spriteset.update
      $game_map.update_events
      $game_map.update_vehicles
      update_scene if scene_change_ok?
    end
    #--------------------------------------------------------------------------
    # * Create All Windows
    #--------------------------------------------------------------------------
    def create_all_windows
      if @message_window
        @message_window.dispose
        @message_window = nil
      end
      if @scroll_text_window
        @scroll_text_window.dispose
        @scroll_text_window = nil
      end
      create_location_window unless $game_map.display_name.empty?
    end
    #--------------------------------------------------------------------------
    # * Preprocessing for Transferring Player
    #--------------------------------------------------------------------------
    def pre_transfer
      @map_name_window.close if @map_name_window
      case $game_temp.fade_type
      when 0
        fadeout(fadeout_speed)
      when 1
        white_fadeout(fadeout_speed)
      end
    end
    #--------------------------------------------------------------------------
    # * Post Processing for Transferring Player
    #--------------------------------------------------------------------------
    def post_transfer
      case $game_temp.fade_type
      when 0
        Graphics.wait(fadein_speed / 2)
        fadein(fadein_speed)
      when 1
        Graphics.wait(fadein_speed / 2)
        white_fadein(fadein_speed)
      end
      create_location_window unless $game_map.display_name.empty?
      @map_name_window.open if @map_name_window
    end
  else
    #--------------------------------------------------------------------------
    # * Update.                                                           [REP]
    #--------------------------------------------------------------------------
    def update
      super
      $game_map.update(true)
      $game_player.update
      $game_timer.update
      @spriteset.update
      $game_map.update_events
      $game_map.update_vehicles
      update_scene if scene_change_ok?
    end
  end
end
