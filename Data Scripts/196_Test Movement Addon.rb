module TSBS
  
  TesMove = {  
  
  "Summon_Grenade" => [
  [],
  #[:change_skill, 41],
  #[:pose, 2, 2, 30],      
  #[:pose, 3, 1, 5],       
  #[:pose, 3, 2, 5],       
  #[:sound, "Evasion1", 100, 100],
  #[:proj_afimage],
  #[:projectile, 0, 30, 15, 211, 15],  
  #[:pose, 3, 8, 30],      
  [:wait, 10000],            
  ],
  
  "En_attack" => [
  [],
  [:action, "Target Damage"],
  [:wait, 60],
  ],
  
  "Entangle" => [
  [true],
  [:pose, 1, 7, 15],
  [:pose, 1, 8, 15],
  ],
  
  }
  
  
  AnimLoop.merge!(TesMove)
end