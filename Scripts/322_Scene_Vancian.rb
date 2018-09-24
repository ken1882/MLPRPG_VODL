#==============================================================================
# ** Scene_Vancian
#------------------------------------------------------------------------------
#  Scene for prepare vancian spells
#==============================================================================
# last work: spell book
class Scene_Vancian < Scene_MenuBase
  #--------------------------------------------------------------------------
  BackgroundImage       = "StarSwirl_Archive"
  SpellbookImage        = "spellbook"
  SpellLevelTagImage    = "booktag"
  SpellLevelTagOutline  = "booktag_outline"
  #--------------------------------------------------------------------------
  # * start
  #--------------------------------------------------------------------------
  def start
    super
    create_all_windows
  end
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Cache.background(BackgroundImage)
  end
  #--------------------------------------------------------------------------
  def create_all_windows
    create_help_window
    create_spellbook
  end
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new
  end
  #--------------------------------------------------------------------------
  def create_spellbook
    @layout    = ::Sprite.new
    @layout.bitmap = Cache.UI(SpellbookImage)
    ww, wh = @layout.bitmap.width, @layout.bitmap.height
    wx, wy = Graphics.center_width(ww), Graphics.height - wh
    @spellbook = Window_MouseUIBase.new(wx, wy, ww, wh)
  end
  #--------------------------------------------------------------------------
end
