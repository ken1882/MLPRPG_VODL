

module TSBS
  jump_height = 20
  wait_time = 4
  
  Moves = {
  # ---------------------------------------------------------------------------
  # Aim sequence
  # ---------------------------------------------------------------------------
  "Aim_Target" => [
    [true],
    [:icon,"Clear"],
    [:icon,"Xbow-RAISE"],
    [:pose,5,0,100],
    ],
  # ---------------------------------------------------------------------------
  # Casting sequence
  # ---------------------------------------------------------------------------
  "Casting" => [
    [true],
    [:icon,"Clear"],
    [:pose, 3, 6, 6],
    [:pose, 3, 6, 6],
    [:pose, 3, 7, 6],
    [:pose, 3, 7, 6],    
  ],
  # ---------------------------------------------------------------------------
  # Debuff sequence
  # ---------------------------------------------------------------------------
  "Debuff" => [
    [true],
    [:balloon,12],
    [:wait,56],
  ],
  # ---------------------------------------------------------------------------
  # Debuff sequence
  # ---------------------------------------------------------------------------
  "Debuff_Anger" => [
    [true],
    [:balloon,13],
    [:wait,56],
  ],
  # ---------------------------------------------------------------------------
  # Force Field
  # ---------------------------------------------------------------------------
  "Force_Field" => [
    [true],
    [:script,"self.multi_animation_id.push(359)"],
    [:wait,60],    
  ],
  # ---------------------------------------------------------------------------
  # Knock Back
  # ---------------------------------------------------------------------------
  "Knock_Back" => [
    [],
    [:goto_oripost, 10, 0],
  ],
  
  #-----------------------------------------------------------------------------
  
  #-----------------------------------------------------------------------------
  }
  Icons.merge!(Staff_Icons)
  AnimLoop.merge!(Moves)
  
end