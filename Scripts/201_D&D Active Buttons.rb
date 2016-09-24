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
    @button_cooldown -= 1 if @button_cooldown > 0
    
    return if @button_cooldown > 0
    #--------------------------------------------------------------------------
    # Console
    #--------------------------------------------------------------------------
    if    Input.press?(:kCTRL) && Input.press?(:kSPACE)
      $game_temp.reserve_common_event(23)
      @button_cooldown = 10
    #--------------------------------------------------------------------------
    # Dubug: show player coordinate
    #--------------------------------------------------------------------------
    elsif Input.press?(:kCTRL) && Input.press?(:kP)
      puts "(#{$game_player.x},#{$game_player.y})"
      @button_cooldown = 10
    #--------------------------------------------------------------------------
    #   Tactic Mode
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:kSPACE)
      @tactic_enabled ? end_tactic : start_tactic
      @button_cooldown = 10
    #--------------------------------------------------------------------------
    #  Chnage AI
    #--------------------------------------------------------------------------
    elsif Input.press?(:kCTRL) && Input.press?(:kA)
      if $game_party.leader.state?(2)
        $game_party.leader.remove_state(2)
        $game_player.pop_damage('Disable AI')
      else
        $game_party.leader.add_state(2)
        $game_player.make_battle_followers
        $game_player.pop_damage('Enable AI')
      end
      @button_cooldown = 10
    #--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kTAB) && Input.press?(:kF3)
      return if $game_party.members[1].nil?
      return if $game_party.members[1].dead?
      $game_party.swap_order(0,1)
      @button_cooldown = 10
    #--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kTAB) && Input.press?(:kF4)
      return if $game_party.members[2].nil?
      return if $game_party.members[2].dead?
      $game_party.swap_order(0,2)
      @button_cooldown = 10
    #--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kTAB) && Input.press?(:kF5)
      return if $game_party.members[3].nil?
      return if $game_party.members[3].dead?
      $game_party.swap_order(0,3)
      @button_cooldown = 10
    #--------------------------------------------------------------------------
    #  Goto/leave logs
    #--------------------------------------------------------------------------
    elsif Input.press?(:kCTRL) && Input.press?(:kL) && @tactic_enabled
      if @window_info.active
        deactivate_window_info
      else
        @window_info.show
      end
      @button_cooldown = 15
    #--------------------------------------------------------------------------
    #  Process command
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:C) && !@selected.nil? && !@windows[Menu_Actor].active
      set_active_battler(@selected)
      @button_cooldown = 10
    end
    
  end
  
  #--------------------------------------------------------------------------
  #  Deactivate window info
  #--------------------------------------------------------------------------
  def deactivate_window_info
    return unless @window_info.active
    @window_info.deactivate
    @window_info.unselect
  end
  
  
end # Scene_Map
#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
