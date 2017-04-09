
module Mouse
  
  module_function
  def collide_sprite?(sprite)
    return area?(sprite.x, sprite.y, sprite.width, sprite.height)
  end
  
end
