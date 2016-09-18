#==============================================================================#
#                       * Falcao Pearl ABS Liquid v3                           #
#                                                                              #
# The easiest ABS System for RPG Maker!                                        #
#                                                                              #
# Website: http://falcaorgss.wordpress.com/                                    #
# Foro: www.makerpalace.com                 Release date: December 2 2012      #
#                                           updated: December 13 2012          #
#                                           updated: January 22 2014           #
#                                           updated: April 1 2014              #
#==============================================================================#
=begin
Pearl v3 change log
- Injected Pearl abs path
- Fixed dead posses issue
- Implemented respawn timer for enemies
- Fixed vehicle issue
- Enemies cannot longer attack you while in vehicle
- fixed stuck issue when borading a a vehicle while a follower is deadposing
- added low hp switches for enemies
- Added item quantity to enemy drops
- Fixed enemy touch damage issue
- Fixed custom graphics display issue
  ## New Notetags!##
** Enemies
Enemy Respawn Seconds = x       - Time in seconds the enemy can respawn 
Enemy Respawn Animation = x     - Respawn animation id
Enemy Knockback Disable = true  - Make enemy unable to be knocked back
Enemy Lowhp 75% Switch = x      - when enemy hp is below 75% turn on switch id x
Enemy Lowhp 50% Switch = x      - when enemy hp is below 50% turn on switch id x
Enemy Lowhp 25% Switch = x      - when enemy hp is below 25% turn on switch id x
Enemy Lowhp 10% Switch = x      - when enemy hp is below 10% turn on switch id x
# Enemies characters notetags
now you set up more than one tool at the time for enemies. this will make the
enemies less repetitive, this simple commands work as follows. it pick up one
random tool id from the list each time the command is executed. the list can be
infinite.
rand_skill(x,x,x)        ramdom skill ids the enemy going to use
rand_item(x,x,x)         ramdom item ids the enemy going to use
rand_weapon(x,x,x)       ramdom weapon ids the enemy going to use
rand_armor(x,x,x)        ramdom armor ids the enemy going to use
* Item notetags
Exclude From Tool Menu = true   - Exclude item from tool selection menu
Drop Quantity = x               - Enemy drop item quantity (item, weapon, armor)
--------------------------------------------------------------------------------
##  The Fantastic Pearl ABS Patch injection notetags ##
This options allows you use icons from iconset to perform animations for the 
tools, it is usefull for those peoples who are terrible at creating graphics.
* User and projectiles iconset graphic instructions
 Tag any weapon, armor, item or skill with the followings note tags
User Iconset = animated     - You have 3 options available:
                             animated, static, shielding. animated plays
                             3 patterns swing effect. static plays only one
                             and shielding for shield usage effect
note: User iconsets are compatible with default small sprites form the rmvx ace
engine
Projectile Iconset = animated  - you have 2 options available
                                animated and static.
                                animated play a zoom in and zoom out effect
                                static plays no effect
Note: Projectile iconset can be used with default and big characters
================================================================================
Version liquid v2 change log
 - Anime speed Enchanted
 - New dead poses for actors and enemies
 - Combo feature now support infinite combo chains (rather than 2)
 - Added compatibility with bigger characters actors,
 - New Universal molde provided for bigger characters and normal ones
 - added more configuration to the modules
 - Hp and Mp bars now has the option to display pictures instead script drawing
 - New single player option (disable the M Key and K is used to call tool menu)
 - Added TP display to the damage pop mechanism
 - Fixed minor bug when allowing tool usage while using the shield
 - Added new note tag for actors and enemies, Hit Voices = se, se, se
 - Added new note tag to avoid battler voices when using specific skills
 - added new notetag for enemies, Enemy Dead Pose = true , use it if you want
   the enemy to show the knockdown pattern when die rather than erase it
 - Hidden note tags revealed (read the documentation manual ^^)
 - Added new stage Falcao son (just to show up how to create debasting tools)
 
 Do you already have liquid v1 installed? just remove your old pearl scripts and
 and replece it with liquid v2 (core script remains the same)
 
================================================================================
                           * Manual
 The first thing you need to know is this script uses all the database
 parameters to work, same as the default battle engine with few exemptions
 
 Read this documentation and learn about the great features this script has 
 for a professional game development.
 This script comes with 9 separate script pieces (excluding the documentation)
 You can find some customization modules at the top of each piece.
 
