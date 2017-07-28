#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================
# tag: battler
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Regenerate HP
  #--------------------------------------------------------------------------
  def regenerate_hp
    damage = -(100 * hrg).to_i
    damage *= 10 if !$game_party.in_combat?
    perform_map_damage_effect if $game_party.in_battle && damage > 0
    @result.hp_damage = [damage, max_slip_damage].min
    self.hp -= @result.hp_damage
  end
  #--------------------------------------------------------------------------
  # * Regenerate MP
  #--------------------------------------------------------------------------
  def regenerate_mp
    @result.mp_damage = -(100 * mrg).to_i
    @result.mp_damage *= 10 if !$game_party.in_combat?
    self.mp -= @result.mp_damage
  end
  #-----------------
end
