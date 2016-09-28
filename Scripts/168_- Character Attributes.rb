
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class << self; alias load_database_char_attri load_database; end
  def self.load_database
    $dnd_info = []
    load_database_char_attri
    load_character_attributes
  end
  
  #--------------------------------------------------------------------------
  # new method: load_character_attributes
  #--------------------------------------------------------------------------
  def self.load_character_attributes
    group = [$data_enemies]
    group.each do |data|
      data.each {|obj| 
        next if obj.nil?
        obj.load_character_attributes
      }
    end
    
  end
  
end # DataManager
#==============================================================================
# ** RPG::Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop). 
#==============================================================================
class RPG::Enemy
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :default_weapon
  attr_accessor :recover
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def load_character_attributes
    
    @defalut_weapon = 1
    @recover      = 30
    
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when DND::REGEX::DEFAULT_WEAPON
        @default_weapon = $1.to_i
        puts "[Enemy Weapon]: #{self.name}'s default weapon: #{$data_weapons[@default_weapon].name}" if @default_weapon != 1
      when DND::REGEX::COOL_DOWN
        @recover = $1.to_i
      end
    } # self.note.split
    #---
  end
  #------------------------------------
end
#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :default_weapon
  attr_accessor :last_target
  attr_accessor :cool_down
  attr_accessor :recover
  attr_accessor :current_target
  attr_accessor :taget_switch
  #--------------------------------------------------------------------------
  # *) register enemy to event
  #--------------------------------------------------------------------------
  alias register_enemy_comp register_enemy
  def register_enemy(event)
    register_enemy_comp(event)
    return if @enemy.nil?
    subject = @enemy.enemy
    @default_weapon = subject.default_weapon
    @recover        = subject.recover
    @cool_down      = 0
    @taget_switch   = 0
    @current_target = nil
  end
  #--------------------------------------------------------------------------
  # *) Alias method: update_combat_action
  #--------------------------------------------------------------------------
  alias update_combat_action update
  def update
    update_combat_action
    return if @enemy.nil?
    return if @enemy.object == true
    
    update_cooldown
    determind_attack if @inrangeev
  end
  #----------------------------------------------------------------------------
  # *) update cooldown
  #----------------------------------------------------------------------------
  def update_cooldown
    @cool_down -= 1 if @cool_down > 0
    @taget_switch -= 1 if @taget_switch > 0
  end
  #----------------------------------------------------------------------------
  # enemy sensor
  # tag: sight
  #----------------------------------------------------------------------------
  def update_enemy_sensor
    return if @hookshoting[0]
    return if @epassive
    return if @enemy.nil?
    return if @enemy.object
    
    if @sensor != nil
      target = @agroto_f if !@agroto_f.nil?
      for battler in $game_player.followers
        next if battler.nil?
        next if battler.actor.nil?
        target = battler if in_sight?(battler, @sensor)
      end
    end
    
    move_toward_character(@current_target) if !@current_target.nil? && @move_type != 0
    track_down_traget(target)
  end
  #--------------------------------------------------------------------------
  # *) Track down target
  #--------------------------------------------------------------------------
  def track_down_traget(target)
    target = $game_player if target.nil?
    @last_target = Map_Address_Node.new(target.x, target.y)
    
    if in_sight?(target, @sensor)
      data = [$game_map.map_id, @id, PearlKernel::Enemy_Sensor]
      if @inrangeev.nil? and !$game_self_switches[[data[0], data[1], data[2]]]
        $game_self_switches[[data[0], data[1], data[2]]] = true
        @inrangeev = true
        setup_target(target)
      elsif @current_target.nil?
        $game_self_switches[[data[0], data[1], data[2]]] = false
      end
    elsif @inrangeev != nil
      data = [$game_map.map_id, @id, PearlKernel::Enemy_Sensor]
      if ($game_self_switches[[data[0], data[1], data[2]]] && !obj_size?(target, @sensor))
        $game_self_switches[[data[0], data[1], data[2]]] = false
        @inrangeev = nil
        @last_target = nil
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # *) Setup target
  #--------------------------------------------------------------------------
  def setup_target(target)
    return if @taget_switch > 0
    @current_target = target
    @target_switch = 300
  end
  #--------------------------------------------------------------------------
  # *) Determind if attack
  #--------------------------------------------------------------------------
  def determind_attack
    return if @cool_down > 0
    return if @default_weapon.nil?
    
    battlers = [$game_player]
    $game_player.followers.each do |follower|
      battlers.push(follower) if !follower.actor.nil?
    end
    
    for battler in battlers
      weapon = $data_weapons[@default_weapon]
      if obj_size?(battler, weapon.tool_distance)
        turn_toward_character(battler)
        use_weapon(@default_weapon)
        @cool_down = @recover
        setup_target(battler)
      end
    end
    
  end
  #------------------------
end
