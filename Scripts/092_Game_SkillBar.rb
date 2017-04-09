module PONY::SkillBar
  
  # Skillbar X position in tiles
  Tile_X = 2
  
  # Skillbar Y position in tiles
  Tile_Y = 14
  
  # Layout graphic
  LayOutImage = "Skillbar"
  
  # Follower attack command icon index
  ToggleIcon = 116
  
  AllSkillIcon = 143
  VancianIcon  = 141
  AllItemIcon  = 1528
  
  HotKeySelection = 1
  AllSelection    = 2
  CastSelection   = 3
 
  def self.hide
    $game_system.skillbar_enable = true
  end
  
  def self.show
    $game_system.skillbar_enable = nil
  end
  
  def self.hidden?
    !$game_system.skillbar_enable.nil?
  end
end
class Game_System
  attr_accessor :skillbar_enable, :enemy_lifeobject
  alias init_skillbar initialize
  def initialize
    
    init_skillbar
  end
end
class Game_SkillBar
  include PONY::SkillBar
  #--------------------------------------------------------------------------
  # *) Instance Vars
  #--------------------------------------------------------------------------
  attr_accessor :actor 
  attr_accessor :stack
  attr_accessor :indexhash
  attr_accessor :sprite
  attr_accessor :need_update
  #--------------------------------------------------------------------------
  # *) Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @actor = nil
    @stack = []
    @index = HotKeys::SkillBar
    @indexhash = 0
    @need_update = false
    @usability = Array.new(HotKeys::SkillBarSize) { |i| i = nil }
  end
  
  def update
    @actor    = $game_player.actor
    @stack[0] = @actor
  end
  
  def apply_usability
    return if @actor.nil?
    @actor.apply_usability
  end
  
  def need_update?
    return @need_update
  end
  
end