* Installation
 Copy and paste all the script shelf to an empty slot below main
 Export the graphics provided in Character, Animation and pictures folder (few
 graphics provided) Take a look at the database and see what is note tagged,
 export the animations and the tools, exporting the databse is optional but it
 may help you for samples. done!.
 If you are using my FA Interactive system 2.0 make sure you have the lite
 version and paste it ABOVE this sytem
 If you are using my Mouse System buttons script make sure you have the latest
 version. Get the latest version at. http://falcaorgss.wordpress.com/
 If you are using my Pets Servants paste the pet script ABOVE the 10 pieces
* Terms and license
- Do credit me Falcao as the creator of this ABS system
- You can modify anything you want 
- You are allowed to distribute this material in any webpage
- Do not remove the header of any script shelf
- You are free to use this script in non-comercial projects, for comercial
  projects contact me falmc99@gmail.com
* Features
- Full and easy to use ABS engine
- Create any tool from your imagination most easy than ever
- Universal anime graphics, any character can use the graphics including enemies
- Advance Projectile system
- Knockdown feature enable (you give the tool a chance to knockdown a target)
- Tool casting time enabled
- Tool Cooldown enable (the time you have to wait before use the tool again)
- Cooldown coutdown displayed on the toolbar
- Ammo system
- Tool special movements (able to load a moveroute from a common event)
- Tool multiprojectiles enable, you can load upto 8 projectiles at the time
- Bombs, axes, hooshots, magis, shields, boomerangs, anything can be created
- States animation anable (up to 5 icons displayed on map)
- Buffs and debuffs enable (up to 5 icons displayed on map)
- You can assing up to 8 tools to the skillbar (overpowered dont?)
- Input module, default keys are no used by this system
- Area, ranged, spin attacks, target selection  enabled
- Invoke skills for weapon and armors enabled
- Interactive enemies with knockdown, sensor enabled
- Enemies use any tool that the player or follower does
- Enemy battler enabled, so you decide if you want display the battler graphic
- Enemies are able to heal themselfs, have allies enemies etc
- Enemy die commands, collapse animations etc.
- Party system! your followers have a command to start figting
- Followers are able to heal allies, player etc
- Smart targeting system, followers choose an individual enemy to attack
- Agro system, followers and player have a chance to get the agro of the enemy
- Token system (you tag any event to start when was hit by a tool)
- Tool targeting system, autotarget, etc
- Player selection scene enabled
- Quick skill bar enabled
- Item pop up enabled
- Antilag enabled
- Lag free
- Summon system. you can command the tool to use tools by using a common event
  move route as manager action.
- Enemies states, buff and debuff display
- Combo system for the tools ( you can create an epic combo chain)
- Mouse support! you can trigger tools by cliking the skillbar icons!
* I didnt mention all the features this script comes with, find the rest by 
yourself
                      
                      -----------------------
                      * Things you need to know
                      
What is a knockdown? Knockdown is a parameters included with this system, 
tools have a chance to knock an enemy down, if an user is casting a spell
the knockdown can interrupt it, and also stop the movement for few frames, 
the knock down needs a graphic to make the effect, the RTP comes with tons
of knockdownned sprites use them or create your owns with the generator
What is Agro? agro is a parameter of Pearl abs, when the player or follower hit
an enemy they provoke the enemy to attack them, the player by default has more
agro than followers. Its is more probably that enemies attacks the player
                      
The followers can use only one tool while in battle, why? becouse you dont want
to win all the battles, just imagine your folllowers using all theirs tools, 
that will be overpowered, the player has eight tools right in the skill bar so..
There is a menu in game where you decide which tool slot use as a follower
Benefical items and skills can be used without any note tags, meaning
that you can use them freely, benefical tools are those who have
scopes for one ally, all allies, dead allies etc. apply to enemies too
Weapons and armors needs the note tag system to work since they dont have
scopes. is they are not note tagged simple you will not able to use them in map
Enemies can use weapons armors and items too. ammo system is infinite for enemie
since they are suppose to have their own munition wallet. Weapon parameters 
apply to enemies when use it but features are ignored
You can convert a weapon and armor to a skill using the Invoke skill feature
meaning that you will use the weapon but with the properies of the invoked skill
This script is completely free of lag, it have a well worked optimized kernel
but do not abuse and use everything with moderation.
#===============================================================================
                          * Actors  Notetags
                          
Knockdown Graphic = Damage3        - Knockdown graphic
Knockdown Index = 6                - Graphic index
Knockdown pattern = 0              - Graphic pattern
Knockdown Direction = 2            - Graphic direction
The example above shows Ericks knockdown graphic set up, you can leave it blank
but, it is better to have a knock down graphic in order to make the effect work
Battler Voices = se, se, se        - If you want to play actor voices when attac
                                     puts se files name separate by commas
                                     
