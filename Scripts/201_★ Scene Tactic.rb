#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================
module SceneManager
  
  def self.all_battlers
    return unless self.scene.is_a?(Scene_Map)
    
    battlers = [$game_player]
    $game_player.followers.each do |follower|
      next if follower.actor.nil?
      battlers.push(follower)
    end
    battlers += $game_map.event_enemies
    
    return battlers
  end
  
  def self.display_info(text = nil)
    scene = self.scene
    return unless scene.is_a?(Scene_Map) && !text.nil?
    scene.display_info(text)
  end
  
  
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #----------------------------------------------------------------------------
  # Window names: should be replaced by Integer for CPU efficiency  
    Win_Help    = :help        #'help'
    Menu_Actor  = :actor       #'actor'
    Win_Confirm = :confirm     #'confirm'
    Win_Status  = :status      #'status'
    Win_Detail  = :detail      #'detail'
    Win_Item, Win_Skill, Win_Revive   = :item, :skill, :revive      #'item', 'skill', 'revive'
    Win_Option, Win_Config, Win_Color = :option, :config, :color  #'option', 'config', 'color'
    Win_LevelUp = :earned   #'earned'
    Act_List    = :act_list    #'Act List'
  #============================================================================
  #-----------------------------------------------------------------------------
  # *) Instance Variables
  #-----------------------------------------------------------------------------
  attr_accessor :tactic_enabled
  attr_reader   :button_cooldown
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias start_dnd start
  def start
    @button_cooldown = 0
    @tactic_enabled = false
    $tactic_enabled = false if $tactic_enabled.nil?
    $scene_switched = $tactic_enabled || @tactic_enabled
    $tbs_cursor = TBS_Cursor.new
    create_windows
    start_dnd
  end
  #--------------------------------------------------------------------------
  # * Start Tactic
  #--------------------------------------------------------------------------
  def start_tactic
    @tactic_enabled = true
    $tactic_enabled = true
    $tbs_cursor.active = true
    $tbs_cursor.moveto(POS.new($game_player.x, $game_player.y))
    @window_info.add_text("Paused")
    $scene_switched = false
  end
  #--------------------------------------------------------------------------
  # * End Tactic
  #--------------------------------------------------------------------------
  def end_tactic
    @tactic_enabled = false
    $tactic_enabled = false
    $tbs_cursor.active = false
    actor_menu_cancel
    @windows[Win_Help].visible = false
    disable_cursor
    @window_info.add_text("Unpaused")
    update_win_visible
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_tactic_buttons
    @spriteset.update
    $tbs_cursor.update     if !@window_info.active && !@windows[Menu_Actor].active
    update_scene           if @tactic_enabled && !Input.press?(:kALT) && !@windows[Menu_Actor].visible && $tbs_cursor.mode.nil?
    $game_map.update(true) if $game_map.need_refresh
    update_win_visible     if @tactic_enabled
    return if @tactic_enabled && !Input.press?(:kALT)
    $game_map.update(true)
    $game_player.update
    $game_timer.update
    update_scene           if scene_change_ok?
  end
  #--------------------------------------------------------------------------
  # *) Quick menu buttons update
  #--------------------------------------------------------------------------
  def update_menu_buttons
    return if $game_map.interpreter.running?
    return if $game_player.pearl_menu_call[1] > 0
    
    if PearlKey.trigger?(Key::QuickTool)
      return if $game_player.knockdown_data[0] > 0
      $game_player.force_cancel_actions
      SceneManager.call(Scene_QuickTool)
    end
    if !PearlKernel::SinglePlayer and PearlKey.trigger?(Key::PlayerSelect)
      SceneManager.call(Scene_CharacterSet)
    end
    
    # SceneManager.call(Scene_BattlerSelection) # for latter use
  end
  #----------------------------------------------------------------------------
  # Defines windows
  #----------------------------------------------------------------------------
  def create_windows
    @windows = {}
    ##Help - Creates the help window
    @windows[Win_Help] = TBS_Window_Help.new
    @windows[Win_Help].move_to(2)
    
    #Create Command Window
    create_command_window
    
    #Create Status Windows - Both Full and Mini
    create_status_windows
    
    ##make all items partially transparent
    for type, window in @windows
      window.back_opacity = GTBS::CONTROL_OPACITY
      window.visible = false
      window.active = false
    end
    
    @window_info = Window_InformationLog.new
    check_window_info_resume
  end
  #----------------------------------------------------------------------------
  # Status windows
  #----------------------------------------------------------------------------
  def create_status_windows
    ##Detailed status
    #@windows[Win_Detail] = Window_Full_Status.new(nil)
    ##Get current event(actor/enemy) status
    @windows[Win_Status] = Windows_Status_GTBS.new
    #@windows[Win_Status].win_help = @windows[Win_Help];
  end
  #-------------------------------------------------------------------------
  # Update_Selected - returns cursor selected actor
  #-------------------------------------------------------------------------
  def update_selected
    @selected = $game_map.occupied_by?($tbs_cursor.x, $tbs_cursor.y,
                   $battle_cursor_sprite.x, $battle_cursor_sprite.y)
  end
  #----------------------------------------------------------------------------
  # Update Window Visible
  #----------------------------------------------------------------------------
  def update_win_visible
    update_selected
    obj = @selected.nil? ? nil : @selected[0]
    @windows[Win_Status].update(obj)
    @windows[Win_Status].visible = @tactic_enabled && @selected
    @opacity = 0 if scene_changing?
    
    #puts "#{$tbs_cursor.mode}" if @windows[Win_Help].visible
    update_actor_menu if @windows[Menu_Actor].active
    cursor_use_move   if $tbs_cursor.mode == TBS_Cursor::Move
  end
  #----------------------------------------------------------------------------
  # Display info on window
  #----------------------------------------------------------------------------
  def display_info(text)
    @window_info.add_text(text)
  end
  #----------------------------------------------------------------------------
  # Clear info
  #----------------------------------------------------------------------------
  def clear_info
    @winow_info.clear
  end
  #----------------------------------------------------------------------------
  # Update Actor Menu
  #----------------------------------------------------------------------------
  def update_actor_menu
    if @active_battler == nil 
      @windows[Menu_Actor].deactivate
      return
    elsif @active_battler.death_state?
      @windows[Menu_Actor].deactivate
      return
    end
    @windows[Menu_Actor].visible = true  #||=
    @windows[Menu_Actor].update
    #@windows[Win_Status].visible = true
  end
  #--------------------------------------------------------------------------
