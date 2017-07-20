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
  attr_accessor :enemy
  attr_reader   :event
  attr_reader   :terminated
  #--------------------------------------------------------------------------
  attr_accessor :default_weapon
  attr_accessor :last_target
  attr_accessor :cool_down
  attr_accessor :recover
  attr_accessor :target_switch
  attr_accessor :self_vars
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     event:  RPG::Event
  #--------------------------------------------------------------------------
  alias initialize_event_opt initialize
  def initialize(map_id, event)
    @self_vars       = Array.new(4){|i| i = 0}
    @terminated      = false
    initialize_event_opt(map_id, event)
  end
  #--------------------------------------------------------------------------
  # * overwrite method: setup_page_settings
  #--------------------------------------------------------------------------
  def setup_page_settings
    @tile_id          = @page.graphic.tile_id
    @character_name   = @page.graphic.character_name
    @character_index  = @page.graphic.character_index
    
    if @original_direction != @page.graphic.direction
      @direction          = @page.graphic.direction
      @original_direction = @direction
      @prelock_direction  = 0
    end
    
    if @original_pattern != @page.graphic.pattern
      @pattern            = @page.graphic.pattern
      @original_pattern   = @pattern
    end
    
    @move_type          = @page.move_type
    @move_speed         = @page.move_speed
    @move_frequency     = @page.move_frequency
    
    #tag: modified here
    if !@on_path_finding || @on_path_finding.nil?
      @move_route         = @page.move_route
      @move_route_index   = 0               
      @move_route_forcing = false           
    end
    
    @walk_anime         = @page.walk_anime
    @step_anime         = @page.step_anime
    @direction_fix      = @page.direction_fix
    @through            = @page.through
    @priority_type      = @page.priority_type
    @trigger            = @page.trigger
    @list               = @page.list
    @interpreter = @trigger == 4 ? Game_Interpreter.new : nil
  end
  #--------------------------------------------------------------------------
  # * Set Up Event Page Settings
  #--------------------------------------------------------------------------
  alias setup_page_config setup_page_settings
  def setup_page_settings
    setup_page_config
    setup_configs
  end
  #--------------------------------------------------------------------------
  # * Setup configs 
  # tag: event config
  #--------------------------------------------------------------------------
  def setup_configs
    comments = get_comments
    comments.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Event::Terminated
        terminate
      when DND::REGEX::Event::Frozen
        freeze
      end
    end
  end
  #----------------------------------------------------------------------------
  # * Get comments in event page
  #----------------------------------------------------------------------------
  def get_comments
    return unless @list
    comments = ""
    for command in @list
      next unless command.code == 108
      comments += command.parameters[0]
    end
    return comments
  end
  #--------------------------------------------------------
  # *) check if comment is in event page
  #--------------------------------------------------------
  def comment_include?(comment)
    return if comment.nil? || @list.nil?
    comment = comment.to_s
    for command in @list
      if command.code == 108
        return true if command.parameters[0].include?(comment)
      end # if command.code
    end # for command
    return false
  end # def comment
  #----------------------------------------------------------------------------
  # * Permanently delete the event
  #----------------------------------------------------------------------------
  def terminate
    @terminated = true
    $game_map.terminate_event(self)
  end
  #----------------------------------------------------------------------------
  # * Freeze event from update
  #----------------------------------------------------------------------------
  alias ruby_freeze freeze
  def freeze
    @frozen = true
  end
  #----------------------------------------------------------------------------
  def unfreeze
    @frozen = false
  end
  #----------------------------------------------------------------------------
  alias :ruby_frozen? :frozen?
  def frozen?
    @frozen
  end
  #----------------------------------------------------------------------------
  def team_id
    return @enemy.team_id if @enemy
    return 0
  end
  #---------------------------------------------------------------------------
  # * Method Missing
  # ----------------------------------------------------------------------   
  # DANGER ZONE: Redirect to Game_Enemy
  #---------------------------------------------------------------------------
  def method_missing(symbol, *args)
    super(symbol, *args) if @enemy.nil?
    @enemy.method(symbol).call(*args)
  end
  
end
