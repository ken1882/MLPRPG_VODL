#==============================================================================
# ** Window_ProgressSelection
#------------------------------------------------------------------------------
#  This command window determines new game or load a save file in title screen
#==============================================================================
class Window_ProgressSelection < Window_Command
  #--------------------------------------------------------------------------
  AnimatedIcon = Struct.new(:frames, :width, :height).new(6, 266, 250)
  NewGame      = "new_journey"    # Image name of New Game
  LoadGame     = "load_progress"  # Image name of Load Game
  WinWidth     = Graphics.width   # Window Width
  WinHeight    = 300              # Window Height
  AnimUpdateTime = 4              # Frames to update the animated icon once
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, width, height)
    @anim_index = 0
    @anim_timer = 0
    @src_rect = Rect.new(0, 0, AnimatedIcon.width, AnimatedIcon.height)
    create_newgame_sprite
    create_loadgame_sprite
  end
  #--------------------------------------------------------------------------
  def window_width
    return WinWidth
  end
  #--------------------------------------------------------------------------
  def window_height
    return WinHeight
  end
  #--------------------------------------------------------------------------
  def item_height
    AnimatedIcon.height
  end
  #--------------------------------------------------------------------------
  def item_width
    AnimatedIcon.width
  end
  #--------------------------------------------------------------------------
  def draw_item(index)
  end
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    cursor_rect.empty
  end
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::NewGame,  :new_game,  true, nil, Vocab::NewGameHelp)
    add_command(Vocab::LoadGame, :load_game, true, nil, Vocab::LoadGameHelp)
  end # last work is fucking here
  #--------------------------------------------------------------------------
  # * Reset src_rect of animated icon sprite
  #--------------------------------------------------------------------------
  def reset_animated_icon(sprite)
    @anim_index = 0
    @src_rect.x = 0; @src_rect.y = 0;
    sprite.src_rect.set(@src_rect)
  end
  #--------------------------------------------------------------------------
  def update_animated_icon(sprite)
    @anim_timer = (@anim_timer + 1) % AnimUpdateTime
    return unless @anim_timer == 0
    @anim_index = (@anim_index + 1) % AnimatedIcon.frames
    @src_rect.width = AnimatedIcon.width * @anim_index
    sprite.src_rect.set(@src_rect)
  end
  #--------------------------------------------------------------------------
  def update
    super
    case @index
    when 0
      reset_animated_icon(@newgame_sprite) if index_changed?
      update_animated_icon(@newgame_sprite)
    when 1
      reset_animated_icon(@loadgame_sprite) if index_changed?
      update_animated_icon(@loadgame_sprite)
    end
  end
  #--------------------------------------------------------------------------
  def create_newgame_sprite
    @newgame_sprite   = Sprite.new
    @newgame_sprite.x = self.x + spacing
    @newgame_sprite.y = self.y + spacing
    bmp = Cache.UI(NewGame)
    @newgame_sprite.bitmap = bmp
    @newgame_sprite.src_rect.set(0, 0, AnimatedIcon.width, AnimatedIcon.height)
    bmp.dispose
    @child_sprite << @newgame_sprite
  end
  #--------------------------------------------------------------------------
  def create_loadgame_sprite
    @loadgame_sprite   = Sprite.new
    @loadgame_sprite.x = self.x + window_width - spacing
    @loadgame_sprite.y = self.y + spacing
    bmp = Cache.UI(LoadGame)
    @loadgame_sprite.bitmap = bmp
    @loadgame_sprite.src_rect.set(0, 0, AnimatedIcon.width, AnimatedIcon.height)
    bmp.dispose
    @child_sprite << @loadgame_sprite
  end
  #--------------------------------------------------------------------------
end
