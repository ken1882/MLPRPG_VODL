
class Game_Battler < Game_BattlerBase

  def refresh
    state_resist_set.each {|state_id| erase_state(state_id) }
    @hp = [[@hp, mhp].min, 0].max
    @mp = [[@mp, mmp].min, 0].max

    if @hp == 0
      if self.state?(89)
          remove_state(89)
          remove_state(death_state_id)
          @hp += mhp.to_i/5
          
          @dmg_popup = true 
          @popup_ary.push((["AutoRevive","AutoRevive"]))
          
          Audio.se_play("Audio/SE/Recovery", 100,100)
      else
          add_state(death_state_id)
      end
    end
      

  end
  
end
