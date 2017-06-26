class Scene_Test < Scene_Base
  def post_start
    super
    create_background
    create_layer
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
    @window_input = Window_Input.new(Graphics.center_width(480), Graphics.center_height(28), 480, autoscroll: true)
  end
  
  def update
    super
    if Input.trigger?(:kF5)
      @window_input.dispose unless @window_input.disposed?
      @window_input = Window_Input.new(Graphics.center_width(480), Graphics.center_height(28), 480, autoscroll: true)
    end
    process_input
  end
  
  def process_input
    return unless @input_string
    if @input_string.start_with?("eval")
      eval(@input_string.split('eval').at(1))
    end
    
    @input_string = nil
  end
  
  
  def draw_text(*args)
    @window_debug.draw_text(*args)
  end
  
  def create_layer
    @layer = Sprite.new(@viewport)
    @layer.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    text = "Press F5 to show Input Window"
    cx = (Graphics.width - text.size * 10) /2
    @layer.bitmap.draw_text(cx, 20, 400, 24, text)
  end
  
  def terminate
    super
    @layer.dispose
    @background.dispose
  end
  
end