Hit Voices = se, se, se            - Do you want to play voices when was hit?
                                     replace se with the sound file name
#===============================================================================
                             * Enemies
                          
To create an enemy first create an event then in the name box writte
<enemy: x>       - Change x for the enemy id in the database
There are 3 types of events enemies you can create in Pearl ABS
Type one BASIC:
Just tag the event name as enemy and there you go
Type two SENSORIAL
This type needs a second event page as a condition the self switch 'B' on
When the player is near the enemy, the enemy will activate that self switch and
there you can give the enemy attacks etc
Type three ACTION
This include the basic and sensorial, but requireds a third page to show up the
Knockdown graphic or whatever ir order to make the knockdown to make effect.
At third page put as condition Self switch 'C' by default
See game demo for examples, the most used is the Type ACTION 
How to commands enemies to attack?
It is very simple, From the event enemy 'Autonomous Movement' use the
followings mini script calls.
use_weapon(x)
use_armor(x)
use_item(x)
use_skill(x)
Change x for the tool id
                    ---------------------------------
                     * Enemies Notetags (in databse)
First thing to know is enemies notetags in the database are optional, this note
tags are used for some extra customization in the enemies.
Enemy Touch Damage Range = x  - If you want the enemy to damage actor by contact
                                use this tag, change x for the distance in tiles
Enemy Sensor = x              - Distance in tiles the enemy can see the player, 
                                the default value is 6
Enemy Object = true           - The enemy becomes an object, damage pop is no 
                                showed, and some features has been disable
                                this is used to create enemies like traps or,
                                objects like grass where you can get some drop
Enemy Boss Bar = true         - This make the enemy to display a big boss HP bar
Enemy Battler = true          - Do you want the enemy to show battler graphic?
Enemy Breath = true           - Do you want the enemy to breath?
Enemy Die Animation = x       - Change x for animation id
Enemy Kill With Weapon = a,b,c - The enemy becomes invulnerable for all tools an
                                can be killed only by the given tool ids, you
                                can puts all the ids you want separated by comma
Enemy Kill With Armor = a,b,c  - Samething than weapons
Enemy Kill With Item = a,b,c   - Samething than weapons
Enemy Kill With Skill = a,b,c  - Samething than weapons
Enemy Collapse Type = x        - Change x for one of this 4 options available
                                 zoom_vertical
                                 zoom_horizontal
                                 zoom_maximize
                                 zoom_minimize
                                 
Enemy Body Increase x      - By default all enemies has 1 tile of size but that
                            can be changed with this command, you have only two
                            sizes available, 1 = increase doble, 2 = triple.
                            change x for 1 or 2. (this is used for big enemies)
                           
Enemy Die Switch = x       - Change x for switch id to activate when enemy die
Enemy Die Variable = x     - Change x for variable id you want to increase + 1
                             when enemy die
Enemy Die Self Switch x    - Change x for the self switch capital letter you
                             want to activate when enemy die
                                 
Hit Jump = false                 Disable enemy jump when was hit 
Battler Voices = se, se, se       - If you want to play enemy voices when attack
                                    puts se files name separate by commas
                                    
Enemy Dead Pose = true      - Do you want the enemy to display the knockdown
                            graphic when die? this is the dead pose and it only
                            work when a knockdown graphic is defined
                            
Hit Voices = se, se, se            - Do you want to play voices when was hit?
                                     replace se with the sound file name
                                     
Enemy Die Transform = x      - Do you want to transform the enemy when die?
                             change x for the enemy id
                                 
================================================================================
                         * States, buffs and debuffs
States notetags are optional, few changes has been made listed below.
State Animation = x            - State animation id
State Effect Rand Rate = x     - This apply only for HP, MP and TP regen Exparam
                                this calculate how often the state will affect
                                the target. change x for a number between 100
                                and 1000.
How states are removed? 
As you know this is an ABS system NOT turn battle system, to remove the states
check the boxes 'Remove by Damage' or 'Remove by Walking' in the databse
If you choose remove by walking the steps will be equal to seconds, 10 steps 
equal to 10 seconds of duration, doesnt matter if the target is moving or not
* Buffs and Debuffs
If you create a skill that gives buffs or debuffs, the turns stated in databse
will be equal to seconds of duration, 10 turns equal to 10 seconds
================================================================================
                          - Events Tags
