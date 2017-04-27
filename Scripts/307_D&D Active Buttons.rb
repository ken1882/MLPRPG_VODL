#==============================================================================
# ■ Scene_Map
# tag: hotkey
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  alias update_scmap_inputs update
  def update
    update_scmap_inputs
    update_input_buttons
  end
  #--------------------------------------------------------------------------
  # * Button utility process
  #--------------------------------------------------------------------------
  def update_input_buttons
    
    #tag: unfinished
    #deactivate_window_info                if !@tactic_enabled || Input.press?(:kALT)
    #$game_player.update_followers_trigger if @tactic_enabled
    return unless button_cooled?
    return heatup_button if Input.press?(:kCTRL) && process_control_button
    return heatup_button if Input.press?(:kTAB)  && process_switch_button
    return heatup_button if process_normal_button
  end
  #--------------------------------------------------------------------------
  #  *) Actions when ctrl key is pressed
  #--------------------------------------------------------------------------
  def process_control_button
  	#--------------------------------------------------------------------------
    # > Console Debug
    #--------------------------------------------------------------------------
    if Input.press?(:kSPACE)
      $game_temp.reserve_common_event(23)
      return true
    #--------------------------------------------------------------------------
    end
  end
  #--------------------------------------------------------------------------
  #  *) Actions when tab key is pressed
  #--------------------------------------------------------------------------
  def process_switch_button
  	#--------------------------------------------------------------------------
    # > Swap current control actor
    #--------------------------------------------------------------------------
    if Input.press?(:kF3)
      return if $game_party.members[1].nil?
      return if $game_party.members[1].dead?
      $game_party.swap_order(0,1)
      return true
    #--------------------------------------------------------------------------
    # > Swap current control actor
    #--------------------------------------------------------------------------
    elsif Input.press?(:kF4)
      return if $game_party.members[2].nil?
      return if $game_party.members[2].dead?
      $game_party.swap_order(0,2)
      return true
    #--------------------------------------------------------------------------
    # > Swap current control actor
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
  #  *) Actions when single key triggered
  #--------------------------------------------------------------------------
  def process_normal_button
  	#--------------------------------------------------------------------------
    # > Tactic Mode
    #--------------------------------------------------------------------------
    if Input.trigger?(:kSPACE) 
      #$game_map.events[38].use_tool($data_skills[9], $game_player)
      SceneManager.process_tactic
      return true
    #--------------------------------------------------------------------------
    # > Dubug: show player coordinate
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:kP)
      SceneManager.display_info "Player address: (#{$game_player.x},#{$game_player.y})"
      SceneManager.display_info "Mouse  address: (#{Mouse.true_grid[0]},#{Mouse.true_grid[1]})"
      SceneManager.display_info "Mouse pixel address: #{Mouse.pos}"
      return true
    end
    #-----------------------------------------------------------------------
  end
  #--------------------------------------------------------------------------
end # Scene_Map
