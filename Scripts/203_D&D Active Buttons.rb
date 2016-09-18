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
    $game_player.update_followers_trigger if @tactic_enabled
    
    @buttron_cooldown -= 1
    return if @buttron_cooldown > 0
    #--------------------------------------------------------------------------
    # Console
    #--------------------------------------------------------------------------
    if    Input.press?(:kCTRL) && Input.press?(:kSPACE)
      $game_temp.reserve_common_event(23)
      @buttron_cooldown = 10
    #--------------------------------------------------------------------------
    # Dubug: show player coordinate
    #--------------------------------------------------------------------------
    elsif Input.press?(:kCTRL) && Input.press?(:kP)
      puts "(#{$game_player.x},#{$game_player.y})"
      @buttron_cooldown = 10
    #--------------------------------------------------------------------------
    #   Tactic Mode
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:kSPACE)
      @tactic_enabled ? end_tactic : start_tactic
      @buttron_cooldown = 10
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
      @buttron_cooldown = 10
    #--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kTAB) && Input.press?(:kF3)
      return if $game_party.members[1].nil?
      return if $game_party.members[1].dead?
      $game_party.swap_order(0,1)
      @buttron_cooldown = 10
    #--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kTAB) && Input.press?(:kF4)
      return if $game_party.members[2].nil?
      return if $game_party.members[2].dead?
      $game_party.swap_order(0,2)
      @buttron_cooldown = 10
    #--------------------------------------------------------------------------
    #  Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kTAB) && Input.press?(:kF5)
      return if $game_party.members[3].nil?
      return if $game_party.members[3].dead?
      $game_party.swap_order(0,3)
      @buttron_cooldown = 10
    end
    
  end
  
  
end # Scene_Map
#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
