#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================
module SceneManager
  
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #----------------------------------------------------------------------------
  #Window names: should be replaced by Integer for CPU efficiency  
    Win_Help = :help#'help'
    Menu_Actor = :actor #'actor'
    Win_Confirm = :confirm#'confirm'
    Win_Status, Win_Detail = :status, :detail#'status', 'detail'
    Win_Item, Win_Skill, Win_Revive = :item, :skill, :revive#'item', 'skill', 'revive'
    Win_Option, Win_Config, Win_Color = :option, :config, :color#'option', 'config', 'color'
    Win_LevelUp = :earned#'earned'
    Act_List = :act_list#'Act List'
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
    @buttron_cooldown = 0
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
    $scene_switched = false
  end
  #--------------------------------------------------------------------------
  # * End Tactic
  #--------------------------------------------------------------------------
  def end_tactic
    @tactic_enabled = false
    $tactic_enabled = false
    $tbs_cursor.active = false
    update_win_visible
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_tactic_buttons
    $tbs_cursor.update
    @spriteset.update
    $game_map.update(true) if $game_map.need_refresh
    update_win_visible     if @tactic_enabled
    
    return if @tactic_enabled && !Input.press?(:kALT)
    $game_map.update(true)
    $game_player.update
    $game_timer.update
    update_scene        if scene_change_ok?
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
    #@windows[Win_Help] = TBS_Window_Help.new
    #@windows[Win_Help].move_to(2)
    
    #Create Command Window
    #create_command_window
    
    #Create Status Windows - Both Full and Mini
    create_status_windows
    
    ##make all items partially transparent
    for type, window in @windows
      window.back_opacity = GTBS::CONTROL_OPACITY
      window.visible = false
      window.active = false
    end
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
    @selected = $game_map.occupied_by?($tbs_cursor.x, $tbs_cursor.y)
  end
  #----------------------------------------------------------------------------
  # Update Window Visible
  #----------------------------------------------------------------------------
  def update_win_visible
    update_selected
    @windows[Win_Status].update(@selected)
    @windows[Win_Status].visible = @tactic_enabled && @selected
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
  #-----------------------------------------------------------------------------
  # *) Create tactic sprites
  #-----------------------------------------------------------------------------
  def create_tactic_sprites
    create_cursor
  end
  #-----------------------------------------------------------------------------
  def create_cursor
    @cursor = Battle_Cursor.new(@viewport1)
    @cursor.visible = true
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
  def occupied_by?(x, y)
    return nil if !SceneManager.scene_is?(Scene_Map)
    battlers = [$game_player]
    $game_player.followers.each do |follower|
      next if follower.actor.nil?
      battlers.push(follower)
    end
    battlers += $game_map.event_enemies
    
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
          return _battler
        end
      end
    end
    return nil #not occupied?
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
#===============================================================================
# ▼ End of File Battle_Cursor
#===============================================================================
