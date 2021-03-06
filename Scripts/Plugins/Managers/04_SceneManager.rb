#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================
module SceneManager
  #--------------------------------------------------------------------------
  # * Module Instance Variables
  #--------------------------------------------------------------------------
  @ui_visible = true                # user interface visibility
  @load_completed = false
  @loading_screen = nil
  #--------------------------------------------------------------------------
  # * Execute
  #--------------------------------------------------------------------------
  def self.run
    FileManager.export_all_map_dialog
    DataManager.unpack_data if $ENCRYPT
    @timer = 0
    info = Vocab::InitLoadingMsg
    reserve_loading_screen(nil, subtitle: info)
    DataManager.init
    Audio.setup_midi if use_midi?
    Mouse.hide_global_cursor
    @scene = first_scene_class.new
    @scene.main while @scene
  end
  #--------------------------------------------------------------------------
  def self.update_loading
    return unless @loading_screen
    @timer += 1
    Graphics.update
    @loading_screen.update
  end
  #----------------------------------------------------------------------------
  # *)  Disply texts on info box
  #----------------------------------------------------------------------------
  def self.display_info(text = nil)
    return unless scene.is_a?(Scene_Map)
    return if text.nil?
    text.tr('\n','  ')
    scene.display_info(text)
    #if scene.is_a?(Scene_Map) && !text.nil?
    #  scene.display_info(text)
    #else
    #  @saved_map_infos.push(text)
    #end
  end
  #----------------------------------------------------------------------------
  # *) Scene Stack
  #----------------------------------------------------------------------------
  def self.stack
    @stack
  end
  #--------------------------------------------------------------------------
  # * Exit Game
  #--------------------------------------------------------------------------
  class << self; alias exit_stable exit; end
  def self.exit
    self.return unless self.scene_stable?
    sleep(0.1)
    self.exit_stable
  end
  #--------------------------------------------------------------------------
  # * Check if current scene is stable for exit
  #--------------------------------------------------------------------------
  def self.scene_stable?
    return false if self.scene.is_a?(Scene_Text)
    return true
  end
  
  def self.ui_visible?
    @ui_visible
  end
  
  def self.hide_ui
    @ui_visible = false
  end
  
  def self.show_ui
    @ui_visible = true
  end
  #--------------------------------------------------------------------------
  # * Direct Transition
  #--------------------------------------------------------------------------
  class << self; alias goto_proj goto; end
  def self.goto(scene_class)
    return if $on_exit
    goto_proj(scene_class)
  end
  #--------------------------------------------------------------------------
  # * Call
  #--------------------------------------------------------------------------
  class << self; alias call_proj call; end
  def self.call(scene_class)
    return if $on_exit
    call_proj(scene_class)
  end
  #--------------------------------------------------------------------------
  def self.spriteset
    return unless scene_is?(Scene_Map)
    scene.spriteset
  end
  #--------------------------------------------------------------------------
  def self.setup_projectile(proj)
    return unless scene_is?(Scene_Map)
    spriteset.setup_projectile(proj)
  end
  #--------------------------------------------------------------------------
  def self.setup_popinfo(text, position, color, icon_id = 0)
    return unless scene_is?(Scene_Map)
    spriteset.setup_popinfo(text, position, color, icon_id)
  end
  #--------------------------------------------------------------------------
  def self.dispose_temp_sprites
    return unless scene_is?(Scene_Map)
    spriteset.dispose_temp_sprites
  end
  #--------------------------------------------------------------------------
  # *) Viewports
  #--------------------------------------------------------------------------
  def self.viewport
    return scene.viewport
  end
  #--------------------------------------------------------------------------
  def self.superviewport
    return scene.superviewport
  end
  #--------------------------------------------------------------------------
  def self.viewport1
    return nil unless scene_is?(Scene_Map)
    return scene.spriteset.viewport1
  end
  #--------------------------------------------------------------------------
  def self.viewport2
    return nil unless scene_is?(Scene_Map)
    return scene.spriteset.viewport2
  end
  #--------------------------------------------------------------------------
  def self.viewport3
    return nil unless scene_is?(Scene_Map)
    return scene.spriteset.viewport3
  end
  #--------------------------------------------------------------------------
  # *) Loading Screen process
  #--------------------------------------------------------------------------
  def self.reserve_loading_screen(map_id = nil, configs = {})
    info = get_map_loading_info(map_id)
    return if GameManager.skip_loading?
    debug_print "Reserve load screen"
    @loading_screen = ForeGround_Loading.new(info, map_id.nil?, configs)
    self.fade_in(@loading_screen)
  end
  #--------------------------------------------------------------------------
  # *) Retrieve map loading information
  #--------------------------------------------------------------------------
  def self.get_map_loading_info(map_id)
    return if map_id.nil?
    $battle_bgm = nil
    map  = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
    info = Struct.new(:image, :name).new(nil, map.display_name)
    map.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::REGEX::MapLoad_Image
        info.image = $1.to_s
      when DND::REGEX::MapLoad_Name
        info.name  = $1.to_s
      when DND::REGEX::MapBattleBGM
        audio = RPG::BGM.new
        audio.name   = $1.to_s
        audio.volume = $2.to_i rescue 80
        audio.pitch  = $3.to_i rescue 100
        $battle_bgm  = audio
        debug_print "Map(#{info.name}, #{map.display_name})\nbattle BGM: #{audio.name} V/P: #{audio.volume}/#{audio.pitch}"
      end
    }
    return info
  end
  #--------------------------------------------------------------------------
  def self.destroy_loading_screen
    return unless @loading_screen
    debug_print "Terminate load screen"
    self.fade_out(@loading_screen)
    @loading_screen.terminate
    @loading_screen = nil
  end
  #--------------------------------------------------------------------------
  # *) Fade in screen
  #--------------------------------------------------------------------------
  def self.fade_in(plane)
    return unless scene_is?(Scene_Map)
    SceneManager.scene.fade_loop(30) do |value|
      plane.opacity = value
    end
  end
  #--------------------------------------------------------------------------
  # *) Fade out screen
  #--------------------------------------------------------------------------
  def self.fade_out(plane)
    return unless scene_is?(Scene_Map)
    SceneManager.scene.fade_loop(30) do |value|
      plane.opacity = 0xff - value
    end
  end
  #--------------------------------------------------------------------------
  def self.set_loading_phase(info, total)    
    return if GameManager.skip_loading?
    @loading_screen.set_loading_phase(info, total)
  end
  #--------------------------------------------------------------------------
  def self.loading?
    return @loading_screen && @loading_screen.loading?
  end
  #----------------------------------------------------------------------------
  def self.focus_game_window
    # Just to prevent re-spawning the console since
    # Tsuki uses this same part in his Test Edit script
    if !$imported["TH_TestEdit"]
      # Get game window text
      console_w = PONY::API::GetForegroundWindow.call
      buf_len = Win32API.new('user32','GetWindowTextLength', 'L', 'I').call(console_w)
      str = ' ' * (buf_len + 1)
      Win32API.new('user32', 'GetWindowText', 'LPI', 'I').call(console_w , str, str.length)
      
      if debug_mode?
        # Initiate console
        Win32API.new('kernel32.dll', 'AllocConsole', '', '').call
        Win32API.new('kernel32.dll', 'SetConsoleTitle', 'P', '').call('RGSS3 Console')
        $stdout.reopen('CONOUT$')
      end
      Win32API.new('user32.dll', 'SetForegroundWindow', 'P', '').call(PONY::API::Hwnd)
    end
  end
  #----------------------------------------------------------------------------
  def self.send_input(string)
    scene.retrieve_input(string)
  end
  #----------------------------------------------------------------------------
  def self.get_input
    scene.get_input
  end
  #----------------------------------------------------------------------------
  def self.setup_weapon_use(action)
    return unless scene_is?(Scene_Map)
    scene.setup_weapon_use(action)
  end
  #----------------------------------------------------------------------------
  def self.item_help_window
    scene.item_help_window
  end
  #----------------------------------------------------------------------------
  def self.show_item_help_window(x = 0, y = 0, text = "")
    scene.show_item_help_window(x, y, text)
  end
  #-------------------------------------------------------------------------
  def self.hide_item_help_window
    scene.hide_item_help_window
  end
  #-------------------------------------------------------------------------
  def self.immediate_refresh
    return unless spriteset
    spriteset.relocate_units
    spriteset.update_huds
  end
  #-------------------------------------------------------------------------
  def self.register_item_drop(instance, x, y)
    return unless spriteset
    return spriteset.register_item_drop(instance, x, y)
  end
  #-------------------------------------------------------------------------
  def self.create_override_sprite(battler)
    return unless spriteset || battler.nil?
    spriteset.create_override_sprite(battler)
  end
  #-------------------------------------------------------------------------
  def self.dispose_override_sprite(battler)
    return unless spriteset || battler.nil?
    spriteset.dispose_override_sprite(battler)
  end
  #-------------------------------------------------------------------------
  def self.register_all_dead_rescue(proc)
  end
  #-------------------------------------------------------------------------
  def self.call_all_dead_rescue
    PONY::Rescue.CallPrincessLuna
  end
  #-------------------------------------------------------------------------
  def self.update_basic
    return unless scene
    scene.update_basic
  end
  #-------------------------------------------------------------------------
  def self.show_dim_background
    return unless scene
    scene.show_dim_background
  end
  #-------------------------------------------------------------------------
  def self.hide_dim_background
    return unless scene
    scene.hide_dim_background
  end
  #-------------------------------------------------------------------------
end
