#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a super class of all windows within the game.
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system(WindowSkin::Default) if !self.windowskin
    update_padding
    update_tone
    create_contents
    @opening = @closing = false
  end
  #--------------------------------------------------------------------------
  def swap_skin(skin = WindowSkin::Default)
    return unless WindowSkin::Enable
    self.windowskin = skin
  end
  #--------------------------------------------------------------------------
  # * Start button cooldown
  #--------------------------------------------------------------------------
  def heatup_button
    SceneManager.scene.heatup_button rescue false
  end
  #--------------------------------------------------------------------------
  # * Button cooldown finished
  #--------------------------------------------------------------------------
  def button_cooled?
    SceneManager.scene.button_cooled? rescue false
  end
  #--------------------------------------------------------------------------
  # * Window visible? tag: modified
  #--------------------------------------------------------------------------
  def visible?
    return visible
  end
  #--------------------------------------------------------------------------
  # * Window Active?
  #--------------------------------------------------------------------------
  def active?
    return active
  end
end