* Token tags
This tags goes into event comment and are mostly used for normal events to
create some puzzles.
<start_with_weapon: a,b,c>
<start_with_armor: a,b,c>       - Puts tool ids you want the event to start with
<start_with_item: a,b,c>          you can put as many ids needed
<start_with_skill: a,b,c>
* Hookshot tags
This tags are used with the hookshot special tools, here some options available
<hook_grab: true>         - The hook can grab this event           
<hook_pull: true>         - The hook will pull the user from x to event position
* Boomerang tags
<boom_grab: true>         - The event can be grabbed by the boomerang
<boomed_start: true>      - The event start when you succes grabbed the event
Note: Boomerangs can grab drops automatically
================================================================================
                          * Pearl ABS Input System
                          
Pearl ABS Skillbar has 9 buttons available, here the list of the default ones
 - F key       trigger weapons attacks
 - G key       trigger armor tool (shields types)
 - H, J        trigger items tools
 - R, T, Y, U  trigger skill attacks
 - K           trigger follower attacks, keep pressing for 3 seconds to cancel
               the battle
               
Note: the Player is reponsible for command the followers to attack, sometimes
the followers stop fighting when his target dies, you are responsible to 
command the follower to attack again.
 - N key       call the quick tool selection window
 - M key       call the Player selection window, there you set up the follower
               tool slot usage too.
 - B key       Same as cancel key X
================================================================================
                          * Useful script calls
- $game_party.set_item(actor, item, slot)
  Use this command if you want to set automatically an item to the skillbar
  change actor for actor id, item for item id, slot for the slot name symbol
  Exp: $game_party.set_item(1, 20, :H)
  
- $game_party.set_skill(actor, skill, slot)  - samething as items
- SceneManager.call(Scene_QuickTool)    - call the quick tool window manually
- SceneManager.call(Scene_CharacterSet) - call the player slection manually
- $game_player.pop_damage('something')  - display pop text over the player
- $game_map.events[id].pop_damage('')   - display pop text over the event id
                          
================================================================================
                          * Tools Notetags
                                   
Tools are the weapon, armor, items and skills used in the map to damage enemies
Here i going to explain you how to create your own tools to be used on map, and
the explanation of each term definition, The example below how to create a 
usable Axe on map.
Copy this tool settings to any Weapon, Armor, Item, Skill note tags
User Graphic = $Axe
User Anime Speed = 30
Tool Cooldown = 30
Tool Graphic = nil
Tool Index = 0
Tool Size = 1
Tool Distance = 1
Tool Effect Delay = 10
Tool Destroy Delay = 20
Tool Speed = 5
Tool Cast Time = 0
Tool Cast Animation = 0
Tool Blow Power = 1
Tool Piercing = true
Tool Animation When = end
Tool Animation Repeat = false
Tool Special = nil
Tool Target = false
Tool Invoke Skill = 0
Tool Guard Rate = 0
Tool Knockdown Rate = 70
Tool Sound Se = nil
Tool Cooldown Display = false
Tool Item Cost = 0
Tool Short Jump = false
Tool Through = true
Tool Priority = 1
Tool Hit Shake = false
Tool Self Damage = false
Tool Combo Tool = nil
Important!: You CANNOT leave extra empty spaces between the tool variables
definition, just copy and paste that variables to the note tags and edit values
Here the terms explanation
User Graphic = $Axe
- This define the user graphic displayed when the tool is used, if you dont want
  to show graphic puts nil. If you want to show a COSTUMED graphic for the user
  writte the keyword   custom then graphic name ex: custom $Hero_Skill
User Anime Speed = 30
- This define the user graphic animation speed when using the tool, the user
  stop movemnet and do step anime, time in frames
  
Tool Cooldown = 30
- Cooldown is the time you have to wait before using the tool, this gives
  balance to the tool system, time measured in frames
  
Tool Graphic = nil
- This define the tool graphic projectile showed when using the tool, in this
  case no graphic will be displayed, puts nil for not graphic showing
Tool Index = 0
- This defines graphic index of the tool graphic, so you can use a full sheet.
  and set the index of the used graphic
  
Tool Size = 1
- This defines the tool size measured in tiles, this tool has 1 tile size,
  Set greater numbers when you create big tools or area attacks
Tool Distance = 1
- This is the distance the projectile going to do, distance is measured in tiles
  this tools has only 1 tile of trajectory.
  
Tool Effect Delay = 10
- How long the tool going to take to make effect over a target? time measured in
  frames, tools such as bombs take a longer time to make effect so...
  
Tool Destroy Delay = 20
- How long the tool going to take to be destroyed? the time start counting when 
  the tool distance is done, time measured in tiles.
  
Tool Speed = 5
- This defines the tool movement speed, choose a number between 1 to 6
  remeber that tools are represented by a character.
  
Tool Cast Time = 0
- This defines the Tools casting time, time measured in frames, this tool has
  not casting time, puts 0 for not casting time
  
