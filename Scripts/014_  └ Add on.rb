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
    DataManager.unpack_data if $ENCRYPT
    @timer = 0
    reserve_loading_screen
    DataManager.init
    Audio.setup_midi if use_midi?
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
    text.tr('\n','  ')
    scene = self.scene
    if scene.is_a?(Scene_Map) && !text.nil?
      scene.display_info(text)
    else
      @saved_map_infos.push(text)
    end
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
    if !store_projectile(scene_class)
      Cache.clear_projectiles
      $game_map.dispose_projectiles
    end
    goto_proj(scene_class)
  end
  #--------------------------------------------------------------------------
  # * Call
  #--------------------------------------------------------------------------
  class << self; alias call_proj call; end
  def self.call(scene_class)
    if !store_projectile(scene_class)
      Cache.clear_projectiles
      $game_map.dispose_projectiles
    end
    call_proj(scene_class)
  end
  #--------------------------------------------------------------------------
  def self.store_projectile(next_scene)
    return false unless scene_is?(Scene_Map)
    return false if next_scene.is_a?(Scene_Title)
    return false if next_scene.is_a?(Scene_Gameover)
    Cache.store_projectile($game_map.projectiles)
    return true
  end
  #--------------------------------------------------------------------------
  # *) Viewports
  #--------------------------------------------------------------------------
  def self.viewport1
    return nil unless scene_is?(Scene_Map)
    return scene.spriteset.viewport1
  end
  
  def self.viewport2
    return nil unless scene_is?(Scene_Map)
    return scene.spriteset.viewport2
  end
  
  def self.viewport3
    return nil unless scene_is?(Scene_Map)
    return scene.spriteset.viewport3
  end
  #--------------------------------------------------------------------------
  # *) Loading Screen process
  #--------------------------------------------------------------------------
  def self.reserve_loading_screen(map_id = nil)
    puts "[Debug]: Reserve load screen"
    info = get_map_loading_info(map_id)
    @loading_screen = ForeGround_Loading.new(info, map_id.nil?)
    self.fade_in(@loading_screen)
  end
  #--------------------------------------------------------------------------
  # *) Retrieve map loading information
  #--------------------------------------------------------------------------
  def self.get_map_loading_info(map_id)
    return if map_id.nil?
    map  = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
    info = Struct.new(:image, :name).new(nil, map.display_name)
    map.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::REGEX::MapLoad_Image
        info.image = $1.to_s
      when DND::REGEX::MapLoad_Name
        info.name  = $1.to_s
      end
    }
    return info
  end
  #--------------------------------------------------------------------------
  def self.destroy_loading_screen
    return unless @loading_screen
    puts "[Debug]: Terminate load screen"
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
    @loading_screen.set_loading_phase(info, total)
  end
  #--------------------------------------------------------------------------
  def self.loading?
    return @loading_screen && @loading_screen.loading?
  end
  #----------------------------------------------------------------------------
end