end
#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================
class Spriteset_Map
  #-----------------------------------------------------------------------------
  # *) Instance Variables
  #-----------------------------------------------------------------------------
  attr_accessor :viewport1
  attr_reader   :viewport2
  attr_reader   :cursor_range
  attr_reader   :cursor
  attr_reader   :units
  attr_reader   :map
  attr_reader   :tile_sprites
  attr_reader   :actor_sprites
  attr_reader   :enemy_sprites
  attr_reader   :event_sprites
  #-----------------------------------------------------------------------------
  # *) Initialize
  #-----------------------------------------------------------------------------
  alias initialize_dnd initialize
  def initialize(*args)
    initialize_dnd
    create_tactic_sprites
  end
  #--------------------------------------------------------------------------
  # * Alias: Create Character Sprite
  #--------------------------------------------------------------------------
  alias create_characters_dnd create_characters
  def create_characters
    create_characters_dnd
    
    battlers = SceneManager.all_battlers
    @units = []
    $battle_unit_sprites  = []
    @character_sprites.each do |char|
      next unless battlers.include?(char.character)
      obj = Unit_Circle.new(@viewport1, char, char.character)
      @units.push(obj)
      $battle_unit_sprites.push(obj)
    end
  end
  #-----------------------------------------------------------------------------
  # *) Create tactic sprites
  #-----------------------------------------------------------------------------
  def create_tactic_sprites
    create_cursor
  end
  #-----------------------------------------------------------------------------
  def create_cursor
    @cursor = Battle_Cursor.new(@viewport1)
    @cursor.visible = $tactic_enabled
  end
  #-----------------------------------------------------------------------------
  # *) update
  #-----------------------------------------------------------------------------
  alias update_dnd update
  def update
    update_cursor
    update_damagepop_sprites
    return if $tactic_enabled && !$scene_switched && !Input.press?(:kALT) &&
              !$game_map.need_refresh
    update_dnd
  end
  #--------------------------------------------------------------------
  def update_cursor
    return if @cursor.nil?
    @cursor.update
    @units.each do |unit|
      unit.update
    end
    
  end
  #-----------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  #-------------------------------------------------------------------------
  # Occupied? - Is cursor location occupied by battler (living or dead)
  #-------------------------------------------------------------------------
  def occupied_by?(x, y, sx = 0 ,sy = 0)
    return nil if !SceneManager.scene_is?(Scene_Map)
    battlers = [$game_player]
    $game_player.followers.each do |follower|
      next if follower.actor.nil?
      battlers.push(follower)
    end
    battlers += $game_map.event_enemies
    
    # battler: sprite, event etc.
    # _battler : actor, enemy etc.
    for battler in battlers
      next if battler.nil?
      
      if battler.is_a?(Game_Player)
        _battler = $game_party.leader
      elsif battler.is_a?(Game_Follower)
        _battler = battler.actor
      elsif battler.is_a?(Game_Event)
        _battler = battler.enemy
      end
      
      if (_battler.death_state?)
        next
      elsif (_battler.death_state? && _battler.enemy?)
        next
      else
        if battler.at_xy_coord(x,y)
          return [_battler, battler]
        end
      end
    end
    
    for sprite in $battle_unit_sprites
      next if sprite.dead?
      battler = sprite.battler
      
      if battler.is_a?(Game_Player)
        _battler = $game_party.leader
      elsif battler.is_a?(Game_Follower)
        _battler = battler.actor
      elsif battler.is_a?(Game_Event)
        _battler = battler.enemy
      end
      
      return [_battler, battler] if sprite.adjacent?(sx - 16, sy - 32)
    end
    
    return nil # not occupied by anything
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_party_hud refresh
  def refresh
    refresh_party_hud
    scene = SceneManager.scene
    scene.refresh_party_hud if scene.is_a?(Scene_Map)
  end
  #--------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  A character class with mainly movement route and other such processing
