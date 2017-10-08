#==============================================================================
# ** PONY::Rescue
#------------------------------------------------------------------------------
#  Thou shall not die!
#==============================================================================
module PONY::Rescue
  module_function
  
  def CallPrincessLuna
    return if $LunaCalled
    $LunaCalled = true
    $game_player.start_animation(159)
    info = "\\af[9]\\n<Luna>Thou shall glad I followed you.."
    $game_message.add(info)
    ex, ey = $game_player.x, $game_player.y
    rpeve = RPG::Event.new(ex,ey)
    rpeve.name = "Princess Luna"
    rpeve.id = 2000
    eve = Game_Event.new($game_map.map_id, rpeve)
    eve.move_speed = 5
    eve.set_graphic("Princess_Luna%(6)", 0)
    eve.spawn_npc_battler(9)
    $game_map.register_event(eve)
  end
  
end
