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
    
    @active_battler = battler
    play_select_active_sound
    
    if @active_battler.death_state?
      @active_battler = nil;
      return;
    end
    
    @windows[Menu_Actor].setup(@active_battler)
    @original_battler = $tbs_cursor.check_occupy.at(1)
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
      disable_cursor #* actor Menu active
      @windows[Win_Help].visible = false
      $tbs_cursor.moveto(@original_battler.x, @original_battler.y)
      return true
    elsif Input.trigger?(Input::C)
      Sound.play_ok
      @windows[Win_Help].visible = false
      $tbs_cursor.moveto(@original_battler.x, @original_battler.y)
      return false
    end
  end
  #---------------------------------------------------------------------------
end
#===============================================================================
#
# ▼ End of File
#
#===============================================================================