# added. It is used as a super class of Game_Player, Game_Follower,
# GameVehicle, and Game_Event.
#==============================================================================
class Game_Character < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * At XY (used for large units especially)
  #-------------------------------------------------------------------------- 
  def at_xy_coord(x,y)
    size = 0.3
    return( x.between?(@x, @x + size) and y.between?(@y, @y + size))
  end
  #---------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. It includes event starting determinants and
# map scrolling functions. The instance of this class is referenced by
# $game_player.
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Scroll Processing
  #--------------------------------------------------------------------------
  alias update_scroll_dnd update_scroll
  def update_scroll(last_real_x, last_real_y)
    update_scroll_dnd(last_real_x, last_real_y) unless $tactic_enabled
  end
  #--------------------------------------------------------------------------
  # * Player Transfer Reservation
  #     d:  Post move direction (2,4,6,8)
  #--------------------------------------------------------------------------
  alias reserve_transfer_dnd reserve_transfer
  def reserve_transfer(map_id, x, y, d = 2)
    reserve_transfer_dnd(map_id, x, y, d = 2) unless $game_party.leader.state?(2)
  end
  #-------------------------------------------------------------------------
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Scroll Down
  #--------------------------------------------------------------------------
  alias scroll_down_dnd scroll_down
  def scroll_down(distance)
    scroll_down_dnd(distance) unless $tactic_enabled
  end
  #--------------------------------------------------------------------------
  # * Scroll Left
  #--------------------------------------------------------------------------
  alias scroll_left_dnd scroll_left
  def scroll_left(distance)
    scroll_left_dnd(distance) unless $tactic_enabled
  end
  #--------------------------------------------------------------------------
  # * Scroll Right
  #--------------------------------------------------------------------------
  alias scroll_right_dnd scroll_right
  def scroll_right(distance)
    scroll_right(distance) unless $tactic_enabled
  end
  #--------------------------------------------------------------------------
  # * Scroll Up
  #--------------------------------------------------------------------------
  alias scroll_up_dnd scroll_up
  def scroll_up(distance)
    scroll_up_dnd(distance) unless $tactic_enabled
  end
end
#===============================================================================
#
# ▼ End of File
#
#===============================================================================
