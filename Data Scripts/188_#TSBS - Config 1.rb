# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.4ob1 (Open Beta)
# Language : English
# Translated by : Skourpy
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact :
#------------------------------------------------------------------------------
# *> http://www.rpgmakerid.com
# *> http://www.rpgmakervxace.net
# *> http://theolized.blogspot.com
#==============================================================================
# Last updated : 2014.10.21
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5b
# >> Basic Functions 
# >> Movement    
# >> Core Result
# >> Core Fade
# >> Clone Image
# >> Rotate Image
# >> Smooth Movement
# =============================================================================
# Terms of Use :
# -----------------------------------------------------------------------------
# Credit me, TheoAllen. You are free to edit this script by your own. As long
# as you don't claim it yours. For commercial purpose, don't forget to give me
# a free copy of the game.
# =============================================================================
module TSBS 
  # ===========================================================================
    MaxRow = 4
    MaxCol = 3
  # ---------------------------------------------------------------------------
  # Setting the ratio size of the sprite
  # MaxRow for row to down
  # MaxCol for side column /*note: like a frames */
  #
  # so if you input MaxRow = 4 and MaxCol = 3 then the ratio size of your 
  # spriteset must be 3 x 4
  # ===========================================================================
    
  # ===========================================================================
    Enemy_Default_Flip = false
  # ---------------------------------------------------------------------------
  # Basically enemy sprite is facing left. but when battle scene it must facing 
  # right. to avoid some glitch, you can set the value to true /*mirror*/
  # ===========================================================================
    
  # ===========================================================================
    ActorPos = [ # <--- don't edit this
  # ---------------------------------------------------------------------------
      [420,220],
      [435,235],
      [450,250],
      [465,265],
      [480,280],
      [495,295],
      
    # add more actor positions here
    ] # <-- don't edit this
  # ---------------------------------------------------------------------------
  # actor position in [x,y] coordinate. maximum battle members is depends at
  # how much you input the actor positions.  
  # ===========================================================================
  
  # ===========================================================================
    TotalHit_Vocab = "Total Hit"            # Info 1
    TotalHit_Color = Color.new(230,230,50)  # Info 2
    TotalHit_Pos   = [[51,10],[110,66]]     # Info 3
    TotalHit_Size  = 24                     # Info 4
  # ---------------------------------------------------------------------------
  # this setting for showing the hit counter. for more information see the
  # description below :
  #
  # Info 1 :
  # showing the total hit text
  # 
  # Info 2 :
  # for the text color, fill it with this format :
  # Color.new(red, green, blue). maximum value is 255
  #
  # Info 3 : 
  # position of total hit text, to set the position, follow the format below :
  # the coordinate is saved in 'nested array' where the first [x,y] is for the
  # text coordinate, and the second [x,y] is for numeric coordinate.
  # ===========================================================================
  
  # ===========================================================================
    TotalDamage_Vocab = "Damage"                # Info 1
    TotalDamage_Color = Color.new(255,150,150)  # Info 2
    TotalDamage_Pos   = [[75,10],[110,90]]      # Info 3
    TotalDamage_Size  = 24                      # Info 4
  # ---------------------------------------------------------------------------
  # this setting for showing the damage counter. for more information see the
  # description below :
  #
  # Info 1 :
  # showing the total damage text
  # 
  # Info 2 :
  # for the text color, fill it with this format :
  # Color.new(red, green, blue). maximum value is 255
  #
  # Info 3 : 
  # position of total hit text, to set the position, follow the format below :
  # the coordinate is saved in 'nested array' where the first [x,y] is for the
  # text coordinate, and the second [x,y] is for numeric coordinate.
  #
  # Well, same as Total Hit setting :v
  # ===========================================================================
  
  # ===========================================================================
    Critical_Rate = 0.25
  # ---------------------------------------------------------------------------
  # this rate is to specify an actor in critical state, 0.25 which means
  # if HP below 25% the actor is on critical state.
  # ===========================================================================
  
  # ===========================================================================
    Focus_BGColor = Color.new(0,0,0,128)
  # ---------------------------------------------------------------------------
  # Default color for :focus mode at action sequence. fill it with format below
  # --> Color.new(red, green, blue, alpha)
  # maximum value is 255
  # ===========================================================================
  
  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #                           Others Setting
  # ---------------------------------------------------------------------------
  
  # ===========================================================================
    CounterAttack = "Counterattacked!"
  # showing text "Counterattacked!" if counter attacked.
  
    Magic_Reflect = "Magic Reflected!"
  # showing text "Magic Reflected!" if some spell is reflected
  
    Covered = "Covered!"
  # showing text "Covered!" if a battler is being substitued
  
    UseShadow = true
  # Will battler use shadow? Set it to true / false. Default is true
  
    KeepCountingDamage = true
  # Keep counting damage even when the battler is dead (recommended : true)
  
    AutoImmortal = true
  # Tag all battlers as immortal when performing action sequence. Recommended
  # to set it to true if you're using YEA Battle Engine
  
    Looping_Background = true
  # Set background image as looping background. Recommended to set this to true
    
    PlaySystemSound = true
  # When target get hit by skill / item, it will automatically play sound. e.g,
  # when target evades the attack, then system will play evasion from the
  # system database.
  
    UseDamageCounter = true
  # Display the damage counter?

    Reflect_Guard = 121
  # Default Animation for target if target reflecting magic
  
    TimedHit_Anim = 59
  # Animation ID for timed-hit.
  # ===========================================================================
  
end
# =============================================================================
#
#                             END OF GENERAL CONFIG
#
# =============================================================================