# tag: test
class Scene_Test < Scene_Base
  def post_start
    super
    create_background
    create_layer
    create_all_window
    @se_timer = 0
  end
  
  
  def start
    super
    $sprite = Sprite.new(@viewport)
    $sprite.z = 1000
    # test_sum
    # test_fi
  end
  
  def test_sum
    puts "===========Test1========="
    len = 10000000
    ar = []
    len.times{|_| ar << (rand() * 100).to_i}
    t1 = Time.now
    p 'start'
    p PONY::API::SumArray.call(len, ar.pack("l*"))
    t2 = Time.now
    puts "DLL: #{(t2-t1).to_s}"
    p ar.inject(0){|r,i| r + i}
    puts "Ruby: #{(Time.now - t2).to_s}"
  end

  def test_fi
    puts "===========Test2========="
    len = 30
    t1 = Time.now
    p 'start'
    p PONY::API::Fiboncci.call(len)
    t2 = Time.now
    puts "DLL: #{(t2 - t1).to_s}"
    p fiboncci_rb(len)
    puts "Ruby: #{(Time.now - t2).to_s}"
  end
  
  def fiboncci_rb(n)
    return 1 if n < 2
    return fiboncci_rb(n-1) + fiboncci_rb(n-2)
  end

  def create_background
    @background = Sprite.new(@viewport)
    @background.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    color = Color.new(255, 255, 255)
    @background.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, color)
    @background.z = 0
  end
  
  def create_all_window
    @window_input = Window_Input.new(Graphics.center_width(480), Graphics.center_height(28) - 24, 480, autoscroll: true, number: false, dim_background: true, title: "Please enter something~")
    #@window_input = Window_Input.new(Graphics.center_width(480), Graphics.center_height(28) + 24, 480, autoscroll: true)
  end
  
  def update
    super
    if Input.trigger?(:kF5)
      @window_input.dispose   unless @window_input.disposed?
      create_all_window
    end
    process_input
    #Sound.low_hp if @se_timer == 0
    @se_timer += 1
    @se_timer = 0 if @se_timer >= 65
  end
  
  def process_input
    return unless @input_string
    if @input_string.start_with?("eval")
      begin 
        eval(@input_string.split('eval').at(1))
      rescue Exception => e
        p e
      end
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
    $sprite.dispose
  end
  
end