Tool Cast Animation = 0
- Animation played when casting the tool, this is displayed if there is cas time
  obviously, change integer for the animation id
  
Tool Blow Power = 1
- This defines the target steps backwars when was hit by the tool, change the
  integer for tiles distance
Tool Piercing = true
- The tool going to pierce the enemy? change true or false
Tool Animation When = end
- This defines when the animation going to be played, you have 4 options
       end      - Animation is played righ before destroyed
       acting   - Animation is played when the tool is used
       hit      - Animation is played when hit the target
       delay x  - Animation is played when the tool detroy delay reachs
                  the x integer, for example, a bomb display the animation after
                  some delay before the tools is detroyed. change x for a number
Tool Animation Repeat = false
- This defines whether the animation going to be repeated, this only works
  if you set the animation to be played when 'acting'
Tool Special = nil
- This define tool special predefined behavior, you have 11 options available
  shield         - The tool behave like a shield, this works for tagged armors
                   and the state guard is applied to the user, when using it
  hook           - The tools set the hookshot mode, hook can, grab, pull etc.
  area           - Tool become an area atack around the caster, or target
  spiral         - The tool become spiral attack, the user going to make some
                   rounds, the number on rounds is equal to the Tool Distance
  boomerang      - Tool becomes a boomerang, boomerang can grab drops, tagged
                   events, and can be redirectioned with the input keys
  triple         - Loads 3 projectiles at the time, 2 diagonals and 1 straigh
  quintuple      - Loads 5 projectiles at the time, 2 diagonals, 2 cross and
                   one straight forward
  octuple        - Loads 8 projectiles in all direction including diagonals
  autotarget     - The tool move straight and looks for a random target 
                   near the user
  random         - Tool moves 2 steps forward and them make random movements
  common_event x - This is one of the most powerfull features of Pearl ABS
                   this extract the move route from a common event to be used
                   by the tool, everything you delcare in the move route will
                   affect the tool, you can use the attack script calls inside
                   the move route. (used to create tools such as summons)
                   change x for the common event id
                   
     
     Note: Tool special take some default values, for example the tool distance
     is reseted, tool targeting may be disabled, destroy delay reseted etc.
Tool Target = false
- This defines if the tool needs a target to be triggered, A scene selection is
  showed for the player, the followers picks a random target, enemies takes agro
  
Tool Invoke Skill = 0
- Deafault battle system for weapons invoke skill 1,for defending invoke skill 2
  So Pearl abs lets you invoke any skill when using a weapon or armor. 
  set 0 if you want to take the defaults, skills and items invoke themself so...
Tool Guard Rate = 0
- This only work for armors tagged with tool special 'shield', this define
  the rate of guard of the shield, puts a number between 1 and 100
  when gaurd succes the user takes no damage, otherwise, take block damage
    
Tool Knockdown Rate = 70
- This is a great feature of pearl abs, tools are able to knock the target down
  for a short time in order to cancel casting spells etc, puts a number
  between 1 and 100
Tool Sound Se = nil
- Sound SE played when using the tool, if you dont want sounds puts nil
Tool Cooldown Display = false
- The cool down time is displayed on the skillbar when using a tool
  puts false if you dont want to display the cooldown
  
Tool Item Cost = 0
- This is the Pearl ABS ammo system, every single armor, weapon, item skills can
  have an item cost, puts the item id the tools needs to be triggered
  this is used to create tools likes, bows that consume arrows, bombs etc.
  
Tool Short Jump = false
- The tool going to guve a shor jump when triggered, change true or false
Tool Through = true
- Tools go through walls, trees, rocks etc?
Tool Priority = 1
- Priority of the tool,  0 = below characters, 1 = same as characters, 
  2 = above characters
  
Tool Hit Shake = false
- Do you want the screen to shake when the tool hit a target? true / false
Tool Self Damage = false
- Do you want the tool to damage the user? (example bombs can have self damage)
Tool Combo Tool = nil
- tools can have a combo chain, this tool has not a combo cuz is defined to nil
  if you want to make combos you have to put this parameters to define it
  type, id, chance, jump? . type is tool type: weapon, armor, item or skill
  id is the tool id, chance must be a number between 1 and 100, write jump if
  you want the user to jump if you dont want to jump writte nil
  here an example:  weapon, 63, 75, jump
  uses weapon id 63 with a 75% chance and a jump will be performed (simple)
  
* Optionals tools notetags
  <ignore_voices>        When using the tool no battler voices are played
  <ignore_followers>     The tool ignore damage to the followers
  
================================================================================
=end
