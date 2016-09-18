#tag: skill action

module TSBS
  jump_height = 20
  wait_time = 4
  
  Moves = {
  
  "Double_Attack" => [
  [],
  [:move_to_target, 0, 0, 2, 10],
  [:wait,2],
  [:projectile,169,5,0],
  [:wait,4],
  [:projectile,169,5,0],
  ],
  
 
  #----------------------------------------------------------------------------
  "Attack_Pose" => [
    [],
    [:pose,4,0,3],
    [:pose,4,1,3],
    [:pose,4,2,3],
  ],
  #----------------------------------------------------------------------------
  "Attack_Pose_reversed" => [
    [],
    [:pose,5,0,3],
    [:pose,5,1,3],
    [:pose,5,2,3],
  ],
  #=============================================================================
 "Dual-Wield" => [
    [],
    [:script,"$base_damage = calc_dual_wield_base_damage * 0.7"],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:show_anim,304],
    [:target_damage,"$base_damage - b.def * 2"],
    #--------------------------------------------------
    # calc off-hamd damage
    #
    # Dual Weapon Training
    #--------------------------------------------------
    [:if,"self.skill_learned?(601)",  
      [ #true
        [:script,"$base_damage *= 0.8"],
      ],
      [ #false
        [:script,"$base_damage *= 0.6"],
      ]
    ],
    #--------------------------------------------------
    #   Dual Weapon Finesse
    #--------------------------------------------------
    [:if,"self.skill_learned?(602)", 
      [ #true
        [:script,"$base_damage *= 1.2"],
      ],
      # false: do nothing
    ],
    #--------------------------------------------------
    #   Dual Weapon Mastery
    #--------------------------------------------------
    [:if,"self.skill_learned?(603)",  
      [ #true
        [:script,"$base_damage *= 1.3"],
      ],
      # false: do nothing
    ],
    #--------------------------------------------------
    #   Dual Striking
    #--------------------------------------------------
    [:if,"self.state?(228)",
      [ #true
        [:script,"$base_damage *= 1.5"],
      ],
      # false
      [
        [:action,"Attack_Pose"],
      ],
    ],
    #--------------------------------------------------
    [:show_anim,305],
    [:if,"self.skill_learned?(603)",  #Dual Weapon Mastery
      [ #true
        [:target_damage,"b.add_state(226) if a.difficulty_class('str',3) > b.saving_throw('con'); $base_damage - b.def * 2.3"]
      ],
      # false:
      [
        [:target_damage,"$base_damage - b.def * 2.3"]
      ],
    ],
    #--------------------------------------------------
    #   Dual Striking wair for chain skill
    #--------------------------------------------------
    [:if,"self.state?(228)",
      [ #true
        [:wait,8],
      ],
      # false: do nothing
    ],
  ],
  #=============================================================================
  "Trible_Slash" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:wait,2],
    [:projectile,0,5,0],
    [:wait,2],
    [:projectile,0,5,0],
    [:wait,2],
    [:projectile,0,5,0],
    [:wait,5],
  ],
  #----------------------------------------------------------------------------
  "Maigc_Bolt" => [
  [],
  [:action,"ATK"],
  ],
  #----------------------------------------------------------------------------
  "Casting_Spell" => [
  [],
  [:cast, 139],
  [:loop, 3, "K-Cast"],
  [:wait,3],
  [:projectile, 140,3, 0], 
  ],
  #----------------------------------------------------------------------------
  "Casting_Pose" => [
  [],
  [:cast, 139],
  [:loop, 3, "K-Cast"],
  [:wait,3],
  ],
  #----------------------------------------------------------------------------
  "Dragon_Casting" => [
  [],
  [:cast, 178],                      # Play casting animation
  [:loop, 3, "K-Cast"],             # Loop three times
  [:wait, 10],                      # Wait for 15 frame
  [:projectile, 140,3, 0], 
  
  ],
  #----------------------------------------------------------------------------
  "LunarSlash" => [
  [],
  [:action,"ATTACK"],
  [:slide, -45, 0, 50, 15],  
  [:projectile, 149, 8, 0],
  [:wait,4],
  
  # Luna is OP
  [:slide, 90, 0,jump_height, 7],
  [:projectile, 149, 8, 0],
  [:wait,4],
  
  [:slide, -90, 0,jump_height, 7],
  [:projectile, 149, 8, 0],
  [:wait,4],

  [:slide, 90, 0,jump_height, 7],
  [:projectile, 149, 8, 0],
  [:wait,4],
  
  [:slide, -90, 0,jump_height, 7],
  [:projectile, 149, 8, 0],
  [:wait,4],
  
  [:slide, 90, 0, jump_height,  7],
  [:projectile, 149, 8, 0],
  [:wait,4],
  
  [:slide, -90, 0, jump_height,  7],
  [:projectile, 149, 8, 0],
  [:wait,4],
  
  [:slide,90, 0, jump_height,  7],
  [:projectile, 149, 8, 0],
  [:wait,4],
  
  [:slide, -90, 0,jump_height, 7],
  [:projectile, 149, 8, 0],
  [:wait,4],
  ],

  #----------------------------------------------------------------------------
  "Sonic_Rainboom" => [
    [],
    [:focus,10],
    [:action,"Move"],
    [:slide,-100,20,160,160],
    [:wait,3],
    [:projectile,176,160,0],
    [:wait,10],
    ],
    #----------------------------------------------------------------------------
    "Arial_Strike" => [
    [],
    [:action,"ATTACK"],
    [:wait,3],
    ],
    #----------------------------------------------------------------------------
    "Shot" => [
    [],
    [:action,"Move"],
    [:projectile, 146,5, 0], 
    ],#----------------------------------------------------------------------------
    "Gem_Shot" => [
    [],
    [:action,"E_Move"],
    [:projectile, 163,5, 0], 
    ],
    #----------------------------------------------------------------------------
    "Arrow_Shot_R" => [
    [],
    [:script, "self.remove_state(48)"],
    [:action,"Move"],
    [:projectile, 167,5, 0], 
    ],
    #----------------------------------------------------------------------------
    "Arrow_Shot_L" => [
    [],
    [:script, "self.remove_state(48)"],
    [:icon,"Xbow-RAISE"],
    [:pose,5,0,3],
    [:wait,3],
    [:projectile, 166,5, 0], 
    [:pose,5,0,5],
    [:wait,5],
    ],
    #----------------------------------------------------------------------------
    "Bolt_Shot_L" => [
    [],
    [:script, "self.remove_state(48)"],
    [:icon,"Xbow-RAISE"],
    [:pose,5,0,3],
    [:wait,3],
    [:projectile, 166,5, 0], 
    [:pose,5,0,5],
    [:wait,5],
    ],
    #----------------------------------------------------------------------------
    "Scattershot" => [
    [],
    [:script, "self.remove_state(48)"],
    [:icon,"Xbow-RAISE"],
    [:pose,5,0,3],
    [:wait,3],
    [:projectile, 268,3, 0], 
    [:pose,5,0,5],
    [:wait,5],
    ],#----------------------------------------------------------------------------
    "Arrow_Slaying" => [
    [],
    [:script, "self.remove_state(48)"],
    [:icon,"Xbow-RAISE"],
    [:pose,5,0,3],
    [:wait,3],
    [:projectile, 269,3, 0], 
    [:pose,5,0,5],
    [:screen, :shake,8,10, 10],
    [:wait,5],
    ],

    #----------------------------------------------------------------------------
    "Pinkie_Stab" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:wait,2],
    [:slide,-50,1,3,1],
    [:pose, 3, 4,5],
    [:wait,3],
    [:projectile, 140,3, 0],
    [:wait,15]
    ],
    #----------------------------------------------------------------------------
    "Shot_Magic" => [
      [],
      [:change_target, 9, 1],
      [:pose, 3,7,3],
      [:projectile, 150, 8, 0], 
    ],
    #----------------------------------------------------------------------------
    "Maigc_Laser" => [
      [],
      [:slide,-10,0,10,3],
      [:wait,3],
      [:pose, 3,7,3],
      [:projectile, 150, 8, 0], 
      [:pose, 3,7,3],
      [:projectile, 150, 8, 0], 
      [:pose, 3,7,3],
      [:projectile, 150, 8, 0], 
      ],
    #----------------------------------------------------------------------------
    "Chain_Bolt" => [
      [],
      [:slide,-10,0,10,3],
      [:wait,3],
      [:loop,30,"Shot_Magic"],
      ],
   #----------------------------------------------------------------------------
    "Maigc_Blast" => [
      [],
      [:focus, 30],
      [:action,"MagicCast"],
      [:projectile, 221, 200, 0], 
      [:pose, 3,7,200],
      [:wait,10]
      ],
  #----------------------------------------------------------------------------
    "Cast_Pose" => [
      [],
      [:pose,3,6,2],
      [:pose,3,7,2],
      [:pose,3,8,2],
    ],
  #----------------------------------------------------------------------------
     "Second_Wind" => [
    [],
    [:move_to_target, 0, 0, 2, 3],
    [:action,"Cast_Pose"],
    [:projectile, 222,20, 0], 
    [:action,"Cast_Pose"],
    [:projectile, 223,20, 0], 
    [:action,"Cast_Pose"],
    [:projectile, 224,20, 0], 
    [:wait,5],
    
    ],
  #----------------------------------------------------------------------------
  "Kick" => [
    [],
    [:pose,3,7,wait_time], 
    [:target_damage],
  ],
  #----------------------------------------------------------------------------
     "Roundhouse_Kick" => [
    [],
    [:move_to_target, 0, 0, 2, 3],
    [:wait,3],
    [:show_anim],
    [:loop,15,"Kick"],
    [:wait,3],
    
    ],
    #----------------------------------------------------------------------------
     "10_Sec_Flat" => [
    [],
    [:focus, 30],
    [:action,"Move"],
    [:slide,-100,20,120,125],
    [:wait,3],
    [:show_anim],
    [:wait,130],
    [:target_damage],
    ],
     #----------------------------------------------------------------------------
     "Thunder_Rush" => [
      [],
      [:move_to_target, 0, 0, 2, 3],
      [:action,"Cast_Pose"],
      [:action,"Target Damage"],
      [:wait,4],
    ],
    #----------------------------------------------------------------------------
    "Ruby_damage" => [
      [],
      [:pose,3,8,3],
      [:target_damage],
    ],
    #----------------------------------------------------------------------------
     "Ruby_Strike" => [
      [],
      [:pose,3,6,3],
      [:pose,3,7,3],
      [:pose,3,8,3],
      [:show_anim],
      [:loop,5,"Ruby_damage"],
      [:wait,4],
    ],
    #----------------------------------------------------------------------------
    "RR_Combo" => [
      [],
      [:pose,3,0,2],[:pose,3,1,2],[:target_damage],[:pose,3,2,2],
      [:pose,3,5,2],[:pose,3,4,2],[:target_damage],[:pose,3,5,2],

    ],
    #----------------------------------------------------------------------------
     "Fabulous_Combo" => [
      [],
      [:move_to_target, 0, 0, 30, 15],
      [:pose,1,3,10],  [:pose,1,4,10],  [:pose,1,5,10],  
      [:show_anim],
      [:loop,8,"RR_Combo"],
      [:wait,4],
    ],
    #----------------------------------------------------------------------------
     "Gem_Spike" => [
      [],
      [:pose,3,6,3],
      [:pose,3,7,3],
      [:pose,3,8,3],
      [:show_anim],
      [:loop,5,"Ruby_damage"],
      [:pose,3,8,125],
    ],
    #----------------------------------------------------------------------------
     "Makeover" => [
      [],
      [:focus, 30],
      [:move_to_target, 0, 0, 30, 15],
      [:pose,1,3,10],  [:pose,1,4,10],  [:pose,1,5,10],  
      [:show_anim],
      [:screen, :shake,8,10, 210],
      [:wait,250],
      [:target_damage],
      [:wait,3],
    ],
    #----------------------------------------------------------------------------
    "Circle" => [
      [],
      [:pose,3,0,4],
      [:pose,3,1,4],
      [:pose,3,2,4],
    ],
    #----------------------------------------------------------------------------
     "Weee" => [
      [],
      [:sound, "Bow1", 150, 150],
      [:move_to_target, -90, 0,1,1],
      [:wait,3],
      [:move_to_target, 0, 0,40,40],
      [:loop,3,"Circle"],
      [:projectile,231,5,0],
      [:target_damage],
    ],
    #----------------------------------------------------------------------------
     "Party_Cannon" => [
      [],
      [:slide,-45,0,10,2],
      [:pose,3,6,10],
      [:pose,3,8,20],
      [:projectile,232,10,0],
      [:pose,3,7,5],
      [:pose,3,8,100],
      [:target_damage],
    ],
    #----------------------------------------------------------------------------
    "Throw_Cake" => [
      [],
      [:change_target, 9, 1],
      [:pose,3,0,3],
      [:projectile,234,5,0],
      [:pose,3,1,3],
      [:projectile,235,5,0],
      [:pose,3,2,2],
      [:projectile,236,5,0],
      [:change_target, 9, 1],
      [:pose,3,0,3],
      [:projectile,237,5,0],
      [:pose,3,1,3],
      [:projectile,238,5,0],
      [:pose,3,2,2],
      [:projectile,239,5,0],
    ],
    #----------------------------------------------------------------------------
     "Sweet" => [
      [],
      [:slide,0,0,100,1],
      #234~240
      [:loop,5,"Throw_Cake"],
      [:pose,1,3,12],
      [:pose,1,4,12],
      [:pose,1,5,12],
      [:pose,1,9,4],
      [:pose,1,10,4],
      [:pose,1,11,4],
      [:projectile,240,5,0],
      [:wait,5],
      [:target_damage, "a.atk * 10"],
      [:pose,2,1,10],
    ],
    #----------------------------------------------------------------------------
    "Pinkie_Dance" => [
      [],
      [:slide,-13,0,20,1],
      [:pose,2,0,10],
      [:pose,2,1,10],
      [:pose,2,2,10],
      [:slide,-13,0,20,1],
      [:pose,2,3,10],
      [:pose,2,4,10],
      [:pose,2,5,10],
      
    ],
    #----------------------------------------------------------------------------
     "Gypsy_Bard" => [
      [],
      [:focus, 30],
      [:show_anim],
      [:loop,8,"Pinkie_Dance"],
      [:move_to_target,-20, 0, 2, 3],
      [:pose,3,3,5],
      [:target_damage],
    ],
    #----------------------------------------------------------------------------
     "Tangle" => [
      [],
      [:pose,4,3,4],
      [:pose,4,4,4],
      [:pose,4,5,4],
      [:projectile,242,6,0],
      [:pose,3,5,4],
      [:action,"Target Damage"],
      [:pose,3,5,10],
    ],
    #----------------------------------------------------------------------------
     "Punch" => [
      [],      
      [:move_to_target,0, 0,20,1],
      [:pose,3,3,3],
      [:pose,3,4,3],
      [:pose,3,5,10],
      [:pose,3,0,5],
      [:pose,3,1,5],
      [:show_anim],
      [:target_damage],
      [:pose,3,2,20],
    ],
    #----------------------------------------------------------------------------
    "AJ_Stamp" => [
      [],
      [:move_to_target,0, 0,10,30],
      [:wait,1], 
      [:pose,3,5,3],
      [:pose,3,3,3],
      [:pose,3,4,3],
      [:screen, :shake,2,10, 30],
      [:action,"Target Damage"],
    ],
    #----------------------------------------------------------------------------
     "Overwhelm" => [
      [],      
      [:move_to_target,0, 0,30,40],
      [:wait,30],
      [:screen, :shake,2,10, 30],
      [:action,"Target Damage"],
      [:loop,15,"AJ_Stamp"],
    ],
    #----------------------------------------------------------------------------
     "Mallet_Head" => [
      [],      
      [:focus,30],
      [:pose,3,3,10],
      [:pose,3,4,10],
      [:cast,247],
      [:screen, :shake,1,3, 20],
      [:sound, "Applejack - YEEHAW!(longer)", 100, 100],
      [:pose,3,5,60],
      [:move_to_target,0,0,5,10],
      [:wait,3,],
      [:screen, :shake,5,10, 60],
      [:action,"Target Damage"],
      
    ],
    #----------------------------------------------------------------------------
     "Flutter_Attack" => [
      [],      
      [:pose,3,0,20],
      [:move_to_target,10,0,20,3],
      [:wait,20],
      [:pose,3,1,10],
      [:action,"Target Damage"],
      [:action,"E_Move"],
      [:pose,3,2,10],
      [:wait,8],
    ],
    #----------------------------------------------------------------------------
    "Falcon_DMG" => [
      [],
      [:pose,3,8,3],
      [:show_anim]
    ],
    #----------------------------------------------------------------------------
    
     "Falcon" => [
      [],      
      [:pose,3,3,4],
      [:pose,3,4,4],
      [:cast,207],
      [:pose,3,5,90],
      [:wait,90],
      [:action,"Move"],
      [:pose,3,6,4],
      [:pose,3,7,4],
      [:pose,3,8,4],
      [:show_anim,249],
      [:wait,3],
      [:loop,16,"Falcon_DMG"],
      [:target_damage]
    ],
    
    #----------------------------------------------------------------------------
    
     "Bear" => [
      [],      
      [:pose,3,6,4],
      [:pose,3,7,4],
      [:pose,3,8,4],
      [:show_anim,250],
      [:wait,5],
      [:action,"Target Damage"]
    ],
    #----------------------------------------------------------------------------
     "Stare" => [
      [],
      [:move_to_target,50,-30,20,3],
      [:pose,2,0,4],
      [:pose,2,1,4],
      [:pose,2,2,4],
      [:show_anim,251],
      [:focus,30],
     #[:com_event,16],
      [:screen, :shake,1,8, 300],
      [:pose,2,2,300],
      #[:com_event,17],
      [:action,"Target Damage"]
    ],
    #----------------------------------------------------------------------------
     "Sword_Dash" => [
      [],
      [:move_to_target,10,1,1,3],
      [:action,"Target Damage"],
      [:show_anim,260],
      [:change_target, 9, 1],
      [:pose,4,0,2],
      [:move_to_target,-10,1,1,3],
      [:wait,3],
      
      [:move_to_target,10,1,1,3],
      [:action,"Target Damage"],
      [:show_anim,261],
      [:change_target, 9, 1],
      [:move_to_target,-10,1,1,3],
      [:pose,4,1,2],
      [:wait,3],
      
      [:move_to_target,10,1,1,3],
      [:action,"Target Damage"],
      [:show_anim,262],
      [:change_target, 9, 1],
      [:move_to_target,-10,1,1,3],
      [:pose,4,2,2],
      [:wait,3],
      
      [:move_to_target,10,1,1,3],
      [:action,"Target Damage"],
      [:show_anim,263],
      [:move_to_target,-10,1,1,3],
      [:pose,4,2,2],
      [:wait,3],
      
      
    ],

    #----------------------------------------------------------------------------
     "Wild_Dash" => [
      [],
      [:move_to_target,20,-20,1,3],
      [:wait,3],
      [:show_anim],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 30,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -30,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45,27,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -27,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 24,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -24,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 21,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -21,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 18,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -18,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 15,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -15,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 12,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -12,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 9,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -9,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 6,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -6,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
      [:target_damage],
      [:pose,4,0,1],
      [:slide, -45, 3,1, 10],  
      [:pose,4,4,1],
      [:slide, 45, -3,  1, -10],  
      [:pose,4,5,1],
      [:wait,1],
      
    ],
    #----------------------------------------------------------------------------
    
    "Thunder_Storm" => [
      [],
      [:cutin_start,"Actor1_Ougi",100,0,0],
      [:visible, false],
      [:focus,5],
      [:action,"Target Damage"],
      [:wait,50],
      
    ],
    #----------------------------------------------------------------------------
    "Shot_Arrowshower" => [
      [],
      [:script, "self.remove_state(48)"],
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
    ],
    #----------------------------------------------------------------------------
    "Arrow_Rain" => [
      [],
      [:script, "self.remove_state(48)"],
      [:icon,"Clear"],
      [:visible, false],
      [:proj_setup, {
        :start_pos => [0,-150], 
        :anim_end => :default,
        :flash => [false,true],
      }],
      [:wait,5],
      [:show_anim,328],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      [:change_target, 9, 1],
      [:projectile,272,3,0],
      [:wait,3],
      
      
      [:visible, true],
      [:wait,5],
    ],
    #------------------------------------------------------------------------
    "flame_blast" => [
      [],
      [:move_to_target, 80, 0, 5, 10],
      [:wait,10],
      [:cast, 273],
      [:wait,6],
      [:action,"Target Damage"],
      [:wait,20],
    ],
    #------------------------------------------------------------------------
    "Fireball" => [
      [],
      [:action,"Casting_Pose"],
      [:projectile,276,6,0],
      [:wait,20],
    ],
    #------------------------------------------------------------------------
    "Inferno" => [
      [],
      [:action,"Target Damage"],
      [:wait,20],
    ],
    #------------------------------------------------------------------------
    "Blizzard" => [
      [],
      [:action,"Target Damage"],
      [:wait,20],
    ],
    #------------------------------------------------------------------------
    "Earthquake" => [
      [],
      [:action,"Target Damage"],
      [:screen, :shake,8,12, 25],
      [:wait,20],
    ],
    #------------------------------------------------------------------------
    "Stonefist" => [
      [],
      [:projectile,279,6,0],
      [:wait,3],
      [:screen, :shake,4,5,5],
      [:wait,20],
    ],
    #------------------------------------------------------------------------
    "Lighting_Bolt" => [
      [],
      [:loop, 1, "K-Cast"],
      [:wait,3],
      [:projectile,286,12,0],
    ],
    #------------------------------------------------------------------------
    "Tempest" => [
      [],
      [:action,"Target Damage"],
      [:wait,20],
    ],
    #------------------------------------------------------------------------
    "Shock" => [
      [],
      [:move_to_target, 80, 0, 5, 10],
      [:wait,10],
      [:cast, 288],
      [:wait,6],
      [:action,"Target Damage"],
      [:wait,20],
    ],
    #------------------------------------------------------------------------
    "Chain_Lighting_Bolt" => [
      [],
      [:change_target,7],
      [:script,"$chain_lighting_dmg *= 0.825"],
      [:force_hit],
      [:boomerang],
      [:proj_afimage],
      [:proj_setup,{
        :start => :last_target,
      }],
      
      [:change_target,4],
      [:projectile,293,8,0],
      [:wait,3],
    ],
    
    "Chain_Lighting" => [
      [],
      [:cast, 139],
      [:loop, 3, "K-Cast"],
      [:wait,3],
      [:script,"$chain_lighting_dmg = 1"],
      
      [:proj_afimage],
      [:projectile,286,30,0],
      [:wait,30],
      
      [:proj_setup,{
        :start => :last_target,
      }],
      
      [:script,"$chain_lighting_dmg *= 0.825"],
      [:change_target,4],
      [:projectile,293,10,0],
      [:wait,10],
      
      [:loop,10,"Chain_Lighting_Bolt"],
      
    ],
    
    "Chain_Lighting(E)" => [
      [],
      [:cast, 139],
      [:loop, 3, "K-Cast"],
      [:wait,3],
      [:script,"$chain_lighting_dmg = self.mat * 8"],
      
      [:proj_afimage],
      [:projectile,295,30,0],
      [:wait,30],
      
      [:proj_setup,{
        :start => :last_target,
      }],
      
      [:change_target,4],
      [:projectile,293,10,0],
      [:wait,10],
      
      [:loop,10,"Chain_Lighting_Bolt"],
      
    ],
    
    "Spell_Smite" => [
      [],
      [:cast, 139],
      [:loop, 3, "K-Cast"],
      [:wait,3],
      [:show_anim],
      [:wait,10],
      [:target_damage],
      
    ],
    #------------------------------------------------------------------------
    "Dimagic_Beam" => [
      [],
      [:slide,-10,0,10,3],
      [:wait,3],
      [:pose, 3,7,3],
      [:projectile, 302, 20, 0], 
      [:projectile, 301, 20, 0], 
    ],
    #------------------------------------------------------------------------
    "Shield_Pummel" => [
      [],
      [:move_to_target, 0, 0, 2, 10],
      [:target_damage,"v = a.atk * 3 - b.def * 2; v *= 1.2 if a.skill_learned?(595); v"],
      
      [:if,"self.actor?",
        [
          [:show_anim,303],
        ],
        [
          [:show_anim,303,true],
        ]
      ],
      [:wait,25],
      [:pose,4,0,4],
      [:pose,4,1,4],
      [:pose,4,2,4],
      [:target_damage,"v = a.atk * 4 - b.def * 2.5; v *= 1.2 if a.skill_learned?(595); v"],
      [:if,"self.actor?",
        [
          [:show_anim,307],
        ],
        [
          [:show_anim,307,true],
        ]
      ],
      [:wait,3],
    ],
    #------------------------------------------------------------------------
    "Overpower" => [
      [],
      [:move_to_target, 0, 0, 2, 10],
      [:target_damage,"v=a.atk * 3.8 - b.def * 2.1;  v *= 1.2 if a.skill_learned?(595); v"],
      [:if,"self.actor?",
        [
          [:show_anim,303],
        ],
        [
          [:show_anim,303,true],
        ]
      ],
      [:screen, :shake,4,5,5],
      [:wait,5],
      [:pose,4,0,4],
      [:pose,4,1,4],
      [:pose,4,2,4],
      [:move_to_target, 0, 0, 2, 10],
      [:target_damage,"v=a.atk * 3.8 - b.def * 2.1;  v *= 1.2 if a.skill_learned?(595); v"],
      
      [:if,"self.actor?",
        [
          [:show_anim,303],
        ],
        [
          [:show_anim,303,true],
        ]
      ],
      
      [:screen, :shake,4,5, 5],
      [:wait,12],
      [:pose,4,0,4],
      [:pose,4,1,4],
      [:pose,4,2,4],
      [:force_critical],
      [:move_to_target, 0, 0, 2, 10],
      [:target_damage,"b.knock_down if b.saving_throw <= a.difficulty_class('str',3); v=a.atk * 4 - b.def * 2; v *= 1.2 if a.skill_learned?(595); v"],
      [:if,"self.actor?",
        [
          [:show_anim,303],
        ],
        [
          [:show_anim,303,true],
        ]
      ],
      [:screen, :shake,8,10, 10],
      [:wait,3],
    ],
    #------------------------------------------------------------------------
    "Assault" => [
      [],
      [:move_to_target, 0, 0, 2, 10],
      [:target_damage,"v= a.atk * 3 - b.def * 1.2; v *= 1.2 if a.skill_learned?(595); v"],
      [:if,"self.actor?",
        [
          [:show_anim,304],
        ],
        [
          [:show_anim,304,true],
        ]
      ],
      [:wait,5],
      [:pose,4,0,4],
      [:pose,4,1,4],
      [:pose,4,2,4],
      
      [:move_to_target, 0, 0, 2, 10],
      [:target_damage,"v=a.atk * 3 - b.def * 1.2; v *= 1.2 if a.skill_learned?(595); v"],
      [:if,"self.actor?",
        [
          [:show_anim,305],
        ],
        [
          [:show_anim,305,true],
        ]
      ],
      [:wait,5],
      [:pose,4,0,4],
      [:pose,4,1,4],
      [:pose,4,2,4],
      
      [:move_to_target, 0, 0, 2, 10],
      [:target_damage,"v=a.atk * 3 - b.def * 1.2; v *= 1.2 if a.skill_learned?(595); v"],
      [:if,"self.actor?",
        [
          [:show_anim,306],
        ],
        [
          [:show_anim,306,true],
        ]
      ],
      [:wait,5],
      [:pose,4,0,4],
      [:pose,4,1,4],
      [:pose,4,2,4],
      
      [:move_to_target, 0, 0, 2, 10],
      [:target_damage,"v=a.atk * 4 - b.def * 1.8; v *= 1.2 if a.skill_learned?(595); v"],
      [:if,"self.actor?",
        [
          [:show_anim,307],
        ],
        [
          [:show_anim,307,true],
        ]
      ],
      [:wait,8],
      
      
    ],
    #------------------------------------------------------------------------
    "Riposte" => [
      [],
      [:script,"$base_damage = calc_dual_wield_base_damage"],
      [:move_to_target, 0, 0, 2, 10],
      [:action,"Attack_Pose"],
      [:if,"self.actor?",
        [
          [:show_anim,311],
        ],
        [
          [:show_anim,311,true],
        ]
      ],
      [:target_damage,"b.add_state(8) if a.difficulty_class > b.saving_throw; ($base_damage - b.def * 1.8) * 0.6"],
      [:show_anim],
      [:wait,4],
      [:slide, -30, 0, 8, 4],
      [:action,"Attack_Pose_reversed"],
      [:if,"self.actor?",
        [
          [:show_anim,312],
        ],
        [
          [:show_anim,312,true],
        ]
      ],
      [:target_damage],
      [:wait,4],
    ],
    #------------------------------------------------------------------------
    "Cripple" => [
      [],
      [:move_to_target, 0, 0, 2, 5],
      [:script,"$base_damage = calc_dual_wield_base_damage"],
      [:action,"Attack_Pose"],
      [:force_critical],
      [:wait,3],
      [:if,"self.actor?",
        [
          [:show_anim,313],
        ],
        [
          [:show_anim,313,true],
        ]
      ],
      [:target_damage,"($base_damage - b.def * 1.5) * 0.5"],
      [:if,"self.actor?",
        [
          [:show_anim,309],
        ],
        [
          [:show_anim,309,true],
        ]
      ],
      [:wait,10],
    ],
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    "Punisher" => [
      [],
      [:script,"$base_damage = calc_dual_wield_base_damage"],
      [:move_to_target, 0, 0, 2, 10],
      [:if,"self.actor?",
        [
          [:show_anim,314],
        ],
        [
          [:show_anim,314,true],
        ]
      ],
      [:action,"Attack_Pose"],
      
      [:target_damage,"($base_damage * 1.5 - b.def * 2) * 0.5"],
      [:if,"self.actor?",
        [
          [:show_anim,309],
        ],
        [
          [:show_anim,309,true],
        ]
      ],
      [:wait,2],
      
      [:action,"Attack_Pose"],
      [:if,"self.actor?",
        [
          [:show_anim,315],
        ],
        [
          [:show_anim,315,true],
        ]
      ],
      [:target_damage,"($base_damage * 1.5 - b.def * 2) * 0.5"],
      [:if,"self.actor?",
        [
          [:show_anim,309],
        ],
        [
          [:show_anim,309,true],
        ]
      ],
      
      [:action,"Attack_Pose"],
      [:if,"self.actor?",
        [
          [:show_anim,316],
        ],
        [
          [:show_anim,316,true],
        ]
      ],
      [:force_critical],
      [:wait,2],
      [:target_damage,"$base_damage * 0.8"],
      [:if,"self.actor?",
        [
          [:show_anim,309],
        ],
        [
          [:show_anim,309,true],
        ]
      ],
      [:wait,3],
    ],
    #--------------------------------------------------------------------------
    "Dual-Sweep" => [
      [],
      [:move_to_target, 0, 0, 2, 10],
      [:script,"$base_damage = calc_dual_wield_base_damage"],
      
      [:action,"Attack_Pose"],
      [:if,"self.actor?",
        [
          [:show_anim,nil],
        ],
        [
          [:show_anim,nil,true],
        ]
      ],
      [:wait,3],
      [:target_damage,"($base_damage * 1.2 - b.def) * 0.8"],
      [:show_anim,309],
      [:wait,5],
      
      
    ],
    #------------------------------------------------------------------------
    #--------------------------------------------------------------------------
    "Flurry" => [
      [],
      [:script,"$base_damage = calc_dual_wield_base_damage"],
      
      [:move_to_target, 0, 0, 2, 10],
      [:wait,2],
      [:action,"Attack_Pose"],
      [:if,"self.actor?",
        [
          [:show_anim,nil],
        ],
        [
          [:show_anim,nil,true],
        ]
      ],
      [:show_anim,309],
      [:target_damage,"($base_damage - b.def * 2.0) * 0.4"],
      
      [:action,"Attack_Pose"],
      [:show_anim,309],
      [:target_damage,"($base_damage - b.def * 2.0) * 0.4"],
      [:wait,18],
      [:action,"Attack_Pose"],
      [:show_anim,309],
      [:target_damage,"($base_damage - b.def * 2.0) * 0.4"],
      [:wait,3],
    ],
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    "Whirlwind" => [
      [],
      [:move_to_target, 0, 0, 2, 10],
      [:script,"$base_damage = calc_dual_wield_base_damage"],
      
      [:if,"self.actor?",
        [
          [:show_anim,nil],
        ],
        [
          [:show_anim,nil,true],
        ]
      ],
      [:action,"Attack_Pose"],
      [:show_anim,309],
      [:target_damage,"$base_damage = $base_damage - b.def; $base_damage"],
      [:wait,3],
      
      [:action,"Attack_Pose"],
      [:show_anim,309],
      [:target_damage,"$base_damage"],
      [:wait,4],
      
      [:action,"Attack_Pose"],
      [:show_anim,309],
      [:target_damage,"$base_damage"],
      [:wait,3],
      
      [:action,"Attack_Pose"],
      [:show_anim,309],
      [:target_damage,"$base_damage"],
      [:wait,4],
      
      [:action,"Attack_Pose"],
      [:show_anim,309],
      [:target_damage,"$base_damage"],
      [:wait,3],
      
      [:action,"Attack_Pose"],
      [:show_anim,309],
      [:target_damage,"$base_damage * 1.2"],
      [:wait,3],
    ],
    #------------------------------------------------------------------------
    "Twin_Strike" =>[
      [],
      [:script,"$base_damage = calc_dual_wield_base_damage"],
      [:move_to_target, 0, 0, 2, 10],
      
      [:action,"Attack_Pose"],
      [:if,"self.actor?",
        [
          [:show_anim,320],
        ],
        [
          [:show_anim,320,true],
        ]
      ],
      [:wait,1],
      [:force_critical],
      [:if,"skill_learned?(614) || !self.actor?",
        [
          [:target_damage,"b.add_state(226) if a.difficulty_class('str',3) > b.saving_throw('con'); $base_damage * 0.4"],
        ],
        [
          [:target_damage,"$base_damage * 0.4"],
        ]
      ],
      [:show_anim,309],
      
      [:wait,4],
      [:if,"self.actor?",
        [
          [:show_anim,321],
        ],
        [
          [:show_anim,321,true],
        ]
      ],
      [:force_critical],
      
      [:if,"skill_learned?(614)",
        [
          [:target_damage,"b.add_state(226) if a.difficulty_class('str',3) > b.saving_throw('con'); $base_damage * 0.4"],
        ],
        [
          [:target_damage,"$base_damage * 0.4"],
        ]
      ],
      [:show_anim,309],
      [:wait,3],
    ],
    #--------------------------------------------------------------------------#------------------------------------------------------------------------
    "Unending_Flurry" =>[
      [],
      #most copied from dual-wield
      [:script,"$base_damage = calc_dual_wield_base_damage"],
      [:move_to_target, 0, 0, 2, 10],
      [:action,"Attack_Pose"],
      [:if,"self.actor?",
        [
          [:show_anim,304],
        ],
        [
          [:show_anim,304,true],
        ]
      ],
      [:target_damage,"$base_damage - b.def * 2"],
      #--------------------------------------------------
      # calc off-hamd damage
      #
      # Dual Weapon Training
      #--------------------------------------------------
      [:if,"self.skill_learned?(601)",  
        [ #true
          [:script,"$base_damage *= 0.8"],
        ],
        [ #false
          [:script,"$base_damage *= 0.6"],
        ]
      ],
      #--------------------------------------------------
      #   Dual Weapon Finesse
      #--------------------------------------------------
      [:if,"self.skill_learned?(602)", 
        [ #true
          [:script,"$base_damage *= 1.2"],
        ],
        # false: do nothing
      ],
      #--------------------------------------------------
      #   Dual Weapon Mastery
      #--------------------------------------------------
      [:if,"self.skill_learned?(603)",  
        [ #true
          [:script,"$base_damage *= 1.3"],
        ],
        # false: do nothing
      ],
      #--------------------------------------------------
      #   Dual Striking
      #--------------------------------------------------
      [:if,"self.state?(228)",
        [ #true
          [:script,"$base_damage *= 1.5"],
        ],
        # false
        [
          [:action,"Attack_Pose"],
        ],
      ],
      #--------------------------------------------------
      [:if,"self.actor?",
        [
          [:show_anim,305],
        ],
        [
          [:show_anim,305,true],
        ]
      ],
      [:if,"self.skill_learned?(603)",  #Dual Weapon Mastery
        [ #true
          [:target_damage,"b.add_state(226) if a.difficulty_class('str',3) > b.saving_throw('con'); $base_damage - b.def * 2.3"]
        ],
        # false:
        [
          [:target_damage,"$base_damage - b.def * 2.3"]
        ],
      ],
      #--------------------------------------------------
      #   Dual Striking wair for chain skill
      #--------------------------------------------------
      [:if,"self.state?(228)",
        [ #true
          [:wait,8],
        ],
        # false: do nothing
      ],
  ],
  #--------------------------------------------------------------------------
  "Pommel_Strike" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:if,"self.actor?",
        [
          [:show_anim,322],
        ],
        [
          [:show_anim,322,true],
        ]
      ],
    [:target_damage],
    [:wait,3],
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
    [:wait,3],
  ],
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  "Critical_Strike" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:if,"self.actor?",
        [
          [:show_anim,323],
        ],
        [
          [:show_anim,323,true],
        ]
      ],
    [:force_critical],
    [:target_damage,"$base_damage = a.atk * 15 - b.def * 3.2; b.actor? ? $base_damage : !b.is_minon? ? $base_damage : b.mhp*0.2 >= b.hp ? b.mhp : $base_damage"],
    [:wait,3],
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
    [:wait,3],
  ],
  #-----------------------------------------------------------------------------
  "Sunder_Arms" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:if,"self.actor?",
        [
          [:show_anim,324],
        ],
        [
          [:show_anim,324,true],
        ]
      ],
    [:action,"Target Damage"],
    [:wait,3],
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
  ],
  #--------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  "Sunder_Armor" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:if,"self.actor?",
        [
          [:show_anim,325],
        ],
        [
          [:show_anim,325,true],
        ]
      ],
    [:action,"Target Damage"],
    [:wait,3],
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
    
  ],
  #--------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  "Mighty_Blow" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:if,"self.actor?",
        [
          [:show_anim,326],
        ],
        [
          [:show_anim,326,true],
        ]
      ],
    [:target_damage,"b.add_state(8) if (a.skill_learned?(620) && a.difficulty_class('str') > b.saving_throw('str')); b.add_state(248) if a.difficulty_class('str',2) > b.saving_throw('str'); a.atk * 6 - b.def * 3"],
    [:wait,3],
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
  ],
  #--------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  "Two_Hoofed_Sweep" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:if,"self.actor?",
        [
          [:cast,327],
        ],
        [
          [:cast,327,true],
        ]
      ],
    [:cast,309],
    [:if,"self.actor?",
        [
          [:show_anim,nil],
        ],
        [
          [:show_anim,nil,true],
        ]
      ],
    [:target_damage,"b.knock_down if a.difficulty_class('str',2) > b.saving_throw('str'); a.atk * 5 - b.def * 4"],
    [:wait,3],
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
    
  ],
  #--------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  "Sweeping_Strike" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:if,"self.actor?",
        [
          [:cast,329],
        ],
        [
          [:cast,329,true],
        ]
    ],
    
    [:screen, :shake,4,5, 5],
    [:force_critical],
    
    [:if,"self.actor?",
      [
        [:show_anim,nil],
      ],
      [
        [:show_anim,nil,true],
      ]
    ],
    [:target_damage,"(a.atk * 6 - b.def * 3) * 1.5"],
    [:wait,3],
    
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
  ],
  #--------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  "Two-Hoofed_Impact" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:cast,330],
    [:screen, :shake,4,5, 5],
    [:show_anim],
    [:target_damage],
    [:wait,3],
    
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
  ],
  #-----#-----------------------------------------------------------------------------
  "Onslaught" => [
    [],
    [:move_to_target, 10, 0, 2, 10],
    [:action,"Attack_Pose"],
    
    [:if,"self.actor?",
        [
          [:cast,331],
        ],
        [
          [:cast,331,true],
        ]
      ],
    [:screen, :shake,4,5, 5],
    
    [:show_anim],
    [:target_damage],
    [:slide, -8, 0, 3, 5],
    
    [:action,"Attack_Pose"],
    [:show_anim],
    [:target_damage],
    [:slide, -8, 0, 3, 5],
    [:screen, :shake,4,5, 5],
    
    [:action,"Attack_Pose"],
    [:show_anim],
    [:target_damage],
    [:screen, :shake,4,5, 5],
    [:wait,3],
    
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
  ],
  #-----------------------------------------------------------------------
  "Reaving_Storm" => [
    [],
    [:move_to_target, 0, 0, 2, 5],
    
    [:if,"self.mp > 60",
        [
          [:script,"self.mp -= 60"],
          [:action,"Attack_Pose"],    
          [:cast,343],
          [:screen, :shake,4,5, 5],
          [:target_damage],
          [:show_anim,309],
          [:wait,5],
        ],
    ],
    
    [:if,"self.mp > 80",
        [
          [:script,"self.mp -= 80"],
          [:action,"Attack_Pose"],    
          [:cast,344],
          [:screen, :shake,4,5, 5],
          [:target_damage],
          [:show_anim,309],
          [:wait,5],
        ],
    ],
    
    [:if,"self.mp > 80",
        [
          [:script,"self.mp -= 80"],
          [:action,"Attack_Pose"],    
          [:cast,345],
          [:screen, :shake,4,5, 5],
          [:target_damage],
          [:show_anim,309],
          [:wait,5],
        ],
    ],
    
    [:if,"self.mp > 80",
        [
          [:script,"self.mp -= 80"],
          [:action,"Attack_Pose"],    
          [:cast,346],
          [:screen, :shake,4,5, 5],
          [:target_damage],
          [:show_anim,309],
          [:wait,5],
        ],
    ],
    
    [:if,"self.mp > 80",
        [
          [:script,"self.mp -= 80"],
          [:action,"Attack_Pose"],
          [:force_critical],
          [:cast,347],
          [:screen, :shake,4,5, 5],
          [:target_damage],
          [:show_anim,309],
          [:wait,5],
        ],
    ],
    
    
    [:script,"self.mp += 15 if self.skill_learned?(628)"],
  ],
  #--------------------------------------------------------------------------
  "Flicker_Attack" =>[
    [:move_to_target,10,1,1,3],
    [:action,"Target Damage"],
    [:show_anim],
    [:change_target, 9, 1],
    [:wait,1],
  ],
  
  #----------------------------------------------------------------------------
     "Flicker" => [
      [],
      [:screen, :tone, Tone.new(0, 0, 0,0), 1],
      [:focus,30],
      [:wait,5],
      
      [:visible,false],
      
      [:loop,33,"Flicker_Attack"],
      
      [:visible,true],
      
    ],
  #----------------------------------------------------------------------------
  "Heart_Seeker" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    
    [:if,"self.actor?",
      [
        [:show_anim,nil],
      ],
      [
        [:show_anim,nil,true],
      ]
    ],
    [:wait,8],
    [:target_damage,"b.enemy? ? b.minon? ? (b.mhp * 1.2) : (a.atk * 6 + a.agi * 4 - b.def * 3) : (rand() > 0.4) ? (a.atk * 6 + a.agi * 4 - b.def * 3) : b.mhp * 1.2"],
    [:wait,5],
  ],
  #-----------------------------------------------------------------------------
  "Normal_Smash" => [
    [],
    [:move_to_target, 0, 0, 2, 10],
    [:action,"Attack_Pose"],
    [:show_anim],
    [:script,"$base_damage = self.atk * 6"],
    
    [:if,"self.skill_learned?(620)",  # stunning blow
      [ #true
        [:target_damage,"$base_damage += b.def * 2 if a.skill_learned?(623); b.add_state(250) if a.skill_learned?(625);  b.add_state(8) if a.difficulty_class('str',-2) > b.saving_throw('str'); $base_damage - b.def * 2"],
      ],
      #false
      [
        [:target_damage,"$base_damage += b.def * 2 if a.skill_learned?(623); b.add_state(250) if a.skill_learned?(625);$base_damage - b.def * 2"],
      ]
    ],
    
    [:wait,10],
  ],
  #--------------------------------------------------------------------------
  "Sunfire_Hit" => [
    [],
    [:wait,8],
    [:force_hit],
    [:target_damage],
  ],
  #-----------------------------------------------------------------------------
  "Sunfire" => [
    [],
    [:focus,30],
    [:cast, 139],
    [:loop, 3, "K-Cast"],
    [:wait,3],
    
    [:if,"self.enemy?",
      [:show_anim,338],
      [:show_anim,366],
    ],
    
    [:wait,90],
    
    [:loop,10,"Sunfire_Hit"],
    [:wait,55],
    
    [:force_hit],
    [:force_critical],
    [:target_damage,"a.mat * 5"],
    [:wait,100],
  ],
  #--------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  "Armageddon" => [
    [],
    [:focus,30],
    [:visible,false],
    
    [:show_anim,340],
    
    [:wait,90],
    
    [:loop,25,"Sunfire_Hit"],
    
    [:target_damage,"b.add_state(1); 9223372036854775807"],
    [:wait,100],
    [:visible,true],
  ],
  #--------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  "Minor_Drain" => [
    [],
    [:action,"Casting_Spell"],
    [:wait,18],
    [:proj_setup,{
        :reverse => true,
        :damage => 0,
        :anim_end => 41,
        :anim_hit => true,
      }],
    [:projectile, 364,10, 0], 
  ],
  #-----------------------------------------------------------------------------
  "Energy_Drain" => [
    [],
    [:action,"Casting_Spell"],
    [:wait,18],
    [:proj_setup,{
        :reverse => true,
        :damage => 0,
        :anim_end => 41,
        :anim_hit => true,
      }],
    [:projectile, 350,10, 0], 
  ],
  #--------------------------------------------------------------------------
  "venom_explode" => [
    [],
    [:cast,354],
    [:if, "$venom_explode_damage.nil?",
      [:target_damage,"a.mat * 3"],
      [:target_damage,"b.add_state(269) if $venom_infect; b.poison_damage.push([660,$venom_ori_caster.mat,$venom_ori_caster]) if $venom_infect; $venom_explode_damage"],
    ],
    [:script,"die"],
    [:wait,5],
  ],
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  "Animate_Dead" => [
    [],

    [:cast, 139],
    [:loop, 3, "K-Cast"],
    [:wait,3],
    
     [:if,"!$force_target_enemy.nil?",
      [ #true
        [:projectile,169,5,0],
        [:show_anim],
      ],
      #false
      [
        
      ]
    ],
    

    [:wait,10],
  ],
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  "Mind_Blast" => [
    [],
    [:action,"Casting_Spell"],
    [:wait,5],
    [:screen, :shake,8,10, 10],
    [:show_anim,358],
    [:target_damage],
    [:wait,10],
  ],
  #--------------------------------------------------------------------------
  "Shockwave" => [
    [],
    [:cast,362],
    [:wait,3],
    [:target_damage],
    [:screen, :shake,24,30, 30],
    [:wait,40],
  ],
  #--------------------------------------------------------------------------
  "Storm_Century" => [
    [],
    [:focus,10],
    [:wait,10],
    [:action,"Target Damage"],
    [:show_anim],
    [:screen, :shake, 16 ,20, 20],
    [:wait,50],
  ],
  #--------------------------------------------------------------------------
  "Glyph_Paralysis" => [
    [],
    [:action,"Casting_Spell"],
    [:target_damage,"if a.opposite?(b) && a.difficulty_class('int') >= b.saving_throw('con') then b.add_state(7); else; b.add_state(285) end"],
  ],
  
  #------------------------------
  }
  Icons.merge!(Staff_Icons)
  AnimLoop.merge!(Moves)
  
end

class Game_Battler < Game_BattlerBase

  #==============================================================================
  #   Calculate Dual wield base damage
  #==============================================================================
  def calc_dual_wield_base_damage
    v = (self.atk*1.2 + self.agi*1.8 * (self.agi.to_f / 500 + 0.5)).to_i 
    prng = $game_system.make_rand
    
    if self.skill_learned?(603) || !self.actor?
      v *= (1 + (prng.rand(-10..20) * 0.01)).to_f
    else
      v *= (1 + (prng.rand(-25..15) * 0.01)).to_f
    end
    
    v *= 0.75
    v *= 1.2 if self.state?(228) # Dual Striking
    v *= 1.2 if self.enemy?
    
    return v.to_i
  end
end