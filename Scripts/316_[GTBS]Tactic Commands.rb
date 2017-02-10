#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #----------------------------------------------------------------------------
  # Create command window
  #----------------------------------------------------------------------------
  # This window will cover all move and battle options, and disable items 
  # accordingly.
  #----------------------------------------------------------------------------
  def create_command_window
    @windows[Menu_Actor] = Commands_All.new 
    @windows[Menu_Actor].set_handler(:move, method(:actor_menu_move))
    @windows[Menu_Actor].set_handler(:hold, method(:actor_menu_hold))
    #@windows[Menu_Actor].set_handler(:attack, method(:actor_menu_attack))
    #@windows[Menu_Actor].set_handler(:status, method(:actor_menu_status))
    #@windows[Menu_Actor].set_handler(:wait, method(:actor_menu_wait))
    #@windows[Menu_Actor].set_handler(:defend, method(:actor_menu_wait))
    #@windows[Menu_Actor].set_handler(:skill, method(:actor_menu_skill))
    #@windows[Menu_Actor].set_handler(:item, method(:actor_menu_item))
    #@windows[Menu_Actor].set_handler(:escape, method(:actor_menu_escape))
    @windows[Menu_Actor].set_handler(:cancel, method(:actor_menu_cancel))
    #@windows[Menu_Actor].set_handler(:equip, method(:actor_menu_equip))
  end
  #-------------------------------------------------------------------------
  # *) Plays Audio "SelectActive" when the actor has been selected.
  #-------------------------------------------------------------------------
  def play_select_active_sound
    if FileTest.exist?('Audio/SE/SelectActive.mp3') or 
      FileTest.exist?('Audio/SE/SelectActive.wav') or FileTest.exist?('Audio/SE/SelectActive.ogg')
      Audio.se_play('Audio/SE/SelectActive', 100, 100)
    end
  end
  
  #-------------------------------------------------------------------------
  # Set_Active_Battler - Sets the battler, as active and initiates battler phase
  #-------------------------------------------------------------------------
  def set_active_battler(battler, forcing = false)
    return if battler.nil?
    @original_battler = battler[1]
    
    @active_battler = battler[0]
    play_select_active_sound
    
    if @active_battler.death_state?
      @active_battler = nil;
      return;
    end
    
    @windows[Menu_Actor].setup(@active_battler, @original_battler)
  end
  #--------------------------------------------------------
  # draw ranges and active move cursor
  #------------------------------------------------------
  def active_cursor_move
    @windows[Menu_Actor].deactivate
    @windows[Menu_Actor].hide
    @drawn = false
    $tbs_cursor.mode = TBS_Cursor::Move
    @windows[Win_Help].visible = true
    text = "Select a destination, or choose an enemy to aim it."
    @windows[Win_Help].set_text(text)
  end
  #----------------------------------------------------------------------------
  def actor_menu_move
    active_cursor_move
  end
  #----------------------------------------------------------------------------
  # *) actor hold in position
  #----------------------------------------------------------------------------
  def actor_menu_hold
    if @original_battler.command_holding?
      @original_battler.command_follow
    else
      @original_battler.command_hold
    end
    
    Sound.play_ok
    @windows[Win_Help].visible = false
    $tbs_cursor.moveto(@original_battler.x, @original_battler.y)
    actor_menu_cancel(false)
    
  end
  #----------------------------------------------------------------------------
  # Disable Actor Menu
  #----------------------------------------------------------------------------
  def actor_menu_cancel(play_se = true)
    Sound.play_cancel if play_se
    @windows[Menu_Actor].deactivate
    @windows[Menu_Actor].hide
    @windows[Menu_Actor].close
    #@windows[Win_Help].hide
    disable_cursor(true)
  end
  #----------------------------------------------------------------------------
  # Actor Menu Open
  #----------------------------------------------------------------------------
  def actor_menu_open
    @windows[Menu_Actor].activate
    @windows[Menu_Actor].clear_help
    @windows[Menu_Actor].call_update_help
  end
  #----------------------------------------------------------------------------
  # Disable Cursor
  #----------------------------------------------------------------------------
  def disable_cursor(remain_active = false)
    $tbs_cursor.active = remain_active
    $tbs_cursor.mode   = nil
  end
  #----------------------------------------------------------------------------
  # Actor Move
  #----------------------------------------------------------------------------
  def cursor_use_move
    if Input.trigger?(Input::B)
      Sound.play_cancel
      actor_menu_open
      disable_cursor
      @windows[Win_Help].visible = false
      $tbs_cursor.moveto(@original_battler.x, @original_battler.y)
    elsif Input.trigger?(Input::C)
      
      movable = process_tactic_move($tbs_cursor.x, $tbs_cursor.y)
      if movable
        actor_menu_cancel(false)
        Sound.play_ok
        @windows[Win_Help].visible = false
        $tbs_cursor.moveto(@original_battler.x, @original_battler.y)
      else
        Sound.play_buzzer
        @button_cooldown = Button_CoolDown
      end
      
    end
  end
  #----------------------------------------------------------------------------
  # *) Process tactic move
  #----------------------------------------------------------------------------
  def process_tactic_move(x, y)
    result = false
    result |= $game_player.pixel_passable?(x, y, 2)
    result |= $game_player.pixel_passable?(x, y, 4)
    result |= $game_player.pixel_passable?(x, y, 6)
    result |= $game_player.pixel_passable?(x, y, 8)
    return false if result == false
    
    target = @selected
    target = target.nil? ? nil : target.at(1)
    
    if target.nil? || (target.is_a?(Game_Follower) || target.is_a?(Game_Player))
      @original_battler.pop_damage("Move to position")
      @original_battler.move_to_position(x, y)
    else
      @original_battler.targeted_character = target
      @original_battler.pop_damage("Attack target")
      $game_player.make_battle_follower(@original_battler, false)
    end
    
    return true
  end
  
  #---------------------------------------------------------------------------
end
#===============================================================================
#
# ▼ End of File
#
#===============================================================================