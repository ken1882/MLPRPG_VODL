class Scene_Test < Scene_Base
  def post_start
    super
    create_background
    create_all_window
  end
  
  def create_background
    @background = Sprite.new(@viewport)
    @background.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    color = Color.new(255, 255, 255)
    @background.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, color)
    @background.z = 0
  end
  
  def create_all_window
    @window_input = Window_Input.new(Graphics.center_width(480), Graphics.center_height(28))
  end
  
  def update
    super
  end
  
  def draw_text(*args)
    @window_debug.draw_text(*args)
  end
  
end
