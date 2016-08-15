#tag: skill action

module TSBS
  
  Staff_Icons = {
  
  # Raise the staff
  "Staff-RAISE" => [4, 0, 0, true, -30,-30,1,-1],
  
  "Xbow-RAISE" => [0,-4,-12, true, -30,45,1,-1],
  
  # Small rotation
  "Staff-Rotate1" => [4, 0, 0, true, -30,0,10,-1],
  
  # Heavy Rotation... I mean, Big rotation
  "Staff-Rotate2" => [4, 0, -5, false, -30,30,10,-1],
  
  }
  
  Moves = {
  #----------------------------------------------------------------------------
  "Summon_Grenade" => [
  [],
  [:change_skill, 41],
  [:pose, 2, 2, 30],      
  [:pose, 3, 1, 5],       
  [:pose, 3, 2, 5],       
  [:sound, "Evasion1", 100, 100],
  [:proj_afimage],
  [:projectile, 0, 30, 15, 211, 15],  
  [:pose, 3, 8, 30],      
  [:wait, 30], 
  ],
  #----------------------------------------------------------------------------
  "Move" => [
  [:slide, -45, 0, 10, 7],    # Slide forward
  [:wait, 15],                # Wait for 15 frames
  ],
  #----------------------------------------------------------------------------
  "E_Move" => [
  [:slide, 45, 0, 10, 7],    # Slide forward
  [:wait, 15],                # Wait for 15 frames
  ],
  #----------------------------------------------------------------------------
  "Jump" => [
  [:slide,0, 0, 10, 7], 
  [:wait, 5], 
  ],
  #----------------------------------------------------------------------------
  "ATK" => [
  [],
  [:action, "Move"],        # Move forward
  #[:wait,10],
  #[:pose, 3,0,4,"Staff-RAISE"], # Swing the staff
  [:pose, 3,6,5],
  [:pose, 3,7,5],
  [:projectile, 150, 8, 0], 
  [:wait, 20],
  ],
  # ---------------------------------------------------------------------------
  # Basic move for magic skill casting. To be called somewhere
  # ---------------------------------------------------------------------------
  "MagicCast" => [
  [:action, "Move"],
#  [:icon,"Staff-RAISE"],            # Raise staff!
  [:cast, 139],                      # Play casting animation
  [:loop, 3, "K-Cast"],             # Loop three times
  [:wait, 10],                      # Wait for 15 frame
  
  ],
  #----------------------------------------------------------------------------
  "Vcs_Fireball" => [
  [],
  [:camera, 1, [-75,-25], 65, 1.2],
  [:focus, 60],
  [:action, "MagicCast"],
  [:proj_setup, {
    :start_pos => [0,0], 
    :end_pos => [-50,0],
    :end => :feet,
    :anim_start => 2,
    :anim_end => :default,
    :flash => [false,true],
  }],
  [:camera, 0, [100,-50], 55, 1.0],
  [:projectile,57,14,0],         # Show fireball
  [:wait, 4],
  [:proj_setup, {
    :change => true,
    :end_pos => [-10, 10],
  }],
  [:projectile,57,14,0],         # Show fireball
  [:wait, 4],
  [:proj_setup, {
    :change => true,
    :end_pos => [-10, 10],
  }],
  [:projectile,57,14,0],         # Show fireball
  [:wait, 75],                   # Wait for 30 frames
  [:unfocus, 30],               # Unfocus for 30 frames duration
  [:wait,30],                   # Wait for 30 frames
  ],
  #----------------------------------------------------------------------------
  "Thunder" => [
  [],
  [:camera, 1, [-75,-25], 65, 1.3],
  [:icon,"Staff-RAISE"],            # Raise staff!
  [:cast, 14],                      # Play casting animation
  [:loop, 3, "K-Cast"],             # Loop three times
  [:wait, 15],                      # Wait for 15 frame
  [:camera, 1, [-220,-25], 65, 1.0],
  [:pose, 3, 3, 4,"Staff-Rotate1"], # Rotate staff + change pose
  [:pose, 3, 4, 4],                 # Change pose, wait for 4 frames
  [:pose, 3, 5, 5],                 # Change pose, wait for 4 frames
  [:summon, 1, :self, [-75, 0], -1, "Summon_Grenade", 61, 38],
  [:wait, 5],
  [:summon, 2, :self, [-25, 25], -1, "Summon_Grenade", 61, 38],
  [:wait, 120],
  [:camera, 0, [100,-50], 55, 1.0],
  [:summon, 3, :target, [-105, 0], -1, "Summon_Grenade", 42, 53, true],
  [:wait, 5],
  [:summon, 4, :target, [105, 0], -1, "Summon_Grenade", 42, 53],
  [:wait, 120],
  ],
  #----------------------------------------------------------------------------
  "MMRain-Pre" => [
  [],
  [:camera, 1, [-75,-25], 65, 1.3],
  [:action, "Move"],
  [:icon,"Staff-RAISE"],            # Raise staff!
  [:cast, 14],                      # Play casting animation
  [:loop, 3, "K-Cast"],             # Loop three times
  [:wait, 15],                      # Wait for 15 frame
  [:camera, 2, [100,-50], 55, 1.0],
  [:pose, 3,0,4,"Staff-Rotate2"], # Swing the staff
  [:pose, 3,1,4],
  [:pose, 3,2,4],
  ],
  #----------------------------------------------------------------------------
  "MMRain" => [
  [],
  [:proj_setup, {
    :pierce => true, 
    :wait => 15, 
    :start_pos => [-25, 0],
    :aftimg => true,
    :aft_rate => 1,
  }],
  [:projectile, 56, 10, 0],        # Show magic projectile
  [:sound, "Ice7", 80, 100],
  [:wait, 15],
  [:sound, "Laser", 80, 150],
  [:sound, "Shot1", 80, 150],
  [:wait, 20],               
  ],
  #----------------------------------------------------------------------------
  "MMRain-Post" => [
  [],
  [:wait, 50],
  [:action, "RESET"],
  ],
  #----------------------------------------------------------------------------
  "Magic" => [
  [],
  [:action, "MagicCast"],
  [:action, "Target Damage"],
  [:wait, 60],
  ],
  #----------------------------------------------------------------------------
  "MagicRain" => [
  [],
  [:camera, 1, [-75,-25], 65, 1.3],
  [:pose, 2, 2, 30],      
  [:pose, 3, 1, 5],       
  [:pose, 3, 2, 5],       
  [:sound, "Evasion1", 100, 100],
  [:proj_setup, {
    :end => :self,
    :end_pos => [-115, -150, 1],
    :anim_end => 55,
    :aftimg => true,
    :damage => 0,
  }],
  [:one_anim],
  [:projectile, 0, 25, 7, 3224, 90],
  [:camera, 2, [100,-50], 55, 1.0],
  [:wait, 25 + 6],
  [:proj_setup, {
    :start_pos => [-115, -150],
  }],
  [:projectile, 56, 14, 7],
  [:wait, 20],
  [:check_collapse],
  [:wait, 40],
  ],
  #----------------------------------------------------------------------------
  "Magic_missile" => [
  [],
  [:wait,10],                     # Wait for 10 frames
  [:action,"MagicCast"],
  
  [:projectile, 220,8,0],
  [:wait, 4],
  
  [:projectile, 220,8, 0],
  [:wait, 4],

  [:projectile,  220, 8, 0],
  [:wait, 4],

  ],
  #----------------------------------------------------------------------------
  "Grease" => [
  [],
  [:wait,10],                     # Wait for 10 frames
  [:action,"MagicCast"],
  [:projectile, 140, 8, 0],       # Show magic projectile
  ],
  #----------------------------------------------------------------------------
  "Chromatic_Orb" => [
  [],
  [:wait,10],                     # Wait for 10 frames
  [:action,"MagicCast"],
  [:projectile, 140, 8, 0],       # Show magic projectile
  ],
   #----------------------------------------------------------------------------
  "Blindness" => [
  [],
  [:wait,10],                     # Wait for 10 frames
  [:action,"MagicCast"],
  [:projectile, 140, 8, 0],
  ],
  #----------------------------------------------------------------------------
  "Scorcher" => [
  [],
  [:wait,10],                     # Wait for 10 frames
  [:action,"MagicCast"], # 3 * 6 + 2 = 20 times
  [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     
  [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     
  [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     
  [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     
  [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     
  [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2],     
  [:projectile, 155, 8, 0],[:wait,2],     [:projectile, 155, 8, 0],[:wait,2], 
  
  ],
  #----------------------------------------------------------------------------
  "Acid_Arrow" => [
  [],
  [:wait,10],                     # Wait for 10 frames
  [:action,"MagicCast"],
  [:projectile, 156, 8, 0], 
  ],
  #----------------------------------------------------------------------------
  "Mirror_Image" => [
  [],
  [:wait,10],                     # Wait for 10 frames
  [:action,"MagicCast"],
  [:projectile, 140,3, 0], 
  [:summon, 13, :self, [45, 10], -1, "Summon_Grenade", 61, 38],
  [:summon, 13, :self, [20, 0], -1, "Summon_Grenade", 61, 38],
  [:summon, 13, :self, [45, -10], -1, "Summon_Grenade", 61, 38],
  [:summon, 13, :self, [70, 0], -1, "Summon_Grenade", 61, 38],
  ],
  #----------------------------------------------------------------------------
  "Ray"=>[
  [],
  [:action,"MagicCast"],
  [:projectile, 174,15, 0], 
  ],
  #----------------------------------------------------------------------------
  "Comet"=>[
    [],
    [:focus, 100],
    [:action,"MagicCast"],
    [:projectile,205,200,0],
    [:wait,200]
  ],
  #----------------------------------------------------------------------------
  "Comet_E"=>[
      [],
      [:focus, 100],
      [:action,"MagicCast"],
      [:projectile,208,200,0],
      [:wait,200],
    ],
  }
  
  Icons.merge!(Staff_Icons)
  AnimLoop.merge!(Moves)
  
end