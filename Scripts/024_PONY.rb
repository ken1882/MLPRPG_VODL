#==============================================================================
# ** PONY
#------------------------------------------------------------------------------
#  Pone Pone Pone~ Po-Po-Pony should poni pony
#==============================================================================
$imported = {} if $imported.nil?
Button_CoolDown = 10
SPLIT_LINE = "-----------------------------"
module PONY
  #----------------------------------
  TOTAL_BIT_VARIABLE_ID   = 31
  TOTAL_XP_VARIABLE_ID    = 32
  
  COMBAT_STOP_FLAG        = 98
  Enable_Loading          = true
  #----------------------------------
  ICON_ID = {
    :bit        => 558,
    :chromastal => 571,
  }
  #----------------------------------
  
  #-----------------------------------------------------------------------------
  # * Module functions
  #-----------------------------------------------------------------------------
  module_function
  #-----------------------------------------------------------------------------
  def Sha256(input = nil)
    input = input.to_s unless input.is_a?(String)
    return input.nil? ? API::Sha256 : API::Sha256.call(input)
  end
  #-----------------------------------------------------------------------------
  def MD5(input = nil)
    return input.nil? ? API::MD5 : API::MD5.call(input)
  end
  #-----------------------------------------------------------------------------
  def Mining(input = nil, difficulty = 0x64)
    return input.nil? ? API::Mining : API::Mining.call(input, difficulty)
  end
  #-----------------------------------------------------------------------------
  def Verify(input = nil, difficulty = 0x64)
    return input.nil? ? API::Verify : API::Verify.call(input, difficulty)
  end
  #-----------------------------------------------------------------------------
  def CheckSum(input = nil, is_file = true, is_bin = true)
    is_file = is_file ? 1 : 0
    is_bin  = is_bin  ? 1 : 0
    return input.nil? ? API::CheckSum : API::CheckSum.call(input, is_file, is_bin)
  end
  #-----------------------------------------------------------------------------
  def EncInt(value)
    return unless value.is_a?(Numeric)
    if value < 0
      info = "Numeric out of range: #{value}"
      ERRNO.raise(:illegel_value, :exit, nil, info)
    else
      num = API::EncryptInt.call([value].pack("Q"))
      return num.to_i
    end
  end
  class << self; alias EncryptInt EncInt; end
  #-----------------------------------------------------------------------------
  def DecInt(value)
    return unless value.is_a?(Numeric)
    if value < 0
      info = "Numeric out of range: #{value}"
      ERRNO.raise(:illegel_value, :exit, nil, info)
    else
      #caller.each {|i| puts i} if value == 0
      num = API::DecryptInt.call([value].pack("Q"))
      return num.to_i
    end
  end
  class << self; alias DecryptInt DecInt; end
  #-----------------------------------------------------------------------------
end
#==============================================================================
# ** MakerSystems
#------------------------------------------------------------------------------
#  Module four our Systems.
#==============================================================================
module MakerSystems
  
  #============================================================================
  # ** Effectus
  #----------------------------------------------------------------------------
  #  This module contains variables that you can edit to make Effectus work
  # in whatever way you may need.
  #============================================================================
  
  module Effectus
    
    #------------------------------------------------------------------------
    # * Always Update Patterns.                                         [OPT]
    #------------------------------------------------------------------------
    # This are the patterns that Effectus will look for to know if it needs
    # to always update the event. The search is performed through all comments
    # in the current page of the event, so the order of the event commands
    # doesn't matter.
    # You don't have to use this feature if you set PREVENT_OFFSCREEN_UPDATES
    # to false.
    #------------------------------------------------------------------------
    PATTERNS = ['always']
    #------------------------------------------------------------------------
    # * Prevent Offscreen Updates.                                      [OPT]
    #------------------------------------------------------------------------
    # Common technique against event lag.
    # If true, events that are not inside the screen area won't be updated.
    # If false, events will be normally updated as in vanilla Ace.
    #           but you will still enjoy an enhanced experience thanks to
    #           the system's clever improvements.
    #------------------------------------------------------------------------
    PREVENT_OFFSCREEN_UPDATES = true
    #------------------------------------------------------------------------
    # * Screen Tile Division Modulo.                                    [OPT]
    #------------------------------------------------------------------------
    # Set this to true if either screen width or height divided by 32 (pixels
    # in a tile) has a division remainder.
    # If true, an additional tile is considered as "near the visible area".
    #          Tiny (really tiny) performance loss.
    # If false, screen size must be evenly divisible by 32 to avoid errors.
    #------------------------------------------------------------------------
    SCREEN_TILE_DIVMOD = false
    #------------------------------------------------------------------------
    # * Only Parallax Maps.                                             [OPT]
    #------------------------------------------------------------------------
    # Set this to true if you ONLY use parallax mapping in your project for
    # a huge performance boost.
    # If true, the tilemap (the thing needed to render the maps you created 
    #          using the editor inside the game) will be removed.
    # If false, the tilemap will be created as usual.
    #------------------------------------------------------------------------
    ONLY_PARALLAX_MAPS = false
    #------------------------------------------------------------------------
    # * Improved Plane.                                                 [OPT]
    #------------------------------------------------------------------------
    # Set this to true to use the best custom Plane script available, that is 
    # both memory and CPU efficient. This will improve the performance, 
    # especially for screen sizes bigger than 544x416.
    # If true, the default Plane script will be replaced by our version.
    # If false, the default Plane will be used as usual.
    #------------------------------------------------------------------------
    IMPROVED_PLANE     = true
    #------------------------------------------------------------------------
    # * ATB Bars Need Fixing?                                           [OPT]
    #------------------------------------------------------------------------
    # Set this to true if the bars from the battle system of your game are
    # not being displayed properly.
    # Ignore otherwise.
    # If true, the new Plane script will be in compatibility mode.
    # If false, the new Plane script will work normally.
    #------------------------------------------------------------------------
    ATB_BARS_NEED_FIXING = false
    #------------------------------------------------------------------------
    # * Improved Map Window Control.                                    [OPT]
    #------------------------------------------------------------------------
    # Set this to true to make Effectus improve the handling of default
    # Window objects in the map scene. It's a small improvement, deactivate
    # if you find any weird behavior with custom message systems.
    # If true, default Window objects on the map will be created on demand.
    # If false, default Window objects on the map will be handled as usual.
    #------------------------------------------------------------------------
    MAP_SCENE_WINDOW_IMPROVEMENTS = true
    #------------------------------------------------------------------------
    # * Sprite_Character Full Update Rate.                              [OPT]
    #------------------------------------------------------------------------
    # This is the interval at which the full update for Sprite_Character 
    # instances (The sprites for each event on the map) will be performed.
    # Must be greater than 0. Default is 2 (safe for everyone).
    # Increasing this number makes Sprite_Character less responsive to 
    # changes so you'll have to try to find a value that suits your game.
    #------------------------------------------------------------------------
    SPRITE_CHARACTER_FULL_UPDATE_RATE = 2
    
  end
  
end
