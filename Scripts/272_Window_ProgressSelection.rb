#==============================================================================
# ** Window_ProgressSelection
#------------------------------------------------------------------------------
#  This command window determines new game or load a save file in title screen
#==============================================================================
class Window_ProgressSelection < Window_HorzCommand
  #--------------------------------------------------------------------------
  NewGame      = "new_journey"    # Image name of New Game
  LoadGame     = "load_progress"  # Image name of Load Game
  NGOutline    = "newj_outline"   # Outline for NewGame Sprite
  LoadOutline  = "load_outline"   # Outline for LoadGame Sprite
  IconRect     = Rect.new(0, 0, 266, 250)
  WinWidth     = 640              # Window Width
  WinHeight    = 480              # Window Height
  UpdateCycle  = 60               # Frames to complete a full update cycle
  DeltaTheta   = 180.0 / UpdateCycle
  #--------------------------------------------------------------------------
  def initialize(x, y)
    self.class.const_set(:WinWidth, Graphics.width)
    super(x, y)
    self.back_opacity = 250
    self.arrows_visible = false
    swap_skin(WindowSkin::BBoarder)
    @anim_index = 0
    @anim_timer = 0
    create_newgame_sprite
    create_loadgame_sprite
    create_text_sprite
    create_mode_sprite
  end
  #--------------------------------------------------------------------------
  def window_width;     WinWidth;   end
  def window_height;    WinHeight;  end
  #--------------------------------------------------------------------------
  def contents_width;   WinWidth;   end
  def contents_height;  WinHeight;  end
  #--------------------------------------------------------------------------
  def item_height
    IconRect.height
  end
  #--------------------------------------------------------------------------
  def item_width
    IconRect.width
  end
  #--------------------------------------------------------------------------
  def draw_item(index)
    
  end
  #--------------------------------------------------------------------------
  def update_cursor
  end
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::NewGame,  :new_game,  true, nil, Vocab::NewGame)
    add_command(Vocab::LoadGame, :load_game, true, nil, Vocab::LoadGame)
  end
  #--------------------------------------------------------------------------
  # * Reset src_rect of animated icon sprite
  #--------------------------------------------------------------------------
  def reset_animated_icon(sprite, outline, text)
    sprite.opacity = 0xff
    text.opacity   = 0xff
    @anim_index    = 0
    outline.show
  end
  #--------------------------------------------------------------------------
  def unselect_icon(sprite, outline, text)
    sprite.opacity = translucent_alpha
    text.opacity   = translucent_alpha
    outline.hide
  end
  #--------------------------------------------------------------------------
  def update_animated_icon(sprite)
    @anim_index = (@anim_index + 1) % UpdateCycle
    mul = Math.sin((90 + @anim_index * DeltaTheta).to_rad).abs
    opa = (0xff * mul).to_i
    sprite.opacity = opa
  end
  #--------------------------------------------------------------------------
  def update
    super
    return unless visible?
    update_sprites
  end
  #--------------------------------------------------------------------------
  def update_tone; end
  #--------------------------------------------------------------------------
  def update_sprites
    case @index
    when 0
      if index_changed?
        reset_animated_icon(@newgame_sprite, @newgame_outline, @ng_text_sprite)
        unselect_icon(@loadgame_sprite, @loadgame_outline, @lg_text_sprite)
      end
      update_animated_icon(@newgame_outline)
    when 1
      if index_changed?
        reset_animated_icon(@loadgame_sprite, @loadgame_outline, @lg_text_sprite)
        unselect_icon(@newgame_sprite, @newgame_outline, @ng_text_sprite)
      end
      update_animated_icon(@loadgame_outline)
    end
  end
  #--------------------------------------------------------------------------
  def create_newgame_sprite
    @newgame_sprite   = Sprite.new
    @newgame_sprite.x = self.x + spacing * 2
    @newgame_sprite.y = (self.y + spacing * 4 + window_height - IconRect.height) / 2
    @newgame_sprite.bitmap = Cache.UI(NewGame)
    
    @newgame_outline = Sprite.new
    @newgame_outline.x = @newgame_sprite.x
    @newgame_outline.y = @newgame_sprite.y
    @newgame_outline.bitmap = Cache.UI(NGOutline)
    
    @child_sprite << @newgame_sprite << @newgame_outline
  end
  #--------------------------------------------------------------------------
  def create_loadgame_sprite
    @loadgame_sprite   = Sprite.new
    @loadgame_sprite.x = self.x + window_width - spacing * 2 - IconRect.width
    @loadgame_sprite.y = (self.y + spacing * 4 + window_height - IconRect.height) / 2
    @loadgame_sprite.bitmap = Cache.UI(LoadGame)
    
    @loadgame_outline = Sprite.new
    @loadgame_outline.x = @loadgame_sprite.x
    @loadgame_outline.y = @loadgame_sprite.y
    @loadgame_outline.bitmap = Cache.UI(LoadOutline)
    
    @child_sprite << @loadgame_sprite << @loadgame_outline
  end
  #--------------------------------------------------------------------------
  def create_text_sprite
    @ng_text_sprite = Sprite.new
    @ng_text_sprite.x = @newgame_sprite.x + 4
    @ng_text_sprite.y = @newgame_sprite.y + IconRect.height + 8
    twidth = @newgame_sprite.width
    @ng_text_sprite.bitmap = Bitmap.new(twidth + 8, line_height * 2)
    trect = Rect.new(0, 0, twidth, line_height)
    FileManager.textwrap(@list[0][:help], twidth).each do |line|
      @ng_text_sprite.bitmap.draw_text(trect, line, 1)
      trect.y += line_height
    end
    
    @lg_text_sprite = Sprite.new
    @lg_text_sprite.x = @loadgame_sprite.x + 4
    @lg_text_sprite.y = @loadgame_sprite.y + IconRect.height + 8
    twidth = @loadgame_sprite.width
    @lg_text_sprite.bitmap = Bitmap.new(twidth + 8, line_height * 2)
    trect = Rect.new(0, 0, twidth, line_height)
    FileManager.textwrap(@list[1][:help], twidth).each do |line|
      @lg_text_sprite.bitmap.draw_text(trect, line, 1)
      trect.y += line_height
    end
    
    @child_sprite << @ng_text_sprite << @lg_text_sprite
  end
  #--------------------------------------------------------------------------
  def create_mode_sprite
    @mode_sprite = Sprite.new
    @mode_sprite.bitmap = Bitmap.new(Graphics.width, 128)
    @child_sprite << @mode_sprite
  end
  #--------------------------------------------------------------------------
  def show
    super
    @mode_sprite.bitmap.clear
    mode = nil
    case $game_system.game_mode
    when :main;     mode = PONY::GameMode::Modes[0]
    when :tutorial; mode = PONY::GameMode::Modes[1]
    end
    
    unselect_icon(@loadgame_sprite, @loadgame_outline, @lg_text_sprite)
    unselect_icon(@newgame_sprite, @newgame_outline, @ng_text_sprite)
    
    if mode
      rect = Rect.new(0, 0, Graphics.width, 128)
      @mode_sprite.bitmap.blt(0, 0, Cache.UI(mode[:image]), rect)
      #-- draw mode name
      text_width = text_size(mode[:name]).width + 8
      offset = POS.new(38, 12)
      rect.x = rect.width - text_width - offset.x;
      rect.y = rect.y + rect.height - line_height - offset.y
      rect.width = text_width
      rect.height = line_height
      @mode_sprite.bitmap.draw_text(rect, mode[:name])
    end
  end
  #--------------------------------------------------------------------------
  def set_z(nz)
    return unless nz
    super
    @mode_sprite.z = nz
    @newgame_outline.z = @loadgame_outline.z = nz + 1
    @newgame_sprite.z  = @loadgame_sprite.z  = nz + 2
    @ng_text_sprite.z  = @lg_text_sprite.z   = nz + 3
  end
  #---------------------------------------------------------------------------
  def item_rect(index)
    hgw = Graphics.width / 2; gh = Graphics.height
    return Rect.new(0, 0, hgw, gh) if index == 0
    return Rect.new(hgw, 0, hgw, gh) if index == 1
    return super
  end
  #--------------------------------------------------------------------------
end
