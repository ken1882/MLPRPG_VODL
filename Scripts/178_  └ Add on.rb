#==============================================================================
# ** Window_ItemList
#------------------------------------------------------------------------------
#  This window displays a list of party items on the item screen.
#==============================================================================
class Window_ItemList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_dnd initialize
  def initialize(x, y, width, height)
    @actor = $game_player
    init_dnd(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    super
    return prev_actor if handle?(:prev_actor) && Input.trigger?(:R)
    return next_actor if handle?(:next_actor) && Input.trigger?(:L)
  end
  #--------------------------------------------------------------------------
  def actor=(n_actor)
    @actor = n_actor
  end
  #--------------------------------------------------------------------------
  def prev_actor
    Sound.play_cursor
    call_handler(:prev_actor)
  end
  #--------------------------------------------------------------------------
  def next_actor
    Sound.play_cursor
    call_handler(:next_actor)
  end
  #--------------------------------------------------------------------------
end
