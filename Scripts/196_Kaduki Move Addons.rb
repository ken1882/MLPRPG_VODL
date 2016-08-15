# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.3
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# (English Language)
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5b
# >> Basic Functions
# >> Movement    
# >> Core Result
# >> Core Fade
# >> Clone Image
# >> Rotate Image
# >> Smooth Move
# =============================================================================
=begin

  Introduction :
  Move addons is a trick to split action sequence in different script slot to
  gain more control on you sequences

  How to make move addon :
  - Insert a new script below TSBS
  - Start with "module TSBS"
  - End it with keyword "end"
  - Insert any constant name you want between "module TSBS" and "end". Start 
    it with capital letter. For example "Stella_Moves"
  - Add = {} symbol after the name you just typed
  - Define new action sequences inside {}
  - Adds AnimLoop.merge!(Your_Inputed_Name) in the end of line
  
  The simple example would be like this
-------------------------------------------------------------------------------  
=end
module TSBS
  
  MoveAddon = {
    "New_Action" => [
    [],
    [:pose, 1,3,4],
    [:pose, 1,3,4],
    [:pose, 1,3,4],
    [:target_damage],
    # IT JUST SAMPLE!
    ],
  }
  
  AnimLoop.merge!(MoveAddon) # <-- closure
  
end 
=begin
-------------------------------------------------------------------------------  
  Or you could see the example below
-------------------------------------------------------------------------------  
=end
module TSBS
  
  # Constant name
  Kaduki_Standard = { # <-- adds {
  
  # Define new action sequence between {}
  
  # ---------------------------------------------------------------------------
  # Idle sequence
  # ---------------------------------------------------------------------------
  "K-idle" => [
    [true, false],
    [:if, "self.movable?",
      [ # true
        [:pose,     1,   0,   15],
        [:pose,     1,   1,   15],
        [:pose,     1,   2,   15],
        [:pose,     1,   1,   20],
      ],
      
      [ # false
        [:pose,     1,   0,   20],
      ]
    ],
  ],
  # ---------------------------------------------------------------------------
  # Hurt sequence
  # ---------------------------------------------------------------------------
  "K-hurt" => [
  [],
  [:pose, 1, 3, 5],
  [:pose, 1, 4, 5],
  [:pose, 1, 5, 5],
  ],
  # ---------------------------------------------------------------------------
  # Critical sequence
  # ---------------------------------------------------------------------------
  "K-pinch" => [
  [true,false],
  [:if, "self.movable?",
      [ # true
        [:pose, 1, 6, 15],
        [:pose, 1, 7, 15],
        [:pose, 1, 8, 15],
        [:pose, 1, 7, 15],
      ],
      
      [ # false
        [:pose, 1, 7, 15],
      ]
    ],
  ],
  # ---------------------------------------------------------------------------
  # Move sequence (Not used)
  # ---------------------------------------------------------------------------
  "K-move" => [
  [],
  [:pose, 1, 9, 5],
  [:pose, 1, 10, 5],
  [:pose, 1, 11, 5],
  ],
  # ---------------------------------------------------------------------------
  # Victory sequence
  # ---------------------------------------------------------------------------
  "K-victory" => [
  [false,false,false],
  [:pose, 2, 0, 30],
  [:pose, 2, 1, 8],
  [:pose, 2, 2, 60],
  ],

  # ---------------------------------------------------------------------------
  # Evade sequence
  # ---------------------------------------------------------------------------
  "K-evade" => [
  [false,false,false],
  [:slide, 25, 0, 7, 20],
  [:pose, 2, 3, 2],
  [:pose, 2, 4, 2],
  [:pose, 2, 5, 3],
  [:pose, 1, 0, 10],
#~   [:goto_oripost, 5, 0],
  ],
  # ---------------------------------------------------------------------------
  # Dead sequence
  # ---------------------------------------------------------------------------
  "K-dead" => [
  [true,false],
  [:pose, 2, 9, 10],
  [:pose, 2, 10, 10],
  [:pose, 2, 11, 10],
  ],
  # ---------------------------------------------------------------------------
  # In (bad) state sequence
  # ---------------------------------------------------------------------------
  "K-state" => [
  [false,false],
  [:pose, 1, 7, 10],
  ],
  # ---------------------------------------------------------------------------
  # Item Use
  # ---------------------------------------------------------------------------
  "K-Item" => [
  [],
  [:slide, -45, 0, 7, 10],
  [:pose, 1,0,30],
  [:flip, true],
  [:pose, 3, 6, 4],
  [:pose, 3, 7, 4],
  [:sound, "Evasion1", 80, 100],
  [:projectile, 0, 20, 10, "item_in_use.icon_index", 90],
  [:pose, 3, 8, 4],
  [:wait, 30],
  [:flip, false],
  ],
  # ---------------------------------------------------------------------------
  # Kaduki Cast Pose
  # ---------------------------------------------------------------------------
  "K-Cast" => [
  [true,false,false],
  [:pose, 3, 6, 6],
  [:pose, 3, 6, 6],
  [:pose, 3, 7, 6],
  [:pose, 3, 7, 6],
  ],
  #===========================================
  # Counter  Attack
  #===========================================
    "Sol_Counter" => [
  [false, false, nil],
  [:move_to_target, 0, 0, 10, 10],
  [:wait, 10],
  [:target_damage],
  [:show_anim],
  [:wait, 25],
  ],
  "ECounter" => [
  [false, false, nil],
  [:move_to_target, 0, 0, 10, 10],
  [:wait, 10],
  [:target_damage],
  [:show_anim],
  [:wait, 25],
  ],
  
  } # <-- end "}"
  
  AnimLoop.merge!(Kaduki_Standard) # <-- Add this line as closure
  
end