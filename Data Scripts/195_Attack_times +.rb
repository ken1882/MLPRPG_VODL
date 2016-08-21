
#===============================================================================
# Theolized SBS - Atk Times+ Bugfix
# > Created at : 2015.12.20
#-------------------------------------------------------------------------------
# Put this script below implementation
#===============================================================================

class Game_Battler
  def setup_check_collapse
    (target_array + [target]).compact.each do |tar|
      tar.target = self
      get_scene.check_collapse(tar)
    end
  end
end

class Scene_Battle
  def tsbs_action_main(targets, item, subj)
    # Determine if item is not AoE ~
    if !item.area?
      subj.area_flag = false
      # Repeat item sequence for target number times
      targets.each do |target|
        # Change target if the target is currently dead
        if target.dead? && !item.for_dead_friend? 
          target = subj.opponents_unit.random_target
          if target.nil?
            # Break if there is no target avalaible or force break action
            break
          else
            $game_temp.battler_targets << target
          end
        end
        target = @cover_battlers[target] if @cover_battlers[target]
        # Do sequence
        subj.target = target
        subj.battle_phase = :skill
        wait_for_skill_sequence
        break if [:forced, :idle].include?(subj.battle_phase) || 
          subj.break_action
      end
    # If item is area of effect damage. Do sequence skill only once
    else
      subj.area_flag = true
      subj.battle_phase = :skill
      wait_for_skill_sequence
      subj.area_flag = false
    end
  end
end
