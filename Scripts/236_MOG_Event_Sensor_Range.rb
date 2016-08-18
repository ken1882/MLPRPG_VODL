#==============================================================================
# +++ MOG - Event Sensor Range (v1.0) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Permite que o evento tenha dois comportamentos, de curta distância e de 
# longa distância.
#===============================================================================
# - Utilização
# Crie uma página com a condição de ativação Self Switch D, está página será 
# usada quando o player estiver perto do evento.
# Defina a area do sensor do evento colocando este nome no evento.
#
# <SensorX> 
#
# X = Area do Sensor
#
#===============================================================================
module MOG_EVENT_SENSOR
  #Definição da letra da Self Switch que ativará a página de curta distância.
  SENSOR_SELF_SWITCH = "D"
end

#===============================================================================
# ■ GAME EVENT
#===============================================================================
class Game_Event < Game_Character
  
  attr_reader   :sensor_range
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------            
  alias mog_event_sensor_initialize initialize
  def initialize(map_id, event)
      mog_event_sensor_initialize(map_id, event)
      setup_event_sensor
  end
  
  #--------------------------------------------------------------------------
  # ● Setup Event Sensor
  #--------------------------------------------------------------------------          
  def setup_event_sensor
      @sensor_range =  @event.name =~ /<Sensor(\d+)>/ ? $1.to_i : 0
  end  
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------            
  alias mog_event_sensor_update update 
  def update
      mog_event_sensor_update
      update_event_sensor 
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Sensor
  #--------------------------------------------------------------------------        
  def update_event_sensor 
      return if @sensor_range == 0
      distance = ($game_player.x - self.x).abs + ($game_player.y - self.y).abs
      enable   = (distance <= @sensor_range)
      key = [$game_map.map_id, self.id, MOG_EVENT_SENSOR::SENSOR_SELF_SWITCH]
      last_enable = $game_self_switches[key]
      execute_sensor_effect(enable,key) if enable != last_enable
    end

  #--------------------------------------------------------------------------
  # ● Execute_Sensor Effect
  #--------------------------------------------------------------------------            
  def execute_sensor_effect(enable,key)      
      @pattern = 0 ; @pattern_count = 0               
      $game_self_switches[key] = enable ;  self.refresh
  end
    
end

$mog_rgss3_event_sensor = true