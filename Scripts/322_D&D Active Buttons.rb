module DND
  module BUTTON_EVENT
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Button Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This sets the common events that are to run when the particular button
    # is pressed. The following chart shows the respective keyboard buttons.
    # 
    #   :Button    Default Keyboard Button
    #      :L        Q
    #      :R        W
    #      :X        A
    #      :Y        S
    #      :Z        D
    # 
    # If you do not wish to associate a button with a common event, set the
    # common event for that button to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMON_EVENT ={
    # :Button => Common Event,
           :L =>   0,    # Quest
           :R =>   0,    # Does not run a common event.
           :Y => 0,
           :X => 0,
           :Z => 0,
    } # Do not remove this.
    
    HOT_KEY ={
      :kI => "SceneManager.call(Scene_Item)",
      :kO => "SceneManager.call(Scene_System)",
      :kJ => "$game_temp.reserve_common_event(18)",
      
    }
    
  end # BUTTON_EVENT
end # DND
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================
#==============================================================================
# ■ Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # new method: update_button_common_events
  #--------------------------------------------------------------------------
  def update_tactic_buttons
    update_menu_buttons if @tactic_enabled
    start_tactic        if @tactic_enabled ^ $tactic_enabled
    
    deactivate_window_info                if !@tactic_enabled || Input.press?(:kALT)
    $game_player.update_followers_trigger if @tactic_enabled
    
    return unless button_cooled?
    if Input.press?(:kCTRL); actioned = process_control_button;
    elsif Input.press?(:kTAB); actioned = process_switch_button;
    else; actioned = process_normal_button;
    end
    heatup_button if actioned
  end
  
  
  #--------------------------------------------------------------------------
  #  Process control button
  #--------------------------------------------------------------------------
  def process_control_button
  	#--------------------------------------------------------------------------
    # Console Debug
    #--------------------------------------------------------------------------
    if Input.press?(:kSPACE)
      $game_temp.reserve_common_event(23)
      return true
    #--------------------------------------------------------------------------
    #  Chnage AI
    #--------------------------------------------------------------------------
    elsif Input.press?(:kA)
      # move this to (perhaps battle manager) class
      if $game_party.leader.state?(2)
        $game_party.leader.remove_state(2)
        $game_player.pop_damage('Disable AI')
      else
        $game_party.leader.add_state(2)
        $game_player.make_battle_followers
        $game_player.pop_damage('Enable AI')
      end
      return true
    #--------------------------------------------------------------------------
    #  Quick Save
    #--------------------------------------------------------------------------
    elsif Input.press?(:kS)
      SceneManager.call_quicksave
      return true
    end
    #--------------------------------------------------------------------------
  end
  
  #--------------------------------------------------------------------------
  #  Process normal button event
  #--------------------------------------------------------------------------
  def process_normal_button
  	#--------------------------------------------------------------------------
    #   Tactic Mode
    #--------------------------------------------------------------------------
    if Input.trigger?(:kSPACE)
      @tactic_enabled ? end_tactic : start_tactic
      return true
    #--------------------------------------------------------------------------
    #  Process command
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:C) && !@selected.nil? && !@windows[Menu_Actor].active && $tactic_enabled
      return if @selected[0].is_a?(Game_Enemy) || @selected[0].is_a?(Game_Event) 
      set_active_battler(@selected)
      return true
    #--------------------------------------------------------------------------
    #  Goto/leave logs
    #--------------------------------------------------------------------------
    elsif @tactic_enabled
      if @window_info.active && (Input.press?(:kL) || Input.press?(:B))
        deactivate_window_info
        return true
      elsif Input.press?(:kL)
        activate_window_info
        return true
      end
    #--------------------------------------------------------------------------
    # Dubug: show player coordinate
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:kP)
      SceneManager.display_info "Player address: (#{$game_player.x},#{$game_player.y})"
      SceneManager.display_info "Mouse  address: (#{Mouse.map_grid[0]},#{Mouse.map_grid[1]})"
      return true
    end
    #-----------------------------------------------------------------------
  end
  
  #--------------------------------------------------------------------------
  #  Process switch button
  #--------------------------------------------------------------------------
  def process_switch_button
  	#--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    if Input.press?(:kF3)
      return if $game_party.members[1].nil?
      return if $game_party.members[1].dead?
      $game_party.swap_order(0,1)
      return true
    #--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kF4)
      return if $game_party.members[2].nil?
      return if $game_party.members[2].dead?
      $game_party.swap_order(0,2)
      return true
    #--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kF5)
      return if $game_party.members[3].nil?
      return if $game_party.members[3].dead?
      $game_party.swap_order(0,3)
      return true
    end
    #--------------------------------------------------------------------------
  end
  
  #--------------------------------------------------------------------------
  #  Activate/Deactivate window info
  #--------------------------------------------------------------------------
  def activate_window_info
    return if @window_info.active?
    @window_info.show
  end
  
  def deactivate_window_info
    return unless @window_info.active?
    @window_info.deactivate
    @window_info.unselect
  end
  #--------------------------------------------------------------------------
end # Scene_Map
