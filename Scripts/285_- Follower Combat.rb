#===============================================================================
# * Falcao Pearl ABS script shelf # 1
#
# This script is the Heart of Pearl ABS Liquid, it handles all the character
# management, the tools variables and the input module, enemy registration etc.
#===============================================================================
#===============================================================================
# Game character
#===============================================================================
class Game_CharacterBase
  #========================================================================
  #     * followers attacks engine #tag: follower
  #===============================================================================
  def fo_tool
    return actor.equips[0]       if actor.primary_use == 1
    return actor.equips[1]       if actor.primary_use == 2
    return actor.assigned_item   if actor.primary_use == 3
    return actor.assigned_item2  if actor.primary_use == 4
    return actor.assigned_skill  if actor.primary_use == 5
    return actor.assigned_skill2 if actor.primary_use == 6
    return actor.assigned_skill3 if actor.primary_use == 7
    return actor.assigned_skill4 if actor.primary_use == 8
  end
  
  # followers attack engine
  def update_followers_attack
    if self.is_a?(Game_Follower)
      if @pathfinding_moves.size > 0 && @force_pathfinding
        process_pathfinding_movement
        return
      end
    end
    
    if fo_tool.nil? || battler.dead?
      @targeted_character = nil if @targeted_character != nil
      return
    end
    return if @stopped_movement > 0
    
    if @follower_attacktimer > 0
      @follower_attacktimer -= 1
      if @follower_attacktimer == 40 && !moving? && !command_holding?
        r = rand(3)
        move_random if r == 0 || r == 1
        move_away_from_character(@targeted_character) if 
        !@targeted_character.nil? and r == 2
      end
    end
    
     # if the skill is for the player
    if @targeted_character != nil and @targeted_character.is_a?(Game_Player)
      if all_enemies_dead?
        delete_targetf
        return
      end
      use_predefined_tool
      return
    end
    
    # if the skill is for an enemy to continue
    if @targeted_character != nil
      use_predefined_tool
      return if @targeted_character.nil?
      # reset if the target is dead
      if @targeted_character.collapsing?
        force_cancel_actions
        delete_targetf
      end
    else
      # select a follower slected target
      $game_player.followers.each do |follower|
        if !follower.targeted_character.nil?
          next if follower.targeted_character.is_a?(Game_Player)
          if follower.stuck_timer >= 10
            follower.targeted_character = nil
            return
          end
          @targeted_character = follower.targeted_character
          break
        end
      end
    end
  end
  
  # prepare the tool usage
  def setup_followertool_usage
    
    @range_view = [2, fo_tool.tool_distance].max
    @range_view = [6, @range_view].max if fo_tool.tool_data("Tool Target = ", false) == "true" ||
    fo_tool.tool_data("Tool Special = ", false) == "autotarget"
    
    if fo_tool.is_a?(RPG::Skill) || fo_tool.is_a?(RPG::Item)
      if fo_tool.scope.between?(1, 6)
        setup_target 
      else ; @targeted_character = $game_player
        @range_view = 6
      end
      # prepare tool for invoke follower
    elsif fo_tool.is_a?(RPG::Weapon) || fo_tool.is_a?(RPG::Armor)
      invoke = fo_tool.tool_data("Tool Invoke Skill = ")
      if invoke > 0
        if $data_skills[invoke].scope.between?(1, 6)
          setup_target
        else ; @targeted_character = $game_player
          @range_view = 6
        end
      else
        # no invoke skill just set up an enemy target
        setup_target if @targeted_character.nil?
      end
    end
  end
  
  # use the predifined tool
  # tag: attack
  def use_predefined_tool
    update_follower_movement
    return if @targeted_character.nil?
    if obj_size?(@targeted_character, @range_view) && @follower_attacktimer == 0
      turn_toward_character(@targeted_character)
      use_weapon(fo_tool.id) if actor.primary_use == 1 
      use_armor(fo_tool.id)  if actor.primary_use == 2
      use_item(fo_tool.id)   if actor.primary_use == 3 || actor.primary_use == 4
      use_skill(fo_tool.id)  if actor.primary_use==5 || actor.primary_use==6 ||
      actor.primary_use == 7 || actor.primary_use == 8
      if fo_tool.tool_data("User Graphic = ", false).nil?
        @targeted_character = nil
        turn_toward_player
      end
      @follower_attacktimer = 60
    end
    delete_targetf if self.actor.dead?
  end
  
  def all_enemies_dead?
    for event in $game_map.event_enemies
      if event.on_battle_screen? && event.enemy_ready?
        return false if $game_player.obj_size?(event,PearlKernel::PlayerRange+1)
      end
    end
    return true
  end
  
  def delete_targetf
    @targeted_character = nil
    $game_player.make_battle_followers
  end
  
  #------------------------
  # follower movement attack
  def reset_targeting_settings(target)
    target.being_targeted = false if target.is_a?(Game_Event)
    delete_targetf
    turn_toward_player
    @stuck_timer = 0
  end
  #---------------------------------------------------------------------
  # *) update follower movement
  #---------------------------------------------------------------------
  def update_follower_movement
    target = @targeted_character
    if @stuck_timer >= 30
      reset_targeting_settings(target)
      return
    end
    
    # if the follower is unabble to use the tool
    unless usable_test_passed?(fo_tool)
      if SceneManager.scene_is?(Scene_Map)
        reset_targeting_settings(target)
        @balloon_id = PearlKernel::FailBalloon
        return
      end
    end
    
    return if target.nil?
    @stuck_timer += 1 if !in_sight?(target, @range_view) && !moving?
    if moving? || @anime_speed > 0 || @making_spiral || @hookshoting[0] ||
      @knockdown_data[0] > 0
      @stuck_timer = 0
    end
    return if moving? || @pathfinding_moves.size > 0
    
    if fo_tool.tool_data("Tool Target = ", false) == "true" || 
      fo_tool.tool_data("Tool Special = ", false) == "autotarget" ||
      target.is_a?(Game_Player)
      # using skill con target true magical
      cpu_reactiontype(1, target)
      return 
      # target not exist
    else
    
      if fo_tool.is_a?(RPG::Skill) || fo_tool.is_a?(RPG::Item)
        fo_tool.scope.between?(1, 6) ? cpu_reactiontype(2, target) : # to enemy
        cpu_reactiontype(1, target) # benefical
      else
        # for weapon armor without target
        cpu_reactiontype(2, target)
      end
    end
    return if !obj_size?(target, @range_view)
    return if target.is_a?(Game_Player)
    case rand(40)
    when 4  then move_backward
    when 10 then move_random
    end
  end
  #---------------------------------------------------------------------
  # cpu reaction
  # tag: target
  # tag: follower
  #---------------------------------------------------------------------
  def cpu_reactiontype(type, target)
    return if !@pathfinding_moves.empty? && !@force_pathfinding
    
    unless on_battle_screen?
      3.times.each {|i|  move_toward_player}
      return
    end
    
    if !obj_size?(target, @range_view) && type == 1
      move_toward_character(target, true)
    end
    
    if (@follower_attacktimer == 0 || !obj_size?(target, @range_view))
      if type == 2
        if fo_tool.tool_distance > 3 && Math.hypot(@x - target.x, @y - target.y) < 5 && !self.is_a?(Game_Player)
          @pathfinding_moves.clear if @pathfinding_moves.size > 10
          move_away_from_character(target)
        else
          move_toward_character(target, true, @range_view)
        end
      end # if type == 2
    end # if @follower_attacktimer == 0 || !obj_size?(target, @range_view) a
  end # def
  #---------------------------
end # class Game_CharacterBase
