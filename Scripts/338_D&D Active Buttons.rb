#==============================================================================
# ■ Scene_Map
#==============================================================================
# tag: hotkey
# tag: button
# tag: tactic (inputs)
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  alias update_scmap_inputs update
  def update
    update_input_buttons unless $game_system.story_mode?
    update_scmap_inputs
  end
  #--------------------------------------------------------------------------
  # * Button utility process
  #--------------------------------------------------------------------------
  def update_input_buttons
    return unless button_cooled?
    return heatup_button if Input.press?(:kTAB)  && process_switch_button
    return heatup_button if Input.press?(:kCTRL) && process_control_button
    return heatup_button if process_normal_button
  end
  #--------------------------------------------------------------------------
  #  *) Actions when tab key is pressed
  #--------------------------------------------------------------------------
  def process_switch_button
    return if SceneManager.time_stopped?
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
  #  *) Actions when Ctrl key is pressed
  #--------------------------------------------------------------------------
  def process_control_button
    return unless button_cooled?
    #--------------------------------------------------------------------------
    # > Follower follow command
    #--------------------------------------------------------------------------
    if Input.press?(:kF)
      $game_player.followers.each do |follower|
        follower.command_follow
      end
      $game_player.followers.movement_command = 1
      $game_map.interpreter.gab("Follow up!",0,0)
      return true
    #--------------------------------------------------------------------------
    # > Follower gather command
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:kG)
      $game_player.followers.each do |follower|
        follower.set_target(nil)
        follower.move_to_position($game_player.x, $game_player.y, tool_range: 0)
      end
      $game_map.interpreter.gab("Gather around!",0,0)
      return true
    #--------------------------------------------------------------------------
    # > Follower hold command
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:kH)
      $game_player.followers.each do |follower|
        follower.command_hold
      end
      $game_player.followers.movement_command = 3
      $game_map.interpreter.gab("Hold in position!",0,0)
      return true
    #--------------------------------------------------------------------------
    # > Party concentrate fire on player's target
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:kV)
      $game_player.followers.each do |follower|
        follower.set_target($game_player.last_hit_target)
      end
      $game_map.interpreter.gab("Concentrate fire!",0,0)
      return true
    #--------------------------------------------------------------------------
    # > Ranged tool free-fire mode
    #--------------------------------------------------------------------------
    elsif Input.trigger?(:kR)
    #-----------------------------------------------------
    end
    return false
  end
  #--------------------------------------------------------------------------
  #  *) Actions when single key triggered
  #--------------------------------------------------------------------------
  def process_normal_button
  	#--------------------------------------------------------------------------
    # > Tactic Mode
    # tag: tactic (trigger button)
    #--------------------------------------------------------------------------
    if Input.trigger?(:kSPACE) && !Input.press?(:kALT) && !Input.press?(:kCTRL)
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
